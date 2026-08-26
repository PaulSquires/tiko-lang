'' 'redim z(any) as long' -- A DECLARATION, not a resize.
''
'' Measured: fbc emits NO runtime call for it at all. What it emits is byte for byte the
'' descriptor setup 'dim z(any)' emits -- data and pointer null, size zero, the element
'' length, DIMENSIONS set to the WRITTEN RANK and the dimension table zeroed -- so
'' lbound answers 0, ubound answers -1, and FOR EACH over it iterates no times.
''
'' tiko-lang already emitted exactly that, and then declined anyway: 'any' is a keyword
'' nowhere inside an expression, so it arrived as an ordinary identifier, resolved to
'' nothing, and its bound lowered to no value. The fix is not to build an
'' fb_ArrayRedimEx out of bounds that are not bounds.
sub s1( )
    redim z(any) as long
    print lbound( z ), ubound( z )

    dim as long t = 0
    for each v in z
        t += v
    next
    print t

    redim w(any, any) as double
    print lbound( w, 1 ), ubound( w, 1 )

    '' ...and an ordinary redim beside it still calls the runtime.
    redim q(0 to 3) as long
    q(2) = 5
    print ubound( q ), q(2)
end sub

s1( )
