'' lowertup.bas -- TUPLE EQUALITY.
''
'' Split out of lowersub.bas at the 1500-line cap and included from it. Nothing in it
'' changed in the move.

'' Defined below and used by LowerTupleCompare, which comes first.
declare function TupleElemCmp_ _
    ( byref c as Ctx, byref ldst as MirValue, byref rdst as MirValue, _
      byval et as Tko.TypeId, byval off as long, byval isEq as boolean ) as MirValue
declare function TupleElems_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byref etypes as FB.Array( of ulong ), _
      byref eoffs as FB.Array( of ulong ) ) as boolean

'' TUPLE EQUALITY, which is a SHORT-CIRCUIT CHAIN over the elements.
''
'' Measured from what fbc emits for a two- and a three-element tuple:
''
''     TMP2 = &A ; TMP3 = &B                 each side's address ONCE, so a call on
''                                           either side is evaluated once and not
''                                           once per element
''     if TMP2->_1 != TMP3->_1 goto FALSE
''     TMP4 = -(TMP2->_2 == TMP3->_2)
''     goto JOIN
''     FALSE: TMP4 = 0
''     JOIN:  ...and the three-element form folds LEFT, testing TMP4 and repeating
''
'' so it is exactly the ANDALSO chain of the element comparisons, with the short-circuit
'' constant 0 -- and the inequality is the ORELSE chain of the inverted comparisons,
'' short-circuit constant -1, which is what makes it the negation of the WHOLE thing
'' rather than of each element.
''
'' The result is ALWAYS materialised and negated, even in a condition: fbc writes
'' "if( TMP4 == 0 ) goto ..." rather than branching on the last comparison.
function LowerTupleCompare _
    ( byref c as Ctx, byval id as Tko.NodeId, byval bp as Tko.BinaryPayload ptr, _
      byval tk as Tko.TokenKind, byref outv as MirValue ) as boolean

    if (tk <> Tko.TK_EQ) andalso (tk <> Tko.TK_NE) then return false
    dim as Tko.TypeId lt = c.types->Unqualify( c.info->TypeOf_( bp->lhs ) )
    dim as Tko.TypeId rt = c.types->Unqualify( c.info->TypeOf_( bp->rhs ) )
    if lt = Tko.TYPE_NONE then return false
    if lt <> rt then return false

    '' The elements, in declaration order, with their offsets. A structure that is not
    '' a tuple comes back false and takes no part in this.
    dim as FB.Array( of ulong ) etypes
    dim as FB.Array( of ulong ) eoffs
    if TupleElems_( c, lt, etypes, eoffs ) = false then return false

    '' EACH SIDE'S ADDRESS ONCE, in a slot so it survives the blocks below.
    dim as long pbytes = c.types->target.pointerBits \ 8
    dim as MirValue la = LowerAddr( c, bp->lhs )
    if la.kind = cast( ubyte, MV_NONE ) then return false
    dim as MirValue ra = LowerAddr( c, bp->rhs )
    if ra.kind = cast( ubyte, MV_NONE ) then return false
    dim as long lslot = NewTempLocal( c, MT_PTR, pbytes )
    dim as long rslot = NewTempLocal( c, MT_PTR, pbytes )
    if (lslot < 0) orelse (rslot < 0) then return false
    dim as MirValue ldst, rdst
    ldst.kind = cast( ubyte, MV_LOCAL ) : ldst.ty = cast( ubyte, MT_PTR ) : ldst.id = lslot
    rdst.kind = cast( ubyte, MV_LOCAL ) : rdst.ty = cast( ubyte, MT_PTR ) : rdst.id = rslot
    StoreThrough( c, ldst, la )
    StoreThrough( c, rdst, ra )

    dim as boolean isEq = (tk = Tko.TK_EQ)
    dim as long slot = NewTempLocal( c, MT_I32, 4 )
    if slot < 0 then return false
    dim as MirValue acc
    acc.kind = cast( ubyte, MV_LOCAL ) : acc.ty = cast( ubyte, MT_PTR ) : acc.id = slot

    dim as MirValue cur = TupleElemCmp_( c, ldst, rdst, _
        cast( Tko.TypeId, etypes[0] ), cast( long, eoffs[0] ), isEq )
    if cur.kind = cast( ubyte, MV_NONE ) then return false

    for i as long = 1 to etypes.Count - 1
        dim as long rhsB = NewBlock( c, "tup.rhs" )
        dim as long shortB = NewBlock( c, "tup.short" )
        dim as long joinB = NewBlock( c, "tup.join" )
        if isEq then
            Terminate( c, MTERM_CONDBR, rhsB, shortB, cur )
        else
            Terminate( c, MTERM_CONDBR, shortB, rhsB, cur )
        end if

        c.curBlock = rhsB
        dim as MirValue nx = TupleElemCmp_( c, ldst, rdst, _
            cast( Tko.TypeId, etypes[i] ), cast( long, eoffs[i] ), isEq )
        if nx.kind = cast( ubyte, MV_NONE ) then return false
        dim as MirInst ng
        ng.op = cast( ushort, M_NEG )
        ng.ty = cast( ubyte, MT_I32 )
        ng.a = Coerce( c, nx, MT_I32, false )
        StoreThrough( c, acc, Emit( c, ng ) )
        Terminate( c, MTERM_BR, joinB, -1, NoVal( ) )

        c.curBlock = shortB
        dim as longint shortV = 0
        if isEq = false then shortV = -1
        StoreThrough( c, acc, ConstInt( c, shortV, MT_I32 ) )
        Terminate( c, MTERM_BR, joinB, -1, NoVal( ) )

        c.curBlock = joinB
        cur = LowerExprLoad( c, acc, MT_I32 )
        if cur.kind = cast( ubyte, MV_NONE ) then return false
        '' The accumulator IS the negated answer, so the next round branches on it
        '' directly and only a one-element tuple needs the negation below.
        if i = etypes.Count - 1 then
            outv = cur
            return true
        end if
    next

    dim as MirInst ng1
    ng1.op = cast( ushort, M_NEG )
    ng1.ty = cast( ubyte, MT_I32 )
    ng1.a = Coerce( c, cur, MT_I32, false )
    outv = Emit( c, ng1 )
    return true
end function

'' One element of a tuple comparison: both sides loaded through the hoisted addresses
'' and compared, RAW -- the negation belongs to the chain, not to the element.
function TupleElemCmp_ _
    ( byref c as Ctx, byref ldst as MirValue, byref rdst as MirValue, _
      byval et as Tko.TypeId, byval off as long, byval isEq as boolean ) as MirValue

    dim as MirValue none_
    dim as MirType emt = LowerType( et, *c.types )
    if emt = MT_VOID then return none_

    dim as MirValue lp = LowerExprLoad( c, ldst, MT_PTR )
    dim as MirValue rp = LowerExprLoad( c, rdst, MT_PTR )
    if lp.kind = cast( ubyte, MV_NONE ) then return none_
    if rp.kind = cast( ubyte, MV_NONE ) then return none_

    dim as MirInst lf, rf
    lf.op = cast( ushort, M_FIELD_ADDR ) : lf.ty = cast( ubyte, MT_PTR )
    lf.a = lp : lf.imm = off
    rf.op = cast( ushort, M_FIELD_ADDR ) : rf.ty = cast( ubyte, MT_PTR )
    rf.a = rp : rf.imm = off
    dim as MirValue laddr = Emit( c, lf )
    dim as MirValue raddr = Emit( c, rf )

    dim as Tko.TokenKind etk = Tko.TK_NE
    if isEq then etk = Tko.TK_EQ

    '' A STRING ELEMENT IS A RUNTIME CALL, not an opcode -- measured:
    '' 'fb_StrCompare( &A + 8, -1, &B + 8, -1 )' and then that result against 0. The
    '' descriptor is an aggregate, so comparing it as one would compare the pointer
    '' and the length rather than the text.
    if IsStringType( c, et ) then
        dim as FB.Array( of ulong ) sargs
        PushStrArg( sargs, laddr )
        PushStrArg( sargs, raddr )
        dim as MirValue sc = EmitRtl( c, RTL_STR_COMPARE, sargs )
        if sc.kind = cast( ubyte, MV_NONE ) then return none_
        dim as MirInst scmp
        scmp.op = cast( ushort, BinOpFor( etk, MT_I32, false ) )
        scmp.ty = cast( ubyte, MT_I32 )
        scmp.a = sc
        scmp.b = ConstInt( c, 0, MT_I32 )
        if scmp.op = cast( ushort, M_NONE ) then return none_
        return Emit( c, scmp )
    end if

    if emt = MT_AGG then return none_
    dim as MirValue lv = LowerExprLoad( c, laddr, emt )
    dim as MirValue rv = LowerExprLoad( c, raddr, emt )
    if lv.kind = cast( ubyte, MV_NONE ) then return none_
    if rv.kind = cast( ubyte, MV_NONE ) then return none_

    dim as MirInst cmp
    cmp.op = cast( ushort, BinOpFor( etk, emt, IsUnsignedType( c, et ) ) )
    cmp.ty = cast( ubyte, MT_I32 )
    cmp.a = lv
    cmp.b = rv
    if cmp.op = cast( ushort, M_NONE ) then return none_
    return Emit( c, cmp )
end function

'' A TUPLE'S ELEMENTS, in declaration order, with their byte offsets -- and false for
'' anything that is not a tuple.
''
'' A tuple is built as a UDT whose fields are named '_1', '_2', ... in order and which
'' has no members of its own, so those two facts are what tell one from an ordinary
'' structure. There is no other marker on the type.
function TupleElems_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byref etypes as FB.Array( of ulong ), _
      byref eoffs as FB.Array( of ulong ) ) as boolean

    if c.types->Kind( t ) <> Tko.TK_UDT then return false
    dim as Tko.SymbolId ts = UdtSymOf_( c, t )
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( ts )
    if s = 0 then return false
    if s->inner = Tko.SCOPE_NONE then return false
    dim as Tko.SymScope ptr sc = c.syms->ScopeAt( s->inner )
    if sc = 0 then return false

    dim as long n = 0
    dim as Tko.SymbolId cur = sc->firstSym
    dim as long guard = 0
    while (cur <> Tko.SYMBOL_NONE) andalso (guard < 100000)
        guard += 1
        dim as Tko.Symbol ptr f = c.syms->SymbolAt( cur )
        if f = 0 then exit while
        if f->kind = cast( ubyte, Tko.SYM_FIELD ) then
            n += 1
            if c.names->Spelling( f->name ) <> ("_" & trim( str( n ) )) then return false
            dim as boolean found = false
            dim as long off = c.udts->FieldOffset( t, f->name, found )
            if found = false then return false
            '' A NESTED TUPLE IS FLATTENED into its own leaves, at their offsets from
            '' here -- measured: '((long, long), long)' is THREE element comparisons in
            '' one chain, not a comparison of a pair against a pair.
            dim as FB.Array( of ulong ) sub_t, sub_o
            if TupleElems_( c, c.types->Unqualify( f->type_ ), sub_t, sub_o ) then
                for k as long = 0 to sub_t.Count - 1
                    etypes.Push( sub_t[k] )
                    eoffs.Push( cast( ulong, off + cast( long, sub_o[k] ) ) )
                next
            else
                etypes.Push( cast( ulong, f->type_ ) )
                eoffs.Push( cast( ulong, off ) )
            end if
        elseif f->kind = cast( ubyte, Tko.SYM_PROC ) then
            return false
        end if
        cur = f->nextInScope
    wend
    return (n > 0)
end function
