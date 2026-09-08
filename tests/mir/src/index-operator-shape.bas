'' 'a[ i ]' OVER A UDT WITH 'operator []' TAKES ITS SHAPE FROM THE OPERATOR. Two things
'' were assumed instead, and both were wrong for anything but a container indexed by a
'' 32-bit subscript.
''
'' THE INDEX WAS COERCED TO MT_I32. 'operator []( byval i as integer )' takes an i64 on
'' win64 -- fbc emits '_ZN1VixEu7INTEGER( &X$0, 3ll )' -- so the argument was truncated
'' and handed to a parameter twice its width. clang refused the whole module:
'' "'%t8' defined with type 'i32' but expected 'i64'". Every 'operator []' declared with
'' the natural spelling was affected, byref and byval alike, so no container in the
'' runtime headers indexed by an INTEGER could be compiled at all.
''
'' THE RESULT WAS ASSUMED BYREF. That is one of the two shapes fbc writes:
''
''     byref   int32* vr = _ZN1TixEi( &A, 1 );  *vr = 99;   -- an lvalue
''     byval   int64  vr = _ZN1VixEu7INTEGER( &X$0, 3ll );  -- a value
''
'' Taking the pointer shape for both loaded through an integer.
''
'' Measured against fbc, which prints '8' then '0 10 20 30' and '0 10 99 30'.
type Val
    as integer a
    declare operator [] ( byval i as integer ) as integer
end type

operator Val.[] ( byval i as integer ) as integer
    operator = this.a + i
end operator

type Ref
    as integer buf(0 to 3)
    declare sub init( )
    declare operator [] ( byval i as integer ) byref as integer
end type

sub Ref.init( )
    for k as integer = 0 to 3
        buf(k) = k * 10
    next
end sub

operator Ref.[] ( byval i as integer ) byref as integer
    return this.buf(i)
end operator

dim as Val v
v.a = 5
print v[3]

dim as Ref r
r.init( )
print r[0], r[1], r[2], r[3]
'' THE BYREF ONE IS AN LVALUE, which is what the pointer shape is for.
r[2] = 99
print r[0], r[1], r[2], r[3]
