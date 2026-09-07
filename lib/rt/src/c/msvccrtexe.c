/* msvccrtexe.c -- mainCRTStartup, the entry point of an EXECUTABLE.
**
** MSVC-ONLY, and a translation unit of its own. That is not tidiness: an archive
** member is pulled in only to satisfy an undefined symbol, so keeping this
** separate from msvccrt.c is what stops a DLL from dragging it in.
**
** It was in msvccrt.c to begin with, and a DLL link then failed with TWO
** undefined symbols rather than one -- _DllMainCRTStartup, which was expected,
** and 'main', which was not. The shims live in msvccrt.c and every link needs
** them, so every link also got mainCRTStartup, and mainCRTStartup references
** main. A DLL has none. Splitting the entry points into their own members is
** exactly the arrangement a real CRT uses for the same reason.
*/

#ifdef TKORT_MSVC

typedef void ( __cdecl *tkort_pvfv )( void );

int    __cdecl _configure_narrow_argv( int mode );
int    __cdecl _initialize_narrow_environment( void );
int *  __cdecl __p___argc( void );
char***__cdecl __p___argv( void );
void   __cdecl _initterm( tkort_pvfv *first, tkort_pvfv *last );
void   __cdecl exit( int code );

/* Bracketing the .CRT$X fragments, defined in msvccrt.c. */
extern tkort_pvfv tkort_xi_a[], tkort_xi_z[];
extern tkort_pvfv tkort_xc_a[], tkort_xc_z[];

extern int main( int argc, char **argv );

int mainCRTStartup( void )
{
    int rc;

    /* 2 is _crt_argv_expanded_arguments: argv gets the wildcard expansion a C
    ** program built by MSVC gets by default. */
    _configure_narrow_argv( 2 );
    _initialize_narrow_environment( );

    _initterm( tkort_xi_a, tkort_xi_z );
    _initterm( tkort_xc_a, tkort_xc_z );

    rc = main( *__p___argc( ), *__p___argv( ) );

    /* exit(), not return: the UCRT's exit runs the _crt_atexit handlers and
    ** flushes stdio. Returning from here would skip both. */
    exit( rc );
    return rc;
}

#endif /* TKORT_MSVC */
