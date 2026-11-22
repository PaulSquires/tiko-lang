'' A member that does not exist, on what 'operator []' and 'operator *' return.
type V
    as long a
end type
type W
    as long z
    declare operator [] ( byval i as long ) as V
end type
operator W.[] ( byval i as long ) as V
    return type<V>( i )
end operator
type P
    as long a
end type
operator * ( byref p as P ) byref as V
    static as V v
    return v
end operator
dim as W ww
dim as P pp
print ww[0].nope( 1 )
ww[0].nope( 1 )
print (*pp).nope
print ww[0].a, (*pp).a
