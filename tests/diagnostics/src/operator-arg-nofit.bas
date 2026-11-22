'' A member 'operator []', 'let' or '+=' over a CONST H that does not take the operand: fbc
'' tries the standard conversions only -- H's constructors are not, though a plain sub
'' over 'byref as const H' takes "abc" and 5 through them (lines 47-48, accepted).
type H
    as long v
    declare constructor ( )
    declare constructor ( byref s as string )
    declare constructor ( byval n as long )
end type
constructor H ( )
end constructor
constructor H ( byref s as string )
    v = len( s )
end constructor
constructor H ( byval n as long )
    v = n
end constructor
type W
    as long z
    declare operator [] ( byref key as const H ) as long
    declare operator let ( byref key as const H )
    declare operator += ( byref key as const H )
end type
operator W.[] ( byref key as const H ) as long
    return key.v
end operator
operator W.let ( byref key as const H )
    z = key.v
end operator
operator W.+= ( byref key as const H )
    z += key.v
end operator
type W2
    as long z
    declare operator [] ( byref key as const H ) as long
    declare operator [] ( byval key as double ptr ) as long
end type
operator W2.[] ( byref key as const H ) as long
    return key.v
end operator
operator W2.[] ( byval key as double ptr ) as long
    return 1
end operator
sub s ( byref key as const H )
    print key.v
end sub
s( "abc" )
s( 5 )
dim as W ww
dim as W2 wx
print ww["abc"]
print ww[5]
print wx["abc"]
ww = "abc"
ww = 3
ww += "abcd"
ww += 4
dim as H hh
print ww[hh], wx[hh]
ww = hh
ww += hh
