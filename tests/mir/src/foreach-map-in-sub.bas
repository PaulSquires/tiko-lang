'' FOR EACH OVER AN containers.Map INSIDE A SUB. MapIterator.Value( ) returns a KeyValuePair,
'' which has structors and so takes a hidden result pointer -- and the generic's members
'' are lowered AFTER the SUB that calls them. The call asked only the module whether the
'' callee took one, found no callee yet, and went out with the receiver alone:
''
''     %17 = call agg MapIterator<...>::VALUE(@$tmp4)     against
''     func ptr MapIterator<...>::VALUE(ptr $0, ptr $1)
''
'' -- verify refused it and clang saw a zero-sized aggregate. At module level the
'' definition already existed, so the same loop there was fine. fbsqlite's
'' 'for each entry in this.m_cache' is where it was found. fbc prints 77.
#import "std/containers"
type CachedStatement
	as any ptr handle
	as boolean busy
end type
sub f( )
	dim as containers.Map( of ustring, CachedStatement ) m
	dim as CachedStatement c
	c.handle = cptr( any ptr, 77 )
	m.Put( "k", c )
	for each entry in m
		print cast( integer, entry.value.handle )
	next
end sub
f( )
