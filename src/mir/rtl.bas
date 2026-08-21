'' rtl.bas -- the runtime inventory. See rtl.bi for why it is measured, not copied.

#include once "mir/rtl.bi"

namespace Fbx.Mir

function RtlSymbol( byval r as RtlId ) as string
    select case r
    #define RTL( r_id, r_sym, r_ret, r_args ) case r_id : return r_sym
    FBX_RTL_LIST( RTL )
    #undef RTL
    end select
    return ""
end function

'' The MIR type one letter names. One alphabet for returns and parameters, so a
'' pointer-width value cannot be spelled one way in one column and another in the other.
function RtlTypeOfLetter _
    ( byref c as string, byval is32 as boolean ) as MirType

    select case c
    case "v" : return MT_VOID
    case "b" : return MT_I8
    case "s" : return MT_I16
    case "l" : return MT_I32
    case "L" : return MT_I32
    case "q" : return MT_I64
    case "z" : return iif( is32, MT_I32, MT_I64 )
    case "f" : return MT_F32
    case "d" : return MT_F64
    case "p" : return MT_PTR
    case "." : return MT_VOID      '' the variadic marker names no type
    end select
    return MT_VOID
end function

function RtlReturn( byval r as RtlId, byval is32 as boolean ) as MirType
    dim as string ret = ""
    select case r
    #define RTL( r_id, r_sym, r_ret, r_args ) case r_id : ret = r_ret
    FBX_RTL_LIST( RTL )
    #undef RTL
    end select
    return RtlTypeOfLetter( ret, is32 )
end function

'' The linker-visible name. On win32 every runtime symbol carries the leading
'' underscore, and everything but the VARIADIC entries carries a stdcall '@N' as well:
'' varargs need caller cleanup, so fb_ArrayRedimEx is '_fb_ArrayRedimEx' with no
'' suffix while fb_StrAssign is '_fb_StrAssign@20'. Both measured from libfb.a.
function RtlLinkName( byval r as RtlId, byval is32 as boolean ) as string
    dim as string nm = RtlSymbol( r )
    if is32 = false then return nm
    dim as string ps = RtlParams( r )
    if instr( ps, "." ) > 0 then return "_" & nm

    '' NOT EVERYTHING IN THE RUNTIME IS STDCALL ON WIN32. fb_ErrorThrowEx is cdecl --
    '' measured, libfb.a carries '_fb_ErrorThrowEx' with no '@20' -- and decorating it
    '' emits a name the linker cannot resolve. Found by check-rtl the moment the entry
    '' was added, which is the whole reason that gate compares the DECORATED name.
    if r = RTL_ERROR_THROW then return "_" & nm
    '' 'free' is libc and cdecl; the leading underscore is all win32 adds.
    if r = RTL_FREE then return "_" & nm

    dim as long total = 0
    for i as long = 0 to len( ps ) - 1
        dim as MirType t = RtlTypeOfLetter( mid( ps, i + 1, 1 ), true )
        dim as long sz = 4
        if (t = MT_I64) orelse (t = MT_F64) then sz = 8
        total += sz
    next
    return "_" & nm & "@" & total
end function

function RtlParams( byval r as RtlId ) as string
    select case r
    #define RTL( r_id, r_sym, r_ret, r_args ) case r_id : return r_args
    FBX_RTL_LIST( RTL )
    #undef RTL
    end select
    return ""
end function

function RtlArity( byval r as RtlId ) as long
    return len( RtlParams( r ) )
end function

'' The MIR type a parameter letter names. Kept next to the table so the two cannot
'' drift apart.
function RtlParamType _
    ( byval r as RtlId, byval i as long, byval is32 as boolean ) as MirType

    dim as string p = RtlParams( r )
    if (i < 0) orelse (i >= len( p )) then return MT_VOID
    return RtlTypeOfLetter( mid( p, i + 1, 1 ), is32 )
end function

function DumpRtl( byval is32 as boolean ) as string
    dim as string outp = ""
    for i as long = 1 to RTL_COUNT - 1
        dim as RtlId r = cast( RtlId, i )
        outp += RtlLinkName( r, is32 ) & " " & _
                TypeName( RtlReturn( r, is32 ) ) & " ("
        dim as string ps = RtlParams( r )
        for j as long = 0 to len( ps ) - 1
            if j > 0 then outp += ", "
            if mid( ps, j + 1, 1 ) = "." then
                outp += "..."
            else
                outp += TypeName( RtlParamType( r, j, is32 ) )
            end if
        next
        outp += ")" & chr( 10 )
    next
    outp += "rtl: " & str( RTL_COUNT - 1 ) & " entries" & chr( 10 )
    return outp
end function

end namespace
