'' A PROCEDURE NAME IS DECLARED ONCE PER SCOPE. Every shape below is fbc error 4,
'' "Duplicated definition", on the SECOND line of its pair -- measured 2026-09-18 on
'' fbc-modern 1.20 and on 1.10.1, which agree on all of them. tiko-lang accepted every
'' one and chained the second as an overload.

'' Byte-identical, and the winuser.bi / AfxExt.bi shape that found it.
declare function dupSame( ) as ulong
declare function dupSame( ) as ulong
extern "Windows" lib "user32"
declare function dupLib( ) as ulong
declare function dupLib( ) as ulong
end extern

'' Differing in anything at all, without OVERLOAD.
declare sub dupParams( byval a as long )
declare sub dupParams( byval a as double )
declare sub dupKind( )
declare function dupKind( ) as long
declare sub dupAlias alias "a1"( )
declare sub dupAlias alias "b1"( )

'' A DECLARE after the definition, and a second body.
sub dupAfterDef( )
end sub
declare sub dupAfterDef( )
sub dupTwoBodies( )
end sub
sub dupTwoBodies( )
end sub

'' OVERLOAD has to be on the FIRST declaration.
declare function dupLateKw( byval a as long ) as long
declare function dupLateKw overload( byval a as double ) as long

'' An overload set takes a new signature, not the same one -- and the passing mode
'' does not make one new.
declare sub dupOverload overload( byval a as long )
declare sub dupOverload overload( byval a as long )
declare sub dupMode overload( byval a as long )
declare sub dupMode overload( byref a as long )

'' One scope however it is reached: a reopened namespace, an EXTERN block.
namespace dupNs
    declare sub inner( )
end namespace
namespace dupNs
    declare sub inner( )
end namespace
extern "C"
    declare sub dupExtern( )
end extern
declare sub dupExtern( )

'' Members overload without the keyword, but not on the same signature.
type DupT
    x as long
    declare sub m( byval a as long )
    declare sub m( byval a as long )
    declare property p( ) as long
    declare property p( ) as long
    declare constructor( )
    declare constructor( )
    declare destructor( )
    declare destructor( )
end type

'' And a global operator.
declare operator + ( byref a as DupT, byref b as DupT ) as DupT
declare operator + ( byref a as DupT, byref b as DupT ) as DupT
