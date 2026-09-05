/* atomic.c -- tiko-rt's own atomics.
**
** WHY THIS IS C, AND NOT FREEBASIC.  FreeBASIC has no atomic operations and no
** way to spell a memory barrier.  There is nothing to reimplement in FB here:
** the language cannot express the primitive, so the file stays C and is listed
** in README.md with this reason, as RFC-0003 section 4 requires.
**
** THE CONTRACT IS THE THREE SYMBOL NAMES AND THEIR SIGNATURES, read from
** fb_thread.h -- a header, which PROVENANCE.md permits:
**
**     FBCALL int fb_AtomicFetchAddLong( int *p, int v );
**     FBCALL int fb_AtomicCasLong     ( int *p, int expected, int desired );
**     FBCALL int fb_AtomicLoadLong    ( int *p );
**
** FBCALL is cdecl on both remaining targets, so no decoration is written here.
** win32 was the one target where it was stdcall and it is gone (D14).
**
** 'int', NOT 'long'.  C long is 64-bit on LP64 and 32-bit on LLP64, while
** FreeBASIC's LONG is 32-bit everywhere.  int is 32-bit on every target fbc
** builds for, so it is the only spelling that matches on both.  Getting this
** wrong is invisible on win64 and corrupts the adjacent field on Linux.
**
** ORDERING IS SEQUENTIALLY CONSISTENT throughout.  A reference count needs
** release on the decrement and acquire before the destructor runs; seq_cst is
** stronger than both and is one instruction on x86-64 either way.  A weaker
** ordering is an optimisation that belongs with a real atomics RFC, where it
** can be tested per backend, not guessed at here.
**
** CLANG BUILTINS, NOT THE Interlocked FAMILY.  Every target this tree builds
** goes through clang -- the FreeBASIC modules by way of -gen llvm, and this
** file directly -- so __atomic_* is available on all of them and needs no
** windows.h.  That also keeps the MSVC and MinGW builds of this file textually
** identical, which is one fewer thing that can differ between the two ABIs.
*/

/* Add v to *p and return the value it held BEFORE the add.  Both directions of
** a refcount go through here: the decrement passes -1 and the caller tests the
** returned old value against 1 to detect the last reference.  Returning the old
** value is what makes that test a single atomic step. */
int fb_AtomicFetchAddLong( int *p, int v )
{
	return __atomic_fetch_add( p, v, __ATOMIC_SEQ_CST );
}

/* If *p equals expected, store desired.  Returns the value *p held before, so
** success is (result == expected).
**
** IT RETURNS THE VALUE, NOT A FLAG, because increment-if-not-zero needs it:
** resurrecting a strong reference from a weak one cannot be built out of
** fetch-add, and the caller has to know what it lost the race to. */
int fb_AtomicCasLong( int *p, int expected, int desired )
{
	int e = expected;
	__atomic_compare_exchange_n( p, &e, desired, 0,
	                             __ATOMIC_SEQ_CST, __ATOMIC_SEQ_CST );
	return e;
}

/* A 32-bit aligned load is already atomic on every target fbc supports, so this
** exists for the BARRIER and not for the atomicity: without it the compiler may
** hoist or cache the read of a counter another thread is writing. */
int fb_AtomicLoadLong( int *p )
{
	return __atomic_load_n( p, __ATOMIC_SEQ_CST );
}
