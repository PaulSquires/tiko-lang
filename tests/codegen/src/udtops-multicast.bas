type N
    as long q
    declare operator cast( ) as long
    declare operator cast( ) as double
    declare operator cast( ) as string
end type
operator N.cast( ) as long : print "[L]"; : return 3 : end operator
operator N.cast( ) as double : print "[D]"; : return 3.5 : end operator
operator N.cast( ) as string : print "[S]"; : return "s" : end operator
type M
    as long q
    declare operator cast( ) as long
    declare operator cast( ) as double
end type
operator M.cast( ) as long : print "[l]"; : return 4 : end operator
operator M.cast( ) as double : print "[d]"; : return 4.5 : end operator
dim as N nv : dim as M mv
print nv & "x"
print "<" + nv + ">"
print nv
dim as long ll = mv : print ll
dim as double dd = mv : print dd
dim as integer ii = mv : print ii
dim as single ss = mv : print ss
print mv + 1
print mv + 1.5
print mv * 2
print -mv
print mv = 4
print mv > 4.2
if mv then print "t"
print iif( mv, 1, 2 )
print abs( mv )
print int( mv )
print len( str( nv ) )
