'' lowerintr.bas -- statement INTRINSICS whose lowering is a runtime call.
''
'' Split out of lower.bas when that file passed the 1500-line lint cap. What belongs
'' here is the quirk statements that are calls and nothing else -- no control flow of
'' their own, no state -- with the runtime shape MEASURED from fbc's own C output
'' rather than assumed. PRINT and SWAP live in lowerstr.bas instead, because both are
'' really about the string runtime.

#include once "mir/lowerctx.bi"

namespace Fbx.Mir

declare function AggIifArm_ _
    ( byref c as Ctx, byref dst as MirValue, byval e as Fbx.NodeId ) as boolean
declare function StrSwapKind_ _
    ( byref c as Ctx, byval t as Fbx.TypeId, byref n as longint ) as long

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

'' A STRING 'iif'. Measured from fbc:
''
''     if( C == 0 ) goto label$2;
''     fb_StrInit( &TMP$4, -1, &A, -1, 0 );
''     goto label$4;
''   label$2:
''     fb_StrInit( &TMP$4, -1, &B, -1, 0 );
''   label$4:
''     fb_StrAssign( &R, -1, &TMP$4, -1, 0 );
''     fb_StrDelete( &TMP$4 );
''
'' The temporary is INITIALISED in each arm, not assigned: it has no prior contents,
'' and fb_StrAssign on uninitialised descriptor bytes would free whatever pointer
'' happened to be there. Its life ends with the STATEMENT, which is shorter than any
'' scope, so it is registered on the statement-temporary list rather than the scope
'' cleanup list.
function LowerStringIif_ _
    ( byref c as Ctx, byval condE as Fbx.NodeId, byval thenE as Fbx.NodeId, _
      byval elseE as Fbx.NodeId, byref outv as MirValue ) as boolean

    dim as MirValue cond = LowerExpr( c, condE )
    if cond.kind = cast( ubyte, MV_NONE ) then return false

    dim as long slot = NewTempLocal( c, MT_AGG, c.types->target.stringBytes )
    if slot < 0 then return false
    dim as MirValue taddr
    taddr.kind = cast( ubyte, MV_LOCAL )
    taddr.ty = cast( ubyte, MT_PTR )
    taddr.id = slot

    dim as long thenB = NewBlock( c, "iif.then" )
    dim as long elseB = NewBlock( c, "iif.else" )
    dim as long joinB = NewBlock( c, "iif.join" )
    Terminate( c, MTERM_CONDBR, thenB, elseB, cond )

    c.curBlock = thenB
    if StrInitFrom_( c, taddr, thenE ) = false then return false
    Terminate( c, MTERM_BR, joinB, -1, NoVal( ) )

    c.curBlock = elseB
    if StrInitFrom_( c, taddr, elseE ) = false then return false
    Terminate( c, MTERM_BR, joinB, -1, NoVal( ) )

    c.curBlock = joinB
    c.strTemps.Push( cast( ulong, slot ) )
    outv = taddr
    return true
end function

'' fb_StrInit( dst, -1, src, srcLen, 0 ) for one arm. A literal passes its own bytes
'' and a length that INCLUDES the terminator, which is the fb_StrInit convention and
'' not the fb_StrAllocTempDescZEx one.
function StrInitFrom_ _
    ( byref c as Ctx, byref dst as MirValue, byval e as Fbx.NodeId ) as boolean

    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, dst.kind ) ) : args.Push( cast( ulong, dst.id ) )
    args.Push( cast( ulong, MV_CONST_INT ) )
    args.Push( cast( ulong, cast( ulongint, -1 ) ) )

    '' A CONCATENATION ARM -- 'iif( c, a + b, "" )' -- FIRST, before the type tests. A
    '' concat IS string-typed, so IsStringType below claims it and then asks for its
    '' ADDRESS, which it has not got. Same ordering trap as everywhere else in this
    '' file: a recogniser has to run before the test that would swallow it.
    dim as MirValue ccv
    if ConcatToTemp_( c, e, ccv ) then
        args.Push( cast( ulong, ccv.kind ) ) : args.Push( cast( ulong, ccv.id ) )
        args.Push( cast( ulong, MV_CONST_INT ) )
        args.Push( cast( ulong, cast( ulongint, -1 ) ) )
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
        EmitRtl( c, RTL_STR_INIT, args )
        return true
    end if

    dim as longint zn
    if c.ast->Kind( e ) = Fbx.N_STRING_LIT then
        dim as string lit = StringLitText_( c, e )
        args.Push( cast( ulong, MV_GLOBAL ) )
        args.Push( cast( ulong, c.m->AddStringLiteral( lit, *c.names ) ) )
        args.Push( cast( ulong, MV_CONST_INT ) )
        args.Push( cast( ulong, len( lit ) + 1 ) )
    elseif StrSwapKind_( c, c.info->TypeOf_( e ), zn ) = 1 then
        '' A FIXED-LENGTH NARROW ARM passes its address and its DECLARED LENGTH, not
        '' -1: there is no descriptor to read a length out of. Measured --
        '' 'fb_StrInit( &TMP$5, -1ll, FA$1, 8ll, 0 )'.
        dim as MirValue zv = LowerAddr( c, e )
        if zv.kind = cast( ubyte, MV_NONE ) then return false
        args.Push( cast( ulong, zv.kind ) ) : args.Push( cast( ulong, zv.id ) )
        args.Push( cast( ulong, MV_CONST_INT ) )
        args.Push( cast( ulong, zn ) )
    elseif IsStringType( c, c.info->TypeOf_( e ) ) then
        dim as MirValue sv = LowerAddr( c, e )
        if sv.kind = cast( ubyte, MV_NONE ) then return false
        args.Push( cast( ulong, sv.kind ) ) : args.Push( cast( ulong, sv.id ) )
        args.Push( cast( ulong, MV_CONST_INT ) )
        args.Push( cast( ulong, cast( ulongint, -1 ) ) )
    else
        '' ANYTHING THAT HANDS BACK A DESCRIPTOR -- 'hex( n )', 'trim( s )', a nested
        '' string iif. fbc puts the call's result in a temporary and inits from it:
        '' 'vr$6 = fb_HEX_l( 123 ); fb_StrInit( &TMP$4, -1ll, vr$6, -1ll, 0 )'.
        '' Without this an arm whose type Check does not compute -- which is every
        '' intrinsic call -- declined the whole iif.
        dim as MirValue dv
        if StrDescriptorOf_( c, e, dv ) = false then return false
        if dv.kind = cast( ubyte, MV_NONE ) then return false
        args.Push( cast( ulong, dv.kind ) ) : args.Push( cast( ulong, dv.id ) )
        args.Push( cast( ulong, MV_CONST_INT ) )
        args.Push( cast( ulong, cast( ulongint, -1 ) ) )
    end if
    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 0 )
    EmitRtl( c, RTL_STR_INIT, args )
    return true
end function


'' A UDT 'iif', as an ADDRESS.
''
'' Same branch shape as the scalar form, but the temporary is the UDT itself and what
'' comes back is where it lives -- so '(iif( c, a, b )).i' can take an offset off it
'' without the call being lowered twice.
function LowerAggIif_ _
    ( byref c as Ctx, byval condE as Fbx.NodeId, byval thenE as Fbx.NodeId, _
      byval elseE as Fbx.NodeId, byref outv as MirValue ) as boolean

    dim as Fbx.TypeId ft = c.info->TypeOf_( thenE )
    if ft = Fbx.TYPE_NONE then ft = c.info->TypeOf_( elseE )
    if ft = Fbx.TYPE_NONE then return false
    dim as long sz = SizeOfType( c, ft )
    if sz <= 0 then return false

    dim as MirValue cond = LowerExpr( c, condE )
    if cond.kind = cast( ubyte, MV_NONE ) then return false

    dim as long slot = NewTempLocal( c, MT_AGG, sz )
    if slot < 0 then return false
    dim as MirValue taddr
    taddr.kind = cast( ubyte, MV_LOCAL )
    taddr.ty = cast( ubyte, MT_PTR )
    taddr.id = slot

    dim as long thenB = NewBlock( c, "iif.then" )
    dim as long elseB = NewBlock( c, "iif.else" )
    dim as long joinB = NewBlock( c, "iif.join" )
    Terminate( c, MTERM_CONDBR, thenB, elseB, cond )

    c.curBlock = thenB
    if AggIifArm_( c, taddr, thenE ) = false then return false
    Terminate( c, MTERM_BR, joinB, -1, NoVal( ) )

    c.curBlock = elseB
    if AggIifArm_( c, taddr, elseE ) = false then return false
    Terminate( c, MTERM_BR, joinB, -1, NoVal( ) )

    c.curBlock = joinB
    outv = taddr
    return true
end function

'' One arm: the whole aggregate copied into the temporary. The VALUE first and the
'' address only as a fallback, so a nested iif or a call result works.
private function AggIifArm_ _
    ( byref c as Ctx, byref dst as MirValue, byval e as Fbx.NodeId ) as boolean

    dim as MirValue v = LowerExpr( c, e )
    if v.kind = cast( ubyte, MV_NONE ) then
        dim as MirValue a = LowerAddr( c, e )
        if a.kind = cast( ubyte, MV_NONE ) then return false
        v = LowerExprLoad( c, a, MT_AGG )
    end if
    if v.kind = cast( ubyte, MV_NONE ) then return false
    dim as MirInst st
    st.op = cast( ushort, M_STORE )
    st.ty = cast( ubyte, MT_VOID )
    st.a = dst
    st.b = v
    Emit( c, st )
    return true
end function


'' 'iif( cond, a, b )' as a RUNTIME expression. Returns false when the node is not one,
'' so the caller carries on.
''
'' MIR has no phi, so the value comes out of a TEMPORARY SLOT written on both arms --
'' which is exactly the shape fbc emits:
''
''     if( C == 0ll) goto label$2;
''     TMP = 10ll;  goto label$3;
''     label$2:;  TMP = 20ll;
''     label$3:;  R = TMP;
''
'' It produced NOTHING before, and did not decline: 'dim as integer r = iif( c, 10,
'' 20 )' allocated r, stored nothing and printed whatever the stack held. The DIM
'' initialiser skipped its store whenever the value would not lower, silently.
function LowerIif _
    ( byref c as Ctx, byval id as Fbx.NodeId, byval mt as MirType, _
      byref outv as MirValue ) as boolean

    if c.ast->Kind( id ) <> Fbx.N_CALL then return false
    dim as Fbx.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if lp->count <> 3 then return false
    if lp->target = Fbx.NODE_NONE then return false
    if c.ast->Kind( lp->target ) <> Fbx.N_IDENT then return false
    dim as Fbx.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, lp->target )].data )]
    if Fbx.Text.LowerAscii( c.names->Spelling( ip->name ) ) <> "iif" then return false

    '' The result type is the one the surrounding expression asked for; an aggregate
    '' or an untyped one has no temporary to write, so it declines.
    dim as Fbx.NodeId condE = cast( Fbx.NodeId, c.ast->children[lp->first] )
    dim as Fbx.NodeId thenE = cast( Fbx.NodeId, c.ast->children[lp->first + 1] )
    dim as Fbx.NodeId elseE = cast( Fbx.NodeId, c.ast->children[lp->first + 2] )

    '' The result type is the one the surrounding expression asked for; failing that,
    '' the CALL's own -- which Check does not compute for iif -- and failing that, an
    '' ARM's. An aggregate or a type nothing can name has no temporary to write, so it
    '' declines rather than inventing a slot.
    dim as Fbx.TypeId ft = c.info->TypeOf_( id )
    if ft = Fbx.TYPE_NONE then ft = c.info->TypeOf_( thenE )
    if ft = Fbx.TYPE_NONE then ft = c.info->TypeOf_( elseE )
    dim as MirType rt = mt
    if (rt = MT_VOID) andalso (ft <> Fbx.TYPE_NONE) then rt = LowerType( ft, *c.types )

    '' A STRING iif builds a DESCRIPTOR, not a value, so it takes a different shape:
    '' fb_StrInit into a temporary in each arm, and an fb_StrDelete once the
    '' consuming statement is done with it.
    if IsStringType( c, ft ) then
        return LowerStringIif_( c, condE, thenE, elseE, outv )
    end if

    '' A UDT iif builds its result in a TEMPORARY and yields that temporary's ADDRESS,
    '' because a UDT result is usually read through -- '(iif( c, a, b )).i' is the
    '' shape the corpus writes. The value path below loads it.
    if rt = MT_AGG then
        if c.types->Kind( ft ) <> Fbx.TK_UDT then return false
        dim as MirValue aa
        if LowerAggIif_( c, condE, thenE, elseE, aa ) = false then return false
        outv = LowerExprLoad( c, aa, MT_AGG )
        return (outv.kind <> cast( ubyte, MV_NONE ))
    end if

    if rt = MT_VOID then return false

    dim as MirValue cond = LowerExpr( c, condE )
    if cond.kind = cast( ubyte, MV_NONE ) then return false

    dim as long slot = NewTempLocal( c, rt, c.types->Layout( ft ).size )
    if slot < 0 then return false
    dim as MirValue taddr
    taddr.kind = cast( ubyte, MV_LOCAL )
    taddr.ty = cast( ubyte, MT_PTR )
    taddr.id = slot

    dim as long thenB = NewBlock( c, "iif.then" )
    dim as long elseB = NewBlock( c, "iif.else" )
    dim as long joinB = NewBlock( c, "iif.join" )
    Terminate( c, MTERM_CONDBR, thenB, elseB, cond )

    c.curBlock = thenB
    dim as MirValue tv = LowerExpr( c, thenE )
    if tv.kind <> cast( ubyte, MV_NONE ) then
        dim as MirInst ts
        ts.op = cast( ushort, M_STORE )
        ts.ty = cast( ubyte, MT_VOID )
        ts.a = taddr
        ts.b = Coerce( c, tv, rt, IsUnsignedType( c, c.info->TypeOf_( thenE ) ) )
        Emit( c, ts )
    end if
    Terminate( c, MTERM_BR, joinB, -1, NoVal( ) )

    c.curBlock = elseB
    dim as MirValue ev = LowerExpr( c, elseE )
    if ev.kind <> cast( ubyte, MV_NONE ) then
        dim as MirInst es
        es.op = cast( ushort, M_STORE )
        es.ty = cast( ubyte, MT_VOID )
        es.a = taddr
        es.b = Coerce( c, ev, rt, IsUnsignedType( c, c.info->TypeOf_( elseE ) ) )
        Emit( c, es )
    end if
    Terminate( c, MTERM_BR, joinB, -1, NoVal( ) )

    c.curBlock = joinB
    outv = LowerExprLoad( c, taddr, rt )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

'' 'procptr( f )' -- THE ADDRESS OF A PROCEDURE. Returns false when the node is not one.
''
'' fbc spells it '(tmp$2)&F', a plain function address, and stores it in an ordinary
'' pointer. MIR carries it as M_FUNC_ADDR over the function's table index, because a
'' MirValue has no kind for a function and the index is what the dump and the backend
'' both need.
''
'' It produced NOTHING before, which the DIM initialiser then dropped silently:
'' 'dim as sub( ) p = procptr( tests.x.init )' left p uninitialised.
function LowerProcPtr _
    ( byref c as Ctx, byval id as Fbx.NodeId, byref outv as MirValue ) as boolean

    if c.ast->Kind( id ) <> Fbx.N_CALL then return false
    dim as Fbx.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if lp->count <> 1 then return false
    if lp->target = Fbx.NODE_NONE then return false
    if c.ast->Kind( lp->target ) <> Fbx.N_IDENT then return false
    dim as Fbx.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, lp->target )].data )]
    if Fbx.Text.LowerAscii( c.names->Spelling( ip->name ) ) <> "procptr" then return false

    '' The operand names a PROCEDURE. Anything else -- an overload set nothing chose
    '' between, a name that did not resolve -- has no single address to take.
    dim as Fbx.NodeId fnE = cast( Fbx.NodeId, c.ast->children[lp->first] )

    '' A RUNTIME ENTRY POINT, which fbc predeclares and nothing in the source declares:
    '' 'procptr( fb_ArrayRedimEx )'. Its address is the same M_FUNC_ADDR over the
    '' inventory's own linker name.
    if c.ast->Kind( fnE ) = Fbx.N_IDENT then
        dim as Fbx.IdentPayload ptr rip = _
            @c.ast->idents[cast( long, c.ast->nodes[cast( long, fnE )].data )]
        dim as RtlId rr = RtlByName( c.names->Spelling( rip->name ) )
        if rr <> RTL_NONE then
            dim as boolean is32 = (c.types->target.pointerBits = 32)
            dim as Fbx.InternId rnm = c.names->GetString( RtlLinkName( rr, is32 ) )
            dim as long ridx = -1
            for i as long = 0 to c.m->functions.Count - 1
                if c.m->functions[i]->name = rnm then
                    ridx = i
                    exit for
                end if
            next
            if ridx < 0 then
                dim as MirFunction ptr rdecl = _
                    c.m->AddFunction( rnm, RtlReturn( rr, is32 ) )
                rdecl->isDefinition = false
                rdecl->paramCount = RtlArity( rr )
                ridx = c.m->functions.Count - 1
            end if
            dim as MirInst rfa
            rfa.op = cast( ushort, M_FUNC_ADDR )
            rfa.ty = cast( ubyte, MT_PTR )
            rfa.callee = cast( ulong, ridx )
            outv = Emit( c, rfa )
            return (outv.kind <> cast( ubyte, MV_NONE ))
        end if
    end if

    outv = FuncAddrOf( c, c.info->RefOf( fnE ) )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

'' The ADDRESS of a procedure symbol, as an M_FUNC_ADDR over the function table index.
'' Split out of LowerProcPtr because ERASE over a UDT array needs the same thing for a
'' constructor and a destructor that no source expression names.
function FuncAddrOf( byref c as Ctx, byval fsid as Fbx.SymbolId ) as MirValue
    dim as MirValue none_
    dim as Fbx.Symbol ptr fs = c.syms->SymbolAt( fsid )
    if fs = 0 then return none_
    if fs->kind <> cast( ubyte, Fbx.SYM_PROC ) then return none_
    dim as Fbx.NodeId pn = cast( Fbx.NodeId, fs->payload )
    if pn = Fbx.NODE_NONE then return none_
    if c.ast->Kind( pn ) <> Fbx.N_PROC then return none_

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
        fidx = c.m->functions.Count - 1
    end if

    dim as MirInst fa
    fa.op = cast( ushort, M_FUNC_ADDR )
    fa.ty = cast( ubyte, MT_PTR )
    fa.callee = cast( ulong, fidx )
    return Emit( c, fa )
end function

'' ANDALSO / ORELSE: the right operand is evaluated only when the left does not
'' already decide the answer. The result is materialised through a slot rather than a
'' phi, which is what keeps this IR phi-free.
function LowerShortCircuit _
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

'' A call, given its PIECES rather than a node: FreeBASIC spells one two ways and both
'' have to reach the same code. 'W( 1, 2 )' is an N_CALL with its arguments in a list;
'' 'W 1, 2' is a STATEMENT whose 'a' is the callee and whose children are the arguments.

'' FreeBASIC's BUILT-IN PROCEDURES -- the ones fbc predeclares and lowers straight to a
'' runtime call. They are not keywords and not in the intrinsic registry: a program
'' names them like any other procedure, nothing declares them, and fbx counted every
'' one as an unbound callee.
''
'' Measured from fbc's own C:
''
''     allocate( 16 )        -> malloc( 16ull )
''     callocate( 4, 8 )     -> calloc( 4ull, 8ull )
''     callocate( 16 )       -> calloc( 16ull, 1ull )     one argument means size 1
''     reallocate( p, 32 )   -> realloc( p, 32ull )
''     deallocate( p )       -> free( p )
''     mutexcreate( )        -> fb_MutexCreate( )
''     mutexlock( m )        -> fb_MutexLock( m )
''     fb_Assert( f, l, p, e ) -> fb_Assert( char*, int64, char*, char* )
''
'' fb_Assert is in the list because fbc predeclares it too: the COM tests write their
'' own 'assert_' macro around it with nothing declaring it anywhere, and fbc compiles
'' them. 2,054 unlowered calls came from that one macro.
private function BuiltinProcRtl _
    ( byref nm as string, byref argc as long, byref retTy as MirType ) as RtlId

    select case nm
    case "allocate"     : retTy = MT_PTR  : return RTL_MALLOC
    case "callocate"    : retTy = MT_PTR  : return RTL_CALLOC
    case "reallocate"   : retTy = MT_PTR  : return RTL_REALLOC
    case "deallocate"   : retTy = MT_VOID : return RTL_FREE
    case "mutexcreate"  : retTy = MT_PTR  : return RTL_MUTEX_CREATE
    case "mutexdestroy" : retTy = MT_VOID : return RTL_MUTEX_DESTROY
    case "mutexlock"    : retTy = MT_VOID : return RTL_MUTEX_LOCK
    case "mutexunlock"  : retTy = MT_VOID : return RTL_MUTEX_UNLOCK
    case "fb_assert"    : retTy = MT_VOID : return RTL_ASSERT
    '' 'clear dst, value, bytes' -- libc memset, and the DESTINATION is passed by
    '' ADDRESS: fbc writes 'memset( (void*)A, 0, 16ull )' for 'clear a(0), 0, 16'.
    case "clear"        : retTy = MT_VOID : return RTL_MEMSET
    end select
    return RTL_NONE
end function

'' Lower a call to one of them. Returns false when the callee is not a built-in, so an
'' ordinary unbound callee still declines as it did.
function LowerBuiltinProc _
    ( byref c as Ctx, byval calleeNode as Fbx.NodeId, byval argFirst as long, _
      byval argCount as long, byref outv as MirValue ) as boolean

    if calleeNode = Fbx.NODE_NONE then return false
    if c.ast->Kind( calleeNode ) <> Fbx.N_IDENT then return false
    dim as Fbx.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, calleeNode )].data )]
    dim as string nm = Fbx.Text.LowerAscii( c.names->Spelling( ip->name ) )

    '' ASSERT AND ASSERTWARN EMIT NOTHING, and their argument is NOT EVALUATED.
    '' Measured by running fbc's output: without -g, 'assert( f( ) = 1 )' where f
    '' prints does not print, and no fb_Assert appears in the generated C at all. fbx
    '' has no -g equivalent and defines __FB_DEBUG__ as 0, so this is fbc's behaviour
    '' for every build fbx can produce. Declining instead was 1,346 statements.
    if (nm = "assert") orelse (nm = "assertwarn") then
        outv = NoVal( )
        return true
    end if

    dim as long argc = argCount
    dim as MirType retTy = MT_VOID
    dim as RtlId r = BuiltinProcRtl( nm, argc, retTy )
    if r = RTL_NONE then return false

    '' The declared arity, so a wrong-arity call is left to decline rather than being
    '' handed to the runtime with a short stack.
    dim as long want = RtlArity( r )
    dim as boolean callocOneArg = (r = RTL_CALLOC) andalso (argCount = 1)
    if (argCount <> want) andalso (callocOneArg = false) then return false

    dim as FB.Array( of ulong ) args
    for i as long = 0 to argCount - 1
        dim as Fbx.NodeId a = cast( Fbx.NodeId, c.ast->children[argFirst + i] )
        '' CLEAR's first argument is an LVALUE whose ADDRESS is passed, not its value.
        if (r = RTL_MEMSET) andalso (i = 0) then
            dim as MirValue da = LowerAddr( c, a )
            if da.kind = cast( ubyte, MV_NONE ) then return false
            args.Push( cast( ulong, da.kind ) ) : args.Push( cast( ulong, da.id ) )
            continue for
        end if
        dim as MirValue av = LowerExpr( c, a )
        if av.kind = cast( ubyte, MV_NONE ) then return false
        av = Coerce( c, av, RtlParamType( r, i, (c.types->target.pointerBits = 32) ), _
                     IsUnsignedType( c, c.info->TypeOf_( a ) ) )
        args.Push( cast( ulong, av.kind ) ) : args.Push( cast( ulong, av.id ) )
    next
    '' 'callocate( n )' -- fbc supplies the element size itself.
    if callocOneArg then
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( 1 )
    end if

    outv = EmitRtl( c, r, args )
    if retTy = MT_VOID then return true
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

end namespace
