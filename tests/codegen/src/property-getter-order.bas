type T
    as long v = 5
    declare property P( byval i as long ) as long
    declare property P( ) as long
    declare property P( byval x as long )
end type
property T.P( byval i as long ) as long : return 100 + i : end property
property T.P( ) as long : return v : end property
property T.P( byval x as long ) : v = x : end property
dim as T o
print o.P
print o.P( 7 )
o.P = 9
print o.P
dim as long q = o.P
print q
