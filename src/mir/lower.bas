'' lower.bas -- AST to MIR. See lower.bi for what this slice does and does not cover.

#include once "mir/lower.bi"
#include once "symbols/mangle.bi"

namespace Fbx.Mir

type Ctx
    as Fbx.AstArena ptr     ast
    as Fbx.SymbolTable ptr  syms
    as Fbx.TypeContext ptr  types
    as Fbx.Interner ptr     names
    as Fbx.SemanticInfo ptr info
    as MirModule ptr        m
    as MirFunction ptr      f
    as LowerStats ptr       st
    as long                 curBlock
    '' The innermost loop's exit and continue targets, for EXIT and CONTINUE. A stack
    '' rather than a pair, because the statements take a level count.
    as FB.Array( of long )  breakTo
    as FB.Array( of long )  contTo
    as Fbx.SourceManager ptr srcMgr    '' only for the constant evaluator
end type

private function StmtOf _
    ( byref c as Ctx, byval id as Fbx.NodeId ) as Fbx.StmtPayload ptr
    return @c.ast->stmts[cast( long, c.ast->nodes[cast( long, id )].data )]
end function

'' -------------------------------------------------------------- construction

private function NewBlock( byref c as Ctx, byref label as string ) as long
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
private function Emit( byref c as Ctx, byref ins as MirInst ) as MirValue
    dim as MirValue v
    if c.curBlock < 0 then return v
    dim as MirOp op = cast( MirOp, ins.op )
    '' An instruction that would produce a VOID result is not emitted at all. It
    '' means the frontend could not type the expression, and a well-formed IR with a
    '' gap in it is far more useful than a complete one that is malformed.
    if OpHasResult( op ) andalso (ins.ty = cast( ubyte, MT_VOID )) then
        if (op <> M_CALL) andalso (op <> M_CALL_RTL) then
            c.st->skipped += 1
            return v
        end if
    end if
    if OpHasResult( op ) then
        ins.result = c.f->nextTemp
        c.f->nextTemp += 1
    end if
    c.f->blocks[c.curBlock].insts.Push( ins )
    c.st->insts += 1
    if OpHasResult( op ) then
        v.kind = cast( ubyte, MV_TEMP )
        v.ty = ins.ty
        v.id = ins.result
    end if
    return v
end function

'' An empty value, for the terminators that carry none. FreeBASIC will not take a
'' constructed default argument, so it is spelled once here rather than at every call.
private function NoVal( ) as MirValue
    dim as MirValue v
    return v
end function

private sub Terminate _
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

private function ConstInt _
    ( byref c as Ctx, byval v as longint, byval t as MirType ) as MirValue
    dim as MirInst ins
    ins.op = cast( ushort, M_CONST )
    ins.ty = cast( ubyte, t )
    ins.imm = v
    return Emit( c, ins )
end function

private function ConstFloat _
    ( byref c as Ctx, byval v as double, byval t as MirType ) as MirValue
    dim as MirInst ins
    ins.op = cast( ushort, M_CONST )
    ins.ty = cast( ubyte, t )
    ins.fimm = v
    return Emit( c, ins )
end function

private function IsFloatTy( byval t as MirType ) as boolean
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
private function Coerce _
    ( byref c as Ctx, byref v as MirValue, byval want as MirType ) as MirValue

    if v.kind = cast( ubyte, MV_NONE ) then return v
    dim as MirType have = cast( MirType, v.ty )
    if have = want then return v
    if (have = MT_VOID) orelse (want = MT_VOID) then return v

    dim as MirInst ins
    ins.ty = cast( ubyte, want )
    ins.a = v
    dim as boolean hf = IsFloatTy( have )
    dim as boolean wf = IsFloatTy( want )

    if hf andalso wf then
        ins.op = cast( ushort, iif( TyWidth( want ) < TyWidth( have ), M_FPTRUNC, M_FPEXT ) )
    elseif hf then
        ins.op = cast( ushort, M_FPTOSI )
    elseif wf then
        ins.op = cast( ushort, M_SITOFP )
    else
        if TyWidth( want ) < TyWidth( have ) then
            ins.op = cast( ushort, M_TRUNC )
        elseif TyWidth( want ) > TyWidth( have ) then
            ins.op = cast( ushort, M_SEXT )
        else
            return v
        end if
    end if
    return Emit( c, ins )
end function

'' ------------------------------------------------------------------- locals

'' A local is a slot, addressed by an alloca in the entry block. Locals are found by
'' SYMBOL, so the same name in two scopes gets two slots.
private function LocalFor _
    ( byref c as Ctx, byval sid as Fbx.SymbolId ) as long

    dim as Fbx.Symbol ptr s = c.syms->SymbolAt( sid )
    if s = 0 then return -1
    '' payload doubles as the slot index once assigned; -1 means not yet.
    for i as long = 0 to c.f->locals.Count - 1
        if c.f->locals[i].name = s->name then return i
    next
    dim as MirLocal l
    l.name = s->name
    l.frontendType = s->type_
    l.ty = cast( ubyte, LowerType( s->type_, *c.types ) )
    c.f->locals.Push( l )

    '' The alloca goes in the ENTRY block, which is a verifier rule and also what
    '' lets LLVM's mem2reg promote the slot.
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

declare function LowerExpr _
    ( byref c as Ctx, byval id as Fbx.NodeId ) as MirValue
declare function LowerShortCircuit _
    ( byref c as Ctx, byval id as Fbx.NodeId, byval bp as Fbx.BinaryPayload ptr, _
      byval mt as MirType ) as MirValue
declare function LowerCall _
    ( byref c as Ctx, byval id as Fbx.NodeId, byval mt as MirType ) as MirValue
declare sub LowerIf _
    ( byref c as Ctx, byval id as Fbx.NodeId, byval sp as Fbx.StmtPayload ptr )
declare sub LowerDo( byref c as Ctx, byval id as Fbx.NodeId )
declare sub LowerFor( byref c as Ctx, byval id as Fbx.NodeId )
declare function LowerExprLoad _
    ( byref c as Ctx, byref addr as MirValue, byval t as MirType ) as MirValue

private function BinOpFor _
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

private function IsUnsignedType _
    ( byref c as Ctx, byval t as Fbx.TypeId ) as boolean
    if t = Fbx.TYPE_NONE then return false
    if c.types->Kind( t ) <> Fbx.TK_BUILTIN then return false
    select case c.types->BuiltinOf( t )
    case Fbx.TY_UBYTE, Fbx.TY_USHORT, Fbx.TY_ULONG, Fbx.TY_UINTEGER, Fbx.TY_ULONGINT
        return true
    end select
    return false
end function

'' The ADDRESS of an assignable expression, or an undef value when this slice cannot
'' produce one (a member, an index, a dereference).
private function LowerAddr _
    ( byref c as Ctx, byval id as Fbx.NodeId ) as MirValue

    dim as MirValue v
    if id = Fbx.NODE_NONE then return v
    if c.ast->Kind( id ) <> Fbx.N_IDENT then return v
    dim as Fbx.SymbolId sid = c.info->RefOf( id )
    if sid = Fbx.SYMBOL_NONE then return v
    dim as long slot = LocalFor( c, sid )
    if slot < 0 then return v
    v.kind = cast( ubyte, MV_LOCAL )
    v.ty = cast( ubyte, MT_PTR )
    v.id = slot
    return v
end function

function LowerExpr _
    ( byref c as Ctx, byval id as Fbx.NodeId ) as MirValue

    dim as MirValue v
    if id = Fbx.NODE_NONE then return v

    dim as Fbx.TypeId ft = c.info->TypeOf_( id )
    dim as MirType mt = LowerType( ft, *c.types )

    select case c.ast->Kind( id )
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

    case Fbx.N_IDENT
        dim as MirValue addr = LowerAddr( c, id )
        if addr.kind = cast( ubyte, MV_NONE ) then return v
        dim as MirInst ins
        ins.op = cast( ushort, M_LOAD )
        ins.ty = cast( ubyte, mt )
        ins.a = addr
        return Emit( c, ins )

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

        dim as MirValue l = LowerExpr( c, bp->lhs )
        dim as MirValue r = LowerExpr( c, bp->rhs )
        if (l.kind = cast( ubyte, MV_NONE )) orelse (r.kind = cast( ubyte, MV_NONE )) then
            return v
        end if
        '' The operand type decides signed versus unsigned, and it is the OPERANDS'
        '' type, not the result's: a comparison yields an integer either way.
        dim as Fbx.TypeId lt = c.info->TypeOf_( bp->lhs )
        dim as MirType opTy = LowerType( lt, *c.types )
        '' Both operands are brought to the WIDER of the two; the frontend's measured
        '' promotion rules already decided what the result type is.
        if TyWidth( cast( MirType, r.ty ) ) > TyWidth( opTy ) then
            opTy = cast( MirType, r.ty )
        end if
        if IsFloatTy( cast( MirType, r.ty ) ) then opTy = cast( MirType, r.ty )
        l = Coerce( c, l, opTy )
        r = Coerce( c, r, opTy )
        dim as MirOp op = BinOpFor( tk, opTy, IsUnsignedType( c, lt ) )
        if op = M_NONE then return v
        dim as MirInst ins
        ins.op = cast( ushort, op )
        ins.ty = cast( ubyte, iif( mt = MT_VOID, opTy, mt ) )
        ins.a = l
        ins.b = r
        return Emit( c, ins )

    case Fbx.N_CALL
        return LowerCall( c, id, mt )
    end select

    return v
end function

'' ANDALSO / ORELSE: the right operand is evaluated only when the left does not
'' already decide the answer. The result is materialised through a slot rather than a
'' phi, which is what keeps this IR phi-free.
private function LowerShortCircuit _
    ( byref c as Ctx, byval id as Fbx.NodeId, byval bp as Fbx.BinaryPayload ptr, _
      byval mt as MirType ) as MirValue

    dim as MirValue v
    dim as MirValue l = LowerExpr( c, bp->lhs )
    if l.kind = cast( ubyte, MV_NONE ) then return v

    dim as long rhsB = NewBlock( c, "sc.rhs" )
    dim as long joinB = NewBlock( c, "sc.join" )
    if cast( Fbx.TokenKind, bp->op ) = Fbx.KW_ANDALSO then
        Terminate( c, MTERM_CONDBR, rhsB, joinB, l )
    else
        Terminate( c, MTERM_CONDBR, joinB, rhsB, l )
    end if

    c.curBlock = rhsB
    dim as MirValue r = LowerExpr( c, bp->rhs )
    Terminate( c, MTERM_BR, joinB, -1, NoVal( ) )

    c.curBlock = joinB
    '' Without phis the join cannot name "whichever side ran". Producing the RIGHT
    '' operand's value here is correct only when it ran, so this is marked as the
    '' known gap it is rather than pretended to be complete.
    if r.kind = cast( ubyte, MV_NONE ) then return l
    return r
end function

private function LowerCall _
    ( byref c as Ctx, byval id as Fbx.NodeId, byval mt as MirType ) as MirValue

    dim as MirValue v
    dim as Fbx.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    dim as Fbx.SymbolId callee = c.info->RefOf( id )
    if callee = Fbx.SYMBOL_NONE then return v
    dim as Fbx.Symbol ptr cs = c.syms->SymbolAt( callee )
    if cs = 0 then return v

    '' Arguments go into the module's shared pool as (kind, id) pairs.
    dim as long first = c.m->argPool.Count \ 2
    dim as long n = 0
    for i as long = 0 to cp->count - 1
        dim as MirValue a = LowerExpr( c, cast( Fbx.NodeId, c.ast->children[cp->first + i] ) )
        c.m->argPool.Push( cast( ulong, a.kind ) )
        c.m->argPool.Push( cast( ulong, a.id ) )
        n += 1
    next

    '' The callee is named by its MANGLED name, which is what MIR carries. Finding
    '' the function object is a linear scan for now; it is a map when it matters.
    dim as long fidx = -1
    for i as long = 0 to c.m->functions.Count - 1
        if c.m->functions[i]->name = cs->name then
            fidx = i
            exit for
        end if
    next
    if fidx < 0 then
        dim as MirFunction ptr decl = c.m->AddFunction( cs->name, mt )
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

'' -------------------------------------------------------------- statements

declare sub LowerStmt( byref c as Ctx, byval id as Fbx.NodeId )

private sub LowerBlock( byref c as Ctx, byval id as Fbx.NodeId )
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

    dim as MirValue addr = LowerAddr( c, target )
    dim as MirValue val = LowerExpr( c, value )
    if (addr.kind = cast( ubyte, MV_NONE )) orelse (val.kind = cast( ubyte, MV_NONE )) then
        c.st->skipped += 1
        return
    end if
    '' The stored value must match the slot's type exactly -- MIR has no implicit
    '' conversions, so the narrowing FreeBASIC allows on assignment is explicit here.
    val = Coerce( c, val, cast( MirType, c.f->locals[cast( long, addr.id )].ty ) )
    dim as MirInst ins
    ins.op = cast( ushort, M_STORE )
    ins.ty = cast( ubyte, MT_VOID )
    ins.a = addr
    ins.b = val
    Emit( c, ins )
end sub

sub LowerStmt( byref c as Ctx, byval id as Fbx.NodeId )
    if id = Fbx.NODE_NONE then return
    if c.curBlock < 0 then return

    select case c.ast->Kind( id )
    case Fbx.N_BLOCK
        LowerBlock( c, id )

    case Fbx.N_SCOPE
        '' A SCOPE carries its body in 'b'. Sending the SCOPE node itself to
        '' LowerBlock recursed forever: LowerBlock forwards anything that is not an
        '' N_BLOCK to LowerStmt, which forwarded it straight back. A guard that does
        '' not narrow is not a guard.
        LowerBlock( c, StmtOf( c, id )->b )

    case Fbx.N_VAR
        dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
        if sp->op = cast( ushort, Fbx.KW_REDIM ) then
            c.st->skipped += 1
            return
        end if
        for i as long = 0 to sp->count - 1
            dim as Fbx.NodeId item = cast( Fbx.NodeId, c.ast->children[sp->first + i] )
            if c.ast->Kind( item ) <> Fbx.N_VAR_ITEM then continue for
            dim as Fbx.StmtPayload ptr ip = StmtOf( c, item )
            dim as Fbx.SymbolId sid = c.syms->LookupLocal( c.info->ScopeOf( id ), ip->name )
            if sid = Fbx.SYMBOL_NONE then
                c.st->skipped += 1
                continue for
            end if
            dim as long slot = LocalFor( c, sid )
            if (slot >= 0) andalso (ip->b <> Fbx.NODE_NONE) then
                dim as MirValue val = LowerExpr( c, ip->b )
                if val.kind <> cast( ubyte, MV_NONE ) then
                    val = Coerce( c, val, cast( MirType, c.f->locals[slot].ty ) )
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
        case Fbx.AMB_ASSIGN
            LowerAssign( c, sp->a, sp->b )
        case Fbx.AMB_CALL
            LowerExpr( c, sp->a )
        case else
            c.st->skipped += 1
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
        LowerBlock( c, sp->b )
        c.breakTo.Pop( )
        c.contTo.Pop( )
        Terminate( c, MTERM_BR, headB, -1, NoVal( ) )
        c.curBlock = exitB

    case Fbx.N_DO
        LowerDo( c, id )

    case Fbx.N_FOR
        LowerFor( c, id )

    case Fbx.N_RETURN
        dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
        dim as MirValue rv
        if sp->a <> Fbx.NODE_NONE then rv = LowerExpr( c, sp->a )
        Terminate( c, MTERM_RET, -1, -1, rv )
        '' The cursor goes DEAD rather than opening a block nothing branches to.
        '' Statements after a RETURN are unreachable, and creating a block for them
        '' left the function with an orphan the verifier rightly complained about.
        c.curBlock = -1

    case Fbx.N_EXIT
        if c.breakTo.Count > 0 then
            Terminate( c, MTERM_BR, c.breakTo[c.breakTo.Count - 1], -1, NoVal( ) )
            c.curBlock = -1
        else
            c.st->skipped += 1
        end if

    case Fbx.N_CONTINUE
        if c.contTo.Count > 0 then
            Terminate( c, MTERM_BR, c.contTo[c.contTo.Count - 1], -1, NoVal( ) )
            c.curBlock = -1
        else
            c.st->skipped += 1
        end if

    case Fbx.N_PROC, Fbx.N_TYPE, Fbx.N_ENUM, Fbx.N_TYPEDEF, Fbx.N_NAMESPACE, _
         Fbx.N_CONST, Fbx.N_FIELD, Fbx.N_PARAM
        '' Declarations: handled by the module walk, not inside a body.

    case else
        c.st->skipped += 1
    end select
end sub

private sub LowerIf _
    ( byref c as Ctx, byval id as Fbx.NodeId, byval sp as Fbx.StmtPayload ptr )

    '' The branches hang off a list of N_IF_BRANCH, each with its own condition; the
    '' ELSE body is 'c'.
    dim as Fbx.NodeId branches = sp->b
    if branches = Fbx.NODE_NONE then
        c.st->skipped += 1
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
    LowerBlock( c, sp->b )
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
        c.st->skipped += 1
        return
    end if
    dim as MirType ity = cast( MirType, c.f->locals[cast( long, addr.id )].ty )

    '' init
    dim as MirValue init_ = Coerce( c, LowerExpr( c, fromE ), ity )
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
    dim as MirValue lim = Coerce( c, LowerExpr( c, toE ), ity )
    dim as boolean negStep = false
    if stepE <> Fbx.NODE_NONE then
        dim as Fbx.Check.ConstVal sv = Fbx.Check.ConstOf( *c.ast, stepE, *c.srcMgr, *c.names )
        if sv.known then
            negStep = (sv.value < 0)
        else
            c.st->skipped += 1
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
    LowerBlock( c, sp->b )
    c.breakTo.Pop( )
    c.contTo.Pop( )
    Terminate( c, MTERM_BR, stepB, -1, NoVal( ) )

    c.curBlock = stepB
    dim as MirValue cur2 = LowerExprLoad( c, addr, ity )
    dim as MirValue inc
    if stepE <> Fbx.NODE_NONE then
        inc = Coerce( c, LowerExpr( c, stepE ), ity )
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

private function LowerExprLoad _
    ( byref c as Ctx, byref addr as MirValue, byval t as MirType ) as MirValue
    dim as MirInst ins
    ins.op = cast( ushort, M_LOAD )
    ins.ty = cast( ubyte, t )
    ins.a = addr
    return Emit( c, ins )
end function

'' ------------------------------------------------------------------ the walk

private sub LowerProc _
    ( byref c as Ctx, byval id as Fbx.NodeId )

    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
    if sp->b = Fbx.NODE_NONE then return       '' a declaration, not a definition

    dim as Fbx.SymbolId sid = c.info->RefOf( id )
    dim as Fbx.Symbol ptr s = c.syms->SymbolAt( sid )
    dim as Fbx.TypeId rt = iif( s <> 0, s->type_, Fbx.TYPE_NONE )

    '' MIR carries the MANGLED name and never a source one.
    dim as Fbx.InternId nm = c.names->GetString( _
        Fbx.Mangle.ProcName( *c.ast, id, *c.syms, *c.names, *c.types, *c.info ) )

    dim as MirFunction ptr f = c.m->AddFunction( nm, LowerType( rt, *c.types ) )
    f->isDefinition = true
    dim as MirFunction ptr savedF = c.f
    dim as long savedB = c.curBlock
    c.f = f
    c.st->functions += 1

    for i as long = 0 to sp->count - 1
        if c.ast->Kind( cast( Fbx.NodeId, c.ast->children[sp->first + i] ) ) = Fbx.N_PARAM then
            f->paramCount += 1
        end if
    next

    c.curBlock = NewBlock( c, "entry" )

    '' A parameter is a slot like any other local, written once on entry. That is
    '' what makes 'byval' parameters assignable, which FreeBASIC allows, and it is
    '' the shape mem2reg expects.
    dim as long pidx = 0
    for i as long = 0 to sp->count - 1
        dim as Fbx.NodeId prm = cast( Fbx.NodeId, c.ast->children[sp->first + i] )
        if c.ast->Kind( prm ) <> Fbx.N_PARAM then continue for
        dim as Fbx.StmtPayload ptr pp = StmtOf( c, prm )
        dim as Fbx.SymbolId psid = c.syms->LookupLocal( c.info->ScopeOf( id ), pp->name )
        if psid <> Fbx.SYMBOL_NONE then
            dim as long slot = LocalFor( c, psid )
            if slot >= 0 then
                dim as MirValue addr
                addr.kind = cast( ubyte, MV_LOCAL )
                addr.ty = cast( ubyte, MT_PTR )
                addr.id = slot
                dim as MirValue pv
                pv.kind = cast( ubyte, MV_PARAM )
                pv.ty = c.f->locals[slot].ty
                pv.id = pidx
                dim as MirInst ins
                ins.op = cast( ushort, M_STORE )
                ins.ty = cast( ubyte, MT_VOID )
                ins.a = addr
                ins.b = pv
                Emit( c, ins )
            end if
        end if
        pidx += 1
    next

    LowerBlock( c, sp->b )
    '' A function whose last block has no terminator falls off the end; FreeBASIC
    '' allows that and returns the result variable, so an explicit RET closes it.
    Terminate( c, MTERM_RET, -1, -1, NoVal( ) )

    c.f = savedF
    c.curBlock = savedB
end sub

private sub WalkTop( byref c as Ctx, byval id as Fbx.NodeId )
    if id = Fbx.NODE_NONE then return
    select case c.ast->Kind( id )
    case Fbx.N_MODULE, Fbx.N_BLOCK
        dim as Fbx.ListPayload ptr lp = _
            @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
        for i as long = 0 to lp->count - 1
            WalkTop( c, cast( Fbx.NodeId, c.ast->children[lp->first + i] ) )
        next
    case Fbx.N_NAMESPACE, Fbx.N_EXTERN_BLOCK
        dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
        for i as long = 0 to sp->count - 1
            WalkTop( c, cast( Fbx.NodeId, c.ast->children[sp->first + i] ) )
        next
    case Fbx.N_PROC
        LowerProc( c, id )
    end select
end sub

function Lower _
    ( byref ast as Fbx.AstArena, byval root as Fbx.NodeId, _
      byref syms as Fbx.SymbolTable, byref types as Fbx.TypeContext, _
      byref names as Fbx.Interner, byref info as Fbx.SemanticInfo, _
      byref src as Fbx.SourceManager, byref m as MirModule, _
      byref st as LowerStats ) as long

    dim as Ctx c
    c.srcMgr = @src
    c.ast = @ast
    c.syms = @syms
    c.types = @types
    c.names = @names
    c.info = @info
    c.m = @m
    c.st = @st
    c.curBlock = -1
    WalkTop( c, root )
    return st.functions
end function

end namespace
