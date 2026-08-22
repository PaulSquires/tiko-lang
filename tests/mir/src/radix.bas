'' hex / oct / bin / space / string -- the NUMBER-TO-STRING family.
''
'' None of these existed, and their absence was SILENT: 'dim as string h = hex( 123 )'
'' allocated h, called nothing, and reported "0 statements not lowered".
''
'' FOUR WIDTHS EACH, chosen by the argument's SIZE and not by its name -- LONG is
'' 32-bit, so it takes _i and not _l -- and the digit-count form is a DIFFERENT ENTRY
'' POINT with a different capitalisation. Every one of the twenty-four appears below,
'' and check-rtl proves all of them against fbc.
''
'' The signed-to-unsigned coercion is not cosmetic: it is what makes 'hex( -1 )' on a
'' LONG come out FFFFFFFF instead of sign-extending to sixteen digits.
''
'' 'chr( 65 )' is at the end and still declines: fbc CONSTANT-FOLDS it to a literal and
'' calls nothing, which is a different job from this one.

sub P( )
    dim as string s
    dim as byte b : dim as ubyte ub : dim as short sh : dim as ushort ush
    dim as long l : dim as ulong ul : dim as longint q : dim as ulongint uq
    s = hex( b )   : s = hex( ub )  : s = hex( sh )  : s = hex( ush )
    s = hex( l )   : s = hex( ul )  : s = hex( q )   : s = hex( uq )
    s = hex( l, 4 )
    s = oct( l )   : s = oct( uq )  : s = oct( l, 4 )
    s = bin( l )   : s = bin( uq )  : s = bin( l, 4 )
    s = chr( 65 )  : s = chr( 65, 66 )
    s = space( 4 ) : s = string( 4, 65 ) : s = string( 4, "x" )
end sub
