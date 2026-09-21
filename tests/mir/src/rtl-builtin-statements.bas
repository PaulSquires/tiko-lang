'' THE RUNTIME PROCEDURES fbc knows without a declaration, as STATEMENTS, bare and
'' parenthesised. Every one of these was dropped with no diagnostic: the program built,
'' ran, and did not do it. Measured from fbc-modern's C (-gen gcc):
''
''   stop / system           fb_End( 0 )      system 2    fb_End( 2 )
''   reset                   fb_FileReset( )  reset 1     fb_FileResetEx( 1 )
''   getkey                  fb_Getkey( )
''   out 1, 2                fb_Out( (uint16)1, (uint8)2 )
''   wait 1, 2               fb_Wait( (uint16)1, 2, 0 )
''   setdate s / settime s   fb_SetDate( (FBSTRING*)s ) / fb_SetTime( (FBSTRING*)s )
''   bsave f, p, 16          fb_GfxBsave( &F, p, 16u, (void*)0ull )
''   pmap 1, 0               fb_GfxPMap( 1.0f, 0 )
''   pointcoord 0            fb_GfxCursor( 0 )
''   screenlist 8            fb_GfxScreenList( 8 )
''
'' ...and as VALUES, which need a type Check had none for: 'print pmap( 1, 0 )' could
'' not choose a print routine, and '*erfn( )' had nothing to dereference.
dim as any ptr q = callocate( 64 )
dim as string s = "10:00:00"
if len( s ) = 0 then
    reset
    reset 1
    getkey
    out 1, 2
    wait 1, 2
    wait( 1, 2, 3 )
    setdate "01-01-2020"
    settime s
    bsave "x.bin", q, 16
    pmap 1, 0
    pointcoord( 0 )
    screenlist 8
    print pmap( 10, 0 ); pointcoord( 0 ); screenlist( 32 ); getkey( ); out( 1, 2 )
    print *erfn( ); *ermn( )
    system 2
end if
stop
