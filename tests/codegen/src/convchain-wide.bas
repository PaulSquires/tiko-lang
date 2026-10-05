dim shared as wstring * 10 wq = "77"
type SG
    as long k
    declare operator cast( ) byref as wstring
end type
operator SG.cast( ) byref as wstring : print "[c]"; : return wq : end operator
type TG
    as double v
    declare constructor( )
    declare constructor( byref x as wstring )
end type
constructor TG( ) : end constructor
constructor TG( byref x as wstring ) : v = val( x ) : print "[k]"; : end constructor
sub takeG( byval x as TG ) : print " takeG"; x.v : end sub
dim as SG sg1
takeG( sg1 )
dim as TG qg = sg1 : print " qg"; qg.v
type SH
    as long k
    declare operator cast( ) as string
end type
operator SH.cast( ) as string : print "[c]"; : return "55" : end operator
type TH
    as double v
    declare constructor( )
    declare constructor( byref x as wstring )
end type
constructor TH( ) : end constructor
constructor TH( byref x as wstring ) : v = val( x ) : print "[k]"; : end constructor
sub takeH( byval x as TH ) : print " takeH"; x.v : end sub
dim as SH sh1
takeH( sh1 )
dim as TH qh = sh1 : print " qh"; qh.v
