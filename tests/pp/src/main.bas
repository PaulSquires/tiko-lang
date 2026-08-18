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

'' '#macro NAME?( a )' is callable WITH OR WITHOUT parentheses. The '?' is the opt-in: a
'' plain function-like macro used bare is not an invocation at all, and fbc reports the
'' name as an undeclared variable rather than expanding it.
#macro OPTP?( a )
    dim as long a
#endmacro
OPTP opt_bare
OPTP( opt_paren )

'' '#param' STRINGIZE. Its text must come from the ARGUMENT, not from the macro
'' invocation: RelexInto repoints synthesised tokens at the use site so diagnostics land
'' somewhere visible, and reading the span at that loc returned the call's own source
'' text -- '#a' for 's3(hello)' produced 's3(hell', the right LENGTH from the wrong file.
#macro STRZ( a )
    dim as long a
#endmacro
STRZ( strz_ok )

'' The empty case is the one the bug hid, and the one macros actually test for.
#macro STRTEST( a, c... )
    #if #c = ""
        dim as long strtest_empty
    #else
        dim as long strtest_hasargs
    #endif
#endmacro
STRTEST( 1 )
STRTEST( 1, 2 )
