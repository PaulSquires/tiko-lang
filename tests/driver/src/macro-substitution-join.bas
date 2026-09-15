'' A SUBSTITUTED ARGUMENT JOINS THE BODY BESIDE IT, built to an executable: the value,
'' and through sizeof the type. fbc substitutes an argument's TEXT and re-lexes, so
'' 'm(2)' over '#define m(n) n.5' is the one literal 2.5; tiko spliced two tokens and
'' refused the statement. See tests/pp/src/macro-substitution-join.bas for the grammar.
''
'' fbc prints, one per line:
''     a 2.5 8  b 12 8  c 2.2 8  d 100 8  e 2000 8  f 2 8  g 1.5 8  h 3.14 8  i 3 8
''     j-1  kx"y  l 12.5 8  m 32 8  n 100 8  o 7  p 9  q 5  r 3.5 8  s 2.5 8
''
'' build/goldenrun.sh runs this beside fbc.
type TX
    as integer x = 5
end type
dim shared as TX foo
dim shared as integer ne3 = 7, n5 = 9

#define dot5( n ) n.5
#define one( n ) 1n
#define twice( n ) n.n
#define expo( n ) 1en
#define dotexp( n ) n.e3
#define trail( n ) n.
#define lead( n ) 1.n
#define pair( a, b ) a.b
#define cmp( op ) 1 op= 2
#define pre( n ) "x"n
#define pastejoin( n, k ) n##k.5
#define pasted( n ) 3##n
#define pastedexp( n ) 1e##n
#define ident1( n ) ne3
#define ident2( n ) n5
#define member( n ) n.x

print "a"; dot5( 2 ); sizeof( dot5( 2 ) )
print "b"; one( 2 ); sizeof( one( 2 ) )
print "c"; twice( 2 ); sizeof( twice( 2 ) )
print "d"; expo( 2 ); sizeof( expo( 2 ) )
print "e"; dotexp( 2 ); sizeof( dotexp( 2 ) )
print "f"; trail( 2 ); sizeof( trail( 2 ) )
print "g"; lead( 5 ); sizeof( lead( 5 ) )
print "h"; pair( 3, 14 ); sizeof( pair( 3, 14 ) )
print "i"; pair( 3, ); sizeof( pair( 3, ) )
print "j"; cmp( < )
print "k"; pre( "y" )
print "l"; pastejoin( 1, 2 ); sizeof( pastejoin( 1, 2 ) )
print "m"; pasted( 2 ); sizeof( pasted( 2 ) )
print "n"; pastedexp( 2 ); sizeof( pastedexp( 2 ) )
print "o"; ident1( 2 )
print "p"; ident2( 2 )
print "q"; member( foo )
print "r"; dot5( 2 + 1 ); sizeof( dot5( 2 + 1 ) )
print "s"; dot5( 2 ); sizeof( dot5( 2 ) )
