'' lowercallarg.bas -- the UDT-ARGUMENT machinery of a call: conversion constructors,
'' bare type literals, byval copies, and the temporaries all three need.
''
'' Split out of lowercall.bas at the 1500-line cap and INCLUDED from it, inside the
'' same namespace. Nothing moved here changed in the move.




'' THE CONVERSION CONSTRUCTOR for one argument that is not already the parameter's type.
''
'' 'sub f( byval x as UDT )' called as 'f( 1122 )' over a type declaring
'' 'declare constructor( byval n as integer )'. Measured:
''
''     struct UDT TMP$2$0;
''     _ZN3UDTC1Eu7INTEGER( &TMP$2$0, 1122ll );
''     F( TMP$2$0 );
''
'' -- a temporary, the constructor into it, and the temporary passed. It is destroyed at
'' the END OF THE STATEMENT, after the call's result has been consumed, which is what
'' the argument-temporary list this returns into already does.
''
'' Without it the raw operand went straight to the callee: 'call void F( 1122 )', an
'' integer where an object belongs, with "0 statements not lowered" beside it. It lowered
'' and it verified.
''
'' A CONVERSION CONSTRUCTOR IS ANY ARITY-1 CONSTRUCTOR WHOSE PARAMETER IS NOT THE TYPE
'' ITSELF -- one whose parameter IS the type is the copy constructor, and that is a
'' different path with a different meaning.
private function ConvCtorFor_ _
    ( byref c as Ctx, byval pt as Tko.TypeId ) as Tko.SymbolId

    dim as Tko.SymbolId cur = StructorOf( c, pt, "__ctor" )
    while cur <> Tko.SYMBOL_NONE
        dim as Tko.Symbol ptr s = c.syms->SymbolAt( cur )
        if s = 0 then exit while
        dim as Tko.NodeId pn = cast( Tko.NodeId, s->payload )
        if (pn <> Tko.NODE_NONE) andalso (c.ast->Kind( pn ) = Tko.N_PROC) then
            dim as Tko.StmtPayload ptr pp = StmtOf( c, pn )
            dim as long np = 0
            for i as long = 0 to pp->count - 1
                dim as Tko.NodeId prm = cast( Tko.NodeId, c.ast->children[pp->first + i] )
                if c.ast->Kind( prm ) = Tko.N_PARAM then np += 1
            next
            if np = 1 then
                dim as Tko.TypeId cpt = ParamTypeAt( c, cur, 0 )
                if cpt <> Tko.TYPE_NONE then
                    dim as Tko.TypeId u = cpt
                    if c.types->Kind( u ) = Tko.TK_REFERENCE then u = c.types->Inner( u )
                    if c.types->Unqualify( u ) <> c.types->Unqualify( pt ) then
                        return cur
                    end if
                end if
            end if
        end if
        cur = s->nextOverload
    wend
    return Tko.SYMBOL_NONE
end function

'' A TEMPORARY OF THE PARAMETER'S TYPE, constructed from the argument. Returns its
'' ADDRESS; the caller decides whether the callee wants that or the aggregate loaded out
'' of it, which is the same choice an ordinary byval UDT argument already makes.
'' 'f( type( ) )' -- A BARE TYPE LITERAL AS AN ARGUMENT.
''
'' Recognised by SHAPE: an empty N_TUPLE marked as a type literal with no type name
'' of its own. The type comes from the PARAMETER, which is the only place it can
'' come from, so Check cannot type it and every use of one declined -- the same
'' reason LowerBareTypeLiteralAssign_ exists on the assignment side.
''
'' Measured, and BOTH passing modes build the same temporary and destroy it after
'' the call:
''
''   _ZN1TC1Ev( &TMP$3$0 );  HPASSBYVAL( &TMP$3$0 );  _ZN1TD1Ev( &TMP$3$0 );
''   _ZN1TC1Ev( &TMP$4$0 );  HPASSBYREF( &TMP$4$0 );  _ZN1TD1Ev( &TMP$4$0 );
''
'' Returns the temporary's SLOT; the caller decides whether the callee takes its
'' address or its value, and registers the destructor.
private function BareTypeLiteralArg_ _
    ( byref c as Ctx, byval argNode as Tko.NodeId, byval pt as Tko.TypeId, _
      byref outSlot as long ) as boolean

    outSlot = -1
    if argNode = Tko.NODE_NONE then return false
    if c.ast->Kind( argNode ) <> Tko.N_TUPLE then return false
    if (c.ast->nodes[cast( long, argNode )].flags and Tko.NF_TYPE_LITERAL) = 0 then
        return false
    end if
    if c.info->TypeOf_( argNode ) <> Tko.TYPE_NONE then return false
    if pt = Tko.TYPE_NONE then return false
    dim as Tko.TypeId dt = c.types->Unqualify( pt )
    if c.types->Kind( dt ) = Tko.TK_REFERENCE then
        dt = c.types->Unqualify( c.types->Inner( dt ) )
    end if
    if c.types->Kind( dt ) <> Tko.TK_UDT then return false
    dim as long sz = SizeOfType( c, dt )
    if sz <= 0 then return false

    dim as long tslot = NewTempLocal( c, MT_AGG, sz )
    if tslot < 0 then return false
    if LowerCtorInit( c, tslot, dt, argNode ) = false then return false
    if TypeNeedsDtor_( c, dt ) then
        c.udtTemps.Push( cast( ulong, tslot ) )
        c.udtTempTypes.Push( cast( ulong, dt ) )
    end if
    outSlot = tslot
    return true
end function

private function UdtConvTemp_ _
    ( byref c as Ctx, byval argNode as Tko.NodeId, byval pt as Tko.TypeId, _
      byref outa as MirValue, byref outSlot as long, byref outType as Tko.TypeId ) as boolean

    outSlot = -1
    outType = Tko.TYPE_NONE
    if argNode = Tko.NODE_NONE then return false
    dim as long sz = SizeOfType( c, pt )
    if sz <= 0 then return false

    dim as Tko.SymbolId cv = ConvCtorFor_( c, pt )
    if cv = Tko.SYMBOL_NONE then return false
    dim as Tko.TypeId cpt = ParamTypeAt( c, cv, 0 )
    if cpt = Tko.TYPE_NONE then return false

    '' EVERYTHING THAT CAN FAIL, BEFORE ANYTHING IS EMITTED. A decline that has already
    '' made a temporary does not LOOK like one -- the alloca counts as an instruction and
    '' the statement reads as lowered with the call missing from it.
    dim as boolean byrefP = ParamIsByref( c, cv, 0 )
    dim as MirValue av
    if byrefP then
        av = LowerAddr( c, argNode )
        '' AN RVALUE HAS NO ADDRESS, AND THE CONVERSION STILL HAPPENS. The
        '' constructor that does it may take its operand BYREF -- fb's own
        '' 'constructor foo( byref v as byte )' is the corpus's shape -- and a
        '' CONSTANT argument has nothing to point at. Measured, fbc makes two
        '' temporaries and passes the first's address:
        ''
        ''   TMP$2$0 = (int8)1;
        ''   _ZN3FOOC1ERa( &TMP$3$0, &TMP$2$0 );
        ''   BYVAL_( TMP$3$0 );
        ''
        '' ByrefTemp_ is the same helper the ordinary byref-argument path uses
        '' for exactly this.
        if av.kind = cast( ubyte, MV_NONE ) then
            av = ByrefTemp_( c, argNode, cpt )
        end if
    else
        av = LowerExpr( c, argNode )
    end if
    if av.kind = cast( ubyte, MV_NONE ) then return false
    if byrefP = false then
        dim as MirType cmt = LowerType( cpt, *c.types )
        if (cmt = MT_VOID) orelse (cmt = MT_AGG) then return false
        av = Coerce( c, av, cmt, IsUnsignedType( c, c.info->TypeOf_( argNode ) ) )
        if av.kind = cast( ubyte, MV_NONE ) then return false
    end if

    dim as long slot = NewTempLocal( c, MT_AGG, sz )
    if slot < 0 then return false
    dim as MirValue dst
    dst.kind = cast( ubyte, MV_LOCAL )
    dst.ty = cast( ubyte, MT_PTR )
    dst.id = slot

    dim as FB.Array( of ulong ) cargs
    cargs.Push( cast( ulong, av.kind ) )
    cargs.Push( cast( ulong, av.id ) )
    EmitStructorCall( c, cv, -1, @dst, @cargs )

    if TypeNeedsDtor_( c, pt ) then
        outSlot = slot
        outType = pt
    end if
    outa = dst
    return true
end function

'' THE OPERAND OF A USER-DEFINED OPERATOR, converted to the parameter's type the way
'' an ARGUMENT would be. Two shapes, and they are not the same code:
''
''   an 'operator cast' ON THE SOURCE that yields the parameter's own type is called
''   and its RESULT IS THE OPERAND -- measured, and there is no temporary and no
''   destructor at all:
''
''     struct $2TU* vr$4 = _ZN2TVcv2TUEv( &VV$0 );
''     int64 vr$6 = _ZneR2TUS0_( &UU$0, vr$4 );
''
''   a conversion CONSTRUCTOR on the destination builds a temporary, the operator is
''   called on it, and the temporary is DESTRUCTED at end of statement:
''
''     _ZN2TUC1ER2TV( &TMP$2$0, &VV$0 );
''     int64 vr$7 = _ZneR2TUS0_( &UU$0, &TMP$2$0 );
''     _ZN2TUD1Ev( &TMP$2$0 );
''
'' TWO CHAINED conversions -- a cast to STRING and then a constructor FROM string --
'' are not modelled and decline, in the cost model as well as here.
function UserConvOperand_ _
    ( byref c as Ctx, byval e as Tko.NodeId, byval pt as Tko.TypeId, _
      byref outa as MirValue, byref outSlot as long, byref outType as Tko.TypeId ) as boolean

    outSlot = -1
    outType = Tko.TYPE_NONE
    if (e = Tko.NODE_NONE) orelse (pt = Tko.TYPE_NONE) then return false
    dim as Tko.TypeId pu = c.types->Unqualify( pt )
    if c.types->Kind( pu ) = Tko.TK_REFERENCE then
        pu = c.types->Unqualify( c.types->Inner( pu ) )
    end if
    if c.types->Kind( pu ) <> Tko.TK_UDT then return false
    dim as Tko.TypeId et = c.types->Unqualify( c.info->TypeOf_( e ) )
    if c.types->Kind( et ) = Tko.TK_REFERENCE then
        et = c.types->Unqualify( c.types->Inner( et ) )
    end if
    if et = Tko.TYPE_NONE then return false
    if et = pu then return false

    '' THE CAST FIRST: fbc prefers it, and the file that exercises this says so in
    '' its own priority table.
    if c.types->Kind( et ) = Tko.TK_UDT then
        dim as Tko.SymbolId cur = StructorOf( c, et, "cast" )
        while cur <> Tko.SYMBOL_NONE
            dim as Tko.Symbol ptr cs = c.syms->SymbolAt( cur )
            if cs = 0 then exit while
            dim as Tko.TypeId rt = cs->type_
            if rt <> Tko.TYPE_NONE then
                dim as Tko.TypeId ru = c.types->Unqualify( rt )
                if c.types->Kind( ru ) = Tko.TK_REFERENCE then
                    ru = c.types->Unqualify( c.types->Inner( ru ) )
                end if
                if ru = pu then
                    dim as MirValue self_ = LowerAddr( c, e )
                    if self_.kind = cast( ubyte, MV_NONE ) then return false
                    outa = EmitMemberCall( c, cur, self_, MT_PTR )
                    return (outa.kind <> cast( ubyte, MV_NONE ))
                end if
            end if
            cur = cs->nextOverload
        wend
    end if

    return UdtConvTemp_( c, e, pu, outa, outSlot, outType )
end function

'' The matching teardown: the same destructor pass a call makes over its own
'' argument temporaries.
sub DestroyOperandTemps_ _
    ( byref c as Ctx, byref slots as FB.Array( of ulong ), _
      byref types as FB.Array( of ulong ) )
    DestroyArgTemps_( c, slots, types )
end sub

'' Whether argument 'i' of 'callee' has to be CONVERTED rather than passed. True only
'' when the parameter is a UDT and the argument is not already one of that type -- an
'' argument of the same type is a copy, and both other cases are somebody else's path.
private function ArgNeedsUdtConv_ _
    ( byref c as Ctx, byval callee as Tko.SymbolId, byval idx as long, _
      byval argNode as Tko.NodeId ) as boolean

    if argNode = Tko.NODE_NONE then return false
    if ParamIsArray( c, callee, idx ) then return false
    dim as Tko.TypeId pt = ParamTypeAt( c, callee, idx )
    if pt = Tko.TYPE_NONE then return false
    if c.types->Kind( pt ) = Tko.TK_REFERENCE then pt = c.types->Inner( pt )
    pt = c.types->Unqualify( pt )
    if c.types->Kind( pt ) <> Tko.TK_UDT then return false

    dim as Tko.TypeId at = c.info->TypeOf_( argNode )
    if at = Tko.TYPE_NONE then return false
    if c.types->Kind( at ) = Tko.TK_REFERENCE then at = c.types->Inner( at )
    at = c.types->Unqualify( at )
    if at = pt then return false
    '' A DERIVED OBJECT IS NOT A CONVERSION -- it is the base subobject at offset zero,
    '' which the ordinary path already passes.
    if c.types->Kind( at ) = Tko.TK_UDT then return false
    return true
end function

'' THE CALLER-BUILT COPY of one byval non-trivial UDT argument.
''
'' Returns the address to pass, and the temporary's slot when one was made so the call
'' site can destroy it afterwards. A slot of -1 means nothing needs destroying, which
'' is the type with a copy constructor and no destructor.
private function ByvalUdtCopyArg_ _
    ( byref c as Ctx, byval argNode as Tko.NodeId, byval pt as Tko.TypeId, _
      byref outa as MirValue, byref outSlot as long, byref outType as Tko.TypeId ) as boolean

    outSlot = -1
    outType = Tko.TYPE_NONE
    if argNode = Tko.NODE_NONE then return false
    dim as long sz = SizeOfType( c, pt )
    if sz <= 0 then return false

    '' WHICH COPY, DECIDED BEFORE ANYTHING IS EMITTED. A decline that has already made
    '' a temporary is a decline that does not LOOK like one: the alloca counts as an
    '' instruction, and the statement then reads as lowered with the call missing from
    '' it. That is the shape this whole sweep exists to find.
    ''   2  the written copy constructor      1  the synthesised one      0  memcpy
    dim as Tko.SymbolId cc = StructorWithArity( c, StructorOf( c, pt, "__ctor" ), 1 )
    dim as long how = 0
    if cc <> Tko.SYMBOL_NONE then
        dim as Tko.TypeId cpt = ParamTypeAt( c, cc, 0 )
        if cpt <> Tko.TYPE_NONE then
            if c.types->Kind( cpt ) = Tko.TK_REFERENCE then cpt = c.types->Inner( cpt )
            if c.types->Unqualify( cpt ) = c.types->Unqualify( pt ) then how = 2
        end if
    end if
    if (how = 0) andalso NeedsLetBody_( c, pt ) then how = 1
    '' A DYNAMIC ARRAY MEMBER AND NO WRITTEN COPY CONSTRUCTOR IS A DECLINE.
    ''
    '' fbc synthesises one for such a type and copies the array with fb_ArrayRedimTo
    '' and an element loop; tiko-lang deliberately synthesises none, because an
    '' assignment that skipped the array would look like the field had been handled.
    '' The bitwise fallback is fine for a type whose destructor owns nothing -- fbc
    '' itself memcpys one -- but here the temporary would hold a SECOND descriptor
    '' over the caller's data, and destroying it after the call would erase it.
    if (how = 0) andalso HasDynArrayMember_( c, pt ) then return false

    '' THE SOURCE HAS TO HAVE AN ADDRESS. A copy constructor takes one, and a bitwise
    '' copy of an rvalue that something else already owns would be a second owner of
    '' its buffer -- so an argument with no address DECLINES rather than being copied
    '' some other way.
    dim as MirValue src = LowerAddr( c, argNode )
    if src.kind = cast( ubyte, MV_NONE ) then return false

    dim as long slot = NewTempLocal( c, MT_AGG, sz )
    if slot < 0 then return false
    dim as MirValue dst
    dst.kind = cast( ubyte, MV_LOCAL )
    dst.ty = cast( ubyte, MT_PTR )
    dst.id = slot

    select case how
    case 2
        dim as FB.Array( of ulong ) cargs
        cargs.Push( cast( ulong, src.kind ) )
        cargs.Push( cast( ulong, src.id ) )
        EmitStructorCall( c, cc, -1, @dst, @cargs )
    case 1
        CallImplicitCopy_( c, pt, dst, src )
    case else
        '' fbc emits '__builtin_memcpy( &TMP$4$0, &D$0, 4 )' and nothing else for a
        '' type whose only claim on this path is a destructor.
        dim as MirValue whole = LowerExprLoad( c, src, MT_AGG )
        if whole.kind = cast( ubyte, MV_NONE ) then return false
        StoreThrough( c, dst, whole )
    end select

    if TypeNeedsDtor_( c, pt ) then
        outSlot = slot
        outType = pt
    end if
    outa = dst
    return true
end function

'' The temporaries a call built for its byval UDT arguments, destroyed after it returns
'' and in reverse -- which is the order fbc destroys them in when there is more than one.
private sub DestroyArgTemps_ _
    ( byref c as Ctx, byref slots as FB.Array( of ulong ), _
      byref types as FB.Array( of ulong ) )

    for k as long = slots.Count - 1 to 0 step -1
        dim as Tko.TypeId t = cast( Tko.TypeId, types[k] )
        dim as MirValue a
        a.kind = cast( ubyte, MV_LOCAL )
        a.ty = cast( ubyte, MT_PTR )
        a.id = cast( long, slots[k] )
        dim as Tko.SymbolId dt = StructorWithArity( c, StructorOf( c, t, "__dtor" ), 0 )
        if dt <> Tko.SYMBOL_NONE then
            dim as FB.Array( of ulong ) none_
            EmitStructorCall( c, dt, -1, @a, @none_ )
        else
            CallImplicitDtor_( c, t, a )
        end if
    next
end sub