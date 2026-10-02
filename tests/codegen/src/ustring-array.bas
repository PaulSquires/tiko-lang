sub ShowAll( a( ) as ustring )
    for i as long = lbound( a ) to ubound( a )
        print a( i );
    next
    print
end sub
sub ShowS( a( ) as string )
    print ubound( a )
end sub
dim as ustring us( 0 to 2 ) = { "x", "y", "z" }
dim as string ss( 0 to 1 ) = { "p", "q" }
print "n="; ubound( us )
print "m="; str( ubound( us ) ); "!"
print ubound( us ) + 1; lbound( us ) = 0
dim as long k = ubound( us ) * 2
print k
ShowAll( us( ) )
ShowS( ss( ) )
print "end"
