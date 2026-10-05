'' A UDT's pointer 'operator cast' reaches only its own pointer type, or any pointer
'' through 'any ptr'. Measured on fbc-modern: lines 18-20 and 22 are errors 24, 24, 181
'' and 58; lines 24-25 and 30 are 98 (two casts both reach 'any ptr'); 26-28 compile.
dim shared as long gl = 7
type A2
    as long v
    declare operator cast( ) as long ptr
    declare operator cast( ) as double ptr
end type
operator A2.cast( ) as long ptr : return @gl : end operator
operator A2.cast( ) as double ptr : return cast( double ptr, @gl ) : end operator
type A4
    as long v
    declare operator cast( ) as long ptr
end type
operator A4.cast( ) as long ptr : return @gl : end operator
dim as A2 o2 : dim as A4 o4
dim as byte ptr p1 = o2
dim as byte ptr p2 = o4
p1 = o2
sub tk( byval p as byte ptr ) : end sub
tk( o2 )
dim as any ptr v1
dim as any ptr v2 = o2
v1 = o2
dim as long ptr l1 = o2
dim as double ptr d1 = o2
dim as any ptr v3 = o4
sub ta( byval p as any ptr ) : end sub
ta( o2 )
