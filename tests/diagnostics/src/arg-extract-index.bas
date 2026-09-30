'' __FB_ARG_EXTRACT__'s index must be an integer constant: a float (fbc's 17) or a name no
'' macro defines (fbc's 42, 'Variable not declared') is refused.
#define TWO 2
print __FB_QUOTE__( __FB_ARG_EXTRACT__( 3.5, a, b, c ) )       '' 17
print __FB_QUOTE__( __FB_ARG_EXTRACT__( nosuch, a, b, c ) )    '' 42
print __FB_QUOTE__( __FB_ARG_EXTRACT__( TWO, a, b, c ) )       '' fine
print __FB_QUOTE__( __FB_ARG_EXTRACT__( 1, a, b, c ) )         '' fine
