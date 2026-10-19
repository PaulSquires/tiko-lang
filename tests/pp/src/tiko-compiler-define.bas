'' __TIKO_COMPILER__ is tiko's identity define: defined, and 1. fbc does not define it,
'' so a guard that must also build under fbc tests it with '#ifdef' or 'defined( )'.
#ifndef __TIKO_COMPILER__
    #error "__TIKO_COMPILER__ is not defined"
#endif
#if __TIKO_COMPILER__ <> 1
    #error "__TIKO_COMPILER__ is not 1"
#endif
#if defined( __TIKO_COMPILER__ ) andalso defined( __TIKO_VERSION__ )
    print __TIKO_COMPILER__
#else
    #error "__TIKO_COMPILER__ and __TIKO_VERSION__ disagree"
#endif
