'' A sub's bare name where a value is needed: fbc's 17 for 'print Report' and for
'' '__FUNCTION_NQ__' inside a sub (fbc-modern 1.20, 2026-10-25). TKO0873 at lines 9, 10, 11,
'' 12 and 14. A call statement, '@Report' and a function's name are fine (16-19).
sub Report( )
end sub
function Fn( ) as long
    return 1
end function
print Report
dim as long x = Report
x = Report
x = 1 + Report
sub R2( )
    print __FUNCTION_NQ__
end sub
Report
Report( )
dim as sub( ) sp = @Report
print Fn
