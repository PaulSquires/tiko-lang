dim shared as long l
dim shared as integer i
dim shared as longint li
dim shared as single sg
#print typeof( l + i )
#print typeof( i + li )
#print typeof( 1 shl 32 )
#print typeof( 2147483648 )
declare function f overload ( byval x as long ) as byte
declare function f overload ( byval x as longint ) as short
#print typeof( f( i ) )
declare function g overload ( byval x as single ) as byte
declare function g overload ( byval x as longint ) as short
#print typeof( g( i ) )
