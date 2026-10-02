dim as long x = 5
dim as any ptr a = @x
dim as any ptr ptr pa = @a
dim as long v = *a
*a = 7
print "A["; *a; "]B"
print *cptr( long ptr, a )
dim as long ptr lp = a
print *lp
print **pa
dim as any ptr b = *pa
print a[0]
sub Take( byref n as long )
end sub
Take( *a )
print @(*a)
print sizeof( *a )
