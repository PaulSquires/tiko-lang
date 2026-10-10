/* msvccrtdll.c -- _DllMainCRTStartup, the entry point of a DLL.
**
** MSVC-ONLY, and separate from msvccrtexe.c for the reason given there: an
** archive member is pulled in only to satisfy an undefined symbol, and an
** executable must not drag in the DLL entry point or the reverse.
**
** WHAT AN ENTRY POINT OWES on DLL_PROCESS_ATTACH is the same initialiser walk
** the executable does -- tkort_msvc_init_ is allocated into .CRT$XCY and sets
** the runtime's locale, and a DLL that skipped it would start in "C" with the
** same symptom msvcinit.c records for the exe.
**
** RETURNING ZERO FAILS THE LOAD, which is why the return is unconditional TRUE:
** the loader treats a false return from the entry point as "the DLL refused to
** initialise" and fails LoadLibrary with no further explanation.
**
** DllMain IS NOT CALLED. FreeBASIC has no DLL entry hook of its own -- a
** FreeBASIC DLL's initialisation happens through module constructors, which is
** the .CRT$XC walk below. If tiko ever grows one, it belongs here.
*/

#ifdef TKORT_MSVC

typedef void ( __cdecl *tkort_pvfv )( void );

void __cdecl _initterm( tkort_pvfv *first, tkort_pvfv *last );

/* The .CRT$X walk, in fbc's order -- msvccrt.c says what that is. */
void tkort_run_initialisers( void );

/* msvccrt.c's atexit consults this; see the note there. */
extern int ( __cdecl *tkort_dll_atexit )( tkort_pvfv fn );

void * __cdecl realloc( void *block, unsigned long long size );
void   __cdecl free( void *block );

#define TKORT_DLL_PROCESS_DETACH 0
#define TKORT_DLL_PROCESS_ATTACH 1

/* THIS DLL'S EXIT TABLE.  What the DLL registers with atexit -- fb_hRtExit first,
** from msvcinit.c's initialiser -- runs when the DLL goes, last registered first, as
** MSVC's CRT runs a DLL's own table.  Registration happens on DLL_PROCESS_ATTACH,
** under the loader lock, so the table takes no lock of its own. */
static tkort_pvfv *tkort_exit_tab = 0;
static int tkort_exit_n = 0, tkort_exit_cap = 0;

static int __cdecl tkort_dll_onexit( tkort_pvfv fn )
{
    if( tkort_exit_n == tkort_exit_cap ) {
        int cap = tkort_exit_cap ? tkort_exit_cap * 2 : 16;
        tkort_pvfv *tab = (tkort_pvfv *)realloc( tkort_exit_tab,
                                                 (unsigned long long)cap * sizeof( tkort_pvfv ) );
        if( !tab ) return -1;
        tkort_exit_tab = tab;
        tkort_exit_cap = cap;
    }
    tkort_exit_tab[tkort_exit_n++] = fn;
    return 0;
}

int __stdcall _DllMainCRTStartup( void *instance, unsigned long reason,
                                  void *reserved )
{
    (void)instance;
    (void)reserved;

    if( reason == TKORT_DLL_PROCESS_ATTACH ) {
        /* BEFORE the initialisers: msvcinit.c's registers fb_hRtExit. */
        tkort_dll_atexit = tkort_dll_onexit;
        tkort_run_initialisers( );
    } else if( reason == TKORT_DLL_PROCESS_DETACH ) {
        /* The DLL's OWN table, never the UCRT's: that one belongs to the process,
        ** and running it here would tear down state the host program still owns. */
        while( tkort_exit_n > 0 ) {
            tkort_pvfv fn = tkort_exit_tab[--tkort_exit_n];
            if( fn ) fn( );
        }
        free( tkort_exit_tab );
        tkort_exit_tab = 0;
        tkort_exit_cap = 0;
    }
    return 1;
}

#endif /* TKORT_MSVC */
