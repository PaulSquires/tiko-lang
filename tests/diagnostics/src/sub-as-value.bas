'' A SUB CALLED WHERE A VALUE IS WANTED -- fbc's error 17 on lines 18 to 24 (fbc-modern 1.20).
'' tiko dropped each statement in silence. Lines 26 to 31 call the same subs as statements,
'' through a pointer and a member too, and are accepted.
type O
    a as long
    declare sub M( )
end type
sub O.M( ) : end sub
sub Sb( ) : end sub
sub Take( byval f as sub( ) )
    f( )
end sub
function Fn( ) as long : return 4 : end function
dim as sub( ) pf = @Sb
dim as long x
dim as O vo

print Sb( )
print pf( )
x = Sb( )
x = pf( ) + 1
if Sb( ) then print 1
x = len( Sb( ) )
print vo.M( )

Sb( )
pf( )
vo.M( )
Take( @Sb )
if x then Sb( )
x = Fn( )
