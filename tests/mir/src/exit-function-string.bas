'' 'EXIT FUNCTION' IN A STRING FUNCTION LEAVES THROUGH fb_StrAllocTempResult, the way a
'' bare 'return' does. It loaded the result descriptor and returned the 24 bytes
'' themselves from a function declared to return a pointer, and clang refused the
'' module. AfxNova's DWStrAcode writes 'if pwszStr = NULL then exit function'.
''
'' fbc-modern prints, and tiko now prints too:
''
''    [][x] 3 9|-1ok|prepost
''    [][val2]
''    -1
type P
    as integer a, b, c
end type

function f( byval p as integer ptr ) as string
    if p = 0 then exit function
    return "x"
end function

function g( byval n as integer ) as P
    function = type<P>( 1, 2, 3 )
    if n = 0 then exit function
    return type<P>( 7, 8, 9 )
end function

function w( byval n as integer ) as wstring ptr
    static as wstring * 4 z = "ok"
    if n = 0 then exit function
    return @z
end function

function s2( byval n as integer ) as string
    function = "pre"
    if n = 0 then exit function
    function = "post"
end function

'' ...AND A UDT RETURNED THROUGH THE HIDDEN POINTER RETURNS THAT POINTER. The exit path
'' loaded a result slot such a function does not have and emitted 'ret void' -- AfxNova's
'' DWStrBase64EncodeW, 'if bRes = 0 or cchStr = 0 then exit function'.
type DS
    s as string
    declare constructor( )
    declare constructor( byref v as string )
    declare destructor( )
    declare operator let( byref o as DS )
end type
dim shared as integer ctors, dtors
constructor DS( )
    ctors += 1
end constructor
constructor DS( byref v as string )
    ctors += 1
    s = v
end constructor
destructor DS( )
    dtors += 1
end destructor
operator DS.let( byref o as DS )
    s = o.s
end operator
function enc( byval n as integer ) as DS
    dim as DS o
    if n = 0 then exit function
    o.s = "val" & n
    function = o
end function

dim as integer k = 5
print "[" & f( 0 ) & "][" & f( @k ) & "]";
print g( 0 ).c; g( 1 ).c; "|"; w( 0 ) = 0; *w( 1 ); "|"; s2( 0 ); s2( 1 )
scope
    dim as DS a = enc( 0 )
    dim as DS b = enc( 2 )
    print "[" & a.s & "][" & b.s & "]"
end scope
print ctors = dtors
