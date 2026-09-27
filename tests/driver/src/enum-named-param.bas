'' A parameter named like its own enum type. See tests/driver/enum-named-param.test.
''
'' fbc-modern 1.20 compiles this clean and prints:
''
''      2
''      4
''      1             1
''      20            10
''      3
''      3
''      2

enum E
    EA = 1
    EB
end enum

enum G explicit
    GA = 3
    GB
end enum

'' byval, over a plain and an explicit enum: the parameter IS the value
function asEnum( byval e as E ) as long : return e : end function
function asG( byval g as G ) as long : return g : end function

'' byref: the parameter writes back
function byr( byref e as E ) as long : e = EA : return e : end function

'' defaulted
function dflt( e as E = EB ) as long : return e * 10 : end function

'' inside: another variable of the type, and a bare member, still reach the enum
function inner( byval e as E ) as long
    dim as E other = e
    return other + EA
end function

'' 'E.EB' where no parameter hides E
function qual( byval x as E ) as long : return x + E.EB : end function

'' a local of the enum's type under another name
sub local_( )
    dim as E other = E.EB
    print other
end sub

print asEnum( EB )
print asG( G.GB )
dim as E v = EB
print byr( v ), v
print dflt( ), dflt( EA )
print inner( EB )
print qual( E.EA )
local_( )
