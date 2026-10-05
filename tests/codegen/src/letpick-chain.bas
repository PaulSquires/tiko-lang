type SA
    as long k
    declare operator cast( ) as string
end type
operator SA.cast( ) as string : print "[cS]"; : return "42" : end operator
type TA
    as double v
    declare operator let( byval n as long )
    declare operator let( byval d as double )
    declare operator let( byref s as string )
end type
operator TA.let( byval n as long ) : v = n : print "[L]"; : end operator
operator TA.let( byval d as double ) : v = d : print "[D]"; : end operator
operator TA.let( byref s as string ) : v = val( s ) : print "[SA]"; : end operator
dim as TA tt
dim as short sh = 3 : dim as single sg = 1.5 : dim as longint li = 7 : dim as ubyte ub = 2
dim as SA sa1 : dim as zstring * 4 z = "9" : dim as wstring * 4 w = "8"
tt = 5 : print tt.v
tt = 2.5 : print tt.v
tt = "6" : print tt.v
tt = sh : print tt.v
tt = sg : print tt.v
tt = li : print tt.v
tt = ub : print tt.v
tt = z : print tt.v
tt = w : print tt.v
tt = sa1 : print tt.v
tt = true : print tt.v
dim shared as wstring * 8 wq = "31"
type SN
    as long k
    declare operator cast( ) as string
end type
operator SN.cast( ) as string : print "[cN]"; : return "21" : end operator
type SW
    as long k
    declare operator cast( ) byref as wstring
end type
operator SW.cast( ) byref as wstring : print "[cW]"; : return wq : end operator
type TW
    as double v
    declare operator let( byref w as wstring )
end type
operator TW.let( byref w as wstring ) : v = val( w ) : print "[W]"; : end operator
type TB
    as double v
    declare operator let( byval s as string )
end type
operator TB.let( byval s as string ) : v = val( s ) : print "[B]"; : end operator
dim as SN sn1 : dim as SW sw1 : dim as TW tw1 : dim as TB tb1
tw1 = sn1 : print tw1.v
tw1 = sw1 : print tw1.v
tb1 = sn1 : print tb1.v
tb1 = sw1 : print tb1.v
