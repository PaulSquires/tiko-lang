'' A VALUE WITH NO PRINTABLE FORM, printed, written or passed to str( ) -- fbc's error 24 on
'' lines 28 to 35 (fbc-modern 1.20). tiko dropped each statement in silence. A UDT prints only
'' through an 'operator cast' to a string: lines 37 to 40 are accepted, and lines 33 and 34 --
'' a cast 'as long' alone -- are not.
type U
    a as long
end type
type N
    a as long
    declare operator cast( ) as string
end type
operator N.cast( ) as string : return "N!" : end operator
type NW
    a as long
    declare operator cast( ) as long
end type
operator NW.cast( ) as long : return 7 : end operator
function F( ) as (long, long)
    return (3, 4)
end function
dim as (long, string) t = (1, "a")
dim as U vu
dim as N vn
dim as NW vnw
dim as string s
open "NUL" for output as #1

print t
print "x"; t
print F( )
write t
print #1, t
print vnw
s = str( vnw )
print vu

print vn
s = str( vn )
write vn
print cast( long, vnw )
