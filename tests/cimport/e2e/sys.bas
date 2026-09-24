'' sys.bas -- the target's own C library through #cinclude, several headers in one unit
'' (each one after the first a delta), linked and RUN by build/cimporte2e.sh. Only functions
'' with a symbol: the UCRT's snprintf and printf are inline, and have none to bind.
#cinclude "stdlib.h"
#cinclude "string.h"
#cinclude "stdio.h"
#ifdef __FB_WIN32__
#cinclude "windows.h"
#endif

function cmp_long cdecl( byval a as const any ptr, byval b as const any ptr ) as long
    return *cptr( const long ptr, a ) - *cptr( const long ptr, b )
end function

dim as zstring * 32 s = "hello, world"
print "strlen", strlen( @s )
print "atoi", atoi( "12345" )
dim as long xs( 0 to 4 ) = { 5, 3, 9, 1, 7 }
qsort( @xs( 0 ), 5, sizeof( long ), @cmp_long )
print "qsort", xs( 0 ); xs( 1 ); xs( 2 ); xs( 3 ); xs( 4 )
dim as zstring * 64 buf
strcpy( @buf, "con" )
strcat( @buf, "cat" )
print "strcat", buf
#ifdef __FB_WIN32__
dim as zstring * 8 z = "abcd"
print "win32", (GetCurrentProcessId( ) <> 0), MulDiv( 10, 20, 5 ), lstrlenA( cptr( LPCSTR, @z ) )
#else
print "win32", -1, 40, 4
#endif
