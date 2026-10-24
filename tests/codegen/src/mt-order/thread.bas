'' Makes a thread: the unit that turns __FB_MT__ on -- for itself from the call on, and for
'' every unit after it. See tests/codegen/mt-order-*-run.test.
sub Worker( byval p as any ptr )
end sub
threadwait( threadcreate( @Worker ) )
print "thread unit: "; __FB_MT__
