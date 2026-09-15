'' A SUBSTITUTED ARGUMENT AND THE BODY BESIDE IT RE-LEX AS ONE TOKEN when the body put
'' nothing between them. fbc's preprocessor substitutes the argument's TEXT and re-lexes,
'' so this is the rule tests/pp/src/macro-adjacency.bas describes at the END of an
'' expansion, one level in: at every seam a parameter, a '##' paste or a '#' stringise
'' makes with the body. Measured with 'fbc64 -pp':
''
''   #define m(n) n.5        m(2)      ->  2.5      tiko: 2 and .5, "expected the end
''                                                  of the statement"
''   #define m(n) n .5       m(2)      ->  2 .5     A SPACE STOPS IT, and fbc errors
''   #define m(n) 1n         m(2)      ->  12
''   #define m(n) n.n        m(2)      ->  2.2      two seams, joined left to right
''   #define m(n) 1en        m(2)      ->  1e2      100
''   #define m(n) n.e3       m(2)      ->  2.e3     2000
''   #define m(n) n.         m(2)      ->  2.0      a DOUBLE
''   #define m(n) 1.n        m(5)      ->  1.5
''   #define m(a,b) a.b      m(3,14)   ->  3.14, and m(3,) -> 3.0: an EMPTY argument
''                                                  still lets its neighbours meet
''   #define m(op) 1 op= 2   m(<)      ->  1 <= 2   operators join too
''   #define m(n) "x"n       m("y")    ->  "x""y"   ONE string, x"y
''   #define m(n,k) n##k.5   m(1,2)    ->  12.5     a paste's result joins as well
''   #define m(n) 3##n       m(2)      ->  32       and the '#' of '##' is not a
''   #define m(n) 1e##n      m(2)      ->  1e2      DOUBLE suffix on the number
''   #define m(n) ne3        m(2)      ->  ne3      a whole identifier is never the
''   #define m(n) n5         m(2)      ->  n5       parameter, with or without a join
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
#define spaced( n ) n .5

print dot5( 2 )
print one( 2 )
print twice( 2 )
print expo( 2 )
print dotexp( 2 )
print trail( 2 )
print lead( 5 )
print pair( 3, 14 )
print pair( 3, )
print cmp( < )
print pre( "y" )
print pastejoin( 1, 2 )
print pasted( 2 )
print pastedexp( 2 )
print ident1( 2 )
print ident2( 2 )
print member( foo )
print dot5( 2 + 1 )
