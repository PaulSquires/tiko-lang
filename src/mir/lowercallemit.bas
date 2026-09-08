'' lowercallemit.bas -- emitting a call to a procedure that is already CHOSEN.
''
'' Split out of lowerstore.bas at the 1500-line lint cap. These three share one shape:
'' the callee's symbol is settled, the operands are already in the form its parameters
'' want, and there is no call node in the AST to lower from -- so none of them does
'' overload work or argument conversion, and all of them have to get the ABI shape of
'' the call right on their own. That last part is why they were worth keeping together.

#include once "mir/lowerctx.bi"

namespace Tko.Mir


'' CALL A MEMBER ON A RECEIVER whose address is already in hand, with no call node in
'' the AST to lower from.
''
'' EmitStructorCall does this for constructors and destructors and hard-codes a VOID
'' result; the iterator protocol needs the same thing for functions that return
'' something. Same shape, one more parameter.
'' The same, with ARGUMENTS after the receiver. EmitMemberCall takes none, which is
'' right for the iterator protocol it was written for and wrong for 'operator []'.
'' A DIRECT CALL to a known procedure with a ready argument list -- no receiver, no
'' overload work. What a user-defined GLOBAL operator needs: Check chose the symbol and
'' the caller has already produced the operands the way the parameters want them.
function EmitDirectCall_ _
    ( byref c as Ctx, byval sym as Tko.SymbolId, byval rt as MirType, _
      byref args as FB.Array( of ulong ), byval withSret as boolean = false ) as MirValue

    dim as MirValue none_
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( sym )
    if s = 0 then return none_
    dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
    if pn = Tko.NODE_NONE then return none_
    if c.ast->Kind( pn ) <> Tko.N_PROC then return none_

    dim as long first = c.m->argPool.Count \ 2
    for i as long = 0 to args.Count - 1
        c.m->argPool.Push( args[i] )
    next
    dim as long nargs = args.Count \ 2

    dim as Tko.InternId nm = c.names->GetString( _
        Tko.Mangle.ProcName( *c.ast, pn, *c.syms, *c.names, *c.types, *c.info ) )
    dim as long fidx = -1
    for i as long = 0 to c.m->functions.Count - 1
        if c.m->functions[i]->name = nm then
            fidx = i
            exit for
        end if
    next
    if fidx < 0 then
        dim as MirFunction ptr decl = c.m->AddFunction( nm, rt )
        decl->isDefinition = false
        '' WHETHER A HIDDEN RESULT POINTER WAS PASSED IS REPORTED, not re-derived.
        '' It was hard-coded false, and a user-defined GLOBAL operator returning a
        '' non-trivial UDT is exactly the shape that breaks: the caller pushes a
        '' destination temporary as argument zero and this declared two parameters
        '' against a call passing three.
        ''
        '' 'declare operator +( byref l as const UDT, byref r as const UDT ) as UDT'
        '' over a UDT with a destructor emitted
        ''
        ''     call ptr +(@$tmp4, @a, @b)      three arguments
        ''     declare ptr +(ptr $0, ptr $1)   two parameters
        ''
        '' -- the verifier's 'calls + with 3 arguments, which declares 2', and eight
        '' of the arity failures the sweep records. lowercall.bas has always reported
        '' both hidden parameters here and says why in its own comment; this is the
        '' same rule, and the site that did not follow it.
        SignatureFromProc( c, decl, pn, withSret, false )
        fidx = c.m->functions.Count - 1
    end if

    dim as MirInst ins
    ins.op = cast( ushort, M_CALL )
    ins.ty = cast( ubyte, rt )
    ins.first = first
    ins.count = nargs
    ins.callee = fidx
    return Emit( c, ins )
end function

'' WHAT A MEMBER CALLEE ACTUALLY RETURNS, read off the callee rather than derived from
'' its declared type. Returns MT_VOID when this module has not emitted the function yet,
'' which is the caller's cue to fall back to the type.
''
'' Deriving it is what went wrong: 'operator []( index as integer ) as string' returns by
'' value, and a var-length string travels back as a POINTER to its descriptor -- the
'' definition comes out 'func ptr' with no hidden parameter at all. A caller that asked
'' LowerType( string ) emitted 'call agg' against 'func ptr' and the reader then had an
'' aggregate where a descriptor belonged, so the whole statement declined. The same
'' mistake in the other direction is the one recorded on hasSretParam: 'operator cast'
'' returns a UDT with a destructor and takes NO hidden pointer, because fbc gives it a
'' static result, while an ordinary member returning that type does take one.
function MemberCallRetTy_ _
    ( byref c as Ctx, byval sym as Tko.SymbolId ) as MirType

    dim as Tko.Symbol ptr s = c.syms->SymbolAt( sym )
    if s = 0 then return MT_VOID
    dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
    if pn = Tko.NODE_NONE then return MT_VOID
    if c.ast->Kind( pn ) <> Tko.N_PROC then return MT_VOID
    dim as Tko.InternId nm = c.names->GetString( _
        Tko.Mangle.ProcName( *c.ast, pn, *c.syms, *c.names, *c.types, *c.info ) )
    for i as long = 0 to c.m->functions.Count - 1
        if c.m->functions[i]->name = nm then
            return cast( MirType, c.m->functions[i]->retTy )
        end if
    next
    return MT_VOID
end function

function EmitMemberCallArgs_ _
    ( byref c as Ctx, byval sym as Tko.SymbolId, byref self_ as MirValue, _
      byval rt as MirType, byval args as FB.Array( of ulong ) ptr ) as MirValue

    dim as MirValue none_
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( sym )
    if s = 0 then return none_
    dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
    if pn = Tko.NODE_NONE then return none_
    if c.ast->Kind( pn ) <> Tko.N_PROC then return none_
    if self_.kind = cast( ubyte, MV_NONE ) then return none_

    '' A UDT RESULT THAT TRAVELS THROUGH A HIDDEN POINTER needs somewhere to land, and
    '' the CALLER provides it: a temporary passed as ARGUMENT ZERO, before the
    '' receiver. LowerCallParts has done this since the convention existed; this path
    '' did not, so a method returning a UDT with a destructor was called with the
    '' receiver sitting in the argument slot the callee writes its RESULT through.
    ''
    '' It was silent. The definition came out 'func ptr GETITERATOR(ptr, ptr)' and the
    '' call 'call agg GETITERATOR(@tmp)' -- the right name, one argument short, and no
    '' decline -- until the verifier learned to compare a call against the signature
    '' it is calling.
    '' THE CALLEE IS FOUND FIRST, because only it can answer whether it takes one.
    '' Asking the RETURN TYPE instead gets 'operator cast' wrong: it returns a UDT with
    '' a destructor and takes NO hidden pointer, because fbc gives it a static result --
    '' measured, 'struct $2TU* _ZN2CVcv2TUEv( struct $2CV* )'. Deriving the convention
    '' here rather than reading it produced a call with an argument the definition in
    '' this very module did not declare.
    dim as Tko.InternId nm = c.names->GetString( _
        Tko.Mangle.ProcName( *c.ast, pn, *c.syms, *c.names, *c.types, *c.info ) )
    dim as long fidx = -1
    for i as long = 0 to c.m->functions.Count - 1
        if c.m->functions[i]->name = nm then
            fidx = i
            exit for
        end if
    next

    dim as MirValue sretTmp
    dim as boolean useSret = false
    '' ONLY WHEN THE CALLEE SAYS SO. A callee this module has not seen keeps the old
    '' shape: adding a hidden pointer on a guess is the failure this comment describes,
    '' and the verifier's arity rule reports any that remain rather than hiding them.
    if fidx >= 0 then useSret = c.m->functions[fidx]->hasSretParam

    dim as long first = c.m->argPool.Count \ 2
    dim as long nargs = 0
    if useSret then
        dim as long tslot = NewTempLocal( c, MT_AGG, SizeOfType( c, s->type_ ) )
        if tslot < 0 then return none_
        '' Destroyed at the end of the statement, beside every other temporary of a
        '' type that needs it.
        if TypeNeedsDtor_( c, s->type_ ) then
            c.udtTemps.Push( cast( ulong, tslot ) )
            c.udtTempTypes.Push( cast( ulong, s->type_ ) )
        end if
        sretTmp.kind = cast( ubyte, MV_LOCAL )
        sretTmp.ty = cast( ubyte, MT_PTR )
        sretTmp.id = tslot
        c.m->argPool.Push( cast( ulong, sretTmp.kind ) )
        c.m->argPool.Push( cast( ulong, sretTmp.id ) )
        nargs += 1
    end if
    c.m->argPool.Push( cast( ulong, self_.kind ) )
    c.m->argPool.Push( cast( ulong, self_.id ) )
    nargs += 1
    if args <> 0 then
        for i as long = 0 to args->Count - 1
            c.m->argPool.Push( (*args)[i] )
        next
        nargs += args->Count \ 2
    end if

    '' THE FUNCTION RETURNS THE POINTER, which is what its definition says: fbc writes
    '' 'struct T* F( struct T* tmp )'. Declaring it 'agg' would put a type on the call
    '' that the callee's own 'ret' contradicts.
    dim as MirType callTy = rt
    if useSret then callTy = MT_PTR

    if fidx < 0 then
        dim as MirFunction ptr decl = c.m->AddFunction( nm, callTy )
        decl->isDefinition = false
        SignatureFromProc( c, decl, pn, useSret, true )
        fidx = c.m->functions.Count - 1
    end if

    dim as MirInst ins
    ins.op = cast( ushort, M_CALL )
    ins.ty = cast( ubyte, callTy )
    ins.first = first
    ins.count = nargs
    ins.callee = fidx
    dim as MirValue r = Emit( c, ins )
    '' The call's VALUE is the TEMPORARY, not the pointer the callee handed back --
    '' the same contract LowerCallParts has: 'v = F( )' and 'F( ).field' both read
    '' from the storage the caller supplied.
    if useSret then return LowerExprLoad( c, sretTmp, MT_AGG )
    return r
end function

function EmitMemberCall _
    ( byref c as Ctx, byval sym as Tko.SymbolId, byref self_ as MirValue, _
      byval rt as MirType ) as MirValue
    return EmitMemberCallArgs_( c, sym, self_, rt, 0 )
end function

end namespace
