'' ADJACENCY: the LAST token a macro expansion emits and the NEXT token of the
'' enclosing stream RE-LEX AS ONE when the source put nothing between them. fbc's
'' preprocessor substitutes TEXT and re-lexes the line, so this is not a rule about
'' identifiers or about the '__' suffix in tests/vendor/fbc-tests/pp/hello.bas -- it
'' is about whitespace. Every line below was measured with 'fbc64 -pp':
''
''   #define letter(s) #s + letter : #define letter__ ""
''       letter (o)__      ->  $"o" + ""        the fold hello.bas is built on
''   #define letterX "z"
''       letter (o)X       ->  $"o" + "z"       so it is not about '__'
''       letter (o) __     ->  $"o" + letter  __, and error 89. A SPACE STOPS IT
''   #define M(x) x 12
''       M(a)34            ->  a 1234           NUMBER meets number
''   #define M(x) x <
''       M(a)> 3           ->  a <> 3           OPERATOR meets operator
''   #define M(x) x
''       M(ab)cd           ->  abcd             an ARGUMENT's tail joins too
''   #define M(x) x ab
''       M(q)12            ->  q ab12
''   #define M(x) x "s"
''       M(q)ab            ->  q "s"ab          '"s"ab' re-lexes as TWO; no join
''   #define N 12 : #define M(x) x N
''       M(a)ab            ->  a Nab            the join happens BEFORE the rescan,
''                                              so 'N' never expands
''   #define foobar(z) (z*2) : #define M(y) y foo
''       M(a)bar(3)        ->  a (3*2)          the JOINED name then expands, and
''                                              takes its arguments from the SOURCE
''   #define A(x) x q : #define B(x) r x
''       A(1)B(2)          ->  1 qB(2)          'B' is joined away, never invoked
''
'' And the FRONT of an expansion NEVER joins -- fbc emits a space before the result:
''
''   #define A bc  :  (A)12   ->   ( bc)12
''
'' Two object macros written apart do not join either: '#define A "a"' and
'' '#define B "b"' over 'A B' gives '"a" "b"'.

#define letter( seq ) #seq + letter
#define letter__ ""
#define merge( seq ) letter seq

#define TAIL( x ) x
#define LESSTHAN( x ) x <
#define N 12
#define TAILN( x ) N
#define foobar( z ) (z * 2)
#define TAILFOO( y ) foo
#define QTAIL( x ) q
#define BEE( x ) 999

dim as integer ab = 3
dim as integer abcd = 9
dim as integer Nab = 5
dim as integer qBEE = 4

'' The fold: twelve letters and the empty string that '__' turns 'letter' into.
print merge( (H)(e)(l)(l)(o)(.)(W)(o)(r)(l)(d)(!)__ )

'' A number meeting a number, and the tail that joins is the ARGUMENT's.
print TAIL( 12 )34

'' An operator meeting an operator: '<' and '>' become '<>'.
print LESSTHAN( 1 )> 3

'' An argument's tail meeting an identifier.
print TAIL( ab )cd

'' 'N' is joined onto 'ab' before anything looks for a macro named 'N', so the
'' answer is Nab (5) and not '12ab'.
print TAILN( 0 )ab

'' The joined name is itself a function-like macro, and its argument comes from
'' the source that followed the join.
print TAILFOO( 0 )bar( 3 )

'' 'BEE' is joined away and never invoked: qBEE is 4, not 'q 999'.
print QTAIL( 1 )BEE

'' One character short of a join is no join: 'ab' stands alone here.
print TAIL( 0 ); ab
