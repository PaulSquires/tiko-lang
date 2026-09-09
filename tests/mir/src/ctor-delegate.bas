'' 'constructor( ... )' AS A STATEMENT IS A CALL, NOT A DEFINITION -- one constructor
'' delegating to another of the same type. A definition always names the type first
'' ('constructor Q( )'), so a '(' straight after the keyword can only be a call.
''
'' This was not a missing feature so much as a parse that ran away: 'constructor( )'
'' opened a new constructor, its 'end constructor' closed that, and the enclosing
'' 'end namespace' closed the real one. warnings/suffix-fb.bas lost a namespace three
'' hundred lines further down and reported 'expected end NAMESPACE' at end of file.
''
'' THE DELEGATING CONSTRUCTOR HAS NO PROLOGUE OF ITS OWN. Measured: fbc's C for it is
'' the delegated call and nothing else -- no base constructor, no field memset, and no
'' vptr store even for a type with virtual methods. The one it calls does all three,
'' and emitting a prologue as well would zero the fields AFTER they were filled.
''
'' 'base( )', 'x.constructor( )' and 'base.constructor( )' already worked: each begins
'' with something that is not a declaration keyword.
type Q
	n as integer
	declare constructor( )
	declare constructor( byval z as integer )
end type

constructor Q( )
	this.n = 5
end constructor

constructor Q( byval z as integer )
	constructor( )
	this.n += z
end constructor

'' The same thing inside a NAMESPACE, which is where the runaway parse showed up.
namespace ns
	type R
		m as integer
		declare constructor( )
		declare constructor( byval z as integer )
	end type

	constructor R( )
		this.m = 100
	end constructor

	constructor R( byval z as integer )
		constructor( )
		this.m += z
	end constructor
end namespace

dim as Q v = Q( 3 )
dim as ns.R w = ns.R( 7 )
print v.n, w.m
