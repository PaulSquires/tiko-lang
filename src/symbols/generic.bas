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
      byval scope_ as Fbx.ScopeId, byval gsid as Fbx.SymbolId ) as Fbx.TypeId

    '' THE GENERIC IS PASSED IN, already resolved -- including through a namespace
    '' qualifier, which is where every container in the runtime headers lives. Looking
    '' it up here, unqualified from the use site, found nothing for 'FB.Array( of long )'
    '' and quietly left the reference bound to the GENERIC.
    ''
    '' It still has to be a UDT whose declaration carries a parameter list, or 'Foo( 3 )'
    '' on an ordinary type would be read as an instantiation.
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
    '' THE KEY COMES FROM THE RESOLVED SYMBOL, NOT FROM THE SPELLING. Instantiations
    '' live in SCOPE_GLOBAL, so the qualifier has to be in the name or two generics of
    '' one spelling in different namespaces would share an instantiation -- but taking
    '' it from what was WRITTEN is worse: 'N.It( of long )' at a use site and
    '' 'It( of long )' inside N are the same type and produced two, so a member
    '' returning its own sibling returned something no caller could name.
    ''
    '' '#', not '.', joins the parts: this name becomes the OWNER of every instantiated
    '' member, and Collect resolves an owner by splitting it on DOTS -- a dotted key
    '' sent it looking for a namespace that does not exist and opened every member body
    '' at module scope instead, so the mangled names came out as the bare source
    '' spelling and every call site linked to nothing.
    dim as string key = c.names->Spelling( gs->name ) & "<"
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

    '' THE INSTANTIATION LIVES IN THE GENERIC'S OWN SCOPE, not in SCOPE_GLOBAL.
    ''
    '' Three things follow from that and all three were wrong before. Its member bodies
    '' can SEE THE GENERIC'S SIBLINGS -- 'function Coll( of T ).A( ) as Plain' names a
    '' plain type declared beside Coll, and from a global scope that resolved to
    '' nothing, so the member came out with NO RETURN TYPE and every call to it was
    '' 'call void'. Its mangled name picks the namespace up from the SCOPE CHAIN like
    '' any other member's. And two generics of one spelling in different namespaces get
    '' separate symbols without the name having to carry a qualifier -- which is what a
    '' spelling-derived key got wrong in the other direction: 'N.It( of long )' at a use
    '' site and 'It( of long )' inside N are the same type and produced two.
    dim as Fbx.ScopeId ghome = gs->parent
    if ghome = Fbx.SCOPE_NONE then ghome = Fbx.SCOPE_GLOBAL

    '' CACHED. 'b2 = b' over two spellings of one instantiation has to be the same
    '' type, so a miss here would break assignment as well as duplicate the work.
    dim as Fbx.InternId inm = c.names->Fold( c.names->GetString( key ) )
    dim as Fbx.SymbolId prev = c.syms->LookupLocalTyped( ghome, inm, true )
    dim as Fbx.Symbol ptr ps = c.syms->SymbolAt( prev )
    if ps <> 0 then return ps->type_

    dim as boolean dup = false
    dim as Fbx.SymbolId isid = c.syms->DeclareSym( ghome, inm, _
        Fbx.SYM_UDT, c.ast->Loc( id ), dup )
    dim as Fbx.Symbol ptr isym = c.syms->SymbolAt( isid )
    if isym = 0 then return Fbx.TYPE_NONE
    dim as Fbx.ScopeId iin = c.syms->OpenScope( Fbx.SCOPEK_TYPE, ghome, isid )
    isym->inner = iin
    isym->type_ = c.types->NamedType( Fbx.TK_UDT, inm, cast( ulong, ghome ) )
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
    '' THE GENERIC'S OWN SCOPE, not the use site's. An instantiated member body is the
    '' generic's source re-read, so its names have to resolve where they were WRITTEN:
    '' 'function Array( of T ).GetIterator( ) as ArrayIterator( of T )' names its
    '' sibling unqualified from inside 'namespace FB', and resolving that from the
    '' caller's module scope found nothing -- so GetIterator came out with no return
    '' type at all and 'for each' over any container declined.
    dim as Fbx.ScopeId gscope = gs->parent
    if gscope = Fbx.SCOPE_NONE then gscope = scope_
    c.pendInst.Push( cast( ulong, gscope ) )
    c.pendInst.Push( cast( ulong, argFirst ) )
    c.pendInst.Push( cast( ulong, sp->count ) )

    while c.gparamName.Count > gmark
        c.gparamName.Pop( )
        c.gparamType.Pop( )
    wend

    return isym->type_
end function

'' INSTANTIATE A GENERIC PROCEDURE -- 'Ok( of Decimal, FinanceError )( v )'.
''
'' NO INFERENCE IS NEEDED. Every call site in the runtime headers writes the type
'' arguments out, which is also the only form fbx's parser keeps, so the instantiation's
'' whole input is right there on the call.
''
'' Same machinery as the TYPE half and for the same reason: SemanticInfo is keyed by
'' NodeId, so the body is RE-PARSED from the token range the parser recorded and the
'' fresh nodes are resolved with the parameters bound. What is patched is the NAME --
'' to a structural key over the argument list -- so two instantiations are two symbols
'' with two mangled names, and the call binds to the one it asked for.
''
'' Returns the instantiated symbol, or SYMBOL_NONE when this is not a generic call at
'' all -- which is every ordinary call, so it must be cheap to say no.
function InstantiateGenericProc_ _
    ( byref c as Ctx, byval callId as Fbx.NodeId, byval scope_ as Fbx.ScopeId ) as Fbx.SymbolId

    if c.parser = 0 then return Fbx.SYMBOL_NONE
    dim as long taFirst, taCount
    if c.ast->CallTypeArgsOf( callId, taFirst, taCount ) = false then return Fbx.SYMBOL_NONE
    if c.ast->Kind( callId ) <> Fbx.N_CALL then return Fbx.SYMBOL_NONE

    dim as Fbx.ListPayload ptr lp = ListOf( c, callId )
    dim as Fbx.NodeId tgt = lp->target
    if tgt = Fbx.NODE_NONE then return Fbx.SYMBOL_NONE
    if c.ast->Kind( tgt ) <> Fbx.N_IDENT then return Fbx.SYMBOL_NONE
    dim as Fbx.InternId gname = IdentNameOf( c, tgt )
    if gname = 0 then return Fbx.SYMBOL_NONE

    '' THE GENERIC'S OWN NODE, through its symbol. A name that resolves to something
    '' that is not a generic procedure is left alone -- 'Box( of long )' in expression
    '' position is a TYPE and takes the other path.
    dim as Fbx.SymbolId gsid = c.syms->Lookup( scope_, gname )
    dim as Fbx.Symbol ptr gs = c.syms->SymbolAt( gsid )
    if gs = 0 then return Fbx.SYMBOL_NONE
    if gs->kind <> cast( ubyte, Fbx.SYM_PROC ) then return Fbx.SYMBOL_NONE
    dim as Fbx.NodeId gn = cast( Fbx.NodeId, gs->payload )
    if gn = Fbx.NODE_NONE then return Fbx.SYMBOL_NONE
    if c.ast->Kind( gn ) <> Fbx.N_PROC then return Fbx.SYMBOL_NONE
    dim as Fbx.StmtPayload ptr gp = StmtOf( c, gn )
    if (gp->extra and Fbx.PF_GENERIC_PROC) = 0 then return Fbx.SYMBOL_NONE
    if gp->c = Fbx.NODE_NONE then return Fbx.SYMBOL_NONE
    if c.ast->Kind( gp->c ) <> Fbx.N_BLOCK then return Fbx.SYMBOL_NONE
    dim as Fbx.ListPayload ptr pl = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, gp->c )].data )]
    if pl->count <> taCount then return Fbx.SYMBOL_NONE

    '' THE ARGUMENTS, resolved where they were written. One that does not resolve means
    '' no instantiation rather than a wrong one -- the call then declines, which is the
    '' honest outcome and the same rule the type half uses.
    dim as string key = c.names->Spelling( gname ) & "<"
    dim as FB.Array( of ulong ) argTypes
    for i as long = 0 to taCount - 1
        dim as Fbx.NodeId an = cast( Fbx.NodeId, c.ast->children[taFirst + i] )
        dim as Fbx.TypeId at = ResolveTypeRef( c, an, scope_ )
        if at = Fbx.TYPE_NONE then return Fbx.SYMBOL_NONE
        argTypes.Push( cast( ulong, at ) )
        if i > 0 then key += ","
        key += str( cast( long, at ) )
    next
    key += ">"

    '' CACHED, in the scope the generic itself lives in. Two call sites naming the same
    '' instantiation must reach ONE function, or the module would carry two definitions
    '' of it under one mangled name.
    dim as Fbx.InternId inm = c.names->Fold( c.names->GetString( key ) )
    dim as Fbx.ScopeId home = gs->parent
    if home = Fbx.SCOPE_NONE then home = Fbx.SCOPE_GLOBAL
    dim as Fbx.SymbolId prev = c.syms->LookupLocal( home, inm )
    if prev <> Fbx.SYMBOL_NONE then return prev

    '' The symbol is DECLARED NOW and its body filled in by the deferred pass, so a
    '' recursive generic -- one whose body calls itself at the same arguments -- finds
    '' this rather than instantiating for ever.
    dim as boolean idup = false
    dim as Fbx.SymbolId isid = c.syms->DeclareSym( home, inm, Fbx.SYM_PROC, _
        c.ast->Loc( gn ), idup )
    if isid = Fbx.SYMBOL_NONE then return Fbx.SYMBOL_NONE

    dim as long argFirst = c.pendProcArgs.Count
    for i as long = 0 to taCount - 1
        c.pendProcArgs.Push( argTypes[i] )
    next
    c.pendProc.Push( cast( ulong, gn ) )
    c.pendProc.Push( cast( ulong, isid ) )
    c.pendProc.Push( cast( ulong, inm ) )
    c.pendProc.Push( cast( ulong, home ) )
    c.pendProc.Push( cast( ulong, argFirst ) )
    c.pendProc.Push( cast( ulong, taCount ) )
    return isid
end function

'' The deferred half: parse each pending generic procedure again and resolve the fresh
'' nodes with its parameters bound. Separated from the discovery above for the reason
'' every re-parse in this file is -- parsing grows the arena, and a payload pointer held
'' anywhere up the stack dangles the moment it does.
sub InstantiatePendingProcs_( byref c as Ctx )
    if c.parser = 0 then return
    dim as Fbx.ParserState ptr p0 = cast( Fbx.ParserState ptr, c.parser )
    if p0->toks = 0 then return

    while c.pendProcDone < c.pendProc.Count
        dim as long i = c.pendProcDone
        c.pendProcDone += 6
        dim as Fbx.NodeId gn = cast( Fbx.NodeId, c.pendProc[i] )
        dim as Fbx.SymbolId isid = cast( Fbx.SymbolId, c.pendProc[i + 1] )
        dim as Fbx.InternId inm = cast( Fbx.InternId, c.pendProc[i + 2] )
        dim as Fbx.ScopeId home = cast( Fbx.ScopeId, c.pendProc[i + 3] )
        dim as long argFirst = cast( long, c.pendProc[i + 4] )
        dim as long argCount = cast( long, c.pendProc[i + 5] )

        dim as long t0, t1
        if c.ast->TokensOf( gn, t0, t1 ) = false then continue while

        '' The parameters bind for as long as the fresh nodes are being resolved.
        dim as long gmark = c.gparamName.Count
        dim as Fbx.StmtPayload ptr gp = StmtOf( c, gn )
        if gp->c <> Fbx.NODE_NONE then
            if c.ast->Kind( gp->c ) = Fbx.N_BLOCK then
                dim as Fbx.ListPayload ptr pl = _
                    @c.ast->lists[cast( long, c.ast->nodes[cast( long, gp->c )].data )]
                for k as long = 0 to argCount - 1
                    if k >= pl->count then exit for
                    dim as Fbx.NodeId pn = cast( Fbx.NodeId, c.ast->children[pl->first + k] )
                    if c.ast->Kind( pn ) <> Fbx.N_IDENT then continue for
                    dim as Fbx.IdentPayload ptr pip = _
                        @c.ast->idents[cast( long, c.ast->nodes[cast( long, pn )].data )]
                    c.gparamName.Push( cast( ulong, pip->name ) )
                    c.gparamType.Push( c.pendProcArgs[argFirst + k] )
                next
            end if
        end if

        dim as Fbx.ParserState q
        q.toks = p0->toks
        q.stream = 0
        q.litPool = p0->litPool
        q.ast = c.ast
        q.src = c.srcMgr
        q.names = c.names
        q.diags = c.diags
        q.pos = t0
        q.silent = true

        dim as Fbx.NodeId fresh = Fbx.Parse.Statement( q )
        if (fresh <> Fbx.NODE_NONE) andalso (c.ast->Kind( fresh ) = Fbx.N_PROC) then
            dim as Fbx.StmtPayload ptr fp = StmtOf( c, fresh )
            '' THE NAME IS THE STRUCTURAL KEY, and the generic flag comes OFF -- this
            '' one is a concrete procedure now, and leaving the flag on would make
            '' lowering decline the very body that was just built for it.
            fp->name = inm
            fp->rawName = inm
            fp->extra and= not Fbx.PF_GENERIC_PROC
            fp->c = Fbx.NODE_NONE

            c.ast->extraTopLevel.Push( cast( ulong, fresh ) )
            c.info->Resize( c.ast->Count( ) )
            Fbx.Collect.One( *c.ast, fresh, home, *c.syms, *c.names, *c.types, _
                             *c.diags, *c.info )
            WalkStmt( c, fresh, home )
            '' Collect declares its own symbol for a fresh unqualified definition, and
            '' that one carries the node. The symbol the CALL SITE was given is the one
            '' declared before the body existed, so it is pointed at the same node here
            '' -- without this the call mangles against a symbol with no payload and
            '' comes out as the bare source spelling.
            dim as Fbx.Symbol ptr isym = c.syms->SymbolAt( isid )
            dim as Fbx.SymbolId made = c.syms->LookupLocal( home, inm )
            dim as Fbx.Symbol ptr msym = c.syms->SymbolAt( made )
            if (isym <> 0) andalso (msym <> 0) then
                if isym->payload = 0 then isym->payload = msym->payload
                if isym->type_ = Fbx.TYPE_NONE then isym->type_ = msym->type_
                isym->inner = msym->inner
                isym->flags or= Fbx.SYMF_DEFINED
            end if
        end if

        while c.gparamName.Count > gmark
            c.gparamName.Pop( )
            c.gparamType.Pop( )
        wend
    wend
end sub

declare function TypeMemberNamed_ _
    ( byref c as Ctx, byval t as Fbx.TypeId, byref nm as string ) as Fbx.SymbolId

'' THE ELEMENT TYPE OF A USER COLLECTION -- the RFC-0002 iterator protocol.
''
'' STRUCTURAL, not nominal: a collection is anything with GetIterator( ), and its
'' element type is the return type of the iterator's Value( ). Two lookups, and nothing
'' is declared to implement anything.
''
'' Answered in RESOLVE rather than in lowering, which is where the loop variable used to
'' get its type. Check runs in between, so a variable typed during lowering is untyped
'' for the whole of Check -- and 'if y = 20' inside the loop body produced NO CONDITION,
'' which went out as a conditional branch with nothing to branch on and counted as
'' fully lowered.
function IterElemType_ _
    ( byref c as Ctx, byval seqT as Fbx.TypeId ) as Fbx.TypeId

    dim as Fbx.SymbolId gi = TypeMemberNamed_( c, seqT, "getiterator" )
    dim as Fbx.Symbol ptr gs = c.syms->SymbolAt( gi )
    if gs = 0 then return Fbx.TYPE_NONE
    if gs->type_ = Fbx.TYPE_NONE then return Fbx.TYPE_NONE
    dim as Fbx.SymbolId vo = TypeMemberNamed_( c, gs->type_, "value" )
    dim as Fbx.Symbol ptr vs = c.syms->SymbolAt( vo )
    if vs = 0 then return Fbx.TYPE_NONE
    return vs->type_
end function

'' A member of a UDT by name, folded.
private function TypeMemberNamed_ _
    ( byref c as Ctx, byval t as Fbx.TypeId, byref nm as string ) as Fbx.SymbolId

    if t = Fbx.TYPE_NONE then return Fbx.SYMBOL_NONE
    if c.types->Kind( t ) <> Fbx.TK_UDT then return Fbx.SYMBOL_NONE
    dim as Fbx.InternId tn = c.types->NameOf( t )
    if tn = 0 then return Fbx.SYMBOL_NONE
    dim as Fbx.ScopeId ds = cast( Fbx.ScopeId, c.types->DeclScopeOf( t ) )
    dim as Fbx.SymbolId ts = c.syms->LookupLocalTyped( ds, tn, true )
    if ts = Fbx.SYMBOL_NONE then ts = c.syms->LookupTyped( ds, tn, true )
    dim as Fbx.Symbol ptr s = c.syms->SymbolAt( ts )
    if s = 0 then return Fbx.SYMBOL_NONE
    if s->inner = Fbx.SCOPE_NONE then return Fbx.SYMBOL_NONE
    return c.syms->LookupLocal( s->inner, c.names->Fold( c.names->GetString( nm ) ) )
end function

'' The enclosing NAMESPACE and TYPE names of a scope, outermost first, each followed by
'' '#'. Empty at global or module scope.
''
'' Built from the SCOPE CHAIN rather than from any spelling, which is the whole point:
'' one generic has one qualifier however a use site chose to write it.
function QualifierPrefix_( byref c as Ctx, byval sc as Fbx.ScopeId ) as string
    dim as string parts
    dim as Fbx.ScopeId cur = sc
    dim as long guard = 0
    while (cur <> Fbx.SCOPE_NONE) andalso (guard < 32)
        guard += 1
        dim as Fbx.SymScope ptr s = c.syms->ScopeAt( cur )
        if s = 0 then exit while
        dim as Fbx.Symbol ptr o = c.syms->SymbolAt( s->owner )
        if o <> 0 then
            if o->name <> 0 then parts = c.names->Spelling( o->name ) & "#" & parts
        end if
        cur = s->parent
    wend
    return parts
end function

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
    InstantiatePendingProcs_( c )
    info.Resize( ast.Count( ) )
end sub

function HasGenericDecl_( byref c as Ctx ) as boolean
    for i as long = 0 to c.ast->tokenRanges.Count - 3 step 3
        dim as Fbx.NodeId n = cast( Fbx.NodeId, c.ast->tokenRanges[i] )
        if c.ast->Kind( n ) = Fbx.N_TYPE then return true
        '' A GENERIC PROCEDURE counts too, and it need not be inside a generic type --
        '' 'function Ok( of T, E )( ... )' is one on its own, and fb/result.bi is
        '' nothing but those.
        if c.ast->Kind( n ) = Fbx.N_PROC then
            if (StmtOf( c, n )->extra and Fbx.PF_GENERIC_PROC) <> 0 then return true
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
        '' THE GENERIC-PROCEDURE FLAG COMES OFF. Every out-of-line member of a generic
        '' is spelled 'function Array( of T ).Count( )', so the parser's '( of ... )'
        '' branch marks it PF_GENERIC_PROC -- and lowering skips anything carrying that
        '' as a template. The instantiated body is a concrete procedure; leaving the
        '' flag on meant every one was declared, called, and never emitted.
        fp2->extra and= not Fbx.PF_GENERIC_PROC
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

'' TYPEDEFS THAT NAME A TYPE DECLARED LATER, and the declarations waiting on them.
''
''     type t as u : type u as integer : dim as t i
''
'' A FIXPOINT, not one extra pass: 'a as b / b as c / c as integer' needs one round per
'' link. Bounded, because a round that binds nothing stops. Then the declarations that
'' could not be typed the first time -- only those, because a second full walk would
'' report every diagnostic twice.
sub BackpatchTypedefs( byref c as Ctx )
    for r as long = 1 to c.typedefNode.Count
        dim as boolean progress = false
        for i as long = 0 to c.typedefNode.Count - 1
            dim as Fbx.NodeId id = cast( Fbx.NodeId, c.typedefNode[i] )
            dim as Fbx.ScopeId here = cast( Fbx.ScopeId, c.typedefScope[i] )
            dim as Fbx.StmtPayload ptr tsp = StmtOf( c, id )
            if tsp->name = 0 then continue for
            dim as Fbx.Symbol ptr ts = _
                c.syms->SymbolAt( c.syms->LookupLocalTyped( here, tsp->name, true ) )
            if ts = 0 then continue for
            if ts->kind <> cast( ubyte, Fbx.SYM_TYPEDEF ) then continue for
            dim as Fbx.TypeId al = ResolveTypeRef( c, tsp->a, here )
            if (al = Fbx.TYPE_NONE) orelse (al = ts->type_) then continue for
            ts->type_ = al
            progress = true
        next
        if progress = false then exit for
    next

    for i as long = 0 to c.pendingItem.Count - 1
        dim as Fbx.NodeId item = cast( Fbx.NodeId, c.pendingItem[i] )
        dim as Fbx.ScopeId here = cast( Fbx.ScopeId, c.pendingScope[i] )
        dim as Fbx.StmtPayload ptr ip = StmtOf( c, item )
        dim as Fbx.TypeId t = ResolveTypeRef( c, ip->a, here )
        if t = Fbx.TYPE_NONE then continue for
        BindDeclType( c, here, ip->name, ArrayFromBoundsNode( c, t, ip->c, ip->b ) )
    next
end sub

'' N_VAR_ITEM: an N_BLOCK of N_CASE_RANGE, one per dimension.
function ArrayFromBoundsNode _
    ( byref c as Ctx, byval base_ as Fbx.TypeId, byval id as Fbx.NodeId, _
      byval init as Fbx.NodeId = Fbx.NODE_NONE ) as Fbx.TypeId

    if id = Fbx.NODE_NONE then return base_
    if c.ast->Kind( id ) <> Fbx.N_BLOCK then return base_
    dim as Fbx.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    dim as FB.Array( of ulong ) los, his
    for i as long = 0 to lp->count - 1
        dim as Fbx.NodeId d = cast( Fbx.NodeId, c.ast->children[lp->first + i] )
        if c.ast->Kind( d ) = Fbx.N_CASE_RANGE then
            '' 'a(0 to 9)' -- both bounds written out.
            dim as Fbx.StmtPayload ptr dp = StmtOf( c, d )
            los.Push( cast( ulong, dp->a ) )
            his.Push( cast( ulong, dp->b ) )
        else
            '' 'a(9)' -- a bare expression, which is the UPPER bound with an implicit
            '' lower bound of 0. It is not an N_CASE_RANGE at all, so a loop that only
            '' accepts one silently gives the array no dimensions and drops it back to
            '' its element type.
            los.Push( cast( ulong, Fbx.NODE_NONE ) )
            his.Push( cast( ulong, d ) )
        end if
    next
    return ArrayFromPairs( c, base_, los, his, init, true )
end function

'' 'init' is the declaration's initializer, or NODE_NONE. It is needed because an
'' ellipsis bound takes its size from there and from nowhere else -- fbc refuses
'' 'dim a(0 to ...)' with no initializer outright (error 281).
''
'' Getting this wrong would not be a decline. An unknown bound makes this return the
'' ELEMENT type, so the array becomes eight bytes where twenty-four were needed and
'' nothing says so -- which is exactly what parsing '...' without inferring it did.
function ArrayFromPairs _
    ( byref c as Ctx, byval base_ as Fbx.TypeId, _
      byref los as FB.Array( of ulong ), byref his as FB.Array( of ulong ), _
      byval init as Fbx.NodeId = Fbx.NODE_NONE, _
      byval emptyIsDynamic as boolean = false ) as Fbx.TypeId

    if base_ = Fbx.TYPE_NONE then return base_

    '' EMPTY PARENS -- 'dim as long a()' -- is a DYNAMIC array with its dimension count
    '' left open. It is not 'no array at all', which is what returning the element type
    '' here used to make it: 'a' became a plain LONG, so its declaration reserved four
    '' bytes instead of a descriptor and every later 'redim a(...)' had nothing to
    '' redim. Rank 0 means unspecified; fbc gives such a descriptor eight dimtb slots.
    '' 'emptyIsDynamic' is what tells the two callers apart. A DECLARATION with empty
    '' parens is a dynamic array; a plain TYPE FIELD reaches here with no bound pairs
    '' either, and is not an array at all. Without the distinction 'as long h' inside a
    '' TYPE became a 240-byte descriptor -- caught by the cleanup golden.
    if los.Count = 0 then
        if emptyIsDynamic then return c.types->DynArrayOf( base_, 0 )
        return base_
    end if

    dim as long total = 1
    dim as boolean known = true
    dim as FB.Array( of longint ) bounds
    for i as long = 0 to los.Count - 1
        dim as longint lo = 0
        dim as Fbx.NodeId loN = cast( Fbx.NodeId, los[i] )
        if loN <> Fbx.NODE_NONE then
            dim as Fbx.Check.ConstVal lv = _
                Fbx.Check.ConstOf( *c.ast, loN, *c.srcMgr, *c.names, _
                                   c.types->target.pointerBits )
            if lv.known then lo = lv.value else known = false
        end if
        dim as longint hi = lo - 1
        dim as Fbx.NodeId hiN = cast( Fbx.NodeId, his[i] )
        if (hiN <> Fbx.NODE_NONE) andalso (c.ast->Kind( hiN ) = Fbx.N_ELLIPSIS) then
            '' The bound the initializer implies: lbound + count - 1, per dimension.
            dim as long got = InitCountAt( c, init, i )
            if got > 0 then hi = lo + got - 1 else known = false
        elseif hiN <> Fbx.NODE_NONE then
            dim as Fbx.Check.ConstVal hv = _
                Fbx.Check.ConstOf( *c.ast, hiN, *c.srcMgr, *c.names, _
                                   c.types->target.pointerBits )
            if hv.known then hi = hv.value else known = false
        else
            known = false
        end if
        if known then total *= cast( long, hi - lo + 1 )
        bounds.Push( lo )
        bounds.Push( hi )
    next
    '' A BOUND THAT IS NOT A COMPILE-TIME CONSTANT makes the array DYNAMIC -- 'dim
    '' a(any)', 'dim a(0 to n)'. The rank is still written down, and it is what decides
    '' how many dimtb slots the descriptor carries, so it is kept.
    if (known = false) orelse (total <= 0) then return c.types->DynArrayOf( base_, los.Count )
    return c.types->ArrayOf( base_, los.Count, total, @bounds )
end function

end namespace
