'' call.bas -- fb_ThreadCall, THREADCALL's back end. One entry point over one
'' fbc member (thread_call.o), and it returns NULL on every target -- which is
'' exactly what fbc-modern's own runtime does.
''
'' MEASURED, 2026-09-19 (decision 0015, D15, section 6.3). fbc-modern's shipped
'' thread_call.o is built with DISABLE_FFI: llvm-nm shows it defining
'' fb_ThreadCall and importing NOTHING -- no ffi_prep_cif, no ffi_call. And the
'' program
''
''     dim shared as long g
''     sub worker( byval n as long ) : g = n * 6 : end sub
''     dim as any ptr t = threadcall worker( 7 )
''     print t <> 0 : threadwait t : print g
''
'' prints 0 and 0 when fbc-modern builds it, on win64 AND on linux-x86_64: the
'' handle is NULL and the procedure never runs. THREADWAIT and THREADDETACH
'' already accept a NULL handle (core.bas, detach.bas), so a program that does
'' not check goes on exactly as fbc's does.
''
'' THIS REPLACES fbc's MEMBER; it does not stub out a working one. Until now the
'' win64 and linux targets linked fbc's copy from lib/<target>-fb/ -- the same
'' NULL -- and win64-msvc, which has no fbc archive, failed to LINK any program
'' that used THREADCALL. The compiler warns at every use (TKO0797), so the
'' difference from a working THREADCALL is said at compile time rather than
'' discovered as a thread that never ran.
''
'' THE ARGUMENTS ARE NOT READ. A real implementation marshals them through
'' libffi, and there is no libffi here for any target -- none at all for
'' win64-msvc. When there is, this is the file that changes, and TKO0797 goes.
''
'' VARIADIC, SO extern "c". fbc declares it FBCALL, which is nothing on x86-64,
'' so the symbol is the plain name either way; a '...' needs cdecl in FreeBASIC.

extern "c"   '' NON-FBCALL: variadic, so cdecl; fbc's FBCALL is nothing on x86-64.

function tkort_ThreadCall alias "fb_ThreadCall" _
	( byval proc as any ptr, byval abi as long, byval stack_size as integer, _
	  byval num_args as long, ... ) as any ptr
	return 0
end function

end extern
