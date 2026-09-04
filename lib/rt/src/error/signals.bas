'' signals.bas -- fb_InitSignals, and the handlers behind it. One symbol, one
'' fbc member (signals.o).
''
'' TURNS A FATAL SIGNAL INTO AN FB RUNTIME ERROR, so a program with an ON ERROR
'' handler gets a chance at a division by zero or a null dereference instead of
'' the process simply dying. Seven signals are hooked; anything else keeps the
'' handler it had.
''
'' THE OLD HANDLERS ARE SAVED AND NEVER RESTORED. sigTb keeps what signal()
'' returned, and nothing in fbc ever puts them back -- not fb_hRtExit, not
'' fb_End. So a DLL that initialises the runtime permanently rewires the host's
'' signal handling. Reproduced, because a program that relies on fbc's error
'' handling would break if tiko-rt restored them.
''
'' THE TABLE IS INDEXED BY SIGNAL NUMBER AND SIZED BY NSIG, AND NSIG IS NOT THE
'' SAME NUMBER ON THE TWO PLATFORMS -- 23 on Windows, 65 on Linux. Nor are the
'' signals themselves: SIGABRT is 22 on Windows and 6 on Linux, and SIGQUIT does
'' not exist on Windows at all. All measured; a shared table sized to one
'' platform's NSIG would index out of bounds on the other.
''
'' A SIGNAL WITH NO ENTRY IS RE-RAISED RATHER THAN HANDLED, and the guard tests
'' three things: a negative number, a number past the table, and an entry whose
'' errnum is FB_RTERROR_OK. The last is what makes an untabulated signal fall
'' through -- the table is memset to zero, and FB_RTERROR_OK is zero, so every
'' slot that was never set up says "not mine". Re-raising with the default
'' handler restored is what makes the process die the way it would have.
''
'' AND IT RE-RAISES INSIDE THE HANDLER, which is only safe because the handler
'' for that signal is no longer this one -- signal() on Windows and on glibc
'' resets to SIG_DFL before the handler runs. Without that this would recurse
'' until the stack ran out.
''
'' fb_End IS CALLED IF THE USER HANDLER RETURNS. An ON ERROR handler that does
'' not RESUME cannot continue from a SIGSEGV -- the faulting instruction would
'' simply re-execute -- so the runtime exits with the error number rather than
'' returning into the fault.
''
'' THE WINDOWS EXCEPTION FILTER IS A SECOND, LOWER LAYER. Windows delivers an
'' access violation as a structured exception, not as a signal, so the CRT's
'' SIGSEGV never fires for a real null dereference. SetUnhandledExceptionFilter
'' catches it first and calls raise() to turn it into the signal the table above
'' expects. It is __stdcall on both widths -- an OS callback, not an rtlib entry
'' point -- and it CHAINS to the filter it replaced rather than swallowing the
'' exception.

#include once "inc/descriptors.bi"
#include once "inc/rterror.bi"
#include once "crt/string.bi"

'' MEASURED, per platform, with a C probe -- see the file header. A shared table
'' sized to the wrong NSIG indexes out of bounds.
#ifdef __FB_WIN32__
	const TKORT_NSIG     = 23
	const TKORT_SIGABRT  = 22
	const TKORT_SIGFPE   = 8
	const TKORT_SIGILL   = 4
	const TKORT_SIGSEGV  = 11
	const TKORT_SIGTERM  = 15
	const TKORT_SIGINT   = 2
	'' SIGQUIT DOES NOT EXIST ON WINDOWS. fbc guards its setup with #ifdef, and
	'' so does this.
#else
	const TKORT_NSIG     = 65
	const TKORT_SIGABRT  = 6
	const TKORT_SIGFPE   = 8
	const TKORT_SIGILL   = 4
	const TKORT_SIGSEGV  = 11
	const TKORT_SIGTERM  = 15
	const TKORT_SIGINT   = 2
	const TKORT_SIGQUIT  = 3
#endif

type FB_SIGHANDLER_PROC as sub cdecl ( byval sig as long )

type FB_SIGHANDLER
	as long                errnum
	as FB_SIGHANDLER_PROC  oldhnd
end type

'' FILE-STATIC, like fbc's. FreeBASIC emits a module-level `dim shared` as a
'' local symbol, so this adds nothing to the exported surface.
dim shared as FB_SIGHANDLER tkort_sigTb( 0 to TKORT_NSIG - 1 )

'' FB_ERRHANDLER is NOT declared here -- inc/rterror.bi already provides it, and
'' a second definition is error 4.

extern "c"   '' NON-FBCALL: libc, and fbc's own error entry point.
	declare function crt_signal alias "signal" _
		( byval sig as long, byval handler as FB_SIGHANDLER_PROC ) as FB_SIGHANDLER_PROC
	declare function crt_raise alias "raise" ( byval sig as long ) as long
	declare function tkrt_ErrorThrowEx alias "fb_ErrorThrowEx" _
		( byval errnum as long, byval linenum as long, byval modname as any ptr, _
		  byval funcname as any ptr, byval res_lbl as any ptr ) as FB_ERRHANDLER
end extern

extern "rtlib"   '' FBCALL: fb_End is decorated, `_fb_End@4` on win32.
	declare sub tkrt_End alias "fb_End" ( byval errlevel as long )
end extern

#ifdef __FB_WIN32__

	const EXCEPTION_ACCESS_VIOLATION_    = &hC0000005u
	const EXCEPTION_STACK_OVERFLOW_      = &hC00000FDu
	const EXCEPTION_FLT_DIVIDE_BY_ZERO_  = &hC000008Eu
	const EXCEPTION_FLT_OVERFLOW_        = &hC0000091u
	const EXCEPTION_INT_DIVIDE_BY_ZERO_  = &hC0000094u
	const EXCEPTION_INT_OVERFLOW_        = &hC0000095u

	'' EXCEPTION_POINTERS is two pointers; the first is the EXCEPTION_RECORD,
	'' whose FIRST field is the code. Only that one field is read, so the record
	'' is not modelled beyond it.
	type EXCEPTION_POINTERS_
		as any ptr ExceptionRecord
		as any ptr ContextRecord
	end type

	type TOP_LEVEL_FILTER as function stdcall ( byval info as EXCEPTION_POINTERS_ ptr ) as long

	extern "c"   '' NON-FBCALL: kernel32, `stdcall` per declaration.
		declare function w_SetUnhandledExceptionFilter stdcall alias "SetUnhandledExceptionFilter" _
			( byval f as TOP_LEVEL_FILTER ) as TOP_LEVEL_FILTER
	end extern

	dim shared as TOP_LEVEL_FILTER tkort_old_excpfilter

#endif

'' THE SHARED HANDLER. Not `extern "c"` -- it is never named outside this file,
'' and its address is only ever handed to signal(). It must be cdecl to match
'' what signal() will call it as, which is what the FB_SIGHANDLER_PROC type says.
private sub tkort_gen_handler cdecl ( byval sig as long )

	'' THREE CONDITIONS, and the third is the one that matters: an entry whose
	'' errnum is FB_RTERROR_OK was never set up, because the table is zeroed and
	'' FB_RTERROR_OK is zero. Re-raise rather than handle.
	if( (sig < 0) orelse (sig >= TKORT_NSIG) orelse _
	    (tkort_sigTb(sig).errnum = FB_RTERROR_OK) ) then
		'' SAFE ONLY BECAUSE signal() RESET THIS SIGNAL TO SIG_DFL before
		'' calling us -- otherwise this recurses until the stack is gone.
		crt_raise( sig )
		exit sub
	end if

	'' The user's ON ERROR handler, if the program installed one.
	dim as FB_ERRHANDLER handler = tkrt_ErrorThrowEx( tkort_sigTb(sig).errnum, -1, 0, 0, 0 )
	if( handler <> 0 ) then handler( )

	'' IF IT RETURNED, EXIT. There is nothing to resume to -- the faulting
	'' instruction would simply run again.
	tkrt_End( tkort_sigTb(sig).errnum )

end sub

#ifdef __FB_WIN32__

'' WINDOWS DELIVERS THESE AS STRUCTURED EXCEPTIONS, NOT SIGNALS, so without this
'' filter the CRT's SIGSEGV never fires for a real null dereference. raise()
'' turns the exception into the signal the table expects.
private function tkort_exception_filter stdcall ( byval info as EXCEPTION_POINTERS_ ptr ) as long

	'' The code is the FIRST field of the EXCEPTION_RECORD, which is why the
	'' record itself does not need modelling.
	dim as ulong code = *cptr( ulong ptr, info->ExceptionRecord )

	select case code
	case EXCEPTION_ACCESS_VIOLATION_, EXCEPTION_STACK_OVERFLOW_
		crt_raise( TKORT_SIGSEGV )
	case EXCEPTION_FLT_DIVIDE_BY_ZERO_, EXCEPTION_FLT_OVERFLOW_, _
	     EXCEPTION_INT_DIVIDE_BY_ZERO_, EXCEPTION_INT_OVERFLOW_
		crt_raise( TKORT_SIGFPE )
	end select

	'' CHAINED, NOT SWALLOWED: whatever filter was installed before still runs,
	'' which is what keeps a debugger attached to the process working.
	return tkort_old_excpfilter( info )

end function

#endif

extern "rtlib"   '' FBCALL: fb_InitSignals is decorated, and the win32 archive
                 '' spells it `_fb_InitSignals@0`.

sub tkort_InitSignals alias "fb_InitSignals" ( )

	memset( @tkort_sigTb(0), 0, sizeof( FB_SIGHANDLER ) * TKORT_NSIG )

	'' THE OLD HANDLER IS SAVED AND NEVER PUT BACK -- see the file header.
	#macro TKORT_SETUPSIGNAL( n, e )
		tkort_sigTb(n).oldhnd = crt_signal( n, @tkort_gen_handler )
		tkort_sigTb(n).errnum = e
	#endmacro

	TKORT_SETUPSIGNAL( TKORT_SIGABRT, FB_RTERROR_SIGABRT )
	TKORT_SETUPSIGNAL( TKORT_SIGFPE,  FB_RTERROR_SIGFPE )
	TKORT_SETUPSIGNAL( TKORT_SIGILL,  FB_RTERROR_SIGILL )
	TKORT_SETUPSIGNAL( TKORT_SIGSEGV, FB_RTERROR_SIGSEGV )
	TKORT_SETUPSIGNAL( TKORT_SIGTERM, FB_RTERROR_SIGTERM )
	TKORT_SETUPSIGNAL( TKORT_SIGINT,  FB_RTERROR_SIGINT )

	#ifndef __FB_WIN32__
		'' GUARDED, because Windows has no SIGQUIT at all.
		TKORT_SETUPSIGNAL( TKORT_SIGQUIT, FB_RTERROR_SIGQUIT )
	#endif

	#ifdef __FB_WIN32__
		tkort_old_excpfilter = w_SetUnhandledExceptionFilter( @tkort_exception_filter )
	#endif

end sub

end extern
