#ifndef __TKORT_FMT_BI__
#define __TKORT_FMT_BI__

'' fmt.bi -- the printf tiko-rt must call, which is not the one you get, and not
'' the same one for every entry point.
''
'' ============================================================ THE FINDING
''
'' On Windows two printf implementations are reachable from the same program and
'' they disagree on things numeric formatting depends on:
''
''                        MSVCRT              MinGW ANSI stdio
''     %.7g of 1e20       1e+020              1e+20
''     %.7g of infinity   1.#INF              inf
''     "% u" of 7         7 (flag ignored)    " 7"
''
'' AND fbc's OWN RUNTIME USES BOTH. Measured by calling its entry points
'' directly rather than by reading its build flags:
''
''     fb_DoubleToStr( 1e20 )      -> 1e+20    (it calls sprintf)
''     fb_FloatToStr( 1e20 )       -> 1e+20    (sprintf)
''     fb_hFloat2Str( 1e20, 16 )   -> 1e+020   (it calls snprintf)
''     PRINT of a double           -> 1e+019   (goes through fb_hFloat2Str)
''
'' So in fbc's build **sprintf resolves to MinGW's and snprintf resolves to
'' MSVCRT's**, and which one an entry point gets depends only on which of the two
'' its author happened to write. That is not a decision anybody made; it is what
'' MinGW's headers do with __USE_MINGW_ANSI_STDIO. Reproducing it means matching
'' the CALL, not picking the better implementation.
''
'' The wide family is MSVCRT throughout, because swprintf is #defined to
'' _snwprintf there.
''
'' This was found by a differential: STR$ of 1e20 disagreed in the third
'' character of the exponent. The first fix routed everything through MinGW and
'' made the narrow column right and the wide column wrong -- which is how the
'' split came to light at all. tests/abi/tostr-parity.bas carries all of it.
''
'' LINUX HAS NO SPLIT: glibc has one implementation and it is C99. This is
'' genuinely about WHICH LIBC, not a width, so it is an #ifdef.

'' THE MICROSOFT ABI HAS NO SPLIT TO REPRODUCE. There is one CRT there -- the
'' UCRT -- and __mingw_sprintf does not exist in it, so the two aliases below
'' cannot point at different implementations however much fbc's accident says
'' they should. Both are the UCRT's, which is C99-conforming.
''
'' THIS IS A KNOWN, DELIBERATE DIVERGENCE and it is the one thing about the
'' win64-msvc target that is not ABI-neutral. Whether it is VISIBLE has not been
'' measured: it cannot be until the archive links, which is what this file is
'' being changed to allow. The instrument is tests/abi/tostr-parity.bas, which
'' already carries every case, and the question it must answer is whether
'' fb_hFloat2Str( 1e20, 16 ) still gives 1e+020 on this target or becomes
'' 1e+20 -- the second would change what PRINT does with a double.
''
'' docs/tiko-rt/RFC-0006 section 3.3 calls this the most dangerous item in the
'' MSVC move, on the grounds that nothing fails to build or link and only the
'' last digits move. It is confined to these two declarations.
#ifdef TKORT_MSVC
	extern "c"   '' NON-FBCALL: these are libc, not rtlib entry points.
		declare function tkrt_sprintf cdecl alias "sprintf" _
			( byval s as zstring ptr, byval fmt as zstring ptr, ... ) as long
		declare function tkrt_snprintf cdecl alias "snprintf" _
			( byval s as zstring ptr, byval n as uinteger, byval fmt as zstring ptr, ... ) as long
	end extern
#elseif defined( __FB_WIN32__ ) or defined( __FB_WIN64__ )
	extern "c"   '' NON-FBCALL: these are libc, not rtlib entry points.
		'' sprintf -> MinGW.  snprintf -> MSVCRT.  Both verified above.
		declare function tkrt_sprintf cdecl alias "__mingw_sprintf" _
			( byval s as zstring ptr, byval fmt as zstring ptr, ... ) as long
		declare function tkrt_snprintf cdecl alias "snprintf" _
			( byval s as zstring ptr, byval n as uinteger, byval fmt as zstring ptr, ... ) as long
	end extern
#else
	extern "c"   '' NON-FBCALL: these are libc, not rtlib entry points.
		'' glibc has one implementation and it is the C99 one.
		declare function tkrt_sprintf cdecl alias "sprintf" _
			( byval s as zstring ptr, byval fmt as zstring ptr, ... ) as long
		declare function tkrt_snprintf cdecl alias "snprintf" _
			( byval s as zstring ptr, byval n as uinteger, byval fmt as zstring ptr, ... ) as long
	end extern
#endif

#endif '' __TKORT_FMT_BI__
