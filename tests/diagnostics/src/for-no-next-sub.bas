'' A FOR with no NEXT before the 'end sub' that closes the procedure around it -- fbc's
'' error 13 on line 6 (fbc-modern 1.20).
sub S( )
    for j as long = 1 to 2
        print j
end sub
