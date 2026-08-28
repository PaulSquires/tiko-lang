'' A UDT WHOSE EVERY FIELD IS POINTER-SIZED IS A POINTER TABLE TOO, and it is how a
'' callback record is written. Measured:
''
''   static as fntype fn = ( @subr_cb, @func_cb )
''     static struct $6FNTYPE FN$0 = { (tmp$2)&SUBR_CB, (tmp$3)&FUNC_CB };
''
'' A UDT's initialiser is written '( a, b )' where an array's is '{ a, b }', and both
'' arrive as a flat list of words. The byte-image fold cannot express a RELOCATION, so
'' without this the declaration declined outright.
declare sub subr_cb( )
declare function func_cb( ) as long
type fntype
	s as sub( )
	f as function( ) as long
end type
static as fntype fn = ( @subr_cb, @func_cb )
fn.s( )
print fn.f( )
sub subr_cb( )
end sub
function func_cb( ) as long
	return 9
end function
