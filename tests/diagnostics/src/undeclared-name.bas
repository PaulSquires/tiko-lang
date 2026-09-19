'' A NAME NOTHING DECLARED IS AN ERROR -- fbc's 42, "Variable not declared". Every one
'' below is refused on exactly the line fbc-modern 1.20 and 1.10.1 refuse it (2026-09-19);
'' tiko-lang accepted them all, dropped the statement and built the program.
dim as integer x
dim as string s
type TT
    a as integer
end type
dim as TT t

'' Written, read, called, subscripted, sized, taken apart.
zz1 = 1
x = zz2
print zz3
x = zz4( 1 )
zz5( 1 )
zz6 1, 2
x = sizeof( zz7 )
dim as integer y = zz8
x = zz9.a
with zz10
end with
swap zz11, x
x = len( zz12 )
zz13 += 1
x = iif( zz14, 1, 2 )
s = hex( zz15 )
const K = zz16 + 1
enum E
    e1 = zz17
end enum
dim arr( zz18 ) as integer
print #zz19, "a"
x = *zz20

'' One per statement, and a ':' ends the line for fbc: 'a' alone, then 'zz21' alone.
a = b + c
print zz21 : print zz22

'' Inside a procedure and inside a member.
sub s1( )
    zz23 = 1
end sub
type TM
    a as integer
    declare sub m( )
end type
sub TM.m( )
    zz24 = 1
end sub

'' NOT undeclared: builtins that are not keywords bind no symbol either.
s = hex( 255 ) & oct( 8 ) & bin( 2 ) & space( 1 )
x = val( "1" ) + valint( "2" ) + rgb( 1, 2, 3 )
x = t.a
deallocate( 0 )
dim as any ptr pf = procptr( fb_ArrayRedimEx )

'' ...nor what is never compiled as a value: an 'assert' argument (nothing without -g),
'' an '#assert' operand (a pre-processor expression, where an unknown name is 0),
'' 'offsetof''s field, an OPEN device, and an explicit enum's sibling in its own body.
assert( zzAsserted = 1 )
#assert zzPp = zzPp
x = offsetof( TT, a )
open cons for output as #1
enum EX explicit
    first_
    second_ = first_ + 1
end enum
