type TN
    v as double
end type
type TSC
    v as double
    declare operator cast( ) as string
end type
operator TSC.cast( ) as string
    return "3"
end operator
type TF
    v as double
    declare operator cast( ) as double
end type
operator TF.cast( ) as double
    return v
end operator
type TDF extends TF
end type
type TQ
    v as double
end type
operator sqr( byref x as const TQ ) as double
    return 9
end operator
enum TE
    e1 = 4
end enum
dim as TN vn
dim as TSC vsc
dim as TF vf
dim as TDF vdf
dim as TQ vq
dim as string vs = "4"
dim as integer ptr vip
dim as boolean vb = true
dim as double d = 2
dim as TE ve = e1
print sqr( vn )
print abs( vsc )
print int( vs )
print sgn( vip )
print sqr( vb )
print atan2( 1.0, vn )
print sqr( d ); abs( vf ); sqr( vdf ); sqr( vq ); sqr( ve ); atan2( vf, d )
