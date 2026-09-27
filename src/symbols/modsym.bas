'' modsym.bas -- which symbols are module code, and what a module lets out (ADR 0017;
'' RFC-0002 §3-4).
''
'' MODULE CODE is decided by WHERE A NAME IS DECLARED: at module level, or in a namespace at
'' module level, in one of the unit's own files. A header the module includes -- windows.bi
'' -- is not module code: its names keep their classic link names, which is what lets them
'' mean the same thing to every unit of the program. A declaration a header's MACRO writes
'' into a module file carries the header's location, and is classic too.
''
'' THE WORDS WRITTEN are read off the declarations, where the parser left them
'' (PF_VIS_PUBLIC, PF_VIS_PRIVATE), and put on every symbol of that name in that scope: an
'' overload set is one name, and 'public declare' above a plain definition makes the
'' definition public.

#include once "symbols/modsym.bi"
#include once "support/text.bi"

namespace Tko.ModSym

sub Begin _
    ( byref syms as Tko.SymbolTable, byval fileCount as long, byref chain as string )

    syms.modFileCount = fileCount
    syms.selfChain.Clear( )
    dim as long st = 1
    do
        dim as long dt = instr( st, chain, "." )
        dim as string one_ = iif( dt = 0, mid( chain, st ), mid( chain, st, dt - st ) )
        if len( one_ ) > 0 then syms.selfChain.Push( Tko.Text.UpperAscii( one_ ) )
        if dt = 0 then exit do
        st = dt + 1
    loop
end sub

'' At module level: the MODULE scope, through any number of namespaces and nothing else.
private function ModuleLevel_( byref syms as Tko.SymbolTable, byval sc as Tko.ScopeId ) as boolean
    dim as Tko.ScopeId cur = sc
    while cur <> Tko.SCOPE_NONE
        dim as Tko.SymScope ptr s = syms.ScopeAt( cur )
        if s = 0 then return false
        if s->kind = cast( ubyte, Tko.SCOPEK_MODULE ) then return true
        if s->kind <> cast( ubyte, Tko.SCOPEK_NAMESPACE ) then return false
        cur = s->parent
    wend
    return false
end function

private function InUnit_ _
    ( byref syms as Tko.SymbolTable, byref src as Tko.SourceManager, _
      byval loc as Tko.SourceLoc ) as boolean
    if loc = Tko.LOC_NONE then return false
    dim as long f = cast( long, src.Decode( loc ).file )
    return (f >= 1) andalso (f <= syms.modFileCount)
end function

private sub MarkNamed_ _
    ( byref syms as Tko.SymbolTable, byval sc as Tko.ScopeId, byval nm as Tko.InternId, _
      byval f as ulong )
    if nm = 0 then return
    for si as long = 1 to syms.Count( )
        dim as Tko.Symbol ptr s = syms.SymbolAt( cast( Tko.SymbolId, si ) )
        if s = 0 then continue for
        if (s->parent = sc) andalso (s->name = nm) then s->flags or= f
    next
end sub

sub Mark _
    ( byref ast as Tko.AstArena, byref syms as Tko.SymbolTable, _
      byref info as Tko.SemanticInfo, byref src as Tko.SourceManager, _
      byref diags as Tko.DiagnosticEngine )

    if syms.modFileCount = 0 then return

    for si as long = 1 to syms.Count( )
        dim as Tko.Symbol ptr s = syms.SymbolAt( cast( Tko.SymbolId, si ) )
        if s = 0 then continue for
        if ModuleLevel_( syms, s->parent ) = false then continue for
        if InUnit_( syms, src, s->loc ) = false then continue for
        s->flags or= Tko.SYMF_MODSRC
        '' 'common' SHARES STORAGE BY SPELLING across units, which is the coupling modules
        '' replace (RFC-0003 §4).
        if (s->flags and Tko.SYMF_COMMON) <> 0 then
            diags.Report( Tko.TKO0366, Tko.PointRange( s->loc ), "'common'" )
        end if
    next

    for n as long = 1 to ast.Count( )
        dim as Tko.NodeId id = cast( Tko.NodeId, n )
        dim as Tko.NodeKind k = ast.Kind( id )
        select case k
        case Tko.N_PROC, Tko.N_VAR, Tko.N_CONST, Tko.N_TYPE, Tko.N_ENUM, Tko.N_TYPEDEF, _
             Tko.N_NAMESPACE
        case else
            continue for
        end select
        dim as Tko.StmtPayload ptr sp = @ast.stmts[cast( long, ast.nodes[n].data )]
        dim as ulong vis = sp->extra and (Tko.PF_VIS_PUBLIC or Tko.PF_VIS_PRIVATE)
        if vis = 0 then continue for
        dim as ulong f = iif( (vis and Tko.PF_VIS_PUBLIC) <> 0, Tko.SYMF_PUBLIC, Tko.SYMF_PRIVDECL )
        '' A NODE THAT OPENS A SCOPE -- a procedure, a type, a namespace -- records the one it
        '' opens (collect.bas), and its name is declared in the one around it: the scope
        '' whose owner is the node's own name steps out once.
        dim as Tko.ScopeId sc = info.ScopeOf( id )
        dim as Tko.SymScope ptr os = syms.ScopeAt( sc )
        if os <> 0 then
            dim as Tko.Symbol ptr ow = syms.SymbolAt( os->owner )
            if ow <> 0 then
                if ow->name = sp->name then sc = os->parent
            end if
        end if
        if ModuleLevel_( syms, sc ) = false then continue for
        if (k = Tko.N_VAR) orelse (k = Tko.N_CONST) then
            for i as long = 0 to sp->count - 1
                dim as Tko.NodeId item = cast( Tko.NodeId, ast.children[sp->first + i] )
                if ast.Kind( item ) <> Tko.N_VAR_ITEM then continue for
                MarkNamed_( syms, sc, ast.stmts[cast( long, ast.nodes[cast( long, item )].data )].name, f )
            next
        else
            MarkNamed_( syms, sc, sp->name, f )
        end if
    next
end sub

sub Inherit( byref syms as Tko.SymbolTable, byval sid as Tko.SymbolId, byval from as Tko.SymbolId )
    dim as Tko.Symbol ptr s = syms.SymbolAt( sid )
    dim as Tko.Symbol ptr f = syms.SymbolAt( from )
    if (s = 0) orelse (f = 0) then return
    s->flags or= (f->flags and Tko.SYMF_MODMASK)
end sub

sub ProcLinkage _
    ( byref syms as Tko.SymbolTable, byval sid as Tko.SymbolId, _
      byref isPrivate as boolean, byref isExported as boolean, byref isHidden as boolean )

    dim as Tko.Symbol ptr s = syms.SymbolAt( sid )
    if s = 0 then return
    '' A MEMBER TAKES ITS TYPE'S VISIBILITY: a public type's methods are public, and a
    '' module-private type's hidden. 'private:' sections are access, not linkage.
    if (s->flags and Tko.SYMF_MODSRC) = 0 then
        dim as Tko.SymScope ptr ps = syms.ScopeAt( s->parent )
        if ps = 0 then return
        if ps->kind <> cast( ubyte, Tko.SCOPEK_TYPE ) then return
        s = syms.SymbolAt( ps->owner )
        if s = 0 then return
        if (s->flags and Tko.SYMF_MODSRC) = 0 then return
    end if
    if isPrivate then return
    if (s->flags and Tko.SYMF_PRIVDECL) <> 0 then
        isPrivate = true
        return
    end if
    if (s->flags and Tko.SYMF_PUBLIC) <> 0 then return
    isHidden = true
    isExported = false
end sub

end namespace
