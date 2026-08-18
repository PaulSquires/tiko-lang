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

function RtlReturn( byval r as RtlId ) as MirType
    select case r
    #define RTL( r_id, r_sym, r_ret, r_args ) case r_id : return r_ret
    FBX_RTL_LIST( RTL )
    #undef RTL
    end select
    return MT_VOID
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
function RtlParamType( byval r as RtlId, byval i as long ) as MirType
    dim as string p = RtlParams( r )
    if (i < 0) orelse (i >= len( p )) then return MT_VOID
    select case mid( p, i + 1, 1 )
    case "v" : return MT_VOID
    case "b" : return MT_I8
    case "s" : return MT_I16
    case "l" : return MT_I32
    case "L" : return MT_I32
    case "q" : return MT_I64
    case "f" : return MT_F32
    case "d" : return MT_F64
    case "p" : return MT_PTR
    case "." : return MT_VOID      '' the variadic marker names no type
    end select
    return MT_VOID
end function

function DumpRtl( ) as string
    dim as string outp = ""
    for i as long = 1 to RTL_COUNT - 1
        dim as RtlId r = cast( RtlId, i )
        outp += RtlSymbol( r ) & " " & TypeName( RtlReturn( r ) ) & " ("
        dim as string ps = RtlParams( r )
        for j as long = 0 to len( ps ) - 1
            if j > 0 then outp += ", "
            if mid( ps, j + 1, 1 ) = "." then
                outp += "..."
            else
                outp += TypeName( RtlParamType( r, j ) )
            end if
        next
        outp += ")" & chr( 10 )
    next
    outp += "rtl: " & str( RTL_COUNT - 1 ) & " entries" & chr( 10 )
    return outp
end function

end namespace
