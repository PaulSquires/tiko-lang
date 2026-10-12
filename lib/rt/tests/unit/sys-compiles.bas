'' sys-compiles.bas -- S0's acceptance test.
''
'' Compile-only, every target, single- and multi-threaded. It proves the thing
'' S0 exists to prove: that the whole toolchain path works end to end --
'' fbc-modern -gen llvm -> clang -c -> object -- for a module written in the
'' freestanding subset that reaches the OS the way tiko-rt will reach it.
''
'' An empty archive proves the archiver runs. This proves the compiler does.

#include once "sys/sys.ti"

extern "rtlib"

	'' Every shape a tiko-rt entry point takes, so that a regression in any of
	'' them fails here rather than in the middle of S5.

	'' 1. raw memory through libc
	function tkort_SysProbeAlloc( byval n as uinteger ) as any ptr
		dim as any ptr p = malloc( n )
		if p <> 0 then memset( p, 0, n )
		return p
	end function

	sub tkort_SysProbeFree( byval p as any ptr )
		if p <> 0 then free( p )
	end sub

	'' 2. a zstring walk with a pointer-width index (RFC-0003 section 5.1)
	function tkort_SysProbeLen( byval s as zstring ptr ) as integer
		if s = 0 then return 0
		dim as integer n = any
		n = 0
		while s[n] <> 0
			n += 1
		wend
		return n
	end function

	'' 3. the wide side. wchar_t is 2 bytes on Windows and 4 on Linux, so this
	''    must go through wcslen rather than reinterpreting the buffer.
	function tkort_SysProbeWLen( byval s as wstring ptr ) as integer
		if s = 0 then return 0
		return wcslen( s )
	end function

	'' 4. a per-target size that must be taken from the header, never assumed
	function tkort_SysProbeJmpBufSize( ) as integer
		return sizeof( jmp_buf )
	end function

	'' 5. a descriptor-shaped record, to prove layout control
	type TKORT_SYSPROBE field = 1
		as any ptr   data
		as integer   len
		as integer   size
	end type

	function tkort_SysProbeDescSize( ) as integer
		return sizeof( TKORT_SYSPROBE )
	end function

end extern

'' The two layout facts every string entry point depends on. If either is false
'' on any target, every FBSTRING variable is the wrong size and nothing else
'' matters. RFC-0002 section 3.1.
#assert sizeof( TKORT_SYSPROBE ) = 3 * sizeof( any ptr )
#assert sizeof( integer ) = sizeof( any ptr )
