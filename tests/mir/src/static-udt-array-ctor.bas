'' A STATIC ARRAY OF UDT WITH AN INITIALISER LIST, over an element whose only
'' constructor takes an argument. The static-local path asked 'does the element need
'' DEFAULT construction?' -- it does not -- answered 'nothing to do', and fell to the
'' byte-image fold, which cannot fold a constructor call and declined.
''
'' Measured, fbc emits NO IMAGE AT ALL: a run-once guard and one constructor call per
'' element, at that element's own offset --
''
''     _ZN3BARC1Eu7INTEGER( (struct $3BAR*)B1$1, 1ll );
''     _ZN3BARC1Eu7INTEGER( (struct $3BAR*)((uint8*)B1$1 + 8ll), 2ll );
''
'' -- and run, it prints ' 1 2 5' on both calls, which is what makes it a STATIC.
type bar
	as integer v
	declare constructor( byval n as integer )
end type

constructor bar( byval n as integer )
	this.v = n
end constructor

sub S( )
	static as bar b1(0 to 4) = { bar(1), bar(2), bar(3), bar(4), bar(5) }
	print b1(0).v; b1(1).v; b1(4).v
end sub

S( )
S( )
