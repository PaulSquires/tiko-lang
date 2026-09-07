/* msvccrtdll.c -- _DllMainCRTStartup, the entry point of a DLL.
**
** MSVC-ONLY, and separate from msvccrtexe.c for the reason given there: an
** archive member is pulled in only to satisfy an undefined symbol, and an
** executable must not drag in the DLL entry point or the reverse.
**
** WHAT AN ENTRY POINT OWES on DLL_PROCESS_ATTACH is the same initialiser walk
** the executable does -- tkort_msvc_init_ is allocated into .CRT$XCB and sets
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

extern tkort_pvfv tkort_xi_a[], tkort_xi_z[];
extern tkort_pvfv tkort_xc_a[], tkort_xc_z[];

#define TKORT_DLL_PROCESS_ATTACH 1

int __stdcall _DllMainCRTStartup( void *instance, unsigned long reason,
                                  void *reserved )
{
    (void)instance;
    (void)reserved;

    if( reason == TKORT_DLL_PROCESS_ATTACH ) {
        _initterm( tkort_xi_a, tkort_xi_z );
        _initterm( tkort_xc_a, tkort_xc_z );
    }

    /* No DLL_PROCESS_DETACH work. The UCRT's own atexit table belongs to the
    ** process, not to this module, and running it here would tear down state
    ** the host program still owns. */
    return 1;
}

#endif /* TKORT_MSVC */
