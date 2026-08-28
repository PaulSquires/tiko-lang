'' THREE SHAPES, each measured against fbc.
''
'' A NAME THAT IS BOTH A TYPE AND A PROCEDURE is, as the BASE of a member access, the
'' TYPE. An identifier in expression position prefers the VALUE class -- which is right
'' everywhere except here, because a PROCEDURE has no members to reach. Not
'' hypothetical: 'crt/time.bi' declares a global 'localtime' and 'fb/chrono.bi' declares
'' 'FB.LocalTime', and including both made every 'LocalTime.<static>( )' inside the
'' namespace resolve to the C function.
''
'' A CONVERTING CONSTRUCTOR MAY TAKE ITS OPERAND BYREF, and an rvalue has no address.
'' Measured, fbc makes two temporaries and passes the first's address:
''
''   TMP$2$0 = (int8)1;
''   _ZN3FOOC1ERa( &TMP$3$0, &TMP$2$0 );
''   BYVAL_( TMP$3$0 );
''
'' 'f( type( ) )' IS A BARE TYPE LITERAL: an empty tuple with no type name of its own,
'' so nothing typed it. The type comes from the PARAMETER, and both passing modes build
'' the same temporary and destroy it after the call:
''
''   _ZN1TC1Ev( &TMP$3$0 );  HPASSBYVAL( &TMP$3$0 );  _ZN1TD1Ev( &TMP$3$0 );
''   _ZN1TC1Ev( &TMP$4$0 );  HPASSBYREF( &TMP$4$0 );  _ZN1TD1Ev( &TMP$4$0 );
namespace NS
type Stamp
	m_ticks as longint
	declare static function FromTicks( byval v as longint ) as Stamp
	declare static function Midnight( ) as Stamp
end type
private function Stamp.FromTicks( byval v as longint ) as Stamp
	dim as Stamp r
	r.m_ticks = v
	return r
end function
private function Stamp.Midnight( ) as Stamp
	return Stamp.FromTicks( 0 )
end function
end namespace
declare function stamp cdecl alias "stamp" ( byval p as any ptr ) as any ptr
dim st as NS.Stamp = NS.Stamp.Midnight( )
print st.m_ticks

const TEST_VAL as byte = 1
type foo
	_type as long
	declare constructor( )
	declare constructor( byref v as byte )
end type
constructor foo( )
	this._type = 0
end constructor
constructor foo( byref v as byte )
	this._type = v
end constructor
sub byval_( byval f as foo )
	print f._type
end sub
byval_( TEST_VAL )

type T
	v as long
	declare constructor( )
	declare destructor( )
end type
constructor T( )
	this.v = 3
end constructor
destructor T( )
end destructor
sub hPassByval( byval x as T )
	print x.v
end sub
sub hPassByref( byref x as T )
	print x.v
end sub
hPassByval( type( ) )
hPassByref( type( ) )
