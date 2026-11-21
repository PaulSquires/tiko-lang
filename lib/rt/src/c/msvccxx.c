/* msvccxx.c -- the C++ runtime pieces no DLL exports, for a windows-x86_64 link (docs/tiko-cpp C2).
**
** MSVC-ONLY, and empty everywhere else. Its own archive member, so it is linked only when
** an MSVC-ABI C++ object references one of its names: a program with no C++ in it is the
** same bytes it was.
**
** WHY.  windows-x86_64 links with no Visual Studio (msvccrt.c says why): ucrtbase.dll and
** our own import libraries. A C++ object built by Visual C++ or by clang for the msvc
** triple also needs the C++ runtime. Most of that is exported -- the STL by msvcp140.dll,
** exceptions and RTTI by vcruntime140.dll (lib/implib, build/dlldef.py) -- and the rest is
** what Visual Studio's static msvcrt.lib/libcmt.lib carry. MEASURED, the undefined symbols of
** a probe corpus built by cl /MD /EHsc /O2 and by clang that no DLL exports
** (docs/tiko-cpp/probes/c2/classify.py):
**
**     operator new / delete    the whole family: plain, sized, array, nothrow, aligned
**     std::nothrow             a one-byte constant
**     ??_L ??_M                cl's array constructor / destructor iterators
**     type_info's vftable      every RTTI type descriptor points at it
**     __type_info_root_node    the list head type_info::name() caches names on
**     _Init_thread_*           thread-safe initialisation of function-local statics
**     dynamic TLS              __dyn_tls_on_demand_init, __tls_guard, __tlregdtor,
**                              _tls_index -- and with them the image's TLS directory
**     /GS                      __security_cookie, __security_check_cookie,
**                              __GSHandlerCheck (cl's default; clang's does not use it)
**
** NOT A TRANSLITERATION.  Each is written from the ABI it has to meet -- the mangled name,
** the argument list, what the compiler's generated code expects around the call -- and
** every behaviour is checked by build/cpplane.sh against the same C++ linked by Visual
** Studio. The names with '?' and '@' in them are spelled with asm labels.
*/

#ifdef TKORT_MSVC

typedef unsigned long long tkort_size;
typedef unsigned long long tkort_uptr;
typedef void ( __cdecl *tkort_pvfv )( void );
typedef void ( __cdecl *tkort_xfn )( void * );

/* ---------------------------------------------------------- what this calls */

void * __cdecl malloc( tkort_size n );
void * __cdecl realloc( void *p, tkort_size n );
void   __cdecl free( void *p );
void * __cdecl _aligned_malloc( tkort_size n, tkort_size align );
void   __cdecl _aligned_free( void *p );
int    __cdecl _callnewh( tkort_size n );                       /* ucrtbase */
void   __cdecl tkort_xbad_alloc( void ) __asm__( "?_Xbad_alloc@std@@YAXXZ" );   /* msvcp140 */

void __stdcall AcquireSRWLockExclusive( void **lock );
void __stdcall ReleaseSRWLockExclusive( void **lock );
int  __stdcall SleepConditionVariableSRW( void **cv, void **lock, unsigned long ms, unsigned long flags );
void __stdcall WakeAllConditionVariable( void **cv );
void __stdcall GetSystemTimeAsFileTime( unsigned long long *ft );
unsigned long __stdcall GetCurrentProcessId( void );
unsigned long __stdcall GetCurrentThreadId( void );
int  __stdcall QueryPerformanceCounter( long long *c );

/* ---------------------------------------------------------- operator new / delete */

/* operator new: the new-handler loop, then std::bad_alloc. _callnewh returns 0 when no
** handler is installed (or it gave up), which is when the standard says new throws; msvcp140's
** std::_Xbad_alloc is the throw, so the exception is the one Visual C++'s own new raises. */
static void *tkort_new( tkort_size n )
{
    void *p;
    if( n == 0 ) n = 1;
    while( (p = malloc( n )) == 0 ) {
        if( _callnewh( n ) == 0 ) tkort_xbad_alloc( );
    }
    return p;
}

static void *tkort_new_aligned( tkort_size n, tkort_size a )
{
    void *p;
    if( n == 0 ) n = 1;
    while( (p = _aligned_malloc( n, a )) == 0 ) {
        if( _callnewh( n ) == 0 ) tkort_xbad_alloc( );
    }
    return p;
}

static void *tkort_new_nothrow( tkort_size n )
{
    if( n == 0 ) n = 1;
    return malloc( n );
}

static void *tkort_new_aligned_nothrow( tkort_size n, tkort_size a )
{
    if( n == 0 ) n = 1;
    return _aligned_malloc( n, a );
}

/* The family. 'a' is std::align_val_t, a size_t enum; a std::nothrow_t argument is a reference
** to an empty object and is never read. */
void *cxx_new( tkort_size n ) __asm__( "??2@YAPEAX_K@Z" );
void *cxx_new( tkort_size n ) { return tkort_new( n ); }
void *cxx_newa( tkort_size n ) __asm__( "??_U@YAPEAX_K@Z" );
void *cxx_newa( tkort_size n ) { return tkort_new( n ); }
void *cxx_new_nt( tkort_size n, const void *nt ) __asm__( "??2@YAPEAX_KAEBUnothrow_t@std@@@Z" );
void *cxx_new_nt( tkort_size n, const void *nt ) { (void)nt; return tkort_new_nothrow( n ); }
void *cxx_newa_nt( tkort_size n, const void *nt ) __asm__( "??_U@YAPEAX_KAEBUnothrow_t@std@@@Z" );
void *cxx_newa_nt( tkort_size n, const void *nt ) { (void)nt; return tkort_new_nothrow( n ); }
void *cxx_new_al( tkort_size n, tkort_size a ) __asm__( "??2@YAPEAX_KW4align_val_t@std@@@Z" );
void *cxx_new_al( tkort_size n, tkort_size a ) { return tkort_new_aligned( n, a ); }
void *cxx_newa_al( tkort_size n, tkort_size a ) __asm__( "??_U@YAPEAX_KW4align_val_t@std@@@Z" );
void *cxx_newa_al( tkort_size n, tkort_size a ) { return tkort_new_aligned( n, a ); }
void *cxx_new_al_nt( tkort_size n, tkort_size a, const void *nt ) __asm__( "??2@YAPEAX_KW4align_val_t@std@@AEBUnothrow_t@1@@Z" );
void *cxx_new_al_nt( tkort_size n, tkort_size a, const void *nt ) { (void)nt; return tkort_new_aligned_nothrow( n, a ); }
void *cxx_newa_al_nt( tkort_size n, tkort_size a, const void *nt ) __asm__( "??_U@YAPEAX_KW4align_val_t@std@@AEBUnothrow_t@1@@Z" );
void *cxx_newa_al_nt( tkort_size n, tkort_size a, const void *nt ) { (void)nt; return tkort_new_aligned_nothrow( n, a ); }

void cxx_del( void *p ) __asm__( "??3@YAXPEAX@Z" );
void cxx_del( void *p ) { free( p ); }
void cxx_dela( void *p ) __asm__( "??_V@YAXPEAX@Z" );
void cxx_dela( void *p ) { free( p ); }
void cxx_del_sz( void *p, tkort_size n ) __asm__( "??3@YAXPEAX_K@Z" );
void cxx_del_sz( void *p, tkort_size n ) { (void)n; free( p ); }
void cxx_dela_sz( void *p, tkort_size n ) __asm__( "??_V@YAXPEAX_K@Z" );
void cxx_dela_sz( void *p, tkort_size n ) { (void)n; free( p ); }
void cxx_del_nt( void *p, const void *nt ) __asm__( "??3@YAXPEAXAEBUnothrow_t@std@@@Z" );
void cxx_del_nt( void *p, const void *nt ) { (void)nt; free( p ); }
void cxx_dela_nt( void *p, const void *nt ) __asm__( "??_V@YAXPEAXAEBUnothrow_t@std@@@Z" );
void cxx_dela_nt( void *p, const void *nt ) { (void)nt; free( p ); }
void cxx_del_al( void *p, tkort_size a ) __asm__( "??3@YAXPEAXW4align_val_t@std@@@Z" );
void cxx_del_al( void *p, tkort_size a ) { (void)a; _aligned_free( p ); }
void cxx_dela_al( void *p, tkort_size a ) __asm__( "??_V@YAXPEAXW4align_val_t@std@@@Z" );
void cxx_dela_al( void *p, tkort_size a ) { (void)a; _aligned_free( p ); }
void cxx_del_sz_al( void *p, tkort_size n, tkort_size a ) __asm__( "??3@YAXPEAX_KW4align_val_t@std@@@Z" );
void cxx_del_sz_al( void *p, tkort_size n, tkort_size a ) { (void)n; (void)a; _aligned_free( p ); }
void cxx_dela_sz_al( void *p, tkort_size n, tkort_size a ) __asm__( "??_V@YAXPEAX_KW4align_val_t@std@@@Z" );
void cxx_dela_sz_al( void *p, tkort_size n, tkort_size a ) { (void)n; (void)a; _aligned_free( p ); }
void cxx_del_al_nt( void *p, tkort_size a, const void *nt ) __asm__( "??3@YAXPEAXW4align_val_t@std@@AEBUnothrow_t@1@@Z" );
void cxx_del_al_nt( void *p, tkort_size a, const void *nt ) { (void)a; (void)nt; _aligned_free( p ); }
void cxx_dela_al_nt( void *p, tkort_size a, const void *nt ) __asm__( "??_V@YAXPEAXW4align_val_t@std@@AEBUnothrow_t@1@@Z" );
void cxx_dela_al_nt( void *p, tkort_size a, const void *nt ) { (void)a; (void)nt; _aligned_free( p ); }

/* std::nothrow, an object of the empty std::nothrow_t. */
const char tkort_std_nothrow __asm__( "?nothrow@std@@3Unothrow_t@1@B" ) = 0;

/* ---------------------------------------------------------- arrays of classes (cl) */

/* __ehvec_ctor: construct 'count' objects of 'size' bytes in order. Visual C++'s also
** destroys the ones already built when a constructor throws; this does not -- they leak
** rather than being destroyed, which needs a C++ catch this file cannot write. */
void cxx_ehvec_ctor( char *p, tkort_size size, tkort_size count, tkort_xfn ctor, tkort_xfn dtor )
    __asm__( "??_L@YAXPEAX_K1P6AX0@Z2@Z" );
void cxx_ehvec_ctor( char *p, tkort_size size, tkort_size count, tkort_xfn ctor, tkort_xfn dtor )
{
    (void)dtor;
    for( tkort_size i = 0; i < count; i++ ) ctor( p + i * size );
}

/* __ehvec_dtor: destroy them in REVERSE order, the last first. */
void cxx_ehvec_dtor( char *p, tkort_size size, tkort_size count, tkort_xfn dtor )
    __asm__( "??_M@YAXPEAX_K1P6AX0@Z@Z" );
void cxx_ehvec_dtor( char *p, tkort_size size, tkort_size count, tkort_xfn dtor )
{
    p += size * count;
    while( count-- > 0 ) {
        p -= size;
        dtor( p );
    }
}

/* ---------------------------------------------------------- type_info */

/* The vector deleting destructor, slot 0 of type_info's vftable: the destructor is trivial,
** and bit 0 of 'flags' says to free the object too. Type descriptors are static data and are
** never deleted; the slot exists because the class is polymorphic. */
void *cxx_ti_vdd( void *self, unsigned flags ) __asm__( "??_Etype_info@@UEAAPEAXI@Z" );
void *cxx_ti_vdd( void *self, unsigned flags ) { if( flags & 1 ) free( self ); return self; }
void *cxx_ti_sdd( void *self, unsigned flags ) __asm__( "??_Gtype_info@@UEAAPEAXI@Z" );
void *cxx_ti_sdd( void *self, unsigned flags ) { if( flags & 1 ) free( self ); return self; }
void cxx_ti_dtor( void *self ) __asm__( "??1type_info@@UEAA@XZ" );
void cxx_ti_dtor( void *self ) { (void)self; }

/* THE VFTABLE: the complete-object-locator word (none -- typeid of a type_info is not
** supported), then the address point, which is the symbol, then slot 0. */
__asm__(
    "    .section .rdata,\"dr\"\n"
    "    .p2align 3\n"
    "    .quad 0\n"
    "    .globl \"??_7type_info@@6B@\"\n"
    "\"??_7type_info@@6B@\":\n"
    "    .quad \"??_Etype_info@@UEAAPEAXI@Z\"\n"
    "    .text\n"
);

/* __type_info_root_node: an SLIST_HEADER, 16 bytes and 16-aligned, zero. vcruntime140's
** __std_type_info_name pushes each demangled name it allocates onto it. */
__declspec(align(16)) unsigned char tkort_ti_root[16] __asm__( "?__type_info_root_node@@3U__type_info_node@@A" );

/* ---------------------------------------------------------- thread-safe statics */

/* A function-local static's guard is an int: 0 not initialised, -1 being initialised, and
** once done the value of a global epoch. The generated code compares the guard with this
** thread's copy of the epoch and calls _Init_thread_header only when the guard is newer; on
** return a guard of -1 means "this thread initialises", and the code then calls
** _Init_thread_footer (or _Init_thread_abort when the initialiser throws). Another thread
** waits on the condition variable. */
#define TKORT_EPOCH_START ( -2147483647 - 1 )
static void *tkort_its_lock = 0;     /* SRWLOCK_INIT */
static void *tkort_its_cv = 0;       /* CONDITION_VARIABLE_INIT */
static int tkort_its_global = TKORT_EPOCH_START;
__declspec(thread) int _Init_thread_epoch = TKORT_EPOCH_START;

void __cdecl _Init_thread_header( int *once )
{
    AcquireSRWLockExclusive( &tkort_its_lock );
    if( *once == 0 ) {
        *once = -1;
    } else {
        while( *once == -1 ) {
            SleepConditionVariableSRW( &tkort_its_cv, &tkort_its_lock, 100, 0 );
            if( *once == 0 ) {
                *once = -1;
                ReleaseSRWLockExclusive( &tkort_its_lock );
                return;
            }
        }
        _Init_thread_epoch = tkort_its_global;
    }
    ReleaseSRWLockExclusive( &tkort_its_lock );
}

void __cdecl _Init_thread_abort( int *once )
{
    AcquireSRWLockExclusive( &tkort_its_lock );
    *once = 0;
    ReleaseSRWLockExclusive( &tkort_its_lock );
    WakeAllConditionVariable( &tkort_its_cv );
}

void __cdecl _Init_thread_footer( int *once )
{
    AcquireSRWLockExclusive( &tkort_its_lock );
    tkort_its_global++;
    *once = tkort_its_global;
    _Init_thread_epoch = tkort_its_global;
    ReleaseSRWLockExclusive( &tkort_its_lock );
    WakeAllConditionVariable( &tkort_its_cv );
}

/* ---------------------------------------------------------- the TLS directory */

/* A __declspec(thread) variable is addressed through _tls_index, which the loader fills in
** from the image's TLS directory -- _tls_used, which the linker finds by name and points the
** PE header at. Its template runs from the start marker to the end marker; its callbacks are
** the .CRT$XL* fragments between tkort_xl_a and tkort_xl_z.
**
** THE START MARKER IS IN '.tls' ITSELF, not '.tls$AAA'. Thread-locals are emitted into '.tls$',
** with an EMPTY suffix, which sorts before '$AAA' -- measured: with '.tls$AAA' the template was
** one byte long, every thread_local lay outside it, and the first std::string read was null. */
__declspec(allocate(".tls")) char tkort_tls_start = 0;
__declspec(allocate(".tls$ZZZ")) char tkort_tls_end = 0;
unsigned long _tls_index = 0;

typedef void ( __stdcall *tkort_tlscb )( void *module, unsigned long reason, void *reserved );
#pragma section( ".CRT$XLA", read )
#pragma section( ".CRT$XLZ", read )
__declspec(allocate(".CRT$XLA")) tkort_tlscb tkort_xl_a = 0;
__declspec(allocate(".CRT$XLZ")) tkort_tlscb tkort_xl_z = 0;

typedef struct {
    unsigned long long start, end, index, callbacks;
    unsigned int zerofill, characteristics;
} tkort_tlsdir;
const tkort_tlsdir _tls_used = {
    (unsigned long long)&tkort_tls_start, (unsigned long long)&tkort_tls_end,
    (unsigned long long)&_tls_index, (unsigned long long)(&tkort_xl_a + 1), 0, 0
};

/* ---------------------------------------------------------- dynamic thread_local */

/* A thread_local with a dynamic initialiser puts that initialiser in .CRT$XD*. The generated
** code reads __tls_guard before an access and calls __dyn_tls_on_demand_init when it is
** clear, which runs every initialiser of the range for THIS thread; a thread_local with a
** destructor registers it through __tlregdtor, and the thread's exit runs them, newest first.
** Threads created later get the initialisers from the TLS callback as well, as Visual C++'s
** do; the main thread gets them on demand. */
#pragma section( ".CRT$XDA", read )
#pragma section( ".CRT$XDZ", read )
__declspec(allocate(".CRT$XDA")) tkort_pvfv tkort_xd_a = 0;
__declspec(allocate(".CRT$XDZ")) tkort_pvfv tkort_xd_z = 0;
__declspec(thread) char __tls_guard = 0;

static void tkort_dyn_tls_init( void )
{
    if( __tls_guard ) return;
    __tls_guard = 1;
    for( tkort_pvfv *f = &tkort_xd_a + 1; f < &tkort_xd_z; f++ ) {
        if( *f ) ( *f )( );
    }
}

void __cdecl __dyn_tls_on_demand_init( void ) { tkort_dyn_tls_init( ); }

static __declspec(thread) tkort_pvfv *tkort_tl_dtors = 0;
static __declspec(thread) unsigned tkort_tl_count = 0;
static __declspec(thread) unsigned tkort_tl_cap = 0;

int __cdecl __tlregdtor( tkort_pvfv fn )
{
    if( tkort_tl_count == tkort_tl_cap ) {
        unsigned cap = tkort_tl_cap ? tkort_tl_cap * 2 : 8;
        tkort_pvfv *g = (tkort_pvfv *)realloc( tkort_tl_dtors, cap * sizeof( tkort_pvfv ) );
        if( g == 0 ) return -1;
        tkort_tl_dtors = g;
        tkort_tl_cap = cap;
    }
    tkort_tl_dtors[tkort_tl_count++] = fn;
    return 0;
}

static void tkort_tl_run_dtors( void )
{
    while( tkort_tl_count > 0 ) {
        tkort_pvfv fn = tkort_tl_dtors[--tkort_tl_count];
        if( fn ) fn( );
    }
    free( tkort_tl_dtors );
    tkort_tl_dtors = 0;
    tkort_tl_cap = 0;
}

/* DLL_PROCESS_DETACH 0, DLL_PROCESS_ATTACH 1, DLL_THREAD_ATTACH 2, DLL_THREAD_DETACH 3. */
static void __stdcall tkort_tls_callback( void *module, unsigned long reason, void *reserved )
{
    (void)module; (void)reserved;
    if( reason == 2 ) tkort_dyn_tls_init( );
    else if( (reason == 3) || (reason == 0) ) tkort_tl_run_dtors( );
}
#pragma section( ".CRT$XLC", read )
__declspec(allocate(".CRT$XLC")) tkort_tlscb tkort_xl_c = tkort_tls_callback;

/* An object built with the attach-time model names this instead of the on-demand one. */
void __stdcall __dyn_tls_init( void *module, unsigned long reason, void *reserved )
{
    (void)module; (void)reserved;
    if( reason == 2 ) tkort_dyn_tls_init( );
}

/* ---------------------------------------------------------- /GS */

/* THE COOKIE. A protected function stores it XORed with its frame on entry and calls
** __security_check_cookie with the result on the way out. Its top 16 bits are zero by the
** check's own design (below); set from the clock, the process, the thread and the performance
** counter before the first initialiser runs, so before any C++ code. */
tkort_uptr __security_cookie = 0x00002B992DDFA232ull;

void __cdecl __security_init_cookie( void )
{
    unsigned long long ft = 0;
    long long pc = 0;
    tkort_uptr c;
    GetSystemTimeAsFileTime( &ft );
    QueryPerformanceCounter( &pc );
    c = ft ^ ((tkort_uptr)GetCurrentProcessId( ) << 32) ^ GetCurrentThreadId( ) ^ (tkort_uptr)pc
        ^ ((tkort_uptr)pc << 32) ^ (tkort_uptr)&c;
    c &= 0x0000FFFFFFFFFFFFull;
    if( (c == 0) || (c == 0x00002B992DDFA232ull) ) c = 0x00002B992DDFA233ull;
    __security_cookie = c;
}
static void __cdecl tkort_gs_init( void ) { __security_init_cookie( ); }
#pragma section( ".CRT$XIC", read )
__declspec(allocate(".CRT$XIC")) tkort_pvfv tkort_xi_gs = tkort_gs_init;

/* THE CHECK, in assembly: it runs in the protected function's epilogue with the return value
** already in RAX, so it may change nothing but RCX and the flags. Equal to the cookie and with
** a zero top 16 bits it returns; anything else is a corrupted stack, and the process ends with
** __fastfail( FAST_FAIL_STACK_COOKIE_CHECK_FAILURE = 2 ), which no handler can intercept. */
__asm__(
    "    .text\n"
    "    .globl __security_check_cookie\n"
    "__security_check_cookie:\n"
    "    cmpq __security_cookie(%rip), %rcx\n"
    "    jne 1f\n"
    "    rolq $16, %rcx\n"
    "    testw $0xffff, %cx\n"
    "    jne 1f\n"
    "    rorq $16, %rcx\n"
    "    ret\n"
    "1:  movl $2, %ecx\n"
    "    int $0x29\n"
);

/* THE UNWIND-TIME CHECKS. A function with both a cookie and an exception handler names one
** of these as its handler: Visual C++'s re-checks the cookie of each frame an exception
** unwinds through, then hands the frame to the real handler. These hand it over WITHOUT the
** re-check (the cookie is still checked on every normal return): the cookie's position in a
** frame comes from GS_HANDLER_DATA and the frame's unwind info, and a wrong reading would end a
** correct program.
**
** ORDINARY REFERENCES, NOT WEAK ONES. Declared weak, so that a program with no FH4 code would not
** acquire vcruntime140_1.dll, clang gave each a weak DEFINITION with a default -- and lld, finding
** the name defined, never loaded the import library's member: every C++ object's unwind info then
** named __CxxFrameHandler3 at the default, which was type_info's vftable, and the first throw
** crashed (measured, tests/cpplane/msvc/stl). So a program that links this file imports
** vcruntime140_1.dll too, which the Visual C++ redistributable has shipped beside vcruntime140.dll
** since Visual Studio 2019. */
extern int __CxxFrameHandler4( void *er, void *frame, void *ctx, void *dc );
extern int __CxxFrameHandler3( void *er, void *frame, void *ctx, void *dc );
extern int __C_specific_handler( void *er, void *frame, void *ctx, void *dc );

int __cdecl __GSHandlerCheck( void *er, void *frame, void *ctx, void *dc )
{
    (void)er; (void)frame; (void)ctx; (void)dc;
    return 1;   /* ExceptionContinueSearch */
}
int __cdecl __GSHandlerCheck_EH4( void *er, void *frame, void *ctx, void *dc )
{
    return __CxxFrameHandler4( er, frame, ctx, dc );
}
int __cdecl __GSHandlerCheck_EH( void *er, void *frame, void *ctx, void *dc )
{
    return __CxxFrameHandler3( er, frame, ctx, dc );
}
int __cdecl __GSHandlerCheck_SEH( void *er, void *frame, void *ctx, void *dc )
{
    return __C_specific_handler( er, frame, ctx, dc );
}

#endif /* TKORT_MSVC */
