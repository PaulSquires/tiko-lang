'' '*' over a UDT with no 'operator *': a plain type, and ones casting to a number and to a
'' pointer -- a cast is not tried. The last has an 'operator *' and is fine.
dim shared as long g = 42
type U
    as long a
end type
type UC
    as long a
    declare operator cast ( ) as long
end type
operator UC.cast ( ) as long
    return 1
end operator
type UP
    as long a
    declare operator cast ( ) as long ptr
end type
operator UP.cast ( ) as long ptr
    return @g
end operator
type S
    as long a
end type
operator * ( byref x as S ) as long
    return x.a
end operator
dim as U h
dim as UC hc
dim as UP hp
dim as S hs
print *h
print *hc
print *hp
print *hs
