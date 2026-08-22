'' lower.bas -- AST to MIR. See lower.bi for what this slice does and does not cover.

#include once "mir/lower.bi"
#include once "mir/lowerctx.bi"

namespace Fbx.Mir

declare function StrSwapKind_ _
    ( byref c as Ctx, byval t as Fbx.TypeId, byref n as longint ) as long

'' Ctx and the shared helpers live in lowerctx.bi: lowering is now two files.


function StmtOf _
    ( byref c as Ctx, byval id as Fbx.NodeId ) as Fbx.StmtPayload ptr
    return @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
end function

'' -------------------------------------------------------------- construction

function NewBlock( byref c as Ctx, byref label as string ) as long
    dim as MirBlock b
    b.label = c.names->GetString( label & str( c.f->blocks.Count ) )
    b.term = cast( ubyte, MTERM_NONE )
    b.target = -1
    b.target2 = -1
    c.f->blocks.Push( b )
    c.st->blocks += 1
    return c.f->blocks.Count - 1
end function

'' Instructions are appended to the FUNCTION's list and the current block's extent is
'' widened. That only works while blocks are built in order, which is why lowering
'' never returns to a finished block -- it opens a new one instead.
function Emit( byref c as Ctx, byref ins as MirInst ) as MirValue
    dim as MirValue v
    if c.curBlock < 0 then return v
    dim as MirOp op = cast( MirOp, ins.op )
    '' An instruction that would produce a VOID result is not emitted at all. It
    '' means the frontend could not type the expression, and a well-formed IR with a
    '' gap in it is far more useful than a complete one that is malformed.
    if OpHasResult( op ) andalso (ins.ty = cast( ubyte, MT_VOID )) then
        if (op <> M_CALL) andalso (op <> M_CALL_RTL) andalso _
           (op <> M_CALL_IND) then
            SkipHere( c )
            return v
        end if
    end if
    '' A call returning void produces no value, so it gets no result temp. Giving it
    '' one made every constructor call read as '%2 = call void', which is noise in a
    '' listing the golden tests assert on.
    dim as boolean makesValue = OpHasResult( op )
    if ins.ty = cast( ubyte, MT_VOID ) then makesValue = false
    if makesValue then
        ins.result = c.f->nextTemp
        c.f->nextTemp += 1
    end if
    c.f->blocks[c.curBlock].insts.Push( ins )
    c.st->insts += 1
    if makesValue then
        v.kind = cast( ubyte, MV_TEMP )
        v.ty = ins.ty
        v.id = ins.result
    end if
    return v
end function

'' An empty value, for the terminators that carry none. FreeBASIC will not take a
'' constructed default argument, so it is spelled once here rather than at every call.
function NoVal( ) as MirValue
    dim as MirValue v
    return v
end function

sub Terminate _
    ( byref c as Ctx, byval k as MirTermKind, byval t1 as long, _
      byval t2 as long, byref cond as MirValue )

    if c.curBlock < 0 then return
    dim as MirBlock ptr b = @c.f->blocks[c.curBlock]
    '' A block already terminated is left alone: the second terminator would be
    '' unreachable, and silently dropping it is what 'return' inside an IF needs.
    if b->term <> cast( ubyte, MTERM_NONE ) then return
    b->term = cast( ubyte, k )
    b->target = t1
    b->target2 = t2
    b->cond = cond
end sub

function ConstInt _
    ( byref c as Ctx, byval v as longint, byval t as MirType ) as MirValue
    dim as MirInst ins
    ins.op = cast( ushort, M_CONST )
    ins.ty = cast( ubyte, t )
    ins.imm = v
    return Emit( c, ins )
end function

function ConstFloat _
    ( byref c as Ctx, byval v as double, byval t as MirType ) as MirValue
    dim as MirInst ins
    ins.op = cast( ushort, M_CONST )
    ins.ty = cast( ubyte, t )
    ins.fimm = v
    return Emit( c, ins )
end function

'' A typed zero. A float result slot must be zeroed with a FLOAT constant: an integer
'' zero stored into an f64 slot is a type mismatch the verifier catches, and would be a
'' reinterpreted bit pattern if it did not.
function ZeroOf( byref c as Ctx, byval t as MirType ) as MirValue
    if IsFloatTy( t ) then return ConstFloat( c, 0.0, t )
    return ConstInt( c, 0, t )
end function

function IsFloatTy( byval t as MirType ) as boolean
    return (t = MT_F32) orelse (t = MT_F64)
end function

private function TyWidth( byval t as MirType ) as long
    select case t
    case MT_I8  : return 8
    case MT_I16 : return 16
    case MT_I32, MT_F32 : return 32
    case MT_I64, MT_F64, MT_PTR : return 64
    end select
    return 0
end function

'' MIR has NO implicit conversions (docs/plan/09 section 5, rule 4), so a value whose
'' type differs from the one an instruction needs gets an explicit one. Without this
'' an integer literal -- which FreeBASIC types as INTEGER, so i64 -- is compared
'' against an i32 counter, and the IR states something the backend cannot honour.
function Coerce _
    ( byref c as Ctx, byref v as MirValue, byval want as MirType, _
      byval srcUnsigned as boolean = false ) as MirValue

    if v.kind = cast( ubyte, MV_NONE ) then return v
    dim as MirType have = cast( MirType, v.ty )
    if have = want then return v
    if (have = MT_VOID) orelse (want = MT_VOID) then return v

    '' A POINTER IS NOT AN INTEGER, even where the two are the same width. TyWidth
    '' gives MT_PTR and MT_I64 both 64, so the integer branch below saw "same width"
    '' and returned the value UNCHANGED -- 700 corpus stores of an i64 straight into a
    '' ptr slot, and the verifier was right about every one of them.
    ''
    '' 'dim p as integer ptr : p = 0' is the commonest shape by far. fbc accepts it
    '' silently, and warns only on a non-zero integer (warning 4, "Suspicious pointer
    '' assignment") -- so a conversion is the correct thing to emit here, not a refusal.
    ''
    '' Width FIRST, then the cast. A 32-bit value bitcast straight to a pointer would
    '' state a 32-bit quantity in a 64-bit slot; going through the pointer-sized
    '' integer makes the widening explicit and leaves the bitcast width-preserving.
    if (have = MT_PTR) orelse (want = MT_PTR) then
        dim as MirType intPtrTy = MT_I64
        if c.types->target.pointerBits = 32 then intPtrTy = MT_I32
        if want = MT_PTR then
            dim as MirValue w = Coerce( c, v, intPtrTy, srcUnsigned )
            if w.kind = cast( ubyte, MV_NONE ) then return w
            dim as MirInst bc
            bc.op = cast( ushort, M_BITCAST )
            bc.ty = cast( ubyte, MT_PTR )
            bc.a = w
            return Emit( c, bc )
        end if
        dim as MirInst bc
        bc.op = cast( ushort, M_BITCAST )
        bc.ty = cast( ubyte, intPtrTy )
        bc.a = v
        dim as MirValue w = Emit( c, bc )
        if w.kind = cast( ubyte, MV_NONE ) then return w
        return Coerce( c, w, want )
    end if

    dim as MirInst ins
    ins.ty = cast( ubyte, want )
    ins.a = v
    dim as boolean hf = IsFloatTy( have )
    dim as boolean wf = IsFloatTy( want )

    if hf andalso wf then
        ins.op = cast( ushort, iif( TyWidth( want ) < TyWidth( have ), M_FPTRUNC, M_FPEXT ) )
    elseif hf then
        '' ROUND FIRST. FreeBASIC converts a float to an integer by rounding to the
        '' nearest, halves to even -- measured by running fbc: 1.4 -> 1, 1.6 -> 2,
        '' 2.5 -> 2, 3.5 -> 4, -2.5 -> -2. A bare fptosi truncates toward zero and is
        '' wrong for three of those five, silently, in every conversion in the tree.
        '' fbc's own C says the same thing: 'fb_D2I( v )' is '(int32)nearbyint( v )'.
        dim as MirInst rn
        rn.op = cast( ushort, M_NEARBYINT )
        rn.ty = cast( ubyte, have )
        rn.a = v
        dim as MirValue rv = Emit( c, rn )
        if rv.kind <> cast( ubyte, MV_NONE ) then ins.a = rv
        ins.op = cast( ushort, M_FPTOSI )
    elseif wf then
        '' An UNSIGNED source goes through uitofp. sitofp reads the top bit as a sign,
        '' so a ULONGINT near its maximum came out as -1 instead of 1.8e19.
        ins.op = cast( ushort, iif( srcUnsigned, M_UITOFP, M_SITOFP ) )
    else
        if TyWidth( want ) < TyWidth( have ) then
            ins.op = cast( ushort, M_TRUNC )
        elseif TyWidth( want ) > TyWidth( have ) then
            '' ZERO-extend an unsigned source. Sign-extending one turns every value
            '' with its top bit set negative: a UBYTE of 200 widened to a LONG gave
            '' -56, and fbc prints 200.
            ins.op = cast( ushort, iif( srcUnsigned, M_ZEXT, M_SEXT ) )
        else
            return v
        end if
    end if
    return Emit( c, ins )
end function

'' ------------------------------------------------------------------- locals

'' A local is a slot, addressed by an alloca in the entry block. Locals are found by
'' SYMBOL, so the same name in two scopes gets two slots.



'' An anonymous slot, for a value with no name in the source. The alloca goes in the
'' entry block like any other local, so nothing downstream has to treat it specially.
function NewTempLocal _
    ( byref c as Ctx, byval ty as MirType, byval sizeBytes as long ) as long

    dim as MirLocal l
    l.name = c.names->GetString( "$tmp" & str( c.f->locals.Count ) )
    l.ty = cast( ubyte, ty )
    l.size = sizeBytes
    c.f->locals.Push( l )

    dim as long saved = c.curBlock
    c.curBlock = 0
    dim as MirInst ins
    ins.op = cast( ushort, M_ALLOCA )
    ins.ty = cast( ubyte, MT_PTR )
    ins.imm = c.f->locals.Count - 1
    Emit( c, ins )
    c.curBlock = saved
    return c.f->locals.Count - 1
end function

'' ------------------------------------------------------------- expressions

declare function LowerShortCircuit _
    ( byref c as Ctx, byval id as Fbx.NodeId, byval bp as Fbx.BinaryPayload ptr, _
      byval mt as MirType ) as MirValue
declare function LowerCall _
    ( byref c as Ctx, byval id as Fbx.NodeId, byval mt as MirType ) as MirValue
declare sub LowerIf _
    ( byref c as Ctx, byval id as Fbx.NodeId, byval sp as Fbx.StmtPayload ptr )


function IsUnsignedType _
    ( byref c as Ctx, byval t as Fbx.TypeId ) as boolean
    if t = Fbx.TYPE_NONE then return false
    if c.types->Kind( t ) <> Fbx.TK_BUILTIN then return false
    select case c.types->BuiltinOf( t )
    case Fbx.TY_UBYTE, Fbx.TY_USHORT, Fbx.TY_ULONG, Fbx.TY_UINTEGER, Fbx.TY_ULONGINT
        return true
    end select
    return false
end function


function LowerExpr _
    ( byref c as Ctx, byval id as Fbx.NodeId ) as MirValue

    dim as MirValue v
    if id = Fbx.NODE_NONE then return v

    dim as Fbx.TypeId ft = c.info->TypeOf_( id )
    dim as MirType mt = LowerType( ft, *c.types )

    select case c.ast->Kind( id )
    case Fbx.N_STRING_LIT
        return LowerStringLitAddr( c, id )

    case Fbx.N_INT_LIT
        dim as Fbx.LiteralPayload ptr lp = _
            @c.ast->literals[cast( long, c.ast->nodes[cast( long, id )].data )]
        if mt = MT_VOID then mt = MT_I64
        return ConstInt( c, cast( longint, lp->intValue ), mt )

    case Fbx.N_FLOAT_LIT
        dim as Fbx.LiteralPayload ptr lp = _
            @c.ast->literals[cast( long, c.ast->nodes[cast( long, id )].data )]
        if mt = MT_VOID then mt = MT_F64
        return ConstFloat( c, lp->fltValue, mt )

    case Fbx.N_PAREN
        dim as Fbx.ListPayload ptr pp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
        if pp->count <> 1 then return v
        return LowerExpr( c, cast( Fbx.NodeId, c.ast->children[pp->first] ) )

    case Fbx.N_IDENT, Fbx.N_MEMBER
        dim as MirValue pre = LowerPredeclared( c, id )
        if pre.kind <> cast( ubyte, MV_NONE ) then return pre

        '' A BITFIELD HAS NO ADDRESS OF ITS OWN: it is bits inside a unit its
        '' neighbours share, so it is read by masking rather than by loading.
        dim as MirValue bfv
        if LowerBitfieldRead( c, id, bfv ) then return bfv

        dim as MirValue addr = LowerAddr( c, id )
        if addr.kind = cast( ubyte, MV_NONE ) then return v
        dim as MirInst ins
        ins.op = cast( ushort, M_LOAD )
        ins.ty = cast( ubyte, mt )
        ins.a = addr
        return Emit( c, ins )

    case Fbx.N_ADDROF
        '' '@x' IS THE ADDRESS, which is what LowerAddr already computes for every
        '' lvalue -- a local, a global, a field, an array element, a byref parameter.
        '' There was no case for it at all, so every '@' in the tree produced NOTHING:
        '' 'dim as T ptr p = @obj' allocated p, stored nothing, and 'p->v = 1' then
        '' wrote through whatever the stack held. Silent, because a DIM initialiser
        '' that would not lower skipped its store without counting it.
        dim as Fbx.UnaryPayload ptr ap = _
            @c.ast->unaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        return LowerAddr( c, ap->operand )

    case Fbx.N_NEW
        '' 'new T' -- an ALLOCATION, not a call. It arrives here rather than at the
        '' N_CALL case because it is its own node kind.
        dim as MirValue nwv2
        if LowerNew_( c, id, nwv2 ) then return nwv2
        return v

    case Fbx.N_INDEX
        '' 'p[i]' reads through the computed element address. Check does not type an
        '' N_INDEX, so the load's type comes from the POINTEE when the caller has not
        '' asked for one -- without it the load carried MT_VOID, was refused by Emit
        '' and declined, which is how 'dim as integer v = p[1]' still emitted nothing
        '' after the address itself was lowering correctly.
        dim as MirType imt = mt
        if imt = MT_VOID then
            dim as Fbx.ListPayload ptr xp = _
                @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
            dim as Fbx.TypeId xt = c.info->TypeOf_( xp->target )
            if xt <> Fbx.TYPE_NONE then
                '' A STRING SUBSCRIPTED IS ITS CHARACTER -- one byte narrow, TWO wide,
                '' and UNSIGNED, because fbc writes '(int32)*(uint16*)(...)' and a sign
                '' extension would turn a character above 0x7FFF negative. Asked FIRST,
                '' because a 'zstring ptr' is a pointer too and its POINTEE is the
                '' unsized builtin, which lowers to no MIR type at all: the load then
                '' carried MT_VOID and Emit refused it.
                dim as long cesz = CharElemSize_( c, xt )
                if cesz = 1 then
                    imt = MT_I8
                elseif cesz = 2 then
                    imt = MT_I16
                elseif c.types->Kind( xt ) = Fbx.TK_POINTER then
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

    case Fbx.N_DEREF
        '' '*p' is a LOAD THROUGH the pointer. LowerAddr already knows the shape --
        '' the address is the pointer's VALUE -- so this is the load around it.
        dim as MirValue da = LowerAddr( c, id )
        if da.kind = cast( ubyte, MV_NONE ) then return v
        return LowerExprLoad( c, da, mt )

    case Fbx.N_UNARY
        dim as Fbx.UnaryPayload ptr up = _
            @c.ast->unaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        dim as MirValue x = LowerExpr( c, up->operand )
        if x.kind = cast( ubyte, MV_NONE ) then return v
        dim as MirInst ins
        ins.ty = cast( ubyte, mt )
        ins.a = x
        select case cast( Fbx.TokenKind, up->op )
        case Fbx.TK_MINUS : ins.op = cast( ushort, M_NEG )
        case Fbx.TK_PLUS  : return x
        case Fbx.KW_NOT   : ins.op = cast( ushort, M_NOT )
        case else         : return v
        end select
        return Emit( c, ins )

    case Fbx.N_BINARY
        dim as Fbx.BinaryPayload ptr bp = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        dim as Fbx.TokenKind tk = cast( Fbx.TokenKind, bp->op )

        '' ANDALSO and ORELSE must not evaluate the right side unless they have to,
        '' so they are control flow, not an opcode.
        if (tk = Fbx.KW_ANDALSO) orelse (tk = Fbx.KW_ORELSE) then
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
        if cmpStr then
            dim as MirValue sc = LowerStrCompare( c, bp, tk )
            if sc.kind <> cast( ubyte, MV_NONE ) then return sc
            return v
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
        '' operand it may evaluate twice. fbx always calls pow. Same value, different
        '' code, and no risk of evaluating a call twice.
        if tk = Fbx.TK_CARET then
            dim as MirValue pl = Coerce( c, l, MT_F64, IsUnsignedType( c, c.info->TypeOf_( bp->lhs ) ) )
            dim as MirValue pr = Coerce( c, r, MT_F64, IsUnsignedType( c, c.info->TypeOf_( bp->rhs ) ) )
            dim as FB.Array( of ulong ) pa
            pa.Push( cast( ulong, pl.kind ) ) : pa.Push( cast( ulong, pl.id ) )
            pa.Push( cast( ulong, pr.kind ) ) : pa.Push( cast( ulong, pr.id ) )
            return EmitRtl( c, RTL_POW, pa )
        end if
        '' The operand type decides signed versus unsigned, and it is the OPERANDS'
        '' type, not the result's: a comparison yields an integer either way.
        dim as Fbx.TypeId lt = c.info->TypeOf_( bp->lhs )
        dim as Fbx.TypeId rt = c.info->TypeOf_( bp->rhs )
        dim as MirType opTy = LowerType( lt, *c.types )
        '' Both operands are brought to the WIDER of the two; the frontend's measured
        '' promotion rules already decided what the result type is.
        if TyWidth( cast( MirType, r.ty ) ) > TyWidth( opTy ) then
            opTy = cast( MirType, r.ty )
        end if
        if IsFloatTy( cast( MirType, r.ty ) ) then opTy = cast( MirType, r.ty )
        l = Coerce( c, l, opTy, IsUnsignedType( c, lt ) )
        r = Coerce( c, r, opTy, IsUnsignedType( c, rt ) )
        dim as MirOp op = BinOpFor( tk, opTy, IsUnsignedType( c, lt ) )
        if op = M_NONE then return v
        dim as MirInst ins
        ins.op = cast( ushort, op )
        ins.ty = cast( ubyte, iif( mt = MT_VOID, opTy, mt ) )
        ins.a = l
        ins.b = r
        return Emit( c, ins )

    case Fbx.N_CALL
        '' A conversion intrinsic is a KEYWORD, so there is no callee to find and
        '' nothing to call: it lowers to the coercion its result type asks for.
        if IsConvIntrinsic( c, id ) then return LowerConvIntrinsic( c, id, mt )
        '' 'iif( c, a, b )' is a CONDITIONAL, not a call: only one arm may run.
        dim as MirValue iifv
        if LowerIif( c, id, mt, iifv ) then return iifv
        '' 'new T' allocates and constructs; it is not a call to anything named 'new'.
        dim as MirValue nwv
        if LowerNew_( c, id, nwv ) then return nwv
        '' 'procptr( f )' is a function's ADDRESS, not a call to it.
        dim as MirValue ppv
        if LowerProcPtr( c, id, ppv ) then return ppv
        '' 'len( x )' is a runtime call for a string and a constant for anything else.
        dim as MirValue lnv
        if LowerLen( c, id, lnv ) then return lnv
        '' int / fix / frac / abs / sgn / sqr and the transcendentals. A mix of gcc
        '' builtins, runtime calls and a plain floor -- see LowerMathCall_.
        dim as MirValue mtv
        if LowerMathCall_( c, id, mtv ) then return mtv
        '' 'asc', 'instr', 'instrrev' and the val family: string intrinsics whose
        '' RESULT IS A NUMBER, so they arrive here rather than through the descriptor
        '' path that hex and trim take.
        dim as MirValue snv
        if LowerStrNumCall_( c, id, snv ) then return snv
        '' 'lbound(a)' / 'ubound(a)' over a DYNAMIC array is a runtime call; over a
        '' fixed one both fold at compile time and never reach here.
        dim as MirValue abv
        if LowerArrayBoundCall( c, id, abv ) then return abv
        '' 'wstr( x )' widens a scalar or a narrow string into a wide temporary.
        dim as MirValue wcv
        if LowerWstrOf( c, id, wcv ) then return wcv
        '' Indexing and calling share a spelling; an array subscript is an address to
        '' load from, not a call to make.
        if IsArrayIndex( c, id ) then
            dim as MirValue addr = LowerArrayIndex( c, id )
            if addr.kind = cast( ubyte, MV_NONE ) then return v
            return LowerExprLoad( c, addr, LowerType( c.info->TypeOf_( id ), *c.types ) )
        end if
        return LowerCall( c, id, mt )
    end select

    return v
end function


private function LowerCall _
    ( byref c as Ctx, byval id as Fbx.NodeId, byval mt as MirType ) as MirValue

    dim as Fbx.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]

    '' The callee is recorded on the CALL node, and for a member call it is recorded
    '' on the MEMBER instead -- Check binds 'b.Push' when it types it, which is after
    '' Resolve has finished copying references onto call nodes. Falling back to the
    '' callee's own reference is what makes 'b.Push( 1 )' find its procedure.
    dim as Fbx.SymbolId callee = c.info->RefOf( id )
    if callee = Fbx.SYMBOL_NONE then callee = c.info->RefOf( cp->target )
    return LowerCallParts( c, cp->target, callee, cp->first, cp->count, mt )
end function

'' -------------------------------------------------------------- cleanup model

sub PushScope( byref c as Ctx )
    c.scopeMark.Push( c.cleanupNode.Count )
end sub

'' Emit one scope's actions, innermost registration LAST, without popping: an EXIT or
'' RETURN leaving several scopes needs to run them all and then keep going.
private sub EmitScopeCleanup( byref c as Ctx, byval depth as long )
    if (depth < 0) orelse (depth >= c.scopeMark.Count) then return
    dim as long from_ = c.scopeMark[depth]
    dim as long upto = c.cleanupNode.Count
    if depth + 1 < c.scopeMark.Count then upto = c.scopeMark[depth + 1]
    for i as long = upto - 1 to from_ step -1
        if c.cleanupSlot[i] < 0 then
            LowerStmt( c, cast( Fbx.NodeId, c.cleanupNode[i] ) )
        elseif c.cleanupNode[i] = CLEANUP_ERASE_ARRAY then
            '' A local DYNAMIC array is erased at scope exit whatever its element
            '' type -- measured; fbc emits fb_ArrayErase / fb_ArrayStrErase /
            '' fb_ArrayEraseObj for every one of them.
            ''
            '' The marker is an IMPOSSIBLE SymbolId rather than a small number.
            '' Cleanup entries are otherwise symbol ids, and 1 is a perfectly valid
            '' one -- using it as a sentinel would have destructed whatever symbol 1
            '' happened to be. That is the pool-confusion mistake this project has
            '' made seven times; not an eighth.
            EmitEraseDynLocal( c, c.cleanupSlot[i] )
        elseif c.cleanupNode[i] = 0 then
            '' A string local is released with fb_StrDelete. This is the
            '' DestroyLocal action the cleanup model was built for and has had
            '' nothing to register until now.
            dim as MirValue addr
            addr.kind = cast( ubyte, MV_LOCAL )
            addr.ty = cast( ubyte, MT_PTR )
            addr.id = c.cleanupSlot[i]
            dim as FB.Array( of ulong ) args
            args.Push( cast( ulong, addr.kind ) )
            args.Push( cast( ulong, addr.id ) )
            EmitRtl( c, RTL_STR_DELETE, args )
        else
            EmitDtorCall( c, cast( Fbx.SymbolId, c.cleanupNode[i] ), c.cleanupSlot[i] )
        end if
    next
end sub

'' Every action of every scope from the innermost out to 'outermost', in that order.
'' This is what a RETURN through three scopes needs, and rule 5 of docs/plan/08: a
'' GOTO out of N scopes runs N scopes' cleanups, innermost first.
sub EmitCleanupsTo( byref c as Ctx, byval outermost as long )
    for d as long = c.scopeMark.Count - 1 to outermost step -1
        EmitScopeCleanup( c, d )
    next
end sub

private sub PopScope( byref c as Ctx )
    if c.scopeMark.Count = 0 then return
    dim as long mark = c.scopeMark[c.scopeMark.Count - 1]
    c.scopeMark.Pop( )
    while c.cleanupNode.Count > mark
        c.cleanupNode.Pop( )
        c.cleanupSlot.Pop( )
    wend
end sub

'' A scope that ends by falling out of the bottom runs its own actions and nothing
'' else; the enclosing scopes have not ended.
sub CloseScope( byref c as Ctx )
    EmitScopeCleanup( c, c.scopeMark.Count - 1 )
    PopScope( c )
end sub


'' Pick the constructor overload for a set of argument types, using the same cost
'' model overload resolution uses -- the one fitted to 1,274 measured fbc choices.
'' Constructors chain like any other overload set precisely because they were given a
'' synthetic name, so nothing here is special-cased.
function PickCtor _
    ( byref c as Ctx, byval first_ as Fbx.SymbolId, _
      byref argT as FB.Array( of ulong ) ) as Fbx.SymbolId

    dim as Fbx.SymbolId best = Fbx.SYMBOL_NONE
    dim as long bestCost = Fbx.Check.CONV_NONE
    dim as long ties = 0
    dim as Fbx.SymbolId cur = first_

    while cur <> Fbx.SYMBOL_NONE
        dim as Fbx.Symbol ptr s = c.syms->SymbolAt( cur )
        if s = 0 then exit while
        dim as Fbx.NodeId pn = cast( Fbx.NodeId, s->payload )
        if (pn <> Fbx.NODE_NONE) andalso (c.ast->Kind( pn ) = Fbx.N_PROC) then
            dim as Fbx.StmtPayload ptr pp = StmtOf( c, pn )
            dim as long np = 0
            for i as long = 0 to pp->count - 1
                dim as Fbx.NodeId prm = cast( Fbx.NodeId, c.ast->children[pp->first + i] )
                if c.ast->Kind( prm ) = Fbx.N_PARAM then np += 1
            next
            if np = argT.Count then
                dim as long total = 0
                dim as long ai = 0
                dim as boolean viable = true
                for i as long = 0 to pp->count - 1
                    dim as Fbx.NodeId prm = cast( Fbx.NodeId, c.ast->children[pp->first + i] )
                    if c.ast->Kind( prm ) <> Fbx.N_PARAM then continue for
                    dim as Fbx.StmtPayload ptr sp2 = StmtOf( c, prm )
                    dim as long cost = Fbx.Check.ConversionCost( _
                        cast( Fbx.TypeId, argT[ai] ), c.info->TypeOf_( sp2->a ), *c.types )
                    ai += 1
                    if cost >= Fbx.Check.CONV_NONE then
                        viable = false
                        exit for
                    end if
                    total += cost
                next
                if viable then
                    if total < bestCost then
                        bestCost = total
                        best = cur
                        ties = 0
                    elseif total = bestCost then
                        ties += 1
                    end if
                end if
            end if
        end if
        cur = s->nextOverload
    wend

    '' A tie is an ambiguous call, not a silent pick.
    if ties > 0 then return Fbx.SYMBOL_NONE
    return best
end function


'' -------------------------------------------------------------- statements

sub LowerBlock( byref c as Ctx, byval id as Fbx.NodeId )
    if id = Fbx.NODE_NONE then return
    if c.ast->Kind( id ) <> Fbx.N_BLOCK then
        LowerStmt( c, id )
        return
    end if
    dim as Fbx.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    for i as long = 0 to lp->count - 1
        LowerStmt( c, cast( Fbx.NodeId, c.ast->children[lp->first + i] ) )
    next
end sub

private sub LowerAssign _
    ( byref c as Ctx, byval target as Fbx.NodeId, byval value as Fbx.NodeId )

    '' A string assignment is a runtime call, not a store. When it cannot be lowered
    '' -- 'a = b + a' needs a temporary -- it is SKIPPED, never allowed to fall
    '' through: an ordinary store would emit load/add/store over 24-byte descriptors,
    '' which is not a partial answer but a wrong one.
    '' A WIDE STRING is neither a store nor the narrow string runtime: 'wstring * N'
    '' is a bare uint16* with its own family of entry points, and which one depends on
    '' whether the SOURCE is wide or narrow.
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
    if (zdk = 1) orelse (zdk = 3) then
        dim as MirValue zdst = LowerAddr( c, target )
        if zdst.kind <> cast( ubyte, MV_NONE ) then
            if LowerZstrAssignTo( c, zdst, zdn, value, false ) then return
        end if
        SkipHere( c )
        return
    end if

    '' Same reason as the read: a full-width store into a bitfield's unit would
    '' overwrite every field packed beside it, so it is a read-modify-write.
    if LowerBitfieldStore( c, target, value ) then return

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


declare sub LowerStmtInner( byref c as Ctx, byval id as Fbx.NodeId )

sub LowerStmt( byref c as Ctx, byval id as Fbx.NodeId )
    if id = Fbx.NODE_NONE then return
    if c.curBlock < 0 then return
    '' Saved and restored: statements nest, and a decline belongs to the INNERMOST one.
    dim as ushort savedKind = c.curStmtKind
    c.curStmtKind = cast( ushort, c.ast->Kind( id ) )

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

    LowerStmtInner( c, id )

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
            EmitRtl( c, RTL_STR_DELETE, args )
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
end sub

private sub LowerStmtInner( byref c as Ctx, byval id as Fbx.NodeId )

    select case c.ast->Kind( id )
    case Fbx.N_BLOCK
        LowerBlock( c, id )

    case Fbx.N_SCOPE
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
        c.loopKind.Push( cast( long, Fbx.KW_SCOPE ) )
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

    case Fbx.N_DEFER
        '' Registered, not run. It fires at the end of the ENCLOSING scope, in
        '' reverse registration order -- which is the FBC-Modern behaviour to
        '' reproduce, not to improve on.
        c.cleanupNode.Push( cast( ulong, StmtOf( c, id )->b ) )
        c.cleanupSlot.Push( -1 )

    case Fbx.N_VAR
        dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
        if sp->op = cast( ushort, Fbx.KW_REDIM ) then
            if LowerRedim( c, id, sp ) = false then SkipHere( c )
            return
        end if
        '' 'dim byref rb as integer = a' ALIASES a. The slot would have to hold a
        '' pointer and every read and write go through it, which is not implemented --
        '' so this DECLINES rather than lowering the initializer as a copy.
        ''
        '' It matters that this landed with the parse fix and not after it. Parsing
        '' BYREF turned a statement that silently vanished into one that silently
        '' ALIASED NOTHING: measured, 'rb = 5' then 'print a' gives 5 under fbc and
        '' would have given 1 here. A decline is the honest answer until the
        '' indirection exists.
        if (c.ast->nodes[cast( long, id )].flags and Fbx.NF_BYREF) <> 0 then
            SkipHere( c )
            c.st->varByref += 1
            return
        end if
        for i as long = 0 to sp->count - 1
            dim as Fbx.NodeId item = cast( Fbx.NodeId, c.ast->children[sp->first + i] )
            if c.ast->Kind( item ) <> Fbx.N_VAR_ITEM then continue for
            dim as Fbx.StmtPayload ptr ip = StmtOf( c, item )
            '' The VARIABLE, not a type name that happens to share the spelling.
            dim as Fbx.SymbolId sid = _
                c.syms->LookupLocalTyped( c.info->ScopeOf( id ), ip->name, false )
            if sid = Fbx.SYMBOL_NONE then
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
                InitSharedGlobal( c, sid, ip->b )
                continue for
            end if

            dim as long slot = LocalFor( c, sid )

            '' A UDT local is CONSTRUCTED where it is declared and DESTROYED at the
            '' end of its scope. The destructor is registered into the same cleanup
            '' list the defers use, so the measured order -- reverse registration,
            '' interleaved with defers, innermost scope first on an early exit --
            '' applies to it without any extra arrangement.
            dim as Fbx.Symbol ptr vs = c.syms->SymbolAt( sid )
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
                end if
            end if

            if (slot >= 0) andalso (vs <> 0) then
                '' 'dim as T x = T( 5 )' selects a constructor by its arguments; a
                '' bare 'dim as T x' takes the no-argument one.
                constructed = LowerCtorInit( c, slot, vs->type_, ip->b )
                dim as Fbx.SymbolId ctor = Fbx.SYMBOL_NONE
                if constructed = false then
                    ctor = StructorWithArity( c, _
                        StructorOf( c, vs->type_, "__ctor" ), 0 )
                end if
                if ctor <> Fbx.SYMBOL_NONE then EmitStructorCall( c, ctor, slot )
                dim as Fbx.SymbolId dtor = StructorWithArity( c, _
                    StructorOf( c, vs->type_, "__dtor" ), 0 )
                if dtor <> Fbx.SYMBOL_NONE then
                    c.cleanupNode.Push( cast( ulong, dtor ) )
                    c.cleanupSlot.Push( slot )
                end if
                if IsStringType( c, vs->type_ ) then
                    '' Order matters: the descriptor is made valid BEFORE its release
                    '' is registered, so no path can reach the fb_StrDelete with a
                    '' descriptor that was never written.
                    LowerStringInit( c, slot, item, ip->b )
                    strInited = true
                    c.cleanupNode.Push( 0 )
                    c.cleanupSlot.Push( slot )
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
            if ip->b = Fbx.NODE_NONE then needsStore = false
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
                if (zk2 = 1) orelse (zk2 = 3) then
                    dim as MirValue zdst
                    zdst.kind = cast( ubyte, MV_LOCAL )
                    zdst.ty = cast( ubyte, MT_PTR )
                    zdst.id = slot
                    if LowerZstrAssignTo( c, zdst, zn2, ip->b, true ) then needsStore = false
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

    case Fbx.N_AMBIGUOUS
        dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
        select case c.info->AmbiguousOf( id )
        case Fbx.AMB_RESULT
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
        case Fbx.AMB_ASSIGN
            dim as long beforeA = c.f->blocks[c.curBlock].insts.Count
            dim as Fbx.TokenKind aop = cast( Fbx.TokenKind, sp->op )
            dim as boolean plain = (aop = Fbx.TK_EQ) orelse (aop = Fbx.TK_AMPEQ)
            '' '&=' is string concatenation and already has its own path through
            '' LowerAssign; everything else with an operator is a read-modify-write.
            if plain then
                LowerAssign( c, sp->a, sp->b )
            elseif LowerCompoundAssign( c, sp->a, sp->b, aop ) = false then
                SkipHere( c )
            end if
            if c.f->blocks[c.curBlock].insts.Count = beforeA then
                c.st->ambAssign += 1
            end if
        case Fbx.AMB_CALL
            '' A CALL STATEMENT THAT PRODUCES NOTHING IS A DECLINE, and has to be counted
            '' as one. LowerCall returns MV_NONE for an unresolved callee without
            '' recording anything, so when the classification changed from error to call
            '' these statements stopped being counted while still emitting no code --
            '' the count fell by 78,000 and the work was not being done.
            ''
            '' A call whose result is void legitimately yields MV_NONE too, so the test
            '' is whether the statement emitted ANY instruction, not what it returned.
            dim as long beforeN = c.f->blocks[c.curBlock].insts.Count
            '' 'W( 1, 2 )' is an expression; 'W 1, 2' is this statement's own callee
            '' and children, and looks nothing like a call node.
            if c.ast->Kind( sp->a ) = Fbx.N_CALL then
                LowerExpr( c, sp->a )
            else
                LowerStmtCall( c, id )
            end if

            '' ASSERT AND ASSERTWARN EMIT NOTHING ON PURPOSE. Measured: without -g,
            '' fbc evaluates neither the condition nor anything else, and its C
            '' contains no trace of the statement. Emitting nothing is the WHOLE
            '' lowering, so the emitted-nothing test below has to know that -- and it
            '' is the only construct in the language for which that is true.
            dim as boolean deliberateNoOp = false
            if c.ast->Kind( sp->a ) = Fbx.N_CALL then
                dim as Fbx.ListPayload ptr np = _
                    @c.ast->lists[cast( long, c.ast->nodes[cast( long, sp->a )].data )]
                if np->target <> Fbx.NODE_NONE then
                    if c.ast->Kind( np->target ) = Fbx.N_IDENT then
                        dim as Fbx.IdentPayload ptr nip = _
                            @c.ast->idents[cast( long, _
                                c.ast->nodes[cast( long, np->target )].data )]
                        select case Fbx.Text.LowerAscii( c.names->Spelling( nip->name ) )
                        case "assert", "assertwarn"
                            deliberateNoOp = true
                        end select
                    end if
                end if
            end if

            if deliberateNoOp then
                '' nothing to emit, and nothing to count
            elseif c.f->blocks[c.curBlock].insts.Count = beforeN then
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

    case Fbx.N_IF
        dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
        LowerIf( c, id, sp )

    case Fbx.N_WHILE
        dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
        dim as long headB = NewBlock( c, "while.head" )
        dim as long bodyB = NewBlock( c, "while.body" )
        dim as long exitB = NewBlock( c, "while.exit" )
        Terminate( c, MTERM_BR, headB, -1, NoVal( ) )
        c.curBlock = headB
        dim as MirValue cond = LowerExpr( c, sp->a )
        Terminate( c, MTERM_CONDBR, bodyB, exitB, cond )
        c.curBlock = bodyB
        c.breakTo.Push( exitB )
        c.contTo.Push( headB )
        c.loopScope.Push( c.scopeMark.Count )
        c.loopKind.Push( cast( long, Fbx.KW_WHILE ) )
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

    case Fbx.N_DO
        LowerDo( c, id )

    case Fbx.N_FOR
        LowerFor( c, id )

    case Fbx.N_INTRINSIC
        dim as Fbx.StmtPayload ptr ip = StmtOf( c, id )
        dim as boolean handled = false
        if ip->op = cast( ushort, Fbx.KW_PRINT ) then handled = LowerPrint( c, id )
        if ip->op = cast( ushort, Fbx.KW_SWAP ) then handled = LowerSwap( c, id )
        if ip->op = cast( ushort, Fbx.KW_CLOSE ) then handled = LowerClose( c, id )
        if ip->op = cast( ushort, Fbx.KW_ERROR ) then handled = LowerError( c, id )
        if ip->op = cast( ushort, Fbx.KW_ERASE ) then handled = LowerErase( c, id )
        if ip->op = cast( ushort, Fbx.KW_WRITE ) then handled = LowerWrite( c, id )
        if ip->op = cast( ushort, Fbx.KW_POKE ) then handled = LowerPoke( c, id )
        if ip->op = cast( ushort, Fbx.KW_LSET ) then handled = LowerLrset( c, id, false )
        if ip->op = cast( ushort, Fbx.KW_RSET ) then handled = LowerLrset( c, id, true )
        if ip->op = cast( ushort, Fbx.KW_READ ) then handled = LowerRead( c, id )
        if ip->op = cast( ushort, Fbx.KW_RESTORE ) then handled = LowerRestore( c, id )
        '' A DATA statement emits no code: its descriptor array was built by the
        '' pre-pass, before anything else was lowered.
        if ip->op = cast( ushort, Fbx.KW_DATA ) then handled = (c.dataHead >= 0)
        '' LINE is two unrelated statements sharing a keyword: bit 1 of 'extra' is
        '' LINE INPUT, bit 2 the graphics form, which needs libfbgfx and declines.
        if ip->op = cast( ushort, Fbx.KW_LINE ) then
            if (ip->extra and 1) <> 0 then
                handled = LowerLineInput( c, id )
                if handled = false then handled = LowerInput( c, id, true )
            end if
        end if
        if ip->op = cast( ushort, Fbx.KW_INPUT ) then handled = LowerInput( c, id, false )
        if handled = false then SkipStmt( c, id )

    case Fbx.N_FOREACH
        if LowerForEachArray( c, id ) = false then SkipStmt( c, id )

    case Fbx.N_DELETE_STMT
        if LowerDelete( c, id ) = false then SkipStmt( c, id )

    case Fbx.N_WITH
        '' 'with expr' declares nothing and emits nothing of its own -- it is a NAMING
        '' construct. Resolve has already pointed every '.field' inside it at the
        '' subject's own node, so the body lowers as ordinary statements and the member
        '' accesses find their base the usual way.
        ''
        '' A subject Resolve would not accept -- anything but an lvalue, because the
        '' base is SHARED rather than evaluated into a temporary -- leaves its members
        '' baseless, and they decline inside the body instead of here.
        LowerBlock( c, StmtOf( c, id )->b )

    case Fbx.N_END_STMT
        LowerEndStmt( c, id )

    case Fbx.N_SELECT
        LowerSelect( c, id )

    case Fbx.N_LABEL
        LowerLabel( c, id )

    case Fbx.N_GOTO
        LowerGoto( c, id )

    case Fbx.N_RETURN
        dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
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
            if sp->a <> Fbx.NODE_NONE then
                '' THE VALUE FIRST, the address only as a fallback. 'return F( )'
                '' and 'return Vec3d_( x, y, z )' have no address to take -- a call
                '' result is a value -- and requiring one declined 10,387 statements,
                '' which is most of what a UDT-returning function actually returns.
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
            if sp->a <> Fbx.NODE_NONE then
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
        if sp->a <> Fbx.NODE_NONE then
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

    case Fbx.N_EXIT
        LowerExitLike( c, id, true )

    case Fbx.N_CONTINUE
        LowerExitLike( c, id, false )

    case Fbx.N_PROC, Fbx.N_TYPE, Fbx.N_ENUM, Fbx.N_TYPEDEF, Fbx.N_NAMESPACE, _
         Fbx.N_CONST, Fbx.N_FIELD, Fbx.N_PARAM, Fbx.N_EXTERN_BLOCK, _
         Fbx.N_USING, Fbx.N_ASSERT
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

private sub LowerIf _
    ( byref c as Ctx, byval id as Fbx.NodeId, byval sp as Fbx.StmtPayload ptr )

    '' The branches hang off a list of N_IF_BRANCH, each with its own condition; the
    '' ELSE body is 'c'.
    dim as Fbx.NodeId branches = sp->b
    if branches = Fbx.NODE_NONE then
        SkipHere( c )
        return
    end if
    dim as Fbx.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, branches )].data )]

    dim as long joinB = NewBlock( c, "if.join" )
    for i as long = 0 to lp->count - 1
        dim as Fbx.NodeId br = cast( Fbx.NodeId, c.ast->children[lp->first + i] )
        if c.ast->Kind( br ) <> Fbx.N_IF_BRANCH then continue for
        dim as Fbx.StmtPayload ptr bp = StmtOf( c, br )
        dim as long thenB = NewBlock( c, "if.then" )
        dim as long elseB = NewBlock( c, "if.else" )
        '' A CONDITION THAT WOULD NOT LOWER IS A DECLINE. It used to go out as
        '' 'condbr _, then, else' -- a conditional branch with NO CONDITION -- which
        '' the verifier passes and a backend cannot mean anything by. The IF counted as
        '' fully lowered while its test had vanished, which is the worst of the three
        '' outcomes and is how 'if a + b = c' looked for as long as a concatenation
        '' could not be compared.
        ''
        '' The branch still goes out, to the THEN side: an unconditional entry is no
        '' more wrong than a missing condition and keeps the block graph well formed,
        '' and the decline beside it is what says the test is missing.
        dim as MirValue cond = LowerExpr( c, bp->a )
        if cond.kind = cast( ubyte, MV_NONE ) then
            SkipHere( c )
            Terminate( c, MTERM_BR, thenB, -1, NoVal( ) )
        else
            Terminate( c, MTERM_CONDBR, thenB, elseB, cond )
        end if
        c.curBlock = thenB
        LowerBlock( c, bp->b )
        Terminate( c, MTERM_BR, joinB, -1, NoVal( ) )
        c.curBlock = elseB
    next

    if sp->c <> Fbx.NODE_NONE then LowerBlock( c, sp->c )
    Terminate( c, MTERM_BR, joinB, -1, NoVal( ) )
    c.curBlock = joinB
end sub


'' The result variable's value, or nothing when the procedure has no slot -- a SUB, or
'' a result type the slot does not cover. Callers pass it straight to Terminate, which
'' treats MV_NONE as 'return no value'.
function LoadResult( byref c as Ctx ) as MirValue
    if c.resultSlot < 0 then return NoVal( )
    dim as MirValue addr
    addr.kind = cast( ubyte, MV_LOCAL )
    addr.ty = cast( ubyte, MT_PTR )
    addr.id = c.resultSlot
    return LowerExprLoad( c, addr, cast( MirType, c.resultTy ) )
end function

function LowerExprLoad _
    ( byref c as Ctx, byref addr as MirValue, byval t as MirType ) as MirValue
    dim as MirInst ins
    ins.op = cast( ushort, M_LOAD )
    ins.ty = cast( ubyte, t )
    ins.a = addr
    return Emit( c, ins )
end function


end namespace
