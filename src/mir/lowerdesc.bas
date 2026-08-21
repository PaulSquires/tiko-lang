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

declare function StrSwapKind_ _
    ( byref c as Ctx, byval t as Fbx.TypeId, byref n as longint ) as long
declare function EraseOne_( byref c as Ctx, byval it as Fbx.NodeId ) as boolean
declare function RedimOne_ _
    ( byref c as Ctx, byval id as Fbx.NodeId, byval item as Fbx.NodeId, _
      byval presv as boolean ) as boolean
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


'' WHETHER A UDT RETURN TRAVELS THROUGH AN EXPLICIT HIDDEN POINTER.
''
'' Measured, and it is not the rule the name suggests:
''
''     explicit sret  <==>  the type has a DESTRUCTOR or a COPY CONSTRUCTOR
''
'' declared, or implicit through a member or a base that has one. SIZE PLAYS NO PART:
'' a one-byte type with a destructor is sret, and a sixteen-byte POD is not.
'' 'operator let' does NOT force it -- only a destructor or a copy constructor does.
''
'' See docs/internals/phase-6-udt-return.md. The same rule on both targets: fbc makes a
'' TWO-valued frontend decision and leaves register-versus-memory to the C compiler,
'' which is the same division of labour fbx has with whatever consumes MIR.
function UsesSretReturn( byref c as Ctx, byval t as Fbx.TypeId ) as boolean
    if t = Fbx.TYPE_NONE then return false
    if c.types->Kind( t ) <> Fbx.TK_UDT then return false
    if StructorOf( c, t, "__dtor" ) <> Fbx.SYMBOL_NONE then return true
    '' A COPY CONSTRUCTOR is a constructor taking one argument of its own type. Any
    '' other one-argument constructor is a conversion, not a copy.
    dim as Fbx.SymbolId ctors = StructorOf( c, t, "__ctor" )
    dim as Fbx.SymbolId cur = ctors
    while cur <> Fbx.SYMBOL_NONE
        dim as Fbx.Symbol ptr s = c.syms->SymbolAt( cur )
        if s = 0 then exit while
        dim as Fbx.NodeId pn = cast( Fbx.NodeId, s->payload )
        if pn <> Fbx.NODE_NONE then
            if c.ast->Kind( pn ) = Fbx.N_PROC then
                dim as Fbx.StmtPayload ptr psp = StmtOf( c, pn )
                dim as long np = 0
                dim as Fbx.TypeId only = Fbx.TYPE_NONE
                for i as long = 0 to psp->count - 1
                    dim as Fbx.NodeId prm = cast( Fbx.NodeId, c.ast->children[psp->first + i] )
                    if c.ast->Kind( prm ) <> Fbx.N_PARAM then continue for
                    np += 1
                    only = c.info->TypeOf_( prm )
                next
                if np = 1 then
                    dim as Fbx.TypeId bare = only
                    if bare <> Fbx.TYPE_NONE then
                        if c.types->Kind( bare ) = Fbx.TK_REFERENCE then
                            bare = c.types->Inner( bare )
                        end if
                        bare = c.types->Unqualify( bare )
                        if bare = t then return true
                    end if
                end if
            end if
        end if
        cur = s->nextOverload
    wend
    return false
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
    '' A DYNAMIC array already has a descriptor; erase it directly.
    if c.types->IsDynArray( t ) then
        dim as MirValue dv = LowerAddr( c, it )
        if dv.kind = cast( ubyte, MV_NONE ) then return false
        if dv.kind <> cast( ubyte, MV_LOCAL ) then return false
        EmitEraseDynLocal( c, dv.id )
        return true
    end if
    if c.types->types[cast( long, t )].dims < 1 then return false

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



'' The descriptor's byte size for a given RANK. Rank 0 is an unspecified dimension
'' count, which fbc gives the full eight dimtb slots because it does not know either.
function DescBytesFor( byref c as Ctx, byval rank as long ) as long
    dim as long n = rank
    if n <= 0 then n = 8
    return DescPtrBytes_( c ) * (6 + n * 3)
end function

'' A DYNAMIC array's declaration. No allocation and no runtime call -- the descriptor
'' IS the object and the element block stays NULL until a redim. Six fields and a
'' zeroed dimtb, which is exactly what fbc emits:
''
''     DATA = 0, PTR = 0, SIZE = 0, ELEMENT_LEN = sizeof(elem),
''     DIMENSIONS = rank, FLAGS = 8 for an unspecified rank else 16 + rank
''
'' FLAGS was measured at 8 for 'dim a()', 17 for one dimension, 18 for two, 24 for
'' eight. What the bits MEAN inside the runtime was not measured; these are the values
'' fbc writes.
''
'' The dimtb is zeroed with explicit stores rather than a memset call. fbc uses
'' __builtin_memset, which its C backend inlines; MIR has no such thing, and 24 stores
'' for the worst case is cheaper to reason about than an ABI question.
sub InitDynArrayDesc _
    ( byref c as Ctx, byref desc as MirValue, byval t as Fbx.TypeId )

    dim as long rank = c.types->DynRank( t )
    dim as long slots = rank
    if slots <= 0 then slots = 8
    dim as long pb = DescPtrBytes_( c )
    dim as long elemLen = SizeOfType( c, c.types->Inner( t ) )

    dim as MirValue nul = ConstInt( c, 0, MT_PTR )
    DescStore_( c, desc, 0, nul )
    DescStore_( c, desc, pb, nul )
    DescStoreConst_( c, desc, 2 * pb, 0 )
    DescStoreConst_( c, desc, 3 * pb, elemLen )
    DescStoreConst_( c, desc, 4 * pb, rank )
    dim as long flags = 8
    if rank > 0 then flags = 16 + rank
    DescStoreConst_( c, desc, 5 * pb, flags )

    for i as long = 0 to slots * 3 - 1
        DescStoreConst_( c, desc, 6 * pb + i * pb, 0 )
    next
end sub

'' The element base of a dynamic array: the DATA field, already biased by its lbounds.
'' Indexing adds index * ELEMENT_LEN and NEVER subtracts an lbound -- measured, and
'' subtracting one here would double-apply the bias the runtime already folded in.
function DynArrayDataPtr( byref c as Ctx, byref desc as MirValue ) as MirValue
    dim as MirInst ld
    ld.op = cast( ushort, M_LOAD )
    ld.ty = cast( ubyte, MT_PTR )
    ld.a = desc
    return Emit( c, ld )
end function



'' Erase the DYNAMIC array in a local slot, at scope exit. Three-way on the element
'' type, measured:
''
''     scalar / POD    fb_ArrayErase( d )
''     string          fb_ArrayStrErase( d )
''     UDT             fb_ArrayEraseObj( d, ctor, dtor )
''
'' A UDT with only IMPLICIT structors falls to fb_ArrayErase here, because fbx does
'' not synthesise implicit structors yet. That is wrong for such a type -- fbc would
'' run the destructors -- and is stated rather than hidden.
sub EmitEraseDynLocal( byref c as Ctx, byval slot as long )
    if (slot < 0) orelse (slot >= c.f->locals.Count) then return
    dim as Fbx.TypeId t = c.f->locals[slot].frontendType
    if c.types->IsDynArray( t ) = false then return

    dim as MirValue d
    d.kind = cast( ubyte, MV_LOCAL )
    d.ty = cast( ubyte, MT_PTR )
    d.id = slot

    dim as Fbx.TypeId et = c.types->Inner( t )
    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, d.kind ) ) : args.Push( cast( ulong, d.id ) )

    if IsStringType( c, et ) then
        EmitRtl( c, RTL_ARRAY_STR_ERASE, args )
        return
    end if
    if c.types->Kind( et ) = Fbx.TK_UDT then
        dim as Fbx.SymbolId ctor = StructorOf( c, et, "__ctor" )
        dim as Fbx.SymbolId dtor = StructorOf( c, et, "__dtor" )
        if (ctor <> Fbx.SYMBOL_NONE) orelse (dtor <> Fbx.SYMBOL_NONE) then
            if PushStructorPtr_( c, args, ctor ) then
                if PushStructorPtr_( c, args, dtor ) then
                    EmitRtl( c, RTL_ARRAY_ERASE_OBJ, args )
                    return
                end if
            end if
            '' A structor whose address could not be taken: fall through to the plain
            '' erase rather than emitting a call with a missing argument.
            dim as FB.Array( of ulong ) plain
            plain.Push( cast( ulong, d.kind ) ) : plain.Push( cast( ulong, d.id ) )
            EmitRtl( c, RTL_ARRAY_ERASE, plain )
            return
        end if
    end if
    EmitRtl( c, RTL_ARRAY_ERASE, args )
end sub



'' REDIM and REDIM PRESERVE.
''
''     fb_ArrayRedimEx      ( desc, elemLen, int32, int32, dims, lo1, hi1, ... )
''     fb_ArrayRedimPresvEx ( same )
''     fb_ArrayRedimObj     ( desc, elemLen, ctor*, dtor*, dims, lo1, hi1, ... )
''     fb_ArrayRedimPresvObj( same )
''
'' All four are VARIADIC, and they are the only array routines that are CDECL on
'' win32 -- everything else there is stdcall with an @N suffix. The inventory carries
'' that automatically: an entry whose parameter string contains the variadic marker
'' takes the cdecl link name.
''
'' Argument 3 of the Ex form was -1 for every element type measured EXCEPT an FB
'' fixed-length 'string * N', where it was 32 at every N. What enum the 32 belongs to
'' could not be determined from fbc's output, so it is reproduced as a literal.
'' Argument 4 is -1 if and only if the element is a var-len STRING, otherwise 0.
''
'' The bounds are 2 * dims varargs -- lo1, hi1, lo2, hi2, ... -- at the target's
'' pointer width.
function LowerRedim _
    ( byref c as Ctx, byval id as Fbx.NodeId, _
      byval sp as Fbx.StmtPayload ptr ) as boolean

    dim as boolean presv = _
        ((c.ast->nodes[cast( long, id )].flags and Fbx.NF_PRESERVE) <> 0)

    for i as long = 0 to sp->count - 1
        dim as Fbx.NodeId item = cast( Fbx.NodeId, c.ast->children[sp->first + i] )
        if c.ast->Kind( item ) <> Fbx.N_VAR_ITEM then continue for
        if RedimOne_( c, id, item, presv ) = false then return false
    next
    return true
end function

private function RedimOne_ _
    ( byref c as Ctx, byval id as Fbx.NodeId, byval item as Fbx.NodeId, _
      byval presv as boolean ) as boolean

    dim as Fbx.StmtPayload ptr ip = StmtOf( c, item )
    dim as Fbx.SymbolId sid = _
        c.syms->LookupLocalTyped( c.info->ScopeOf( id ), ip->name, false )
    if sid = Fbx.SYMBOL_NONE then return false
    dim as Fbx.Symbol ptr vs = c.syms->SymbolAt( sid )
    if vs = 0 then return false
    if c.types->IsDynArray( vs->type_ ) = false then return false

    dim as long slot = LocalFor( c, sid )
    if slot < 0 then return false
    dim as MirValue desc
    desc.kind = cast( ubyte, MV_LOCAL )
    desc.ty = cast( ubyte, MT_PTR )
    desc.id = slot

    '' The bounds, one N_CASE_RANGE or bare upper bound per dimension.
    if ip->c = Fbx.NODE_NONE then return false
    if c.ast->Kind( ip->c ) <> Fbx.N_BLOCK then return false
    dim as Fbx.ListPayload ptr lp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, ip->c )].data )]
    if lp->count < 1 then return false

    dim as Fbx.TypeId et = c.types->Inner( vs->type_ )
    dim as MirType zt = DescIntTy_( c )

    '' Bound VALUES first: they are ordinary expressions and must be evaluated before
    '' anything is emitted that would be wrong to leave behind if one declines.
    dim as FB.Array( of ulong ) bk
    dim as FB.Array( of ulong ) bi
    for d as long = 0 to lp->count - 1
        dim as Fbx.NodeId dn = cast( Fbx.NodeId, c.ast->children[lp->first + d] )
        dim as Fbx.NodeId loN = Fbx.NODE_NONE
        dim as Fbx.NodeId hiN = dn
        if c.ast->Kind( dn ) = Fbx.N_CASE_RANGE then
            dim as Fbx.StmtPayload ptr dp = StmtOf( c, dn )
            loN = dp->a
            hiN = dp->b
        end if

        '' A bare 'a(9)' has an implicit lower bound of 0.
        dim as MirValue lv = ConstInt( c, 0, zt )
        if loN <> Fbx.NODE_NONE then
            lv = LowerExpr( c, loN )
            if lv.kind = cast( ubyte, MV_NONE ) then return false
            lv = Coerce( c, lv, zt, IsUnsignedType( c, c.info->TypeOf_( loN ) ) )
        end if
        dim as MirValue hv = LowerExpr( c, hiN )
        if hv.kind = cast( ubyte, MV_NONE ) then return false
        hv = Coerce( c, hv, zt, IsUnsignedType( c, c.info->TypeOf_( hiN ) ) )

        bk.Push( cast( ulong, lv.kind ) ) : bi.Push( cast( ulong, lv.id ) )
        bk.Push( cast( ulong, hv.kind ) ) : bi.Push( cast( ulong, hv.id ) )
    next

    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, desc.kind ) ) : args.Push( cast( ulong, desc.id ) )
    args.Push( cast( ulong, MV_CONST_INT ) )
    args.Push( cast( ulong, SizeOfType( c, et ) ) )

    dim as Fbx.SymbolId ctor = Fbx.SYMBOL_NONE
    dim as Fbx.SymbolId dtor = Fbx.SYMBOL_NONE
    if c.types->Kind( et ) = Fbx.TK_UDT then
        ctor = StructorOf( c, et, "__ctor" )
        dtor = StructorOf( c, et, "__dtor" )
    end if
    dim as boolean useObj = (ctor <> Fbx.SYMBOL_NONE) orelse (dtor <> Fbx.SYMBOL_NONE)

    if useObj then
        if PushStructorPtr_( c, args, ctor ) = false then return false
        if PushStructorPtr_( c, args, dtor ) = false then return false
    else
        '' Argument 4 is -1 if and only if the element is a var-len STRING.
        ''
        '' Argument 3 is -1 for every element type measured EXCEPT an FB fixed-length
        '' 'string * N', which gives 32 at any N. fbx cannot tell 'string * N' from
        '' 'zstring * N': both are modelled as an array of TY_ZSTRING, and fbc gives
        '' -1 for the second. So a FIXED-LENGTH STRING ELEMENT DECLINES rather than
        '' guessing which of the two it is and being silently wrong half the time.
        dim as longint a3 = -1
        dim as longint a4 = 0
        if IsStringType( c, et ) then
            a4 = -1
        else
            dim as longint zn
            if StrSwapKind_( c, et, zn ) >= 0 then return false
        end if
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, a3 ) )
        args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, a4 ) )
    end if

    args.Push( cast( ulong, MV_CONST_INT ) ) : args.Push( cast( ulong, lp->count ) )
    for j as long = 0 to bk.Count - 1
        args.Push( bk[j] ) : args.Push( bi[j] )
    next

    dim as RtlId r = RTL_ARRAY_REDIM
    if useObj then
        r = RTL_ARRAY_REDIM_OBJ
        if presv then r = RTL_ARRAY_REDIM_PRESV_OBJ
    elseif presv then
        r = RTL_ARRAY_REDIM_PRESV
    end if
    EmitRtl( c, r, args )
    return true
end function



'' The ADDRESS of one element of a DYNAMIC array.
''
'' Measured: only DATA and, for rank 2 and up, DIMTB[1..n-1].ELEMENTS are read.
'' DIMTB[0].ELEMENTS is never read, and NO LBOUND IS EVER SUBTRACTED -- DATA is
'' already biased by the runtime, so subtracting one here would apply the bias twice.
''
''     addr = DATA + ((..(i0 * E1 + i1) * E2 + i2 ..) + i(n-1)) * ELEMENT_LEN
function LowerDynArrayIndex _
    ( byref c as Ctx, byval id as Fbx.NodeId, byval sp as Fbx.ListPayload ptr, _
      byval at as Fbx.TypeId ) as MirValue

    dim as MirValue none_
    dim as long rank = c.types->DynRank( at )
    '' An UNSPECIFIED rank takes the subscript count as the rank: 'dim a()' followed
    '' by 'redim a(0 to 4)' is one-dimensional, and the subscript is what says so.
    if rank <= 0 then rank = sp->count
    if sp->count <> rank then return none_

    dim as long elemLen = SizeOfType( c, c.types->Inner( at ) )
    if elemLen <= 0 then return none_

    dim as MirValue desc = LowerAddr( c, sp->target )
    if desc.kind = cast( ubyte, MV_NONE ) then return none_

    dim as MirType offTy = DescIntTy_( c )
    dim as long pb = DescPtrBytes_( c )

    dim as MirValue acc
    for k as long = 0 to rank - 1
        dim as Fbx.NodeId ix = cast( Fbx.NodeId, c.ast->children[sp->first + k] )
        dim as MirValue iv = LowerExpr( c, ix )
        if iv.kind = cast( ubyte, MV_NONE ) then return none_
        iv = Coerce( c, iv, offTy, IsUnsignedType( c, c.info->TypeOf_( ix ) ) )

        if acc.kind = cast( ubyte, MV_NONE ) then
            acc = iv
        else
            '' Scale what has accumulated by THIS dimension's element count, read from
            '' DIMTB[k].ELEMENTS, then add this index.
            dim as MirInst fa
            fa.op = cast( ushort, M_FIELD_ADDR )
            fa.ty = cast( ubyte, MT_PTR )
            fa.a = desc
            fa.imm = 6 * pb + k * 3 * pb
            dim as MirValue ea = Emit( c, fa )
            dim as MirValue nEl = LowerExprLoad( c, ea, offTy )

            dim as MirInst mul
            mul.op = cast( ushort, M_MUL )
            mul.ty = cast( ubyte, offTy )
            mul.a = acc
            mul.b = nEl
            acc = Emit( c, mul )

            dim as MirInst add_
            add_.op = cast( ushort, M_ADD )
            add_.ty = cast( ubyte, offTy )
            add_.a = acc
            add_.b = iv
            acc = Emit( c, add_ )
        end if
    next
    if acc.kind = cast( ubyte, MV_NONE ) then return none_

    if elemLen <> 1 then
        dim as MirInst mul
        mul.op = cast( ushort, M_MUL )
        mul.ty = cast( ubyte, offTy )
        mul.a = acc
        mul.b = ConstInt( c, elemLen, offTy )
        acc = Emit( c, mul )
    end if

    dim as MirValue base_ = DynArrayDataPtr( c, desc )
    if base_.kind = cast( ubyte, MV_NONE ) then return none_
    dim as MirInst pa
    pa.op = cast( ushort, M_PTR_ADD )
    pa.ty = cast( ubyte, MT_PTR )
    pa.a = base_
    pa.b = acc
    return Emit( c, pa )
end function

'' LBOUND and UBOUND over a DYNAMIC array. Both go through the runtime, with the
'' descriptor cast to the const-void form and a ONE-BASED dimension; a bare
'' 'lbound( a )' passes 1. A FIXED array folds both at compile time and never calls.
function LowerArrayBoundCall _
    ( byref c as Ctx, byval id as Fbx.NodeId, byref outv as MirValue ) as boolean

    if c.ast->Kind( id ) <> Fbx.N_CALL then return false
    dim as Fbx.ListPayload ptr cp = _
        @c.ast->lists[cast( long, c.ast->nodes[cast( long, id )].data )]
    if cp->target = Fbx.NODE_NONE then return false
    if c.ast->Kind( cp->target ) <> Fbx.N_IDENT then return false
    if (cp->count < 1) orelse (cp->count > 2) then return false
    dim as Fbx.IdentPayload ptr ip = _
        @c.ast->idents[cast( long, c.ast->nodes[cast( long, cp->target )].data )]
    dim as string nm = Fbx.Text.LowerAscii( c.names->Spelling( ip->name ) )

    dim as RtlId r = RTL_NONE
    if nm = "lbound" then
        r = RTL_ARRAY_LBOUND
    elseif nm = "ubound" then
        r = RTL_ARRAY_UBOUND
    else
        return false
    end if

    dim as Fbx.NodeId a0 = cast( Fbx.NodeId, c.ast->children[cp->first] )
    if c.types->IsDynArray( c.info->TypeOf_( a0 ) ) = false then return false
    dim as MirValue desc = LowerAddr( c, a0 )
    if desc.kind = cast( ubyte, MV_NONE ) then return false

    dim as MirType zt = DescIntTy_( c )
    dim as MirValue dimV = ConstInt( c, 1, zt )
    if cp->count = 2 then
        dim as Fbx.NodeId a1 = cast( Fbx.NodeId, c.ast->children[cp->first + 1] )
        dim as MirValue dv = LowerExpr( c, a1 )
        if dv.kind = cast( ubyte, MV_NONE ) then return false
        dimV = Coerce( c, dv, zt, IsUnsignedType( c, c.info->TypeOf_( a1 ) ) )
    end if

    dim as FB.Array( of ulong ) args
    args.Push( cast( ulong, desc.kind ) ) : args.Push( cast( ulong, desc.id ) )
    args.Push( cast( ulong, dimV.kind ) ) : args.Push( cast( ulong, dimV.id ) )
    outv = EmitRtl( c, r, args )
    return (outv.kind <> cast( ubyte, MV_NONE ))
end function

end namespace
