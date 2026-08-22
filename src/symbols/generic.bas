'' generic.bas -- instantiating a generic TYPE.
''
'' Split out of resolve.bas, which is at its size limit.

#include once "symbols/resolvectx.bi"
#include once "symbols/check.bi"
#include once "symbols/collect.bi"
#include once "parser/parser.bi"

namespace Fbx.Resolve

declare sub InstantiateMembers_ _
    ( byref c as Ctx, byval gnode as Fbx.NodeId, byval gname as Fbx.InternId, _
      byval inm as Fbx.InternId, byval iin as Fbx.ScopeId, byval scope_ as Fbx.ScopeId, _
      byval argFirst as long, byval argCount as long )

'' INSTANTIATE A GENERIC TYPE -- 'Box( of long )'.
''
'' Monomorphisation, the same thing fbc does: one concrete UDT per (generic, argument
'' list), built in the GLOBAL scope and cached under a structural key. fbc emits every
'' instantiation 'static' into the module that needs it, so there is nothing to share
'' across translation units and nothing lost by doing it per-module.
''
'' This is the TYPE half only. Members are not instantiated -- their bodies need a
'' token replay, which is a separate job -- so a method call on one still declines.
'' What this fixes is the FIELDS: every instantiation used to resolve to the generic's
'' own fieldless UDT of SIZE ZERO, so 'b.value = 1' had nowhere to store and 'dim as
'' Array( of Decimal ) a' reserved nothing.
''
'' Built on the same three steps as the TUPLE desugaring above -- declare a symbol in
'' SCOPE_GLOBAL under a structural name, open its TYPE scope, declare the fields with
'' resolved types -- because it is the same problem: a type that the source names
'' structurally rather than by a declaration of its own.
function InstantiateGeneric_ _
    ( byref c as Ctx, byval id as Fbx.NodeId, byval sp as Fbx.StmtPayload ptr, _
      byval scope_ as Fbx.ScopeId ) as Fbx.TypeId

    '' The generic itself. Not through LookupTyped's type filter alone: it has to be a
    '' UDT whose declaration carries a parameter list, or 'Foo( 3 )' on an ordinary
    '' type would be read as an instantiation.
    dim as Fbx.SymbolId gsid = c.syms->LookupTyped( scope_, sp->name, true )
    dim as Fbx.Symbol ptr gs = c.syms->SymbolAt( gsid )
    if gs = 0 then return Fbx.TYPE_NONE
    if gs->kind <> cast( ubyte, Fbx.SYM_UDT ) then return Fbx.TYPE_NONE
    dim as Fbx.NodeId gn = cast( Fbx.NodeId, gs->payload )
    if gn = Fbx.NODE_NONE then return Fbx.TYPE_NONE
    if c.ast->Kind( gn ) <> Fbx.N_TYPE then return Fbx.TYPE_NONE
    dim as Fbx.StmtPayload ptr gp = StmtOf( c, gn )
    if gp->b = Fbx.NODE_NONE then return Fbx.TYPE_NONE
    if c.ast->Kind( gp->b ) <> Fbx.N_BLOCK then return Fbx.TYPE_NONE
    dim as Fbx.ListPayload ptr plist = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, gp->b )].data )]
    if plist->count <> sp->count then return Fbx.TYPE_NONE

    '' The ARGUMENTS, resolved in the scope that wrote them. One that does not resolve
    '' means no instantiation rather than a wrong one -- every use then declines, which
    '' is the honest outcome and the same rule the tuple path uses.
    dim as string key = c.names->Spelling( sp->name ) & "<"
    dim as FB.Array( of ulong ) argTypes
    for i as long = 0 to sp->count - 1
        dim as Fbx.NodeId an = cast( Fbx.NodeId, c.ast->children[sp->first + i] )
        dim as Fbx.TypeId at = ResolveTypeRef( c, an, scope_ )
        if at = Fbx.TYPE_NONE then return Fbx.TYPE_NONE
        argTypes.Push( cast( ulong, at ) )
        if i > 0 then key += ","
        key += str( cast( long, at ) )
    next
    key += ">"

    '' CACHED. 'b2 = b' over two spellings of one instantiation has to be the same
    '' type, so a miss here would break assignment as well as duplicate the work.
    dim as Fbx.InternId inm = c.names->Fold( c.names->GetString( key ) )
    dim as Fbx.SymbolId prev = c.syms->LookupLocalTyped( Fbx.SCOPE_GLOBAL, inm, true )
    dim as Fbx.Symbol ptr ps = c.syms->SymbolAt( prev )
    if ps <> 0 then return ps->type_

    dim as boolean dup = false
    dim as Fbx.SymbolId isid = c.syms->DeclareSym( Fbx.SCOPE_GLOBAL, inm, _
        Fbx.SYM_UDT, c.ast->Loc( id ), dup )
    dim as Fbx.Symbol ptr isym = c.syms->SymbolAt( isid )
    if isym = 0 then return Fbx.TYPE_NONE
    dim as Fbx.ScopeId iin = c.syms->OpenScope( Fbx.SCOPEK_TYPE, Fbx.SCOPE_GLOBAL, isid )
    isym->inner = iin
    isym->type_ = c.types->NamedType( Fbx.TK_UDT, inm, cast( ulong, Fbx.SCOPE_GLOBAL ) )
    '' The symbol is published BEFORE the fields are walked, so a generic that refers
    '' to itself behind a pointer -- 'as Node( of T ) ptr nxt' -- finds the cache
    '' rather than recursing for ever.
    isym->payload = cast( long, gn )

    '' The parameters bind for as long as the fields are being resolved.
    dim as long gmark = c.gparamName.Count
    for i as long = 0 to sp->count - 1
        dim as Fbx.NodeId pn = cast( Fbx.NodeId, c.ast->children[plist->first + i] )
        if c.ast->Kind( pn ) <> Fbx.N_IDENT then continue for
        dim as Fbx.IdentPayload ptr pip = _
            @c.ast->idents[cast( long, c.ast->nodes[cast( long, pn )].data )]
        c.gparamName.Push( cast( ulong, pip->name ) )
        c.gparamType.Push( argTypes[i] )
    next

    for i as long = 0 to gp->count - 1
        dim as Fbx.NodeId m = cast( Fbx.NodeId, c.ast->children[gp->first + i] )
        if c.ast->Kind( m ) <> Fbx.N_FIELD then continue for
        dim as Fbx.StmtPayload ptr fp = StmtOf( c, m )
        if fp->name = 0 then continue for
        dim as Fbx.TypeId ft = ResolveTypeRef( c, fp->a, iin )
        ft = ArrayFromBounds( c, ft, fp->first, fp->count )
        dim as boolean fdup = false
        dim as Fbx.SymbolId fsid = c.syms->DeclareSym( iin, fp->name, Fbx.SYM_FIELD, _
            c.ast->Loc( m ), fdup )
        dim as Fbx.Symbol ptr fs = c.syms->SymbolAt( fsid )
        if fs <> 0 then fs->type_ = ft
    next

    '' THE MEMBERS, AFTER THE WALK. See Ctx.pendInst for why this cannot happen here.
    dim as long argFirst = c.pendInstArgs.Count
    for i as long = 0 to sp->count - 1
        c.pendInstArgs.Push( argTypes[i] )
    next
    c.pendInst.Push( cast( ulong, gn ) )
    c.pendInst.Push( cast( ulong, gs->name ) )
    c.pendInst.Push( cast( ulong, inm ) )
    c.pendInst.Push( cast( ulong, iin ) )
    c.pendInst.Push( cast( ulong, scope_ ) )
    c.pendInst.Push( cast( ulong, argFirst ) )
    c.pendInst.Push( cast( ulong, sp->count ) )

    while c.gparamName.Count > gmark
        c.gparamName.Pop( )
        c.gparamType.Pop( )
    wend

    return isym->type_
end function

'' INSTANTIATE THE MEMBERS of a generic, by parsing their definitions a SECOND time.
''
'' The bodies cannot be shared. SemanticInfo is keyed by NodeId, so two instantiations
'' walking one body would write two different types onto the same node and the second
'' would win everywhere -- which is why the two earlier attempts at giving instantiations
'' their own member SYMBOLS pointing at the generic's own nodes moved the corpus
'' backwards and then not at all. Fresh nodes are the only answer.
''
'' A re-parse gets them, and it needs no token substitution: the ordinary declaration
'' parser runs over the range the definition was first read from, and the type parameters
'' are substituted later, by ResolveTypeRef, off the stack this is called under. The
'' token buffer only ever grows, so an index recorded during the first parse is still
'' valid now.
''
'' What is patched is one field. 'function Box.Get( ) as T' re-parses with ownerName
'' 'Box'; setting it to the instantiation's structural name is what makes Collect open
'' the body under the INSTANTIATION's scope rather than the generic's -- and with it the
'' mangled name, which comes off the scope chain, differs per instantiation for free.
''
'' The generic's own 'declare' lines are not instantiated at all. The DEFINITION carries
'' the whole signature, and Collect declares a member it finds no declaration for, so
'' one pass over the definitions is the complete job.
'' The statements of a block.
''
'' FIRST AND COUNT ARE SNAPSHOTTED because instantiating a generic member RE-PARSES it,
'' and parsing appends to ast.lists -- so a ListPayload ptr held across one dangles.
'' The child POOL only grows, so indices taken now stay valid.
sub WalkBlock_ _
    ( byref c as Ctx, byval id as Fbx.NodeId, byval here as Fbx.ScopeId )
    dim as Fbx.ListPayload ptr lp = ListOf( c, id )
    dim as long lfirst = lp->first
    dim as long lcount = lp->count
    for i as long = 0 to lcount - 1
        WalkStmt( c, cast( Fbx.NodeId, c.ast->children[lfirst + i] ), here )
    next
end sub

'' Does this unit DECLARE a generic at all? The parser records the token range of every
'' one it sees and of nothing else shaped like a type, so the table answers it without
'' a walk -- and the answer decides whether Resolve pays for a second pass.
'' A UNIT WITH GENERICS IS WALKED TWICE.
''
'' Instantiating a generic member re-parses it, and parsing appends to the arena's
'' payload vectors -- so it can only happen when NO payload pointer is live, which means
'' with the walk fully unwound. But a member cannot be instantiated after the walk
'' either: the call site that needs it is IN the walk, and 'a.Put( )' would have bound
'' to the generic's own member before the instantiation existed.
''
'' So: one pass to find out which instantiations the unit asks for, the instantiation
'' itself with the stack empty, then the real pass, which now sees every instantiated
'' member. The first pass is DISCOVERY ONLY -- its diagnostics are rolled back, or every
'' error in a file using a generic would be reported twice. Files with no generic at all
'' pay nothing: the second walk never happens.
sub DiscoverInstantiations_ _
    ( byref c as Ctx, byref ast as Fbx.AstArena, byval root as Fbx.NodeId, _
      byref diags as Fbx.DiagnosticEngine, byref info as Fbx.SemanticInfo )

    if HasGenericDecl_( c ) = false then return

    dim as long dpend = diags.pending.Count
    dim as long derr = diags.errors
    dim as long dwarn = diags.warnings
    dim as long dsupp = diags.suppressedCount
    WalkStmt( c, root, Fbx.SCOPE_GLOBAL )
    while diags.pending.Count > dpend
        diags.pending.Pop( )
    wend
    diags.errors = derr
    diags.warnings = dwarn
    diags.suppressedCount = dsupp
    InstantiatePending_( c )
    info.Resize( ast.Count( ) )
end sub

function HasGenericDecl_( byref c as Ctx ) as boolean
    for i as long = 0 to c.ast->tokenRanges.Count - 3 step 3
        if c.ast->Kind( cast( Fbx.NodeId, c.ast->tokenRanges[i] ) ) = Fbx.N_TYPE then
            return true
        end if
    next
    return false
end function

sub InstantiatePending_( byref c as Ctx )
    '' Drained rather than iterated: a member body may name another generic, and
    '' resolving it appends here. The count is re-read every time round.
    while c.pendDone < c.pendInst.Count
        dim as long i = c.pendDone
        c.pendDone += 7
        InstantiateMembers_( c, cast( Fbx.NodeId, c.pendInst[i] ), _
                             cast( Fbx.InternId, c.pendInst[i + 1] ), _
                             cast( Fbx.InternId, c.pendInst[i + 2] ), _
                             cast( Fbx.ScopeId, c.pendInst[i + 3] ), _
                             cast( Fbx.ScopeId, c.pendInst[i + 4] ), _
                             cast( long, c.pendInst[i + 5] ), _
                             cast( long, c.pendInst[i + 6] ) )
    wend
end sub

private sub InstantiateMembers_ _
    ( byref c as Ctx, byval gnode as Fbx.NodeId, byval gname as Fbx.InternId, _
      byval inm as Fbx.InternId, byval iin as Fbx.ScopeId, byval scope_ as Fbx.ScopeId, _
      byval argFirst as long, byval argCount as long )

    if c.parser = 0 then return
    dim as Fbx.ParserState ptr p0 = cast( Fbx.ParserState ptr, c.parser )
    if p0->toks = 0 then return

    '' The table is scanned to its length AS IT IS NOW. Resolving one member may
    '' instantiate another generic, which appends -- and those entries belong to that
    '' generic, not this one. Taking the count first keeps this loop over its own work.
    '' THE TYPE PARAMETERS, bound again. They were popped when the type half finished,
    '' and the member signatures -- 'byval x as T' -- are what needs them.
    dim as long gmark = c.gparamName.Count
    dim as Fbx.StmtPayload ptr gp = StmtOf( c, gnode )
    if gp->b <> Fbx.NODE_NONE then
        if c.ast->Kind( gp->b ) = Fbx.N_BLOCK then
            dim as Fbx.ListPayload ptr pl = _
                @c.ast->lists[cast( long, c.ast->nodes[cast( long, gp->b )].data )]
            for i as long = 0 to argCount - 1
                if i >= pl->count then exit for
                dim as Fbx.NodeId pn = cast( Fbx.NodeId, c.ast->children[pl->first + i] )
                if c.ast->Kind( pn ) <> Fbx.N_IDENT then continue for
                dim as Fbx.IdentPayload ptr pip = _
                    @c.ast->idents[cast( long, c.ast->nodes[cast( long, pn )].data )]
                c.gparamName.Push( cast( ulong, pip->name ) )
                c.gparamType.Push( c.pendInstArgs[argFirst + i] )
            next
        end if
    end if

    dim as long n0 = c.ast->tokenRanges.Count
    for i as long = 0 to n0 - 3 step 3
        dim as Fbx.NodeId dn = cast( Fbx.NodeId, c.ast->tokenRanges[i] )
        if c.ast->Kind( dn ) <> Fbx.N_PROC then continue for
        dim as Fbx.StmtPayload ptr dp = StmtOf( c, dn )
        if dp->ownerName <> gname then continue for
        if dp->b = Fbx.NODE_NONE then continue for

        '' A PARSER OF ITS OWN over the same buffer. The stream is deliberately NOT
        '' carried across: the preprocessor was closed when the unit finished, and the
        '' range being re-read is already buffered, so nothing may try to pull more.
        dim as Fbx.ParserState q
        q.toks = p0->toks
        q.stream = 0
        q.litPool = p0->litPool
        q.ast = c.ast
        q.src = c.srcMgr
        q.names = c.names
        q.diags = c.diags
        q.pos = cast( long, c.ast->tokenRanges[i + 1] )
        q.silent = true

        dim as Fbx.NodeId fresh = Fbx.Parse.Statement( q )
        if fresh = Fbx.NODE_NONE then continue for
        if c.ast->Kind( fresh ) <> Fbx.N_PROC then continue for

        dim as Fbx.StmtPayload ptr fp2 = StmtOf( c, fresh )
        fp2->ownerName = inm
        dim as Fbx.InternId mname = fp2->name
        dim as ushort mop = fp2->op

        '' THE MEMBER'S SYMBOL, declared here because nothing else will. Collect treats
        '' 'sub Box.Put( )' as a DEFINITION of something declared elsewhere and
        '' deliberately declares nothing for it -- the 'declare sub Put( )' inside the
        '' TYPE is what carries the symbol. The instantiation's scope has no such line,
        '' so without this the definition landed in a scope that named it nowhere:
        '' every call site fell back to the GENERIC's member, and lowering, which finds
        '' the receiver by looking 'this' up in the proc symbol's scope, found no
        '' symbol and gave the method NO RECEIVER at all.
        ''
        '' Structors are left alone: Collect already declares those itself, under the
        '' synthetic __ctor / __dtor names, and doing it twice would split the chain.
        select case cast( Fbx.TokenKind, mop )
        case Fbx.KW_CONSTRUCTOR, Fbx.KW_DESTRUCTOR
        case else
            if mname <> 0 then
                dim as boolean mdup = false
                dim as Fbx.SymbolId msid = c.syms->DeclareSym( iin, mname, _
                    Fbx.SYM_PROC, c.ast->Loc( fresh ), mdup )
                dim as Fbx.Symbol ptr msym = c.syms->SymbolAt( msid )
                if msym <> 0 then
                    '' THE FRESH NODE IS THE PAYLOAD. Every call site mangles against
                    '' whatever node the symbol points at, and a symbol with none
                    '' mangles to its bare source spelling -- 'call void put(...)',
                    '' which links to nothing. It is also what carries the signature,
                    '' and this instantiation's signature is on this instantiation's
                    '' own node, not the generic's.
                    msym->payload = cast( long, fresh )
                    msym->flags or= Fbx.SYMF_DEFINED
                end if
            end if
        end select

        '' The unit's root block was closed when it was parsed, so this node is not
        '' reachable from it. Later passes walk extraTopLevel to find it; without that
        '' it would be collected, resolved, typed -- and never emitted.
        c.ast->extraTopLevel.Push( cast( ulong, fresh ) )
        c.info->Resize( c.ast->Count( ) )
        Fbx.Collect.One( *c.ast, fresh, scope_, *c.syms, *c.names, *c.types, _
                         *c.diags, *c.info )
        WalkStmt( c, fresh, scope_ )
    next

    while c.gparamName.Count > gmark
        c.gparamName.Pop( )
        c.gparamType.Pop( )
    wend
end sub

end namespace
