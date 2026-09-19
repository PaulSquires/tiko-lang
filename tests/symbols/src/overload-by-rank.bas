'' AN ARRAY ARGUMENT CHOOSES AN OVERLOAD BY ITS RANK. 'a( any )' takes a one-dimensional
'' array and 'a( any, any )' a two-dimensional one, and a 'dim a( )' of unknown rank takes
'' its rank from its FIRST redim. fbc-modern 1.20 prints 1 2 1 2 -- the shape of
'' overload/bydesc.bas's dimensions1vs2 group, where tiko-lang called all four calls
'' ambiguous (TKO0660).
function f overload( array( any ) as integer ) as integer
    function = 1
end function

function f overload( array( any, any ) as integer ) as integer
    function = 2
end function

dim array1( any ) as integer
dim array2( any, any ) as integer
dim byRedim1( ) as integer
redim byRedim1( 0 to 0 )
dim byRedim2( ) as integer
redim byRedim2( 0 to 0, 0 to 0 )

print f( array1( ) ), f( array2( ) ), f( byRedim1( ) ), f( byRedim2( ) )
