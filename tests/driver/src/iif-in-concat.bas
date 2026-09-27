'' An IIF inside a string concatenation, in a function returning a string or a UDT
'' holding one. See tests/driver/iif-in-concat.test.
''
'' fbc-modern 1.20 compiles this clean and prints:
''
''     tip 3 for 1
''     t 2.25|
''     b 10 yes FF / b 20 no 10
''     8x1
''     c true
''     g42
''     p0!

enum E
    EA = 1
    EB
end enum

type Text
    as string s
end type

'' the repro: a NUMERIC iif as a concat term, in a function returning a STRING
function f1( byval a as any ptr, byval idx as long ) as string
    dim as string s = "tip " & idx & " for " & iif( a <> 0, 1, 0 )
    return s
end function

'' ...into a UDT holding a string, with FLOAT arms
function f2( byval a as any ptr ) as Text
    dim as Text t
    t.s = "t " & iif( a <> 0, 1.5, 2.25 ) & "|"
    return t
end function

'' numeric, STRING and untyped ('hex') arms side by side
function f3( byval b as boolean ) as string
    return "b " & iif( b, 10, 20 ) & " " & iif( b, "yes", "no" ) & " " & iif( b, hex( 255 ), hex( 16 ) )
end function

'' a numeric iif FIRST, and ENUM arms
function f4( byval b as boolean ) as string
    dim as E e1 = EB
    return iif( b, 7, 8 ) & "x" & iif( b, e1, EA )
end function

'' BOOLEAN arms
function f5( byval b as boolean ) as string
    return "c " & iif( b, true, false )
end function

'' POINTER arms: the address, a null one here so the output is stable
function f6( byval p as any ptr ) as string
    dim as string s = "p" & iif( p <> 0, p, 0 )
    return s & "!"
end function

print f1( cptr( any ptr, 1 ), 3 )
print f2( 0 ).s
print f3( true ); " / "; f3( false )
print f4( false )
print f5( true )
dim as string g = "g" & iif( 1 > 0, 42, 0 )
print g
print f6( 0 )
