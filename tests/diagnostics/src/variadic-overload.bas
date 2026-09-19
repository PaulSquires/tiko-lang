'' A PROCEDURE WITH '...' IS NEVER AN OVERLOAD -- fbc's error 143, reported as its error
'' 4 for anything but a constructor. Each shape below is refused on exactly the line
'' fbc-modern 1.20 and 1.10.1 refuse (2026-09-18); tiko-lang accepted every one.

'' Declared OVERLOAD, alone: a sub, a function, a definition, in a namespace, in 'extern'.
declare sub varAlone cdecl overload( byval a as long, ... )
declare function varFn cdecl overload( byval a as long, ... ) as long
sub varDef cdecl overload( byval a as long, ... )
end sub
namespace VarNs
    declare sub inside cdecl overload( byval a as long, ... )
end namespace
extern "C"
    declare sub varExtern overload( byval a as long, ... )
end extern

'' Joining an overload set, with the keyword or without it.
declare sub varJoin cdecl overload( byval a as double )
declare sub varJoin cdecl overload( byval a as long, ... )
declare sub varJoinNoKw cdecl overload( byval a as double )
declare sub varJoinNoKw cdecl( byval a as long, ... )

'' Members overload without a keyword, so a set may not form around a variadic one in
'' either order -- nor may a variadic member be declared OVERLOAD, nor any constructor
'' take '...'.
type VarT
    x as long
    declare sub m1 cdecl( byval a as long, ... )
    declare sub m1( byval a as double )
    declare sub m2( byval a as double )
    declare sub m2 cdecl( byval a as long, ... )
    declare sub m3 cdecl overload( byval a as long, ... )
    declare constructor cdecl( byval a as long, ... )
end type

'' fbc forgets a refused declaration: this set is not refused in turn.
declare sub varForgot cdecl overload( byval a as long, ... )
declare sub varForgot cdecl overload( byval a as double )
