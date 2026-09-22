'' SIZEOF AND LEN OVER AN ARRAY MEASURE ITS ELEMENT.
''
'' fbc's rule, measured on fbc-modern 1.20.0 (2026-09-19) by compiling and RUNNING each
'' line. tiko-lang answered the whole array's storage instead, which is a plausible
'' number rather than a diagnostic -- and over an array of UDTs it answered nothing at
'' all and took the PRINT around it with it.
''
'' A FIXED-LENGTH STRING IS AN ARRAY IN THE TYPE MODEL AND NOT ONE FOR THIS RULE:
'' 'zstring * 8' is 8 and 'string * 6' is 6, the whole thing, and an ARRAY of either
'' measures one element -- 8 and 6 again.

type T2
    x as long
    y as long
end type

type H
    arr( 0 to 3 ) as long
    n as long
end type

'' MODULE LEVEL, and declared before P uses them: the CONSTANT and the array BOUND
'' below are folded by the constant evaluator rather than by lowering, and it had the
'' same rule wrong -- K was 4 and the bound 4, so 'c2' ran 4 to 4 instead of 1 to 4.
dim b0( 0 to 3 ) as ubyte
const K = sizeof( b0 )                  '' 1, and it was 4
'' THE BOUND IS THE SAME FOLD, and the size below is the assertion on it: four
'' longs, 1 to 4. With the old rule the bound was 4 and the array was 4 to 4.
dim c2( sizeof( b0 ) to 4 ) as long

'' THE CONSTANT EVALUATOR'S HALF, read back: K is 1 and c2 runs 1 to 4. AT MODULE LEVEL,
'' because c2 is a module-level 'dim' -- a local of main, which fbc's error 42 hides from
'' every procedure: see tests/diagnostics/module-local-not-shared.
dim as long s6 = K, s7 = lbound( c2 ), s8 = ubound( c2 )

sub P( )
    dim b( 0 to 3 ) as ubyte
    dim l( 0 to 3 ) as long
    dim m( 0 to 1, 0 to 2 ) as long
    dim t_( 0 to 2 ) as T2
    dim p_( 0 to 3 ) as long ptr
    dim sa( 0 to 2 ) as string
    redim d( 0 to 3 ) as long
    dim z as zstring * 8
    dim f as string * 6
    dim za( 0 to 2 ) as zstring * 8
    dim fa( 0 to 2 ) as string * 6
    dim as H h

    '' THE ELEMENT, every one of them.
    dim as long e1 = sizeof( b )        '' 1  -- was 4
    dim as long e2 = len( b )           '' 1  -- was 4
    dim as long e3 = sizeof( l )        '' 4  -- was 16
    dim as long e4 = sizeof( m )        '' 4  -- was 24, the whole 2 x 3
    dim as long e5 = sizeof( t_ )       '' 8  -- was nothing at all
    dim as long e6 = sizeof( p_ )       '' 8  -- was 32
    dim as long e7 = sizeof( sa )       '' 24 -- the descriptor, and no strlen
    dim as long e8 = len( sa )          '' 24 -- LEN agrees: fbc calls nothing here
    dim as long e9 = sizeof( d )        '' 4  -- dynamic, and already right
    dim as long e10 = sizeof( h.arr )   '' 4  -- through a FIELD
    dim as long e11 = sizeof( H.arr )   '' 4  -- and through the TYPE's own name

    '' NOT AN ARRAY FOR THIS RULE.
    dim as long s1 = sizeof( z )        '' 8
    dim as long s2 = sizeof( f )        '' 6
    dim as long s3 = sizeof( za )       '' 8, one element of the array of them
    dim as long s4 = sizeof( fa )       '' 6
    dim as long s5 = sizeof( H )        '' 20, a UDT is measured whole

end sub

