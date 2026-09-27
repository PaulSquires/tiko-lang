'' One of each row of RFC-0004 §3 that the names fixture does not already have.
#module "rows"
#define LIMIT 10
public const MAXN = LIMIT * 2
public enum Colour
    red
    green = 5
end enum
public type Handle as long
public union Bits
    b as ubyte
    w as ushort
end union
public type Vec
    x as long
    y as long
    declare sub Scale( byval k as long )
    declare operator += ( byref o as Vec )
end type
sub Vec.Scale( byval k as long )
    x *= k : y *= k
end sub
operator Vec.+=( byref o as Vec )
    x += o.x : y += o.y
end operator
public operator + ( byref a as Vec, byref b as Vec ) as Vec
    return type( a.x + b.x, a.y + b.y )
end operator
public declare function Later( byval n as long = MAXN ) as long
function Later( byval n as long ) as long
    static calls as long
    calls += 1
    return n + calls
end function
public sub Counted( ) static
    dim as long n
    n += 1
end sub
public dim shared table( 0 to 3 ) as long = { 1, 2, 3, 4 }
sub Setup( ) constructor
    table( 0 ) = 1
end sub
public dim shared as double ratio = 0.5, scale_
dim shared lines_ as string
if LIMIT > 5 then
    const LOCALC = 3
    print LOCALC
end if
