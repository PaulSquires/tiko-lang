type B extends object
	declare virtual sub proc2()
end type
sub B.proc2()
	print "B.proc2"
end sub
dim as B ptr p = new B
dim as any ptr ptr ptr q = cast( any ptr ptr ptr, p )
dim as sub( byref as B ) f = cptr( sub( byref as B ), (*q)[0] )
f( *p )
dim as any ptr ptr q2 = cast( any ptr ptr, p )
print q2 = cptr( any ptr ptr, p )
