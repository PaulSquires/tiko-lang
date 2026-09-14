'' 'if ... then end f( )' is the END STATEMENT. The 'scope' on the next line opens a
'' block; it must not be read as 'end scope' and undefine SCOPED_NOTE early.
'' fbc-modern prints "in" then 7.
function Report( byval s as string ) as long
    return 0
end function
scope
    #define SCOPED_NOTE 7
    dim as long x = 1
    if x = 0 then end Report( "a" )
    scope
        print "in"
    end scope
    print SCOPED_NOTE
end scope
