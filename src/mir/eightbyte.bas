'' eightbyte.bas -- the SysV AMD64 eightbyte classification, computed in the FRONTEND.
''
'' docs/internals/phase-8-sysv-abi.md is where the rule was measured. It lives here
'' rather than in the backend because it needs the LAYOUT STORE -- which field sits at
'' which offset, and what type it is -- and giving the backend that would undo the
'' separation docs/plan/10 is built on. MIR carries the two-bit conclusion instead.
''
'' Win64 never calls any of this: its classifier takes a byte count and nothing else.

#import "std/containers"
#include once "mir/lowerctx.bi"

namespace Tko.Mir

'' Is this type a float or a double, for classification purposes? SINGLE and DOUBLE
'' only -- a 'long double' is x87 and forces MEMORY, which is handled by the caller.
private function IsSseLeaf_( byref c as Ctx, byval t as Tko.TypeId ) as boolean
    dim as Tko.TypeId b = c.types->Unqualify( t )
    if c.types->Kind( b ) <> Tko.TK_BUILTIN then return false
    select case c.types->BuiltinOf( b )
    case Tko.TY_SINGLE, Tko.TY_DOUBLE : return true
    end select
    return false
end function

'' Fold one field's contribution into the eightbyte it lands in.
''
'' MERGING IS 'INTEGER WINS', which is what a union measured as: 'union{ double; long
'' long }' is passed as i64, not as a double. So a field only leaves an eightbyte SSE
'' if the eightbyte has seen nothing but floats and doubles.
private sub FoldField_ _
    ( byref c as Ctx, byval t as Tko.TypeId, byval off as long, _
      byref cls0 as ulong, byref cls1 as ulong, byref memory as boolean )

    if memory then return
    dim as Tko.TypeId b = c.types->Unqualify( t )

    '' A NESTED AGGREGATE OR ARRAY RECURSES -- measured: '{ {float,float} }' is
    '' <2 x float> and 'float v[4]' is two of them, so neither can be treated as an
    '' opaque block of its own size.
    if c.types->Kind( b ) = Tko.TK_ARRAY then
        dim as Tko.TypeId el = c.types->Inner( b )
        dim as long esz = SizeOfType( c, el )
        if esz <= 0 then
            memory = true
            return
        end if
        dim as long total = SizeOfType( c, b )
        dim as long n = total \ esz
        for i as long = 0 to n - 1
            FoldField_( c, el, off + (i * esz), cls0, cls1, memory )
            if memory then return
        next
        return
    end if

    if c.types->Kind( b ) = Tko.TK_UDT then
        dim as long li = c.udts->Find( b )
        if li < 0 then
            memory = true
            return
        end if
        dim as long first = c.udts->udts[li].first
        dim as long count = c.udts->udts[li].count
        for i as long = 0 to count - 1
            dim as Tko.UdtField ptr f = @c.udts->fields[first + i]
            FoldField_( c, f->type_, off + f->offset, cls0, cls1, memory )
            if memory then return
        next
        return
    end if

    '' A LEAF. Which eightbyte it lands in is decided by its offset; a leaf that
    '' STRADDLES the boundary makes both integer, which cannot happen for any type
    '' FreeBASIC has at natural alignment but costs nothing to be right about.
    dim as long sz = SizeOfType( c, b )
    if sz <= 0 then
        memory = true
        return
    end if
    dim as boolean sse = IsSseLeaf_( c, b )
    dim as long lo = off \ 8
    dim as long hi = (off + sz - 1) \ 8
    for e as long = lo to hi
        dim as ulong add = TKO_EB_INTEGER
        if sse andalso (lo = hi) then add = TKO_EB_SSE
        select case e
        case 0
            if (cls0 = TKO_EB_NONE) orelse (add = TKO_EB_INTEGER) then cls0 = add
        case 1
            if (cls1 = TKO_EB_NONE) orelse (add = TKO_EB_INTEGER) then cls1 = add
        case else
            '' Past sixteen bytes, which the caller has already ruled out.
            memory = true
            return
        end select
    next
end sub

'' The packed eightbyte classes of a type, for MirFunction.AddParam. Zero for anything
'' that is not an aggregate -- a scalar needs no classification.
function ClassifyEightbytes _
    ( byref c as Ctx, byval t as Tko.TypeId ) as ulong

    if t = Tko.TYPE_NONE then return 0
    dim as long sz = SizeOfType( c, t )
    if sz <= 0 then return 0
    '' OVER SIXTEEN BYTES IS MEMORY, before anything is walked.
    if sz > 16 then return TKO_EB_MEMORY

    dim as ulong cls0 = TKO_EB_NONE
    dim as ulong cls1 = TKO_EB_NONE
    dim as boolean memory = false
    FoldField_( c, t, 0, cls0, cls1, memory )
    if memory then return TKO_EB_MEMORY
    '' An aggregate with no classifiable field at all -- an empty type. Nothing is
    '' passed for it, and saying INTEGER is both harmless and what clang does.
    if cls0 = TKO_EB_NONE then cls0 = TKO_EB_INTEGER
    if (sz > 8) andalso (cls1 = TKO_EB_NONE) then cls1 = TKO_EB_INTEGER
    return TKO_EB_PACK( cls0, cls1 )
end function

end namespace
