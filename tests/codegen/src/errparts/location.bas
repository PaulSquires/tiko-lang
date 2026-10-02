sub F( )
    on local error goto h
    error 7
    exit sub
h:
    dim as long c = err
    print "err"; c; " in "; *erfn( )
end sub
F( )
