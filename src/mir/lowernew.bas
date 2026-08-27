'' lowernew.bas -- 'new' AND 'new T[n]'.
''
'' The allocation, the null guard fbc emits inline, and the construction -- one call for
'' the scalar form and a counted loop for the array one.
''
'' Split out of lowerintr.bas at the 1500-line cap and included from it in the same
'' place. Nothing in them changed in the move.

'' 'new T[n]' -- THE ARRAY FORM.
''
'' Measured from what fbc emits for 'new C[3]' over a type with a constructor:
''
''     void* vr = calloc( 12ull, 1ull );          n * sizeof( T ), folded into the
''     TMP2 = (struct C*)vr;                      first argument as the scalar form
''     if( TMP2 == 0 ) goto DONE;                 does
''     TMP4 = TMP2;  TMP3 = 3ull;
''     LOOP: if( TMP3 == 0 ) goto DONE;
''           _ZN1CC1Ev( TMP4 );                   one constructor call per element
''           TMP4 = (struct C*)((uint8*)TMP4 + 4);
''           TMP3 = TMP3 - 1;
''           goto LOOP;
''     DONE: P = TMP2;
''
'' -- so the count is a RUNTIME value, the loop runs backwards to zero, and the whole
'' thing is guarded by the same null check the scalar form has. There is no cookie: a
'' trivial destructor needs no count and fbc emits none.
''
'' fbc accepts no constructor ARGUMENTS in this form, so the child list holds the count
'' and nothing else.
private function LowerNewArray_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byval np as Tko.ListPayload ptr, _
      byref outv as MirValue ) as boolean

    if np->count <> 1 then return false
    dim as Tko.TypeId el = c.info->TypeOf_( np->target )
    if el = Tko.TYPE_NONE then return false
    dim as long esz = SizeOfType( c, el )
    if esz <= 0 then return false

    dim as MirType zt = MT_I64
    if c.types->target.pointerBits = 32 then zt = MT_I32

    '' THE COUNT, once: it is an expression and may have a side effect -- the corpus
    '' writes 'new ClassUDT[sidefx( )]' precisely to check that it runs once.
    dim as Tko.NodeId cntE = cast( Tko.NodeId, c.ast->children[np->first] )
    dim as MirValue cnt0 = LowerExpr( c, cntE )
    if cnt0.kind = cast( ubyte, MV_NONE ) then return false
    dim as MirValue cnt = Coerce( c, cnt0, zt, _
                                  IsUnsignedType( c, c.info->TypeOf_( cntE ) ) )

    '' n * sizeof( T ), folded into calloc's FIRST argument as the scalar form does.
    dim as MirInst mul
    mul.op = cast( ushort, M_MUL )
    mul.ty = cast( ubyte, zt )
    mul.a = cnt
    mul.b = ConstInt( c, esz, zt )
    dim as MirValue bytes_ = Emit( c, mul )
    if bytes_.kind = cast( ubyte, MV_NONE ) then return false

    dim as FB.Array( of ulong ) aa
    aa.Push( cast( ulong, bytes_.kind ) ) : aa.Push( cast( ulong, bytes_.id ) )
    aa.Push( cast( ulong, MV_CONST_INT ) ) : aa.Push( 1 )
    dim as MirValue raw = EmitRtl( c, RTL_CALLOC, aa )
    if raw.kind = cast( ubyte, MV_NONE ) then return false

    dim as long pbytes = c.types->target.pointerBits \ 8
    dim as long slot = NewTempLocal( c, MT_PTR, pbytes )
    if slot < 0 then return false
    dim as MirValue saddr
    saddr.kind = cast( ubyte, MV_LOCAL )
    saddr.ty = cast( ubyte, MT_PTR )
    saddr.id = slot
    StoreThrough( c, saddr, raw )

    '' A CONSTRUCTOR PER ELEMENT, guarded by the null check and counted down. A type
    '' with none needs no loop at all: calloc has already zeroed the storage.
    dim as Tko.SymbolId ctor = CtorOf_( c, el, 0 )
    dim as boolean implCtor = false
    if ctor = Tko.SYMBOL_NONE then
        implCtor = (c.types->Kind( el ) = Tko.TK_UDT) andalso TypeNeedsInit_( c, el )
    end if

    if (ctor <> Tko.SYMBOL_NONE) orelse implCtor then
        dim as long cursor = NewTempLocal( c, MT_PTR, pbytes )
        dim as long left_ = NewTempLocal( c, zt, TyWidthBytes_( zt ) )
        if (cursor < 0) orelse (left_ < 0) then return false
        dim as MirValue cur, rem_
        cur.kind = cast( ubyte, MV_LOCAL ) : cur.ty = cast( ubyte, MT_PTR ) : cur.id = cursor
        rem_.kind = cast( ubyte, MV_LOCAL ) : rem_.ty = cast( ubyte, MT_PTR ) : rem_.id = left_

        dim as MirValue pv0 = LowerExprLoad( c, saddr, MT_PTR )
        if pv0.kind = cast( ubyte, MV_NONE ) then return false
        dim as MirInst nz
        nz.op = cast( ushort, M_ICMP_NE )
        nz.ty = cast( ubyte, MT_I32 )
        nz.a = pv0
        nz.b = ConstInt( c, 0, MT_PTR )
        dim as MirValue okv = Emit( c, nz )
        if okv.kind = cast( ubyte, MV_NONE ) then return false

        dim as long initB = NewBlock( c, "newarr.init" )
        dim as long testB = NewBlock( c, "newarr.test" )
        dim as long bodyB = NewBlock( c, "newarr.body" )
        dim as long doneB = NewBlock( c, "newarr.done" )
        Terminate( c, MTERM_CONDBR, initB, doneB, okv )

        c.curBlock = initB
        StoreThrough( c, cur, pv0 )
        StoreThrough( c, rem_, cnt )
        Terminate( c, MTERM_BR, testB, -1, NoVal( ) )

        c.curBlock = testB
        dim as MirValue rv = LowerExprLoad( c, rem_, zt )
        if rv.kind = cast( ubyte, MV_NONE ) then return false
        dim as MirInst more
        more.op = cast( ushort, M_ICMP_NE )
        more.ty = cast( ubyte, MT_I32 )
        more.a = rv
        more.b = ConstInt( c, 0, zt )
        dim as MirValue mv = Emit( c, more )
        if mv.kind = cast( ubyte, MV_NONE ) then return false
        Terminate( c, MTERM_CONDBR, bodyB, doneB, mv )

        c.curBlock = bodyB
        dim as MirValue ev = LowerExprLoad( c, cur, MT_PTR )
        if ev.kind = cast( ubyte, MV_NONE ) then return false
        dim as FB.Array( of ulong ) noargs
        if ctor <> Tko.SYMBOL_NONE then
            EmitStructorCall( c, ctor, -1, @ev, @noargs )
        else
            CallImplicitCtor_( c, el, ev )
        end if
        dim as MirInst adv
        adv.op = cast( ushort, M_PTR_ADD )
        adv.ty = cast( ubyte, MT_PTR )
        adv.a = ev
        adv.b = ConstInt( c, esz, zt )
        dim as MirValue nx = Emit( c, adv )
        if nx.kind = cast( ubyte, MV_NONE ) then return false
        StoreThrough( c, cur, nx )
        dim as MirValue rv2 = LowerExprLoad( c, rem_, zt )
        if rv2.kind = cast( ubyte, MV_NONE ) then return false
        dim as MirInst dec
        dec.op = cast( ushort, M_SUB )
        dec.ty = cast( ubyte, zt )
        dec.a = rv2
        dec.b = ConstInt( c, 1, zt )
        StoreThrough( c, rem_, Emit( c, dec ) )
        Terminate( c, MTERM_BR, testB, -1, NoVal( ) )

        c.curBlock = doneB
    end if

    outv = LowerExprLoad( c, saddr, MT_PTR )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

function LowerNew_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

    if c.ast->Kind( id ) <> Tko.N_NEW then return false
    dim as Tko.ListPayload ptr np = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if np->target = Tko.NODE_NONE then return false
    if (c.ast->nodes[cast( long, id )].flags and Tko.NF_ARRAY) <> 0 then
        return LowerNewArray_( c, id, np, outv )
    end if

    dim as Tko.TypeId el = c.info->TypeOf_( np->target )
    if el = Tko.TYPE_NONE then return false
    dim as long esz = SizeOfType( c, el )
    if esz <= 0 then return false

    '' calloc( bytes, 1 ). The second argument is the ELEMENT COUNT and fbc always
    '' passes 1, folding the whole size into the first -- not the other way round.
    dim as FB.Array( of ulong ) aa
    aa.Push( cast( ulong, MV_CONST_INT ) ) : aa.Push( cast( ulong, esz ) )
    aa.Push( cast( ulong, MV_CONST_INT ) ) : aa.Push( 1 )
    dim as MirValue raw = EmitRtl( c, RTL_CALLOC, aa )
    if raw.kind = cast( ubyte, MV_NONE ) then return false

    '' The allocation lives in a slot, because the construction below is a BRANCH and
    '' the value has to survive the join.
    dim as long slot = NewTempLocal( c, MT_PTR, c.types->target.pointerBits \ 8 )
    if slot < 0 then return false
    dim as MirValue saddr
    saddr.kind = cast( ubyte, MV_LOCAL )
    saddr.ty = cast( ubyte, MT_PTR )
    saddr.id = slot
    dim as MirInst st0
    st0.op = cast( ushort, M_STORE )
    st0.ty = cast( ubyte, MT_VOID )
    st0.a = saddr
    st0.b = raw
    Emit( c, st0 )

    '' A CONSTRUCTOR, guarded by the null check fbc emits inline.
    ''
    '' INCLUDING THE ONE FBC WRITES FOR YOU. 'new T' over a type with a string field
    '' allocated the object and constructed nothing -- calloc's zeroing happens to
    '' leave a valid empty descriptor, so it survived, but a type with a base, a vptr
    '' or a nested constructor got none of them and the vptr in particular stayed null.
    dim as Tko.SymbolId ctor = CtorOf_( c, el, np->count )
    dim as boolean implCtor = false
    if (ctor = Tko.SYMBOL_NONE) andalso (np->count = 0) then
        implCtor = (c.types->Kind( el ) = Tko.TK_UDT) andalso TypeNeedsInit_( c, el )
    end if
    dim as FB.Array( of ulong ) cargs
    if ctor <> Tko.SYMBOL_NONE then
        '' THE ARGUMENTS BEFORE THE BRANCH. fbc evaluates them where the 'new' is
        '' written, not inside the null-guarded arm -- which matters the moment one has
        '' a side effect.
        '' THE SAME ARGUMENTS AN ORDINARY CONSTRUCTOR CALL GETS. This pushed each one
        '' as a plain expression, so 'new T( b( ) )' -- an ARRAY argument, which has no
        '' value and travels as a descriptor -- produced nothing, while the identical
        '' 'T( b( ) )' one line away lowered.
        if PushCtorArgs_( c, ctor, np->first, np->count, cargs ) = false then return false
    end if
    if (ctor <> Tko.SYMBOL_NONE) orelse implCtor then
        dim as MirValue pv = LowerExprLoad( c, saddr, MT_PTR )
        if pv.kind = cast( ubyte, MV_NONE ) then return false
        dim as MirValue zero = ConstInt( c, 0, MT_PTR )
        dim as MirInst cmp
        cmp.op = cast( ushort, M_ICMP_NE )
        cmp.ty = cast( ubyte, MT_I32 )
        cmp.a = pv
        cmp.b = zero
        dim as MirValue cond = Emit( c, cmp )
        if cond.kind = cast( ubyte, MV_NONE ) then return false

        dim as long bodyB = NewBlock( c, "new.ctor" )
        dim as long joinB = NewBlock( c, "new.join" )
        Terminate( c, MTERM_CONDBR, bodyB, joinB, cond )
        c.curBlock = bodyB
        if ctor <> Tko.SYMBOL_NONE then
            EmitStructorCall( c, ctor, -1, @pv, @cargs )
        else
            CallImplicitCtor_( c, el, pv )
        end if
        Terminate( c, MTERM_BR, joinB, -1, NoVal( ) )
        c.curBlock = joinB
    end if

    outv = LowerExprLoad( c, saddr, MT_PTR )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function
