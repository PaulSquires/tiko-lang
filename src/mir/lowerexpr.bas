'' lowerexpr.bas -- LowerExpr, the expression dispatcher.
''
'' Split out of lower.bas at the 1500-line cap and INCLUDED from it, in the same place,
'' exactly as lowerassign.bas and lowerinit.bas are: lower.bas is one compilation unit
'' made of several files, and several of the helpers here are module-private to it.
'' Nothing about the code changed in the move.



function LowerExpr _
    ( byref c as Ctx, byval id as Tko.NodeId ) as MirValue

    dim as MirValue v
    if id = Tko.NODE_NONE then return v

    dim as Tko.TypeId ft = c.info->TypeOf_( id )
    dim as MirType mt = LowerType( ft, *c.types )

    select case c.ast->Kind( id )
    '' 'open( f for input as #1 )' IN EXPRESSION POSITION yields the error code. The
    '' parser builds the same N_INTRINSIC node either way, so the statement form's own
    '' lowering serves -- it was only the expression path that had no case, and a DIM
    '' initialised from one allocated its slot and stored nothing.
    case Tko.N_INTRINSIC
        dim as MirValue ov
        '' 'threadcall f( a )' YIELDS THE THREAD HANDLE, and that is how every real
        '' use in the corpus writes it: 'dim as any ptr t = threadcall f( 1 )'.
        if LowerThreadCall_( c, id, ov ) then return ov
        if LowerOpenCall_( c, id, ov ) then return ov
        '' 'get( #f, 1, b )' YIELDS THE ERROR CODE, and that is how the corpus writes
        '' every one: 'CU_ASSERT( get( #f, 1, b ) = 0 )'. Same node either way, so the
        '' statement form's own lowering serves here too.
        dim as Tko.StmtPayload ptr isp = StmtOf( c, id )
        dim as Tko.TokenKind iop = cast( Tko.TokenKind, isp->op )
        if (iop = Tko.KW_GET) orelse (iop = Tko.KW_PUT) then
            dim as MirValue gv
            if LowerFileGetPut( c, id, (iop = Tko.KW_PUT), gv ) then return gv
        end if
        '' 'close( n )' YIELDS THE ERROR CODE the same way, and that is how the corpus
        '' asks about a bad channel: 'CU_ASSERT_EQUAL( close(0), ILLEGALFUNCTIONCALL )'.
        '' Measured -- 'e = close(0)' is 'vr$1 = fb_FileClose( 0 )', the same call the
        '' statement form makes with its result discarded.
        if iop = Tko.KW_CLOSE then
            dim as MirValue cv2
            if LowerCloseCall_( c, id, cv2 ) then return cv2
        end if
        return v

    case Tko.N_CLOSURE
        '' A CAPTURING LAMBDA'S OBJECT. See lowerclosure.bas.
        dim as MirValue clv
        if LowerClosure_( c, id, clv ) then return clv
        return v

    case Tko.N_STRING_LIT
        return LowerStringLitAddr( c, id )

    case Tko.N_INT_LIT
        dim as Tko.LiteralPayload ptr lp = _
            @c.ast->literals[cast( long, c.ast->nodes[cast( long, id )].data )]
        if mt = MT_VOID then mt = MT_I64
        return ConstInt( c, cast( longint, lp->intValue ), mt )

    case Tko.N_FLOAT_LIT
        dim as Tko.LiteralPayload ptr lp = _
            @c.ast->literals[cast( long, c.ast->nodes[cast( long, id )].data )]
        if mt = MT_VOID then mt = MT_F64
        return ConstFloat( c, lp->fltValue, mt )

    case Tko.N_TUPLE
        '' 'type<P>( 5, 6 )' IN VALUE POSITION -- an argument, a parameter default.
        '' fbc builds a temporary and field-initialises it. A bare tuple has no type
        '' target and is not one of these.
        '' ...and the same spelling over a type that is NOT a UDT is a plain
        '' CONVERSION. See LowerTypeLitConvert_.
        dim as MirValue tcv
        if LowerTypeLitConvert_( c, id, tcv ) then return tcv

        dim as MirValue ulv
        if LowerUdtLiteralValue_( c, id, ulv ) then return ulv
        return v

    case Tko.N_PAREN
        dim as Tko.ListPayload ptr pp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
        if pp->count <> 1 then return v
        return LowerExpr( c, cast( Tko.NodeId, c.ast->children[pp->first] ) )

    case Tko.N_IDENT, Tko.N_MEMBER
        '' 'NS.K' AND 'NS.SOME_ENUM_MEMBER' FOLD TO THEIR VALUES, exactly as the
        '' unqualified spellings do. Splitting this case for the property branch below
        '' dropped that -- and the bitfield read with it -- so a qualified constant lost
        '' its fold and 'x.f' over a bitfield went back to loading the whole packed unit.
        '' The two kinds share every step but one; only the property call is
        '' member-specific.
        dim as MirValue pre = LowerPredeclared( c, id )
        if pre.kind <> cast( ubyte, MV_NONE ) then return pre

        '' A BITFIELD HAS NO ADDRESS OF ITS OWN: it is bits inside a unit its
        '' neighbours share, so it is read by masking rather than by loading.
        dim as MirValue bfv
        if LowerBitfieldRead( c, id, bfv ) then return bfv

        '' 't.V' WITH NO PARENTHESES over a property is a call to its GETTER. With them
        '' it is an ordinary call and never reaches here -- so the only spelling that
        '' was missing is the one properties are actually used in.
        if c.ast->Kind( id ) = Tko.N_MEMBER then
            dim as MirValue pgv
            if LowerPropertyGet_( c, id, pgv ) then return pgv
        end if

        '' A BARE FUNCTION NAME IN VALUE POSITION IS A CALL. 'd = timer' and
        '' 's = curdir' are how FreeBASIC spells a no-argument call, and LowerAddr
        '' answers with the function's ADDRESS -- so the address of fb_Timer was stored
        '' in a double and the address of fb_CurDir was handed to fb_StrInit as a
        '' string. It verified: a pointer is a well-typed value.
        ''
        '' '@f' and 'procptr( f )' go through LowerAddr and are unaffected; there is no
        '' spelling that means "the address" without one of them.
        dim as MirValue bpc
        if LowerBareProcCall_( c, id, mt, bpc ) then return bpc

        dim as MirValue addr = LowerAddr( c, id )
        if addr.kind = cast( ubyte, MV_NONE ) then return v
        dim as MirInst ins
        ins.op = cast( ushort, M_LOAD )
        ins.ty = cast( ubyte, mt )
        ins.a = addr
        return Emit( c, ins )

    case Tko.N_ADDROF
        '' '@x' IS THE ADDRESS, which is what LowerAddr already computes for every
        '' lvalue -- a local, a global, a field, an array element, a byref parameter.
        '' There was no case for it at all, so every '@' in the tree produced NOTHING:
        '' 'dim as T ptr p = @obj' allocated p, stored nothing, and 'p->v = 1' then
        '' wrote through whatever the stack held. Silent, because a DIM initialiser
        '' that would not lower skipped its store without counting it.
        dim as Tko.UnaryPayload ptr ap = _
            @c.ast->unaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        '' '@"lit"' IS THE ADDRESS OF THE BYTES, which is what a 'zstring ptr'
        '' parameter wants. A literal has no lvalue, so LowerAddr answered NOTHING and
        '' every 'printf( @"%d", n )' passed an unresolved value as its format.
        if c.ast->Kind( ap->operand ) = Tko.N_STRING_LIT then
            return LowerStringLitAddr( c, ap->operand )
        end if
        '' ...AND SO IS '@S' OVER A STRING CONSTANT. 'const s = "abc"' emits no
        '' variable -- it folds -- so LowerAddr had nothing to take and
        '' 'dim as byte ptr p = @s' declined. Measured, fbc hands back the
        '' LITERAL'S OWN STORAGE: 'P$0 = (int8*)"abc"'.
        if c.ast->Kind( ap->operand ) = Tko.N_IDENT then
            dim as Tko.Symbol ptr acs = c.syms->SymbolAt( c.info->RefOf( ap->operand ) )
            if acs <> 0 then
                if acs->kind = cast( ubyte, Tko.SYM_CONSTANT ) then
                    dim as string actx
                    if ConstStringTextOf_( c, ap->operand, actx ) then
                        dim as MirValue acv
                        acv.kind = cast( ubyte, MV_GLOBAL )
                        acv.ty = cast( ubyte, MT_PTR )
                        acv.id = c.m->AddStringLiteral( actx, *c.names )
                        return acv
                    end if
                end if
            end if
        end if
        '' '@wstr( "w1" )' -- A WIDE STRING IS ALREADY A POINTER, so its address is
        '' that pointer and not the address of a temporary holding one. Measured: fbc
        '' folds the whole thing to '(uint16*)L"w1"', the literal's own storage. Asking
        '' LowerAddr for a CALL's address instead gave nothing, and the parameter
        '' default 'byval pw as const wstring ptr = @wstr( "w1" )' declined with it --
        '' which is how functions/paraminit writes every wide default.
        '' '@( @x )' OVER A BYREF PARAMETER IS THE PARAMETER'S OWN SLOT. A byref
        '' parameter IS a pointer variable, so '@x' names its CONTENTS and '@( @x )'
        '' its address -- measured, 'void S2( int8* X$1 ) { ... = (uint64)&X$1; }' --
        '' and fbc REJECTS the same spelling over any other variable, error 24, so
        '' there is nothing else to model beside it.
        ''
        '' LowerAddr was asked for the address of an rvalue and answered nothing.
        '' pointers/arith.bas puts every byref case through one macro that writes it
        '' four times.
        dim as Tko.NodeId inA = Unparen_( c, ap->operand )
        if c.ast->Kind( inA ) = Tko.N_ADDROF then
            dim as Tko.UnaryPayload ptr ap2 = _
                @c.ast->unaries[cast( long, c.ast->nodes[cast( long, inA )].data )]
            dim as Tko.NodeId nmA = Unparen_( c, ap2->operand )
            if c.ast->Kind( nmA ) = Tko.N_IDENT then
                dim as Tko.Symbol ptr syA = c.syms->SymbolAt( c.info->RefOf( nmA ) )
                if syA <> 0 then
                    dim as boolean isParam = _
                        (syA->kind = cast( ubyte, Tko.SYM_PARAMETER ))
                    dim as boolean isRef = false
                    if syA->type_ <> Tko.TYPE_NONE then
                        isRef = (c.types->Kind( syA->type_ ) = Tko.TK_REFERENCE)
                    end if
                    if isParam andalso isRef then
                        dim as long pslot = LocalFor( c, c.info->RefOf( nmA ) )
                        if pslot >= 0 then
                            dim as MirValue pv
                            pv.kind = cast( ubyte, MV_LOCAL )
                            pv.ty = cast( ubyte, MT_PTR )
                            pv.id = pslot
                            return pv
                        end if
                    end if
                end if
            end if
        end if

        dim as MirValue wrv
        if WideOperand_( c, ap->operand, wrv ) then
            if wrv.kind <> cast( ubyte, MV_NONE ) then return wrv
        end if
        return LowerAddr( c, ap->operand )

    case Tko.N_NEW
        '' 'new T' -- an ALLOCATION, not a call. It arrives here rather than at the
        '' N_CALL case because it is its own node kind.
        dim as MirValue nwv2
        if LowerNew_( c, id, nwv2 ) then return nwv2
        return v

    case Tko.N_INDEX
        '' 'p[i]' reads through the computed element address. Check does not type an
        '' N_INDEX, so the load's type comes from the POINTEE when the caller has not
        '' asked for one -- without it the load carried MT_VOID, was refused by Emit
        '' and declined, which is how 'dim as integer v = p[1]' still emitted nothing
        '' after the address itself was lowering correctly.
        dim as MirType imt = mt
        if imt = MT_VOID then
            dim as Tko.ListPayload ptr xp = _
                @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
            dim as Tko.TypeId xt = c.info->TypeOf_( xp->target )
            if xt <> Tko.TYPE_NONE then
                '' A STRING SUBSCRIPTED IS ITS CHARACTER -- one byte narrow, TWO wide,
                '' and UNSIGNED, because fbc writes '(int32)*(uint16*)(...)' and a sign
                '' extension would turn a character above 0x7FFF negative. Asked FIRST,
                '' because a 'zstring ptr' is a pointer too and its POINTEE is the
                '' unsized builtin, which lowers to no MIR type at all: the load then
                '' carried MT_VOID and Emit refused it.
                '' A UDT WITH 'operator []' -- the load's type is what the operator
                '' returns. LowerAddr already emits the call; without a type here the
                '' load carried MT_VOID and Emit refused it, so every 'a[ i ]' over a
                '' container declined with the call sitting right there.
                if c.types->Kind( xt ) = Tko.TK_UDT then
                    dim as Tko.SymbolId ixs2 = UdtMemberNamed_( c, xt, "[]" )
                    if ixs2 <> Tko.SYMBOL_NONE then
                        dim as Tko.Symbol ptr ixsym = c.syms->SymbolAt( ixs2 )
                        if ixsym <> 0 then
                            imt = LowerType( ixsym->type_, *c.types )
                        end if
                    end if
                end if

                dim as long cesz = CharElemSize_( c, xt )
                if cesz = 1 then
                    imt = MT_I8
                elseif cesz = 2 then
                    imt = MT_I16
                elseif c.types->Kind( xt ) = Tko.TK_POINTER then
                    imt = LowerType( c.types->Inner( xt ), *c.types )
                    dim as long pesz = CharElemSize_( c, c.types->Inner( xt ) )
                    if pesz = 1 then
                        imt = MT_I8
                    elseif pesz = 2 then
                        imt = MT_I16
                    end if
                end if
            end if
        end if
        if imt = MT_VOID then return v
        dim as MirValue ia = LowerAddr( c, id )
        if ia.kind = cast( ubyte, MV_NONE ) then return v
        return LowerExprLoad( c, ia, imt )

    case Tko.N_DEREF
        '' '*p' is a LOAD THROUGH the pointer. LowerAddr already knows the shape --
        '' the address is the pointer's VALUE -- so this is the load around it.
        dim as MirValue da = LowerAddr( c, id )
        if da.kind = cast( ubyte, MV_NONE ) then return v
        '' '*pz' AND '*pw' AS A NUMBER ARE ONE CHARACTER, unsigned. Measured:
        '' 'd = *pz' over a 'zstring ptr' is '(double)(uint8)*PZ$0' and over a
        '' 'wstring ptr' it is '(double)*PW$0' out of a uint16*. The ordinary load
        '' asked for the POINTEE's type, which is a string, so it produced an
        '' aggregate the arithmetic could not take and the statement declined. A
        '' STRING context never reaches here: it goes through StrDescriptorOf_.
        '' The widening is the CONSUMER's, and unsigned -- see IsUnsignedType.
        dim as MirType cmt = DerefCharTy_( c, id )
        if cmt <> MT_VOID then return LowerExprLoad( c, da, cmt )
        return LowerExprLoad( c, da, mt )

    case Tko.N_UNARY
        dim as Tko.UnaryPayload ptr up = _
            @c.ast->unaries[cast( long, c.ast->nodes[cast( long, id )].data )]

        '' A user-defined unary operator is a call, as the binary one is.
        dim as MirValue uuv
        if LowerUserUnaryOp_( c, id, up, mt, uuv ) then return uuv

        '' A UDT THAT ONLY CASTS TO A NUMBER IS THAT NUMBER HERE -- '-v' is a call to
        '' 'operator cast( ) as integer' and a negation of its result, measured. The
        '' binary case has had this since the operator was implemented; the unary one
        '' lowered the UDT itself and negated an aggregate.
        dim as MirValue x
        if UserCastToNum_( c, up->operand, x ) = false then
            x = LowerExpr( c, up->operand )
        end if
        if x.kind = cast( ubyte, MV_NONE ) then return v
        dim as MirInst ins
        ins.ty = cast( ubyte, mt )
        ins.a = x
        select case cast( Tko.TokenKind, up->op )
        case Tko.TK_MINUS : ins.op = cast( ushort, M_NEG )
        case Tko.TK_PLUS  : return x
        case Tko.KW_NOT   : ins.op = cast( ushort, M_NOT )
        case else         : return v
        end select
        return Emit( c, ins )

    case Tko.N_BINARY
        dim as Tko.BinaryPayload ptr bp = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        dim as Tko.TokenKind tk = cast( Tko.TokenKind, bp->op )

        '' 'a IS T' -- the RTTI type test, and not an arithmetic operator at all.
        '' Measured:
        ''
        ''   int32 vr$2 = fb_IsTypeOf( (void*)A$0, (void*)&_ZTSN3DOGE );
        ''
        '' -- the OBJECT'S ADDRESS and the named type's RTTI record, both of which the
        '' lowerer already knows how to produce. '*p is Dog' passes the pointer itself,
        '' which is the same address by another route.
        if tk = Tko.KW_IS then
            dim as MirValue isv
            if LowerIsTypeOf_( c, bp->lhs, bp->rhs, isv ) then return isv
            return v
        end if

        '' A USER-DEFINED OPERATOR IS A CALL. Without it 'x - y' over two UDTs
        '' subtracted the raw aggregates as integers -- emitted, verified, wrong.
        dim as MirValue uov
        if LowerUserBinaryOp_( c, id, bp, mt, uov ) then return uov

        '' TUPLE EQUALITY is a SHORT-CIRCUIT CHAIN over the elements, not a comparison
        '' of two objects -- see LowerTupleCompare for the shape fbc emits.
        dim as MirValue tcv
        if LowerTupleCompare( c, id, bp, tk, tcv ) then return tcv


        '' ANDALSO and ORELSE must not evaluate the right side unless they have to,
        '' so they are control flow, not an opcode.
        if (tk = Tko.KW_ANDALSO) orelse (tk = Tko.KW_ORELSE) then
            return LowerShortCircuit( c, id, bp, mt )
        end if

        '' A STRING comparison is a runtime call, not an opcode. Without this the
        '' operands are loaded as 24-byte descriptors and compared as if they were
        '' integers -- which verifies, lowers, and means nothing.
        '' A WIDE string is not IsStringType -- it is an ARRAY of the wstring builtin
        '' -- so it fell straight past this guard and its operands were loaded as
        '' aggregates and compared as integers. Exactly the failure the comment above
        '' describes, one type along.
        '' EITHER SIDE DECIDES. Asking only the LHS meant 'trim( w ) = b' fell to the
        '' numeric path -- Check computes no type for an intrinsic call, so the left
        '' side looks like nothing -- and its operands were loaded as aggregates and
        '' compared as integers. The same file's comment says exactly that about the
        '' wide case; this is the same mistake one operand along.
        dim as boolean cmpStr = IsStringType( c, c.info->TypeOf_( bp->lhs ) ) orelse _
                                (IsWideString_( c, c.info->TypeOf_( bp->lhs ) ))
        if cmpStr = false then
            cmpStr = IsStringType( c, c.info->TypeOf_( bp->rhs ) ) orelse _
                     (IsWideString_( c, c.info->TypeOf_( bp->rhs ) ))
        end if
        '' EVERY NARROW FLAVOUR, not just the var-length one. A 'zstring * 8', a
        '' 'string * 32' and an unsized zstring through a pointer are none of them
        '' IsStringType, so 'if z1 = z2' fell to the NUMERIC path and compared the
        '' objects as INTEGERS -- silently, with no decline, where fbc calls
        '' 'fb_StrCompare( Z1, 8ll, Z2, 8ll )'. It lowered, it verified, and it was
        '' wrong.
        if cmpStr = false then
            dim as longint fcn
            dim as long lk = StrSwapKind_( c, c.info->TypeOf_( bp->lhs ), fcn )
            dim as long rk = StrSwapKind_( c, c.info->TypeOf_( bp->rhs ), fcn )
            cmpStr = (lk = 1) orelse (lk = 3) orelse (rk = 1) orelse (rk = 3)
        end if
        '' AND BY SHAPE, for the calls Check gives no type at all: 'wbin( b ) =
        '' wstr( "10000000" )' is two of them, so neither side looked like a string and
        '' the comparison fell to the NUMERIC path -- which then declined, taking the
        '' CU_ASSERT around it with it, 228 times in one corpus file.
        if cmpStr = false then
            cmpStr = TermIsWide_( c, bp->lhs ) orelse TermIsWide_( c, bp->rhs )
        end if
        '' ...UNLESS ONE SIDE IS A SINGLE CHARACTER AND THE OTHER A NUMBER. Measured:
        '' 'pw[0] = asc( "1" )' is '(uint64)(int64)*PW$0 == 49ull' -- an unsigned
        '' INTEGER comparison of one element -- while '*pz = "723"' beside it stays a
        '' string compare, because there the other side is a string too.
        ''
        '' The string test claimed both, and the wide compare then had no string on
        '' the numeric side: quirk/zwstr-deref.bas asserts the shape eight times.
        if cmpStr then
            dim as boolean lChar = (CharLvalueTy_( c, bp->lhs ) <> MT_VOID)
            dim as boolean rChar = (CharLvalueTy_( c, bp->rhs ) <> MT_VOID)
            if lChar andalso NumericTerm_( c, bp->rhs ) then cmpStr = false
            if rChar andalso NumericTerm_( c, bp->lhs ) then cmpStr = false
        end if
        if cmpStr then
            dim as MirValue sc = LowerStrCompare( c, id, bp, tk )
            if sc.kind <> cast( ubyte, MV_NONE ) then return sc
            return v
        end if

        '' AND WHEN THERE IS NO OPERATOR TO CALL, THE ANSWER IS NOTHING. A UDT operand
        '' with no bound operator and no type of its own fell through to the arithmetic
        '' path below and ADDED THE RAW AGGREGATES as integers -- the failure the
        '' user-operator comment above describes, one case along: it happens whenever
        '' Check could not BIND the operator rather than whenever there is none, and a
        '' GENERIC global operator is exactly that case. 'x + y' over two
        '' 'Box( of long )' emitted 'add' on the two objects, verified, and was wrong.
        ''
        '' AFTER the string tests, not before them: a UDT with 'operator cast' to a
        '' string is compared as a STRING and has no type of its own either, so
        '' refusing it here as well took 'ut = st' with it -- 350 corpus statements
        '' across the udt-wstring and udt-zstring families.
        ''
        '' The node's own TYPE is what separates the remaining two: a UDT that reaches
        '' the numeric path legitimately does so through 'operator cast', and Check
        '' types the expression when it does.
        '' A UDT OPERAND REACHES THE NUMERIC PATH THROUGH ITS OWN 'operator cast',
        '' and asking it for a value directly gets nothing. ASKED BEFORE the refusal
        '' below, because a type that HAS such an operator is exactly the case that
        '' refusal must not take: 'result = u <> 0' over a type declaring only
        '' 'operator cast( ) as integer' is measured as a call to it and a comparison
        '' of the RESULT. See UserCastToNum_.
        dim as MirValue l
        dim as MirValue r
        dim as boolean lCast = UserCastToNum_( c, bp->lhs, l )
        dim as boolean rCast = UserCastToNum_( c, bp->rhs, r )

        dim as boolean noType = (c.info->TypeOf_( id ) = Tko.TYPE_NONE)
        dim as boolean noCast = (lCast = false) andalso (rCast = false)
        if noType andalso noCast then
            dim as Tko.TypeId lud = c.types->Unqualify( c.info->TypeOf_( bp->lhs ) )
            dim as Tko.TypeId rud = c.types->Unqualify( c.info->TypeOf_( bp->rhs ) )
            dim as boolean udtOperand = (c.types->Kind( lud ) = Tko.TK_UDT) orelse _
                                        (c.types->Kind( rud ) = Tko.TK_UDT)
            if udtOperand then return v
        end if

        if lCast = false then l = LowerExpr( c, bp->lhs )
        if rCast = false then r = LowerExpr( c, bp->rhs )
        if (l.kind = cast( ubyte, MV_NONE )) orelse (r.kind = cast( ubyte, MV_NONE )) then
            return v
        end if

        '' '^' IS A LIBC CALL, not an opcode, and BOTH OPERANDS BECOME DOUBLES whatever
        '' they were: measured, 'n ^ n' over two LONGs is
        '' 'pow( (double)(int64)N, (double)(int64)N )' and the result is a double the
        '' surrounding expression narrows. It had no entry in the operator table at all,
        '' so every '^' declined.
        ''
        '' ONE DIVERGENCE, deliberate: fbc folds an exponent of exactly 2 into a
        '' MULTIPLY -- 'x ^ 2.0' is 'X * X' -- which it can only do safely for an
        '' operand it may evaluate twice. tiko-lang always calls pow. Same value, different
        '' code, and no risk of evaluating a call twice.
        if tk = Tko.TK_CARET then
            dim as MirValue pl = Coerce( c, l, MT_F64, IsUnsignedType( c, c.info->TypeOf_( bp->lhs ) ) )
            dim as MirValue pr = Coerce( c, r, MT_F64, IsUnsignedType( c, c.info->TypeOf_( bp->rhs ) ) )
            dim as FB.Array( of ulong ) pa
            pa.Push( cast( ulong, pl.kind ) ) : pa.Push( cast( ulong, pl.id ) )
            pa.Push( cast( ulong, pr.kind ) ) : pa.Push( cast( ulong, pr.id ) )
            return EmitRtl( c, RTL_POW, pa )
        end if
        '' The operand type decides signed versus unsigned, and it is the OPERANDS'
        '' type, not the result's: a comparison yields an integer either way.
        dim as Tko.TypeId lt = c.info->TypeOf_( bp->lhs )
        dim as Tko.TypeId rt = c.info->TypeOf_( bp->rhs )
        dim as MirType opTy = LowerType( lt, *c.types )
        '' Both operands are brought to the WIDER of the two; the frontend's measured
        '' promotion rules already decided what the result type is.
        if TyWidth( cast( MirType, r.ty ) ) > TyWidth( opTy ) then
            opTy = cast( MirType, r.ty )
        end if
        if IsFloatTy( cast( MirType, r.ty ) ) then opTy = cast( MirType, r.ty )
        l = Coerce( c, l, opTy, IsUnsignedType( c, lt ) )
        r = Coerce( c, r, opTy, IsUnsignedType( c, rt ) )
        '' IMP and EQV are two instructions each and so have no entry in the table.
        if (tk = Tko.KW_IMP) orelse (tk = Tko.KW_EQV) then
            return EmitImpEqv_( c, tk, opTy, l, r )
        end if
        dim as MirOp op = BinOpFor( tk, opTy, IsUnsignedType( c, lt ) )
        if op = M_NONE then return v
        dim as MirInst ins
        ins.op = cast( ushort, op )
        ins.ty = cast( ubyte, iif( mt = MT_VOID, opTy, mt ) )
        ins.a = l
        ins.b = r
        dim as MirValue res = Emit( c, ins )

        '' A COMPARISON USED AS A VALUE IS NEGATED. Measured, in every value position
        '' fbc has: 'R = -(A < B)', 'print -(A < B)', 'Y = (int8)-(A < B)' -- so the
        '' answer is -1 and 0, not 1 and 0. tiko-lang emitted the bare comparison, and
        '' every printed, stored or passed comparison in the corpus was off by a sign.
        ''
        '' NOT for the one node being lowered as a CONDITION: a branch only asks
        '' whether it is nonzero, and fbc emits no negation there either.
        if IsCmpOp_( op ) andalso (id <> c.rawCmpNode) then
            dim as MirInst neg
            neg.op = cast( ushort, M_NEG )
            neg.ty = ins.ty
            neg.a = res
            return Emit( c, neg )
        end if
        return res

    case Tko.N_CALL
        '' THE EXPRESSION CALL CHAIN -- a dozen constructs that are spelled like a
        '' call and are not one. It lives in lowerintr.bas, with the intrinsics it
        '' dispatches to, because this file is at its size limit.
        return LowerCallExpr_( c, id, mt )
    end select

    return v
end function
