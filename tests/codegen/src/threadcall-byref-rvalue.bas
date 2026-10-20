' THREADCALL with a literal for a BYREF string parameter and an rvalue for a byref integer.
sub worker(byref id as string, byref n as integer)
    print id; n
end sub
dim as any ptr t = threadcall worker("A", 6 + 1)
if t then threadwait t
print "done"
