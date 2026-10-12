'' Every stdio function the UCRT defines inline, called through crt.bi. On windows-x86_64 each
'' was "undefined symbol" at the link until tiko-rt defined it (lib/rt/src/c/msvccrt.c).
'' The output is fbc-modern's for the same program, except vsnprintf's truncation: tiko
'' follows the UCRT's C99 vsnprintf, as its snprintf already did.
#include once "crt.bi"
sub vp cdecl( byval fmt as zstring ptr, ... )
    dim as cva_list ap
    cva_start( ap, fmt )
    vprintf( fmt, ap )
    cva_end( ap )
end sub
sub vfp cdecl( byval fmt as zstring ptr, ... )
    dim as cva_list ap
    cva_start( ap, fmt )
    vfprintf( stdout, fmt, ap )
    cva_end( ap )
end sub
function vsnp cdecl( byval buf as zstring ptr, byval n as integer, byval fmt as zstring ptr, ... ) as long
    dim as cva_list ap
    cva_start( ap, fmt )
    function = vsnprintf( buf, n, fmt, ap )
    cva_end( ap )
end function
dim as zstring * 64 buf
dim as long a, b
dim as double d
printf( !"printf %d %s\n", 42, "str" )
vp( !"vprintf %x\n", 255 )
vfp( !"vfprintf %s\n", "ok" )
vsnp( @buf, 64, "%d", 7 )
sscanf( "12 34 5.5", "%d %d %lf", @a, @b, @d )
if a = 0 then scanf( "%d", @a ) : fscanf( stdin, "%d", @b )
