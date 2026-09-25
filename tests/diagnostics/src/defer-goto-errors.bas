'' A forward GOTO past a 'defer' whose scope holds the label: fbc's error 349 (fbc-modern
'' 1.20), reported on the GOTO's line once per defer crossed. Every GOTO marked 349 below
'' is one fbc refuses, and fbc accepts every other line of this file.
sub SameScope( )
    goto s1                             ' 349, twice: two defers
    defer print "a"
    defer print "b"
s1:
end sub
sub IntoScope( )
    goto s2                             ' 349
    scope
        defer print "a"
s2:
    end scope
end sub
sub OutThenPast( byval c as long )
    if c then
        goto s3                         ' 349
    end if
    defer print "a"
s3:
end sub
function InFunction( ) as long
    if 1 then goto s4                   ' 349
    defer print "a"
s4:
    return 1
end function
sub ScopeClosed( )
    goto s5
    scope
        defer print "a"
    end scope
s5:
end sub
sub OtherBranch( byval c as long )
    goto s6
    if c then
        defer print "a"
    else
s6:
    end if
end sub
sub SingleLineIf( )
    goto s7
    if 1 then defer print "a"
s7:
end sub
sub Backward( )
    dim as long i
s8:
    defer print "a"
    i += 1
    if i < 2 then goto s8
end sub
sub OutOfDeferScope( )
    scope
        defer print "a"
        goto s9
    end scope
s9:
end sub
sub OnGoto( byval n as long )
    on n goto s10
    defer print "a"
s10:
end sub
sub EmptyDefer( )
    goto s11
    defer : print "y"
s11:
end sub
scope
    goto s12                            ' 349, at module level
    defer print "a"
s12:
end scope
