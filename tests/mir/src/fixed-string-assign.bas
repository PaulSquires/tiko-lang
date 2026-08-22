'' A FIXED-LENGTH STRING IS A CHAR ARRAY WITH NO DESCRIPTOR, and every runtime call
'' that touches one passes its DECLARED LENGTH where a var-length string passes -1.
''
'' Both directions were wrong, and differently:
''
''   c = fa    declined outright -- PushStrArg's -1 would have made the runtime read a
''             length out of the first bytes of the text, so it refused instead
''   fa = c    emitted NOTHING AT ALL and counted as fully lowered, because a fixed
''             string is not IsStringType and it fell through to the ordinary store
''             path, which had nothing to say about it either
''
'' The second is the worse of the two: the assignment simply did not happen, and no
'' number anywhere said so.
''
'' Every call below is what fbc emits, argument for argument.

dim shared as integer ct

sub P( )
    dim as string a = "x", b = "y", c
    dim as zstring * 8 fa = "x", fb2 = "y", fc

    c = fa                       '' fb_StrAssign( &C, -1, FA, 8, 0 )
    fa = c                       '' fb_StrAssign( FA,  8, &C, -1, 0 )

    '' AN IIF IN A STRING CONTEXT IS A STRING IIF whatever its arms look like. Asking
    '' the ARMS was not enough: Check computes no type for an intrinsic call, so an
    '' iif over two of them looked like an iif over nothing and declined.
    c = iif( ct, fa, fb2 )
    fc = iif( ct, fa, fb2 )

    '' fb_StrInit for a DIM initialiser, fb_StrAssign for an assignment -- measured,
    '' and true only of the descriptor branch. The literal one is fb_StrAssign in both.
    dim as zstring * 8 z1 = trim( a )
    dim as zstring * 8 z2
    z2 = trim( a )
    c = b
end sub
