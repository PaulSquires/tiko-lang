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
    as Fbx.UdtLayouts ptr   udts      '' field offsets, for member access
    '' THE CLEANUP MODEL (docs/plan/08 section 6).
    ''
    '' One flat list of actions, plus a stack of marks giving where each open scope's
    '' actions begin. Actions run in REVERSE REGISTRATION ORDER, and locals and
    '' DEFERs share the one list -- which is what makes the measured fbc order fall
    '' out rather than needing to be arranged. Measured: a local 'a' declared before
    '' two defers is destroyed AFTER both of them run, newest defer first.
    '' Two action kinds share ONE list, because the ORDER is one order: a local
    '' declared before two defers is destroyed after both run (measured), which only
    '' falls out if they are interleaved rather than kept apart.
    ''   RunDefer      cleanupNode = the statement,   cleanupSlot = -1
    ''   DestroyLocal  cleanupNode = the dtor symbol,  cleanupSlot = the slot
    ''   DeleteString  cleanupNode = 0,                cleanupSlot = the slot
    as FB.Array( of ulong ) cleanupNode
    as FB.Array( of long )  cleanupSlot
    as FB.Array( of long )  scopeMark      '' index into cleanupNode per open scope
    '' The scope depth each open loop started at, so EXIT and CONTINUE know how many
    '' scopes they are leaving.
    as FB.Array( of long )  loopScope
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
    '' An aggregate slot needs its SIZE: 'agg' says nothing about how many bytes to
    '' reserve, and the layout pass is the only thing that knows.
    dim as long ui = c.udts->Find( s->type_ )
    if ui >= 0 then
        l.size = c.udts->udts[ui].size
    else
        l.size = c.types->Layout( s->type_ ).size
    end if
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

    '' 'x.f' is the base's address plus a CONSTANT offset. The offset comes from the
    '' measured layout, and Check already bound the member to its field symbol, so
    '' nothing is looked up twice.
    if c.ast->Kind( id ) = Fbx.N_MEMBER then
        dim as Fbx.BinaryPayload ptr mp = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
        dim as Fbx.TypeId bt = c.info->TypeOf_( mp->lhs )
        dim as MirValue base_
        if (bt <> Fbx.TYPE_NONE) andalso (c.types->Kind( bt ) = Fbx.TK_POINTER) then
            '' Through a pointer the base is the VALUE, not its slot.
            base_ = LowerExpr( c, mp->lhs )
            bt = c.types->Inner( bt )
        else
            base_ = LowerAddr( c, mp->lhs )
        end if
        if base_.kind = cast( ubyte, MV_NONE ) then return v
        dim as Fbx.SymbolId fsym = c.info->RefOf( id )
        dim as Fbx.Symbol ptr fs = c.syms->SymbolAt( fsym )
        if fs = 0 then return v
        dim as boolean found = false
        dim as long off = c.udts->FieldOffset( bt, fs->name, found )
        if found = false then return v
        dim as MirInst ins
        ins.op = cast( ushort, M_FIELD_ADDR )
        ins.ty = cast( ubyte, MT_PTR )
        ins.a = base_
        ins.imm = off
        return Emit( c, ins )
    end if

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

    case Fbx.N_IDENT, Fbx.N_MEMBER
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


declare sub LowerStmt( byref c as Ctx, byval id as Fbx.NodeId )
declare function SameLValue _
    ( byref c as Ctx, byval a as Fbx.NodeId, byval b as Fbx.NodeId ) as boolean

'' The ctor or dtor of a type, or SYMBOL_NONE. They live in the type's scope under a
'' synthetic name, because neither has a name of its own in the source.
private function StructorOf _
    ( byref c as Ctx, byval t as Fbx.TypeId, byref which as string ) as Fbx.SymbolId

    if t = Fbx.TYPE_NONE then return Fbx.SYMBOL_NONE
    if c.types->Kind( t ) <> Fbx.TK_UDT then return Fbx.SYMBOL_NONE
    dim as Fbx.InternId tn = c.types->NameOf( t )
    if tn = 0 then return Fbx.SYMBOL_NONE
    dim as Fbx.ScopeId ds = cast( Fbx.ScopeId, c.types->DeclScopeOf( t ) )
    dim as Fbx.SymbolId ts = c.syms->Lookup( ds, tn )
    dim as Fbx.Symbol ptr s = c.syms->SymbolAt( ts )
    if s = 0 then return Fbx.SYMBOL_NONE
    if s->inner = Fbx.SCOPE_NONE then return Fbx.SYMBOL_NONE
    return c.syms->LookupLocal( s->inner, _
        c.names->Fold( c.names->GetString( which ) ) )
end function

'' The overload in a chain that takes exactly 'want' parameters. A default
'' constructor and a destructor are the zero-parameter ones -- taking the head of the
'' chain instead picked whichever overload happened to be first.
private function StructorWithArity _
    ( byref c as Ctx, byval first_ as Fbx.SymbolId, byval want as long ) as Fbx.SymbolId

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
            if np = want then return cur
        end if
        cur = s->nextOverload
    wend
    return Fbx.SYMBOL_NONE
end function

'' A call to a structor with the slot's address as the implicit THIS. The receiver is
'' the first argument, per the ABI, which is also how the mangled name reads.
private sub EmitStructorCall _
    ( byref c as Ctx, byval sym as Fbx.SymbolId, byval slot as long )

    dim as Fbx.Symbol ptr s = c.syms->SymbolAt( sym )
    if s = 0 then return
    dim as Fbx.NodeId pn = cast( Fbx.NodeId, s->payload )
    if pn = Fbx.NODE_NONE then return
    if c.ast->Kind( pn ) <> Fbx.N_PROC then return

    dim as MirValue self_
    self_.kind = cast( ubyte, MV_LOCAL )
    self_.ty = cast( ubyte, MT_PTR )
    self_.id = slot

    dim as long first = c.m->argPool.Count \ 2
    c.m->argPool.Push( cast( ulong, self_.kind ) )
    c.m->argPool.Push( cast( ulong, self_.id ) )

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
        decl->paramCount = 1
        fidx = c.m->functions.Count - 1
    end if

    dim as MirInst ins
    ins.op = cast( ushort, M_CALL )
    ins.ty = cast( ubyte, MT_VOID )
    ins.first = first
    ins.count = 1
    ins.callee = fidx
    Emit( c, ins )
end sub

private sub EmitDtorCall _
    ( byref c as Ctx, byval sym as Fbx.SymbolId, byval slot as long )
    EmitStructorCall( c, sym, slot )
end sub

'' ------------------------------------------------------------------ runtime

'' A call to a runtime function, by table id. Nothing here spells a runtime name: the
'' inventory is the only place that does (docs/plan/11 section 3).
private function EmitRtl _
    ( byref c as Ctx, byval r as RtlId, byref args as FB.Array( of ulong ) ) as MirValue

    dim as MirValue v
    dim as Fbx.InternId nm = c.names->GetString( RtlSymbol( r ) )
    dim as long fidx = -1
    for i as long = 0 to c.m->functions.Count - 1
        if c.m->functions[i]->name = nm then
            fidx = i
            exit for
        end if
    next
    if fidx < 0 then
        dim as MirFunction ptr decl = c.m->AddFunction( nm, RtlReturn( r ) )
        decl->isDefinition = false
        decl->paramCount = RtlArity( r )
        fidx = c.m->functions.Count - 1
    end if

    dim as long first = c.m->argPool.Count \ 2
    for i as long = 0 to args.Count - 1
        c.m->argPool.Push( args[i] )
    next

    dim as MirInst ins
    ins.op = cast( ushort, M_CALL_RTL )
    ins.ty = cast( ubyte, RtlReturn( r ) )
    ins.first = first
    ins.count = args.Count \ 2
    ins.callee = fidx
    return Emit( c, ins )
end function

'' The (pointer, length) pair the string runtime takes. A var-length string is its
'' DESCRIPTOR's address with a length of -1; the runtime reads the length from the
'' descriptor itself.
private sub PushStrArg _
    ( byref args as FB.Array( of ulong ), byref addr as MirValue )
    args.Push( cast( ulong, addr.kind ) )
    args.Push( cast( ulong, addr.id ) )
    args.Push( cast( ulong, MV_CONST_INT ) )
    args.Push( cast( ulong, cast( ulongint, -1 ) ) )
end sub


private function IsStringType _
    ( byref c as Ctx, byval t as Fbx.TypeId ) as boolean
    if t = Fbx.TYPE_NONE then return false
    if c.types->Kind( t ) <> Fbx.TK_BUILTIN then return false
    dim as Fbx.BuiltinType b = c.types->BuiltinOf( t )
    return (b = Fbx.TY_STRING) orelse (b = Fbx.TY_USTRING)
end function

'' 'a = b' and 'a = a + b' between var-length strings. Returns false when this is not
'' a string assignment, so the caller falls back to an ordinary store.
private function LowerStringAssign _
    ( byref c as Ctx, byval target as Fbx.NodeId, byval value as Fbx.NodeId ) as boolean

    if IsStringType( c, c.info->TypeOf_( target ) ) = false then return false
    dim as MirValue dst = LowerAddr( c, target )
    if dst.kind = cast( ubyte, MV_NONE ) then return false

    '' 'a = a + b' is a CONCAT-ASSIGN, which is what fbc emits: the destination is
    '' also the left operand, so no temporary is needed.
    dim as Fbx.NodeId rhs = value
    dim as boolean concat = false
    if c.ast->Kind( value ) = Fbx.N_BINARY then
        dim as Fbx.BinaryPayload ptr bp = _
            @c.ast->binaries[cast( long, c.ast->nodes[cast( long, value )].data )]
        if cast( Fbx.TokenKind, bp->op ) = Fbx.TK_PLUS then
            '' Only the self-concatenation shape is handled here; a general
            '' 'a = b + c' needs a temporary, which is not lowered yet.
            if SameLValue( c, target, bp->lhs ) then
                concat = true
                rhs = bp->rhs
            else
                return false
            end if
        end if
    end if

    if IsStringType( c, c.info->TypeOf_( rhs ) ) = false then return false
    dim as MirValue src = LowerAddr( c, rhs )
    if src.kind = cast( ubyte, MV_NONE ) then return false

    dim as FB.Array( of ulong ) args
    PushStrArg( args, dst )
    PushStrArg( args, src )
    args.Push( cast( ulong, MV_CONST_INT ) )
    args.Push( 0 )
    if concat then
        EmitRtl( c, RTL_STR_CONCAT_ASSIGN, args )
    else
        EmitRtl( c, RTL_STR_ASSIGN, args )
    end if
    return true
end function

'' Whether two expressions name the same storage. Only the simple cases are needed:
'' anything else falls back to the general path rather than guessing.
private function SameLValue _
    ( byref c as Ctx, byval a as Fbx.NodeId, byval b as Fbx.NodeId ) as boolean
    if (a = Fbx.NODE_NONE) orelse (b = Fbx.NODE_NONE) then return false
    if c.ast->Kind( a ) <> c.ast->Kind( b ) then return false
    if c.ast->Kind( a ) <> Fbx.N_IDENT then return false
    return c.info->RefOf( a ) = c.info->RefOf( b )
end function

'' -------------------------------------------------------------- cleanup model

private sub PushScope( byref c as Ctx )
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
private sub EmitCleanupsTo( byref c as Ctx, byval outermost as long )
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
private sub CloseScope( byref c as Ctx )
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

    '' A string assignment is a runtime call, not a store.
    if LowerStringAssign( c, target, value ) then return

    dim as MirValue addr = LowerAddr( c, target )
    dim as MirValue val = LowerExpr( c, value )
    if (addr.kind = cast( ubyte, MV_NONE )) orelse (val.kind = cast( ubyte, MV_NONE )) then
        c.st->skipped += 1
        return
    end if
    '' The stored value must match the TARGET's type exactly -- MIR has no implicit
    '' conversions, so the narrowing FreeBASIC allows on assignment is explicit here.
    '' The type comes from the target EXPRESSION, not from the local slot: a member
    '' store's address is a temp from field.addr, and there is no slot to ask.
    val = Coerce( c, val, LowerType( c.info->TypeOf_( target ), *c.types ) )
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

            '' A UDT local is CONSTRUCTED where it is declared and DESTROYED at the
            '' end of its scope. The destructor is registered into the same cleanup
            '' list the defers use, so the measured order -- reverse registration,
            '' interleaved with defers, innermost scope first on an early exit --
            '' applies to it without any extra arrangement.
            dim as Fbx.Symbol ptr vs = c.syms->SymbolAt( sid )
            dim as boolean constructed = false
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
                    c.cleanupNode.Push( 0 )
                    c.cleanupSlot.Push( slot )
                end if
            end if

            '' Hoisted: FreeBASIC warns 38 on a mixed boolean/non-boolean chain, and
            '' the house rule is to name the condition rather than silence it.
            dim as boolean needsStore = (slot >= 0)
            if ip->b = Fbx.NODE_NONE then needsStore = false
            if constructed then needsStore = false
            if needsStore then
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

    case Fbx.N_RETURN
        dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
        dim as MirValue rv
        if sp->a <> Fbx.NODE_NONE then rv = LowerExpr( c, sp->a )
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
            c.st->skipped += 1
        end if

    case Fbx.N_CONTINUE
        if c.contTo.Count > 0 then
            EmitCleanupsTo( c, c.loopScope[c.loopScope.Count - 1] )
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

    dim as long scopeDepthIn = c.scopeMark.Count
    PushScope( c )
    LowerBlock( c, sp->b )
    CloseScope( c )
    '' Every scope opened must have been closed. An imbalance means some exit path
    '' skipped a scope's cleanup, which is the bug class this whole model exists to
    '' prevent, so it is checked rather than assumed.
    if c.scopeMark.Count <> scopeDepthIn then
        c.st->scopeImbalance += 1
    end if
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
      byref src as Fbx.SourceManager, byref udts as Fbx.UdtLayouts, _
      byref m as MirModule, byref st as LowerStats ) as long

    dim as Ctx c
    c.srcMgr = @src
    c.udts = @udts
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
