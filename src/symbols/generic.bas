'' generic.bas -- instantiating a generic TYPE.
''
'' Split out of resolve.bas, which is at its size limit.

#include once "symbols/resolvectx.bi"
#include once "symbols/check.bi"
#include once "symbols/collect.bi"
#include once "parser/parser.bi"

namespace Tko.Resolve

declare sub InstantiateMembers_ _
    ( byref c as Ctx, byval gnode as Tko.NodeId, byval gname as Tko.InternId, _
      byval inm as Tko.InternId, byval iin as Tko.ScopeId, byval scope_ as Tko.ScopeId, _
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
    ( byref c as Ctx, byval id as Tko.NodeId, byval sp as Tko.StmtPayload ptr, _
      byval scope_ as Tko.ScopeId, byval gsid as Tko.SymbolId ) as Tko.TypeId

    '' THE GENERIC IS PASSED IN, already resolved -- including through a namespace
    '' qualifier, which is where every container in the runtime headers lives. Looking
    '' it up here, unqualified from the use site, found nothing for 'FB.Array( of long )'
    '' and quietly left the reference bound to the GENERIC.
    ''
    '' It still has to be a UDT whose declaration carries a parameter list, or 'Foo( 3 )'
    '' on an ordinary type would be read as an instantiation.
    dim as Tko.Symbol ptr gs = c.syms->SymbolAt( gsid )
    if gs = 0 then return Tko.TYPE_NONE
    if gs->kind <> cast( ubyte, Tko.SYM_UDT ) then return Tko.TYPE_NONE
    dim as Tko.NodeId gn = cast( Tko.NodeId, gs->payload )
    if gn = Tko.NODE_NONE then return Tko.TYPE_NONE
    if c.ast->Kind( gn ) <> Tko.N_TYPE then return Tko.TYPE_NONE
    dim as Tko.StmtPayload ptr gp = StmtOf( c, gn )
    if gp->b = Tko.NODE_NONE then return Tko.TYPE_NONE
    if c.ast->Kind( gp->b ) <> Tko.N_BLOCK then return Tko.TYPE_NONE
    dim as Tko.ListPayload ptr plist = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, gp->b )].data )]
    if plist->count <> sp->count then return Tko.TYPE_NONE

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
        dim as Tko.NodeId an = cast( Tko.NodeId, c.ast->children[sp->first + i] )
        dim as Tko.TypeId at = ResolveTypeRef( c, an, scope_ )
        if at = Tko.TYPE_NONE then return Tko.TYPE_NONE
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
    dim as Tko.ScopeId ghome = gs->parent
    if ghome = Tko.SCOPE_NONE then ghome = Tko.SCOPE_GLOBAL

    '' CACHED. 'b2 = b' over two spellings of one instantiation has to be the same
    '' type, so a miss here would break assignment as well as duplicate the work.
    dim as Tko.InternId inm = c.names->Fold( c.names->GetString( key ) )
    dim as Tko.SymbolId prev = c.syms->LookupLocalTyped( ghome, inm, true )
    dim as Tko.Symbol ptr ps = c.syms->SymbolAt( prev )
    if ps <> 0 then return ps->type_

    dim as boolean dup = false
    dim as Tko.SymbolId isid = c.syms->DeclareSym( ghome, inm, _
        Tko.SYM_UDT, c.ast->Loc( id ), dup )
    dim as Tko.Symbol ptr isym = c.syms->SymbolAt( isid )
    if isym = 0 then return Tko.TYPE_NONE
    dim as Tko.ScopeId iin = c.syms->OpenScope( Tko.SCOPEK_TYPE, ghome, isid )
    isym->inner = iin
    isym->type_ = c.types->NamedType( Tko.TK_UDT, inm, cast( ulong, ghome ) )
    '' The symbol is published BEFORE the fields are walked, so a generic that refers
    '' to itself behind a pointer -- 'as Node( of T ) ptr nxt' -- finds the cache
    '' rather than recursing for ever.
    isym->payload = cast( long, gn )

    '' The parameters bind for as long as the fields are being resolved.
    dim as long gmark = c.gparamName.Count
    for i as long = 0 to sp->count - 1
        dim as Tko.NodeId pn = cast( Tko.NodeId, c.ast->children[plist->first + i] )
        if c.ast->Kind( pn ) <> Tko.N_IDENT then continue for
        dim as Tko.IdentPayload ptr pip = _
            @c.ast->idents[cast( long, c.ast->nodes[cast( long, pn )].data )]
        c.gparamName.Push( cast( ulong, pip->name ) )
        c.gparamType.Push( argTypes[i] )
    next

    for i as long = 0 to gp->count - 1
        dim as Tko.NodeId m = cast( Tko.NodeId, c.ast->children[gp->first + i] )
        if c.ast->Kind( m ) <> Tko.N_FIELD then continue for
        dim as Tko.StmtPayload ptr fp = StmtOf( c, m )
        if fp->name = 0 then continue for
        dim as Tko.TypeId ft = ResolveTypeRef( c, fp->a, iin )
        ft = ArrayFromBounds( c, ft, fp->first, fp->count, iin )
        dim as boolean fdup = false
        dim as Tko.SymbolId fsid = c.syms->DeclareSym( iin, fp->name, Tko.SYM_FIELD, _
            c.ast->Loc( m ), fdup )
        dim as Tko.Symbol ptr fs = c.syms->SymbolAt( fsid )
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
    dim as Tko.ScopeId gscope = gs->parent
    if gscope = Tko.SCOPE_NONE then gscope = scope_
    c.pendInst.Push( cast( ulong, gscope ) )
    c.pendInst.Push( cast( ulong, argFirst ) )
    c.pendInst.Push( cast( ulong, sp->count ) )

    while c.gparamName.Count > gmark
        c.gparamName.Pop( )
        c.gparamType.Pop( )
    wend

    return isym->type_
end function

#include once "symbols/genericinfer.bas"

'' INFER THE TYPE ARGUMENTS from the call's own arguments, for a call that wrote none.
''
'' THE RULE IS POSITIONAL AND SHALLOW, which is what fbc's own headers document: a type
'' parameter is inferred from a procedure parameter DECLARED AS THAT NAME AND NOTHING
'' ELSE. 'byref v as T' infers T; 'byval p as T ptr' and 'byval o as Optional( of T )'
'' do not, because unifying through a decoration is a different feature and guessing at
'' it would instantiate at the wrong type silently.
''
'' Every parameter must come out with a type or this returns false and the call declines
'' -- a partly-inferred instantiation is a miscompile, not a partial answer.
'' THE TYPE ARGUMENTS OF AN INSTANTIATION, recovered from its structural name.
''
'' The name IS the key: InstantiateGeneric_ builds 'Box<6,9>' out of the generic's
'' spelling and the TypeIds of its arguments, so this is a DECODE of that encoding
'' rather than a guess -- the two belong together and must move together.
private function InstArgsOf_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byref outv as FB.Array( of ulong ) ) as boolean

    if t = Tko.TYPE_NONE then return false
    dim as Tko.TypeId ut = c.types->Unqualify( t )
    if c.types->Kind( ut ) <> Tko.TK_UDT then return false
    dim as string nm = c.names->Spelling( c.types->NameOf( ut ) )
    dim as long lt_ = instr( nm, "<" )
    if lt_ = 0 then return false
    if right( nm, 1 ) <> ">" then return false
    dim as string body = mid( nm, lt_ + 1, len( nm ) - lt_ - 1 )
    dim as long from = 1
    do
        dim as long comma = instr( from, body, "," )
        dim as string piece
        if comma = 0 then
            piece = mid( body, from )
        else
            piece = mid( body, from, comma - from )
        end if
        if len( trim( piece ) ) = 0 then return false
        outv.Push( cast( ulong, cast( long, val( piece ) ) ) )
        if comma = 0 then exit do
        from = comma + 1
    loop
    return (outv.Count > 0)
end function

private function InferProcTypeArgs_ _
    ( byref c as Ctx, byval callId as Tko.NodeId, byval gn as Tko.NodeId, _
      byval scope_ as Tko.ScopeId, byref outT as FB.Array( of ulong ) ) as boolean

    dim as Tko.StmtPayload ptr gp = StmtOf( c, gn )
    if gp->c = Tko.NODE_NONE then return false
    if c.ast->Kind( gp->c ) <> Tko.N_BLOCK then return false
    dim as Tko.ListPayload ptr gl = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, gp->c )].data )]
    if gl->count <= 0 then return false

    dim as Tko.ListPayload ptr cl = ListOf( c, callId )

    for g as long = 0 to gl->count - 1
        dim as Tko.NodeId gnm = cast( Tko.NodeId, c.ast->children[gl->first + g] )
        if c.ast->Kind( gnm ) <> Tko.N_IDENT then return false
        dim as Tko.InternId want = IdentNameOf( c, gnm )
        if want = 0 then return false

        dim as Tko.TypeId got = Tko.TYPE_NONE
        for k as long = 0 to gp->count - 1
            if k >= cl->count then exit for
            dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[gp->first + k] )
            if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
            dim as Tko.StmtPayload ptr pp = StmtOf( c, prm )
            if pp->a = Tko.NODE_NONE then continue for
            if c.ast->Kind( pp->a ) <> Tko.N_TYPEREF then continue for
            dim as Tko.AstNode ptr tn = @c.ast->nodes[cast( long, pp->a )]
            dim as Tko.StmtPayload ptr tp = StmtOf( c, pp->a )

            '' 'byval p as T ptr' -- A POINTER PARAMETER STILL NAMES T. Pointers were
            '' skipped outright with the array and procedure-type forms, so
            '' 'function Deref( of T )( byval p as T ptr ) as T' inferred NOTHING and
            '' never instantiated -- and the call went out as 'declare void DEREF()',
            '' a name with no body and no result, WITH NO DECLINE to say so.
            '' fbc emits '_Z5DerefIiEPi( &V$0 )' and the program prints ok.
            ''
            '' One level, and only for a bare 'T': the argument's own pointer is
            '' stripped and T binds to the POINTEE.
            '' A POINTER TYPE-REF WRAPS: the OUTER node carries NF_PTR and its 'a' is
            '' the pointee's own type-ref, so the name is one level in and not on the
            '' node the flag is on.
            dim as boolean isPtrParam = ((tn->flags and Tko.NF_PTR) <> 0)
            dim as Tko.InternId ptrName = 0
            if isPtrParam andalso (tp->a <> Tko.NODE_NONE) then
                if c.ast->Kind( tp->a ) = Tko.N_TYPEREF then
                    ptrName = StmtOf( c, tp->a )->name
                end if
            end if
            if isPtrParam andalso (ptrName = want) then
                dim as Tko.NodeId aNode = cast( Tko.NodeId, c.ast->children[cl->first + k] )
                dim as Tko.TypeId aT = InferArgType_( c, aNode, scope_ )
                if aT = Tko.TYPE_NONE then continue for
                dim as Tko.TypeId aU = c.types->Unqualify( aT )
                if c.types->Kind( aU ) = Tko.TK_REFERENCE then
                    aU = c.types->Unqualify( c.types->Inner( aU ) )
                end if
                if c.types->Kind( aU ) <> Tko.TK_POINTER then continue for
                dim as Tko.TypeId el = c.types->Inner( aU )
                if el = Tko.TYPE_NONE then continue for
                got = c.types->Unqualify( el )
                exit for
            end if
            if (tn->flags and (Tko.NF_PTR or Tko.NF_PROC_TYPE or Tko.NF_ARRAY)) <> 0 then
                continue for
            end if
            if tp->name <> want then
                '' 'byref dst as Box( of T )' -- THE PARAMETER IS AN INSTANTIATION and
                '' the type parameter is one of ITS arguments. Only a bare 'T' was
                '' matched, so every generic procedure written this way inferred
                '' nothing and declined -- fb/comptr.bi's ComQI and ComQIAs are both
                '' this shape, and they are what the whole com family asserts on.
                if tp->count <= 0 then continue for
                dim as long at_ = -1
                for j as long = 0 to tp->count - 1
                    dim as Tko.NodeId an2 = cast( Tko.NodeId, c.ast->children[tp->first + j] )
                    if c.ast->Kind( an2 ) <> Tko.N_TYPEREF then continue for
                    if StmtOf( c, an2 )->name = want then
                        at_ = j
                        exit for
                    end if
                next
                if at_ < 0 then continue for
                dim as Tko.TypeId argT = InferArgType_( c, _
                    cast( Tko.NodeId, c.ast->children[cl->first + k] ), scope_ )
                if argT = Tko.TYPE_NONE then continue for
                '' AN ARGUMENT THAT IS NOT AN INSTANTIATION AT ALL MAKES THE WHOLE
                '' INFERENCE FAIL, rather than moving on to the next parameter.
                ''
                '' fb/array.bi declares 'Contains( of T )( byref a as Array( of T ),
                '' byref v as T )' and fb/string.bi declares three concrete 'Contains'
                '' beside it. Skipping a parameter that could not match let T be
                '' inferred from the SECOND argument alone, so
                '' 'Contains( "hello", "ell" )' instantiated the array generic with
                '' T = string -- 'call void contains<15>( ... )', a result that went
                '' nowhere and a variable that was never stored. This parameter is
                '' written as an instantiation and the argument is not one: the
                '' candidate cannot apply, and saying so is what lets the concrete
                '' overloads be considered.
                dim as FB.Array( of ulong ) iargs
                if InstArgsOf_( c, argT, iargs ) = false then return false
                if at_ >= iargs.Count then return false
                got = cast( Tko.TypeId, iargs[at_] )
                if got <> Tko.TYPE_NONE then exit for
                continue for
            end if
            got = InferArgType_( c, cast( Tko.NodeId, c.ast->children[cl->first + k] ), _
                                 scope_ )
            if got <> Tko.TYPE_NONE then exit for
        next
        if got = Tko.TYPE_NONE then return false
        outT.Push( cast( ulong, got ) )
    next
    return true
end function

'' INSTANTIATE A GENERIC PROCEDURE -- 'Ok( of Decimal, FinanceError )( v )'.
''
'' The type arguments may be WRITTEN OUT or INFERRED from the call's arguments.
'' 'Some( r )' is the shape fb/optional.bi and fb/mathint.bi use everywhere -- a free
'' generic procedure exists precisely so T comes off the argument -- and declining it
'' cost 88 statements in every file that includes either header.
''
'' Same machinery as the TYPE half and for the same reason: SemanticInfo is keyed by
'' NodeId, so the body is RE-PARSED from the token range the parser recorded and the
'' fresh nodes are resolved with the parameters bound. What is patched is the NAME --
'' to a structural key over the argument list -- so two instantiations are two symbols
'' with two mangled names, and the call binds to the one it asked for.
''
'' Returns the instantiated symbol, or SYMBOL_NONE when this is not a generic call at
'' all -- which is every ordinary call, so it must be cheap to say no.
declare function InstantiateProcAt_ _
    ( byref c as Ctx, byval gn as Tko.NodeId, byval gsid as Tko.SymbolId, _
      byval gname as Tko.InternId, byref argTypes as FB.Array( of ulong ) ) as Tko.SymbolId


function InstantiateGenericProc_ _
    ( byref c as Ctx, byval callId as Tko.NodeId, byval scope_ as Tko.ScopeId ) as Tko.SymbolId

    if c.parser = 0 then return Tko.SYMBOL_NONE
    if c.ast->Kind( callId ) <> Tko.N_CALL then return Tko.SYMBOL_NONE
    dim as long taFirst, taCount
    dim as boolean written = c.ast->CallTypeArgsOf( callId, taFirst, taCount )

    dim as Tko.ListPayload ptr lp = ListOf( c, callId )
    dim as Tko.NodeId tgt = lp->target
    if tgt = Tko.NODE_NONE then return Tko.SYMBOL_NONE

    '' A QUALIFIED CALLEE IS STILL A CALLEE. 'NS.Mk( 5L )' names the generic through
    '' its NAMESPACE, so the target is an N_MEMBER and not an identifier -- and this
    '' refused it, so the generic was never instantiated. The call still went out, to a
    '' mangled name with no body behind it, or produced nothing at all where the result
    '' had to be a value.
    ''
    '' It is most of fb/optional.bi and fb/result.bi: every 'FB.Some( x )' in the
    '' shipped headers is written this way, and 'using FB' with the SAME call
    '' unqualified instantiated correctly -- which is what says the fault is here and
    '' not in the instantiation itself.
    ''
    '' The lookup starts from the QUALIFIER'S scope in that case, not from the call
    '' site's: 'NS.Mk' means the Mk in NS, and looking it up where the call sits would
    '' find a different one or none.
    dim as Tko.ScopeId lookScope = scope_
    dim as boolean qualified = false
    if c.ast->Kind( tgt ) = Tko.N_MEMBER then
        dim as Tko.BinaryPayload ptr qbp = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, tgt )].data )]
        if c.ast->Kind( qbp->lhs ) <> Tko.N_IDENT then return Tko.SYMBOL_NONE
        '' THE NAMESPACE'S OWN BINDING, which Resolve has already made -- and its
        '' member scope is 'inner', not 'payload'.
        dim as Tko.SymbolId nsid = c.info->RefOf( qbp->lhs )
        if nsid = Tko.SYMBOL_NONE then
            nsid = c.syms->Lookup( scope_, IdentNameOf( c, qbp->lhs ) )
        end if
        dim as Tko.Symbol ptr nss = c.syms->SymbolAt( nsid )
        if nss = 0 then return Tko.SYMBOL_NONE
        if nss->kind <> cast( ubyte, Tko.SYM_NAMESPACE ) then return Tko.SYMBOL_NONE
        lookScope = cast( Tko.ScopeId, nss->inner )
        tgt = qbp->rhs
        qualified = true
    end if
    if c.ast->Kind( tgt ) <> Tko.N_IDENT then return Tko.SYMBOL_NONE
    dim as Tko.InternId gname = IdentNameOf( c, tgt )
    if gname = 0 then return Tko.SYMBOL_NONE

    '' THE GENERIC'S OWN NODE, through its symbol. A name that resolves to something
    '' that is not a generic procedure is left alone -- 'Box( of long )' in expression
    '' position is a TYPE and takes the other path.
    '' A QUALIFIED NAME LOOKS ONLY IN THAT SCOPE: 'NS.Mk' means the Mk in NS, and
    '' walking outward from it would find a different one.
    dim as Tko.SymbolId gsid
    if qualified then
        gsid = c.syms->LookupLocal( lookScope, gname )
    else
        gsid = c.syms->Lookup( lookScope, gname )
    end if
    dim as Tko.Symbol ptr gs = c.syms->SymbolAt( gsid )
    if gs = 0 then return Tko.SYMBOL_NONE
    if gs->kind <> cast( ubyte, Tko.SYM_PROC ) then return Tko.SYMBOL_NONE
    dim as Tko.NodeId gn = cast( Tko.NodeId, gs->payload )
    if gn = Tko.NODE_NONE then return Tko.SYMBOL_NONE
    if c.ast->Kind( gn ) <> Tko.N_PROC then return Tko.SYMBOL_NONE
    dim as Tko.StmtPayload ptr gp = StmtOf( c, gn )
    if (gp->extra and Tko.PF_GENERIC_PROC) = 0 then return Tko.SYMBOL_NONE
    if gp->c = Tko.NODE_NONE then return Tko.SYMBOL_NONE
    if c.ast->Kind( gp->c ) <> Tko.N_BLOCK then return Tko.SYMBOL_NONE
    dim as Tko.ListPayload ptr pl = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, gp->c )].data )]
    if written andalso (pl->count <> taCount) then return Tko.SYMBOL_NONE

    '' THE ARGUMENTS, resolved where they were written -- or inferred from the call's
    '' own arguments where they were not. One that does not resolve means no
    '' instantiation rather than a wrong one -- the call then declines, which is the
    '' honest outcome and the same rule the type half uses.
    dim as FB.Array( of ulong ) argTypes
    if written then
        for i as long = 0 to taCount - 1
            dim as Tko.NodeId an = cast( Tko.NodeId, c.ast->children[taFirst + i] )
            dim as Tko.TypeId at = ResolveTypeRef( c, an, scope_ )
            if at = Tko.TYPE_NONE then return Tko.SYMBOL_NONE
            argTypes.Push( cast( ulong, at ) )
        next
    else
        if InferProcTypeArgs_( c, callId, gn, scope_, argTypes ) = false then
            return Tko.SYMBOL_NONE
        end if
        taCount = cast( long, argTypes.Count )
        if pl->count <> taCount then return Tko.SYMBOL_NONE
    end if

    return InstantiateProcAt_( c, gn, gsid, gname, argTypes )
end function

'' The second half of the above, reached by TWO callers: a call that names a generic
'' procedure, and a generic GLOBAL OPERATOR being instantiated alongside the generic
'' TYPE it is written over. Everything from the cache key down is the same work.
function InstantiateProcAt_ _
    ( byref c as Ctx, byval gn as Tko.NodeId, byval gsid as Tko.SymbolId, _
      byval gname as Tko.InternId, byref argTypes as FB.Array( of ulong ) ) as Tko.SymbolId

    dim as Tko.Symbol ptr gs = c.syms->SymbolAt( gsid )
    if gs = 0 then return Tko.SYMBOL_NONE
    dim as long taCount = cast( long, argTypes.Count )

    '' THE GENERIC'S OWN SYMBOL IS PART OF THE KEY. Name plus type arguments is not
    '' enough: fb/comptr.bi declares TWO global 'operator ->', one over ComPtr and one
    '' over ComQIPtr, and at the same T they produce the same "-><5100>". ComPtr's
    '' instantiated first and claimed it, so the lookup below handed ComQIPtr's
    '' instantiation back the WRONG operator -- 'b->PokeB( )' over a ComQIPtr found no
    '' arrow of its own, the member access stayed untyped, and the statement declined.
    '' fbc emits both: _ZptR8ComPtrI6IFAKEBE and _ZptR8ComQIPtrI6IFAKEBE.
    ''
    '' Two CALL SITES naming the same instantiation still meet at one symbol, which is
    '' what the cache is for -- they reach it through the same generic.
    dim as string key = c.names->Spelling( gname ) & "<"
    for i as long = 0 to taCount - 1
        if i > 0 then key += ","
        key += str( cast( long, argTypes[i] ) )
    next
    key += ">"

    '' CACHED, in the scope the generic itself lives in. Two call sites naming the same
    '' instantiation must reach ONE function, or the module would carry two definitions
    '' of it under one mangled name.
    dim as Tko.InternId inm = c.names->Fold( c.names->GetString( key ) )
    dim as Tko.ScopeId home = gs->parent
    if home = Tko.SCOPE_NONE then home = Tko.SCOPE_GLOBAL

    '' LOOKED UP BY A KEY THAT NAMES THE GENERIC, not by the instantiation's NAME.
    '' Name plus type arguments is not enough to tell two generics apart: fb/comptr.bi
    '' declares TWO global 'operator ->', one over ComPtr and one over ComQIPtr, and at
    '' the same T both spell "-><5100>". ComPtr's instantiated first and claimed the
    '' name, so ComQIPtr's lookup found it and returned the WRONG operator -- and
    '' 'b->PokeB( )' over a ComQIPtr then had no arrow of its own, the member access
    '' stayed untyped, and the statement declined. fbc emits both:
    '' _ZptR8ComPtrI6IFAKEBE and _ZptR8ComQIPtrI6IFAKEBE.
    ''
    '' The gsid goes in the KEY and not in the name, because the NAME IS MANGLED: put
    '' it there and every instantiated generic came out as "MK#11<8>" where fbc writes
    '' "MK<8>", which the mangle gate and four goldens said at once. Two SYM_PROCs of
    '' one name in one scope chain as overloads, so the two arrows coexist.
    dim as Tko.InternId ikey = _
        c.names->Fold( c.names->GetString( key & "#" & str( cast( long, gsid ) ) ) )
    for i as long = 0 to cast( long, c.procInstKey.Count ) - 1
        if cast( Tko.InternId, c.procInstKey[i] ) = ikey then
            return cast( Tko.SymbolId, c.procInstSym[i] )
        end if
    next

    '' The symbol is DECLARED NOW and its body filled in by the deferred pass, so a
    '' recursive generic -- one whose body calls itself at the same arguments -- finds
    '' this rather than instantiating for ever.
    dim as boolean idup = false
    dim as Tko.SymbolId isid = c.syms->DeclareSym( home, inm, Tko.SYM_PROC, _
        c.ast->Loc( gn ), idup )
    if isid = Tko.SYMBOL_NONE then return Tko.SYMBOL_NONE
    c.procInstKey.Push( cast( ulong, ikey ) )
    c.procInstSym.Push( cast( ulong, isid ) )

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
    dim as Tko.ParserState ptr p0 = cast( Tko.ParserState ptr, c.parser )
    if p0->toks = 0 then return

    while c.pendProcDone < c.pendProc.Count
        dim as long i = c.pendProcDone
        c.pendProcDone += 6
        dim as Tko.NodeId gn = cast( Tko.NodeId, c.pendProc[i] )
        dim as Tko.SymbolId isid = cast( Tko.SymbolId, c.pendProc[i + 1] )
        dim as Tko.InternId inm = cast( Tko.InternId, c.pendProc[i + 2] )
        dim as Tko.ScopeId home = cast( Tko.ScopeId, c.pendProc[i + 3] )
        dim as long argFirst = cast( long, c.pendProc[i + 4] )
        dim as long argCount = cast( long, c.pendProc[i + 5] )

        dim as long t0, t1
        if c.ast->TokensOf( gn, t0, t1 ) = false then continue while

        '' The parameters bind for as long as the fresh nodes are being resolved.
        dim as long gmark = c.gparamName.Count
        dim as Tko.StmtPayload ptr gp = StmtOf( c, gn )
        if gp->c <> Tko.NODE_NONE then
            if c.ast->Kind( gp->c ) = Tko.N_BLOCK then
                dim as Tko.ListPayload ptr pl = _
                    @c.ast->lists[cast( long, c.ast->nodes[cast( long, gp->c )].data )]
                for k as long = 0 to argCount - 1
                    if k >= pl->count then exit for
                    dim as Tko.NodeId pn = cast( Tko.NodeId, c.ast->children[pl->first + k] )
                    if c.ast->Kind( pn ) <> Tko.N_IDENT then continue for
                    dim as Tko.IdentPayload ptr pip = _
                        @c.ast->idents[cast( long, c.ast->nodes[cast( long, pn )].data )]
                    c.gparamName.Push( cast( ulong, pip->name ) )
                    c.gparamType.Push( c.pendProcArgs[argFirst + k] )
                next
            end if
        end if

        dim as Tko.ParserState q
        q.toks = p0->toks
        q.stream = 0
        q.litPool = p0->litPool
        q.ast = c.ast
        q.src = c.srcMgr
        q.names = c.names
        q.diags = c.diags
        q.pos = t0
        q.silent = true
        '' SEEDED AND WRITTEN BACK, so a lambda in this body gets a name no other
        '' instantiation of the same generic can produce. The re-parse is a fresh
        '' ParserState whose counter would otherwise start at zero every time, and
        '' every instantiation would hoist a procedure called __tko_lambda_<hash>_0.
        q.lambdaSeq = p0->lambdaSeq

        dim as Tko.NodeId fresh = Tko.Parse.Statement( q )
        p0->lambdaSeq = q.lambdaSeq
        if (fresh <> Tko.NODE_NONE) andalso (c.ast->Kind( fresh ) = Tko.N_PROC) then
            dim as Tko.StmtPayload ptr fp = StmtOf( c, fresh )
            '' THE NAME IS THE STRUCTURAL KEY, and the generic flag comes OFF -- this
            '' one is a concrete procedure now, and leaving the flag on would make
            '' lowering decline the very body that was just built for it.
            fp->name = inm
            fp->rawName = inm
            fp->extra and= not Tko.PF_GENERIC_PROC
            fp->c = Tko.NODE_NONE

            '' A LAMBDA WRITTEN INSIDE A GENERIC BODY is hoisted by the RE-PARSE, into
            '' the re-parse's own ParserState -- which is a local here, so the
            '' procedure was built, named, and then dropped on the floor. Its body
            '' names the generic's type parameters, which is exactly why it cannot be
            '' hoisted once at module level with the original: the parameters are bound
            '' only for the length of this instantiation.
            ''
            '' fb/sort.bi declares its comparator that way in all four of Sort,
            '' SortDesc, IsSorted and IsSortedDesc -- 'dim as function( byref as T,
            '' byref as T ) as boolean less = function( ... ) return x < y end
            '' function' -- so every sort in the corpus lowered a comparator whose
            '' body produced nothing.
            ''
            '' Collected BEFORE the body that names them, so '@__tko_lambda_...'
            '' resolves; walked after, with the generic's parameters still bound.
            for li as long = 0 to q.lambdas.Count - 1
                dim as Tko.NodeId lam = cast( Tko.NodeId, q.lambdas[li] )
                '' CONCRETE now, like the body it came out of: the re-parse marked it
                '' a template because the enclosing generic header is still spelled
                '' '( of T )', and lowering skips anything carrying that.
                StmtOf( c, lam )->extra and= not Tko.PF_GENERIC_PROC
                c.ast->extraTopLevel.Push( cast( ulong, lam ) )
                c.info->Resize( c.ast->Count( ) )
                Tko.Collect.One( *c.ast, lam, home, *c.syms, *c.names, *c.types, _
                                 *c.diags, *c.info )
            next

            c.ast->extraTopLevel.Push( cast( ulong, fresh ) )
            c.info->Resize( c.ast->Count( ) )
            Tko.Collect.One( *c.ast, fresh, home, *c.syms, *c.names, *c.types, _
                             *c.diags, *c.info )
            '' THE BODY IS WALKED FIRST, and the hoisted lambdas after it.
            ''
            '' A CAPTURING lambda's closure TYPE is synthesised when the N_CLOSURE
            '' node inside the body is walked -- that is the only point where the
            '' captured names are in scope -- and the hoisted invoke procedure's
            '' prologue reads that type's '__CAP_' fields through its own receiver.
            '' Walked first, the invoke body named a type that did not exist yet, so
            '' every 'var byref <name> = *__tko_cl.__CAP_<NAME>' had no reference to
            '' bind and the body that used it declined with it:
            ''
            ''     sub[ byref total, byval bias ]( byval v as long )
            ''         total = v + bias
            ''     end sub
            ''
            '' -- inside a generic. The same lambda written in an ORDINARY procedure
            '' lowered, which is what says the shape is fine and only the order was
            '' wrong. COLLECT still runs lambdas-first: '@__tko_lambda_...' in the
            '' body has to resolve, and that needs the symbol, not the walk.
            WalkStmt( c, fresh, home )
            for li as long = 0 to q.lambdas.Count - 1
                WalkStmt( c, cast( Tko.NodeId, q.lambdas[li] ), home )
            next
            '' Collect declares its own symbol for a fresh unqualified definition, and
            '' that one carries the node. The symbol the CALL SITE was given is the one
            '' declared before the body existed, so it is pointed at the same node here
            '' -- without this the call mangles against a symbol with no payload and
            '' comes out as the bare source spelling.
            dim as Tko.Symbol ptr isym = c.syms->SymbolAt( isid )
            dim as Tko.SymbolId made = c.syms->LookupLocal( home, inm )
            dim as Tko.Symbol ptr msym = c.syms->SymbolAt( made )
            if (isym <> 0) andalso (msym <> 0) then
                if isym->payload = 0 then isym->payload = msym->payload
                if isym->type_ = Tko.TYPE_NONE then isym->type_ = msym->type_
                isym->inner = msym->inner
                isym->flags or= Tko.SYMF_DEFINED
            end if
        end if

        while c.gparamName.Count > gmark
            c.gparamName.Pop( )
            c.gparamType.Pop( )
        wend
    wend
end sub

declare function TypeMemberNamed_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byref nm as string ) as Tko.SymbolId

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
    ( byref c as Ctx, byval seqT as Tko.TypeId ) as Tko.TypeId

    dim as Tko.SymbolId gi = TypeMemberNamed_( c, seqT, "getiterator" )
    dim as Tko.Symbol ptr gs = c.syms->SymbolAt( gi )
    if gs = 0 then return Tko.TYPE_NONE
    if gs->type_ = Tko.TYPE_NONE then return Tko.TYPE_NONE
    dim as Tko.SymbolId vo = TypeMemberNamed_( c, gs->type_, "value" )
    dim as Tko.Symbol ptr vs = c.syms->SymbolAt( vo )
    if vs = 0 then return Tko.TYPE_NONE
    return vs->type_
end function

'' A member of a UDT by name, folded.
private function TypeMemberNamed_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byref nm as string ) as Tko.SymbolId

    if t = Tko.TYPE_NONE then return Tko.SYMBOL_NONE
    '' A BYREF PARAMETER IS A REFERENCE TO THE TYPE, not the type. 'for each e in a'
    '' over a 'byref a as Array( of T )' found no members at all, so the loop variable
    '' stayed untyped and its every use declined -- while the same loop over a LOCAL
    '' container lowered. fbc's own stats.bi takes its containers byref, which is what
    '' a container-taking procedure does.
    t = c.types->Unqualify( t )
    if c.types->Kind( t ) = Tko.TK_REFERENCE then
        t = c.types->Unqualify( c.types->Inner( t ) )
    end if
    if c.types->Kind( t ) <> Tko.TK_UDT then return Tko.SYMBOL_NONE
    dim as Tko.InternId tn = c.types->NameOf( t )
    if tn = 0 then return Tko.SYMBOL_NONE
    dim as Tko.ScopeId ds = cast( Tko.ScopeId, c.types->DeclScopeOf( t ) )
    dim as Tko.SymbolId ts = c.syms->LookupLocalTyped( ds, tn, true )
    if ts = Tko.SYMBOL_NONE then ts = c.syms->LookupTyped( ds, tn, true )
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( ts )
    if s = 0 then return Tko.SYMBOL_NONE
    if s->inner = Tko.SCOPE_NONE then return Tko.SYMBOL_NONE
    return c.syms->LookupLocal( s->inner, c.names->Fold( c.names->GetString( nm ) ) )
end function

'' The enclosing NAMESPACE and TYPE names of a scope, outermost first, each followed by
'' '#'. Empty at global or module scope.
''
'' Built from the SCOPE CHAIN rather than from any spelling, which is the whole point:
'' one generic has one qualifier however a use site chose to write it.
function QualifierPrefix_( byref c as Ctx, byval sc as Tko.ScopeId ) as string
    dim as string parts
    dim as Tko.ScopeId cur = sc
    dim as long guard = 0
    while (cur <> Tko.SCOPE_NONE) andalso (guard < 32)
        guard += 1
        dim as Tko.SymScope ptr s = c.syms->ScopeAt( cur )
        if s = 0 then exit while
        dim as Tko.Symbol ptr o = c.syms->SymbolAt( s->owner )
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
    ( byref c as Ctx, byval id as Tko.NodeId, byval here as Tko.ScopeId )
    dim as Tko.ListPayload ptr lp = ListOf( c, id )
    dim as long lfirst = lp->first
    dim as long lcount = lp->count
    for i as long = 0 to lcount - 1
        WalkStmt( c, cast( Tko.NodeId, c.ast->children[lfirst + i] ), here )
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
    ( byref c as Ctx, byref ast as Tko.AstArena, byval root as Tko.NodeId, _
      byref diags as Tko.DiagnosticEngine, byref info as Tko.SemanticInfo )

    if HasGenericDecl_( c ) = false then return

    dim as long dpend = diags.pending.Count
    dim as long derr = diags.errors
    dim as long dwarn = diags.warnings
    dim as long dsupp = diags.suppressedCount
    WalkStmt( c, root, Tko.SCOPE_GLOBAL )
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
        dim as Tko.NodeId n = cast( Tko.NodeId, c.ast->tokenRanges[i] )
        if c.ast->Kind( n ) = Tko.N_TYPE then return true
        '' A GENERIC PROCEDURE counts too, and it need not be inside a generic type --
        '' 'function Ok( of T, E )( ... )' is one on its own, and fb/result.bi is
        '' nothing but those.
        if c.ast->Kind( n ) = Tko.N_PROC then
            if (StmtOf( c, n )->extra and Tko.PF_GENERIC_PROC) <> 0 then return true
        end if
    next
    return false
end function


'' A GENERIC GLOBAL OPERATOR IS INSTANTIATED WITH THE TYPE IT IS WRITTEN OVER.
''
''     operator -> ( of T )( byref p as SharedPtr( of T ) ) byref as T
''     operator +  ( of T )( byref a as Box( of T ), byref b as Box( of T ) ) as Box( of T )
''
'' are part of the type's interface and are declared beside it, but they are NOT members
'' -- fbc refuses a member arithmetic operator -- so InstantiateMembers_ never saw them
'' and nothing else ever did either. The result was that overload resolution costed the
'' UNINSTANTIATED parameter, 'Box( of T )', against the concrete 'Box( of long )', found
'' no candidate, and left the expression untyped; lowering then added the two objects as
'' raw integers. 542 corpus statements.
''
'' Instantiating a call's generic PROCEDURE cannot serve here: that is driven by an
'' N_CALL with arguments to infer from, and an operator has neither -- what it has is a
'' PARAMETER PATTERN naming the generic. So the trigger is the TYPE's instantiation, and
'' the arguments are that instantiation's own.
''
'' The match is deliberately narrow: the same number of type parameters, and a FIRST
'' parameter whose type reference names this generic. An operator over some other
'' generic in the same file is not instantiated here.
private sub InstantiateGlobalOpsFor_ _
    ( byref c as Ctx, byval gname as Tko.InternId, byval scope_ as Tko.ScopeId, _
      byval argFirst as long, byval argCount as long )

    if argCount <= 0 then return
    dim as long n0 = c.ast->tokenRanges.Count
    for i as long = 0 to n0 - 3 step 3
        dim as Tko.NodeId dn = cast( Tko.NodeId, c.ast->tokenRanges[i] )
        if c.ast->Kind( dn ) <> Tko.N_PROC then continue for
        dim as Tko.StmtPayload ptr dp = StmtOf( c, dn )
        if (dp->extra and Tko.PF_GENERIC_PROC) = 0 then continue for
        if dp->op <> cast( ushort, Tko.KW_OPERATOR ) then continue for
        if dp->ownerName <> 0 then continue for

        '' The same arity of type parameters, or the arguments do not fit.
        if dp->c = Tko.NODE_NONE then continue for
        if c.ast->Kind( dp->c ) <> Tko.N_BLOCK then continue for
        dim as Tko.ListPayload ptr tl = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, dp->c )].data )]
        if tl->count <> argCount then continue for

        '' ...and a first parameter that names THIS generic.
        dim as boolean overThis = false
        for k as long = 0 to dp->count - 1
            dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[dp->first + k] )
            if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
            dim as Tko.NodeId tn = StmtOf( c, prm )->a
            if tn <> Tko.NODE_NONE then
                if c.ast->Kind( tn ) = Tko.N_TYPEREF then
                    overThis = (StmtOf( c, tn )->name = gname)
                end if
            end if
            exit for
        next
        if overThis = false then continue for

        '' Its own symbol, found by walking the operator name's overload chain for the
        '' one whose payload is THIS node: an operator name carries several.
        dim as Tko.SymbolId osid = c.syms->Lookup( scope_, dp->name )
        dim as Tko.SymbolId found = Tko.SYMBOL_NONE
        while osid <> Tko.SYMBOL_NONE
            dim as Tko.Symbol ptr os = c.syms->SymbolAt( osid )
            if os = 0 then exit while
            if cast( Tko.NodeId, os->payload ) = dn then
                found = osid
                exit while
            end if
            osid = os->nextOverload
        wend
        if found = Tko.SYMBOL_NONE then continue for

        dim as FB.Array( of ulong ) argTypes
        for k as long = 0 to argCount - 1
            argTypes.Push( c.pendInstArgs[argFirst + k] )
        next
        dim as Tko.SymbolId isid = InstantiateProcAt_( c, dn, found, dp->name, argTypes )
        '' ...and reachable under the OPERATOR'S OWN SPELLING, which is what overload
        '' resolution looks up. Declared under its structural key alone, the
        '' instantiation existed and nothing could find it.
        if isid <> Tko.SYMBOL_NONE then
            dim as Tko.Symbol ptr gsy = c.syms->SymbolAt( found )
            if gsy <> 0 then c.syms->ChainOverload( gsy->parent, dp->name, isid )
        end if
    next
end sub

sub InstantiatePending_( byref c as Ctx )
    '' Drained rather than iterated: a member body may name another generic, and
    '' resolving it appends here. The count is re-read every time round.
    while c.pendDone < c.pendInst.Count
        dim as long i = c.pendDone
        c.pendDone += 7
        InstantiateMembers_( c, cast( Tko.NodeId, c.pendInst[i] ), _
                             cast( Tko.InternId, c.pendInst[i + 1] ), _
                             cast( Tko.InternId, c.pendInst[i + 2] ), _
                             cast( Tko.ScopeId, c.pendInst[i + 3] ), _
                             cast( Tko.ScopeId, c.pendInst[i + 4] ), _
                             cast( long, c.pendInst[i + 5] ), _
                             cast( long, c.pendInst[i + 6] ) )
        InstantiateGlobalOpsFor_( c, cast( Tko.InternId, c.pendInst[i + 1] ), _
                                  cast( Tko.ScopeId, c.pendInst[i + 4] ), _
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
    ( byref c as Ctx, byval gnode as Tko.NodeId, byval gname as Tko.InternId, _
      byval inm as Tko.InternId, byval iin as Tko.ScopeId, byval scope_ as Tko.ScopeId, _
      byval argFirst as long, byval argCount as long )

    if c.parser = 0 then return
    dim as Tko.ParserState ptr p0 = cast( Tko.ParserState ptr, c.parser )
    if p0->toks = 0 then return

    '' The table is scanned to its length AS IT IS NOW. Resolving one member may
    '' instantiate another generic, which appends -- and those entries belong to that
    '' generic, not this one. Taking the count first keeps this loop over its own work.
    '' THE TYPE PARAMETERS, bound again. They were popped when the type half finished,
    '' and the member signatures -- 'byval x as T' -- are what needs them.
    dim as long gmark = c.gparamName.Count
    dim as Tko.StmtPayload ptr gp = StmtOf( c, gnode )
    if gp->b <> Tko.NODE_NONE then
        if c.ast->Kind( gp->b ) = Tko.N_BLOCK then
            dim as Tko.ListPayload ptr pl = _
                @c.ast->lists[cast( long, c.ast->nodes[cast( long, gp->b )].data )]
            for i as long = 0 to argCount - 1
                if i >= pl->count then exit for
                dim as Tko.NodeId pn = cast( Tko.NodeId, c.ast->children[pl->first + i] )
                if c.ast->Kind( pn ) <> Tko.N_IDENT then continue for
                dim as Tko.IdentPayload ptr pip = _
                    @c.ast->idents[cast( long, c.ast->nodes[cast( long, pn )].data )]
                c.gparamName.Push( cast( ulong, pip->name ) )
                c.gparamType.Push( c.pendInstArgs[argFirst + i] )
            next
        end if
    end if

    dim as long n0 = c.ast->tokenRanges.Count
    for i as long = 0 to n0 - 3 step 3
        dim as Tko.NodeId dn = cast( Tko.NodeId, c.ast->tokenRanges[i] )
        if c.ast->Kind( dn ) <> Tko.N_PROC then continue for
        dim as Tko.StmtPayload ptr dp = StmtOf( c, dn )
        '' A GENERIC'S CONSTRUCTOR AND DESTRUCTOR NAME THE TYPE, WITH NO DOT --
        '' 'constructor G( of T )( )' -- so the parser records no ownerName for one
        '' and this filter threw every structor away. An ordinary member is written
        '' 'function G( of T ).Get( )', HAS the dot, and passed; that is why member
        '' functions instantiated and structors did not.
        ''
        '' Nothing then declared __ctor or __dtor in the instantiation's scope, so
        '' StructorOf found none and every caller concluded the type had none: a
        '' 'dim' of a generic ran no constructor, an initialiser copied the bytes
        '' instead of calling the copy constructor, and scope exit ran no destructor.
        '' Silently -- it lowered and it verified.
        ''
        '' That is ComPtr's and SharedPtr's refcounting, LinkedList's teardown and
        '' Channel's reference count, none of which were running.
        dim as boolean isStructor = _
            (dp->op = cast( ushort, Tko.KW_CONSTRUCTOR )) orelse _
            (dp->op = cast( ushort, Tko.KW_DESTRUCTOR ))
        dim as boolean mine = (dp->ownerName = gname)
        if mine = false then
            if isStructor then mine = (dp->name = gname)
        end if
        if mine = false then continue for
        if dp->b = Tko.NODE_NONE then continue for

        '' A PARSER OF ITS OWN over the same buffer. The stream is deliberately NOT
        '' carried across: the preprocessor was closed when the unit finished, and the
        '' range being re-read is already buffered, so nothing may try to pull more.
        dim as Tko.ParserState q
        q.toks = p0->toks
        q.stream = 0
        q.litPool = p0->litPool
        q.ast = c.ast
        q.src = c.srcMgr
        q.names = c.names
        q.diags = c.diags
        q.pos = cast( long, c.ast->tokenRanges[i + 1] )
        q.silent = true
        q.lambdaSeq = p0->lambdaSeq

        dim as Tko.NodeId fresh = Tko.Parse.Statement( q )
        p0->lambdaSeq = q.lambdaSeq
        if fresh = Tko.NODE_NONE then continue for
        if c.ast->Kind( fresh ) <> Tko.N_PROC then continue for

        dim as Tko.StmtPayload ptr fp2 = StmtOf( c, fresh )
        fp2->ownerName = inm
        '' A STRUCTOR NAMES ITS TYPE IN 'name', not in 'ownerName' -- there is no
        '' dot, so that is where the parser puts it and where Collect reads the
        '' owner from. Left as the GENERIC's name it was collected as a plain
        '' module-level procedure called 'G', which is what the emitted 'func void
        '' G(...)' was: three real bodies under a name no instantiation could call.
        select case cast( Tko.TokenKind, fp2->op )
        case Tko.KW_CONSTRUCTOR, Tko.KW_DESTRUCTOR
            '' ...and its ownerName goes back to NOTHING, because Collect reads a
            '' structor's owner as 'ownerName & "." & name' when both are set --
            '' 'ns.UDT' for 'constructor ns.UDT( )'. Leaving both would ask for a type
            '' called 'g<6>.g<6>'.
            fp2->name = inm
            fp2->ownerName = 0
        end select
        '' THE GENERIC-PROCEDURE FLAG COMES OFF. Every out-of-line member of a generic
        '' is spelled 'function Array( of T ).Count( )', so the parser's '( of ... )'
        '' branch marks it PF_GENERIC_PROC -- and lowering skips anything carrying that
        '' as a template. The instantiated body is a concrete procedure; leaving the
        '' flag on meant every one was declared, called, and never emitted.
        fp2->extra and= not Tko.PF_GENERIC_PROC
        dim as Tko.InternId mname = fp2->name
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
        '' A STRUCTOR NEEDS ONE SYMBOL PER OVERLOAD, and that is what this gives it.
        '' Collect attaches a ctor DEFINITION to whatever 'LookupLocal' answers for
        '' '__ctor', which is right when the TYPE declares one -- the declarations
        '' inside a type carry the signatures and the definitions attach to them. An
        '' INSTANTIATION'S scope has no such declarations: InstantiateGeneric_ mirrors
        '' only the fields. So every definition collapsed onto the first symbol, the
        '' chain was one long, and 'G( of long )( 7 )' resolved to the DEFAULT
        '' constructor and dropped the 7.
        ''
        '' Declared here with the FRESH node as the payload, exactly as an ordinary
        '' member is, each overload keeps its own signature and its own mangled name.
        dim as Tko.InternId declNm = mname
        select case cast( Tko.TokenKind, mop )
        case Tko.KW_CONSTRUCTOR
            declNm = c.names->Fold( c.names->GetString( "__ctor" ) )
        case Tko.KW_DESTRUCTOR
            declNm = c.names->Fold( c.names->GetString( "__dtor" ) )
        end select
        select case cast( Tko.TokenKind, mop )
        case else
            mname = declNm
            if mname <> 0 then
                dim as boolean mdup = false
                dim as Tko.SymbolId msid = c.syms->DeclareSym( iin, mname, _
                    Tko.SYM_PROC, c.ast->Loc( fresh ), mdup )
                dim as Tko.Symbol ptr msym = c.syms->SymbolAt( msid )
                if msym <> 0 then
                    '' THE FRESH NODE IS THE PAYLOAD. Every call site mangles against
                    '' whatever node the symbol points at, and a symbol with none
                    '' mangles to its bare source spelling -- 'call void put(...)',
                    '' which links to nothing. It is also what carries the signature,
                    '' and this instantiation's signature is on this instantiation's
                    '' own node, not the generic's.
                    msym->payload = cast( long, fresh )
                    msym->flags or= Tko.SYMF_DEFINED
                end if
            end if
        end select

        '' The unit's root block was closed when it was parsed, so this node is not
        '' reachable from it. Later passes walk extraTopLevel to find it; without that
        '' it would be collected, resolved, typed -- and never emitted.
        '' The same lambda hoist the procedure half does, and for the same reason: the
        '' re-parse owns the procedures it hoists and this ParserState is a local.
        for li as long = 0 to q.lambdas.Count - 1
            dim as Tko.NodeId lam = cast( Tko.NodeId, q.lambdas[li] )
            StmtOf( c, lam )->extra and= not Tko.PF_GENERIC_PROC
            c.ast->extraTopLevel.Push( cast( ulong, lam ) )
            c.info->Resize( c.ast->Count( ) )
            Tko.Collect.One( *c.ast, lam, scope_, *c.syms, *c.names, *c.types, _
                             *c.diags, *c.info )
        next

        c.ast->extraTopLevel.Push( cast( ulong, fresh ) )
        c.info->Resize( c.ast->Count( ) )
        Tko.Collect.One( *c.ast, fresh, scope_, *c.syms, *c.names, *c.types, _
                         *c.diags, *c.info )
        '' BODY FIRST, then its lambdas -- the same order and the same reason as in
        '' InstantiatePendingProcs_ above: a capturing lambda's closure type is
        '' synthesised by the walk of the N_CLOSURE node inside the body.
        WalkStmt( c, fresh, scope_ )
        for li as long = 0 to q.lambdas.Count - 1
            WalkStmt( c, cast( Tko.NodeId, q.lambdas[li] ), scope_ )
        next
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
            dim as Tko.NodeId id = cast( Tko.NodeId, c.typedefNode[i] )
            dim as Tko.ScopeId here = cast( Tko.ScopeId, c.typedefScope[i] )
            dim as Tko.StmtPayload ptr tsp = StmtOf( c, id )
            if tsp->name = 0 then continue for
            dim as Tko.Symbol ptr ts = _
                c.syms->SymbolAt( c.syms->LookupLocalTyped( here, tsp->name, true ) )
            if ts = 0 then continue for
            if ts->kind <> cast( ubyte, Tko.SYM_TYPEDEF ) then continue for
            dim as Tko.TypeId al = ResolveTypeRef( c, tsp->a, here )
            if (al = Tko.TYPE_NONE) orelse (al = ts->type_) then continue for
            ts->type_ = al
            progress = true
        next
        if progress = false then exit for
    next

    for i as long = 0 to c.pendingItem.Count - 1
        dim as Tko.NodeId item = cast( Tko.NodeId, c.pendingItem[i] )
        dim as Tko.ScopeId here = cast( Tko.ScopeId, c.pendingScope[i] )
        dim as Tko.StmtPayload ptr ip = StmtOf( c, item )
        dim as Tko.TypeId t = ResolveTypeRef( c, ip->a, here )
        if t = Tko.TYPE_NONE then continue for
        BindDeclType( c, here, ip->name, _
            ArrayFromBoundsNode( c, t, ip->c, ip->b, here ), true )
    next
end sub

'' N_VAR_ITEM: an N_BLOCK of N_CASE_RANGE, one per dimension.
function ArrayFromBoundsNode _
    ( byref c as Ctx, byval base_ as Tko.TypeId, byval id as Tko.NodeId, _
      byval init as Tko.NodeId = Tko.NODE_NONE, _
      byval scope_ as Tko.ScopeId = Tko.SCOPE_NONE ) as Tko.TypeId

    if id = Tko.NODE_NONE then return base_
    if c.ast->Kind( id ) <> Tko.N_BLOCK then return base_
    dim as Tko.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    dim as FB.Array( of ulong ) los, his
    for i as long = 0 to lp->count - 1
        dim as Tko.NodeId d = cast( Tko.NodeId, c.ast->children[lp->first + i] )
        if c.ast->Kind( d ) = Tko.N_CASE_RANGE then
            '' 'a(0 to 9)' -- both bounds written out.
            dim as Tko.StmtPayload ptr dp = StmtOf( c, d )
            los.Push( cast( ulong, dp->a ) )
            his.Push( cast( ulong, dp->b ) )
        else
            '' 'a(9)' -- a bare expression, which is the UPPER bound with an implicit
            '' lower bound of 0. It is not an N_CASE_RANGE at all, so a loop that only
            '' accepts one silently gives the array no dimensions and drops it back to
            '' its element type.
            los.Push( cast( ulong, Tko.NODE_NONE ) )
            his.Push( cast( ulong, d ) )
        end if
    next
    return ArrayFromPairs( c, base_, los, his, init, true, scope_ )
end function

'' 'init' is the declaration's initializer, or NODE_NONE. It is needed because an
'' ellipsis bound takes its size from there and from nowhere else -- fbc refuses
'' 'dim a(0 to ...)' with no initializer outright (error 281).
''
'' Getting this wrong would not be a decline. An unknown bound makes this return the
'' ELEMENT type, so the array becomes eight bytes where twenty-four were needed and
'' nothing says so -- which is exactly what parsing '...' without inferring it did.
'' 'scope_' IS WHAT LETS A NAMED CONSTANT BE A BOUND. ConstOf returns "unknown" for
'' every N_IDENT when it is handed no symbol table -- its first line is 'if syms = 0
'' then return CVNone_( )' -- so 'const N = 2 : dim a(0 to N)' had an unknown bound and
'' fell to DynArrayOf below. That is not a decline: it made 'a' a 72-byte DESCRIPTOR
'' that NOTHING EVER INITIALISES, so every element access dereferenced a garbage data
'' pointer, with 0 statements not lowered and verify ok. fbc writes 'static int32
'' T$[3];' and, run, prints ' 0 2 10 20 30' for lbound/ubound and the three elements.
function ArrayFromPairs _
    ( byref c as Ctx, byval base_ as Tko.TypeId, _
      byref los as FB.Array( of ulong ), byref his as FB.Array( of ulong ), _
      byval init as Tko.NodeId = Tko.NODE_NONE, _
      byval emptyIsDynamic as boolean = false, _
      byval scope_ as Tko.ScopeId = Tko.SCOPE_NONE ) as Tko.TypeId

    dim as Tko.ScopeId cscope = scope_
    if cscope = Tko.SCOPE_NONE then cscope = Tko.SCOPE_GLOBAL

    if base_ = Tko.TYPE_NONE then return base_

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

    '' A LONGINT, and that is not caution. 'dim as byte t(0 to &h7FFFFFFF)' is
    '' 2147483648 elements, which overflowed a LONG to a negative -- and the
    '' 'total <= 0' test below then turned the whole declaration into a DYNAMIC
    '' array, silently. fbc says error 50, 'Array too big'.
    dim as longint total = 1
    dim as boolean known = true
    dim as FB.Array( of longint ) bounds
    for i as long = 0 to los.Count - 1
        dim as longint lo = 0
        dim as Tko.NodeId loN = cast( Tko.NodeId, los[i] )
        if loN <> Tko.NODE_NONE then
            dim as Tko.Check.ConstVal lv = _
                Tko.Check.ConstOf( *c.ast, loN, *c.srcMgr, *c.names, _
                                   c.types->target.pointerBits, c.syms, cscope )
            if lv.known then lo = lv.value else known = false
        end if
        dim as longint hi = lo - 1
        dim as Tko.NodeId hiN = cast( Tko.NodeId, his[i] )
        if (hiN <> Tko.NODE_NONE) andalso (c.ast->Kind( hiN ) = Tko.N_ELLIPSIS) then
            '' The bound the initializer implies: lbound + count - 1, per dimension.
            dim as long got = InitCountAt( c, init, i )
            if got > 0 then hi = lo + got - 1 else known = false
        elseif hiN <> Tko.NODE_NONE then
            dim as Tko.Check.ConstVal hv = _
                Tko.Check.ConstOf( *c.ast, hiN, *c.srcMgr, *c.names, _
                                   c.types->target.pointerBits, c.syms, cscope )
            if hv.known then hi = hv.value else known = false
        else
            known = false
        end if
        if known then total *= (hi - lo + 1)
        bounds.Push( lo )
        bounds.Push( hi )
    next
    '' A BOUND THAT IS NOT A COMPILE-TIME CONSTANT makes the array DYNAMIC -- 'dim
    '' a(any)', 'dim a(0 to n)'. The rank is still written down, and it is what decides
    '' how many dimtb slots the descriptor carries, so it is kept.
    if (known = false) orelse (total <= 0) then return c.types->DynArrayOf( base_, los.Count )
    '' TOO MANY ELEMENTS TO COUNT IN A LONG is already over fbc's limit, whatever
    '' the element size: the limit is 2147483647 BYTES and an element is at least
    '' one. Reported here rather than later because the type cannot carry the
    '' count -- TypeRecord.elems is a long -- so nothing downstream could see it.
    '' OVER THE LIMIT, and the type still has to carry the BOUNDS: a count of 1
    '' keeps TypeRecord.elems honest -- it is a long and cannot hold the real
    '' one -- while ArrayTooBig_ recomputes from those bounds in 64 bits and
    '' reports. Reporting HERE instead gave the error twice, because a
    '' declaration whose type is not yet complete is revisited.
    if total > 2147483647 then
        return c.types->ArrayOf( base_, los.Count, 1, @bounds )
    end if
    return c.types->ArrayOf( base_, los.Count, cast( long, total ), @bounds )
end function

end namespace
