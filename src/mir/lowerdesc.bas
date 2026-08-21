'' lowerdesc.bas -- the array descriptor, synthesised for a FIXED array, and ERASE.
''
'' See docs/internals/phase-6-array-descriptor.md for the measurements this implements.
'' The short version:
''
''     ptr   DATA          off 0    biased base: PTR - (lowest index tuple) * elemLen
''     ptr   PTR           off 8    the real base
''     ssize SIZE          off 16   total bytes
''     ssize ELEMENT_LEN   off 24
''     ssize DIMENSIONS    off 32
''     ssize FLAGS         off 40
''     DIMTB[n]            off 48   { ELEMENTS, LBOUND, UBOUND } each, dim 0 first
''
'' with every offset halved on win32. Total = 6*ptr + dims*3*ptr.
''
'' A FIXED array has no descriptor in memory: fbc synthesises one on the stack at the
'' array's DECLARATION point and passes that. fbx synthesises it at the point of USE
'' instead. That is a deliberate difference, and it is safe because the descriptor is
'' pure function of compile-time constants -- the bounds, the element size, and the
'' array's own address -- none of which can change between the two points.

#include once "lowerctx.bi"

namespace Fbx.Mir

using Fbx

declare function EraseOne_( byref c as Ctx, byval it as Fbx.NodeId ) as boolean
declare function PushStructorPtr_ _
    ( byref c as Ctx, byref args as FB.Array( of ulong ), _
      byval s as Fbx.SymbolId ) as boolean


'' The natural integer width of a descriptor field, which is the pointer width.
private function DescIntTy_( byref c as Ctx ) as MirType
    if c.types->target.pointerBits = 32 then return MT_I32
    return MT_I64
end function

private function DescPtrBytes_( byref c as Ctx ) as long
    return c.types->target.pointerBits \ 8
end function

'' Store 'v' into 'base + off'.
private sub DescStore_ _
    ( byref c as Ctx, byref base_ as MirValue, byval off as long, byref v as MirValue )

    dim as MirInst fa
    fa.op = cast( ushort, M_FIELD_ADDR )
    fa.ty = cast( ubyte, MT_PTR )
    fa.a = base_
    fa.imm = off
    dim as MirValue a = Emit( c, fa )

    dim as MirInst st
    st.op = cast( ushort, M_STORE )
    st.ty = cast( ubyte, MT_VOID )
    st.a = a
    st.b = v
    Emit( c, st )
end sub

private sub DescStoreConst_ _
    ( byref c as Ctx, byref base_ as MirValue, byval off as long, byval n as longint )

    dim as MirValue v = ConstInt( c, n, DescIntTy_( c ) )
    DescStore_( c, base_, off, v )
end sub


'' Synthesise a descriptor for a FIXED array and return its address.
''
'' 'arrAddr' is the array's own base address and 't' its TK_ARRAY type. Returns false
'' for anything that is not a fixed array with known bounds and a known element size --
'' a DYNAMIC array already has a descriptor and must not get a second one.
function SynthFixedArrayDesc _
    ( byref c as Ctx, byref arrAddr as MirValue, byval t as Fbx.TypeId, _
      byref outv as MirValue ) as boolean

    if c.types->Kind( t ) <> Fbx.TK_ARRAY then return false
    dim as long dims = c.types->types[cast( long, t )].dims
    if dims < 1 then return false                  '' -1 is dynamic

    dim as Fbx.TypeId et = c.types->types[cast( long, t )].inner
    if et = Fbx.TYPE_NONE then return false
    dim as long elemLen = SizeOfType( c, et )
    if elemLen <= 0 then return false

    dim as long first = c.types->types[cast( long, t )].first
    if c.types->types[cast( long, t )].count < dims * 2 then return false

    '' Per-dimension element counts, and the row-major offset of the LOWEST index
    '' tuple -- which is what DATA is biased by. fbc never subtracts an lbound when
    '' indexing, so the bias has to be baked in here or every access is off by it.
    dim as FB.Array( of longint ) lo
    dim as FB.Array( of longint ) hi
    dim as FB.Array( of longint ) nel
    dim as longint total = 1
    for d as long = 0 to dims - 1
        dim as longint l = c.types->boundPool[first + d * 2]
        dim as longint h = c.types->boundPool[first + d * 2 + 1]
        if h < l then return false
        lo.Push( l )
        hi.Push( h )
        nel.Push( h - l + 1 )
        total *= (h - l + 1)
    next

    dim as longint bias = 0
    for d as long = 0 to dims - 1
        if d > 0 then bias *= nel[d]
        bias += lo[d]
    next

    dim as long ptrBytes = DescPtrBytes_( c )
    dim as long descBytes = 6 * ptrBytes + dims * 3 * ptrBytes
    dim as long slot = NewTempLocal( c, MT_AGG, descBytes )
    dim as MirValue desc
    desc.kind = cast( ubyte, MV_LOCAL )
    desc.ty = cast( ubyte, MT_PTR )
    desc.id = slot

    '' DATA = base - bias * elemLen. A zero bias stores the base unchanged rather than
    '' emitting a subtract of nothing.
    dim as MirValue dataV = arrAddr
    if bias <> 0 then
        dim as MirInst pa
        pa.op = cast( ushort, M_PTR_ADD )
        pa.ty = cast( ubyte, MT_PTR )
        pa.a = arrAddr
        pa.b = ConstInt( c, -(bias * elemLen), DescIntTy_( c ) )
        dataV = Emit( c, pa )
    end if
    DescStore_( c, desc, 0, dataV )
    DescStore_( c, desc, ptrBytes, arrAddr )
    DescStoreConst_( c, desc, 2 * ptrBytes, total * elemLen )
    DescStoreConst_( c, desc, 3 * ptrBytes, elemLen )
    DescStoreConst_( c, desc, 4 * ptrBytes, dims )
    '' FLAGS. Measured 49 for one fixed dimension, 50 for two, 51 for three -- so
    '' 48 + dims. What the bits MEAN inside the runtime was not measured; these are
    '' the values fbc writes, reproduced rather than derived.
    DescStoreConst_( c, desc, 5 * ptrBytes, 48 + dims )

    for d as long = 0 to dims - 1
        dim as long b = 6 * ptrBytes + d * 3 * ptrBytes
        DescStoreConst_( c, desc, b, nel[d] )
        DescStoreConst_( c, desc, b + ptrBytes, lo[d] )
        DescStoreConst_( c, desc, b + 2 * ptrBytes, hi[d] )
    next

    outv = desc
    return true
end function


'' ERASE.
''
'' Five-way, measured, and the fixed-string row is the one that would have been got
'' wrong by analogy: 'erase' over a FIXED string array is fb_ArrayDestructStr, NOT
'' fb_ArrayClear. Verified by removing the erase and watching the call count fall from
'' two to one.
''
''     fixed   scalar / POD     fb_ArrayClear( d )
''     fixed   string           fb_ArrayDestructStr( d )
''     fixed   UDT w/ structor  fb_ArrayClearObj( d, ctor, dtor )
''     dynamic scalar / POD     fb_ArrayErase( d )
''     dynamic string           fb_ArrayStrErase( d )
''     dynamic UDT              fb_ArrayEraseObj( d, ctor, dtor )
''
'' Only the FIXED rows are lowered. A dynamic array has no descriptor in fbx yet -- its
'' declaration lowers to nothing at all -- so calling fb_ArrayErase on whatever a
'' dynamic array's slot happens to hold would hand the runtime a wild pointer. That
'' declines, loudly, rather than emitting something that looks right.
function LowerErase( byref c as Ctx, byval id as Fbx.NodeId ) as boolean
    dim as Fbx.StmtPayload ptr sp = StmtOf( c, id )
    if sp->count < 1 then return false

    for i as long = 0 to sp->count - 1
        dim as Fbx.NodeId it = cast( Fbx.NodeId, c.ast->children[sp->first + i] )
        if EraseOne_( c, it ) = false then return false
    next
    return true
end function

private function EraseOne_( byref c as Ctx, byval it as Fbx.NodeId ) as boolean
    dim as Fbx.TypeId t = c.info->TypeOf_( it )
    if t = Fbx.TYPE_NONE then return false
    if c.types->Kind( t ) <> Fbx.TK_ARRAY then return false
    if c.types->types[cast( long, t )].dims < 1 then return false      '' dynamic: see above

    dim as MirValue base_ = LowerAddr( c, it )
    if base_.kind = cast( ubyte, MV_NONE ) then return false
    dim as MirValue desc
    if SynthFixedArrayDesc( c, base_, t, desc ) = false then return false

    dim as Fbx.TypeId et = c.types->types[cast( long, t )].inner
    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, desc.kind ) ) : args.Push( cast( ulong, desc.id ) )

    '' A var-len STRING element is destructed, not cleared: its bytes are a descriptor
    '' the runtime owns.
    if IsStringType( c, et ) then
        EmitRtl( c, RTL_ARRAY_DESTRUCT_STR, args )
        return true
    end if

    '' A UDT gets ClearObj with its constructor and destructor, either of which may be
    '' null. Structors count whether they are written or implicit -- a UDT holding a
    '' string has both without either appearing in the source.
    if c.types->Kind( et ) = Fbx.TK_UDT then
        dim as Fbx.SymbolId ctor = StructorOf( c, et, "__ctor" )
        dim as Fbx.SymbolId dtor = StructorOf( c, et, "__dtor" )
        if (ctor <> Fbx.SYMBOL_NONE) orelse (dtor <> Fbx.SYMBOL_NONE) then
            if PushStructorPtr_( c, args, ctor ) = false then return false
            if PushStructorPtr_( c, args, dtor ) = false then return false
            EmitRtl( c, RTL_ARRAY_CLEAR_OBJ, args )
            return true
        end if
    end if

    EmitRtl( c, RTL_ARRAY_CLEAR, args )
    return true
end function

'' A structor's ADDRESS as an argument, or a null pointer when there is none.
private function PushStructorPtr_ _
    ( byref c as Ctx, byref args as FB.Array( of ulong ), _
      byval s as Fbx.SymbolId ) as boolean

    if s = Fbx.SYMBOL_NONE then
        args.Push( cast( ulong, MV_CONST_INT ) )
        args.Push( 0 )
        return true
    end if
    dim as MirValue fp = FuncAddrOf( c, s )
    if fp.kind = cast( ubyte, MV_NONE ) then return false
    args.Push( cast( ulong, fp.kind ) ) : args.Push( cast( ulong, fp.id ) )
    return true
end function

end namespace
