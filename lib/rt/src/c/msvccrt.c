/* msvccrt.c -- the CRT startup and the few shims ucrtbase.dll does not export.
**
** MSVC-ONLY, and empty everywhere else: the gnu targets get all of this from
** fbc's crt2.o and libmingwex.a, which are on their link line already.
**
** WHY THIS EXISTS.  Before it, a win64-msvc link needed Visual Studio on the
** machine doing the compiling -- not the SDK, VC Tools specifically, for
** libcmt.lib, libvcruntime.lib, oldnames.lib and legacy_stdio_definitions.lib.
** Measured 2026-09-06: those four are the only reason clang reached into
** "C:/Program Files/Microsoft Visual Studio". They are also NOT in Microsoft's
** own redistributable set -- VC/Redist/MSVC/<v>/x64 contains runtime DLLs and no
** static libraries at all -- so shipping copies was not obviously permitted.
**
** WHAT WAS ACTUALLY MISSING was small, and that is the point of the file.
** ucrtbase.dll is a Windows system component present on every Windows 10 and
** later, and it exports 2,650 symbols: every mem* and str* function, fileno,
** the whole stdio core, and every startup primitive used below. A link against
** it plus our own import libraries left exactly six names undefined:
**
**     mainCRTStartup   the entry point, which lives in no DLL
**     _fltused         a marker the backend emits a reference to
**     atexit           over _crt_atexit, which IS exported
**     sprintf          inline in the UCRT headers, so not exported
**     time localtime   named _time64 and _localtime64 in the UCRT
**
** floor and floorf were on that list too and are not shim work: they were a bug
** in our generated ucrtbase.lib, which marked them as DATA imports.
**
** NOT A TRANSLITERATION OF MSVC's STARTUP.  Every entry point called here is
** exported by ucrtbase.dll and declared below from its documented signature.
** The one thing that had to be read rather than guessed is what sprintf passes
** to __stdio_common_vsprintf, because getting the option word wrong is a silent
** formatting difference rather than a link error. From the SDK's own stdio.h:
** sprintf calls _vsprintf_l, which calls _vsnprintf_l with a count of
** (size_t)-1, which calls __stdio_common_vsprintf with
** _CRT_INTERNAL_LOCAL_PRINTF_OPTIONS | _CRT_INTERNAL_PRINTF_LEGACY_VSPRINTF_NULL_TERMINATION
** and returns -1 for any negative result. _CRT_INTERNAL_LOCAL_PRINTF_OPTIONS is
** (*__local_stdio_printf_options()), a per-translation-unit static that is zero
** unless the unit sets it, so the whole word here is the one legacy flag.
*/

#ifdef TKORT_MSVC

typedef unsigned long long tkort_u64;
typedef unsigned long long tkort_size;
typedef void ( __cdecl *tkort_pvfv )( void );

/* ---------------------------------------------------------- ucrtbase.dll */

int    __cdecl _configure_narrow_argv( int mode );
int    __cdecl _initialize_narrow_environment( void );
int *  __cdecl __p___argc( void );
char***__cdecl __p___argv( void );
void   __cdecl _initterm( tkort_pvfv *first, tkort_pvfv *last );
void   __cdecl exit( int code );
int    __cdecl _crt_atexit( tkort_pvfv fn );
int    __cdecl __stdio_common_vsprintf( tkort_u64 options, char *buffer,
                                        tkort_size count, char const *format,
                                        void *locale, char *arglist );
long long __cdecl _time64( long long *dest );
int       __cdecl _fileno( void *stream );
void *    __cdecl _localtime64( long long const *src );

/* THE INITIALISER RANGE.  tkort_msvc_init_ is allocated into .CRT$XCB
** (msvcinit.c) and the linker sorts the .CRT$XC* fragments together, so
** bracketing them with XCA and XCZ and handing the pair to _initterm is what
** actually calls it. Without this the runtime starts in the "C" locale and
** UCASE leaves accented characters alone -- the failure msvcinit.c records.
**
** The XI range is C-style initialisers. Nothing here uses it today; it is
** bracketed anyway because the cost is two empty pointers and the failure mode
** if something starts using it is silent. */
#pragma section( ".CRT$XIA", read )
#pragma section( ".CRT$XIZ", read )
#pragma section( ".CRT$XCA", read )
#pragma section( ".CRT$XCZ", read )
__declspec(allocate(".CRT$XIA")) tkort_pvfv tkort_xi_a[] = { 0 };
__declspec(allocate(".CRT$XIZ")) tkort_pvfv tkort_xi_z[] = { 0 };
__declspec(allocate(".CRT$XCA")) tkort_pvfv tkort_xc_a[] = { 0 };
__declspec(allocate(".CRT$XCZ")) tkort_pvfv tkort_xc_z[] = { 0 };

/* THE STACK PROBE.  The backend emits 'call __chkstk' in the prologue of any
** function whose frame exceeds a page, and on this target nothing defines it:
** it lives in Visual Studio's libcmt, and clang's own clang_rt.builtins does
** NOT carry it (checked). tiko-rt's io_printusg.o is the first module to need
** one -- fb_PrintUsingWstr and fb_PrintUsingUStr both have large frames.
**
** THE CONTRACT, which is the whole of it: RAX holds the byte count, the routine
** touches one byte on every page between the current RSP and RSP-RAX so the
** guard page is hit in order, and it returns with RAX and every other register
** unchanged. It does NOT move RSP -- the caller's next instruction is
** 'sub rsp, rax'. Written in assembly because that register discipline cannot
** be expressed in C.
**
** Guard pages must be touched IN DESCENDING ORDER, one per page. Skipping one
** and writing past it is how a stack overflow becomes a silent memory
** corruption instead of an exception. */__asm__(
    ".globl __chkstk\n"
    "__chkstk:\n"
    "    push %rcx\n"
    "    push %rax\n"
    "    cmp  $0x1000, %rax\n"
    "    lea  24(%rsp), %rcx\n"
    "    jb   2f\n"
    "1:\n"
    "    sub  $0x1000, %rcx\n"
    "    test %rcx, (%rcx)\n"
    "    sub  $0x1000, %rax\n"
    "    cmp  $0x1000, %rax\n"
    "    ja   1b\n"
    "2:\n"
    "    sub  %rax, %rcx\n"
    "    test %rcx, (%rcx)\n"
    "    pop  %rax\n"
    "    pop  %rcx\n"
    "    ret\n"
);

/* THE FLOATING-POINT MARKER.  The backend emits a reference to _fltused from
** any module that touches a float, and the CRT is expected to define it. Its
** value is never read; only its presence is. */
int _fltused = 0x9875;

int __cdecl atexit( tkort_pvfv fn )
{
    return _crt_atexit( fn );
}

int __cdecl sprintf( char *buffer, char const *format, ... )
{
    int result;
    char *arglist;
    __builtin_va_start( arglist, format );
    /* 1 is _CRT_INTERNAL_PRINTF_LEGACY_VSPRINTF_NULL_TERMINATION. */
    result = __stdio_common_vsprintf( 1ull, buffer, (tkort_size)-1,
                                      format, 0, arglist );
    __builtin_va_end( arglist );
    return result < 0 ? -1 : result;
}

/* fileno IS NOT AN EXPORT, whatever fbc's import library says. ucrtbase.dll
** exports _fileno only, and libucrtbase.dll.a lists 'fileno' -- a name the DLL
** does not have. Harmless in fbc's tree, where nothing references it; here it
** produced a binary the loader silently refused to start. A graphics program
** built without error and exited 127 while the same program without graphics
** ran, because only the graphics path reaches fileno.
**
** build/mkmsvcdef.py now drops export names the DLL does not actually have, so
** the bogus import cannot be generated again. This defines the name properly. */
int __cdecl fileno( void *stream )
{
    return _fileno( stream );
}

/* time_t IS 64-BIT on x64, so these are renames rather than conversions. */
long long __cdecl time( long long *dest )
{
    return _time64( dest );
}

void * __cdecl localtime( long long const *src )
{
    return _localtime64( src );
}

#endif /* TKORT_MSVC */
