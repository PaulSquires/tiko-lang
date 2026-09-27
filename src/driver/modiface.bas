'' modiface.bas -- a module's interface, read into the units that import it (ADR 0017;
'' RFC-0002 §2, RFC-0004 §4-5).
''
'' EACH MODULE OF THE BUILD, once compiled, leaves its interface behind as a source file
'' held in memory (tkiemit.bas writes it). An '#import' then reads that file in where it
'' stands -- and before it the interface of every module it depends on, dependencies
'' first and each once: the interface names its own imports' types by their namespaces,
'' so those have to be declared already.
''
'' THE INTERFACE IS A NAMESPACE, '__tko_mod_acme_net_http', that nothing written in source
'' names. The '#import' binds its alias -- 'http', or what 'as' says -- to the same scope,
'' so 'http.Fetch( )' and 'using http' work as they do for any namespace; and the mangler
'' writes the module's chain where the namespace would go, so the importer's 'Fetch' is
'' the symbol the module defined.
''
'' NOT YET: an alias is the whole unit's rather than its file's (M22), and a name the
'' interface does not call 'public' is found as readily as one it does.

#include once "driver/modiface.bi"
#include once "driver/modresolve.bi"
#include once "driver/tkiemit.bi"
#include once "symbols/modsym.bi"
#include once "support/text.bi"

namespace Tko.Modules

private function InUnit_( byref ctx as Tko.CompilerContext, byval f as Tko.FileId ) as boolean
    for each m as ulong in ctx.modFiles
        if m = cast( ulong, f ) then return true
    next
    return false
end function

function ImportIndex( byref ctx as Tko.CompilerContext, byref rec as Tko.PpImport ) as long
    if ctx.ifaceChains.Count = 0 then return -1
    dim as Tko.FileId f = ctx.sources.Decode( rec.loc ).file
    dim as string fromDir = DirOfFile( ctx.sources.PathOf( f ) )
    '' Read from a module's file, in the module's package; from a root, in the roots'.
    dim as string pn, pr
    RootPackage( ctx, pn, pr )
    if InUnit_( ctx, f ) then
        pn = ctx.modPkgName
        pr = ctx.modPkgRoot
    end if
    dim as ModWhere w
    if ResolveImport( ctx, rec, fromDir, pn, pr, w ) = false then return -1
    for i as long = 0 to ctx.ifaceChains.Count - 1
        if ctx.ifaceChains[i] = w.chain then return i
    next
    return -1
end function

'' Module n's interface, after every one it depends on.
private sub Closure_ _
    ( byref ctx as Tko.CompilerContext, byval n as long, byref seen as FB.Array( of ubyte ), _
      byref files as Tko.FileIdVec )
    if seen[n] <> 0 then return
    seen[n] = 1
    for e as long = 0 to ctx.ifaceEdgeFrom.Count - 1
        if cast( long, ctx.ifaceEdgeFrom[e] ) = n then
            Closure_( ctx, cast( long, ctx.ifaceEdgeTo[e] ), seen, files )
        end if
    next
    if ctx.ifaceFiles[n] <> cast( ulong, Tko.FILE_NONE ) then files.Push( ctx.ifaceFiles[n] )
end sub

private function Hook_ _
    ( byval c as any ptr, byref rec as Tko.PpImport, byref files as Tko.FileIdVec, _
      byref chain as string ) as boolean
    dim as Tko.CompilerContext ptr ctx = cast( Tko.CompilerContext ptr, c )
    dim as long n = ImportIndex( *ctx, rec )
    if n < 0 then return false
    chain = ctx->ifaceChains[n]
    dim as FB.Array( of ubyte ) seen
    for i as long = 0 to ctx->ifaceChains.Count - 1
        seen.Push( 0 )
    next
    Closure_( *ctx, n, seen, files )
    return true
end function

sub InstallImports( byref ctx as Tko.CompilerContext, byref cfg as Tko.PpConfig )
    cfg.importCtx = @ctx
    cfg.importFn = @Hook_
end sub

private function Folded_( byref ctx as Tko.CompilerContext, byref s as string ) as Tko.InternId
    return ctx.names.Fold( ctx.names.GetString( s ) )
end function

'' AN ALIAS SHARES ITS MODULE'S SCOPE: 'http.X', 'using http' and 'http.T' as a type all work
'' as for any namespace. The mangler never sees it: the scope's owner is the module's own.
private sub BindView_ _
    ( byref syms as Tko.SymbolTable, byval asid as Tko.SymbolId, byval nsSid as ulong, _
      byval parent as Tko.ScopeId )
    dim as Tko.Symbol ptr a = syms.SymbolAt( asid )
    dim as Tko.Symbol ptr ns = syms.SymbolAt( cast( Tko.SymbolId, nsSid ) )
    if (a = 0) orelse (ns = 0) then return
    a->inner = ns->inner
end sub

'' A MODULE'S RE-EXPORTS (RFC-0002 §6), from its interface's '' reexport <alias> <chain>
'' lines: each alias, a view of that module, declared public inside the module's own
'' namespace -- 'http.esc.Url'.
private sub BindReexports_ _
    ( byref ctx as Tko.CompilerContext, byref syms as Tko.SymbolTable, _
      byref nsOf as FB.Array( of ulong ) )
    for n as long = 0 to ctx.ifaceChains.Count - 1
        if nsOf[n] = 0 then continue for
        dim as string t = ctx.ifaceTexts[n]
        dim as long p = 1
        while p <= len( t )
            dim as long e = instr( p, t, chr( 10 ) )
            if e = 0 then e = len( t ) + 1
            dim as string ln = mid( t, p, e - p )
            p = e + 1
            if left( ln, 2 ) <> "''" then exit while
            if left( ln, 12 ) <> "'' reexport " then continue while
            dim as string rest = mid( ln, 13 )
            dim as long sp = instr( rest, " " )
            if sp = 0 then continue while
            dim as string al = left( rest, sp - 1 )
            dim as string ch = mid( rest, sp + 1 )
            dim as long m = -1
            for i as long = 0 to ctx.ifaceChains.Count - 1
                if ctx.ifaceChains[i] = ch then m = i
            next
            if m < 0 then continue while
            if nsOf[m] = 0 then continue while
            dim as Tko.Symbol ptr host = syms.SymbolAt( cast( Tko.SymbolId, nsOf[n] ) )
            if host = 0 then continue while
            dim as Tko.ScopeId hs = host->inner
            dim as boolean dup = false
            dim as Tko.SymbolId rsid = syms.DeclareSym( hs, Folded_( ctx, al ), Tko.SYM_NAMESPACE, _
                                                        Tko.LOC_NONE, dup )
            if dup then continue while
            BindView_( syms, rsid, nsOf[m], hs )
        wend
    next
end sub

sub BindImports _
    ( byref ctx as Tko.CompilerContext, byref ast as Tko.AstArena, _
      byref syms as Tko.SymbolTable, byref info as Tko.SemanticInfo, _
      byref imports as Tko.PpImportVec )

    if ctx.ifaceChains.Count = 0 then return
    dim as Tko.ScopeId modScope = Tko.ModSym.ModuleScope( syms )

    '' Each interface this unit read: its namespace, for the mangler.
    dim as FB.Array( of ulong ) nsOf       '' by module index: the namespace symbol, or 0
    dim as Tko.FileIdVec read_
    for i as long = 0 to ctx.ifaceChains.Count - 1
        nsOf.Push( 0 )
        if ctx.ifaceFiles[i] = cast( ulong, Tko.FILE_NONE ) then continue for
        read_.Push( ctx.ifaceFiles[i] )
        dim as Tko.SymbolId sid = syms.LookupLocal( modScope, _
            Folded_( ctx, InterfaceNamespace( ctx.ifaceChains[i] ) ) )
        dim as Tko.Symbol ptr s = syms.SymbolAt( sid )
        while (s <> 0) andalso (s->kind <> cast( ubyte, Tko.SYM_NAMESPACE ))
            sid = s->altClass
            s = syms.SymbolAt( sid )
        wend
        if s = 0 then continue for
        nsOf[i] = cast( ulong, sid )
        syms.importNs.Push( cast( ulong, sid ) )
        syms.importChains.Push( Tko.Text.UpperAscii( ctx.ifaceChains[i] ) )
    next
    Tko.ModSym.MarkImported( ast, syms, info, ctx.sources, read_ )
    BindReexports_( ctx, syms, nsOf )

    '' Each '#import''s alias, bound to its module's scope.
    dim as FB.Array( of ulong ) aliasSym, aliasMod, aliasRec
    for k as long = 0 to imports.Count - 1
        dim as long n = ImportIndex( ctx, imports[k] )
        if n < 0 then continue for
        if nsOf[n] = 0 then continue for
        dim as Tko.InternId an = Folded_( ctx, imports[k].alias_ )
        dim as boolean dup = false
        dim as Tko.SymbolId asid = syms.DeclareSym( modScope, an, Tko.SYM_NAMESPACE, imports[k].loc, dup )
        if dup then
            dim as long mine = -1
            for q as long = 0 to aliasSym.Count - 1
                if aliasSym[q] = cast( ulong, asid ) then mine = q
            next
            if mine < 0 then
                ctx.diags.Report( Tko.TKO0863, Tko.PointRange( imports[k].loc ), imports[k].alias_ )
            elseif aliasMod[mine] <> cast( ulong, n ) then
                ctx.diags.Report( Tko.TKO0862, Tko.PointRange( imports[k].loc ), _
                                  imports[k].alias_, imports[aliasRec[mine]].path )
            end if
            continue for
        end if
        BindView_( syms, asid, nsOf[n], modScope )
        aliasSym.Push( cast( ulong, asid ) )
        aliasMod.Push( cast( ulong, n ) )
        aliasRec.Push( cast( ulong, k ) )
    next
end sub

sub InitOrder( byref ctx as Tko.CompilerContext, byref outv as Tko.StrVec )
    outv.Clear( )
    dim as long self_ = -1
    if ctx.modFileCount > 0 then
        for i as long = 0 to ctx.ifaceChains.Count - 1
            if ctx.ifaceChains[i] = ctx.modChain then self_ = i
        next
        if self_ < 0 then return
    end if
    for each o as ulong in ctx.ifaceOrder
        dim as boolean wanted = (self_ < 0)
        if wanted = false then
            for e as long = 0 to ctx.ifaceEdgeFrom.Count - 1
                dim as boolean hit = (cast( long, ctx.ifaceEdgeFrom[e] ) = self_)
                if hit then hit = (ctx.ifaceEdgeTo[e] = o)
                if hit then wanted = true
            next
        end if
        if wanted then outv.Push( ctx.ifaceChains[o] )
    next
end sub

sub PublishInterface _
    ( byref ctx as Tko.CompilerContext, byref pr as Tko.PpResult, _
      byref ast as Tko.AstArena, byref syms as Tko.SymbolTable, _
      byref info as Tko.SemanticInfo )

    dim as long self_ = -1
    for i as long = 0 to ctx.ifaceChains.Count - 1
        if ctx.ifaceChains[i] = ctx.modChain then self_ = i
    next
    if self_ < 0 then return
    '' The namespaces of the module's own imports, for the names its interface spells
    '' through their aliases.
    dim as Tko.StrVec aliases, spaces
    for k as long = 0 to pr.imports.Count - 1
        dim as long n = ImportIndex( ctx, pr.imports[k] )
        if n < 0 then continue for
        aliases.Push( Tko.Text.LowerAscii( pr.imports[k].alias_ ) )
        spaces.Push( InterfaceNamespace( ctx.ifaceChains[n] ) )
    next
    dim as string text_ = WriteInterface( ctx, pr.tokens, ast, syms, info, aliases, spaces, _
                                          pr.modHeaders, @pr )
    '' ...and what it re-exports, in the header (RFC-0002 §6): '' reexport <alias> <chain>.
    dim as string rx = ""
    for k as long = 0 to pr.imports.Count - 1
        if pr.imports[k].isPublic = false then continue for
        dim as long n = ImportIndex( ctx, pr.imports[k] )
        if n < 0 then continue for
        rx &= "'' reexport " & Tko.Text.LowerAscii( pr.imports[k].alias_ ) & " " & ctx.ifaceChains[n] & chr( 10 )
    next
    if len( rx ) > 0 then
        dim as long l2 = instr( instr( text_, chr( 10 ) ) + 1, text_, chr( 10 ) )
        text_ = left( text_, l2 ) & rx & mid( text_, l2 + 1 )
    end if
    dim as Tko.FileId id = ctx.sources.AddVirtual( ctx.modChain & ".tki", text_ )
    ctx.ifaceFiles[self_] = cast( ulong, id )
    ctx.ifaceTexts[self_] = text_
end sub

end namespace
