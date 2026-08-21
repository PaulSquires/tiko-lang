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
