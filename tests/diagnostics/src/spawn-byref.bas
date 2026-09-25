'' 'spawn' of a procedure with a BYREF parameter -- fbc's error 358, on the FIRST-DECLARED
'' procedure of the name, written or by default. Checked with fbc-modern 1.20: 358 on
'' lines 40, 41, 42, 43 and 45; lines 44 and 46 are accepted.
namespace FB
#ifdef __FB_WIN32__
	#ifdef __FB_64BIT__
		extern "C"
	#else
		extern "Windows"
	#endif
#else
	extern "C"
#endif
#ifdef __FB_WIN32__
declare sub Spawn alias "fb_Spawn" _
	( byval work as sub stdcall( byval ctx as any ptr ), byval ctx as any ptr = 0 )
#else
declare sub Spawn alias "fb_Spawn" _
	( byval work as sub cdecl( byval ctx as any ptr ), byval ctx as any ptr = 0 )
#endif
end extern
end namespace
type U
	as long n
end type
sub W1( byref x as long ) : end sub
sub W2( x as string ) : end sub
sub W3( x as U ) : end sub
sub W4( byref x as long = 3 ) : end sub
sub W5( byval x as string ) : end sub
declare sub W6 overload ( byval x as long )
declare sub W6( byref s as string, byval y as long )
sub W6( byval x as long ) : end sub
sub W6( byref s as string, byval y as long ) : end sub
declare sub W7 overload ( byref s as string, byval y as long )
declare sub W7( byval x as long )
sub W7( byval x as long ) : end sub
sub W7( byref s as string, byval y as long ) : end sub
dim as long k = 1 : dim as string st = "x" : dim as U uu
spawn W1( k )
spawn W2( st )
spawn W3( uu )
spawn W4
spawn W5( st )
spawn W7( k )
spawn W6( k )
