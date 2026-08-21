'' lower.bas -- AST to MIR. See lower.bi for what this slice does and does not cover.

#include once "mir/lower.bi"
#include once "mir/lowerctx.bi"

namespace Fbx.Mir

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
declare sub LowerDo( byref c as Ctx, byval id as Fbx.NodeId )
declare sub LowerFor( byref c as Ctx, byval id as Fbx.NodeId )

function BinOpFor _
    ( byval tk as Fbx.TokenKind, byval t as MirType, _
      byval isUnsigned as boolean ) as MirOp

    dim as boolean f = IsFloatTy( t )
    select case tk
    case Fbx.TK_PLUS      : return M_ADD
    case Fbx.TK_MINUS     : return M_SUB
    case Fbx.TK_STAR      : return M_MUL
    case Fbx.TK_SLASH     : return M_FDIV
    case Fbx.TK_BACKSLASH : return iif( isUnsigned, M_UDIV, M_SDIV )
    case Fbx.KW_MOD       : return iif( isUnsigned, M_UREM, M_SREM )
    case Fbx.KW_AND       : return M_AND
    case Fbx.KW_OR        : return M_OR
    case Fbx.KW_XOR       : return M_XOR
    case Fbx.KW_SHL       : return M_SHL
    '' SHR is ARITHMETIC on a signed value -- '-1 shr 1' is -1, measured in
    '' docs/internals/phase-5-const.md -- so it is ashr unless the type is unsigned.
    case Fbx.KW_SHR       : return iif( isUnsigned, M_LSHR, M_ASHR )
    case Fbx.TK_EQ        : return iif( f, M_FCMP_EQ, M_ICMP_EQ )
    case Fbx.TK_NE        : return iif( f, M_FCMP_NE, M_ICMP_NE )
    case Fbx.TK_LT        : return iif( f, M_FCMP_LT, iif( isUnsigned, M_ICMP_ULT, M_ICMP_SLT ) )
    case Fbx.TK_GT        : return iif( f, M_FCMP_GT, iif( isUnsigned, M_ICMP_UGT, M_ICMP_SGT ) )
    case Fbx.TK_LE        : return iif( f, M_FCMP_LE, M_ICMP_SLE )
    case Fbx.TK_GE        : return iif( f, M_FCMP_GE, M_ICMP_SGE )
    end select
    return M_NONE
end function

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
                if c.types->Kind( xt ) = Fbx.TK_POINTER then
                    imt = LowerType( c.types->Inner( xt ), *c.types )
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
        if IsStringType( c, c.info->TypeOf_( bp->lhs ) ) then
            dim as MirValue sc = LowerStrCompare( c, bp, tk )
            if sc.kind <> cast( ubyte, MV_NONE ) then return sc
            return v
        end if

        dim as MirValue l = LowerExpr( c, bp->lhs )
        dim as MirValue r = LowerExpr( c, bp->rhs )
        if (l.kind = cast( ubyte, MV_NONE )) orelse (r.kind = cast( ubyte, MV_NONE )) then
            return v
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
        '' 'procptr( f )' is a function's ADDRESS, not a call to it.
        dim as MirValue ppv
        if LowerProcPtr( c, id, ppv ) then return ppv
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

function LowerCallParts _
    ( byref c as Ctx, byval calleeNode as Fbx.NodeId, byval callee as Fbx.SymbolId, _
      byval argFirst as long, byval argCount as long, _
      byval mt as MirType ) as MirValue

    dim as MirValue v

    '' A BUILT-IN PROCEDURE binds to nothing because nothing declares it -- fbc
    '' predeclares 'allocate', 'deallocate', the mutex four and 'fb_Assert' and lowers
    '' each straight to a runtime call. Checked BEFORE the symbol, which is exactly
    '' what these do not have.
    dim as MirValue bv
    if LowerBuiltinProc( c, calleeNode, argFirst, argCount, bv ) then return bv

    dim as Fbx.Symbol ptr cs = c.syms->SymbolAt( callee )
    if callee = Fbx.SYMBOL_NONE then return v
    if cs = 0 then return v

    '' A CALL THROUGH A PROCEDURE POINTER. 'dim as sub( ) p = procptr( f ) : p( )'
    '' names a VARIABLE, not a procedure, so there is no function to look up and
    '' mangling its name would invent one. docs/plan/09 lists 'call_indirect' for
    '' exactly this; the callee is the pointer's VALUE.
    dim as boolean viaPointer = false
    if cs->kind <> cast( ubyte, Fbx.SYM_PROC ) then
        dim as Fbx.TypeId ct = cs->type_
        if ct <> Fbx.TYPE_NONE then
            if c.types->Kind( ct ) = Fbx.TK_REFERENCE then ct = c.types->Inner( ct )
            if c.types->Kind( ct ) = Fbx.TK_POINTER then ct = c.types->Inner( ct )
            viaPointer = (c.types->Kind( ct ) = Fbx.TK_PROC)
        end if
        '' Anything else that is not a procedure is not callable, and was already
        '' declining here.
        if viaPointer = false then return v
    end if

    '' Arguments are collected LOCALLY and pushed to the shared pool in one run at the
    '' end. Lowering them straight into the pool interleaved a nested call's arguments
    '' with this one's, because the callee's extent was opened before its arguments were
    '' lowered: 'F( G( 7 ), 9 )' emitted 'call void F(%4, %5)' -- F( 7, G(7) ) -- and
    '' dropped the 9 entirely. No decline, no diagnostic, wrong arguments.
    dim as FB.Array( of ulong ) argv

    '' THE RECEIVER IS THE FIRST ARGUMENT of an instance method, and it was missing.
    '' fbc declares 'void _ZN1T1MEi( struct $1T*, int32 )'; fbx emitted
    '' 'call void _ZN1T1MEi(%5)' -- the right name, the wrong arguments, and no decline,
    '' so it counted as fully lowered. A mangled name that says member and a call that
    '' does not pass one is the worst shape a bug can have here.
    dim as MirValue self_ = ReceiverOf( c, calleeNode, callee )
    if self_.kind <> cast( ubyte, MV_NONE ) then
        argv.Push( cast( ulong, self_.kind ) )
        argv.Push( cast( ulong, self_.id ) )
    end if

    for i as long = 0 to argCount - 1
        dim as Fbx.NodeId argNode = cast( Fbx.NodeId, c.ast->children[argFirst + i] )
        dim as boolean wantsRef = ParamIsByref( c, callee, i )

        dim as MirValue a
        if wantsRef then
            a = LowerAddr( c, argNode )
            '' An argument with no address -- a literal or a computed value -- cannot
            '' be passed by reference as it stands. fbc materialises a temporary for
            '' one; fbx declines rather than passing something that is not the
            '' variable the callee will write through.
            if a.kind = cast( ubyte, MV_NONE ) then a = LowerExpr( c, argNode )
        else
            a = LowerExpr( c, argNode )
        end if
        argv.Push( cast( ulong, a.kind ) )
        argv.Push( cast( ulong, a.id ) )
    next

    dim as long first = c.m->argPool.Count \ 2
    dim as long n = argv.Count \ 2
    for i as long = 0 to argv.Count - 1
        c.m->argPool.Push( argv[i] )
    next

    '' The callee is named by its MANGLED name, which is what MIR carries.
    ''
    '' It must be mangled the SAME WAY the definition was. Symbol.name is the FOLDED
    '' spelling -- lowercased, because FreeBASIC lookup is case-insensitive -- so using
    '' it here produced 'call void a()' against a definition named 'A', which matched
    '' nothing and silently added an extern declaration instead. The result was a
    '' module that referenced a symbol it also defined, under two spellings.
    dim as Fbx.InternId cnm = cs->name
    if cs->payload <> 0 then
        cnm = c.names->GetString( Fbx.Mangle.ProcName( _
            *c.ast, cast( Fbx.NodeId, cs->payload ), *c.syms, *c.names, _
            *c.types, *c.info ) )
    end if

    '' THE INDIRECT CALL. The callee is the pointer's VALUE, loaded from wherever the
    '' variable lives; there is no function table entry and no name.
    if viaPointer then
        dim as MirValue fp = LowerExpr( c, calleeNode )
        if fp.kind = cast( ubyte, MV_NONE ) then return v
        dim as MirInst ic
        ic.op = cast( ushort, M_CALL_IND )
        ic.ty = cast( ubyte, mt )
        ic.a = Coerce( c, fp, MT_PTR )
        ic.first = first
        ic.count = n
        return Emit( c, ic )
    end if

    '' Finding the function object is a linear scan for now; it is a map when it
    '' matters.
    dim as long fidx = -1
    for i as long = 0 to c.m->functions.Count - 1
        if c.m->functions[i]->name = cnm then
            fidx = i
            exit for
        end if
    next
    if fidx < 0 then
        dim as MirFunction ptr decl = c.m->AddFunction( cnm, mt )
        decl->isDefinition = false
        fidx = c.m->functions.Count - 1
    end if

    dim as MirInst ins
    ins.op = cast( ushort, M_CALL )
    ins.ty = cast( ubyte, mt )
    ins.first = first
    ins.count = n
    ins.callee = fidx
    return Emit( c, ins )
end function


private function LowerCall _
    ( byref c as Ctx, byval id as Fbx.NodeId, byval mt as MirType ) as MirValue

    dim as Fbx.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    return LowerCallParts( c, cp->target, c.info->RefOf( id ), _
                           cp->first, cp->count, mt )
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
private function PickCtor _
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

'' 'dim as T x = T( 5 )'. The initialiser parses as a CALL on the type's name, so it
'' is recognised by the callee naming the variable's own UDT rather than by any
'' special syntax. Returns false when this is not a constructor call.
private function LowerCtorInit _
    ( byref c as Ctx, byval slot as long, byval t as Fbx.TypeId, _
      byval init_ as Fbx.NodeId ) as boolean

    if init_ = Fbx.NODE_NONE then return false
    if c.ast->Kind( init_ ) <> Fbx.N_CALL then return false
    if c.types->Kind( t ) <> Fbx.TK_UDT then return false

    dim as Fbx.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, init_ )].data )]
    if cp->target = Fbx.NODE_NONE then return false
    if c.ast->Kind( cp->target ) <> Fbx.N_IDENT then return false
    dim as Fbx.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, cp->target )].data )]
    if ip->name <> c.types->NameOf( t ) then return false

    dim as Fbx.SymbolId ctors = StructorOf( c, t, "__ctor" )
    if ctors = Fbx.SYMBOL_NONE then return false

    '' Argument VALUES first, then the pick: the types are needed to choose, and the
    '' values must be evaluated in source order regardless of which overload wins.
    dim as FB.Array( of ulong ) argT
    dim as FB.Array( of ulong ) argKind
    dim as FB.Array( of ulong ) argId
    for i as long = 0 to cp->count - 1
        dim as Fbx.NodeId a = cast( Fbx.NodeId, c.ast->children[cp->first + i] )
        dim as MirValue av = LowerExpr( c, a )
        argT.Push( cast( ulong, c.info->TypeOf_( a ) ) )
        argKind.Push( cast( ulong, av.kind ) )
        argId.Push( cast( ulong, av.id ) )
    next

    dim as Fbx.SymbolId pick = PickCtor( c, ctors, argT )
    if pick = Fbx.SYMBOL_NONE then return false
    dim as Fbx.Symbol ptr ps = c.syms->SymbolAt( pick )
    if ps = 0 then return false
    dim as Fbx.NodeId pn = cast( Fbx.NodeId, ps->payload )
    if pn = Fbx.NODE_NONE then return false

    '' Arguments are coerced to the chosen overload's PARAMETER types: MIR has no
    '' implicit conversions, and the overload was selected knowing a conversion would
    '' be needed, so it has to be written down.
    dim as Fbx.StmtPayload ptr cpp = StmtOf( c, pn )
    dim as long ai2 = 0
    for i as long = 0 to cpp->count - 1
        dim as Fbx.NodeId prm = cast( Fbx.NodeId, c.ast->children[cpp->first + i] )
        if c.ast->Kind( prm ) <> Fbx.N_PARAM then continue for
        if ai2 >= argT.Count then exit for
        dim as MirValue av
        av.kind = cast( ubyte, argKind[ai2] )
        av.ty = cast( ubyte, LowerType( cast( Fbx.TypeId, argT[ai2] ), *c.types ) )
        av.id = argId[ai2]
        dim as Fbx.StmtPayload ptr sp3 = StmtOf( c, prm )
        dim as MirValue cv = Coerce( c, av, _
            LowerType( c.info->TypeOf_( sp3->a ), *c.types ) )
        argKind[ai2] = cv.kind
        argId[ai2] = cv.id
        ai2 += 1
    next

    dim as long first = c.m->argPool.Count \ 2
    c.m->argPool.Push( cast( ulong, MV_LOCAL ) )
    c.m->argPool.Push( cast( ulong, slot ) )
    for i as long = 0 to argT.Count - 1
        c.m->argPool.Push( argKind[i] )
        c.m->argPool.Push( argId[i] )
    next

    dim as Fbx.InternId nm = c.names->GetString( _
        Fbx.Mangle.ProcName( *c.ast, pn, *c.syms, *c.names, *c.types, *c.info ) )
    dim as long fidx = -1
    for i as long = 0 to c.m->functions.Count - 1
        if c.m->functions[i]->name = nm then
            fidx = i
            exit for
        end if
    next
    if fidx < 0 then
        dim as MirFunction ptr decl = c.m->AddFunction( nm, MT_VOID )
        decl->isDefinition = false
        decl->paramCount = argT.Count + 1
        fidx = c.m->functions.Count - 1
    end if

    dim as MirInst ins
    ins.op = cast( ushort, M_CALL )
    ins.ty = cast( ubyte, MT_VOID )
    ins.first = first
    ins.count = argT.Count + 1
    ins.callee = fidx
    Emit( c, ins )
    return true
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
    if IsStringType( c, c.info->TypeOf_( target ) ) then
        if LowerStringAssign( c, target, value ) = false then c.st->skipped += 1
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
    LowerStmtInner( c, id )
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
        PushScope( c )
        LowerBlock( c, StmtOf( c, id )->b )
        CloseScope( c )

    case Fbx.N_DEFER
        '' Registered, not run. It fires at the end of the ENCLOSING scope, in
        '' reverse registration order -- which is the FBC-Modern behaviour to
        '' reproduce, not to improve on.
        c.cleanupNode.Push( cast( ulong, StmtOf( c, id )->b ) )
        c.cleanupSlot.Push( -1 )

    case Fbx.N_VAR
        dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
        if sp->op = cast( ushort, Fbx.KW_REDIM ) then
            SkipHere( c )
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
            if c.resultSlot < 0 then
                '' A result type with no slot: STRING and UDT returns go through a
                '' hidden pointer fbx does not model. Declining is the honest answer;
                '' storing into an invented slot would compile and be wrong.
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
        '' A loop BODY is a scope: its locals and defers run on every iteration
        '' (docs/plan/08 rule 4), which the measurement confirms.
        PushScope( c )
        LowerBlock( c, sp->b )
        CloseScope( c )
        c.loopScope.Pop( )
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
        '' LINE is two unrelated statements sharing a keyword: bit 1 of 'extra' is
        '' LINE INPUT, bit 2 the graphics form, which needs libfbgfx and declines.
        if ip->op = cast( ushort, Fbx.KW_LINE ) then
            if (ip->extra and 1) <> 0 then handled = LowerLineInput( c, id )
        end if
        if handled = false then SkipStmt( c, id )

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
        dim as MirValue rv
        if sp->a <> Fbx.NODE_NONE then
            rv = LowerExpr( c, sp->a )
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
        if c.breakTo.Count > 0 then
            EmitCleanupsTo( c, c.loopScope[c.loopScope.Count - 1] )
            Terminate( c, MTERM_BR, c.breakTo[c.breakTo.Count - 1], -1, NoVal( ) )
            c.curBlock = -1
        else
            SkipHere( c )
        end if

    case Fbx.N_CONTINUE
        if c.contTo.Count > 0 then
            EmitCleanupsTo( c, c.loopScope[c.loopScope.Count - 1] )
            Terminate( c, MTERM_BR, c.contTo[c.contTo.Count - 1], -1, NoVal( ) )
            c.curBlock = -1
        else
            SkipHere( c )
        end if

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
        dim as MirValue cond = LowerExpr( c, bp->a )
        Terminate( c, MTERM_CONDBR, thenB, elseB, cond )
        c.curBlock = thenB
        LowerBlock( c, bp->b )
        Terminate( c, MTERM_BR, joinB, -1, NoVal( ) )
        c.curBlock = elseB
    next

    if sp->c <> Fbx.NODE_NONE then LowerBlock( c, sp->c )
    Terminate( c, MTERM_BR, joinB, -1, NoVal( ) )
    c.curBlock = joinB
end sub

private sub LowerDo( byref c as Ctx, byval id as Fbx.NodeId )
    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
    dim as ushort flags = c.ast->nodes[cast( long, id )].flags
    dim as boolean postCond = ((flags and Fbx.NF_POST_COND) <> 0)
    dim as boolean isUntil = ((flags and Fbx.NF_UNTIL) <> 0)

    dim as long headB = NewBlock( c, "do.head" )
    dim as long bodyB = NewBlock( c, "do.body" )
    dim as long exitB = NewBlock( c, "do.exit" )
    Terminate( c, MTERM_BR, iif( postCond, bodyB, headB ), -1, NoVal( ) )

    c.curBlock = headB
    if sp->a <> Fbx.NODE_NONE then
        dim as MirValue cond = LowerExpr( c, sp->a )
        '' UNTIL is the same test with the arms swapped, which is cheaper than
        '' emitting a negation and is exactly what fbc's own lowering does.
        if isUntil then
            Terminate( c, MTERM_CONDBR, exitB, bodyB, cond )
        else
            Terminate( c, MTERM_CONDBR, bodyB, exitB, cond )
        end if
    else
        Terminate( c, MTERM_BR, bodyB, -1, NoVal( ) )
    end if

    c.curBlock = bodyB
    c.breakTo.Push( exitB )
    c.contTo.Push( headB )
    c.loopScope.Push( c.scopeMark.Count )
    PushScope( c )
    LowerBlock( c, sp->b )
    CloseScope( c )
    c.loopScope.Pop( )
    c.breakTo.Pop( )
    c.contTo.Pop( )
    Terminate( c, MTERM_BR, headB, -1, NoVal( ) )
    c.curBlock = exitB
end sub

private sub LowerFor( byref c as Ctx, byval id as Fbx.NodeId )
    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
    '' children are [from, to, step]; any may be absent.
    dim as Fbx.NodeId fromE = Fbx.NODE_NONE
    dim as Fbx.NodeId toE = Fbx.NODE_NONE
    dim as Fbx.NodeId stepE = Fbx.NODE_NONE
    if sp->count >= 1 then fromE = cast( Fbx.NodeId, c.ast->children[sp->first] )
    if sp->count >= 2 then toE = cast( Fbx.NodeId, c.ast->children[sp->first + 1] )
    if sp->count >= 3 then stepE = cast( Fbx.NodeId, c.ast->children[sp->first + 2] )

    dim as MirValue addr = LowerAddr( c, sp->a )
    if addr.kind = cast( ubyte, MV_NONE ) then
        SkipHere( c )
        return
    end if
    dim as MirType ity = cast( MirType, c.f->locals[cast( long, addr.id )].ty )

    '' init
    dim as MirValue init_ = Coerce( c, LowerExpr( c, fromE ), ity, _
                                    IsUnsignedType( c, c.info->TypeOf_( fromE ) ) )
    if init_.kind <> cast( ubyte, MV_NONE ) then
        dim as MirInst st0
        st0.op = cast( ushort, M_STORE )
        st0.ty = cast( ubyte, MT_VOID )
        st0.a = addr
        st0.b = init_
        Emit( c, st0 )
    end if

    dim as long headB = NewBlock( c, "for.head" )
    dim as long bodyB = NewBlock( c, "for.body" )
    dim as long stepB = NewBlock( c, "for.step" )
    dim as long exitB = NewBlock( c, "for.exit" )
    Terminate( c, MTERM_BR, headB, -1, NoVal( ) )

    '' guard: counter <= limit. A NEGATIVE step needs the opposite test, and when the
    '' step is not a compile-time constant fbc emits a runtime sign test. This slice
    '' handles the constant case and records the other as unlowered rather than
    '' emitting a loop that runs the wrong number of times.
    c.curBlock = headB
    dim as MirValue cur = LowerExprLoad( c, addr, ity )
    dim as MirValue lim = Coerce( c, LowerExpr( c, toE ), ity, _
                                  IsUnsignedType( c, c.info->TypeOf_( toE ) ) )
    dim as boolean negStep = false
    if stepE <> Fbx.NODE_NONE then
        dim as Fbx.Check.ConstVal sv = Fbx.Check.ConstOf( *c.ast, stepE, *c.srcMgr, *c.names, _
                                   c.types->target.pointerBits )
        if sv.known then
            negStep = (sv.value < 0)
        else
            SkipHere( c )
        end if
    end if
    dim as MirInst cmp
    cmp.op = cast( ushort, iif( IsFloatTy( ity ), _
                                iif( negStep, M_FCMP_GE, M_FCMP_LE ), _
                                iif( negStep, M_ICMP_SGE, M_ICMP_SLE ) ) )
    cmp.ty = cast( ubyte, MT_I8 )
    cmp.a = cur
    cmp.b = lim
    dim as MirValue cond = Emit( c, cmp )
    Terminate( c, MTERM_CONDBR, bodyB, exitB, cond )

    c.curBlock = bodyB
    c.breakTo.Push( exitB )
    c.contTo.Push( stepB )
    c.loopScope.Push( c.scopeMark.Count )
    PushScope( c )
    LowerBlock( c, sp->b )
    CloseScope( c )
    c.loopScope.Pop( )
    c.breakTo.Pop( )
    c.contTo.Pop( )
    Terminate( c, MTERM_BR, stepB, -1, NoVal( ) )

    c.curBlock = stepB
    dim as MirValue cur2 = LowerExprLoad( c, addr, ity )
    dim as MirValue inc
    if stepE <> Fbx.NODE_NONE then
        inc = Coerce( c, LowerExpr( c, stepE ), ity, _
                      IsUnsignedType( c, c.info->TypeOf_( stepE ) ) )
    else
        inc = ConstInt( c, 1, ity )
    end if
    dim as MirInst add_
    add_.op = cast( ushort, M_ADD )
    add_.ty = cast( ubyte, ity )
    add_.a = cur2
    add_.b = inc
    dim as MirValue nxt = Emit( c, add_ )
    dim as MirInst st1
    st1.op = cast( ushort, M_STORE )
    st1.ty = cast( ubyte, MT_VOID )
    st1.a = addr
    st1.b = nxt
    Emit( c, st1 )
    Terminate( c, MTERM_BR, headB, -1, NoVal( ) )

    c.curBlock = exitB
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
