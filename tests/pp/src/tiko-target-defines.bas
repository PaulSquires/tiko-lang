'' TIKO_OS_* / TIKO_ARCH_* agree with the legacy __FB_WIN32__ / __FB_LINUX__, are "1"
'' so '#if' works as well as '#ifdef', and on Windows and Linux x86-64 the macOS and
'' aarch64 ones are absent.
#ifdef __FB_WIN32__
    #ifndef TIKO_OS_WINDOWS
        #error "TIKO_OS_WINDOWS not defined on Windows"
    #endif
    #ifdef TIKO_OS_LINUX
        #error "TIKO_OS_LINUX defined on Windows"
    #endif
#endif
#ifdef __FB_LINUX__
    #ifndef TIKO_OS_LINUX
        #error "TIKO_OS_LINUX not defined on Linux"
    #endif
    #ifdef TIKO_OS_WINDOWS
        #error "TIKO_OS_WINDOWS defined on Linux"
    #endif
#endif
#if defined( TIKO_OS_MACOS ) orelse defined( TIKO_ARCH_AARCH64 )
    #error "TIKO_OS_MACOS or TIKO_ARCH_AARCH64 defined on Windows/Linux x86-64"
#endif
#if TIKO_ARCH_X86_64 <> 1
    #error "TIKO_ARCH_X86_64 is not 1"
#endif
#if defined( TIKO_OS_WINDOWS )
    #if TIKO_OS_WINDOWS <> 1
        #error "TIKO_OS_WINDOWS is not 1"
    #endif
    #print os=windows
#elseif defined( TIKO_OS_LINUX )
    #if TIKO_OS_LINUX <> 1
        #error "TIKO_OS_LINUX is not 1"
    #endif
    #print os=linux
#else
    #error "no TIKO_OS_* defined"
#endif
print 1
