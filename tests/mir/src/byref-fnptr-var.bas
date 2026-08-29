'' A BYREF VARIABLE HOLDING A FUNCTION POINTER whose result is BYREF, and the address
'' of what it returns.
''
'' 'dim byref p2 as function( ) byref as integer = p1' is a REFERENCE wrapping the
'' pointer, so the pointer test in LowerAddr missed it and '@(p2( ))' declined while
'' '@(p1( ))' on the line above lowered. Measured, fbc reads the same pointer either
'' way -- 'int64* vr$3 = (*P2$0)( );' -- and dim/byref.bas is one statement of this.
dim shared gi as integer = 123
function f( ) byref as integer
    function = gi
end function
dim p1 as function( ) byref as integer = @f
dim byref p2 as function( ) byref as integer = p1
print p2( )
print ( @(f( )) = @gi )
print ( @(p1( )) = @gi )
print ( @(p2( )) = @gi )
