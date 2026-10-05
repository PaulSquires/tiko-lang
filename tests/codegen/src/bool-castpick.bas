type B_bytedouble
    as long q
    declare operator cast( ) as byte
    declare operator cast( ) as double
end type
operator B_bytedouble.cast( ) as byte : print "[byte]"; : return 1 : end operator
operator B_bytedouble.cast( ) as double : print "[double]"; : return 1 : end operator
scope
    dim as B_bytedouble m
    dim as boolean bb = m : print bb
end scope
type B_singlelongint
    as long q
    declare operator cast( ) as single
    declare operator cast( ) as longint
end type
operator B_singlelongint.cast( ) as single : print "[single]"; : return 1 : end operator
operator B_singlelongint.cast( ) as longint : print "[longint]"; : return 1 : end operator
scope
    dim as B_singlelongint m
    dim as boolean bb = m : print bb
end scope
type B_shortulong
    as long q
    declare operator cast( ) as short
    declare operator cast( ) as ulong
end type
operator B_shortulong.cast( ) as short : print "[short]"; : return 1 : end operator
operator B_shortulong.cast( ) as ulong : print "[ulong]"; : return 1 : end operator
scope
    dim as B_shortulong m
    dim as boolean bb = m : print bb
end scope
type B_doublesingle
    as long q
    declare operator cast( ) as double
    declare operator cast( ) as single
end type
operator B_doublesingle.cast( ) as double : print "[double]"; : return 1 : end operator
operator B_doublesingle.cast( ) as single : print "[single]"; : return 1 : end operator
scope
    dim as B_doublesingle m
    dim as boolean bb = m : print bb
end scope
type B_ubytebyte
    as long q
    declare operator cast( ) as ubyte
    declare operator cast( ) as byte
end type
operator B_ubytebyte.cast( ) as ubyte : print "[ubyte]"; : return 1 : end operator
operator B_ubytebyte.cast( ) as byte : print "[byte]"; : return 1 : end operator
scope
    dim as B_ubytebyte m
    dim as boolean bb = m : print bb
end scope
