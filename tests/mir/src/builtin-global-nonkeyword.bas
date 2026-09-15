'' A BUILTIN THAT IS NOT A LEXER KEYWORD, CALLED THROUGH THE GLOBAL SCOPE, IS THE BUILTIN.
'' '..hex( 255 )' reached Check as a MEMBER whose target is not an identifier, and Resolve
'' rewrote it to the bare builtin only for a keyword spelling or LEFT/RIGHT -- so hex, oct,
'' bin, val and space printed nothing and the statement declined. The rewrite now takes
'' every spelling the intrinsic table types (Check.IsTypedIntrinsicName).
''
'' fbc prints:
''   hex:FF
''   oct:10
''   bin:101
''   len: 2
''   val: 42
''   space:[  ]
''   left:A
''   wide lengths: 2 3 3 4
''   valint: 12 vallng: 13
''   in sub:10 3
dim as string s = "Ab"
print "hex:"; ..hex( 255 )
print "oct:"; ..oct( 8 )
print "bin:"; ..bin( 5 )
print "len:"; ..len( s )
print "val:"; ..val( "42" )
print "space:["; ..space( 2 ); "]"
print "left:"; ..left( s, 1 )
print "wide lengths:"; len( ..whex( 255 ) ); len( ..woct( 64 ) ); len( ..wbin( 5 ) ); len( ..wspace( 4 ) )
print "valint:"; ..valint( "12" ); " vallng:"; ..vallng( "13" )
sub InSub( )
    print "in sub:"; .hex( 16 ); .space( 1 ); .val( "3" )
end sub
InSub( )
