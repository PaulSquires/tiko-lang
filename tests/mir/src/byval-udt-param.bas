'' A BYVAL UDT PARAMETER: which types go by POINTER with a caller-built copy, and
'' which still go by value.
''
'' Measured against fbc, one type per rule:
''   D1  a destructor only          -> pointer, memcpy into the temporary, temp destroyed
''   C1  a default constructor only -> BY VALUE, as a plain aggregate
''   S1  a string member            -> pointer, copy constructor, temp destroyed
''   V1  extends object             -> pointer, copy constructor, NO destruction
type D1
    as long a
    declare destructor( )
end type
destructor D1( ) : end destructor
type C1
    as long a
    declare constructor( )
end type
constructor C1( ) : end constructor
type S1
    as string s
end type
type V1 extends object
    as long a
end type
sub t1( byval v as D1 ) : print v.a : end sub
sub t2( byval v as C1 ) : print v.a : end sub
sub t3( byval v as S1 ) : print v.s : end sub
sub t4( byval v as V1 ) : print v.a : end sub
dim as D1 d : dim as C1 c : dim as S1 s : dim as V1 v
t1( d ) : t2( c ) : t3( s ) : t4( v )
