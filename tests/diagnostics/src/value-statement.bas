'' A VALUE ALONE AS A STATEMENT -- fbc's error 10 on lines 32 to 44, and 119 on 45 and 46
'' (fbc-modern 1.20). tiko dropped each statement in silence. Lines 48 to 58 are calls, a
'' method, a property read and a static member, and are accepted.
const KK = 3
enum EE
    e1
end enum
function F( ) as long : return 1 : end function
sub S2( ) : end sub
type V
    as long a
    as long b( 0 to 1 )
    as sub( ) fp
    declare sub M( )
    declare property P( ) as long
    declare static sub SM( )
end type
sub V.M( ) : end sub
property V.P( ) as long : return a : end property
sub V.SM( ) : end sub
dim as V vv
dim as V va( 0 to 1 )
dim as long n = 1
dim as long ar( 0 to 2 )
dim as string sa( 0 to 1 )
redim as long rr( 0 to 1 )
dim as long ptr p = @n
dim as sub( ) pf = @S2
dim as sub( ) pfa( 0 to 1 )
vv.fp = @S2
pfa( 0 ) = @S2
ar( 1 )
n
vv.a
vv.b( 1 )
va( 0 ).a
va( 0 )
sa( 1 )
rr( 0 )
p[0]
*p
(p)
pf
pfa( 0 )
KK
EE.e1
print "--"
F
F( )
S2
vv.M
vv.M( )
vv.P
V.SM
va( 0 ).M( )
pf( )
vv.fp( )
pfa( 0 )( )
print "end"
