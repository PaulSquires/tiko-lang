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
      byref eoffs as FB.Array( of ulong ), byval flatten as boolean = true ) as boolean

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
    if TupleElems_( c, lt, etypes, eoffs, true ) = false then return false

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

'' THE GLOBAL 'operator =' OR 'operator <>' over a UDT, or nothing.
''
'' A tuple element that is a UDT compares through the element type's own operator, and
'' there is no NODE for that element to hand to the ordinary user-operator path -- only
'' a pair of addresses. So the operator is looked up here and called directly, which is
'' exactly what the string-element branch above does with fb_StrCompare.
''
'' BOTH parameters must be this UDT: a type may declare '=' against several right-hand
'' types, and taking the first would take one at random.
private function TupleUdtCmpOp_ _
    ( byref c as Ctx, byval ut as Tko.TypeId, byref nm as string ) as Tko.SymbolId

    if ut = Tko.TYPE_NONE then return Tko.SYMBOL_NONE
    if c.types->Kind( ut ) <> Tko.TK_UDT then return Tko.SYMBOL_NONE
    dim as Tko.ScopeId sc = cast( Tko.ScopeId, c.types->DeclScopeOf( ut ) )
    if sc = Tko.SCOPE_NONE then return Tko.SYMBOL_NONE
    dim as Tko.SymbolId cur = _
        c.syms->Lookup( sc, c.names->Fold( c.names->GetString( nm ) ) )
    dim as long guard = 0
    while (cur <> Tko.SYMBOL_NONE) andalso (guard < 256)
        guard += 1
        dim as Tko.Symbol ptr os = c.syms->SymbolAt( cur )
        if os = 0 then exit while
        if os->kind = cast( ubyte, Tko.SYM_PROC ) then
            dim as Tko.NodeId pn = cast( Tko.NodeId, os->payload )
            dim as boolean isProc = (pn <> Tko.NODE_NONE)
            if isProc then isProc = (c.ast->Kind( pn ) = Tko.N_PROC)
            if isProc then
                dim as Tko.StmtPayload ptr pp = StmtOf( c, pn )
                if pp->op = cast( ushort, Tko.KW_OPERATOR ) then
                    dim as long np = 0
                    dim as boolean bothMine = true
                    for i as long = 0 to pp->count - 1
                        dim as Tko.NodeId prm = _
                            cast( Tko.NodeId, c.ast->children[pp->first + i] )
                        if c.ast->Kind( prm ) <> Tko.N_PARAM then continue for
                        dim as Tko.TypeId pt = c.info->TypeOf_( StmtOf( c, prm )->a )
                        if c.types->Unqualify( pt ) <> ut then bothMine = false
                        np += 1
                    next
                    if (np = 2) andalso bothMine then return cur
                end if
            end if
        end if
        cur = os->nextOverload
    wend
    return Tko.SYMBOL_NONE
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

    '' A UDT ELEMENT COMPARES THROUGH ITS OWN OPERATOR. Measured, fbc calls it on the
    '' two field addresses and short-circuits between elements:
    ''
    ''     int64 vr$8  = _ZeqR7WATCHEDS0_( TMP$2$0, TMP$3$0 );
    ''     if( vr$8 == 0ll) goto label$4;
    ''     int64 vr$13 = _ZeqR7WATCHEDS0_( TMP$2$0 + 4ll, TMP$3$0 + 4ll );
    ''
    '' and run, 'a = b' over a mismatching first element calls it ONCE. Refusing every
    '' aggregate element made the whole comparison MV_NONE, so the IF around it had no
    '' condition and the statement declined -- tuple/equality.bas's own subject.
    if emt = MT_AGG then
        dim as string uop = "<>"
        if isEq then uop = "="
        dim as Tko.SymbolId ucmp = TupleUdtCmpOp_( c, c.types->Unqualify( et ), uop )
        '' ...OR, WITH NO SUCH OPERATOR, THROUGH ITS NUMERIC CAST: measured on fbc-modern, a type
        '' with 'operator =' and 'operator cast( ) as long' but no '<>' compares the two casts
        '' for '<>' (prints -1 for 2 against 3). The cast is the shared rule's with nothing to
        '' meet -- NumericCastPick -- as for a plain UDT operand.
        if ucmp = Tko.SYMBOL_NONE then
            dim as Tko.SymbolId ccs = UserCastNumOverload_( c, c.types->Unqualify( et ) )
            if ccs = Tko.SYMBOL_NONE then return none_
            dim as Tko.TypeId crt = c.types->Unqualify( c.syms->SymbolAt( ccs )->type_ )
            dim as MirType cmt = LowerType( crt, *c.types )
            dim as MirValue lcv = EmitMemberCall( c, ccs, laddr, cmt )
            dim as MirValue rcv = EmitMemberCall( c, ccs, raddr, cmt )
            if (lcv.kind = cast( ubyte, MV_NONE )) orelse (rcv.kind = cast( ubyte, MV_NONE )) then return none_
            dim as MirInst ccmp
            ccmp.op = cast( ushort, BinOpFor( etk, cmt, IsUnsignedType( c, crt ) ) )
            ccmp.ty = cast( ubyte, MT_I32 )
            ccmp.a = lcv : ccmp.b = rcv
            if ccmp.op = cast( ushort, M_NONE ) then return none_
            return Emit( c, ccmp )
        end if
        dim as Tko.Symbol ptr ucs = c.syms->SymbolAt( ucmp )
        if ucs = 0 then return none_
        dim as MirType urt = MT_I64
        if ucs->type_ <> Tko.TYPE_NONE then urt = LowerType( ucs->type_, *c.types )
        dim as FB.Array( of ulong ) uargs
        uargs.Push( cast( ulong, laddr.kind ) ) : uargs.Push( cast( ulong, laddr.id ) )
        uargs.Push( cast( ulong, raddr.kind ) ) : uargs.Push( cast( ulong, raddr.id ) )
        '' RAW, AS EVERY ELEMENT IS: the chain above negates a 1/0 into FreeBASIC's -1/0, and the
        '' operator already answers -1 -- negated, 't1 = t2' printed 1 where fbc-modern prints -1.
        dim as MirValue ures = EmitDirectCall_( c, ucmp, urt, uargs )
        if (ures.kind = cast( ubyte, MV_NONE )) orelse (urt = MT_VOID) orelse (urt = MT_AGG) then return ures
        dim as MirInst unz
        unz.op = cast( ushort, BinOpFor( Tko.TK_NE, urt, false ) )
        unz.ty = cast( ubyte, MT_I32 )
        unz.a = ures : unz.b = ConstInt( c, 0, urt )
        if unz.op = cast( ushort, M_NONE ) then return ures
        return Emit( c, unz )
    end if
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
      byref eoffs as FB.Array( of ulong ), byval flatten as boolean ) as boolean

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
            if flatten andalso _
               TupleElems_( c, c.types->Unqualify( f->type_ ), sub_t, sub_o, true ) then
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

'' THE FIELDS A DESTRUCTURING READS: every field of ANY UDT, in declaration order.
''
'' NOT TupleElems_, which is for tuple EQUALITY and rightly insists on '_1'..'_N' and
'' refuses a type with members. Measured, fbc destructures a plain UDT positionally,
'' methods and all:
''
''   let( a, b, c ) = f( )   over 'type P: as long x, y, z: declare sub m( )'
''                           prints 1 2 3
''   let( a, b ) = f( )      over the same THREE-field type prints 1 2 -- FEWER
''                           names than fields is accepted and takes the leading ones
''   let( a, b, c ) = f( )   over a TWO-field type is fbc error 266,
''                           'Too many elements'
''
'' Without this, 'let( a, b, c ) = f( )' over an ordinary UDT did not decline: the
'' N_TUPLE target fell through to the value path, which built a temporary FROM THE
'' NAMES' CURRENT VALUES and stored the call's result into it. Nothing was assigned
'' to a, b or c, no decline said so, and it verified.
private function DestructureElems_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byref etypes as FB.Array( of ulong ), _
      byref eoffs as FB.Array( of ulong ) ) as boolean

    if c.types->Kind( t ) <> Tko.TK_UDT then return false
    dim as Tko.SymbolId ts = UdtSymOf_( c, t )
    dim as Tko.Symbol ptr s = c.syms->SymbolAt( ts )
    if s = 0 then return false
    if s->inner = Tko.SCOPE_NONE then return false
    dim as Tko.SymScope ptr sc = c.syms->ScopeAt( s->inner )
    if sc = 0 then return false

    dim as Tko.SymbolId cur = sc->firstSym
    dim as long guard = 0
    while (cur <> Tko.SYMBOL_NONE) andalso (guard < 100000)
        guard += 1
        dim as Tko.Symbol ptr f = c.syms->SymbolAt( cur )
        if f = 0 then exit while
        if f->kind = cast( ubyte, Tko.SYM_FIELD ) then
            dim as boolean found = false
            dim as long off = c.udts->FieldOffset( t, f->name, found )
            if found = false then return false
            etypes.Push( cast( ulong, f->type_ ) )
            eoffs.Push( cast( ulong, off ) )
        end if
        cur = f->nextInScope
    wend
    return (etypes.Count > 0)
end function

'' 'let (a, b) = expr' -- TUPLE DESTRUCTURING.
''
'' The target is an N_TUPLE of lvalues and the value is one tuple, so this is not an
'' assignment of one thing to another: it is N assignments from the elements of a single
'' evaluation. Measured from what fbc emits:
''
''     struct FBTUPLE2Iii vr = GIVESLL( );
''     TMP6 = vr;  TMP7 = &TMP6;
''     A = *(int32*)TMP7;
''     B = *(int32*)((uint8*)TMP7 + 4);
''
'' -- the right side ONCE, into a temporary whose address every element is then read
'' through, so a call on the right runs once and not once per name.
''
'' Without it the whole statement declined: LowerAddr was asked for the address of an
'' N_TUPLE, which is not an lvalue and has none.
function LowerDestructure _
    ( byref c as Ctx, byval target as Tko.NodeId, byval value as Tko.NodeId ) as boolean

    if c.ast->Kind( target ) <> Tko.N_TUPLE then return false
    dim as Tko.ListPayload ptr tl = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, target )].data )]
    if tl->count <= 0 then return false

    '' THE ELEMENTS OF THE SOURCE, top level only: 'let ((a,b),c) = n' names three
    '' lvalues and the middle one is a tuple of its own, which this does not model --
    '' the counts would not match and it declines.
    dim as Tko.TypeId vt = c.types->Unqualify( c.info->TypeOf_( value ) )
    dim as FB.Array( of ulong ) etypes
    dim as FB.Array( of ulong ) eoffs
    if DestructureElems_( c, vt, etypes, eoffs ) = false then return false
    '' FEWER NAMES THAN FIELDS IS LEGAL and takes the leading ones; MORE is fbc
    '' error 266 and declines here.
    if tl->count > etypes.Count then return false

    '' THE RIGHT SIDE ONCE. An addressable value is read where it is; anything else --
    '' a call, a literal -- is built into a temporary first, which is what fbc does.
    dim as MirValue src = LowerAddr( c, value )
    if src.kind = cast( ubyte, MV_NONE ) then
        dim as long vsz = SizeOfType( c, vt )
        if vsz <= 0 then return false
        dim as long tslot = NewTempLocal( c, MT_AGG, vsz )
        if tslot < 0 then return false
        dim as MirValue tdst
        tdst.kind = cast( ubyte, MV_LOCAL )
        tdst.ty = cast( ubyte, MT_PTR )
        tdst.id = tslot
        dim as MirValue rv = LowerExpr( c, value )
        if rv.kind = cast( ubyte, MV_NONE ) then return false
        StoreThrough( c, tdst, rv )
        src = tdst
    end if

    '' ...and the address held in a slot, so every element reads the same one.
    dim as long pbytes = c.types->target.pointerBits \ 8
    dim as long pslot = NewTempLocal( c, MT_PTR, pbytes )
    if pslot < 0 then return false
    dim as MirValue pdst
    pdst.kind = cast( ubyte, MV_LOCAL )
    pdst.ty = cast( ubyte, MT_PTR )
    pdst.id = pslot
    StoreThrough( c, pdst, src )

    for i as long = 0 to tl->count - 1
        dim as Tko.NodeId nm = cast( Tko.NodeId, c.ast->children[tl->first + i] )
        '' AN ELIDED SLOT IS SKIPPED AND STILL COUNTS. 'let( a, , b ) = f( )' takes
        '' the FIRST and THIRD elements -- measured, fbc writes
        '' 'A = *(int32*)TMP; B = *(int32*)((uint8*)TMP + 8)' -- so the position
        '' drives the offset whether or not anything is named there. Without a case
        '' for it LowerAddr had no lvalue and the whole destructuring declined.
        if c.ast->Kind( nm ) = Tko.N_ELIDED then continue for
        dim as Tko.TypeId et = cast( Tko.TypeId, etypes[i] )
        dim as MirValue base_ = LowerExprLoad( c, pdst, MT_PTR )
        if base_.kind = cast( ubyte, MV_NONE ) then return false
        dim as MirInst fa
        fa.op = cast( ushort, M_FIELD_ADDR )
        fa.ty = cast( ubyte, MT_PTR )
        fa.a = base_
        fa.imm = cast( long, eoffs[i] )
        dim as MirValue saddr = Emit( c, fa )
        if saddr.kind = cast( ubyte, MV_NONE ) then return false

        dim as MirValue daddr = LowerAddr( c, nm )
        if daddr.kind = cast( ubyte, MV_NONE ) then return false

        '' A STRING ELEMENT IS A RUNTIME CALL, from one descriptor into another.
        if IsStringType( c, et ) then
            dim as FB.Array( of ulong ) sargs
            PushStrArg( sargs, daddr )
            PushStrArg( sargs, saddr )
            sargs.Push( cast( ulong, MV_CONST_INT ) )
            sargs.Push( 0 )
            dim as long which = RTL_STR_ASSIGN
            if IsUStringType( c, et ) then which = RTL_USTR_ASSIGN
            if EmitRtl( c, which, sargs ).kind = cast( ubyte, MV_NONE ) then return false
            continue for
        end if

        dim as MirType emt = LowerType( et, *c.types )
        if emt = MT_VOID then return false
        if emt = MT_AGG then return false
        dim as MirValue ev = LowerExprLoad( c, saddr, emt )
        if ev.kind = cast( ubyte, MV_NONE ) then return false
        dim as MirType dmt = LowerType( c.info->TypeOf_( nm ), *c.types )
        if dmt = MT_VOID then dmt = emt
        StoreThrough( c, daddr, CoerceTy( c, ev, dmt, et) )
    next
    return true
end function

'' IS THIS TYPE A TUPLE? Its fields are named '_1', '_2', ... in order and it has no
'' members of its own; there is no other marker.
function IsTupleType_( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    dim as FB.Array( of ulong ) ts, os
    return TupleElems_( c, c.types->Unqualify( t ), ts, os, false )
end function
