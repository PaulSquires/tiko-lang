'' 'function = type( )' -- A BARE TYPE LITERAL has no type of its own, so the value path
'' answered nothing and there was no address to take either: the statement declined. It
'' is the RESULT TYPE that supplies the type, exactly as a declaration's does.
''
'' Measured, fbc builds a TEMPORARY, copies it into the hidden pointer and destroys it --
'' the temporary is why this only showed up on a type with a DESTRUCTOR:
''
''     _ZN8CLASSUDTC1Ev( &TMP$3$1 );
''     __builtin_memcpy( tmp$2$1, &TMP$3$1, 8 );
''     _ZN8CLASSUDTD1Ev( &TMP$3$1 );
''
'' and run, the function returns 123.
type ClassUdt
	as integer i
	declare constructor( )
	declare constructor( byref rhs as ClassUdt )
	declare destructor( )
end type

constructor ClassUdt( )
	this.i = 123
end constructor

constructor ClassUdt( byref rhs as ClassUdt )
	this.i = rhs.i
end constructor

destructor ClassUdt( )
end destructor

function f1( ) as ClassUdt
	function = type( )
end function

print f1( ).i

'' The named-constructor spelling beside it, which always worked.
function f2( ) as ClassUdt
	function = ClassUdt( )
end function

print f2( ).i
