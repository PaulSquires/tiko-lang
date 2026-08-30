'' A STRING LITERAL IS SPELLED BACK WITH THE PREFIX IT WAS WRITTEN WITH. Measured, all
'' four, by running fbc:
''
''     #define t $"hello"   len( __FB_QUOTE__( t ) ) = 8   $"hello"
''     #define t "hello"    len( __FB_QUOTE__( t ) ) = 7    "hello"
''     #define t !"a\tb"    len( __FB_QUOTE__( t ) ) = 7   !"a\tb"
''     #define S(a) #a      len( S( $"q" ) ) = 4           $"q"
''
'' There is NO file-versus-synthesised distinction: a nested __FB_QUOTE__ gives fbc
'' '$"1 2 3" $"4 5 6"', prefix and all. An earlier attempt added '$' UNCONDITIONALLY,
'' which put one on plain literals, and the note left behind read that as 'synthesised
'' literals take no prefix'. strKind is what says which.
#define t1 $"hello"
#define t2 "hello"
#define t3 !"a\tb"
#define S( a ) #a

print len( __FB_QUOTE__( t1 ) ), __FB_QUOTE__( t1 )
print len( __FB_QUOTE__( t2 ) ), __FB_QUOTE__( t2 )
print len( __FB_QUOTE__( t3 ) ), __FB_QUOTE__( t3 )
print len( S( $"q" ) ), S( $"q" )
