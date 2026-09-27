'' A value where an enum's name is: fbc's error 120 for a variable named like a visible
'' enum, and 265 for a member reached through a value of an enum type. See
'' tests/diagnostics/enum-name-value.test for the lines.

enum E
    EA = 1
    EB
end enum

enum G explicit
    GA = 3
    GB
end enum

sub s1( )
    dim as E e = EB
end sub

sub s2( )
    dim e as E = EB
end sub

sub s3( )
    dim as long e = 5
end sub

sub s4( byval p as E )
    print p.EB
end sub

function f1( byval e as E ) as long
    return e + E.EA
end function

function f2( byval g as G ) as long
    return g + G.GB
end function

dim as E v = EA
print v.EB
