'' a static array's bound expression builds a temporary once, and destroys it once
dim shared as integer nc, nd
type ClassUdt
	i as integer
	declare constructor( byval i as integer )
	declare destructor( )
end type
constructor ClassUdt( byval i as integer ) : this.i = i : nc += 1 : print "+"; : end constructor
destructor ClassUdt( ) : nd += 1 : print "-"; : end destructor
function fInteger( byref x as ClassUdt ) as integer
	function = x.i
end function
sub staticRedimBoundsExpr( )
	static array(0 to fInteger( ClassUdt( 1 ) )) as integer
	print "[" & ubound(array) & "]";
end sub
staticRedimBoundsExpr( )
staticRedimBoundsExpr( )
print : print nc; nd
