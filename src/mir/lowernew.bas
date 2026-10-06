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
'' trivial destructor needs no count and fbc emits none. A type WITH ONE gets the cookie
'' (T37) -- see 'THE COOKIE' below, and LowerDeleteArray_ for the other half.
''
'' fbc accepts no constructor ARGUMENTS in this form, so the child list holds the count
'' and nothing else.
private function LowerNewArray_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byval np as Tko.ListPayload ptr, _
      byref outv as MirValue ) as boolean

    '' PLACEMENT: the pointer is child 0 and the COUNT follows it.
    dim as boolean isPlace = _
        ((c.ast->nodes[cast( long, id )].flags and Tko.NF_PLACEMENT) <> 0)
    dim as long cntAt = np->first
    if isPlace then
        if np->count <> 2 then return false
        cntAt += 1
    elseif np->count <> 1 then
        return false
    end if
    '' 'new const A' ALLOCATES AND CONSTRUCTS EXACTLY AS 'new A' DOES -- the const
    '' is on the RESULT POINTER's target, not on the allocation. Measured, fbc
    '' emits the same calloc and the same '_ZN1AC1Ev( TMP )' for both. Left
    '' qualified, the element type is a TK_QUALIFIED and every lookup below --
    '' the size, the constructor, the vptr -- asks for a UDT and gets nothing,
    '' so the whole 'dim p as const A ptr = new const A' declined.
    dim as Tko.TypeId el = c.types->Unqualify( c.info->TypeOf_( np->target ) )
    if el = Tko.TYPE_NONE then return false
    dim as long esz = SizeOfType( c, el )
    if esz <= 0 then return false

    dim as MirType zt = MT_I64
    if c.types->target.pointerBits = 32 then zt = MT_I32

    '' THE COUNT, once: it is an expression and may have a side effect -- the corpus
    '' writes 'new ClassUDT[sidefx( )]' precisely to check that it runs once.
    dim as Tko.NodeId cntE = cast( Tko.NodeId, c.ast->children[cntAt] )
    dim as MirValue cnt0 = LowerExpr( c, cntE )
    if cnt0.kind = cast( ubyte, MV_NONE ) then return false
    dim as MirValue cnt = CoerceTy( c, cnt0, zt, c.info->TypeOf_( cntE ) )

    '' n * sizeof( T ), folded into calloc's FIRST argument as the scalar form does.
    dim as MirInst mul
    mul.op = cast( ushort, M_MUL )
    mul.ty = cast( ubyte, zt )
    mul.a = cnt
    mul.b = ConstInt( c, esz, zt )
    dim as MirValue bytes_ = Emit( c, mul )
    if bytes_.kind = cast( ubyte, MV_NONE ) then return false

    '' THE COOKIE (T37), keyed on "the type has a destructor" -- a written one or the one
    '' fbc writes for a string field -- and never on a placement array. Measured:
    ''
    ''     void* vr = calloc( 20ull, 1ull );        3 * 4 + 8: the header is in the size,
    ''     if( TMP == 0 ) goto DONE;                and in what 'operator new[]' and the
    ''     *(uint64*)TMP = 3ull;                    '{ any }' malloc are handed too
    ''     TMP = (struct NOISY*)((uint8*)TMP + 8ll);
    ''
    '' Without it 'delete[]' had no count, declined, and ran no destructor at all.
    dim as long ckBytes = c.types->target.pointerBits \ 8
    dim as boolean cookie = false
    if isPlace = false then
        cookie = (DtorOf_( c, el ) <> Tko.SYMBOL_NONE)
        if cookie = false then
            if c.types->Kind( el ) = Tko.TK_UDT then cookie = TypeNeedsDtor_( c, el )
        end if
    end if
    if cookie then
        dim as MirInst hdr
        hdr.op = cast( ushort, M_ADD )
        hdr.ty = cast( ubyte, zt )
        hdr.a = bytes_
        hdr.b = ConstInt( c, ckBytes, zt )
        bytes_ = Emit( c, hdr )
        if bytes_.kind = cast( ubyte, MV_NONE ) then return false
    end if

    '' A PLACEMENT ARRAY ALLOCATES NOTHING EITHER, and it has no cookie to write,
    '' so the byte count computed above is used only to ZERO a trivial element type.
    '' Measured, over an element with no constructor:
    ''
    ''     TMP$12$0 = (int64*)BUF$0;
    ''     if( TMP$12$0 == (int64*)0ull) goto label$18;
    ''     __builtin_memset( TMP$12$0, 0, 24ull );
    ''     label$18:;
    ''
    '' An element WITH a constructor gets the same count-down loop the ordinary form
    '' already emits, over the placement pointer.
    '' 'new T[n] { any }' CHANGES ANYTHING ONLY OVER AN ELEMENT NOTHING CONSTRUCTS; over
    '' one with a constructor fbc warns (19) that it has no effect. Measured: 'new V[3]
    '' {any}' is malloc( 24 ) with no memset, and its placement form drops the memset.
    dim as boolean noInit = ((c.ast->nodes[cast( long, id )].flags and Tko.NF_NOINIT) <> 0)
    if noInit then noInit = (CtorOf_( c, el, 0 ) = Tko.SYMBOL_NONE)
    if noInit then
        if c.types->Kind( el ) = Tko.TK_UDT then noInit = (TypeNeedsInit_( c, el ) = false)
    end if

    dim as MirValue raw
    if isPlace then
        dim as Tko.NodeId pe = cast( Tko.NodeId, c.ast->children[np->first] )
        raw = LowerExpr( c, pe )
        if raw.kind = cast( ubyte, MV_NONE ) then return false
        raw = Coerce( c, raw, MT_PTR, true )
    else
        '' ...AND THE ARRAY FORM TAKES 'operator new[]', which is a DIFFERENT operator
        '' with its own Itanium code -- _ZN3BARnaEu8UINTEGER against the scalar's
        '' _ZN3BARnwEu8UINTEGER. Measured, fbc calls it with the WHOLE byte count,
        '' header included: 'new bar[2]' over an 8-byte bar is new[]16.
        dim as Tko.SymbolId opNewA = _
            StructorWithArity( c, StructorOf( c, el, "new[]" ), 1 )
        if opNewA <> Tko.SYMBOL_NONE then
            dim as FB.Array( of ulong ) nb
            nb.Push( cast( ulong, bytes_.kind ) ) : nb.Push( cast( ulong, bytes_.id ) )
            raw = EmitDirectCall_( c, opNewA, MT_PTR, nb )
        elseif noInit then
            dim as FB.Array( of ulong ) ma
            ma.Push( cast( ulong, bytes_.kind ) ) : ma.Push( cast( ulong, bytes_.id ) )
            raw = EmitRtl( c, RTL_MALLOC, ma )
        else
            dim as FB.Array( of ulong ) aa
            aa.Push( cast( ulong, bytes_.kind ) ) : aa.Push( cast( ulong, bytes_.id ) )
            aa.Push( cast( ulong, MV_CONST_INT ) ) : aa.Push( 1 )
            raw = EmitRtl( c, RTL_CALLOC, aa )
        end if
    end if
    if raw.kind = cast( ubyte, MV_NONE ) then return false

    dim as long pbytes = c.types->target.pointerBits \ 8
    dim as long slot = NewTempLocal( c, MT_PTR, pbytes )
    if slot < 0 then return false
    dim as MirValue saddr
    saddr.kind = cast( ubyte, MV_LOCAL )
    saddr.ty = cast( ubyte, MT_PTR )
    saddr.id = slot
    StoreThrough( c, saddr, raw )

    '' The count at offset 0 and the pointer past it, inside the allocation's null check.
    if cookie then
        dim as MirInst ckz
        ckz.op = cast( ushort, M_ICMP_NE )
        ckz.ty = cast( ubyte, MT_I32 )
        ckz.a = raw
        ckz.b = ConstInt( c, 0, MT_PTR )
        dim as MirValue ckok = Emit( c, ckz )
        if ckok.kind = cast( ubyte, MV_NONE ) then return false
        dim as long ckB = NewBlock( c, "newarr.cookie" )
        dim as long ckJ = NewBlock( c, "newarr.cookied" )
        Terminate( c, MTERM_CONDBR, ckB, ckJ, ckok )
        c.curBlock = ckB
        StoreThrough( c, raw, cnt )
        dim as MirInst bump
        bump.op = cast( ushort, M_PTR_ADD )
        bump.ty = cast( ubyte, MT_PTR )
        bump.a = raw
        bump.b = ConstInt( c, ckBytes, zt )
        dim as MirValue past = Emit( c, bump )
        if past.kind = cast( ubyte, MV_NONE ) then return false
        StoreThrough( c, saddr, past )
        Terminate( c, MTERM_BR, ckJ, -1, NoVal( ) )
        c.curBlock = ckJ
    end if

    '' A CONSTRUCTOR PER ELEMENT, guarded by the null check and counted down. A type
    '' with none needs no loop at all: calloc has already zeroed the storage.
    dim as Tko.SymbolId ctor = CtorOf_( c, el, 0 )
    dim as boolean implCtor = false
    if ctor = Tko.SYMBOL_NONE then
        implCtor = (c.types->Kind( el ) = Tko.TK_UDT) andalso TypeNeedsInit_( c, el )
    end if

    '' A PLACEMENT ARRAY OF A TRIVIAL ELEMENT STILL HAS TO BE ZEROED: there is no
    '' calloc to have done it. Measured as one memset over the whole n * sizeof( T ).
    dim as boolean zeroArr = isPlace
    if zeroArr then zeroArr = (noInit = false)
    if zeroArr then zeroArr = (ctor = Tko.SYMBOL_NONE)
    if zeroArr then zeroArr = (implCtor = false)
    if zeroArr then
        dim as MirValue zp = LowerExprLoad( c, saddr, MT_PTR )
        if zp.kind = cast( ubyte, MV_NONE ) then return false
        dim as MirInst zc
        zc.op = cast( ushort, M_ICMP_NE )
        zc.ty = cast( ubyte, MT_I32 )
        zc.a = zp
        zc.b = ConstInt( c, 0, MT_PTR )
        dim as MirValue zcond = Emit( c, zc )
        if zcond.kind = cast( ubyte, MV_NONE ) then return false
        dim as long zbody = NewBlock( c, "newp.zero" )
        dim as long zjoin = NewBlock( c, "newp.join" )
        Terminate( c, MTERM_CONDBR, zbody, zjoin, zcond )
        c.curBlock = zbody
        dim as FB.Array( of ulong ) za
        za.Push( cast( ulong, zp.kind ) ) : za.Push( cast( ulong, zp.id ) )
        za.Push( cast( ulong, MV_CONST_INT ) ) : za.Push( 0 )
        za.Push( cast( ulong, bytes_.kind ) ) : za.Push( cast( ulong, bytes_.id ) )
        EmitRtl( c, RTL_MEMSET, za )
        Terminate( c, MTERM_BR, zjoin, -1, NoVal( ) )
        c.curBlock = zjoin
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

'' Whether the first 'n' fields of 'el' can take the 'n' arguments one value each -- a
'' scalar, or a record given a value of exactly its type -- the shape LowerBaseFieldInit_
'' fills (T32).
private function ScalarFieldList_ _
    ( byref c as Ctx, byval el as Tko.TypeId, byval n as long, byval first_ as long ) as boolean
    dim as long ui = c.udts->Find( el )
    if ui < 0 then return false
    dim as long f0 = c.udts->udts[ui].first
    if n > c.udts->udts[ui].count then return false
    for i as long = 0 to n - 1
        dim as MirType fmt = LowerType( c.udts->fields[f0 + i].type_, *c.types )
        if fmt = MT_VOID then return false
        '' A record field needs an argument of exactly its type (LowerBaseFieldInit_).
        if fmt = MT_AGG then
            dim as Tko.NodeId a = cast( Tko.NodeId, c.ast->children[first_ + i] )
            if c.types->Unqualify( c.info->TypeOf_( a ) ) <> _
               c.types->Unqualify( c.udts->fields[f0 + i].type_ ) then return false
        end if
    next
    return true
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

    '' 'new const A' ALLOCATES AND CONSTRUCTS EXACTLY AS 'new A' DOES -- the const
    '' is on the RESULT POINTER's target, not on the allocation. Measured, fbc
    '' emits the same calloc and the same '_ZN1AC1Ev( TMP )' for both. Left
    '' qualified, the element type is a TK_QUALIFIED and every lookup below --
    '' the size, the constructor, the vptr -- asks for a UDT and gets nothing,
    '' so the whole 'dim p as const A ptr = new const A' declined.
    dim as Tko.TypeId el = c.types->Unqualify( c.info->TypeOf_( np->target ) )
    if el = Tko.TYPE_NONE then return false
    dim as long esz = SizeOfType( c, el )
    if esz <= 0 then return false

    '' PLACEMENT NEW ALLOCATES NOTHING: the pointer is the one written, cast to the
    '' type. Everything after it -- the null guard, the constructor, the result -- is
    '' the same, which is why this is one value and not a second path.
    ''
    '' Measured, and the placement expression is evaluated BEFORE the guard:
    ''
    ''     TMP$2$0 = (struct $5PLAIN*)BUF$0;
    ''     if( TMP$2$0 == (struct $5PLAIN*)0ull) goto label$10;
    ''     __builtin_memset( TMP$2$0, 0, 8ull );
    ''     label$10:;
    dim as boolean isPlace = _
        ((c.ast->nodes[cast( long, id )].flags and Tko.NF_PLACEMENT) <> 0)
    '' 'new T( any )' -- allocated and NOT initialised: no constructor, no zeroing.
    dim as boolean noInit = ((c.ast->nodes[cast( long, id )].flags and Tko.NF_NOINIT) <> 0)
    dim as long argFirst = np->first
    dim as long argCount = np->count
    dim as MirValue raw
    if isPlace then
        if argCount < 1 then return false
        dim as Tko.NodeId pe = cast( Tko.NodeId, c.ast->children[argFirst] )
        argFirst += 1
        argCount -= 1
        raw = LowerExpr( c, pe )
        if raw.kind = cast( ubyte, MV_NONE ) then return false
        raw = Coerce( c, raw, MT_PTR, true )
    else
        '' A TYPE'S OWN 'operator new' IS THE ALLOCATOR, and it was never asked for.
        '' Measured, fbc calls it and prints from inside it:
        ''
        ''     type bar : declare static operator new( byval size as uinteger ) ...
        ''     dim as bar ptr p = new bar     ->  _ZN3BARnwEu8UINTEGER( 8 )
        ''
        '' tiko emitted the runtime calloc instead, so a type that manages its own
        '' storage silently got the wrong allocator -- and its operator, which tiko
        '' already mangles and EMITS correctly, was never called by anything.
        '' tests/mir/src/operator-new-delete.bas printed nothing at all where fbc
        '' prints four lines.
        ''
        '' STATIC, so there is no receiver: 'void* _ZN3BARnwEu8UINTEGER( uint64 )'
        '' takes the BYTE SIZE and nothing else.
        dim as Tko.SymbolId opNew = _
            StructorWithArity( c, StructorOf( c, el, "new" ), 1 )
        if opNew <> Tko.SYMBOL_NONE then
            dim as FB.Array( of ulong ) na
            na.Push( cast( ulong, MV_CONST_INT ) ) : na.Push( cast( ulong, esz ) )
            raw = EmitDirectCall_( c, opNew, MT_PTR, na )
        elseif noInit then
            '' 'new T( any )': malloc( bytes ), which zeroes nothing.
            dim as FB.Array( of ulong ) ma
            ma.Push( cast( ulong, MV_CONST_INT ) ) : ma.Push( cast( ulong, esz ) )
            raw = EmitRtl( c, RTL_MALLOC, ma )
        else
            '' calloc( bytes, 1 ). The second argument is the ELEMENT COUNT and fbc always
            '' passes 1, folding the whole size into the first -- not the other way round.
            dim as FB.Array( of ulong ) aa
            aa.Push( cast( ulong, MV_CONST_INT ) ) : aa.Push( cast( ulong, esz ) )
            aa.Push( cast( ulong, MV_CONST_INT ) ) : aa.Push( 1 )
            raw = EmitRtl( c, RTL_CALLOC, aa )
        end if
    end if
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
    '' PICKED BY THE ARGUMENT TYPES, with arity as the fallback -- the same rule, and
    '' for the same reason, as LowerUdtParenInit_ in lowerctor.bas.
    ''
    '' CtorOf_ takes the first constructor in the overload chain with that ARITY. A
    '' type with both 'constructor( byval x as long )' and 'constructor( byref o as T )'
    '' has two of arity one, so which one 'new T( v )' called depended on WHICH WAS
    '' DECLARED FIRST. With the copy constructor last, 'new T( v )' loaded v as a VALUE
    '' for the long parameter, then fell out of the lowering entirely: no constructor
    '' call, no result, and a function whose 'ret' carried nothing against a signature
    '' returning a pointer -- 'ret void' in a 'func ptr'. fb/sharedptr.bi's
    '' MakeSharedFrom is exactly 'new T( v )'.
    '' 'new T( type( 123 ) )' -- AN UNNAMED TYPE LITERAL AS THE ONLY ARGUMENT is T's field
    '' list: the literal takes T, the type being built (pointers/new-delete.bas). Check typed
    '' it a one-element tuple, so nothing below matched and the statement declined. Its
    '' elements stand in for the arguments -- for a type with NO constructor only, where
    '' that is exactly 'new T( 123 )'; a constructed T would also need the copy.
    if (argCount = 1) andalso (c.types->Kind( el ) = Tko.TK_UDT) then
        dim as Tko.NodeId tla = cast( Tko.NodeId, c.ast->children[argFirst] )
        if c.ast->Kind( tla ) = Tko.N_TUPLE then
            if (c.ast->nodes[cast( long, tla )].flags and Tko.NF_TYPE_LITERAL) <> 0 then
                dim as Tko.ListPayload ptr tlp = _
                    @c.ast->lists[cast( long, c.ast->nodes[cast( long, tla )].data )]
                if (tlp->target = Tko.NODE_NONE) andalso (tlp->count >= 1) then
                    if StructorOf( c, el, "__ctor" ) = Tko.SYMBOL_NONE then
                        argFirst = tlp->first
                        argCount = tlp->count
                    end if
                end if
            end if
        end if
    end if

    dim as Tko.SymbolId ctor = Tko.SYMBOL_NONE
    if (argCount > 0) andalso (c.types->Kind( el ) = Tko.TK_UDT) then
        dim as FB.Array( of ulong ) ctArgT
        dim as boolean ctTyped = true
        for i as long = 0 to argCount - 1
            dim as Tko.NodeId an = cast( Tko.NodeId, c.ast->children[argFirst + i] )
            dim as Tko.TypeId at3 = c.info->TypeOf_( an )
            if at3 = Tko.TYPE_NONE then
                ctTyped = false
                exit for
            end if
            ctArgT.Push( cast( ulong, at3 ) )
        next
        if ctTyped then ctor = PickCtor( c, StructorOf( c, el, "__ctor" ), ctArgT )
    end if
    if ctor = Tko.SYMBOL_NONE then ctor = CtorOf_( c, el, argCount )
    if noInit then ctor = Tko.SYMBOL_NONE
    dim as boolean implCtor = false
    dim as boolean implCand = (ctor = Tko.SYMBOL_NONE) andalso (argCount = 0)
    if noInit then implCand = false
    if implCand then
        implCtor = (c.types->Kind( el ) = Tko.TK_UDT) andalso TypeNeedsInit_( c, el )
    end if

    '' A SCALAR NEW WITH AN INITIALISER -- 'new integer( 111 )'. There is no
    '' constructor to find, so this fell past every branch below and the value was
    '' DROPPED: the allocation happened, calloc's zeroing stood in for it, and the
    '' statement lowered and verified with the 111 nowhere in the output.
    ''
    '' Measured, and it sits inside the same null guard a constructor call does:
    ''
    ''     TMP$2$0 = (int64*)vr$0;
    ''     if( TMP$2$0 == (int64*)0ull) goto label$2;
    ''     *TMP$2$0 = 111ll;
    ''     label$2:;
    dim as boolean scalarInit = false
    if (ctor = Tko.SYMBOL_NONE) andalso (argCount = 1) then
        dim as MirType emt = LowerType( el, *c.types )
        scalarInit = (emt <> MT_VOID) andalso (emt <> MT_AGG)
        '' ...AND A VAR-LENGTH STRING, which lowers as an aggregate and so fell past this:
        '' 'new string( "newstr" )' came back calloc-empty. Measured, fbc initialises the
        '' descriptor inside the same guard: 'fb_StrInit( TMP, -1, "newstr", 7, 0 )'.
        if scalarInit = false then scalarInit = IsStringType( c, el )
    end if

    '' 'new T( x )' WITH x A T, AND NO COPY CONSTRUCTOR OF T's OWN, IS THE IMPLICIT ONE.
    '' Nothing matched, T is not a scalar, and so the argument was DROPPED: the object
    '' came back calloc-zeroed -- its vptr null -- and the first virtual call through it
    '' crashed (the FreeBASIC manual's covariant clone( ): 'new myDerived( this )').
    '' Measured, fbc synthesises the copy constructor and calls it inside the guard:
    ''
    ''     if( TMP == 0 ) goto label;  _ZN9MYDERIVEDC1ERKS_( TMP, THIS );  label:;
    ''
    '' A DERIVED x SLICES, as it does in 'dim as T y = x': the copy constructor installs
    '' T's own vptr and assigns T's members. The source's address is taken where the
    '' 'new' is written, as every other argument is.
    dim as boolean implCopy = false
    dim as MirValue copySrc
    if cbool( ctor = Tko.SYMBOL_NONE ) andalso cbool( argCount = 1 ) andalso (isPlace = false) andalso _
       cbool( c.types->Kind( el ) = Tko.TK_UDT ) then
        dim as Tko.NodeId csn = cast( Tko.NodeId, c.ast->children[argFirst] )
        dim as Tko.TypeId cst = c.types->Unqualify( c.info->TypeOf_( csn ) )
        if c.types->Kind( cst ) = Tko.TK_REFERENCE then
            cst = c.types->Unqualify( c.types->Inner( cst ) )
        end if
        '' 'THIS' HOLDS A POINTER -- tiko types it 'T ptr' -- and names the object it points
        '' at; InitSourceAddr_ loads it for the same reason.
        if IsThisPointerIdent_( c, csn ) then cst = c.types->Unqualify( c.types->Inner( cst ) )
        if c.types->BaseDistance( cst, el ) >= 0 then
            copySrc = InitSourceAddr_( c, csn )
            implCopy = (copySrc.kind <> cast( ubyte, MV_NONE ))
        end if
    end if

    '' 'new T( a, b )' OVER A TYPE WITH NO CONSTRUCTOR FILLS ITS FIELDS IN ORDER, as
    '' 'dim as T x = ( a, b )' does (T32). Nothing above matched it, so the arguments were
    '' dropped and 'new Point( 3, 4 )' came back calloc-zeroed, '0 0', where fbc gives
    '' '3 4'. The field-by-field initialiser is the one 'base( ... )' uses for a base with
    '' no constructor, run inside the same null guard as every other initialiser here.
    dim as boolean fieldInit = false
    '' PLAIN DATA ONLY: a type that needs construction -- a string field, say -- takes no
    '' field list from 'new', and fbc refuses one (error 99).
    dim as boolean fiCand = (ctor = Tko.SYMBOL_NONE) andalso (argCount >= 1)
    fiCand = fiCand andalso (implCopy = false) andalso (scalarInit = false)
    if fiCand andalso (c.types->Kind( el ) = Tko.TK_UDT) then
        fieldInit = (TypeNeedsInit_( c, el ) = false)
        '' ...AND ONLY A LIST OF SCALAR FIELDS, decided BEFORE the guard is built: the
        '' field-by-field initialiser refuses a record-typed field, and refusing after
        '' the branch was emitted left a block with no terminator.
        if fieldInit then fieldInit = ScalarFieldList_( c, el, argCount, argFirst )
    end if

    '' PLACEMENT NEW OVER A TYPE WITH NO CONSTRUCTOR ZEROES, because there is no
    '' calloc to have done it. Measured: '__builtin_memset( TMP$2$0, 0, 8ull )', and
    '' fbc emits NO memset when a constructor runs or when a scalar initialiser is
    '' written -- both write the bytes themselves.
    dim as boolean placeZero = false
    if isPlace then
        dim as boolean noCtor = (ctor = Tko.SYMBOL_NONE)
        if noCtor then noCtor = (implCtor = false)
        if noCtor then noCtor = (scalarInit = false)
        if noCtor then noCtor = (fieldInit = false)
        placeZero = noCtor
    end if
    dim as FB.Array( of ulong ) cargs
    if (ctor <> Tko.SYMBOL_NONE) andalso (isPlace = false) then
        '' THE ARGUMENTS BEFORE THE BRANCH. fbc evaluates them where the 'new' is
        '' written, not inside the null-guarded arm -- which matters the moment one has
        '' a side effect.
        '' THE SAME ARGUMENTS AN ORDINARY CONSTRUCTOR CALL GETS. This pushed each one
        '' as a plain expression, so 'new T( b( ) )' -- an ARRAY argument, which has no
        '' value and travels as a descriptor -- produced nothing, while the identical
        '' 'T( b( ) )' one line away lowered.
        if PushCtorArgs_( c, ctor, argFirst, argCount, cargs ) = false then return false
    end if
    dim as boolean needsGuard = (ctor <> Tko.SYMBOL_NONE) orelse implCtor
    if needsGuard = false then needsGuard = scalarInit
    if needsGuard = false then needsGuard = implCopy
    if needsGuard = false then needsGuard = placeZero
    if needsGuard = false then needsGuard = fieldInit
    if needsGuard then
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
        '' A PLACEMENT NEW'S CONSTRUCTOR ARGUMENTS ARE EVALUATED INSIDE THE GUARD.
        '' Measured, with a side-effecting placement expression and a side-effecting
        '' argument: the placement call runs before the branch and the argument call
        '' after it. An ordinary 'new' evaluates its arguments where the 'new' is
        '' written, which is why the two are pushed in different places.
        if isPlace andalso (ctor <> Tko.SYMBOL_NONE) then
            if PushCtorArgs_( c, ctor, argFirst, argCount, cargs ) = false then
                return false
            end if
        end if
        if ctor <> Tko.SYMBOL_NONE then
            EmitStructorCall( c, ctor, -1, @pv, @cargs )
        elseif implCopy then
            CallImplicitCopy_( c, el, pv, copySrc )
        elseif scalarInit andalso IsStringType( c, el ) then
            '' calloc zeroed the descriptor, so it is a valid empty string to assign into;
            '' placement storage is zeroed first, as nothing else did it.
            dim as Tko.NodeId sve = cast( Tko.NodeId, c.ast->children[argFirst] )
            if isPlace then ZeroStrDescriptor( c, pv )
            if LowerStringAssignTo( c, pv, Tko.NODE_NONE, sve, _
                    iif( IsUStringType( c, el ), 1, 0 ) ) = false then return false
        elseif scalarInit then
            dim as Tko.NodeId ive = cast( Tko.NodeId, c.ast->children[argFirst] )
            dim as MirValue iv
            if IsUdtValue_( c, ive ) then
                iv = LowerNumArg_( c, ive, LowerType( el, *c.types ) )   '' 'new long( m )': its numeric cast
            else
                iv = LowerExpr( c, ive )
                if iv.kind = cast( ubyte, MV_NONE ) then return false
                iv = CoerceTy( c, iv, LowerType( el, *c.types ), el)
            end if
            if iv.kind = cast( ubyte, MV_NONE ) then return false
            StoreThrough( c, pv, iv )
        elseif fieldInit then
            if LowerBaseFieldInit_( c, pv, el, argFirst, argCount ) = false then return false
        elseif placeZero then
            dim as FB.Array( of ulong ) pz
            pz.Push( cast( ulong, pv.kind ) ) : pz.Push( cast( ulong, pv.id ) )
            pz.Push( cast( ulong, MV_CONST_INT ) ) : pz.Push( 0 )
            pz.Push( cast( ulong, MV_CONST_INT ) ) : pz.Push( cast( ulong, esz ) )
            EmitRtl( c, RTL_MEMSET, pz )
        else
            CallImplicitCtor_( c, el, pv )
        end if
        Terminate( c, MTERM_BR, joinB, -1, NoVal( ) )
        c.curBlock = joinB
    end if

    outv = LowerExprLoad( c, saddr, MT_PTR )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

'' 'delete[] p' OVER A TYPE WITH A DESTRUCTOR (T37) -- the other half of the cookie
'' LowerNewArray_ writes. Measured, fbc:
''
''     if( P == 0 ) goto DONE;
''     N = *(int64*)((uint8*)P + -8ll);
''     CUR = (struct NOISY*)((uint8*)P + (N << 2));
''     LOOP: if( N == 0 ) goto END;
''           CUR = (struct NOISY*)((uint8*)CUR + -4ll);
''           _ZN5NOISYD1Ev( CUR );                 LAST ELEMENT FIRST
''           N = N - 1;  goto LOOP;
''     END:  free( (void*)((uint8*)P + -8ll) );   or 'operator delete[]', same pointer
''     DONE:
''
'' The destructor is called directly, by the static type, as fbc does for an array.
function LowerDeleteArray_ _
    ( byref c as Ctx, byval pe as Tko.NodeId, byval el as Tko.TypeId, _
      byval dtor as Tko.SymbolId, byval implDtor as boolean ) as boolean

    dim as long esz = SizeOfType( c, c.types->Unqualify( el ) )
    if esz <= 0 then return false
    dim as MirType zt = MT_I64
    if c.types->target.pointerBits = 32 then zt = MT_I32
    dim as long pbytes = c.types->target.pointerBits \ 8

    dim as MirValue p = LowerExpr( c, pe )
    if p.kind = cast( ubyte, MV_NONE ) then return false
    p = Coerce( c, p, MT_PTR )
    dim as MirInst nz
    nz.op = cast( ushort, M_ICMP_NE )
    nz.ty = cast( ubyte, MT_I32 )
    nz.a = p
    nz.b = ConstInt( c, 0, MT_PTR )
    dim as MirValue okv = Emit( c, nz )
    if okv.kind = cast( ubyte, MV_NONE ) then return false
    dim as long bodyB = NewBlock( c, "delarr.body" )
    dim as long testB = NewBlock( c, "delarr.test" )
    dim as long loopB = NewBlock( c, "delarr.loop" )
    dim as long freeB = NewBlock( c, "delarr.free" )
    dim as long joinB = NewBlock( c, "delarr.join" )
    Terminate( c, MTERM_CONDBR, bodyB, joinB, okv )

    c.curBlock = bodyB
    dim as MirInst hb
    hb.op = cast( ushort, M_PTR_ADD )
    hb.ty = cast( ubyte, MT_PTR )
    hb.a = p
    hb.b = ConstInt( c, -pbytes, zt )
    dim as MirValue base_ = Emit( c, hb )
    if base_.kind = cast( ubyte, MV_NONE ) then return false
    dim as MirValue n = LowerExprLoad( c, base_, zt )
    if n.kind = cast( ubyte, MV_NONE ) then return false
    dim as MirInst mul
    mul.op = cast( ushort, M_MUL )
    mul.ty = cast( ubyte, zt )
    mul.a = n
    mul.b = ConstInt( c, esz, zt )
    dim as MirInst endp
    endp.op = cast( ushort, M_PTR_ADD )
    endp.ty = cast( ubyte, MT_PTR )
    endp.a = p
    endp.b = Emit( c, mul )
    dim as MirValue ev = Emit( c, endp )
    if ev.kind = cast( ubyte, MV_NONE ) then return false
    dim as long cursor = NewTempLocal( c, MT_PTR, pbytes )
    dim as long left_ = NewTempLocal( c, zt, TyWidthBytes_( zt ) )
    if (cursor < 0) orelse (left_ < 0) then return false
    dim as MirValue cur, rem_
    cur.kind = cast( ubyte, MV_LOCAL ) : cur.ty = cast( ubyte, MT_PTR ) : cur.id = cursor
    rem_.kind = cast( ubyte, MV_LOCAL ) : rem_.ty = cast( ubyte, MT_PTR ) : rem_.id = left_
    StoreThrough( c, cur, ev )
    StoreThrough( c, rem_, n )
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
    Terminate( c, MTERM_CONDBR, loopB, freeB, mv )

    c.curBlock = loopB
    dim as MirValue cv = LowerExprLoad( c, cur, MT_PTR )
    if cv.kind = cast( ubyte, MV_NONE ) then return false
    dim as MirInst back
    back.op = cast( ushort, M_PTR_ADD )
    back.ty = cast( ubyte, MT_PTR )
    back.a = cv
    back.b = ConstInt( c, -esz, zt )
    dim as MirValue pv = Emit( c, back )
    if pv.kind = cast( ubyte, MV_NONE ) then return false
    StoreThrough( c, cur, pv )
    if dtor <> Tko.SYMBOL_NONE then
        EmitStructorCall( c, dtor, -1, @pv )
    elseif implDtor then
        CallImplicitDtor_( c, el, pv )
    end if
    dim as MirValue rv2 = LowerExprLoad( c, rem_, zt )
    if rv2.kind = cast( ubyte, MV_NONE ) then return false
    dim as MirInst dec
    dec.op = cast( ushort, M_SUB )
    dec.ty = cast( ubyte, zt )
    dec.a = rv2
    dec.b = ConstInt( c, 1, zt )
    StoreThrough( c, rem_, Emit( c, dec ) )
    Terminate( c, MTERM_BR, testB, -1, NoVal( ) )

    '' THE COOKIE'S ADDRESS IS WHAT WAS ALLOCATED, so it is what is released.
    c.curBlock = freeB
    dim as FB.Array( of ulong ) da
    da.Push( cast( ulong, base_.kind ) ) : da.Push( cast( ulong, base_.id ) )
    dim as Tko.SymbolId opDel = StructorWithArity( c, StructorOf( c, el, "delete[]" ), 1 )
    if opDel <> Tko.SYMBOL_NONE then
        EmitDirectCall_( c, opDel, MT_VOID, da )
    else
        EmitRtl( c, RTL_FREE, da )
    end if
    Terminate( c, MTERM_BR, joinB, -1, NoVal( ) )
    c.curBlock = joinB
    return true
end function
