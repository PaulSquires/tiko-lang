'' 'operator new[]' AND 'operator delete[]' ARE TWO TOKENS AND ONE NAME, the same way
'' 'operator []' is. The word half was already the name by the time the operator reader
'' ran, so its early-out fired and left the '[' where the PARAMETER LIST was expected --
'' the whole list was lost, 'size' was unbound, and the declared 'buf' became the
'' implicit 'this'.
''
'' All four allocation operators have Itanium codes, and tiko-lang spelled every one as
'' the vendor extension over the word -- '_ZN3BARv23newEu8UINTEGER', a name nothing
'' defines. Measured:
''
''     operator bar.new      _ZN3BARnwEu8UINTEGER( uint64 SIZE$1 )
''     operator bar.delete   _ZN3BARdlEPv( void* BUF$1 )
''     operator bar.new[]    _ZN3BARnaEu8UINTEGER
''     operator bar.delete[] _ZN3BARdaEPv
''
'' ONE parameter each: they are STATIC whether or not the definition repeats the word,
'' and treated as ordinary operators they took a 'this' nothing passes, so every
'' argument arrived one place late.
type bar
	as integer v
	declare static operator new ( byval size as uinteger ) as any ptr
	declare static operator delete ( byval buf as any ptr )
	declare static operator new[] ( byval size as uinteger ) as any ptr
	declare static operator delete[] ( byval buf as any ptr )
end type

operator bar.new ( byval size as uinteger ) as any ptr
	print "new"; size
	operator = allocate( size )
end operator

operator bar.delete ( byval buf as any ptr )
	print "delete"
	deallocate( buf )
end operator

operator bar.new[] ( byval size as uinteger ) as any ptr
	print "new[]"; size
	operator = allocate( size )
end operator

operator bar.delete[] ( byval buf as any ptr )
	print "delete[]"
	deallocate( buf )
end operator

dim as bar ptr p1 = new bar
delete p1
dim as bar ptr p2 = new bar[2]
delete[] p2
