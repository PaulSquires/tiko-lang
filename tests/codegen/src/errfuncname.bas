'' -exx NAMES THE PROCEDURE IN A RUNTIME ABORT. fbc says
''
''     at line 4 of errfuncname.bas::TOUCHIT()
''
'' and this said 'of errfuncname.bas()' -- the file named and the function slot empty.
'' Measured against fbc, whose abort text this now matches byte for byte, in a SUB and
'' at module level both.
sub touchit( )
    dim as integer a(0 to 2)
    dim as integer i = 5
    a(i) = 1
end sub

touchit( )
