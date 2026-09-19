'' AN OPERATOR'S SHAPE -- how many parameters it takes (fbc's error 1), whether it may be a
'' member (153) and whether it must be one (152). Each is refused on exactly the line
'' fbc-modern 1.20 and 1.10.1 refuse it (2026-09-19); tiko-lang accepted them all. (It
'' already refused a global 'let', 'cast', '[]' and the compound assignments.)
type T
    x as long
    declare operator += ( )
    declare operator let ( byval a as long, byval b as long )
    declare operator cast ( byval a as long ) as long
    declare operator [] ( ) byref as long
    declare operator for ( byref s as T, byref t as T )
    declare operator next ( ) as integer
    declare operator new ( ) as any ptr
    declare operator + ( byref b as T ) as T
    declare operator -> ( ) byref as T
    '' ACCEPTED: each member shape fbc takes.
    declare operator -= ( byval a as long )
    declare operator cast ( ) as long
    declare operator [] ( byval i as long ) byref as long
    declare operator for ( )
    declare operator step ( byref s as T )
    declare operator next ( byref c as T, byref s as T ) as integer
    declare operator delete ( byval p as any ptr )
    declare operator @ ( ) as long ptr
end type
declare operator = ( byref a as T ) as integer
declare operator not ( byref a as T, byref b as T ) as T
declare operator - ( byref a as T, byref b as T, byref c as T ) as T
declare operator @ ( byref a as T ) as long ptr
declare operator new ( byval sz as uinteger ) as any ptr
declare operator for ( byref a as T )
'' ACCEPTED: each global shape fbc takes -- '+', '-' and '*' are unary too.
declare operator + ( byref a as T, byref b as T ) as T
declare operator - ( byref a as T ) as T
declare operator * ( byref a as T ) as long
declare operator len ( byref a as T ) as integer
declare operator -> ( byref a as T ) byref as T
'' LAST, because fbc's recovery from them disturbs what follows: 'andalso' and 'orelse'
'' are not overloadable at all -- fbc's 157.
declare operator andalso ( byref a as T, byref b as T ) as integer
declare operator orelse ( byref a as T, byref b as T ) as integer
