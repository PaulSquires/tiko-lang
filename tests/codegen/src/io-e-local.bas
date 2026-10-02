'' T68: the same check reaching a LOCAL handler, in the procedure that failed.
sub Closing( )
    on local error goto h
    close #7
    print "not reached"
    exit sub
h:
    dim as long c = err
    print "close:"; c
end sub
Closing( )
print "after"
