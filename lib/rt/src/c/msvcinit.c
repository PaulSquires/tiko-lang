/* msvcinit.c -- the runtime's startup and shutdown hooks, for the Microsoft ABI.
**
** WHAT THIS REPLACES.  fbc's driver links a standalone object, fbrt0.o, which is
** what calls fb_hRtInit before main and fb_hRtExit after it.  RFC-0003 records
** that object as staying C and as NOT being an archive member: fbc names it on
** the link line itself.  A program linked against tiko-rt's archive alone --
** which is what the win64-msvc target produces, since fbc cannot link an MSVC
** object -- therefore never calls either one.
**
** MEASURED, and it is not a subtle failure once you look for it:
**
**     fbc / MinGW      setlocale( LC_CTYPE, NULL ) -> "English_Canada.1252"
**     tiko-rt / MSVC   setlocale( LC_CTYPE, NULL ) -> "C"
**
** fb_hRtInit is the only caller of setlocale( LC_CTYPE, "" ) in the runtime, so
** without it the process stays in the C locale, mbstowcs cannot convert a byte
** outside 7-bit ASCII, and UCASE leaves every accented character alone.  That is
** four of the differentials in build/diffmsvc.sh -- swap-case-mid, wsearch,
** uwconv and utf -- and none of them says "locale" anywhere in its output.
**
** WHY .CRT$XCY.  RFC-0006 section 4.4 measured the ordering: sections named
** .CRT$X.. are sorted by name and the linker concatenates them, clang lowers
** __attribute__((constructor)) to .CRT$XCU, and FreeBASIC module constructors
** land in XCU with it -- numbered ones after it, in .CRT$XCV (see msvccrt.c).
** tiko-rt walks the range BACKWARDS, as mingw walks .ctors, so the LAST fragment
** runs FIRST: .CRT$XCY runs before every constructor a program can write, which
** is the relationship fbrt0's .ctors.65435 has to fbc's priority floor of 101 on
** the gnu side. It was .CRT$XCB while the walk ran forwards.
**
** WHY atexit AND NOT A TERMINATOR SECTION.  atexit is LIFO, so a handler
** registered here -- before any module constructor has run, and therefore before
** any module destructor has been registered -- runs LAST.  fb_hRtExit has to run
** after everything it might tear down, which is exactly that position.
**
** MSVC ONLY, and the file is empty elsewhere.  On the gnu targets fbc's own
** fbrt0.o is on the link line and doing this job; adding a second initialiser
** there would mean two calls into fb_hRtInit's counter and a gated archive that
** differs from the one measured.  An empty translation unit is a valid object
** with no symbols, so the MinGW archive gains a member and nothing else.
*/

#ifdef TKORT_MSVC

#include <stdlib.h>
#include <stdio.h>

void fb_hRtInit( void );
void fb_hRtExit( void );

/* A BAD ARGUMENT TO A CRT FUNCTION MUST RETURN, NOT KILL THE PROCESS.
**
** MSVCRT checks little and returns an error; the UCRT validates and calls
** its invalid-parameter handler, whose default is __fastfail -- the process
** dies with 0xC0000409, no message, and any buffered stdout lost. That is a
** BEHAVIOUR DIFFERENCE between the two Windows runtimes, and this runtime's
** job is to behave like the one FreeBASIC programs were written against.
**
** MEASURED, and it is not hypothetical. fbc's crt/locale.bi is glibc's header
** verbatim, with no win32 arm anywhere in src/inc/crt, so on Windows it hands
** out POSIX category numbers: LC_ALL is 6 where Windows wants 0. The same
** program, the same source:
**
**     MinGW   setlocale( 6, NULL ) -> NULL, four more calls, exit 0
**     UCRT    setlocale( 6, NULL ) -> 0xC0000409, no output
**
** fbc's own chrono/iso.bas does exactly that in no_locale_leakage_, which is
** why the MSVC gate died at startup with nothing printed. (tiko-rt itself is
** not the caller: src/init/rtinit.bas hard-codes 2 on Windows and 0 on Linux,
** and says why.)
**
** THE COST IS REAL AND IS THE POINT. A genuine bad argument now returns an
** error instead of stopping the program at the fault -- which is exactly what
** it does on MinGW today, and parity with that is what this target is for.
** errno is still set and the call still fails; only the termination goes. */
static void tkort_invalid_parameter(
	const wchar_t *expression, const wchar_t *function,
	const wchar_t *file, unsigned int line, uintptr_t reserved )
{
	(void)expression; (void)function; (void)file; (void)line; (void)reserved;
}

static void tkort_msvc_startup( void )
{
	/* BEFORE fb_hRtInit, which itself calls setlocale. */
	_set_invalid_parameter_handler( tkort_invalid_parameter );

	fb_hRtInit( );

	/* Registered from inside the initialiser rather than beside it, so the
	** ordering argument above holds by construction: nothing else can have
	** registered a handler yet. */
	atexit( fb_hRtExit );
}

/* The section has to be DECLARED read-only before anything can be allocated
** into it; declaring and allocating in one step is not available here. */
#pragma section(".CRT$XCY", read)

/* The initialiser table holds POINTERS TO FUNCTIONS taking and returning
** nothing, and the CRT walks the whole .CRT$XC.. range calling each. */
__declspec(allocate(".CRT$XCY")) void (*tkort_msvc_init_)( void ) = tkort_msvc_startup;

#else

/* Deliberately empty. See the header: fbc's fbrt0.o already does this on the
** gnu targets, and a second initialiser there would double the count. */
typedef int tkort_msvcinit_not_used_here_;

#endif
