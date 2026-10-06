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
      byval rt as MirType, byval args as FB.Array( of ulong ) ptr, _
      byval vslot as long ) as MirValue

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
    '' ...AND A CALLEE NOT LOWERED YET IS ASKED THE DEFINITION'S OWN QUESTION, which is
    '' not a guess: lowerproc gives a member the hidden pointer exactly when its result
    '' is an aggregate that UsesSretReturn, it is not byref, and it is not a cast
    '' operator (the static result above). A generic instantiation's members are lowered
    '' AFTER the user procedures that call them, so 'for each entry in m' over an
    '' 'FB.Map( of ustring, T )' inside any SUB called 'Value( )' with the receiver alone
    '' against a definition taking the result pointer too, and handed clang a
    '' zero-sized aggregate. At module level the definition already existed.
    if (fidx < 0) andalso (s->type_ <> Tko.TYPE_NONE) then
        dim as boolean isByrefRet = ((c.ast->nodes[cast( long, pn )].flags and Tko.NF_BYREF) <> 0)
        dim as boolean isCastOp = (StmtOf( c, pn )->name = c.names->Fold( c.names->GetString( "cast" ) ))
        if (isByrefRet = false) andalso (isCastOp = false) then
            if LowerType( s->type_, *c.types ) = MT_AGG then useSret = UsesSretReturn( c, s->type_ )
        end if
    end if

    dim as long first = c.m->argPool.Count \ 2
    dim as long nargs = 0
    if useSret then
        '' Destroyed at the end of the statement, beside every other temporary of a
        '' type that needs it -- or the variable a declaration is building, SretInPlaceInit_.
        dim as long tslot = SretResultSlot_( c, s->type_, true, sym )
        if tslot < 0 then return none_
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
    '' A VIRTUAL PROPERTY GOES THROUGH THE RECEIVER'S VPTR, exactly as a virtual method
    '' does in LowerCallParts (T49). The getter and setter came here with the name the
    '' resolver bound -- the STATIC type's accessor -- and called it directly, so 'pa->P'
    '' through an A ptr on a B returned A's value while the table beside it held B's.
    '' The caller asks VirtualSlotOf_, which keeps 'base.P' direct. The signature rides
    '' along as callee + 1, the convention an M_CALL_IND uses (see DeclIndexFor_).
    if vslot >= 0 then
        dim as MirValue vfp = VirtualCalleeOf_( c, self_, vslot )
        if vfp.kind <> cast( ubyte, MV_NONE ) then
            ins.op = cast( ushort, M_CALL_IND )
            ins.a = vfp
            ins.callee = cast( ulong, fidx + 1 )
            if callTy = MT_AGG then ins.imm = SizeOfType( c, s->type_ )
        end if
    end if
    dim as MirValue r = Emit( c, ins )
    '' The call's VALUE is the TEMPORARY, not the pointer the callee handed back --
    '' the same contract LowerCallParts has: 'v = F( )' and 'F( ).field' both read
    '' from the storage the caller supplied.
    '' ...EXCEPT THE DECLARED VARIABLE, which is built and has nothing to read: its address
    '' goes back to SretInPlaceInit_, the only caller that offers one.
    if useSret andalso c.sretIntoTaken andalso (sretTmp.id = c.sretIntoSlot) then return sretTmp
    if useSret then return LowerExprLoad( c, sretTmp, MT_AGG )
    return r
end function

function EmitMemberCall _
    ( byref c as Ctx, byval sym as Tko.SymbolId, byref self_ as MirValue, _
      byval rt as MirType ) as MirValue
    '' A VIRTUAL ONE THROUGH THE RECEIVER'S VPTR -- 'operator cast' and 'operator @' are reached
    '' only through here, and '*pa' over an 'A ptr' to a B called A's (virtual/virtual.bas
    '' virtualOperators). The slot is the declaring type's, which every derived table keeps.
    return EmitMemberCallArgs_( c, sym, self_, rt, 0, MemberVSlot_( c, sym ) )
end function

function MemberVSlot_( byref c as Ctx, byval sym as Tko.SymbolId ) as long
    if c.vts = 0 then return -1
    dim as Tko.Symbol ptr ms = c.syms->SymbolAt( sym )
    if ms = 0 then return -1
    dim as Tko.NodeId md = cast( Tko.NodeId, ms->payload )
    if (md = Tko.NODE_NONE) orelse (c.ast->Kind( md ) <> Tko.N_PROC) then return -1
    if (StmtOf( c, md )->extra and (Tko.PF_VIRTUAL or Tko.PF_ABSTRACT)) = 0 then return -1
    dim as Tko.SymScope ptr os = c.syms->ScopeAt( ms->parent )
    if (os = 0) orelse (os->kind <> cast( ubyte, Tko.SCOPEK_TYPE )) then return -1
    dim as Tko.Symbol ptr ow = c.syms->SymbolAt( os->owner )
    if ow = 0 then return -1
    return c.vts->SlotOf( c.types->Unqualify( ow->type_ ), sym, md )
end function

'' WHERE A HIDDEN-POINTER RESULT LANDS: the variable a declaration has on offer, or a
'' temporary -- registered for destruction at the end of the statement when asked.
''
'' The offer names ONE CALLEE, and only a call to that symbol takes it. LowerCallParts and
'' the operators ask before they lower a single operand, but a getter reached through
'' EmitMemberCallArgs_ asks AFTER its receiver is lowered, and a call inside that receiver
'' must not build x.
function SretResultSlot_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byval registerDtor as boolean, _
      byval sym as Tko.SymbolId ) as long

    if c.sretIntoOn andalso (sym = c.sretIntoSym) then
        if c.types->Unqualify( t ) = c.sretIntoType then
            c.sretIntoOn = false
            c.sretIntoTaken = true
            return c.sretIntoSlot
        end if
    end if
    dim as long tslot = NewTempLocal( c, MT_AGG, SizeOfType( c, t ) )
    if tslot < 0 then return tslot
    if registerDtor then
        if TypeNeedsDtor_( c, t ) then
            c.udtTemps.Push( cast( ulong, tslot ) )
            c.udtTempTypes.Push( cast( ulong, t ) )
        end if
    end if
    return tslot
end function

'' ...REGISTERED LATE: a slot SretResultSlot_ handed out with registerDtor false, put on
'' the statement's list now. An operator's result is made after its operands, so it has
'' to die before their temporaries do. The variable a declaration offered is not a
'' temporary and is left alone.
sub SretResultSlotAfter_( byref c as Ctx, byval t as Tko.TypeId, byval slot as long )
    if slot < 0 then return
    if c.sretIntoTaken andalso (slot = c.sretIntoSlot) then return
    if TypeNeedsDtor_( c, t ) = false then return
    c.udtTemps.Push( cast( ulong, slot ) )
    c.udtTempTypes.Push( cast( ulong, t ) )
end sub

'' A PAREN-LESS PROPERTY'S GETTER: CHECK'S CHOICE, recorded on the member -- the accessor with
'' a result and no index (PropertyReadAccessor_). Nothing when the member is not such a getter.
'' This walked the chain itself, from the head, as a second copy of the rule (overload re-pick
'' refactor, Phase 1).
private function SoleGetter_( byref c as Ctx, byval member as Tko.NodeId ) as Tko.SymbolId
    dim as Tko.SymbolId sid = c.info->RefOf( member )
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( sid )
    if s = 0 then return Tko.SYMBOL_NONE
    if s->kind <> cast( ubyte, Tko.SYM_PROC ) then return Tko.SYMBOL_NONE
    dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
    if (pn = Tko.NODE_NONE) orelse (c.ast->Kind( pn ) <> Tko.N_PROC) then return Tko.SYMBOL_NONE
    dim as Tko.StmtPayload ptr pp = StmtOf( c, pn )
    if (pp->op <> cast( ushort, Tko.KW_PROPERTY )) orelse (pp->a = Tko.NODE_NONE) then return Tko.SYMBOL_NONE
    for i as long = 0 to pp->count - 1
        if c.ast->Kind( cast( Tko.NodeId, c.ast->children[pp->first + i] ) ) = Tko.N_PARAM then return Tko.SYMBOL_NONE
    next
    return sid
end function

'' 'dim as T x = f( )' CONSTRUCTS x IN PLACE when f's result travels through the hidden
'' pointer. Measured, fbc passes the variable itself --
''
''   struct $2WS C$0;
''   VIARETURN( &C$0, &A$0, &TMP$16$0 );
''
'' -- and the same for a global operator, '_ZplR1Hi( &Y$1, &X$1, 2 )', with or without a
'' copy constructor. tiko default-constructed x, built the result in a temporary, stored
'' its bytes over x and destroyed the temporary: for a type whose constructor allocates
'' and whose destructor frees, a leak and a double free per declaration.
''
'' ...and for a METHOD, through '.' or '->' or on the type, a paren-less PROPERTY and a
'' UNARY operator:
''
''   _ZN3FAC2MKEi( &X2$1, PF$1, 2 );       _ZN3FAC3SMKEi( &X3$1, 3 );
''   _ZN3FAC9HP__get__Ev( &X6$1, &OBJ$1 ); _ZngR1H( &X5$1, &X1$1 );
''
'' Offered only for a call naming a procedure or a method -- with or without parentheses --
'' an operator bound to one, or a property's sole getter, whose non-byref result is exactly
'' T; and taken only by a call
'' to that symbol (SretResultSlot_). True when x has been dealt with, and nothing may
'' construct or store it after.
function SretInPlaceInit_ _
    ( byref c as Ctx, byval slot as long, byval t as Tko.TypeId, _
      byval e as Tko.NodeId ) as boolean

    if (slot < 0) orelse (e = Tko.NODE_NONE) then return false
    dim as Tko.SymbolId callee = Tko.SYMBOL_NONE
    dim as boolean isProp = false
    dim as boolean isOp = false
    dim as boolean isBare = false
    select case c.ast->Kind( e )
    case Tko.N_CALL
        '' The binding LowerAddr's call arm reads; a TYPE's constructor is not one.
        dim as Tko.ListPayload ptr lp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, e )].data )]
        if lp->target = Tko.NODE_NONE then return false
        select case c.ast->Kind( lp->target )
        case Tko.N_IDENT, Tko.N_MEMBER
        case else
            return false
        end select
        if TypeCtorTypeOf_( c, e ) <> Tko.TYPE_NONE then return false
        callee = c.info->RefOf( e )
        if callee = Tko.SYMBOL_NONE then callee = c.info->RefOf( lp->target )
    case Tko.N_BINARY, Tko.N_UNARY
        callee = c.info->RefOf( e )
        isOp = true
    case Tko.N_IDENT, Tko.N_MEMBER
        '' A PAREN-LESS PROPERTY is its getter. Any other paren-less PROCEDURE is a call
        '' with every argument defaulted -- 'obj.mk0', measured '_ZN3FAC3MK0Ev( &Z1$1,
        '' &OBJ$1 )' -- which LowerExpr sends to LowerBareProcCall_; one it would not
        '' call is not offered, and neither is a variable.
        if c.ast->Kind( e ) = Tko.N_MEMBER then callee = SoleGetter_( c, e )
        if callee <> Tko.SYMBOL_NONE then
            isProp = true
        else
            callee = c.info->RefOf( e )
            if callee = Tko.SYMBOL_NONE then return false
            dim as Tko.Symbol ptr bs = c.syms->SymbolAt( callee )
            if bs = 0 then return false
            if bs->kind <> cast( ubyte, Tko.SYM_PROC ) then return false
            dim as Tko.NodeId bpn = cast( Tko.NodeId, bs->payload )
            if bpn = Tko.NODE_NONE then return false
            if c.ast->Kind( bpn ) <> Tko.N_PROC then return false
            if StmtOf( c, bpn )->op = cast( ushort, Tko.KW_PROPERTY ) then return false
            if IsVariadicProc( c, callee ) then return false
            for i as long = 0 to ParamCountOf( c, callee ) - 1
                if ParamDefaultAt( c, callee, i ) = Tko.NODE_NONE then return false
            next
            isBare = true
        end if
    case else
        return false
    end select
    if callee = Tko.SYMBOL_NONE then return false
    dim as Tko.Symbol ptr cs = c.syms->SymbolAt( callee )
    if cs = 0 then return false
    if cs->kind <> cast( ubyte, Tko.SYM_PROC ) then return false
    dim as Tko.NodeId pn = cast( Tko.NodeId, cs->payload )
    if pn = Tko.NODE_NONE then return false
    if c.ast->Kind( pn ) <> Tko.N_PROC then return false
    if (c.ast->nodes[cast( long, pn )].flags and Tko.NF_BYREF) <> 0 then return false
    if isOp then
        if StmtOf( c, pn )->op <> cast( ushort, Tko.KW_OPERATOR ) then return false
    end if
    if cs->type_ = Tko.TYPE_NONE then return false
    dim as Tko.TypeId ut = c.types->Unqualify( t )
    if c.types->Unqualify( cs->type_ ) <> ut then return false
    if UsesSretReturn( c, cs->type_ ) = false then return false

    dim as long cmark = c.udtTemps.Count
    c.sretIntoSlot = slot
    c.sretIntoType = ut
    c.sretIntoSym = callee
    c.sretIntoTaken = false
    dim as MirValue ra
    '' A GETTER HAS NO ADDRESS ARM in LowerAddr; its value path is LowerPropertyGet_, which
    '' arms the offer itself once this node's receiver is lowered.
    if isProp then
        c.sretIntoNode = e
        c.sretIntoAtNode = true
        if LowerPropertyGet_( c, e, ra ) = false then ra.kind = cast( ubyte, MV_NONE )
        c.sretIntoAtNode = false
    elseif isBare then
        '' ...and a paren-less call's is LowerBareProcCall_, asked for the ADDRESS.
        c.sretIntoOn = true
        if LowerBareProcCall_( c, e, MT_PTR, ra ) = false then ra.kind = cast( ubyte, MV_NONE )
    else
        c.sretIntoOn = true
        ra = LowerAddr( c, e )
    end if
    c.sretIntoOn = false
    dim as boolean taken = c.sretIntoTaken
    c.sretIntoTaken = false

    if taken then
        if (ra.kind = cast( ubyte, MV_LOCAL )) andalso (ra.id = slot) then return true
        '' Something other than the initialiser took it, so x holds the wrong object.
        '' Not reachable by the shapes above; declined rather than miscompiled.
        SkipHere( c )
        return true
    end if
    if ra.kind = cast( ubyte, MV_NONE ) then
        SkipHere( c )
        return true
    end if
    '' NOT TAKEN: the result sits in a temporary nobody else can reach, so its bytes are
    '' MOVED into x and the temporary is not destroyed -- the counts building in place gives.
    dim as MirValue mv
    if isProp then
        '' A getter's value is already LOADED, out of the temporary it registered last.
        mv = ra
        if c.udtTemps.Count > cmark then
            if c.types->Unqualify( cast( Tko.TypeId, c.udtTempTypes[c.udtTempTypes.Count - 1] ) ) = ut then
                ForgetUdtTemp_( c, cast( long, c.udtTemps[c.udtTemps.Count - 1] ) )
            end if
        end if
    else
        dim as long sz = SizeOfType( c, t )
        if sz > 0 then mv = LowerExprLoad( c, ra, MT_AGG, sz )
    end if
    if mv.kind = cast( ubyte, MV_NONE ) then
        SkipHere( c )
        return true
    end if
    dim as MirValue dst
    dst.kind = cast( ubyte, MV_LOCAL )
    dst.ty = cast( ubyte, MT_PTR )
    dst.id = slot
    StoreThrough( c, dst, mv )
    if isProp = false then
        if ra.kind = cast( ubyte, MV_LOCAL ) then ForgetUdtTemp_( c, ra.id )
    end if
    return true
end function

'' THE RESULT TYPE OF A CALL CHECK LEFT UNTYPED: the result of the procedure it calls.
''
'' ResolveCall_ types no call with an untyped argument, and a DWSTRING concatenation is
'' one: 'a + " 2027"' runs through 'cast( ) byref as const wstring', which Check does not
'' type. So 'dim as DWSTRING c = mk( a + " 2027" )' reached neither SretInPlaceInit_ nor
'' the copy: the call was lowered and dropped, c default-constructed, the call lowered
'' AGAIN and its bytes stored over c, and that temporary destroyed -- c's buffer freed
'' twice, 0xC0000374 at the end of the scope. fbc builds it in place, 'MK( &C$1, TMP )'.
''
'' THAT PROCEDURE IS THE CALL'S OWN BINDING. ResolveCall_ replaces the binding when it
'' chooses an overload; when it cannot -- an untyped argument, a tie -- the binding is the
'' one Resolve copied onto the call from the name, which is the FIRST overload declared
'' (resolve.bas, symbol.bi). LowerCall, LowerAddr's call arm and SretInPlaceInit_ read it
'' the same way, so it is the procedure the call lowers against, and any other overload's
'' result would type the call as something it does not call. The same call shapes
'' SretInPlaceInit_ accepts: a named procedure, not a byref result.
''
'' THIS DOES NOT WALK THE OVERLOADS, and it once said it did: it claimed to answer only
'' when every overload returned the same type. The walk ran for a call with NO binding,
'' and Resolve leaves none -- traced over the gate, the corpus sweep and the AfxNova
'' probes, it never ran once, so the first overload's result is what this has always
'' answered.
''
'' WHICH overload a call binds is Check's decision: ConcatHasWideCastTerm_ (overload.bas)
'' costs a DWSTRING concatenation as WSTRING, so 'mk( a + " 2029" )' binds the wstring
'' overload in any declaration order. An argument Check still cannot type keeps the first.
function UntypedCallResult_( byref c as Ctx, byval e as Tko.NodeId ) as Tko.TypeId
    if e = Tko.NODE_NONE then return Tko.TYPE_NONE
    if c.ast->Kind( e ) <> Tko.N_CALL then return Tko.TYPE_NONE
    dim as Tko.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, e )].data )]
    if lp->target = Tko.NODE_NONE then return Tko.TYPE_NONE
    if c.ast->Kind( lp->target ) <> Tko.N_IDENT then return Tko.TYPE_NONE
    if TypeCtorTypeOf_( c, e ) <> Tko.TYPE_NONE then return Tko.TYPE_NONE
    dim as Tko.SymbolId callee = c.info->RefOf( e )
    if callee = Tko.SYMBOL_NONE then callee = c.info->RefOf( lp->target )
    if callee = Tko.SYMBOL_NONE then return Tko.TYPE_NONE
    dim as Tko.Symbol ptr cs = c.syms->SymbolAt( callee )
    if cs = 0 then return Tko.TYPE_NONE
    if cs->kind <> cast( ubyte, Tko.SYM_PROC ) then return Tko.TYPE_NONE
    dim as Tko.NodeId pn = cast( Tko.NodeId, cs->payload )
    if pn = Tko.NODE_NONE then return Tko.TYPE_NONE
    if c.ast->Kind( pn ) <> Tko.N_PROC then return Tko.TYPE_NONE
    if (c.ast->nodes[cast( long, pn )].flags and Tko.NF_BYREF) <> 0 then return Tko.TYPE_NONE
    return cs->type_
end function

end namespace
