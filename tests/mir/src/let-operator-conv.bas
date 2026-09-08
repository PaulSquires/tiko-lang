'' A CONVERTING 'operator let' -- 'x = 5' over a UDT.
''
'' The same-type assignment operator was a call; a let taking something ELSE was not
'' reached at all, and the statement fell through to the ordinary store, which coerced
'' the scalar to the UDT's own type: '%t6 = trunc i64 5 to [0 x i8]'. That verified
'' here and clang rejected it -- 'invalid cast opcode for cast from i64 to [0 x i8]'.
''
'' Measured, fbc calls the operator with the argument byval and constructs no
'' temporary, picking the overload by the argument's type:
''
''     x = 5      _ZN1VaSEu7INTEGER( &X$0, 5ll )
''     x = 1.5    _ZN1VaSEd( &X$0, 0x1.8p+0 )
''
'' Run under fbc: 5 then 3.
type V
    as integer a
    declare operator let ( byval i as integer )
    declare operator let ( byval d as double )
end type

operator V.let ( byval i as integer )
    this.a = i
end operator

operator V.let ( byval d as double )
    this.a = cast( integer, d * 2 )
end operator

dim as V x
x = 5
print x.a
x = 1.5
print x.a
