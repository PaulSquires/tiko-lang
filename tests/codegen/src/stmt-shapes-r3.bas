' Shapes that stopped on TKO0994 (fbc-examples round 3: r3ice04, 05, 06, 07, 10), and a user
' operator that the builtin of the same name bypassed (r3mis01): wrong results, silently.

' r3ice06: an enum member and a function of the same name, then windows.bi -- the table grows, and
' a rehash gave the name back to the member.
type nk_color
    as ubyte r, g, b, a
end type
enum nk_color_format
    NK_RGB = 0
    NK_RGBA = 1
end enum
function nk_rgb(byval r as long, byval g as long, byval b as long) as nk_color
    return type<nk_color>(r, g, b, 255)
end function
#include once "windows.bi"
dim as nk_color c = nk_rgb(0, 0, 255)
print c.b; NK_RGBA; nk_color_format.NK_RGB

' r3ice04: p[ i ].x through a const UDT pointer.
type V2
    as short x, y
end type
dim as V2 va(1) = {(1, 2), (3, 4)}
dim as const V2 ptr pv = @va(0)
print pv[1].x; pv[1].y

' r3ice05: a method named get called bare with commas and an omitted argument.
type Sock
    as integer n = 5
    declare function get(byref d as ubyte, byval l as integer, byval t as double = 0, byval pk as boolean = false) as integer
    declare function pull() as integer
end type
function Sock.get(byref d as ubyte, byval l as integer, byval t as double = 0, byval pk as boolean = false) as integer
    d = 65 : return l + n
end function
function Sock.pull() as integer
    dim as ubyte buf(3)
    dim as integer g = get( buf(0), 2, , true )
    return g + buf(0)
end function
dim as Sock sk
print sk.pull()

' r3ice07: a 2-D UDT-array field with a nested initialiser, a short row zeroed.
type int2d
    as integer x, y
end type
type AP
    dim as int2d tp(1, 2) = {{(0, 1), (1, 1)}, {(3, 0), (4, 1), (5, 2)}}
end type
dim as AP ap_
print ap_.tp(1, 2).x; ap_.tp(1, 2).y; ap_.tp(0, 1).x; ap_.tp(0, 2).x

' r3mis01 / r3ice10: a user unary operator over a type that also casts to a number.
type D
    as long v
    declare constructor()
    declare constructor(byval x as long)
    declare operator cast() as long
    declare function toString(byval places as long = 3) as string
end type
constructor D()
end constructor
constructor D(byval x as long)
    v = x
end constructor
operator D.cast() as long
    return v
end operator
function D.toString(byval places as long = 3) as string
    return str(v) & "/" & places
end function
operator exp (byref x as D) as D
    return D(x.v * 2)
end operator
operator abs (byref x as D) as D
    return D(x.v * 3)
end operator
operator sgn (byref x as D) as long
    return x.v * 100
end operator
dim as D q = exp(D(4))
dim as D qa = abs(D(4))
print q.toString(37); " "; (exp(D(5))).toString(1); " "; qa.v; sgn(D(-2))
