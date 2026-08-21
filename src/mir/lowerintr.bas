'' lowerintr.bas -- statement INTRINSICS whose lowering is a runtime call.
''
'' Split out of lower.bas when that file passed the 1500-line lint cap. What belongs
'' here is the quirk statements that are calls and nothing else -- no control flow of
'' their own, no state -- with the runtime shape MEASURED from fbc's own C output
'' rather than assumed. PRINT and SWAP live in lowerstr.bas instead, because both are
'' really about the string runtime.

#include once "mir/lowerctx.bi"

namespace Fbx.Mir

'' CLOSE. Every corpus form is the same shape: a list of file numbers, each closed in
'' turn, and an EMPTY list closing all of them.
''
'' Measured from fbc's own C output: 'close #1' is 'fb_FileClose( 1 )', 'close 1' the
'' same call -- the '#' is decoration and the parser has already dropped it -- 'close
'' #1, #2' is two calls in source order, and a bare 'close' is 'fb_FileCloseAll( )'.
'' No new shape, no state, nothing conditional.
''
'' 137 corpus statements across 39 files, none of which lowered before.
function LowerClose( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )

    if sp->count = 0 then
        dim as FB.Array( of ulong ) none_
        EmitRtl( c, RTL_FILE_CLOSEALL, none_ )
        return true
    end if

    for i as long = 0 to sp->count - 1
        dim as Fbx.NodeId it = cast( Fbx.NodeId, c.ast->children[sp->first + i] )
        '' An ELIDED slot is 'close ,' -- the corpus reaches it through a variadic
        '' macro invoked with an empty argument. fbc closes nothing for it.
        if c.ast->Kind( it ) = Fbx.N_ELIDED then continue for
        dim as MirValue fn = LowerExpr( c, it )
        if fn.kind = cast( ubyte, MV_NONE ) then return false
        dim as FB.Array( of ulong ) args
        fn = Coerce( c, fn, MT_I32, IsUnsignedType( c, c.info->TypeOf_( it ) ) )
        args.Push( cast( ulong, fn.kind ) ) : args.Push( cast( ulong, fn.id ) )
        EmitRtl( c, RTL_FILE_CLOSE, args )
    next
    return true
end function

'' ERROR n -- raise a runtime error.
''
'' Measured from fbc's own C:
''
''     void* vr$0 = fb_ErrorThrowEx( 5, 2, (char*)"er.bas", (void*)0, (void*)0 );
''     goto *vr$0;
''
'' Five arguments: the error number, THE SOURCE LINE, THE SOURCE FILE NAME, and two
'' resume labels that are null in -lang fb. The return value is the address of the
'' installed handler, and fbc jumps to it.
''
'' fbx does not implement ON ERROR -- there is no indirect-branch terminator in MIR and
'' no address-of-label value -- so no handler is ever installed, the runtime aborts, and
'' the call does not return. The block therefore ends UNREACHABLE. That is exactly right
'' for all 191 corpus sites, every one of which is an abort path in a runtime header
'' (comptr.bi, result.bi, channel.bi, optional.bi), and it would be WRONG for a program
'' that installed a handler -- which fbx already cannot compile, and still declines.
function LowerError( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
    if sp->count <> 1 then return false
    dim as Fbx.NodeId numE = cast( Fbx.NodeId, c.ast->children[sp->first] )
    dim as MirValue num = LowerExpr( c, numE )
    if num.kind = cast( ubyte, MV_NONE ) then return false
    num = Coerce( c, num, MT_I32, IsUnsignedType( c, c.info->TypeOf_( numE ) ) )

    dim as Fbx.DecodedLoc d = c.srcMgr->Decode( c.ast->Loc( id ) )
    dim as string fname = ""
    dim as Fbx.SourceFile ptr sf = c.srcMgr->FileAt( d.file )
    if sf <> 0 then fname = c.names->Spelling( sf->displayPath )

    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, num.kind ) ) : args.Push( cast( ulong, num.id ) )
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, d.lineNo ) )
    args.Push( cast( ulong, MV_GLOBAL ) )
    args.Push( cast( ulong, c.m->AddStringLiteral( fname, *c.names ) ) )
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
    EmitRtl( c, RTL_ERROR_THROW, args )

    Terminate( c, MTERM_UNREACHABLE, -1, -1, NoVal( ) )
    c.curBlock = NewBlock( c, "error.after" )
    return true
end function

'' The DESTRUCTOR of a UDT, or SYMBOL_NONE. Named 'destructor' in its own scope.
private function DtorOf_( byref c as Ctx, byval t as Fbx.TypeId ) as Fbx.SymbolId
    if t = Fbx.TYPE_NONE then return Fbx.SYMBOL_NONE
    if c.types->Kind( t ) <> Fbx.TK_UDT then return Fbx.SYMBOL_NONE
    '' By SCANNING for the UDT's symbol rather than looking its name up: a TypeId does
    '' not carry the scope it was declared in in a form Lookup can take, and the same
    '' spelling may name a UDT in two namespaces. The identity being matched is the
    '' TYPE, which is unique.
    for i as long = 1 to c.syms->Count( ) - 1
        dim as Fbx.Symbol ptr us = c.syms->SymbolAt( cast( Fbx.SymbolId, i ) )
        if us = 0 then continue for
        if us->kind <> cast( ubyte, Fbx.SYM_UDT ) then continue for
        if us->type_ <> t then continue for
        if us->inner = Fbx.SCOPE_NONE then return Fbx.SYMBOL_NONE
        return c.syms->LookupLocal( us->inner, c.names->Fold( c.names->GetString( "__dtor" ) ) )
    next
    return Fbx.SYMBOL_NONE
end function

'' DELETE p -- run the destructor, then release the storage.
''
'' Measured from fbc's own C, which is smaller than the keyword suggests:
''
''     if( P$0 == (struct $1T*)0ull) goto label$5;
''     _ZN1TD1Ev( P$0 );
''     free( (void*)P$0 );
''     label$5:;
''
'' A NULL CHECK, the destructor called with the pointer itself as the receiver, and
'' libc's free -- not an fb_* entry point. 'delete[] q' over a scalar array is the same
'' without the destructor call.
''
'' DECLINED for an ARRAY of a type that HAS a destructor: fbc has to run one per
'' element and needs the count to do it, which is not in the pointer. Getting that wrong
'' would leak or double-free, so it declines rather than guesses.
function LowerDelete( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
    if sp->a = Fbx.NODE_NONE then return false

    dim as Fbx.TypeId pt = c.info->TypeOf_( sp->a )
    if pt = Fbx.TYPE_NONE then return false
    if c.types->Kind( pt ) <> Fbx.TK_POINTER then return false
    dim as Fbx.TypeId el = c.types->Inner( pt )

    dim as Fbx.SymbolId dtor = DtorOf_( c, el )
    dim as boolean isArray = ((c.ast->nodes[cast( long, id )].flags and Fbx.NF_ARRAY) <> 0)
    if isArray andalso (dtor <> Fbx.SYMBOL_NONE) then return false

    dim as MirValue p = LowerExpr( c, sp->a )
    if p.kind = cast( ubyte, MV_NONE ) then return false
    p = Coerce( c, p, MT_PTR )

    '' 'if p <> 0 then ... end if', in the shape fbc emits: a compare, a conditional
    '' branch, the body, and a join.
    dim as MirValue zero = ConstInt( c, 0, MT_PTR )
    dim as MirInst cmp
    cmp.op = cast( ushort, M_ICMP_NE )
    cmp.ty = cast( ubyte, MT_I32 )
    cmp.a = p
    cmp.b = zero
    dim as MirValue cond = Emit( c, cmp )
    if cond.kind = cast( ubyte, MV_NONE ) then return false

    dim as long bodyB = NewBlock( c, "del.body" )
    dim as long joinB = NewBlock( c, "del.join" )
    Terminate( c, MTERM_CONDBR, bodyB, joinB, cond )
    c.curBlock = bodyB

    if dtor <> Fbx.SYMBOL_NONE then EmitStructorCall( c, dtor, -1, @p )

    dim as FB.Array( of ulong ) fargs
    fargs.Push( cast( ulong, p.kind ) ) : fargs.Push( cast( ulong, p.id ) )
    EmitRtl( c, RTL_FREE, fargs )

    Terminate( c, MTERM_BR, joinB, -1, NoVal( ) )
    c.curBlock = joinB
    return true
end function

'' 'a += b' and its six siblings. The operator was READ BY THE PARSER, recorded on the
'' statement, and then IGNORED: every compound assignment lowered to a plain store of
'' the right-hand side, so 'q += w' compiled as 'q = w'. Verifier-clean, no decline, no
'' diagnostic -- a silent miscompile of one of the commonest statements in the language.
''
'' The target's address is taken ONCE and the read, the operation and the write all go
'' through it, so an lvalue with a side effect -- 'arr( f( ) ) += 1' -- calls f once, as
'' fbc does.
''
'' The computation type is the TARGET's, with one exception measured against fbc:
'' '/' is FLOATING division whatever the operands are. 'dim as integer a = 1 : a /= 2'
'' prints 0 and 'a = 5 : a /= 2' prints 2 -- 0.5 and 2.5 rounded to even, not truncated
'' -- so the division happens in double and the result converts back on the way in.
''
'' '^=' is absent on purpose: power needs a runtime call fbx's inventory does not carry
'' yet, and declining is the honest answer where inventing a shift would not be.
function LowerCompoundAssign _
    ( byref c as Ctx, byval target as Fbx.NodeId, byval value as Fbx.NodeId, _
      byval op as Fbx.TokenKind ) as boolean

    dim as Fbx.TokenKind bop = Fbx.TK_EOF
    select case op
    case Fbx.TK_PLUSEQ   : bop = Fbx.TK_PLUS
    case Fbx.TK_MINUSEQ  : bop = Fbx.TK_MINUS
    case Fbx.TK_STAREQ   : bop = Fbx.TK_STAR
    case Fbx.TK_SLASHEQ  : bop = Fbx.TK_SLASH
    case Fbx.TK_BSLASHEQ : bop = Fbx.TK_BACKSLASH
    case else            : return false
    end select

    dim as Fbx.TypeId tt = c.info->TypeOf_( target )
    if tt = Fbx.TYPE_NONE then return false
    dim as MirType mt = LowerType( tt, *c.types )
    if (mt = MT_VOID) orelse (mt = MT_AGG) then return false

    '' The type the arithmetic happens in. Every operator but '/' works in the
    '' target's own type; '/' is float division, in single when the target already is
    '' one and in double otherwise -- 'dim as single h = 1 : h /= 2' prints 0.5.
    dim as MirType wt = mt
    if bop = Fbx.TK_SLASH then
        wt = iif( mt = MT_F32, MT_F32, MT_F64 )
    end if

    dim as MirValue addr = LowerAddr( c, target )
    if addr.kind = cast( ubyte, MV_NONE ) then return false
    dim as MirValue cur = LowerExprLoad( c, addr, mt )
    if cur.kind = cast( ubyte, MV_NONE ) then return false
    cur = Coerce( c, cur, wt, IsUnsignedType( c, tt ) )
    dim as MirValue rhs = LowerExpr( c, value )
    if rhs.kind = cast( ubyte, MV_NONE ) then return false
    rhs = Coerce( c, rhs, wt, IsUnsignedType( c, c.info->TypeOf_( value ) ) )

    dim as MirOp mop = BinOpFor( bop, wt, IsUnsignedType( c, tt ) )
    if mop = M_NONE then return false
    dim as MirInst bi
    bi.op = cast( ushort, mop )
    bi.ty = cast( ubyte, wt )
    bi.a = cur
    bi.b = rhs
    dim as MirValue res = Emit( c, bi )
    if res.kind = cast( ubyte, MV_NONE ) then return false

    dim as MirInst st
    st.op = cast( ushort, M_STORE )
    st.ty = cast( ubyte, MT_VOID )
    st.a = addr
    st.b = Coerce( c, res, mt )
    Emit( c, st )
    return true
end function



'' The low 'n' bits set. Built by shifting rather than written as a literal so a
'' 64-bit field does not overflow the shift it would need.
private function BitMask_( byval n as long ) as longint
    if n >= 64 then return -1
    return (cast( longint, 1 ) shl n) - 1
end function

'' A BITFIELD MEMBER ACCESS, as the address of its storage UNIT plus the bits it owns.
'' Returns false when the member is not a bitfield, so the caller carries on as before.
''
'' The unit is addressed at the field's byte offset and read at the field's DECLARED
'' type -- which is what sizes the unit, not what sizes the field.
function BitfieldParts _
    ( byref c as Ctx, byval id as Fbx.NodeId, byref addr as MirValue, _
      byref bitOff as long, byref bitWidth as long, byref unitTy as MirType, _
      byref unitUnsigned as boolean ) as boolean

    if c.ast->Kind( id ) <> Fbx.N_MEMBER then return false
    dim as Fbx.SymbolId fsym = c.info->RefOf( id )
    dim as Fbx.Symbol ptr fs = c.syms->SymbolAt( fsym )
    if fs = 0 then return false
    if (fs->flags and Fbx.SYMF_BITFIELD) = 0 then return false

    dim as Fbx.BinaryPayload ptr mp = _
        @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
    dim as Fbx.TypeId bt = c.info->TypeOf_( mp->lhs )
    dim as MirValue base_
    if bt <> Fbx.TYPE_NONE then
        if c.types->Kind( bt ) = Fbx.TK_POINTER then
            base_ = LowerExpr( c, mp->lhs )
            bt = c.types->Inner( bt )
        else
            base_ = LowerAddr( c, mp->lhs )
        end if
    end if
    if base_.kind = cast( ubyte, MV_NONE ) then return false

    dim as long ui = c.udts->Find( bt )
    if ui < 0 then return false
    dim as long off = 0
    dim as boolean got = false
    for i as long = 0 to c.udts->udts[ui].count - 1
        dim as long fi = c.udts->udts[ui].first + i
        if c.udts->fields[fi].name = fs->name then
            off = c.udts->fields[fi].offset
            bitOff = c.udts->fields[fi].bitOffset
            bitWidth = c.udts->fields[fi].bitWidth
            got = true
            exit for
        end if
    next
    if (got = false) orelse (bitWidth <= 0) then return false

    unitTy = LowerType( fs->type_, *c.types )
    if (unitTy = MT_VOID) orelse (unitTy = MT_AGG) then return false
    '' The unit widens to 64 bits by its DECLARED signedness. fbc writes
    '' '(int64)*(uint32*)&A', which zero-extends; sign-extending a ULONG unit whose
    '' top bit is set drags ones down into the shift.
    unitUnsigned = IsUnsignedType( c, fs->type_ )

    dim as MirInst fa
    fa.op = cast( ushort, M_FIELD_ADDR )
    fa.ty = cast( ubyte, MT_PTR )
    fa.a = base_
    fa.imm = off
    addr = Emit( c, fa )
    return (addr.kind <> cast( ubyte, MV_NONE ))
end function

'' Read a bitfield. Measured from fbc's own C, for a 3-bit field at bit 1:
''
''     V = (int32)((uint64)((int64)*(int32*)&T >> (1ll & 63ll)) & 7ull);
''
'' Widen the unit to 64 bits, shift the field down, mask it -- and NO SIGN EXTENSION,
'' even for a signed declared type: fbc reads a 3-bit 'as long' holding all ones as 7,
'' not as -1. Measured, not assumed; it is the one part of this a C habit gets wrong.
function LowerBitfieldRead _
    ( byref c as Ctx, byval id as Fbx.NodeId, byref outv as MirValue ) as boolean

    dim as MirValue addr
    dim as long bitOff, bitWidth
    dim as MirType unitTy
    dim as boolean unitUns
    if BitfieldParts( c, id, addr, bitOff, bitWidth, unitTy, unitUns ) = false then
        return false
    end if

    dim as MirValue raw = LowerExprLoad( c, addr, unitTy )
    if raw.kind = cast( ubyte, MV_NONE ) then return false
    dim as MirValue wide = Coerce( c, raw, MT_I64, unitUns )

    if bitOff > 0 then
        dim as MirInst sh
        sh.op = cast( ushort, M_ASHR )
        sh.ty = cast( ubyte, MT_I64 )
        sh.a = wide
        sh.b = ConstInt( c, bitOff, MT_I64 )
        wide = Emit( c, sh )
        if wide.kind = cast( ubyte, MV_NONE ) then return false
    end if

    dim as MirInst an
    an.op = cast( ushort, M_AND )
    an.ty = cast( ubyte, MT_I64 )
    an.a = wide
    an.b = ConstInt( c, BitMask_( bitWidth ), MT_I64 )
    dim as MirValue masked = Emit( c, an )
    if masked.kind = cast( ubyte, MV_NONE ) then return false

    outv = Coerce( c, masked, unitTy )
    return true
end function

'' Write a bitfield: read the unit, clear the field's bits, or the value in, store back.
''
''     *(uint32*)&A = (uint32)((uint64)((int64)*(uint32*)&A & -15ll) | 10ull);
''
'' -15 is the complement of (7 shl 1) -- the mask for a 3-bit field at bit 1 -- and 10
'' is (5 and 7) shl 1, which fbc has constant-folded. The read-modify-write is what
'' keeps the neighbours packed in the same unit intact, and is the whole reason an
'' ordinary full-width store could not be used here.
function LowerBitfieldStore _
    ( byref c as Ctx, byval id as Fbx.NodeId, byval value as Fbx.NodeId ) as boolean

    dim as MirValue addr
    dim as long bitOff, bitWidth
    dim as MirType unitTy
    dim as boolean unitUns
    if BitfieldParts( c, id, addr, bitOff, bitWidth, unitTy, unitUns ) = false then
        return false
    end if

    dim as MirValue val = LowerExpr( c, value )
    if val.kind = cast( ubyte, MV_NONE ) then return false
    val = Coerce( c, val, MT_I64, IsUnsignedType( c, c.info->TypeOf_( value ) ) )

    dim as MirValue raw = LowerExprLoad( c, addr, unitTy )
    if raw.kind = cast( ubyte, MV_NONE ) then return false
    dim as MirValue wide = Coerce( c, raw, MT_I64, unitUns )

    dim as longint mask = BitMask_( bitWidth )

    dim as MirInst cl
    cl.op = cast( ushort, M_AND )
    cl.ty = cast( ubyte, MT_I64 )
    cl.a = wide
    cl.b = ConstInt( c, not (mask shl bitOff), MT_I64 )
    dim as MirValue cleared = Emit( c, cl )
    if cleared.kind = cast( ubyte, MV_NONE ) then return false

    dim as MirInst vm
    vm.op = cast( ushort, M_AND )
    vm.ty = cast( ubyte, MT_I64 )
    vm.a = val
    vm.b = ConstInt( c, mask, MT_I64 )
    dim as MirValue vmasked = Emit( c, vm )
    if vmasked.kind = cast( ubyte, MV_NONE ) then return false

    if bitOff > 0 then
        dim as MirInst sh
        sh.op = cast( ushort, M_SHL )
        sh.ty = cast( ubyte, MT_I64 )
        sh.a = vmasked
        sh.b = ConstInt( c, bitOff, MT_I64 )
        vmasked = Emit( c, sh )
        if vmasked.kind = cast( ubyte, MV_NONE ) then return false
    end if

    dim as MirInst orr
    orr.op = cast( ushort, M_OR )
    orr.ty = cast( ubyte, MT_I64 )
    orr.a = cleared
    orr.b = vmasked
    dim as MirValue merged = Emit( c, orr )
    if merged.kind = cast( ubyte, MV_NONE ) then return false

    dim as MirInst st
    st.op = cast( ushort, M_STORE )
    st.ty = cast( ubyte, MT_VOID )
    st.a = addr
    st.b = Coerce( c, merged, unitTy )
    Emit( c, st )
    return true
end function

end namespace
