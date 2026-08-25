'' A GENERIC PARAMETER WRITTEN AS AN INSTANTIATION must actually MATCH its argument,
'' or the whole inference fails and the candidate drops out -- leaving the CONCRETE
'' overloads of the same name to be considered.
''
'' The generic is declared FIRST here on purpose: that is the order fb/string.bi and
'' fb/array.bi are in, and fbc picks has_str for it.
namespace NS
    type Box( of T )
        as T v
    end type

    function Has( of T )( byref b as Box( of T ), byref v as T ) as boolean
        return (b.v = v)
    end function

    declare function Has overload alias "has_str" _
        ( byref s as const string, byref m as const string ) as boolean
    declare function Has overload alias "has_wstr" _
        ( byref s as const wstring, byref m as const string ) as boolean
end namespace
using NS
dim as Box( of long ) bx
dim as long r1 = Has( "hello", "ell" )
print r1
