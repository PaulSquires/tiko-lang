'' A PARAMETER WHOSE TYPE IS NOT RESOLVABLE YET IS REVISITED.
''
'' win/windef.bi writes
''
''     type WPARAM as UINT_PTR        ' line 111
''     ...
''     #include once "basetsd.bi"     ' line 129 -- where UINT_PTR is declared
''
'' -- the ALIAS first and its TARGET later -- and every mingw binding is built that way.
'' BackpatchTypedefs already revisited VARIABLE declarations for exactly this, so
'' 'dim as WPARAM w' was 8 bytes; PARAMETERS and RESULTS were never revisited, so
''
''     declare function SendMessageA( ..., byval wParam as WPARAM, ... ) as LRESULT
''
'' reached the emitter as 'declare void SendMessageA(ptr, i32, void, void)'. clang
'' refuses a void parameter, so windows.bi could not be used AT ALL -- and nothing said
'' so until the emitter.
type ALIAS_A as TARGET_A
type ALIAS_B as TARGET_B

type TARGET_A as longint
type TARGET_B as long

declare function Later_( byval a as ALIAS_A, byval b as ALIAS_B ) as ALIAS_A

function Later_( byval a as ALIAS_A, byval b as ALIAS_B ) as ALIAS_A
	return a + b
end function

dim as ALIAS_A v = Later_( 40, 2 )
print v, sizeof( ALIAS_A ), sizeof( ALIAS_B )
