'' A 'defer' with nothing after it on the line is fbc's error 347 (fbc-modern 1.20,
'' 2026-09-25). tiko deferred the NEXT line: line 8's would have run 'print "y"' at the
'' exit, and line 12's swallowed 'end sub'. With a procedure named defer, 'defer :' first
'' on a line is 347 too (line 15); without one it is a label -- see defer-label.bas.
sub defer( )
end sub
sub s( )
    defer
    print "y"
end sub
sub t( )
    defer
end sub
sub u( )
    defer : print "now"
end sub
sub v( )
    scope : defer : print "now" : end scope
end sub
