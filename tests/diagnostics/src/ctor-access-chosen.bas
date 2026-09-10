'' AN INITIALISER THAT NAMES A CONSTRUCTOR IS ASKED ABOUT THAT CONSTRUCTOR, not about
'' whether a reachable DEFAULT one happens to exist. Measured on fbc, three cases one
'' line apart -- and tiko was wrong in BOTH directions before this:
''
''     private ctor( ), public ctor( i ) : dim f as foo = foo(1)  fbc ACCEPTS, tiko refused
''     public ctor( ), PRIVATE ctor( i ) : dim f as foo = foo(1)  fbc err 205, tiko accepted
''     private ctor( ), public ctor( i ) : dim f as foo           fbc err 204, tiko refuses
''
'' This file is the SECOND case, the one tiko used to accept. The first is
'' tests/mir/ctor-access-split and the third was already right.
''
'' The winner had to be picked here rather than read off the node: for a type-call
'' 'foo( 1 )' Check binds the callee to the UDT and types the expression WITHOUT
'' resolving which constructor runs, and PickCtor does that costing in the MIR layer long
'' afterwards. CtorChosenBy_ is narrow on purpose -- anything it cannot settle, including
'' a tie, returns nothing and the old default-constructor question is asked instead.
'' Silence beats a new false refusal.
type foo
	as byte pad

	public:
	declare constructor ( )

	private:
	declare constructor ( i as integer )
end type

constructor foo( )
end constructor

private constructor foo( i as integer )
end constructor

dim shared f as foo = foo( 1 )
