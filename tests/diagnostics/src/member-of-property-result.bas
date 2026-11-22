'' A member that does not exist, on what a byref property getter returns.
type I
    as long colortype
end type
type S
    as long z
    as I i_
    declare property info ( ) byref as I
end type
property S.info ( ) byref as I
    return i_
end property
dim as S so
so.info.nope = 3
print so.info.nope
print so.info.colortype
