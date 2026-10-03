'' T69: ON LOCAL ERROR puts back the handler and the setjmp buffer it replaced when the
'' procedure returns, so the caller's next error reaches the caller's handler.
sub Closing( )
    on local error goto h
    error 1
    print "not reached"
    exit sub
h:
    dim as long c = err
    print "close:"; c
end sub
on error goto top
Closing( )
error 2
print "not reached"
end
top:
dim as long c = err
print "open:"; c
