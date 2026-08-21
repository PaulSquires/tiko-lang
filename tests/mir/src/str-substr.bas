'' The NARROW substring and trim family.
''
'' Each returns an FBSTRING* the runtime owns, and fbc emits NO fb_StrDelete for it --
'' unlike the wide family, there is no lifetime to model here.
''
'' The spellings are NOT consistent and were read off fbc one at a time: fb_TRIM but
'' fb_TrimEx, fb_LEFT but fb_StrMid. Guessing either from the other would have been
'' wrong in both directions.

sub P( byval n as long )
    dim as string a = "  ab  ", p = "x", b

    b = trim( a )
    b = trim( a, p )
    b = trim( a, any p )
    b = ltrim( a )
    b = rtrim( a )
    b = left( a, n )
    b = right( a, n )
    b = mid( a, n )
    b = mid( a, n, n )
    b = ucase( a )
    b = lcase( a )

    '' Nested, and mixed with concatenation. '&' and '+' are the SAME operation on
    '' strings -- fbc emits assign-then-concat-assign for both -- and only '+' was
    '' being flattened, so 'b = a & p' declined while 'b = a + p' lowered.
    b = ucase( trim( a ) ) & "!"
    b = a & p
    b = trim( a ) & p

    '' In a PRINT item. This has to be recognised BEFORE the string-type test:
    '' Check DOES type these calls as STRING, so the type test catches them and then
    '' LowerAddr on a call fails and the whole statement declines.
    print trim( a )
    print ucase( a )
end sub
