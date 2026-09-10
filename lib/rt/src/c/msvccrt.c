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
/* 'struct _iobuf *' AND NOT 'void *', which is what FILE is on Windows. fprintf is a
** clang BUILTIN, so a declaration that disagrees with the builtin's own signature earns
** -Wbuiltin-requires-header -- a new warning in a build that has none. sprintf above
** needs no such care because its (char*, char const*, ...) already matches. Declared
** opaquely rather than by including <stdio.h>, which is the rule this whole file keeps.
*/
struct _iobuf;
int    __cdecl __stdio_common_vfprintf( tkort_u64 options, struct _iobuf *stream,
                                        char const *format,
                                        void *locale, char *arglist );
float  __cdecl _hypotf( float x, float y );
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

/* THE TERMINATOR RANGE, and it was missing outright.
**
** LLVM lowers '@llvm.global_dtors' on a Windows-MSVC target into .CRT$XTX --
** the same mechanism .CRT$XC* is for initialisers -- and nothing here bracketed
** or ran it, so a module destructor was EMITTED CORRECTLY AND NEVER CALLED.
**
** Measured on tests/vendor/fbc-tests/scopes/dtor_eol_eof1.bas: fbc emits
** 'void CHECK( void ) __attribute__(( destructor ));' and the program prints
** '1  1'; the tiko build printed nothing at all and exited 0. It compiled, it
** linked, and it was silent -- which is why only build/runscan.sh could see it.
**
** The real MSVC CRT walks this range inside exit(); we reach the UCRT's exit,
** which knows nothing about our fragments, so msvccrtexe.c registers a handler
** that walks it. */
#pragma section( ".CRT$XTA", read )
#pragma section( ".CRT$XTZ", read )
__declspec(allocate(".CRT$XTA")) tkort_pvfv tkort_xt_a[] = { 0 };
__declspec(allocate(".CRT$XTZ")) tkort_pvfv tkort_xt_z[] = { 0 };

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

/* fprintf IS INLINE IN THE UCRT HEADERS TOO, exactly as sprintf is, so it is not
** exported either. It was not on the list of six above because that list is what
** tiko-rt ITSELF leaves undefined, and tiko-rt never calls fprintf -- but a PROGRAM
** may, and fbc's own fbcunit does, from REPORT_CLOSE and its console reporter. On the
** default Windows target that program could not be linked at all.
**
** READ, NOT GUESSED, for the same reason sprintf's option word was -- getting it wrong
** is a silent formatting difference rather than a link error. From the SDK's stdio.h:
** fprintf calls _vfprintf_l, which calls __stdio_common_vfprintf with
** _CRT_INTERNAL_LOCAL_PRINTF_OPTIONS and returns the result UNCHANGED.
**
** THE OPTION WORD IS ZERO HERE, and that is the one place it differs from sprintf.
** sprintf's chain goes through _vsnprintf_l, which ORs in
** _CRT_INTERNAL_PRINTF_LEGACY_VSPRINTF_NULL_TERMINATION; fprintf's chain adds nothing,
** and _CRT_INTERNAL_LOCAL_PRINTF_OPTIONS is (*__local_stdio_printf_options()), a
** per-translation-unit static that is zero unless the unit sets it. Nor is there a
** negative-result clamp: sprintf returns -1 for any negative, fprintf returns what it
** was given.
*/
/* THE WARNING IS ABOUT THE HEADER, NOT THE SIGNATURE, so matching FILE* does not quiet
** it: -Wbuiltin-requires-header fires because <stdio.h> is not included, and not
** including it is this file's whole method -- every entry point here is declared from
** the documented signature so that the shim depends on no SDK headers at all. sprintf
** above escapes only because its builtin needs no type from that header.
**
** Scoped to the definition rather than the file: another builtin declared later should
** still be told about.
*/
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wbuiltin-requires-header"
int __cdecl fprintf( struct _iobuf *stream, char const *format, ... )
{
    int result;
    char *arglist;
    __builtin_va_start( arglist, format );
    result = __stdio_common_vfprintf( 0ull, stream, format, 0, arglist );
    __builtin_va_end( arglist );
    return result;
}
#pragma clang diagnostic pop

/* snprintf AND vsprintf ARE THE SAME FAMILY as sprintf -- inline in the UCRT headers,
** so not exported -- and fbc's own suite reaches both: crt/varargs.bas calls vsprintf
** directly, and nine modules of the finance tests call snprintf.
**
** READ FROM THE SDK, and the two option words are NOT the same, which is the whole
** reason to read rather than copy sprintf:
**
**   snprintf -> vsnprintf     -> __stdio_common_vsprintf( STANDARD_SNPRINTF_BEHAVIOR,
**                                    buffer, count, format, NULL, args )
**   vsprintf -> _vsnprintf_l  -> __stdio_common_vsprintf( LEGACY_VSPRINTF_NULL_TERMINATION,
**                                    buffer, (size_t)-1, format, NULL, args )
**
** from corecrt_stdio_config.h: LEGACY_VSPRINTF_NULL_TERMINATION is (1ULL << 0) and
** STANDARD_SNPRINTF_BEHAVIOR is (1ULL << 1). Getting these the wrong way round is a
** silent behavioural difference in truncation and termination, not a link error.
**
** BOTH CLAMP a negative result to -1, which sprintf above does too.
*/
int __cdecl snprintf( char *buffer, tkort_size count, char const *format, ... )
{
    int result;
    char *arglist;
    __builtin_va_start( arglist, format );
    /* 2 is _CRT_INTERNAL_PRINTF_STANDARD_SNPRINTF_BEHAVIOR. */
    result = __stdio_common_vsprintf( 2ull, buffer, count, format, 0, arglist );
    __builtin_va_end( arglist );
    return result < 0 ? -1 : result;
}

int __cdecl vsprintf( char *buffer, char const *format, char *arglist )
{
    int result;
    /* 1 is _CRT_INTERNAL_PRINTF_LEGACY_VSPRINTF_NULL_TERMINATION, as sprintf uses. */
    result = __stdio_common_vsprintf( 1ull, buffer, (tkort_size)-1,
                                      format, 0, arglist );
    return result < 0 ? -1 : result;
}

/* hypotf IS NOT SHIM WORK OF THE SAME KIND: ucrtbase.dll DOES have it, under the name
** _hypotf, exactly as time and localtime are _time64 and _localtime64 up above. Checked
** against the DLL's own export table rather than assumed -- the header already records
** floor and floorf looking like this and being a bug in our generated import library
** instead, so which of the two it is has to be established each time.
**
** fb/core.bas reaches it through FB.HPOW10.
*/
float __cdecl hypotf( float x, float y )
{
    return _hypotf( x, y );
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

/* THE INTERLOCKED INTRINSICS THE WINDOWS HEADERS DECLARE AS FUNCTIONS.
**
** fbc-modern's win/intrin.bi declares '_InterlockedExchangeAdd' and its 64-bit twin as
** ordinary externs, and builds '_InterlockedAdd' on top of them in FB. On MinGW those
** names are real symbols in libmingwex; under the MSVC ABI they are COMPILER
** intrinsics, expanded inline by the C frontend and present in no library at all -- so
** an FB program that reaches one gets 'lld-link: error: undefined symbol:
** _InterlockedExchangeAdd', which is 24 of the corpus link failures build/linkscan.sh
** reports, every file that uses fb/comptr.bi.
**
** __atomic_fetch_add WITH SEQ_CST, which is what the Windows contract says: the
** Interlocked family is a full barrier in both directions, and __ATOMIC_SEQ_CST is the
** only ordering that promises that. The return value is the OLD value, which is what
** both the intrinsic and the FB declaration expect.
**
** Named without the leading underscore in the generated call is NOT a possibility: the
** header declares the underscored spelling and that is the symbol the linker asks for.
*/
/* THE NAME IS AN ASM LABEL, not the C identifier. clang REFUSES a definition of a name
** it knows as a builtin -- "definition of builtin function
** '_InterlockedExchangeAdd'" -- and there is no per-function way to turn that off. So
** the function is called something else in C and CARRIES the intrinsic's symbol name
** into the object, which is the only thing the linker looks at. */
long __cdecl tkort_interlocked_xadd32( long volatile *Addend, long Value )
    __asm__( "_InterlockedExchangeAdd" );
long __cdecl tkort_interlocked_xadd32( long volatile *Addend, long Value )
{
    return __atomic_fetch_add( Addend, Value, __ATOMIC_SEQ_CST );
}

long long __cdecl tkort_interlocked_xadd64( long long volatile *Addend,
                                            long long Value )
    __asm__( "_InterlockedExchangeAdd64" );
long long __cdecl tkort_interlocked_xadd64( long long volatile *Addend,
                                            long long Value )
{
    return __atomic_fetch_add( Addend, Value, __ATOMIC_SEQ_CST );
}

#endif /* TKORT_MSVC */
