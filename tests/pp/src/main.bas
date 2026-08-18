#include once "guard.bi"
#include once "guard.bi"
#define ADD( a, b ) ((a) + (b))
#define NAME_OF( x ) #x
#define GLUE( a, b ) a##b
#if __FB_LANG__ = "fb"
print GREETING, ADD( 1, 2 )
#endif
#ifdef GREETING
print NAME_OF( abc ), __FB_QUOTE__( x + y )
#endif
#if defined( NOPE )
print "unreachable"
#elseif 2 * 3 = 6
print "elseif works"
#endif
dim as long GLUE( foo, bar ) = 7
TWICE( print "twice" )
print __FB_ARG_COUNT__( a, b, c )

'' A VARIADIC TAIL MAY BE EMPTY: '#macro v( a, c... )' invoked as 'v( 1 )' is legal, and
'' '#if #c = ""' is the usual way a macro asks whether it got any -- so requiring the tail
'' to be present made the very case worth testing for the one that could not be written.
#macro VTAIL( a, c... )
    dim as long a
#endmacro
VTAIL( vt1 )
VTAIL( vt2, 9 )
