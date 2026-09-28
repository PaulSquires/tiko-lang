'' A PROPERTY WITH EMPTY PARENTHESES OPENING A STATEMENT -- fbc's error 9 on lines 21 to 23,
'' 26 to 30, 32 and 33 (fbc-modern 1.20). tiko accepted each. Lines 36 to 45 are accepted by
'' both: in an expression the parentheses may be empty.
type V
    as long a
    declare property P( ) as long
    declare property P( byval v as long )
    declare property Q( byval i as long ) as long
    declare property Q( byval i as long, byval v as long )
    declare property R( ) as long
    declare property W( byval v as long )
    declare sub M( )
end type
property V.P( ) as long : return a : end property
property V.P( byval v as long ) : a = v : end property
property V.Q( byval i as long ) as long : return a + i : end property
property V.Q( byval i as long, byval v as long ) : a = v : end property
property V.R( ) as long : return 7 : end property
property V.W( byval v as long ) : a = v : end property
sub V.M( )
    P( )
    P( ) = 1
    this.P( )
end sub
dim as V vv
vv.P( )
vv.P( ) = 3
vv.R( )
vv.W( )
vv.W( ) = 2
with vv
    .P( )
    .P( ) = 1
end with
dim as long x
x = vv.P( )
print vv.P( )
x = vv.R( )
x = vv.P
vv.P = 4
vv.R
x = vv.Q( 1 )
vv.Q( 1 ) = 5
vv.W( 6 )
print x
