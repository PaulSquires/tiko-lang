'' A STRING 'iif' is a temporary DESCRIPTOR, not a value.
''
'' Measured from fbc: fb_StrInit into a temporary in each arm, then the consuming
'' statement, then fb_StrDelete. INITIALISED rather than assigned -- the temporary has
'' no prior contents, and fb_StrAssign on uninitialised descriptor bytes would free
'' whatever pointer happened to be there.
''
'' The temporary's life ends with the STATEMENT, which is shorter than any scope.

sub P( byval c as integer )
    dim as string a = "x", b = "y", r

    r = iif( c, a, b )
    r = a + iif( c, a, b ) + "z"
    print iif( c, a, b )
    print "n="; iif( c, a, b ); "!"
    r = iif( c, "lit", b )

    '' A SCALAR iif still takes the value path, and takes its type from an ARM --
    '' Check computes none for the call. 'print iif( c, 1, 2 )' declined for that
    '' reason while the assignment beside it worked.
    dim as integer n
    n = iif( c, 1, 2 )
    print iif( c, 1, 2 )
end sub

'' A UDT 'iif' builds its result in a TEMPORARY and yields that temporary's ADDRESS,
'' because a UDT result is usually read THROUGH -- '(iif( c, a, b )).i' is the shape
'' the corpus writes, and without an address the member had no base to offset from.
type U
    i as integer
    j as integer
end type

sub Q( byval c as integer )
    dim as U a, b, r
    r = iif( c, a, b )
    dim as integer z = (iif( c, a, b )).i
    dim as integer y = (iif( c, iif( c, a, b ), a )).j

    '' The RESULT TYPE is the two arms' common type. Check computed nothing for an iif
    '' call at all, which propagated: an untyped base meant the member never resolved,
    '' and 'var v = iif( ... )' inferred nothing and got a void slot.
    var v = iif( c, 1, 2 )
    dim as long q2 = v
    dim as double d = iif( c, 1, 2.5 )
end sub
