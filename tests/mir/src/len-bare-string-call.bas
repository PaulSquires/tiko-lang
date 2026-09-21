'' LEN OVER A BARE STRING FUNCTION NAME CALLS THE FUNCTION. It took the name's
'' address instead -- LowerAddr answers a procedure with its code address -- so
'' fb_StrLen read the function's machine code as a descriptor: 'len( inkey )'
'' printed a pointer-sized number, 'len( inkey ) = 0' was false with no key
'' waiting, and 'len( command )' failed verify, the address having declared
'' fb_Command with no parameters. Measured from fbc's C:
''
''   len( inkey )     FBSTRING* vr = fb_Inkey( );       fb_StrLen( vr, -1ll )
''   len( command )   FBSTRING* vr = fb_Command( -1 );  fb_StrLen( vr, -1ll )
''   len( f )         the same, over the user's own function
function f( ) as string
    return "hello"
end function
dim as long a = len( inkey )
dim as long b = len( date )
dim as long c = len( command )
dim as long d = len( f )
dim as long e = len( (curdir) )
