dim shared as integer cnt
type bar
	declare operator new( size as uinteger ) as any ptr
	declare operator delete( buf as any ptr )
	pad as byte
end type
operator bar.new( size as uinteger ) as any ptr
	operator = new byte[size] { any }
	cnt += 1
end operator
operator bar.delete( buf as any ptr )
	delete[] cast( byte ptr, buf )
	cnt += 1
end operator
type Q
	as integer a, b
end type
dim as bar ptr pbar = new bar( any )
delete pbar
print cnt
dim as integer ptr pi = new integer( any )
dim as Q ptr pq = new Q( any )
print "after"
delete pi : delete pq
