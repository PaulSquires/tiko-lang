'' Three small gaps that shared nothing but their size.
''
'' 'wspace( n )' -- THE WIDE TWIN OF SPACE. fb_WstrSpace was in the runtime table and had
'' no caller at all, so every 'e = wspace( 5 )' declined. The corpus builds most of its
'' EXPECTED VALUES that way, which is why lset and rset looked broken when they were not.
'' Measured: 'uint16* vr$4 = fb_WstrSpace( 5ll )', and the result is an allocation the
'' CALLER owns, so it is registered for its fb_WstrDelete like any other wide temporary.
''
'' 'wchr( a, b, c, d )' -- VARIADIC, up to 32 codes in fbc. A guard belonging to the
'' trim/mid family sat at the top of the whole wide-call function and refused a fourth
'' argument, so a four-code wchr declined while a three-code one lowered.
''
'' 'clear BYVAL p, 0, n' says the argument ALREADY IS the address, which is the whole
'' point of the spelling: 'clear @li, ...' takes the address of a TEMPORARY holding @li
'' and clears the temporary -- fbc's own warning 50 -- while 'clear byval @li, ...'
'' clears li. Measured, both from one probe. KW_BYVAL was unwrapped in exactly one place
'' in the lowerer, the user-call path, so here the wrapper reached LowerAddr, the
'' constant folder and LowerExpr in turn and none of them knew what it was.
sub s1( )
    dim as wstring * 50 e
    e = wspace( 5 )
    print len( e )

    dim as wstring * 40 a = wchr( 65, 66, 67, 68 )
    print a

    dim as integer li = 7
    clear byval @li, 0, sizeof( li )
    print li

    dim as integer lj = 9
    clear lj, 0, sizeof( lj )
    print lj
end sub

s1( )
