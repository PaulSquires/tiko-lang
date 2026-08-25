'' lower.bas -- AST to MIR. See lower.bi for what this slice does and does not cover.

#include once "mir/lower.bi"
#include once "mir/lowerctx.bi"

namespace Tko.Mir

declare function LowerCtorReturn_( byref c as Ctx, byval e as Tko.NodeId ) as boolean
declare function LowerTupleReturn_( byref c as Ctx, byval e as Tko.NodeId ) as boolean
declare function DerefCharTy_( byref c as Ctx, byval id as Tko.NodeId ) as MirType
declare function StaticMemberSym_ _
    ( byref c as Ctx, byval stmt as Tko.NodeId, byval item as Tko.NodeId ) as Tko.SymbolId
declare function IsCmpOp_( byval op as MirOp ) as boolean
declare function LowerByrefResult_ _
    ( byref c as Ctx, byval valueE as Tko.NodeId ) as boolean
declare function LowerTypeLitConvert_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean
declare function TypeLitCopySource_ _
    ( byref c as Ctx, byval target as Tko.NodeId, byval value as Tko.NodeId ) as Tko.NodeId
declare function StrSwapKind_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byref n as longint ) as long

'' Ctx and the shared helpers live in lowerctx.bi: lowering is now two files.


#include once "mir/lowerutil.bas"

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
        '' '@wstr( "w1" )' -- A WIDE STRING IS ALREADY A POINTER, so its address is
        '' that pointer and not the address of a temporary holding one. Measured: fbc
        '' folds the whole thing to '(uint16*)L"w1"', the literal's own storage. Asking
        '' LowerAddr for a CALL's address instead gave nothing, and the parameter
        '' default 'byval pw as const wstring ptr = @wstr( "w1" )' declined with it --
        '' which is how functions/paraminit writes every wide default.
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

        dim as MirValue x = LowerExpr( c, up->operand )
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
        if c.info->TypeOf_( id ) = Tko.TYPE_NONE then
            dim as Tko.TypeId lud = c.types->Unqualify( c.info->TypeOf_( bp->lhs ) )
            dim as Tko.TypeId rud = c.types->Unqualify( c.info->TypeOf_( bp->rhs ) )
            dim as boolean udtOperand = (c.types->Kind( lud ) = Tko.TK_UDT) orelse _
                                        (c.types->Kind( rud ) = Tko.TK_UDT)
            if udtOperand then return v
        end if

        dim as MirValue l = LowerExpr( c, bp->lhs )
        dim as MirValue r = LowerExpr( c, bp->rhs )
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


'' NOT private any more: the expression call chain moved to lowerintr.bas when this
'' file reached its size limit, and it ends here.





'' -------------------------------------------------------------- statements



private sub LowerAssign _
    ( byref c as Ctx, byval target as Tko.NodeId, byval value as Tko.NodeId )

    '' A string assignment is a runtime call, not a store. When it cannot be lowered
    '' -- 'a = b + a' needs a temporary -- it is SKIPPED, never allowed to fall
    '' through: an ordinary store would emit load/add/store over 24-byte descriptors,
    '' which is not a partial answer but a wrong one.
    '' A WIDE STRING is neither a store nor the narrow string runtime: 'wstring * N'
    '' is a bare uint16* with its own family of entry points, and which one depends on
    '' whether the SOURCE is wide or narrow.
    '' 'x = type<T>( y )' OVER THE SAME TYPE IS A COPY OF y, not a field list, and
    '' the field-list path could not take it -- T's first field is a LONG and the
    '' argument is a T -- so the whole assignment declined. Unwrapped and assigned,
    '' so a type with an 'operator let' still gets its call. See TypeLitCopySource_.
    dim as Tko.NodeId tlv = TypeLitCopySource_( c, target, value )
    if tlv <> Tko.NODE_NONE then
        LowerAssign( c, target, tlv )
        return
    end if

    if LowerWideAssign( c, target, value ) then return
    if LowerWideToNarrow( c, target, value ) then return

    if IsStringType( c, c.info->TypeOf_( target ) ) then
        if LowerStringAssign( c, target, value ) = false then c.st->skipped += 1
        return
    end if

    '' A FIXED-LENGTH NARROW DESTINATION -- 'zstring * N' -- is a CHAR ARRAY, not a
    '' descriptor, so IsStringType says no and it fell through to the ordinary store
    '' path. There it emitted NOTHING AT ALL and counted as fully lowered: 'dim as
    '' zstring * 8 fa : fa = c' left fa untouched with "0 statements not lowered"
    '' beside it, which is the worst of the three outcomes -- worse than declining,
    '' because nothing said it had happened.
    ''
    '' The runtime call is the one the DIM INITIALISER already used, and fbc emits the
    '' same thing for both: fb_StrAssign( FA, 8, &C, -1, 0 ).
    dim as longint zdn
    dim as long zdk = StrSwapKind_( c, c.info->TypeOf_( target ), zdn )
    '' Kind 4 is a fixed USTRING, which takes the same shape through the UTF-16
    '' entry points.
    if (zdk = 1) orelse (zdk = 3) orelse (zdk = 4) then
        dim as MirValue zdst = LowerAddr( c, target )
        if zdst.kind <> cast( ubyte, MV_NONE ) then
            if LowerZstrAssignTo( c, zdst, zdn, value, false, (zdk = 4) ) then return
        end if
        SkipHere( c )
        return
    end if

    '' A UDT WITH AN ASSIGNMENT OPERATOR IS A CALL, not a store. 'x = y' over a type
    '' holding a string copied the DESCRIPTOR bitwise and left two objects owning one
    '' buffer -- a double free at scope exit, not a leak. fbc emits
    '' '_ZN1TaSERKS_( &X, &Y )'.
    ''
    '' Both sides must be the SAME type: 'x = someOtherThing' is a conversion, and the
    '' assignment operator takes its own type by reference.
    dim as Tko.TypeId atl = c.info->TypeOf_( target )
    if (atl <> Tko.TYPE_NONE) andalso (atl = c.info->TypeOf_( value )) then
        if c.types->Kind( atl ) = Tko.TK_UDT then
            dim as boolean handled = false
            dim as Tko.SymbolId ulet = StructorOf( c, atl, "let" )
            if (ulet <> Tko.SYMBOL_NONE) orelse NeedsLetBody_( c, atl ) then
                dim as MirValue da = LowerAddr( c, target )
                dim as MirValue sa = LowerAddr( c, value )
                if (da.kind <> cast( ubyte, MV_NONE )) andalso _
                   (sa.kind <> cast( ubyte, MV_NONE )) then
                    if ulet <> Tko.SYMBOL_NONE then
                        dim as FB.Array( of ulong ) largs
                        largs.Push( cast( ulong, sa.kind ) )
                        largs.Push( cast( ulong, sa.id ) )
                        EmitStructorCall( c, ulet, -1, @da, @largs )
                    else
                        CallImplicitLet_( c, atl, da, sa )
                    end if
                    handled = true
                end if
            end if
            if handled then return
        end if
    end if

    '' Same reason as the read: a full-width store into a bitfield's unit would
    '' overwrite every field packed beside it, so it is a read-modify-write.
    '' 't.V = x' OVER A PROPERTY IS A CALL, not a store. Without this it reached the
    '' ordinary store path, which looked for a FIELD of that name, found a procedure and
    '' declined.
    if LowerPropertySet_( c, target, value ) then return

    if LowerBitfieldStore( c, target, value ) then return

    '' 'let (a, b) = expr' -- N assignments from the elements of ONE evaluation, not an
    '' assignment of one thing to another. An N_TUPLE target is not an lvalue and has no
    '' address, so the whole statement declined.
    if LowerDestructure( c, target, value ) then return

    dim as MirValue addr = LowerAddr( c, target )
    dim as MirValue val = LowerExpr( c, value )
    if (addr.kind = cast( ubyte, MV_NONE )) orelse (val.kind = cast( ubyte, MV_NONE )) then
        SkipHere( c )
        return
    end if
    '' AN UNTYPED TARGET IS A DECLINE, not a store. Every remaining MIR verify failure
    '' in the corpus was this one shape -- 'store: stores <T> into a void slot' --
    '' where the frontend left a variable untyped and lowering stored into it anyway.
    ''
    '' The verifier exists to catch that, and catching it is the right outcome; but
    '' EMITTING the store and then reporting it is worse than not emitting it. A
    '' decline is counted, names the site, and leaves nothing malformed behind.
    if LowerType( c.info->TypeOf_( target ), *c.types ) = MT_VOID then
        SkipHere( c )
        return
    end if

    '' The stored value must match the TARGET's type exactly -- MIR has no implicit
    '' conversions, so the narrowing FreeBASIC allows on assignment is explicit here.
    '' The type comes from the target EXPRESSION, not from the local slot: a member
    '' store's address is a temp from field.addr, and there is no slot to ask.
    val = Coerce( c, val, LowerType( c.info->TypeOf_( target ), *c.types ), _
                  IsUnsignedType( c, c.info->TypeOf_( value ) ) )
    dim as MirInst ins
    ins.op = cast( ushort, M_STORE )
    ins.ty = cast( ubyte, MT_VOID )
    ins.a = addr
    ins.b = val
    Emit( c, ins )
end sub


declare sub LowerStmtInner( byref c as Ctx, byval id as Tko.NodeId )

'' The assignment and declaration helpers, in their own file at the 1500-line cap.
#include once "mir/lowerinit.bas"

sub LowerStmt( byref c as Ctx, byval id as Tko.NodeId )
    if id = Tko.NODE_NONE then return
    if c.curBlock < 0 then return
    '' Saved and restored: statements nest, and a decline belongs to the INNERMOST one.
    dim as ushort savedKind = c.curStmtKind
    dim as ulong savedNode = c.curStmtNode
    c.curStmtKind = cast( ushort, c.ast->Kind( id ) )
    c.curStmtNode = cast( ulong, id )

    '' STATEMENT-LIFETIME STRING TEMPORARIES. A string 'iif' builds its result in a
    '' temporary descriptor that must be released once the statement that consumes it
    '' has finished -- measured; fbc emits the fb_StrDelete on the very next line.
    '' That is a shorter life than any scope, so it cannot use the scope cleanup list.
    ''
    '' The mark is saved and restored because statements NEST: an 'if' releases only
    '' the temporaries its own condition made, not the ones its body made, and those
    '' have already been released by the inner LowerStmt.
    dim as long tmpMark = c.strTemps.Count
    dim as long wtmpMark = c.wstrTemps.Count
    dim as long utmpMark = c.udtTemps.Count

    LowerStmtInner( c, id )

    ReleaseUdtTemps_( c, utmpMark )

    while c.strTemps.Count > tmpMark
        dim as long slot = cast( long, c.strTemps[c.strTemps.Count - 1] )
        c.strTemps.Pop( )
        '' A dead cursor means the statement ended in a terminator -- a RETURN or a
        '' GOTO -- and anything emitted here would land in no block at all. fbc has
        '' the same hole and leaks the temporary; matching it beats emitting an
        '' instruction with nowhere to go.
        if c.curBlock >= 0 then
            dim as MirValue addr
            addr.kind = cast( ubyte, MV_LOCAL )
            addr.ty = cast( ubyte, MT_PTR )
            addr.id = slot
            dim as FB.Array( of ulong ) args
            args.Push( cast( ulong, addr.kind ) ) : args.Push( cast( ulong, addr.id ) )
            EmitRtl( c, StrRtlFor_( c, c.f->locals[slot].frontendType, _
                                    RTL_STR_DELETE ), args )
        end if
    wend

    '' A WIDE temporary's slot holds a POINTER to an allocation, so what is released is
    '' the pointer LOADED from it -- not the slot's address, which is where the pointer
    '' lives. fbc writes 'fb_WstrDelete( (uint16*)TMP$2$1 )'.
    while c.wstrTemps.Count > wtmpMark
        dim as long wslot = cast( long, c.wstrTemps[c.wstrTemps.Count - 1] )
        c.wstrTemps.Pop( )
        if c.curBlock >= 0 then
            dim as MirValue waddr
            waddr.kind = cast( ubyte, MV_LOCAL )
            waddr.ty = cast( ubyte, MT_PTR )
            waddr.id = wslot
            dim as MirValue wv = LowerExprLoad( c, waddr, MT_PTR )
            if wv.kind <> cast( ubyte, MV_NONE ) then
                dim as FB.Array( of ulong ) wargs
                wargs.Push( cast( ulong, wv.kind ) ) : wargs.Push( cast( ulong, wv.id ) )
                EmitRtl( c, RTL_WSTR_DELETE, wargs )
            end if
        end if
    wend

    c.curStmtKind = savedKind
    c.curStmtNode = savedNode
end sub

private sub LowerStmtInner( byref c as Ctx, byval id as Tko.NodeId )

    select case c.ast->Kind( id )
    case Tko.N_BLOCK
        LowerBlock( c, id )

    case Tko.N_SCOPE
        '' A SCOPE carries its body in 'b'. Sending the SCOPE node itself to
        '' LowerBlock recursed forever: LowerBlock forwards anything that is not an
        '' N_BLOCK to LowerStmt, which forwarded it straight back. A guard that does
        '' not narrow is not a guard.
        '' A SCOPE is a break TARGET too: 'exit scope' leaves it. Its exit block is
        '' opened LAZILY -- the frame is pushed with -1 and LowerExitLike allocates
        '' the block the first time something actually needs it. Allocating it up
        '' front gave every scope in the corpus a dead block and renumbered the rest,
        '' which the goldens caught.
        c.breakTo.Push( -1 )
        c.contTo.Push( -1 )
        c.loopScope.Push( c.scopeMark.Count )
        c.loopKind.Push( cast( long, Tko.KW_SCOPE ) )
        dim as long scAt = c.breakTo.Count - 1
        PushScope( c )
        LowerBlock( c, StmtOf( c, id )->b )
        CloseScope( c )
        dim as long scExit = c.breakTo[scAt]
        c.breakTo.Pop( )
        c.contTo.Pop( )
        c.loopScope.Pop( )
        c.loopKind.Pop( )
        if scExit >= 0 then
            Terminate( c, MTERM_BR, scExit, -1, NoVal( ) )
            c.curBlock = scExit
        end if

    case Tko.N_DEFER
        '' Registered, not run. It fires at the end of the ENCLOSING scope, in
        '' reverse registration order -- which is the FBC-Modern behaviour to
        '' reproduce, not to improve on.
        c.cleanupNode.Push( cast( ulong, StmtOf( c, id )->b ) )
        c.cleanupSlot.Push( -1 )
        c.cleanupType.Push( 0 )

    case Tko.N_VAR
        dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
        if sp->op = cast( ushort, Tko.KW_REDIM ) then
            if LowerRedim( c, id, sp ) = false then SkipHere( c )
            return
        end if
        '' 'dim BYREF rb as integer = a' ALIASES a, and its slot holds a POINTER --
        '' the same shape a byref PARAMETER has. Resolve types it as a REFERENCE, so
        '' the slot lowers to a pointer and AddrOfVar loads it; every read, every write
        '' and every '@' of the alias then goes through the indirection, because all of
        '' them ask that one function.
        ''
        '' What is left here is the DECLARATION: it stores the referent's ADDRESS, not
        '' its value. fbc writes 'int64* RB$0; RB$0 = &A$0;'.
        ''
        '' This used to decline, and the decline was the right answer at the time:
        '' parsing BYREF had turned a statement that silently vanished into one that
        '' silently ALIASED NOTHING -- 'rb = 5' then 'print a' gives 5 under fbc and
        '' would have given 1 here.
        dim as boolean isByrefLocal = _
            ((c.ast->nodes[cast( long, id )].flags and Tko.NF_BYREF) <> 0)
        for i as long = 0 to sp->count - 1
            dim as Tko.NodeId item = cast( Tko.NodeId, c.ast->children[sp->first + i] )
            if c.ast->Kind( item ) <> Tko.N_VAR_ITEM then continue for
            dim as Tko.StmtPayload ptr ip = StmtOf( c, item )
            '' The VARIABLE, not a type name that happens to share the spelling.
            dim as Tko.SymbolId sid = Tko.SYMBOL_NONE
            if (c.ast->nodes[cast( long, item )].flags and Tko.NF_QUALIFIED) = 0 then
                sid = c.syms->LookupLocalTyped( c.info->ScopeOf( id ), ip->name, false )
            end if
            '' 'dim shared T.x as integer = 2' DEFINES a static member, looked up
            '' through its OWNER. See StaticMemberSym_.
            if (c.ast->nodes[cast( long, item )].flags and Tko.NF_QUALIFIED) <> 0 then
                sid = StaticMemberSym_( c, id, item )
            end if
            if sid = Tko.SYMBOL_NONE then
                SkipHere( c )
                continue for
            end if
            '' DIM SHARED is STORAGE, not code. fbc emits 'static int32 H$ = 5;' --
            '' the initialiser belongs to the definition and is not a store executed
            '' anywhere -- so the declaration records the initial value and emits
            '' nothing.
            ''
            '' A shared string also gets NO cleanup: fbc emits no fb_StrDelete for one,
            '' anywhere. Registering one here would release module storage at the end of
            '' whichever scope happened to declare it.
            '' A STATIC local takes the same route: module lifetime, a compile-time
            '' initialiser rather than a store on entry, and no cleanup registered.
            dim as boolean inModule = IsSharedVar( c, sid )
            if IsStaticLocal( c, sid ) then inModule = true
            if inModule then
                '' A SHARED OR STATIC ALIAS is module storage holding an address, and
                '' fbc initialises it statically -- 'int64* RG$ = &G$;'. A MIR global
                '' carries an integer, a float or a byte image, none of which is a
                '' RELOCATION, so the address is stored where the declaration is
                '' instead. Same value: the referent is module storage too, so its
                '' address is the same on every pass through this line.
                if isByrefLocal then
                    if BindAliasStorage( c, sid, ip->b, true ) = false then
                        SkipHere( c )
                        c.st->varByref += 1
                    end if
                    continue for
                end if
                '' A STATIC LOCAL OBJECT is constructed LAZILY, where it is declared:
                '' a guard flag, the constructor and an atexit thunk. Module storage
                '' with no code run on it left a string field's descriptor
                '' uninitialised for the life of the program.
                if IsStaticLocal( c, sid ) then
                    if LowerStaticLocalInit_( c, sid, ip->b ) then continue for
                end if
                InitSharedGlobal( c, sid, ip->b )
                continue for
            end if

            dim as long slot = LocalFor( c, sid )

            '' THE ALIAS ITSELF: store the referent's ADDRESS in the slot and stop. No
            '' construction, no cleanup and no initialiser store -- the alias owns
            '' nothing, and the thing it names was declared somewhere else.
            if isByrefLocal then
                if BindAliasStorage( c, sid, ip->b, false ) = false then
                    SkipHere( c )
                    c.st->varByref += 1
                end if
                continue for
            end if

            '' A UDT local is CONSTRUCTED where it is declared and DESTROYED at the
            '' end of its scope. The destructor is registered into the same cleanup
            '' list the defers use, so the measured order -- reverse registration,
            '' interleaved with defers, innermost scope first on an early exit --
            '' applies to it without any extra arrangement.
            dim as Tko.Symbol ptr vs = c.syms->SymbolAt( sid )
            dim as boolean constructed = false
            dim as boolean strInited = false

            '' A DYNAMIC array's slot holds a DESCRIPTOR, which has to be filled in
            '' before anything can redim or erase it, and erased on the way out --
            '' fbc erases every local dynamic array at scope exit whatever its element
            '' type. Registered as cleanup node 1, which the cleanup emitter reads as
            '' 'erase this array slot'.
            if (slot >= 0) andalso (vs <> 0) then
                if c.types->IsDynArray( vs->type_ ) then
                    dim as MirValue dd
                    dd.kind = cast( ubyte, MV_LOCAL )
                    dd.ty = cast( ubyte, MT_PTR )
                    dd.id = slot
                    InitDynArrayDesc( c, dd, vs->type_ )
                    c.cleanupNode.Push( CLEANUP_ERASE_ARRAY )
                    c.cleanupSlot.Push( slot )
                    c.cleanupType.Push( 0 )
                end if
            end if

            if (slot >= 0) andalso (vs <> 0) then
                '' 'dim as T x = T( 5 )' selects a constructor by its arguments; a
                '' bare 'dim as T x' takes the no-argument one.
                '' 'dim as T y = x' OVER THE SAME TYPE IS THE COPY CONSTRUCTOR.
                '' Without it the initialiser was a whole-aggregate load and store, so
                '' a type holding a string ended with two objects owning one buffer --
                '' and both were released at scope exit. fbc emits
                '' '_ZN1TC1ERKS_( &Y, &X )' and nothing else: no default constructor
                '' call and no copy of the bytes.
                '' A TYPE LITERAL IS A CONSTRUCTOR CALL, NOT A COPY SOURCE.
                '' 'dim as T x = type<T>( 123 )' has T's own type, so it reached the
                '' copy path, which took its ADDRESS and passed that as the argument:
                '' '_ZN7CTORUDTC1Ei( @a, @$tmp2 )' where 123 belonged. Its children are
                '' the constructor's arguments and LowerCtorInit below takes them.
                '' A CONSTRUCTOR CALL IS NOT A COPY SOURCE EITHER. 'dim a as T = T( 3 )'
                '' now has the type T on its initialiser -- it did not before -- so it
                '' reached the copy path, which built a TEMPORARY, constructed into
                '' that, and then copy-constructed 'a' from it. fbc constructs 'a'
                '' directly, and LowerCtorInit below does the same.
                dim as boolean initIsLiteral = false
                if ip->b <> Tko.NODE_NONE then
                    if c.ast->Kind( ip->b ) = Tko.N_TUPLE then
                        initIsLiteral = _
                            ((c.ast->nodes[cast( long, ip->b )].flags and _
                              Tko.NF_TYPE_LITERAL) <> 0)
                    elseif c.ast->Kind( ip->b ) = Tko.N_CALL then
                        initIsLiteral = _
                            (TypeCtorTypeOf_( c, ip->b ) <> Tko.TYPE_NONE)
                    end if
                end if
                if (ip->b <> Tko.NODE_NONE) andalso (initIsLiteral = false) then
                    dim as Tko.TypeId ivt = c.info->TypeOf_( ip->b )
                    if (ivt <> Tko.TYPE_NONE) andalso (ivt = vs->type_) andalso _
                       (c.types->Kind( ivt ) = Tko.TK_UDT) then
                        '' AND ITS PARAMETER MUST BE THE TYPE ITSELF. StructorWithArity
                        '' answers ANY one-argument constructor, so a type declaring
                        '' 'constructor( byval n as long )' and nothing else had that
                        '' one picked as its copy constructor -- and was handed an
                        '' ADDRESS where a long belonged.
                        dim as Tko.SymbolId ucp = CopyCtorOf_( c, ivt )
                        if (ucp <> Tko.SYMBOL_NONE) orelse NeedsLetBody_( c, ivt ) then
                            dim as MirValue dsa
                            dsa.kind = cast( ubyte, MV_LOCAL )
                            dsa.ty = cast( ubyte, MT_PTR )
                            dsa.id = slot
                            dim as MirValue ssa = LowerAddr( c, ip->b )
                            if ssa.kind <> cast( ubyte, MV_NONE ) then
                                if ucp <> Tko.SYMBOL_NONE then
                                    dim as FB.Array( of ulong ) cargs
                                    cargs.Push( cast( ulong, ssa.kind ) )
                                    cargs.Push( cast( ulong, ssa.id ) )
                                    EmitStructorCall( c, ucp, slot, 0, @cargs )
                                else
                                    CallImplicitCopy_( c, ivt, dsa, ssa )
                                end if
                                constructed = true
                            end if
                        end if
                    end if
                end if
                if constructed = false then
                    constructed = LowerCtorInit( c, slot, vs->type_, ip->b )
                end if
                '' ...and 'dim u as U = s', a CONVERTING constructor, which fell
                '' through to the default one and dropped the initialiser entirely.
                if constructed = false then
                    constructed = LowerConvCtorInit_( c, slot, vs->type_, ip->b )
                end if
                dim as Tko.SymbolId ctor = Tko.SYMBOL_NONE
                if constructed = false then
                    ctor = StructorWithArity( c, _
                        StructorOf( c, vs->type_, "__ctor" ), 0 )
                end if
                if ctor <> Tko.SYMBOL_NONE then EmitStructorCall( c, ctor, slot )

                '' THE VPTR, for a type that has a table. fbc stores it inside the
                '' constructor -- implicit or written -- so a type with no constructor
                '' at all still gets one made for it. tiko-lang synthesises no constructors,
                '' so the store is emitted HERE for a variable that runs none, and in
                '' the constructor's own prologue when it does.
                ''
                '' NOT COVERED, and it is the honest limit of this: a UDT FIELD of a
                '' class type, an element of an array of one, and 'new T'. Each of
                '' those is constructed somewhere tiko-lang models no construction at all,
                '' and inventing one here would be inventing implicit structors.
                '' NO WRITTEN CONSTRUCTOR, but the type may still need one: a
                '' string field's descriptor has to be zeroed before anything assigns
                '' through it, a dynamic array's descriptor has to be built, and a
                '' type with a table needs its vptr. fbc synthesises a constructor for
                '' exactly those cases; this calls the one tiko-lang synthesises.
                if (ctor = Tko.SYMBOL_NONE) andalso (constructed = false) then
                    dim as MirValue va
                    va.kind = cast( ubyte, MV_LOCAL )
                    va.ty = cast( ubyte, MT_PTR )
                    va.id = slot
                    '' A UDT ONLY. A bare 'dim as string s' and a bare dynamic
                    '' array have their own initialisation at this site already, and
                    '' routing them through here asked for a constructor of a type
                    '' called FBSTRING that nothing defines.
                    if c.types->Kind( vs->type_ ) = Tko.TK_UDT then
                        if TypeNeedsInit_( c, vs->type_ ) then
                            CallImplicitCtor_( c, vs->type_, va )
                        end if
                    elseif ArrayElemNeedsInit_( c, vs->type_ ) then
                        EmitArrayElems_( c, slot, vs->type_, true )
                    end if
                end if
                dim as Tko.SymbolId dtor = StructorWithArity( c, _
                    StructorOf( c, vs->type_, "__dtor" ), 0 )
                if dtor <> Tko.SYMBOL_NONE then
                    c.cleanupNode.Push( cast( ulong, dtor ) )
                    c.cleanupSlot.Push( slot )
                    c.cleanupType.Push( 0 )
                elseif ArrayElemNeedsDtor_( c, vs->type_ ) then
                    '' AN ARRAY OF T IS N OBJECTS, each destroyed in turn -- in reverse,
                    '' which is what 'delete[]' was measured doing.
                    c.cleanupNode.Push( CLEANUP_DESTROY_ARRAY )
                    c.cleanupSlot.Push( slot )
                    c.cleanupType.Push( cast( ulong, vs->type_ ) )
                elseif (c.types->Kind( vs->type_ ) = Tko.TK_UDT) andalso _
                       TypeNeedsDtor_( c, vs->type_ ) then
                    '' ...and the destructor fbc synthesises, for the same reasons.
                    '' Without it a UDT holding a string leaked its buffer at every
                    '' scope exit, silently.
                    c.cleanupNode.Push( CLEANUP_IMPLICIT_DTOR )
                    c.cleanupSlot.Push( slot )
                    c.cleanupType.Push( cast( ulong, vs->type_ ) )
                end if
                if IsStringType( c, vs->type_ ) then
                    '' Order matters: the descriptor is made valid BEFORE its release
                    '' is registered, so no path can reach the fb_StrDelete with a
                    '' descriptor that was never written.
                    '' The answer is READ: a string initialiser that cannot be built
                    '' is a decline, not a variable that silently starts out empty.
                    if LowerStringInit( c, slot, item, ip->b ) = false then SkipHere( c )
                    strInited = true
                    c.cleanupNode.Push( 0 )
                    c.cleanupSlot.Push( slot )
                    c.cleanupType.Push( 0 )
                end if

                '' A 'string * N' IS PREFILLED WITH SPACES, not zeros, and not
                '' incidentally: it has no terminator, so its N bytes ARE its value and
                '' an unwritten one must read back as N blanks. Measured --
                '' '__builtin_memset( (uint8*)A$1, 32, 32ll )' -- and the one thing here
                '' that a zstring's zero-fill would get wrong rather than merely leave
                '' untidy. Emitted before any initialiser, which then overwrites it.
                dim as longint fsn3
                if StrSwapKind_( c, vs->type_, fsn3 ) = 3 then
                    dim as MirValue fsa
                    fsa.kind = cast( ubyte, MV_LOCAL )
                    fsa.ty = cast( ubyte, MT_PTR )
                    fsa.id = slot
                    dim as FB.Array( of ulong ) fma
                    fma.Push( cast( ulong, fsa.kind ) ) : fma.Push( cast( ulong, fsa.id ) )
                    fma.Push( cast( ulong, MV_CONST_INT ) ) : fma.Push( 32 )
                    fma.Push( cast( ulong, MV_CONST_INT ) )
                    fma.Push( cast( ulong, c.types->ElemCount( vs->type_ ) ) )
                    EmitRtl( c, RTL_MEMSET, fma )
                end if
            end if

            '' Hoisted: FreeBASIC warns 38 on a mixed boolean/non-boolean chain, and
            '' the house rule is to name the condition rather than silence it.
            dim as boolean needsStore = (slot >= 0)
            if ip->b = Tko.NODE_NONE then needsStore = false
            '' 'dim d as double = any' INITIALISES NOTHING. It is the explicit request
            '' for an uninitialised variable, and fbc emits the declaration and no
            '' store at all -- measured. Treating 'any' as an ordinary initialiser
            '' expression left it with no value to store, so the declaration DECLINED:
            '' 32 corpus lines, every one of them a statement that is meant to produce
            '' no code. 'any' is a keyword, so nothing else can be spelled that way.
            if IsAnyInit_( c, ip->b ) then needsStore = false
            if constructed then needsStore = false
            '' A string initialiser went through fb_StrInit, which is a call and not a
            '' store; storing over it as well would overwrite the descriptor the
            '' runtime just filled in.
            if strInited then needsStore = false
            '' A BRACE INITIALISER over an array is element stores, not one store of
            '' a value there is no way to name.
            if needsStore andalso (slot >= 0) then
                if LowerArrayInit( c, slot, c.syms->SymbolAt( sid )->type_, ip->b ) then
                    needsStore = false
                end if
            end if

            '' A FIXED WSTRING initialiser is a runtime call, not a store: the slot
            '' holds the buffer itself, so 'dim w as wstring * 50 = trim( t )' has to
            '' go through fb_WstrAssign exactly as an assignment does.
            '' A FIXED-LENGTH NARROW string initialiser is a runtime call too, and its
            '' length arguments are its own element count rather than -1.
            if needsStore andalso (slot >= 0) then
                dim as longint zn2
                dim as long zk2 = StrSwapKind_( c, c.syms->SymbolAt( sid )->type_, zn2 )
                if (zk2 = 1) orelse (zk2 = 3) orelse (zk2 = 4) then
                    dim as MirValue zdst
                    zdst.kind = cast( ubyte, MV_LOCAL )
                    zdst.ty = cast( ubyte, MT_PTR )
                    zdst.id = slot
                    if LowerZstrAssignTo( c, zdst, zn2, ip->b, true, (zk2 = 4) ) then _
                        needsStore = false
                end if
            end if

            if needsStore andalso (slot >= 0) then
                dim as long wn = _
                    WideStringElems( c, c.syms->SymbolAt( sid )->type_ )
                if wn > 0 then
                    dim as MirValue wdst
                    wdst.kind = cast( ubyte, MV_LOCAL )
                    wdst.id = slot
                    if LowerWideAssignTo( c, wdst, wn, ip->b ) then needsStore = false
                end if
            end if

            '' 'dim as UDT x = ( 1, 2, 3 )' -- a PAREN INITIALISER LIST, which is a
            '' sequence of field stores and not a value to coerce into the slot.
            if needsStore andalso (slot >= 0) then
                if LowerUdtParenInit_( c, slot, c.syms->SymbolAt( sid )->type_, _
                                       ip->b ) then needsStore = false
            end if

            if needsStore then
                dim as MirValue val = LowerExpr( c, ip->b )
                '' AN INITIALISER THAT WOULD NOT LOWER IS A DECLINE, and was silent:
                '' the store was simply skipped, so 'dim as integer r = iif( c, 10,
                '' 20 )' allocated r, stored nothing, and printed whatever the stack
                '' held -- with "0 statements not lowered" beside it. Every other
                '' decline in this file is counted; this one was not.
                if val.kind = cast( ubyte, MV_NONE ) then SkipHere( c )
                if val.kind <> cast( ubyte, MV_NONE ) then
                    val = Coerce( c, val, cast( MirType, c.f->locals[slot].ty ), _
                                  IsUnsignedType( c, c.info->TypeOf_( ip->b ) ) )
                    dim as MirValue addr
                    addr.kind = cast( ubyte, MV_LOCAL )
                    addr.ty = cast( ubyte, MT_PTR )
                    addr.id = slot
                    dim as MirInst ins
                    ins.op = cast( ushort, M_STORE )
                    ins.ty = cast( ubyte, MT_VOID )
                    ins.a = addr
                    ins.b = val
                    Emit( c, ins )
                end if
            end if
        next

    case Tko.N_AMBIGUOUS
        dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
        select case c.info->AmbiguousOf( id )
        case Tko.AMB_RESULT
            '' BASIC's result assignment, both spellings: 'function = expr' and
            '' 'f = expr' inside f. It stores and CARRIES ON -- it is not a return, so
            '' no terminator and no cleanups.
            '' A UDT RESULT travelling through the HIDDEN POINTER has no result slot
            '' at all: the pointer IS the result object, so 'function = expr' copies
            '' the value straight through it. Measured -- fbc emits
            '' '__builtin_memcpy( tmp$2$1, &T$1, 4 )', or the type's 'operator let'
            '' where it has one.
            if (c.resultSlot < 0) andalso (c.sretParam >= 0) then
                if LowerSretResult( c, sp->b ) = false then
                    SkipHere( c )
                    c.st->ambResultNoSlot += 1
                end if
            elseif c.resultSlot < 0 then
                '' A result type with no slot: a UDT return that is NOT sret, which is
                '' returned BY VALUE and has no address to write through. Declining is
                '' the honest answer; storing into an invented slot would compile and
                '' be wrong.
                SkipHere( c )
                c.st->ambResultNoSlot += 1
                '' WHICH TYPE, so the next reader has a name rather than a count. The
                '' scalar, string, sret and by-value-UDT cases all have slots; what
                '' reaches here is whatever none of those recognised.
                if c.st->resultNoSlotKinds.Count = 0 then
                    for i as long = 0 to 15
                        c.st->resultNoSlotKinds.Push( 0 )
                    next
                end if
                dim as long rk = cast( long, c.types->Kind( c.resultType ) )
                if (rk >= 0) andalso (rk < 16) then
                    c.st->resultNoSlotKinds[rk] += 1
                end if
            elseif c.byrefResult then
                if LowerByrefResult_( c, sp->b ) = false then SkipHere( c )
            elseif IsStringType( c, c.resultType ) then
                '' A STRING RESULT IS ASSIGNED, NOT STORED. The result slot holds a
                '' DESCRIPTOR, and copying one is not the same as assigning to it:
                '' 'function = s' was emitting a raw 24-byte aggregate copy, so the
                '' result descriptor came out pointing at the ARGUMENT's data. Both
                '' owners then free it. Measured -- fbc emits
                '' 'fb_StrAssign( &fb$result, -1, S, -1, 0 )', and the same call with
                '' a length of 0 for a ZSTRING source and fb_WstrAssignToA for a wide
                '' one. It compiled, verified and counted as lowered the whole time.
                '' A WIDE SOURCE goes through fb_WstrAssignToA, not fb_StrAssign.
                if LowerWideToNarrowSlot( c, c.resultSlot, c.resultType, sp->b ) then
                elseif LowerStringAssignToSlot( c, c.resultSlot, sp->b ) = false then
                    SkipHere( c )
                end if
            elseif ResultFieldListInit_( c, sp->b ) then
                '' 'function = type( 1, 2 )' and 'function = ( 1, 2 )' -- A FIELD LIST
                '' WRITTEN STRAIGHT INTO THE RESULT. Neither spelling names a type: the
                '' RESULT's type is the context, exactly as a declaration's is for
                '' 'dim as P x = ( 1, 2 )'. Lowering it as an expression asked the tuple
                '' for a type it has not got, so both declined.
            else
                dim as MirValue rval = LowerExpr( c, sp->b )
                if rval.kind = cast( ubyte, MV_NONE ) then
                    SkipHere( c )
                else
                    dim as MirValue raddr
                    raddr.kind = cast( ubyte, MV_LOCAL )
                    raddr.ty = cast( ubyte, MT_PTR )
                    raddr.id = c.resultSlot
                    dim as MirInst rs
                    rs.op = cast( ushort, M_STORE )
                    rs.ty = cast( ubyte, MT_VOID )
                    rs.a = raddr
                    '' MIR has no implicit conversions, so the narrowing FreeBASIC
                    '' allows on a result assignment is explicit here, exactly as it
                    '' is for an ordinary assignment.
                    rs.b = Coerce( c, rval, cast( MirType, c.resultTy ), _
                                   IsUnsignedType( c, c.info->TypeOf_( sp->b ) ) )
                    Emit( c, rs )
                end if
            end if
        case Tko.AMB_ASSIGN
            '' THE BLOCK AS WELL AS THE COUNT. A compound assignment that is CONTROL
            '' FLOW -- 'i andalso= e' -- ends the current block and continues in the
            '' join, so comparing the join's instruction count against the count taken
            '' in a different block reported a statement that lowered perfectly well as
            '' having emitted nothing.
            dim as long beforeAB = c.curBlock
            dim as long beforeA = c.f->blocks[c.curBlock].insts.Count
            dim as Tko.TokenKind aop = cast( Tko.TokenKind, sp->op )
            '' '&=' WAS TREATED AS PLAIN, so 's &= "b"' lowered to fb_StrAssign -- an
            '' assignment where an append belongs. So is '+=' over a string.
            if aop = Tko.TK_EQ then
                LowerAssign( c, sp->a, sp->b )
            elseif LowerConcatAssignStmt( c, sp->a, sp->b, aop ) then
            elseif LowerCompoundAssign( c, sp->a, sp->b, aop ) = false then
                SkipHere( c )
            end if
            if (c.curBlock = beforeAB) andalso _
               (c.f->blocks[c.curBlock].insts.Count = beforeA) then
                c.st->ambAssign += 1
                '' WHICH KIND OF TARGET, so the next reader has something to go and
                '' implement rather than a number.
                if c.st->ambAssignKinds.Count = 0 then
                    for i as long = 0 to 15
                        c.st->ambAssignKinds.Push( 0 )
                    next
                end if
                dim as Tko.TypeId att = c.info->TypeOf_( sp->a )
                if att = Tko.TYPE_NONE then
                    c.st->ambAssignUntyped += 1
                else
                    dim as long ak = cast( long, c.types->Kind( att ) )
                    if (ak >= 0) andalso (ak < 16) then c.st->ambAssignKinds[ak] += 1
                end if
                if c.st->ambAssignValKinds.Count = 0 then
                    for i as long = 0 to 127
                        c.st->ambAssignValKinds.Push( 0 )
                    next
                end if
                dim as long vk = cast( long, c.ast->Kind( sp->b ) )
                if (vk >= 0) andalso (vk < 128) then c.st->ambAssignValKinds[vk] += 1
            end if
        case Tko.AMB_CALL
            '' A CALL STATEMENT THAT PRODUCES NOTHING IS A DECLINE, and has to be counted
            '' as one. LowerCall returns MV_NONE for an unresolved callee without
            '' recording anything, so when the classification changed from error to call
            '' these statements stopped being counted while still emitting no code --
            '' the count fell by 78,000 and the work was not being done.
            ''
            '' A call whose result is void legitimately yields MV_NONE too, so the test
            '' is whether the statement emitted ANY instruction, not what it returned.
            '' THE BLOCK IS PART OF THE TEST. An argument containing ANDALSO is
            '' control flow, so lowering the call moves c.curBlock -- and comparing
            '' this block's count against a DIFFERENT block's said "emitted nothing"
            '' for a call that had just been emitted elsewhere.
            dim as long beforeB = c.curBlock
            dim as long beforeN = c.f->blocks[c.curBlock].insts.Count
            '' AND WHETHER A CALL GAVE UP, which the instruction count cannot tell:
            '' the ARGUMENTS are lowered before the call can fail, so a statement whose
            '' call was never emitted looked exactly like one that lowered.
            c.lastCallOk = true
            '' 'W( 1, 2 )' is an expression; 'W 1, 2' is this statement's own callee
            '' and children, and looks nothing like a call node.
            if c.ast->Kind( sp->a ) = Tko.N_CALL then
                '' 'base( n )' IS THE BASE-CLASS CONSTRUCTOR, not a call to anything
                '' named 'base' -- tried first, because the ordinary call path has no
                '' callee to bind and would decline it.
                if LowerBaseCtorCall_( c, sp->a ) = false then LowerExpr( c, sp->a )
            else
                LowerStmtCall( c, id )
            end if

            '' ASSERT AND ASSERTWARN EMIT NOTHING ON PURPOSE. Measured: without -g,
            '' fbc evaluates neither the condition nor anything else, and its C
            '' contains no trace of the statement. Emitting nothing is the WHOLE
            '' lowering, so the emitted-nothing test below has to know that -- and it
            '' is the only construct in the language for which that is true.
            dim as boolean deliberateNoOp = false
            if c.ast->Kind( sp->a ) = Tko.N_CALL then
                dim as Tko.ListPayload ptr np = _
                    @c.ast->lists[cast( long, c.ast->nodes[cast( long, sp->a )].data )]
                if np->target <> Tko.NODE_NONE then
                    if c.ast->Kind( np->target ) = Tko.N_IDENT then
                        dim as Tko.IdentPayload ptr nip = _
                            @c.ast->idents[cast( long, _
                                c.ast->nodes[cast( long, np->target )].data )]
                        select case Tko.Text.LowerAscii( c.names->Spelling( nip->name ) )
                        case "assert", "assertwarn"
                            deliberateNoOp = true
                        end select
                    end if
                end if
            end if

            if deliberateNoOp then
                '' nothing to emit, and nothing to count
            elseif c.lastCallOk = false then
                SkipHere( c )
                CountUnlowredCall( c, sp->a )
            elseif (c.curBlock = beforeB) andalso _
                   (c.f->blocks[c.curBlock].insts.Count = beforeN) then
                SkipHere( c )
                CountUnlowredCall( c, sp->a )
            end if
        case else
            '' No expression to look at: the statement was classified as something other
            '' than a call or an assignment -- a property setter, BASIC's result
            '' assignment, or nothing at all.
            SkipHere( c )
            c.st->ambOther += 1
            dim as long ac = cast( long, c.info->AmbiguousOf( id ) )
            while c.st->ambOtherClass.Count <= ac
                c.st->ambOtherClass.Push( 0 )
            wend
            c.st->ambOtherClass[ac] += 1
        end select

    case Tko.N_IF
        dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
        LowerIf( c, id, sp )

    case Tko.N_WHILE
        dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
        dim as long headB = NewBlock( c, "while.head" )
        dim as long bodyB = NewBlock( c, "while.body" )
        dim as long exitB = NewBlock( c, "while.exit" )
        Terminate( c, MTERM_BR, headB, -1, NoVal( ) )
        c.curBlock = headB
        '' A UDT temporary made by the CONDITION dies here, not at the end of the
        '' loop: the head runs again on every iteration and the slot is the same one.
        dim as long umark = c.udtTemps.Count
        dim as MirValue cond = LowerCondition( c, sp->a )
        ReleaseUdtTemps_( c, umark )
        Terminate( c, MTERM_CONDBR, bodyB, exitB, cond )
        c.curBlock = bodyB
        c.breakTo.Push( exitB )
        c.contTo.Push( headB )
        c.loopScope.Push( c.scopeMark.Count )
        c.loopKind.Push( cast( long, Tko.KW_WHILE ) )
        '' A loop BODY is a scope: its locals and defers run on every iteration
        '' (docs/plan/08 rule 4), which the measurement confirms.
        PushScope( c )
        LowerBlock( c, sp->b )
        CloseScope( c )
        c.loopScope.Pop( )
        c.loopKind.Pop( )
        c.breakTo.Pop( )
        c.contTo.Pop( )
        Terminate( c, MTERM_BR, headB, -1, NoVal( ) )
        c.curBlock = exitB

    case Tko.N_DO
        LowerDo( c, id )

    case Tko.N_FOR
        LowerFor( c, id )

    case Tko.N_INTRINSIC
        '' The intrinsic STATEMENTS -- one keyword each, and a dispatch long enough
        '' to be its own subject. It lives in lowerintr.bas with the rest of them.
        if LowerIntrinsicStmt( c, id ) = false then SkipStmt( c, id )

    case Tko.N_FOREACH
        if LowerForEachArray( c, id ) = false then SkipStmt( c, id )

    case Tko.N_DELETE_STMT
        if LowerDelete( c, id ) = false then SkipStmt( c, id )

    case Tko.N_WITH
        '' 'with expr' declares nothing and emits nothing of its own -- it is a NAMING
        '' construct. Resolve has already pointed every '.field' inside it at the
        '' subject's own node, so the body lowers as ordinary statements and the member
        '' accesses find their base the usual way.
        ''
        '' ...ONCE. The subject's ADDRESS is computed here and pushed, and LowerAddr
        '' hands that same address back for every use of the node inside the body --
        '' so a subject with a side effect runs once, which is what fbc does, and
        '' 'with( status( hFindSlot( @this ) ) )' does not call hFindSlot per field.
        ''
        '' A subject with no address leaves the stack alone and its members decline
        '' inside the body, which is the honest outcome and what happened before.
        dim as Tko.StmtPayload ptr wp = StmtOf( c, id )
        dim as boolean wpushed = false
        if wp->a <> Tko.NODE_NONE then
            dim as MirValue wa = LowerAddr( c, wp->a )
            if wa.kind <> cast( ubyte, MV_NONE ) then
                '' INTO A SLOT, not held as a value. A GOTO may jump INTO the body --
                '' warnings/branch-cross-with is a corpus file that does exactly that,
                '' and fbc warns about it rather than refusing it -- so a use inside is
                '' not dominated by the definition at the top and the verifier is right
                '' to say so. A LOCAL is not in SSA form: stored once here and loaded
                '' at each use, which is the shape fbc emits as well.
                dim as long wslot = NewTempLocal( c, MT_PTR, _
                    c.types->target.pointerBits \ 8 )
                if wslot >= 0 then
                    dim as MirValue wdst
                    wdst.kind = cast( ubyte, MV_LOCAL )
                    wdst.ty = cast( ubyte, MT_PTR )
                    wdst.id = wslot
                    dim as MirInst wst
                    wst.op = cast( ushort, M_STORE )
                    wst.ty = cast( ubyte, MT_VOID )
                    wst.a = wdst
                    wst.b = wa
                    Emit( c, wst )
                    c.withNode.Push( cast( ulong, wp->a ) )
                    c.withKind.Push( cast( ulong, MV_LOCAL ) )
                    c.withId.Push( cast( ulong, wslot ) )
                    wpushed = true
                end if
            end if
        end if
        LowerBlock( c, wp->b )
        if wpushed then
            c.withNode.Pop( )
            c.withKind.Pop( )
            c.withId.Pop( )
        end if

    case Tko.N_END_STMT
        LowerEndStmt( c, id )

    case Tko.N_SELECT
        LowerSelect( c, id )

    case Tko.N_LABEL
        LowerLabel( c, id )

    case Tko.N_GOTO
        LowerGoto( c, id )

    case Tko.N_RETURN
        dim as Tko.StmtPayload ptr sp = StmtOf( c, id )
        '' 'return' with no expression yields the result variable, not nothing --
        '' 'function = 7 : return' is 7. Loaded only in that case: reading the slot
        '' unconditionally emitted a load every explicit 'return expr' then discarded,
        '' which the golden caught as four dead instructions.
        '' A STRING RESULT does not leave as a value: it is BUILT in the result
        '' descriptor and handed to fb_StrAllocTempResult on the way out, which is
        '' what fbc emits. 'return "hi"' is therefore an ASSIGNMENT into the result
        '' slot followed by that call -- returning the literal directly would hand
        '' back a pointer to static text where the caller expects a descriptor.
        if LowerStringReturn( c, sp->a ) then return

        '' A TRIVIAL UDT RESULT is returned BY VALUE out of its result slot. The value
        '' has to be copied into that slot first, exactly as 'function = expr' does --
        '' the ordinary path below would try to Coerce an aggregate to an aggregate,
        '' which is not a conversion MIR has.
        if c.udtResult andalso (c.resultSlot >= 0) then
            if sp->a <> Tko.NODE_NONE then
                '' THE VALUE FIRST, the address only as a fallback. 'return F( )'
                '' and 'return Vec3d_( x, y, z )' have no address to take -- a call
                '' result is a value -- and requiring one declined 10,387 statements,
                '' which is most of what a UDT-returning function actually returns.
                '' A BARE TUPLE LITERAL HAS NO TYPE OF ITS OWN -- 'return (20, 22)'
                '' names no type and UdtLiteralSlot_ wants one written -- so it is
                '' built straight INTO the result slot from the function's own result
                '' type. fbc builds a temporary and copies it in; this is the same
                '' object one copy earlier, and without it every tuple-returning
                '' function declined its return.
                if LowerTupleReturn_( c, sp->a ) then return

                '' 'return T( args )' CONSTRUCTS INTO THE RESULT, and is not a value
                '' to copy: 'D( this.y + n )' is a constructor call spelled as a call
                '' to the type name, so LowerExpr had nothing to hand back and
                '' LowerAddr no address to take. See LowerCtorReturn_.
                if LowerCtorReturn_( c, sp->a ) then return

                dim as MirValue uval = LowerExpr( c, sp->a )
                dim as boolean copied = false
                if uval.kind = cast( ubyte, MV_NONE ) then
                    dim as MirValue usrc = LowerAddr( c, sp->a )
                    if usrc.kind <> cast( ubyte, MV_NONE ) then
                        uval = LowerExprLoad( c, usrc, MT_AGG )
                    end if
                end if
                if uval.kind <> cast( ubyte, MV_NONE ) then
                    if true then
                        dim as MirValue uda
                        uda.kind = cast( ubyte, MV_LOCAL )
                        uda.ty = cast( ubyte, MT_PTR )
                        uda.id = c.resultSlot
                        dim as MirInst us
                        us.op = cast( ushort, M_STORE )
                        us.ty = cast( ubyte, MT_VOID )
                        us.a = uda
                        us.b = uval
                        Emit( c, us )
                        copied = true
                    end if
                end if
                if copied = false then SkipHere( c )
            end if
            EmitCleanupsTo( c, 0 )
            dim as MirValue ura2
            ura2.kind = cast( ubyte, MV_LOCAL )
            ura2.ty = cast( ubyte, MT_PTR )
            ura2.id = c.resultSlot
            Terminate( c, MTERM_RET, -1, -1, LowerExprLoad( c, ura2, MT_AGG ) )
            c.curBlock = -1
            return
        end if

        '' A UDT RETURN through the hidden pointer: copy into the caller's storage if
        '' there is a value, then return THAT POINTER -- which is what fbc's own C
        '' does, 'return tmp$2$1'.
        if c.sretParam >= 0 then
            if sp->a <> Tko.NODE_NONE then
                if LowerSretResult( c, sp->a ) = false then SkipHere( c )
            end if
            EmitCleanupsTo( c, 0 )
            dim as MirValue spa
            spa.kind = cast( ubyte, MV_LOCAL )
            spa.ty = cast( ubyte, MT_PTR )
            spa.id = c.sretParam
            Terminate( c, MTERM_RET, -1, -1, LowerExprLoad( c, spa, MT_PTR ) )
            c.curBlock = -1
            return
        end if

        dim as MirValue rv
        if sp->a <> Tko.NODE_NONE then
            rv = LowerExpr( c, sp->a )
            '' 'return expr' WHOSE VALUE WOULD NOT LOWER was silent: the terminator
            '' went out with nothing in it and the statement counted as fully lowered,
            '' so a function returned whatever the ABI happened to leave behind. Every
            '' other decline in this file is counted; this one was not.
            if rv.kind = cast( ubyte, MV_NONE ) then SkipHere( c )
        else
            rv = LoadResult( c )
        end if
        '' A RETURN leaves every open scope, so every open scope's actions run,
        '' innermost first, BEFORE the terminator.
        EmitCleanupsTo( c, 0 )
        Terminate( c, MTERM_RET, -1, -1, rv )
        '' The cursor goes DEAD rather than opening a block nothing branches to.
        '' Statements after a RETURN are unreachable, and creating a block for them
        '' left the function with an orphan the verifier rightly complained about.
        c.curBlock = -1

    case Tko.N_EXIT
        LowerExitLike( c, id, true )

    case Tko.N_CONTINUE
        LowerExitLike( c, id, false )

    case Tko.N_PROC, Tko.N_TYPE, Tko.N_ENUM, Tko.N_TYPEDEF, Tko.N_NAMESPACE, _
         Tko.N_CONST, Tko.N_FIELD, Tko.N_PARAM, Tko.N_EXTERN_BLOCK, _
         Tko.N_USING, Tko.N_ASSERT
        '' Declarations: handled by the module walk, not inside a body.
        ''
        '' N_EXTERN_BLOCK belongs here and was declining instead -- 1,238 of them, the
        '' second largest never-started kind. An 'extern "C" ... end extern' can hold
        '' NOTHING EXECUTABLE: measured, both 'print 1' and an assignment inside one are
        '' fbc error 96, "Illegal inside a compound statement or scoped block". What it
        '' may hold is DECLARE, a procedure body, and 'dim shared as T x = 5' -- and a
        '' shared initialiser is part of the global's definition, not a store in main.
        '' So there is nothing for the statement layer to emit, and saying so is not
        '' the same as failing to.

    case else
        SkipStmt( c, id )
    end select
end sub






end namespace
