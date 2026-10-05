dim shared as long gl = 7
dim shared as double gd = 2.5
type UU
    as long v
    declare operator cast( ) as any ptr
    declare operator cast( ) as long ptr
    declare operator cast( ) as double ptr
end type
operator UU.cast( ) as any ptr : print "[any]"; : return @gl : end operator
operator UU.cast( ) as long ptr : print "[long]"; : return @gl : end operator
operator UU.cast( ) as double ptr : print "[double]"; : return @gd : end operator
sub tl( byval p as long ptr ) : print " tl"; *p : end sub
sub td( byval p as double ptr ) : print " td"; *p : end sub
sub ta( byval p as any ptr ) : print " ta" : end sub
dim as UU x
dim as long ptr pl = x : print " pl"; *pl
dim as double ptr pd = x : print " pd"; *pd
dim as any ptr pa = x : print " pa"
tl( x )
td( x )
ta( x )
pl = x : print " pl="; *pl
pd = x : print " pd="; *pd
type A1
    as long v
    declare operator cast( ) as long ptr
    declare operator cast( ) as any ptr
end type
operator A1.cast( ) as long ptr : print "[long]"; : return @gl : end operator
operator A1.cast( ) as any ptr : print "[any]"; : return @gl : end operator
type A2
    as long v
    declare operator cast( ) as long ptr
    declare operator cast( ) as double ptr
end type
operator A2.cast( ) as long ptr : print "[long]"; : return @gl : end operator
operator A2.cast( ) as double ptr : print "[double]"; : return cast( double ptr, @gl ) : end operator
type A3
    as long v
    declare operator cast( ) as double ptr
    declare operator cast( ) as any ptr
end type
operator A3.cast( ) as double ptr : print "[double]"; : return cast( double ptr, @gl ) : end operator
operator A3.cast( ) as any ptr : print "[any]"; : return @gl : end operator
dim as A1 o1 : dim as A2 o2 : dim as A3 o3
dim as byte ptr b1 = o1 : print " b1"
dim as long ptr l3 = o3 : print " l3"
dim as zstring ptr z1 = o1 : print " z1"
if o1 then print " if1"
if o3 then print " if3"
