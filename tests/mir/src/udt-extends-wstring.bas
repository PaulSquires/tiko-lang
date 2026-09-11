#lang "fb"
type B extends wstring
    _data as wstring * 16
    declare constructor( byval rhs as const wstring const ptr )
    declare operator cast( ) byref as const wstring
end type
constructor B( byval rhs as const wstring const ptr )
    _data = *rhs
end constructor
operator B.cast( ) byref as const wstring
    return _data
end operator
dim as B bv = wstr( "123" )
print sizeof( B )
print cint( bv )
print cbool( bv )
print len( bv )
print bv

type C extends wstring
    x as byte
end type
type D extends zstring
    x as byte
end type
print sizeof( C ); sizeof( D )
