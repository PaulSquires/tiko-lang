#define YES 1
#macro M( s )
    #if defined( s )
        print "operand-substituted"
    #else
        print "operand-literal"
    #endif
#endmacro
M( YES )
#if defined( constructor )
print "keyword is defined"
#endif
#if defined( nosuchthing )
print "SHOULD NOT APPEAR"
#endif
#if defined( YES )
print "macro is defined"
#endif
