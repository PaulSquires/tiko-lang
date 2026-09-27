'' Two argument shapes fbc accepts with a warning, and tiko dropped without one:
'' an ENUM to a pointer parameter (warning 1) and a NULL POINTER CONSTANT to an integer
'' one (warning 2). See tests/driver/enum-nullptr-args.test.
''
'' Each line prints what the callee received. fbc-modern 1.20 builds this with warnings 1
'' and 2 only, and prints:
''
''      2  2  3  1  1  2
''      0  0  0  0  0  0          (the nine-item line wraps at 80 columns, in both)
''      0  0  0
''      0  0  0  false  0  0
''      0
''
'' -- tiko's build prints the same bytes.

type T
    as long v
end type

enum E
    EA = 1
    EB
end enum

enum G explicit
    GA = 3
end enum

const KN = 0
const KP = cptr( any ptr, 0 )

function toT( byval p as T ptr ) as integer : return cast( integer, p ) : end function
function toAny( byval p as any ptr ) as integer : return cast( integer, p ) : end function
function toZ( byval p as zstring ptr ) as integer : return cast( integer, p ) : end function
function toFn( byval p as function( ) as long ) as integer : return cast( integer, p ) : end function

function asLong( byval i as long ) as long : return i : end function
function asByte( byval i as byte ) as long : return i : end function
function asUShort( byval i as ushort ) as long : return i : end function
function asInteger( byval i as integer ) as long : return i : end function
function asBool( byval b as boolean ) as boolean : return b : end function
function asEnum( byval x as E ) as long : return x : end function
function asRLong( byref i as long ) as long : i += 0 : return i : end function

dim as E e1 = EB
dim as G g1 = G.GA

'' AN ENUM TO A POINTER: the pointer holds the enum's value.
print toT( e1 ), toT( EB ), toT( g1 ), toAny( EA ), toZ( EA ), toFn( e1 )

'' A NULL POINTER CONSTANT, in every spelling fbc folds to one, to a long.
print asLong( cptr( any ptr, 0 ) ), asLong( cptr( T ptr, 0 ) ), asLong( cast( integer ptr, 0 ) ), _
      asLong( cptr( any ptr, &h0 ) ), asLong( cptr( any ptr, -0 ) ), asLong( cptr( any ptr, KN ) ), _
      asLong( KP ), asLong( ( cptr( any ptr, 0 ) ) ), asLong( cptr( any ptr, 1 - 1 ) )

'' ...and to the other integer kinds, a boolean, an enum and a BYREF long.
print asByte( cptr( any ptr, 0 ) ), asUShort( cptr( any ptr, 0 ) ), asInteger( cptr( any ptr, 0 ) ), _
      asBool( cptr( any ptr, 0 ) ), asEnum( cptr( any ptr, 0 ) ), asRLong( cptr( any ptr, 0 ) ), _
      asLong( cptr( any ptr, KN + 0 ) )
