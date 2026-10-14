'' A concatenation with a ustring term is a USTRING when it picks a constructor, as it already
'' was for an ordinary overload set (ResolveCall_). Check keeps '&' narrow, so every form
'' below ran the string constructor; fbc runs the ustring one. The string-only rows stay
'' with the string constructor.

function getu( ) as ustring
    return "fn"
end function

type FA
    as long kind
    as ustring s
    declare constructor( byref v as const ustring )
    declare constructor( byref v as const string )
end type
constructor FA( byref v as const ustring ) : kind = 5 : s = v : end constructor
constructor FA( byref v as const string ) : kind = 6 : s = v : end constructor

function Show( byref tag as const string, byref a as const FA ) as string
    return tag & "=" & a.kind & "[" & a.s & "]"
end function

dim as ustring u = "x"
dim as string bs = "b"
print Show( "arg-ul", u & "!" )
print Show( "arg-fl", getu( ) & "!" )
print Show( "arg-su", bs & u )
print Show( "arg-u", u )
print Show( "arg-sl", bs & "!" )
print Show( "arg-lit", "lit" )
print Show( "call", FA( u & "!" ) )
dim as FA fx = u & "?"
print Show( "init", fx )
dim as FA fy = FA( getu( ) & "#" )
print Show( "init-call", fy )
dim as FA fs = bs & "?"
print Show( "init-s", fs )
var pz = new FA( bs & u )
print Show( "new", *pz )
delete pz
