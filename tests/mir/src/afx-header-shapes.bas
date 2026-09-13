'' THREE HEADER SHAPES AfxNova AND win/*.bi WRITE, each refused before, each accepted by fbc:
''
''   #include once "/crt/string.bi"   a LEADING SLASH, found under the include path
''   Shared : 1 as ulong               a KEYWORD field name with a BITFIELD width (win/psapi.bi)
''   byval h as .HWND                  a single leading DOT in a type: the global name
''
'' fbc prints: 4 1 5 8 1 2
#include once "/crt/string.bi"
type HWND_ as any ptr
type PS_T
	Flags as long
	Shared : 1 as ulong
	Other : 3 as ulong
end type
namespace NS
	type HWND_ as long
	function Pick( byval h as .HWND_ ) as long
		return iif( h = 0, 1, 2 )
	end function
	function Width_( byval h as HWND_ ) as long
		return sizeof( h )
	end function
end namespace
dim as PS_T p
p.Shared = 1 : p.Other = 5
print strlen( "abcd" ); p.Shared; p.Other; sizeof( PS_T ); NS.Pick( 0 ); NS.Width_( 3 ) \ 2
