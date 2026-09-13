'' THE RESULT AT ENTRY. Measured in fbc's C, and what this program prints under fbc:
''
''     fplain_none      memset( &fb$result, 0, 512 )        0
''     fctor_assign     _ZN5TCTORC1Ev( &fb$result )         7  (function = never runs)
''     fctor_none       _ZN5TCTORC1Ev( &fb$result )         7
''     fctor_exit       _ZN5TCTORC1Ev( &fb$result )         7
''     finit_none       _ZN5TINITC1Ev( &fb$result )         5
''     fdtor_none       _ZN5TDTORC1Ev( tmp )                3  (hidden pointer)
''     fctor_return     nothing -- 'return t' copies in     7
type TPLAIN
	x(63) as integer
end type
type TCTOR
	x(63) as integer
	declare constructor( )
end type
constructor TCTOR( )
	x(0) = 7
end constructor
type TINIT
	x(63) as integer
	y as integer = 5
end type
type TDTOR
	x as integer
	declare constructor( )
	declare destructor( )
end type
constructor TDTOR( )
	x = 3
end constructor
destructor TDTOR( )
end destructor
function fplain_none( ) as TPLAIN
end function
function fctor_assign( ) as TCTOR
	dim as TCTOR t0
	if 0 = 1 then function = t0
end function
function fctor_none( ) as TCTOR
end function
function fctor_exit( byval k as integer ) as TCTOR
	if k then exit function
end function
function finit_none( ) as TINIT
end function
function fdtor_none( ) as TDTOR
end function
function fctor_return( ) as TCTOR
	dim as TCTOR t
	return t
end function
dim as TPLAIN p = fplain_none( ) : print p.x(5)
dim as TCTOR q = fctor_assign( ) : print q.x(0)
q = fctor_none( ) : print q.x(0)
q = fctor_exit( 1 ) : print q.x(0)
dim as TINIT r = finit_none( ) : print r.y
dim as TDTOR s = fdtor_none( ) : print s.x
q = fctor_return( ) : print q.x(0)
