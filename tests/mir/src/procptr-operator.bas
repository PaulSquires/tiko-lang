type T
    as long v
    declare operator += ( byval a as integer )
    declare operator += ( byref a as const T )
    declare operator [] ( byval a as integer ) as integer
    declare operator [] ( byref a as const T ) as integer
end type
operator T.+= ( byval a as integer ) : end operator
operator T.+= ( byref a as const T ) : end operator
operator T.[] ( byval a as integer ) as integer
    return a
end operator
operator T.[] ( byref a as const T ) as integer
    return 0
end operator
var f1 = procptr( T.+= )
var f2 = procptr( T.+=, sub( byval as integer ) )
var f3 = procptr( T.[] )
var f4 = procptr( T.[], function( byval as integer ) as integer )
