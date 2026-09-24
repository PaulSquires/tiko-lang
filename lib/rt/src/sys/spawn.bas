'' spawn.bas -- fb_ExecEx, behind EXEC and RUN. One symbol, one fbc member
'' (sys_execex.o).
''
'' TWO IMPLEMENTATIONS THAT SHARE ONLY THEIR SIGNATURE.
''
''   Windows   _spawnl / _execl with the arguments as ONE STRING. The CRT hands
''             the command line to the child unparsed, so the child's own startup
''             splits it -- which is why the program path goes through
''             fb_hGetShortPath first: a path with a space in it would be split
''             into two arguments by the child.
''   POSIX     fork + execvp with a real argv VECTOR. fb_hParseArgs splits the
''             argument string IN PLACE into NUL-separated pieces and returns the
''             count; the pointers are then walked out of that buffer.
''
'' So the same call produces a different argument split on the two platforms, and
'' that is fbc's behaviour rather than something this file chose.
''
'' do_fork MEANS "WAIT FOR IT", WHICH IS THE OPPOSITE OF WHAT IT SOUNDS LIKE.
'' True runs the child and waits, returning its exit code; false REPLACES this
'' process on POSIX (execvp never returns) and on Windows returns the child's
'' handle as an integer. The name is fbc's.
''
'' THE POSIX FAILURE PATH IS A DELIBERATE HACK AND IS REPRODUCED. execvp only
'' returns if it failed, and the child has no other way to tell the parent, so it
'' calls _exit(255) -- and the parent maps a 255 exit status back to -1. fbc's
'' own comment admits this cannot distinguish a child that genuinely returned
'' 255. It also uses _exit rather than exit ON PURPOSE: exit would flush file I/O
'' and run global destructors, including the runtime's own clean-up, which waits
'' on threads that fork() did not duplicate.
''
'' alloca IS NOT AVAILABLE IN FREEBASIC, and this is the one place the port has
'' to substitute for it. fbc allocates the argument buffer and the argv vector on
'' the stack, both sized from the caller's string, so neither has a bound. The
'' substitute here is malloc/free, which is behaviourally identical and differs
'' only in the allocation TRACE -- one malloc/free pair per call, on a path that
'' spawns a process. Freeing has to happen on every return, including the ones
'' where the child was launched, which is the cost of not having alloca's
'' automatic release.
''
'' AND ON THE POSIX no-fork PATH IT IS NEVER FREED, correctly: execvp replaces
'' the process image, so there is nothing to free and nothing to leak. If execvp
'' FAILS it returns, and the free below runs.

#include once "inc/descriptors.bi"
#include once "inc/ctx.bi"
#include once "inc/console.bi"
#include once "inc/print.bi"
#include once "inc/sysbind.bi"

'' fb.h's MAX_PATH, which is fbc's own 1024 and NOT Windows' 260.
const TKORT_EXEC_MAXPATH = 1024

extern "c"   '' NON-FBCALL: the string internals and tiko-rt's own helpers.
	declare function tkrt_hStrDelTemp_NoLock alias "fb_hStrDelTemp_NoLock" _
		( byval s as FBSTRING ptr ) as long
	declare sub fb_StrLock alias "fb_StrLock" ( )
	declare sub fb_StrUnlock alias "fb_StrUnlock" ( )
	declare sub tkrt_hConvertPath alias "fb_hConvertPath" ( byval p as zstring ptr )
	declare function tkrt_hParseArgs alias "fb_hParseArgs" _
		( byval dst as zstring ptr, byval src as zstring ptr, byval l as integer ) as long
end extern

extern "rtlib"   '' FBCALL: fb_hStrDelTemp is decorated.
	declare function tkrt_hStrDelTemp alias "fb_hStrDelTemp" ( byval s as FBSTRING ptr ) as long
end extern

#ifdef ENABLE_MT
	#define STRLOCK()   fb_StrLock()
	#define STRUNLOCK() fb_StrUnlock()
#else
	#define STRLOCK()
	#define STRUNLOCK()
#endif

#ifdef __FB_WIN32__

	'' _P_WAIT, measured with a C probe -- process.h's mode constants.
	const TKORT_P_WAIT = 0

	extern "c"   '' NON-FBCALL: MSVCRT, and fbc's short-path helper.
		'' VARIADIC, and therefore cdecl: the argument list is terminated by a
		'' NULL, which is why these cannot be declared with a fixed arity.
		declare function crt_spawnl alias "_spawnl" _
			( byval mode_ as long, byval path as zstring ptr, ... ) as integer
		declare function crt_execl alias "_execl" _
			( byval path as zstring ptr, ... ) as integer
		declare function tkrt_hGetShortPath alias "fb_hGetShortPath" _
			( byval src as zstring ptr, byval dst as zstring ptr, byval maxlen as integer ) as zstring ptr
		'' fbc's, in io_printbuff.o -- still C, and the reason this file cannot
		'' spell FB_CON_CORRECT_POSITION as anything but a call.
		declare sub tkrt_ConsolePrintBufferEx alias "fb_ConsolePrintBufferEx" _
			( byval buffer as any ptr, byval l as uinteger, byval mask as long )
	end extern

#else

	extern "c"   '' NON-FBCALL: libc, and fbc's console bracket.
		declare function u_fork alias "fork" ( ) as long
		declare function u_execvp alias "execvp" _
			( byval file_ as zstring ptr, byval argv as zstring ptr ptr ) as long
		declare function u_waitpid alias "waitpid" _
			( byval pid as long, byval status as long ptr, byval options as long ) as long
		declare sub u__exit alias "_exit" ( byval code as long )
		declare sub tkrt_hExitConsole alias "fb_hExitConsole" ( )
		declare sub tkrt_hInitConsole alias "fb_hInitConsole" ( )
	end extern

	'' WIFEXITED / WEXITSTATUS, spelled out. glibc defines them as macros over
	'' the raw status word: the low 7 bits are the terminating signal, so a
	'' normal exit has them clear, and the exit code is bits 8..15.
	#define TKORT_WIFEXITED( s )   (((s) and &h7F) = 0)
	#define TKORT_WEXITSTATUS( s ) (((s) shr 8) and &hFF)

#endif

extern "rtlib"   '' FBCALL: fb_system.h decorates fb_ExecEx, and the win32
                 '' archive spells it `_fb_ExecEx@12`.

function tkort_ExecEx alias "fb_ExecEx" _
	( byval program as FBSTRING ptr, byval args as FBSTRING ptr, _
	  byval do_fork as long ) as long

	dim as zstring * TKORT_EXEC_MAXPATH buffer = any
	dim as zstring ptr arguments = 0
	dim as integer len_arguments = 0
	dim as long res = -1

	'' A MISSING PROGRAM CONSUMES BOTH ARGUMENTS AND FAILS. This happens before
	'' the lock, so it is the LOCKING delete.
	if( (program = 0) orelse (program->data = 0) ) then
		tkrt_hStrDelTemp( args )
		tkrt_hStrDelTemp( program )
		return -1
	end if

	#ifdef __FB_WIN32__
		'' THE SHORT PATH, because the child's own startup splits the command
		'' line on spaces and a long path would be torn in two.
		tkrt_hGetShortPath( program->data, @buffer, TKORT_EXEC_MAXPATH )

		'' ONE STRING, NOT A VECTOR -- see the file header.
		if( args = 0 ) then
			arguments = @""
		else
			len_arguments = FB_STRSIZE( args )
			'' alloca's substitute. See the file header.
			arguments = cptr( zstring ptr, malloc( len_arguments + 1 ) )
			if( arguments = 0 ) then
				tkrt_hStrDelTemp( args )
				tkrt_hStrDelTemp( program )
				return -1
			end if
			if( len_arguments <> 0 ) then memcpy( arguments, args->data, len_arguments )
			arguments[len_arguments] = 0
		end if

		STRLOCK()
		tkrt_hStrDelTemp_NoLock( args )
		tkrt_hStrDelTemp_NoLock( program )
		STRUNLOCK()

		'' FB_CON_CORRECT_POSITION(): if the last print left the cursor parked
		'' at the right margin without scrolling, flush that first so the child
		'' starts on the line the user can see.
		if( TKORT_CON_SCROLLOFF() <> 0 ) then
			tkrt_ConsolePrintBufferEx( 0, 0, FB_PRINT_FORCE_ADJUST )
		end if

		'' THE ARGUMENT LIST IS NULL-TERMINATED, which is what makes these
		'' variadic rather than three-argument calls.
		if( do_fork <> 0 ) then
			res = cast( long, crt_spawnl( TKORT_P_WAIT, @buffer, @buffer, arguments, 0 ) )
		else
			res = cast( long, crt_execl( @buffer, @buffer, arguments, 0 ) )
		end if

		'' Freed on every path that returns -- alloca would have done it.
		if( (args <> 0) andalso (arguments <> 0) ) then free( arguments )

		return res
	#else
		strncpy( @buffer, program->data, TKORT_EXEC_MAXPATH )
		buffer[TKORT_EXEC_MAXPATH - 1] = 0

		tkrt_hConvertPath( @buffer )

		dim as long argc = 0

		if( args = 0 ) then
			arguments = @""
		else
			len_arguments = FB_STRSIZE( args )
			arguments = cptr( zstring ptr, malloc( len_arguments + 1 ) )
			if( arguments = 0 ) then
				tkrt_hStrDelTemp( args )
				tkrt_hStrDelTemp( program )
				return -1
			end if
			'' THE TERMINATOR IS WRITTEN BEFORE THE SPLIT, because fb_hParseArgs
			'' rewrites the buffer in place and relies on it.
			arguments[len_arguments] = 0
			if( len_arguments <> 0 ) then
				argc = tkrt_hParseArgs( arguments, args->data, len_arguments )
			end if
		end if

		STRLOCK()
		tkrt_hStrDelTemp_NoLock( args )
		tkrt_hStrDelTemp_NoLock( program )
		STRUNLOCK()

		if( argc = -1 ) then
			if( (args <> 0) andalso (arguments <> 0) ) then free( arguments )
			return -1
		end if

		argc += 1                       '' one more for the program name itself

		dim as zstring ptr ptr argv = cptr( zstring ptr ptr, malloc( sizeof( any ptr ) * (argc + 1) ) )
		if( argv = 0 ) then
			if( (args <> 0) andalso (arguments <> 0) ) then free( arguments )
			return -1
		end if

		argv[0] = @buffer

		'' WALK THE NUL-SEPARATED PIECES fb_hParseArgs left behind: skip to one
		'' character past the next terminator, argc-1 times.
		dim as zstring ptr p = arguments
		for i as integer = 1 to argc - 1
			argv[i] = p
			while( p[0] <> 0 )
				p += 1
			wend
			p += 1
		next
		argv[argc] = 0

		'' The console is handed back to the child and reclaimed afterwards.
		STRLOCK()
		tkrt_hExitConsole( )
		STRUNLOCK()

		if( do_fork <> 0 ) then
			dim as long pid = u_fork( )
			if( pid <> -1 ) then
				if( pid = 0 ) then
					'' THE CHILD. execvp only returns if it FAILED, and there is
					'' no other channel back to the parent -- so 255 is the
					'' agreed failure code, and the parent maps it to -1.
					u_execvp( @buffer, argv )
					'' _exit, NOT exit: exit would flush file I/O and run the
					'' runtime's global destructors, which wait on threads that
					'' fork() did not duplicate.
					u__exit( 255 )
				else
					dim as long status = any
					if( (u_waitpid( pid, @status, 0 ) > 0) andalso TKORT_WIFEXITED( status ) ) then
						res = TKORT_WEXITSTATUS( status )
						'' AND THE AMBIGUITY fbc ACCEPTS: a child that really
						'' returned 255 is indistinguishable from a failed exec.
						if( res = 255 ) then res = -1
					end if
				end if
			end if
		else
			'' REPLACES THIS PROCESS if it succeeds, so nothing below runs and
			'' the two buffers are reclaimed by the exec itself.
			res = u_execvp( @buffer, argv )
		end if

		STRLOCK()
		tkrt_hInitConsole( )
		STRUNLOCK()

		free( argv )
		if( (args <> 0) andalso (arguments <> 0) ) then free( arguments )

		return res
	#endif

end function

end extern
