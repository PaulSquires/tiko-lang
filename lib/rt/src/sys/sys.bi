#ifndef __TKORT_SYS_BI__
#define __TKORT_SYS_BI__

'' sys.bi -- tiko-rt's OS and libc surface.
''
'' Decision R6 is "keep libc, bind it with #cinclude". PROBE-6 (2026-08-28)
'' showed #cinclude cannot carry that on its own:
''
''   win32          REFUSED outright -- error 384, "the C importer has no target
''                  triple for this target, only win64 and linux-x86_64"
''   linux-x86_64   headers not found when cross-compiling from a Windows host;
''                  needs -csysroot pointing at a Linux sysroot
''   win64          works
''
'' So R6 is amended (see docs/tiko-rt/RFC-0001 R6): the primary binding is
'' **fbc's own shipped headers**, which are target-aware, already used by every
'' FreeBASIC program, and available on all three targets. PROBE-7 and PROBE-8
'' confirmed they compile under -gen llvm for win64, win32 and linux-x86_64.
'' #cinclude remains available as a supplement on win64 and linux-x86_64 for
'' anything they lack.
''
'' These are DECLARATIONS of C library functions -- interface, not expression --
'' and they are `src/inc` headers, the category PROVENANCE.md already permits.
'' No rtlib .c body is involved.
''
'' ---------------------------------------------------------------------------
'' ONE CONSTRAINT, MEASURED AND RECORDED RATHER THAN DISCOVERED LATER
''
'' 61 of the 80 headers under fbc's crt/ carry:
''
''     NOTICE: This file is part of the FreeBASIC Compiler package and can't
''             be included in other distributions without authorization.
''
'' (windows.bi does not.) So tiko-rt may INCLUDE them from an fbc-modern install
'' -- which its build already requires, per R4 -- but may not vendor or
'' redistribute them.
''
'' That is fine for the spike and NOT fine forever: independence is one of the
'' reasons this project exists (RFC-0001 section 2), and a runtime that cannot be
'' distributed without 61 of someone else's headers has not achieved it.
''
'' The named work item for the full port, deliberately NOT done now because it
'' does not affect the measurement: generate tiko-rt's own bindings from the
'' SYSTEM headers with -cimport (win64 and linux-x86_64 are supported; win32 is
'' error 384 and needs either a hand-written binding or a triple added to
'' fbc-modern's importer). Tracked in docs/tiko-rt/status/spike.md.
'' ---------------------------------------------------------------------------

'' ------------------------------------------------------------------ libc
''
'' Common to all three targets. PROBE-7: compiles clean on each.

#include once "crt/stdlib.bi"      '' malloc, free, realloc, calloc, exit, getenv
#include once "crt/string.bi"      '' memcpy, memmove, memset, memcmp, str*
#include once "crt/stdio.bi"       '' f*, snprintf, stderr

'' ...AND THE STREAMS AGAIN, ON THE MICROSOFT ABI.
''
'' crt/stdio.bi is fbc's header and it is right about MinGW: there the three
'' streams are macros over __iob_func( ), which returns the base of a FILE array
'' and is indexed. UCRT has no __iob_func. It exports
''
''     FILE* __cdecl __acrt_iob_func( unsigned _Ix )
''
'' -- read from the Windows SDK's own corecrt_wstdio.h, which defines stdout as
'' __acrt_iob_func( 1 ) and not as an index into anything. So it is a different
'' CALL, not a different spelling, and the macros are replaced rather than the
'' symbol renamed.
''
'' fbc's header is not edited: it is another project's file, and it is correct
'' for every target fbc itself builds. TKORT_MSVC comes from build.sh, because
'' fbc compiles win64-msvc AS win64 and no built-in symbol distinguishes them.
#ifdef TKORT_MSVC
	extern "c"   '' NON-FBCALL: this is the UCRT, not an rtlib entry point.
		declare function tkrt_acrt_iob cdecl alias "__acrt_iob_func" _
			( byval ix as ulong ) as FILE ptr
	end extern
	#undef stdin
	#undef stdout
	#undef stderr
	#define stdin  tkrt_acrt_iob( 0 )
	#define stdout tkrt_acrt_iob( 1 )
	#define stderr tkrt_acrt_iob( 2 )
#endif
#include once "crt/wchar.bi"       '' wcs*
#include once "crt/setjmp.bi"      '' jmp_buf, setjmp, longjmp -- GOSUB needs these
#include once "crt/ctype.bi"
#include once "crt/time.bi"
#include once "crt/errno.bi"

'' ------------------------------------------------------------ per-target
''
'' The split is not a tiko-rt invention: the C runtime has win32/thread_core.c
'' and unix/thread_core.c for exactly this reason. crt/pthread.bi refuses a
'' Windows target by design -- "this header is for GNU/Linux glibc" (PROBE-7).

#if defined( __FB_WIN32__ ) or defined( __FB_WIN64__ )

	#include once "windows.bi"     '' PROBE-8: OK on win64 and win32

#elseif defined( __FB_LINUX__ )

	#include once "crt/unistd.bi"
	#ifdef ENABLE_MT
		#include once "crt/pthread.bi"
	#endif

	'' NOT included: crt/sys/stat.bi. It is Windows-only in fbc's tree --
	''     #if defined(__FB_WIN32__) ... #else #error Unsupported platform
	'' -- so there is no shipped Linux stat binding at all. Nothing before P5
	'' (filesystem) needs it; when P5 does, it is #cimport on win64/linux and a
	'' hand-written binding on win32. Recorded so it is a known gap rather than
	'' a surprise.

#else

	#error "tiko-rt supports win64, win32 and linux-x86_64 only (R3)"

#endif

'' -------------------------------------------------------------- invariants
''
'' Asserted here rather than assumed, on every target, because each one is a
'' silent-corruption bug if it is ever false. RFC-0003 section 5.7.

#assert sizeof( any ptr ) = sizeof( integer )   '' integer is pointer-width

#endif '' __TKORT_SYS_BI__
