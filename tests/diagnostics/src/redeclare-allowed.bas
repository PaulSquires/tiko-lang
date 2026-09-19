'' WHAT fbc ACCEPTS beside the rule that a procedure is declared once per scope -- every
'' shape here compiled clean under fbc-modern 1.20 and 1.10.1 (2026-09-18), and none may
'' be reported as a duplicate. See duplicate-declare.bas for the other side.

'' A definition after its declaration is the JOIN, private or not.
declare sub joined( )
sub joined( )
end sub
declare sub joinedPrivate( )
private sub joinedPrivate( )
end sub

'' An overload set: the keyword on the first declaration is enough.
declare function ov overload( byval a as long ) as long
declare function ov( byval a as double ) as long
function ov( byval a as long ) as long
    return a
end function
function ov( byval a as double ) as long
    return 1
end function

'' What makes a signature new: an array descriptor against a scalar, another element
'' type, a pointer.
declare sub ovShape overload( a( ) as long )
declare sub ovShape overload( byval a as long )
declare sub ovShape overload( a( ) as double )
declare sub ovShape overload( byval a as long ptr )

'' The same name in different scopes.
declare sub scoped( )
namespace scA
    declare sub scoped( )
end namespace
namespace scB
    declare sub scoped( )
end namespace

'' A guard sees the first declaration, so the second is never read.
declare function guarded( ) as ulong
#ifndef guarded
declare function guarded( ) as ulong
#endif

'' '#undef' removes a declared procedure -- ONE overload each, the first declared.
declare sub gone( )
#undef gone
declare sub gone( )
declare function goneOv overload( byval a as long ) as long
declare function goneOv overload( byval a as double ) as long
#undef goneOv
declare function goneOv( byval a as long ) as long

'' Members overload by signature with no keyword: a getter and its setter, two 'let'
'' operators, constructors, and two casts that differ only in their result.
type OkT
    x as long
    declare sub m( byval a as long )
    declare sub m( byval a as double )
    declare property p( ) as long
    declare property p( byval v as long )
    declare constructor( )
    declare constructor( byval a as long )
    declare operator let( byval a as long )
    declare operator let( byval a as double )
    declare operator cast( ) as long
    declare operator cast( ) as string
end type

'' So does a global operator.
declare operator + ( byref a as OkT, byref b as OkT ) as OkT
declare operator + ( byref a as OkT, byval b as long ) as OkT

'' Two KNOWN ranks are two overloads.
declare sub okRank overload( a( any ) as integer )
declare sub okRank overload( a( any, any ) as integer )

'' CONST distinguishes where it is not the passed value's own: through a BYREF, and on
'' what a pointer points at.
declare sub okConstRef overload( byref a as long )
declare sub okConstRef overload( byref a as const long )
declare sub okConstStr overload( s as string )
declare sub okConstStr overload( byref s as const string )
declare sub okConstPtr overload( byval a as long ptr )
declare sub okConstPtr overload( byval a as const long ptr )
declare sub okConstPtrPtr overload( byval a as long ptr ptr )
declare sub okConstPtrPtr overload( byval a as long const ptr ptr )

'' Each body written once: two overloads, a getter beside its setter, two constructors,
'' and two same-arity overloads that differ only in type.
type OkBody
    x as long
    declare sub ov( byval a as long )
    declare sub ov( byval a as string )
    declare property p( ) as long
    declare property p( byval v as long )
    declare constructor( )
    declare constructor( byval a as long )
end type
sub OkBody.ov( byval a as long )
end sub
sub OkBody.ov( byval a as string )
end sub
property OkBody.p( ) as long
    return 0
end property
property OkBody.p( byval v as long )
end property
constructor OkBody( )
end constructor
constructor OkBody( byval a as long )
end constructor

'' '#undef' of a GLOBAL name from inside a namespace, of a macro there, of a name nothing
'' declared, and of the namespace itself.
declare sub okGlobal( )
namespace OkUndefNs
    #undef okGlobal
    #define OK_MACRO 1
    #undef OK_MACRO
    #undef neverDeclared
    declare sub inside( )
end namespace
#undef OkUndefNs

'' '...' without OVERLOAD: declared, then defined -- the definition may even write
'' 'overload', joining a declaration that did not -- and a variadic member alone.
declare sub okVar cdecl( byval a as long, ... )
sub okVar cdecl( byval a as long, ... )
end sub
declare sub okVarKwDef cdecl( byval a as long, ... )
sub okVarKwDef cdecl overload( byval a as long, ... )
end sub
type OkVarT
    x as long
    declare sub m cdecl( byval a as long, ... )
end type
