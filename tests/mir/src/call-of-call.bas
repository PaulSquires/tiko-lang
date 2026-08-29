'' A CALLEE THAT IS ITSELF A CALL. 'f2( @f1 )( )' binds the INNER call to f2, so a symbol
'' IS in hand -- and taking it made the outer call a zero-argument call to f2, which is
'' the wrong arity and the wrong function. Measured, fbc calls the RESULT:
''
''   tmp$3 vr$0 = F2( (tmp$3)&F1 );  (vr$0)(  );
''   tmp$4 vr$2 = F4( (tmp$4)&F3 );  int32 vr$1 = (vr$2)(  );
''
'' So the node's SHAPE decides, not whether a symbol was bound: an N_CALL whose own type
'' is a procedure is a value to call, never a name. The same rule makes 'f( 1 )( 2 )'
'' over a table of function pointers lower.
sub f1( )
	print "f1"
end sub
function f2( byval p as sub( ) ) as sub( )
	return p
end function
function f3( ) as long
	return 123
end function
function f4( byval p as function( ) as long ) as function( ) as long
	return p
end function
f2( @f1 )( )
print f4( @f3 )( )
