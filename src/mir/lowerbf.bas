'' lowerbf.bas -- BITFIELDS: reading one, writing one, and the compound form.
''
'' Split out of lowerintr.bas at the 1500-line lint cap. A bitfield is bits inside a
'' unit its neighbours share, so it has no address of its own: every access is a read
'' of the whole unit, a shift and a mask.

#include once "mir/lowerctx.bi"

namespace Tko.Mir

'' Declared in lowerctx.bi now that SWAP needs it too.
declare function BitfieldStoreParts_ _
    ( byref c as Ctx, byref addr as MirValue, byval bitOff as long, _
      byval bitWidth as long, byval unitTy as MirType, byval unitUns as boolean, _
      byref val as MirValue ) as boolean

'' The unit is addressed at the field's byte offset and read at the field's DECLARED
'' type -- which is what sizes the unit, not what sizes the field.
function BitfieldParts _
    ( byref c as Ctx, byval id as Tko.NodeId, byref addr as MirValue, _
      byref bitOff as long, byref bitWidth as long, byref unitTy as MirType, _
      byref unitUnsigned as boolean ) as boolean

    if c.ast->Kind( id ) <> Tko.N_MEMBER then return false
    dim as Tko.SymbolId fsym = c.info->RefOf( id )
    dim as Tko.Symbol ptr fs = c.syms->SymbolAt( fsym )
    if fs = 0 then return false
    if (fs->flags and Tko.SYMF_BITFIELD) = 0 then return false

    dim as Tko.BinaryPayload ptr mp = _
        @c.ast->binaries[cast( long, c.ast->nodes[cast( long, id )].data )]
    dim as Tko.TypeId bt = c.info->TypeOf_( mp->lhs )
    dim as MirValue base_
    if bt <> Tko.TYPE_NONE then
        if c.types->Kind( bt ) = Tko.TK_POINTER then
            base_ = LowerExpr( c, mp->lhs )
            bt = c.types->Inner( bt )
        else
            base_ = LowerAddr( c, mp->lhs )
        end if
    end if
    if base_.kind = cast( ubyte, MV_NONE ) then return false

    dim as long ui = c.udts->Find( bt )
    if ui < 0 then return false
    dim as long off = 0, uOff = 0, uLen = 0
    dim as boolean got = false
    for i as long = 0 to c.udts->udts[ui].count - 1
        dim as long fi = c.udts->udts[ui].first + i
        if c.udts->fields[fi].name = fs->name then
            off = c.udts->fields[fi].offset
            bitOff = c.udts->fields[fi].bitOffset
            bitWidth = c.udts->fields[fi].bitWidth
            uOff = c.udts->fields[fi].unitOffset
            uLen = c.udts->fields[fi].unitBytes
            got = true
            exit for
        end if
    next
    if (got = false) orelse (bitWidth <= 0) then return false

    unitTy = LowerType( fs->type_, *c.types )
    if (unitTy = MT_VOID) orelse (unitTy = MT_AGG) then return false

    '' THE UNIT IS ADDRESSED AT ITS OWN START, not at the field's byte: reading a
    '' four-byte unit from byte 1 of a four-byte structure runs one byte past it, and
    '' writing it rewrites whatever follows. fbc addresses the unit and shifts.
    '' THE RUN'S OWN UNIT when the layout recorded one: the field's type at its aligned
    '' byte cannot hold 'b' in 'ulong a:5, ushort b:12', nor 'd' in 'field=1 : ubyte
    '' a:7, ushort d:10' -- 4095 read back 127 and 1023 read 255.
    dim as long usz = c.types->Layout( fs->type_ ).size
    if (uLen = 1) orelse (uLen = 2) orelse (uLen = 4) orelse (uLen = 8) then
        bitOff += (off - uOff) * 8
        off = uOff
        select case uLen
        case 1 : unitTy = MT_I8
        case 2 : unitTy = MT_I16
        case 4 : unitTy = MT_I32
        case else : unitTy = MT_I64
        end select
    elseif usz > 0 then
        dim as long unitStart = (off \ usz) * usz
        bitOff += (off - unitStart) * 8
        off = unitStart
    end if
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
    ( byref c as Ctx, byval id as Tko.NodeId, byref outv as MirValue ) as boolean

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

    '' A BOOLEAN BITFIELD READS AS A BOOLEAN: set, it is -1, not 1. 'a : 1 as boolean' then
    '' 'x.a = true' and 'dim k as integer = x.a' gave 1, '( x.a = true )' gave 0 and 'if
    '' x.a = -1' was not taken; fbc says -1 to all three. The bit is negated.
    dim as Tko.Symbol ptr bfs = c.syms->SymbolAt( c.info->RefOf( id ) )
    if bfs <> 0 then
        dim as Tko.TypeId bft = c.types->Unqualify( bfs->type_ )
        if c.types->Kind( bft ) = Tko.TK_BUILTIN then
            if c.types->BuiltinOf( bft ) = Tko.TY_BOOLEAN then
                dim as MirInst ng
                ng.op = cast( ushort, M_NEG )
                ng.ty = cast( ubyte, MT_I64 )
                ng.a = masked
                masked = Emit( c, ng )
                if masked.kind = cast( ubyte, MV_NONE ) then return false
            end if
        end if
    end if

    '' At the NODE's type, which Check makes UINTEGER for every bitfield -- not at the
    '' unit's. The masked value is never negative, so the widening is exact.
    dim as MirType rty = LowerType( c.info->TypeOf_( id ), *c.types )
    if (rty = MT_VOID) orelse (rty = MT_AGG) then rty = unitTy
    outv = Coerce( c, masked, rty )
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
'' 'x.a op= v' OVER A BITFIELD: read it, apply the operator, write it back through the
'' masked store the plain assignment already uses.
function BitfieldCompound_ _
    ( byref c as Ctx, byval target as Tko.NodeId, byval value as Tko.NodeId, _
      byval bop as Tko.TokenKind ) as boolean

    dim as MirValue probe
    dim as long bo, bw
    dim as MirType ut
    dim as boolean uu
    if BitfieldParts( c, target, probe, bo, bw, ut, uu ) = false then return false

    '' The READ is the ordinary one, and the arithmetic happens in it: a bitfield is
    '' never wider than its declared type, so the unit's type is the working type.
    dim as MirValue cur
    if LowerBitfieldRead( c, target, cur ) = false then return false
    dim as MirValue rhs = LowerExpr( c, value )
    if rhs.kind = cast( ubyte, MV_NONE ) then return false
    dim as boolean uns = IsUnsignedType( c, c.info->TypeOf_( target ) )
    cur = Coerce( c, cur, MT_I64, uns )
    rhs = CoerceTy( c, rhs, MT_I64, c.info->TypeOf_( value ))

    dim as MirValue res
    if (bop = Tko.KW_IMP) orelse (bop = Tko.KW_EQV) then
        res = EmitImpEqv_( c, bop, MT_I64, cur, rhs )
    else
        dim as MirOp mop = BinOpFor( bop, MT_I64, uns )
        if mop = M_NONE then return false
        dim as MirInst bi
        bi.op = cast( ushort, mop )
        bi.ty = cast( ubyte, MT_I64 )
        bi.a = cur
        bi.b = rhs
        res = Emit( c, bi )
    end if
    if res.kind = cast( ubyte, MV_NONE ) then return false
    return LowerBitfieldStoreValue_( c, target, res )
end function

function LowerBitfieldStore _
    ( byref c as Ctx, byval id as Tko.NodeId, byval value as Tko.NodeId ) as boolean

    dim as MirValue addr
    dim as long bitOff, bitWidth
    dim as MirType unitTy
    dim as boolean unitUns
    if BitfieldParts( c, id, addr, bitOff, bitWidth, unitTy, unitUns ) = false then
        return false
    end if

    dim as MirValue val = LowerExpr( c, value )
    if val.kind = cast( ubyte, MV_NONE ) then return false
    val = CoerceTy( c, val, MT_I64, c.info->TypeOf_( value ))
    return BitfieldStoreParts_( c, addr, bitOff, bitWidth, unitTy, unitUns, val )
end function

'' The same store from a VALUE that is already lowered, which is what the compound
'' form has: it has read the field and applied the operator itself.
function LowerBitfieldStoreValue_ _
    ( byref c as Ctx, byval id as Tko.NodeId, byref val as MirValue ) as boolean

    dim as MirValue addr
    dim as long bitOff, bitWidth
    dim as MirType unitTy
    dim as boolean unitUns
    if BitfieldParts( c, id, addr, bitOff, bitWidth, unitTy, unitUns ) = false then
        return false
    end if
    return BitfieldStoreParts_( c, addr, bitOff, bitWidth, unitTy, unitUns, val )
end function

private function BitfieldStoreParts_ _
    ( byref c as Ctx, byref addr as MirValue, byval bitOff as long, _
      byval bitWidth as long, byval unitTy as MirType, byval unitUns as boolean, _
      byref val as MirValue ) as boolean

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
