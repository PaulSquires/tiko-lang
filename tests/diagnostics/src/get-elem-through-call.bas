'' A GRAPHICS GET'S BUFFER AS AN ARRAY ELEMENT REACHED THROUGH A FUNCTION CALL -- fbc's error 28
'' on lines 17 and 18 (fbc-modern 1.20). tiko accepted both. From line 20 a member element, a
'' pointer member element, a plain array, a call's own pointer, PUT through a call and the file
'' GET are fbc's, and accepted. See symbols/constout.bas.
type AF
    array( 0 to 1023 ) as ubyte
end type
private function f1( byval p as AF ptr ) as AF ptr
    function = p
end function
private function f3( byref x as AF ) byref as AF
    function = x
end function
dim x as AF
dim as AF ptr px = @x
dim as ubyte ba( 0 to 1023 )
get ( 0, 0 )-( 31, 31 ), f1( @x )->array( 0 )
get ( 0, 0 )-( 31, 31 ), f3( x ).array( 0 )
'' accepted from here
get ( 0, 0 )-( 31, 31 ), x.array( 0 )
get ( 0, 0 )-( 31, 31 ), px->array( 0 )
get ( 0, 0 )-( 31, 31 ), ba
get ( 0, 0 )-( 31, 31 ), f1( @x )
put ( 0, 0 ), f1( @x )->array( 0 )
get #1, , f1( @x )->array( 0 )
print "end"
