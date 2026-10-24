'' __FB_MT__ turns on AT the first thread-making call, not for the whole unit: fbc-modern 1.20
'' prints 0 before it and -1 after, in an expression and in an '#if', and in a procedure
'' defined later. See tests/codegen/mt-in-unit-run.test.
sub Worker( byval p as any ptr )
end sub
print "before: "; __FB_MT__
#if __FB_MT__
print "pp before: on"
#else
print "pp before: off"
#endif
threadwait( threadcreate( @Worker ) )
print "after: "; __FB_MT__
#if __FB_MT__
print "pp after: on"
#endif
sub Late( )
    print "in a later procedure: "; __FB_MT__
end sub
Late( )
