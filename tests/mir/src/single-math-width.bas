'' A math builtin over a SINGLE is computed at SINGLE width. See
'' tests/mir/single-math-width.test.
''
'' Every result is stored into a DOUBLE, which is where the width shows: fbc emits
'' '(double)__builtin_sqrtf( S$0 )', so the double holds the SINGLE-rounded root.
'' fbc-modern 1.20 prints:
''
''     sqr         148.7103729248047
''     sin          -0.8933303356171
''     cos          -0.4494006633759
''     tan           1.9878259897232
''     atn           1.5707510709763
''     exp           4.4816889762878
''     dbl         148.7103741862853
''
'' -- the last one the same root over a DOUBLE, which stays double.

dim as single a = 1296, b = 1147.3
dim as single s = ( a - b ) * ( a - b ) + 3.1f
dim as single h = 1.5f
dim as double d = ( a - b ) * ( a - b ) + 3.1f

dim as double r
r = sqr( s ) : print using "sqr  ##########.#############"; r
r = sin( s ) : print using "sin  ##########.#############"; r
r = cos( s ) : print using "cos  ##########.#############"; r
r = tan( s ) : print using "tan  ##########.#############"; r
r = atn( s ) : print using "atn  ##########.#############"; r
r = exp( h ) : print using "exp  ##########.#############"; r
r = sqr( d ) : print using "dbl  ##########.#############"; r
