'' NUMERIC LITERAL SUFFIXES, built to an executable: the value and, through sizeof, the
'' type. fbc accepts every line; tiko refused 'd' on a decimal literal ('3d' was 3 and an
'' identifier 'd'), a '.' with nothing after it, and an empty exponent, and typed a float
'' suffix on a hex, octal or binary literal as an INTEGER. See
'' tests/lexer/src/numeric-suffixes.bas for the grammar.
''
'' build/goldenrun.sh runs this beside fbc.
print "a"; 3d; sizeof( 3d )
print "b"; 3D; sizeof( 3D )
print "c"; 3.d; sizeof( 3.d )
print "d"; 3.; sizeof( 3. )
print "e"; 3.f; sizeof( 3.f )
print "f"; .5d; sizeof( .5d )
print "g"; 3e; 3e+; 3d-; sizeof( 3e )
print "h"; 3df; sizeof( 3df )
print "i"; 3d#; sizeof( 3d# )
print "j"; 1d3f; sizeof( 1d3f )
print "k"; 3d+1
print "l"; 3d -1
print "m"; 3.+1
print "n"; 18446744073709551615d
print "o"; &h3d; sizeof( &h3d )
print "p"; &h3d!; sizeof( &h3d! )
print "q"; &hFFf#; sizeof( &hFFf# )
print "r"; &o7d; sizeof( &o7d )
print "s"; &o7f; sizeof( &o7f )
print "t"; &b1d; sizeof( &b1d )
print "u"; &b101!; sizeof( &b101! )
print "v"; 3dmod 2
print "w"; 3fand 1
print "x"; 3ul; sizeof( 3ul )
dim as double dv = 3d
print "y"; dv; 2d
#if 3d = 3
print "z"
#endif
