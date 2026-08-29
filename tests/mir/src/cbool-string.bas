'' CBOOL OVER A STRING PARSES THE WORD, not a number. fbc has an entry point of its own
'' for it in each width -- fb_VALBOOL and fb_WstrValBool -- and 'cbool( "true" )' is
'' TRUE through them.
''
'' Reaching the integer row instead parsed "true" as a NUMBER, got 0, and answered
'' false, in a statement that verified and counted as lowered.
sub Narrow()
    dim as string s = "true"
    dim as boolean a = cbool( s )
    dim as boolean b = cbool( "false" )
    print a; b
end sub

sub Wide()
    dim as wstring * 8 w = wstr( "true" )
    dim as boolean a = cbool( w )
    print a
end sub

Narrow()
Wide()
