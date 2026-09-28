'' A NAMED VALUE, CALLED -- a scalar, a string, a field, a UDT variable. fbc's errors 3, 72 and
'' 24 on lines 16 to 21 (fbc-modern 1.20). tiko dropped each statement in silence. Lines 23 to
'' 27 are an array indexed, a dynamic one, an array argument and a procedure pointer called.
type T
    a as long
end type
dim as long n = 1
dim as long x
dim as string s = "abc"
dim as long arr( 2 )
dim as long darr( )
dim as T u
function Dbl( byval q as long ) as long : return q * 2 : end function
dim as function( byval as long ) as long pfn = @Dbl

x = n( )
x = n( 1 )
x = len( s( ) )
x = u.a( )
x = sizeof( n( ) )
print u( )

x = arr( 1 )
redim darr( 3 )
x = darr( 0 )
x = pfn( 2 )
x = ubound( arr )
