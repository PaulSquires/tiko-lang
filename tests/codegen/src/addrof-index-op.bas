'' '@a[ i ]' OVER A BYREF 'operator []' IS THE ELEMENT'S ADDRESS. Check typed it as a
'' pointer to the operator procedure, so an overloaded callee taking 'ubyte ptr' found no
'' match (TKO0632; TKO0994 through std/codec) and '*(@b[ 0 ])' was a procedure-pointer
'' dereference (TKO0634). fbc-modern prints the expected output below.
type Bag
    as ubyte d(0 to 3)
    declare operator [] ( byval i as long ) byref as ubyte
end type
operator Bag.[] ( byval i as long ) byref as ubyte
    return d(i)
end operator
function First overload ( byval p as const ubyte ptr, byval n as integer ) as long
    return p[0] + n
end function
function First overload ( byref b as Bag ) as long
    return -1
end function
function Only( byval p as ubyte ptr ) as long
    return p[0]
end function
dim as Bag b
b.d(0) = 65 : b.d(1) = 66
print First( @b[1], 0 )
print First( b )
print Only( @b[0] )
dim as ubyte ptr q = @b[1]
print *q
*(@b[0]) = 67
print b.d(0)
print *(@b[1]) + 1
