/* errjmp.c -- the non-local jump ON ERROR GOTO needs, and nothing else.
**
** WHY THIS EXISTS. fbc's error path is a CROSS-FUNCTION COMPUTED GOTO: the
** thrower returns the handler's address and the raising procedure does
** `goto *vr$1`, landing in whichever procedure installed the handler and
** leaving every frame between them standing. GCC takes that; LLVM does not.
** `indirectbr` can only name labels in the function it appears in, so a throw
** inside a CALLED procedure had nowhere to go: tiko emitted `unreachable`
** after the throw, LLVM lowered it to `int3`, and the program died with
** STATUS_BREAKPOINT where fbc ran the handler. Measured on
** tests/vendor/fbc-tests/com/comptr-error-path.bas and on a four-line repro.
**
** SO THE JUMP IS setjmp/longjmp, which IS expressible. The compiler emits the
** `_setjmp` where ON ERROR GOTO appears -- it has to be THAT frame, a buffer
** captured inside a helper here would name a frame that has already returned
** -- and this longjmps into it from wherever the throw happened.
**
** AND NOTHING IS UNWOUND, which is the behaviour the corpus asserts rather
** than a shortcut: longjmp restores the registers and the stack pointer and
** runs no destructor and no DEFER. comptr-error-path.bas exists to pin that
** down -- "destructors and defers do NOT run on the error path" -- and fbc's
** computed goto achieves it by doing even less.
**
** NO LIBC HEADERS, like every other member of src/c: the Linux build has no
** sysroot and `#include <setjmp.h>` fails there outright. The two entry points
** are declared by hand instead, which is also why the buffer is a plain
** aligned array rather than a jmp_buf -- 512 bytes against Windows x64's 256
** and glibc's 200.
**
** PER THREAD, because FB_ERRORCTX is: a handler installed on one thread has no
** business catching another's throw.
*/

#if defined( _WIN32 )
extern void longjmp( void *env, int val );
#define TKORT_LONGJMP longjmp
#else
/* The one that does NOT restore the signal mask, to pair with _setjmp. */
extern void _longjmp( void *env, int val );
#define TKORT_LONGJMP _longjmp
#endif

/* DOES NOT RETURN. The buffer belongs to the error context -- see
** src/inc/descriptors.ti -- because a '__declspec(thread)' here would want
** '_tls_index' and tiko links no CRT startup to define it. */
void fb_ErrorJmpGoAt( void *env )
{
	TKORT_LONGJMP( env, 1 );
}
