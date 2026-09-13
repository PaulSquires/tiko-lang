'' A STRING TEMPORARY FOR A 'byref as string' CONSTRUCTOR PARAMETER IS COPIED FIRST, as at
'' a call. tiko handed the constructor fb_IntToStr's POOL descriptor, and the runtime frees
'' one of those as soon as a string function reads it: the body's first 'len( s )' was 2,
'' its second 0, and 't = s' stored nothing. AfxNova's DWSTRING( byref ansiStr as string )
'' reads the length before converting, so every DWSTRING built from a narrow string came
'' out empty. The sub call beside it was always right. fbc-modern prints:
''
''    dim: 2 2 [42]
''    ctor: 2 2 [43]
''    sub: 2 2 [44]
type U
    n1 as integer
    n2 as integer
    t as string
    declare constructor( byref s as string )
end type
constructor U( byref s as string )
    n1 = len( s )
    n2 = len( s )
    t = s
end constructor
sub viaSub( byref s as string )
    dim as integer a = len( s ), b = len( s )
    print "sub:"; a; b; " ["; s; "]"
end sub
dim as long n = 42
dim as U u1 = str( n )
print "dim:"; u1.n1; u1.n2; " ["; u1.t; "]"
dim as U u2 = U( str( n + 1 ) )
print "ctor:"; u2.n1; u2.n2; " ["; u2.t; "]"
viaSub( str( n + 2 ) )
