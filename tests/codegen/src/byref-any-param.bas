'' 'declare sub f( byref p as any )' and a body with a concrete type: one procedure, named by the declaration
declare sub test_const( byref p as any )
declare sub test_str( byref p as any )
test_const byval 1234
test_str "abcd"
sub test_const( byref p as integer )
	print cint( @p )
end sub
sub test_str( byref p as zstring ptr )
	print (@p = @"abcd"), *cast(zstring ptr, @p)
end sub
