'' THE MATH INTRINSICS -- int, fix, frac, abs, sgn, sqr and the transcendentals.
''
'' None of them were lowered, so every one declined. 'ctr1 = 1 + int( (b - a) / s )' is
'' the shape the corpus writes, and it was 280 declines in one file.
''
'' THREE DIFFERENT MECHANISMS, and which is which is not guessable from the others:
''
''   sqr sin cos tan asin acos atn log exp   gcc BUILTINS -- '__builtin_sqrt( X )'
''   abs                                     a builtin, and a DIFFERENT one per width:
''                                           __builtin_fabs / fabsf / llabs
''   fix frac sgn                            RUNTIME CALLS -- fb_FIXDouble, fb_FRACd,
''                                           fb_SGNl -- and SGN returns int32 from ALL
''                                           THREE, including the longint form, a return
''                                           width that does not follow its argument
''   atan2 and '^'                           plain libc calls, no builtin prefix, and
''                                           '^' makes BOTH operands doubles whatever
''                                           they were
''   int                                     a FLOOR and nothing else: fbc writes
''                                           'fb_D2L( __builtin_floor( X ) )', but
''                                           fb_D2L is a MACRO over nearbyint and that
''                                           is already the ordinary coercion
''
'' The builtins are OPCODES here rather than runtime entries, because a builtin is
'' declared nowhere: putting them in the inventory would fail check-rtl, which reads
'' what fbc declares.
''
'' ONE DIVERGENCE, deliberate: fbc folds an exponent of exactly 2 into a MULTIPLY --
'' 'x ^ 2.0' is 'X * X' -- which is only safe for an operand it may evaluate twice.
'' tiko-lang always calls pow. Same value, different code, and no risk of evaluating a call
'' twice.

sub P( )
    dim as single f = 1.0, g
    dim as double x = 5.0, y
    dim as longint q = -3
    dim as long n = -3

    n = int( x )  : y = int( x )  : g = int( f )
    g = fix( f )  : y = fix( x )
    g = frac( f ) : y = frac( x )
    n = abs( n )  : y = abs( x )  : g = abs( f )
    n = sgn( f )  : n = sgn( x )  : n = sgn( q )  : n = sgn( n )
    y = sqr( x ) : y = sin( x ) : y = cos( x ) : y = tan( x )
    y = asin( x ) : y = acos( x ) : y = atn( x )
    y = log( x ) : y = exp( x ) : y = atan2( x, x )
    y = x ^ y : y = n ^ n : g = f ^ f
end sub
