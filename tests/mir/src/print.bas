'' PRINT. The separator between items decides how each one prints, so the three forms
'' below must lower differently.

sub P( )
    dim as string s = "x"
    dim as long n
    dim as double d
    dim as any ptr q
    print
    print s
    print n
    print d
    print q
    print "lit"
    print s; n
    print s, n
    print s;
end sub
