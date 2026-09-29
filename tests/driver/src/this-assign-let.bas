'' 'this = x' in a constructor is the object's 'operator let', whatever x's type: a double
'' and a longint here, as fbx's COleDateTime writes 'this = dtSrc' and 'this = timeSrc'.
type D
    as double v
    declare constructor( byval x as double )
    declare constructor( byval n as longint )
    declare operator let( byval x as double )
    declare operator let( byval n as longint )
end type
constructor D( byval x as double )
    this = x
end constructor
constructor D( byval n as longint )
    this = n
end constructor
operator D.let( byval x as double )
    v = x * 2
end operator
operator D.let( byval n as longint )
    v = n + 0.5
end operator
dim as D a = D( 1.25 ), b = D( 3ll )
print a.v; b.v
