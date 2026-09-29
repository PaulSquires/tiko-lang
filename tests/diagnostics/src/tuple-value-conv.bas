'' TWO TUPLE TYPES NEVER CONVERT -- a VALUE of one is refused where the other is wanted.
'' fbc-modern 1.20, 2026-09-29: 24 (line 16), 181 (17, 20, 24, 29, 30), 58 (26, 27, 31). tiko
'' copied the bytes: a '(integer, integer)' read back as a '(long, long)' of '5, 0'.
type P as (long, long)
sub ByV( byval q as (long, long) )
end sub
sub ByR( byref q as (long, long) )
end sub
sub Nest( byval q as ((long, long), long) )
end sub
dim as (integer, integer) a = (5, 6)
dim as (lo as long, hi as long) same = (1, 2)
dim as P ptr pp
dim as (long, long) b

dim as (long, long) b1 = a
b = a
function F( ) as (long, long)
    dim as (integer, integer) t = (1, 2)
    return t
end function
function G( ) as (long, long)
    dim as (integer, integer) t = (1, 2)
    function = t
end function
ByV( a )
ByR( a )
dim as ((long, long), long) n1
n1 = (a, 3)
*pp = a
Nest( (a, 3) )

'' ...and the same tuple spelled another way is ONE type, and a literal adapts.
dim as P b2 = same
b = same
ByV( same )
ByR( same )
ByV( (1, 2) )
Nest( ((1, 2), 3) )
dim as ((long, long), long) n2 = (same, 3)
b = (1, 2)
function H( byval s as (lo as long, hi as long) ) as (x as long, y as long)
    return s
end function
