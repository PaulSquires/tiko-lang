'' THE ACCEPTED HALF: the initialiser names the PUBLIC constructor, and the private
'' default one is irrelevant to it. fbc compiles this; tiko refused it, because
'' CheckImplicitStructors_ asked whether a reachable DEFAULT constructor existed
'' whichever constructor was actually written.
''
'' Its opposite is tests/diagnostics/ctor-access-chosen, which must still be REFUSED --
'' a fix that simply stopped asking would pass this file and break that one.
''
'' NOT 'dim shared'. A module-level SHARED initialised by a constructor call still
'' declines at lowerstore.bas -- static initialisation through a constructor is its own
'' gap and has nothing to do with accessibility. Using one here would have made this
'' test fail for the wrong reason.
type foo
	as byte pad

	private:
	declare constructor ( )

	public:
	declare constructor ( i as integer )
end type

private constructor foo( )
end constructor

constructor foo( i as integer )
	this.pad = 7
end constructor

dim f as foo = foo( 1 )
print f.pad
