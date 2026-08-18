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
