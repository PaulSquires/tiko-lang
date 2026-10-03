'' T69: nested, repeated, in a function with a result, and ON LOCAL ERROR GOTO 0.
function Twice( byval n as long ) as long
    on local error goto h
    if n < 0 then error 5
    return n * 2
h:
    return -1
end function
sub Off( )
    on local error goto 0
    print "off"
end sub
sub Inner( )
    on local error goto h
    error 3
    exit sub
h:
    print "inner:"; err
end sub
sub Outer( )
    on local error goto h
    Inner( )
    error 4
    exit sub
h:
    print "outer:"; err
end sub
on error goto top
for i as long = 1 to 3
    print Twice( i - 2 )
    Outer( )
next
Off( )
error 9
end
top:
print "top:"; err
