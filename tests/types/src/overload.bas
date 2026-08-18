'' Overload selection, on the cases that pin the ranking down. Each candidate pair
'' has distinct RETURN types, so the type of the call says which one was chosen --
'' the same trick tools/gen/overload-truth.py uses to ask fbc.
declare function f overload ( byval x as long ) as byte
declare function f overload ( byval x as double ) as short

declare function g overload ( byval x as byte ) as byte
declare function g overload ( byval x as ushort ) as short

declare function h overload ( byval x as short ) as byte
declare function h overload ( byval x as longint ) as short

declare function k overload ( byval x as integer ) as byte
declare function k overload ( byval x as ulongint ) as short

dim as ubyte u
dim as single s
dim as longint q
dim as long a
dim as uinteger w

print f( q )      '' byte  -- an integer argument takes the integer candidate
print f( s )      '' short -- a float argument takes the float one
print g( a )      '' short -- ushort is the NEARER WIDTH, though byte matches sign
print h( a )      '' short -- longint widens; short would narrow
print k( w )      '' short -- ulongint matches signedness, though integer is the
                  ''          family partner and one rank step away
