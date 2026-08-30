'' file.bas -- the portable file dispatchers: TELL, SEEK, SIZE, FLUSH, SETEOF
'' and the file locks. Sixteen entry points over six fbc members.
''
'' EVERY ONE OF THESE IS A DISPATCHER, not an implementation: it validates the
'' handle, adjusts for the file mode, and calls through the hook table that the
'' per-platform device layer installed. The hooks themselves stay fbc's -- they
'' are the Win32 / POSIX code, and they are the part that is genuinely three
'' implementations rather than one.
''
'' ================================================== THE TWO ADJUSTMENTS
''
'' BASIC FILE POSITIONS ARE 1-BASED AND RANDOM MODE COUNTS RECORDS. Every
'' position crossing this boundary gets both treatments and they do not commute:
''
''     SEEK    subtract 1, THEN multiply by the record length
''     TELL    divide by the record length, THEN add 1
''
'' So SEEK #f, 3 on a RANDOM file with a 128-byte record seeks to byte 256, and
'' TELL turns 256 back into 3. Getting the order wrong is off by one record
'' rather than by one byte.
''
'' AND TELL SUBTRACTS THE PUT-BACK BUFFER. A character pushed back with UNGET is
'' still counted in the OS position but has not been consumed, so the reported
'' position has to move back by however many are pending -- otherwise TELL after
'' an UNGET reports a position the next read will not return from.

#include once "inc/descriptors.bi"
#include once "inc/file.bi"

#ifdef ENABLE_MT
	extern "rtlib"
		declare sub fb_Lock alias "fb_Lock" ( )
		declare sub fb_Unlock alias "fb_Unlock" ( )
	end extern
	#define IOLOCK()   fb_Lock()
	#define IOUNLOCK() fb_Unlock()
#else
	#define IOLOCK()
	#define IOUNLOCK()
#endif

extern "rtlib"
	declare function tkrt_ErrorSetNum alias "fb_ErrorSetNum" ( byval e as long ) as long
end extern

#include once "inc/rterror.bi"

'' The C library's whence values, not FreeBASIC's -- these go straight to the
'' hook, which is C.
const TKORT_SEEK_SET = 0
const TKORT_SEEK_END = 2

extern "c"   '' NON-FBCALL: the *Ex forms take a handle, per fb_file.h.

'' TELL. Returns a 1-BASED position, and 0 for a handle that is not open.
function tkort_FileTellEx alias "fb_FileTellEx" ( byval h as FB_FILE ptr ) as longint

	if( TKORT_HANDLE_USED( h ) = 0 ) then return 0

	IOLOCK()

	dim as longint pos_ = -1
	if( h->hooks->pfnTell <> 0 ) then
		if( h->hooks->pfnTell( h, @pos_ ) <> 0 ) then pos_ = -1
	end if

	if( pos_ <> -1 ) then
		'' Pending put-back characters have not been consumed.
		pos_ -= h->putback_size
		'' Then records, not bytes.
		if( h->mode = FB_FILE_MODE_RANDOM ) then pos_ \= h->reclen
	end if

	IOUNLOCK()

	'' NOTE THE +1 IS OUTSIDE THE GUARD: a failed TELL reports -1 + 1 = 0, which
	'' is the same answer as a closed handle. fbc does this and callers cannot
	'' distinguish the two.
	return pos_ + 1

end function

'' SIZE. Seeks to the end and back, so it needs BOTH hooks -- a handle with only
'' one reports 0 rather than guessing.
function tkort_FileSizeEx alias "fb_FileSizeEx" ( byval h as FB_FILE ptr ) as longint

	dim as longint res = 0
	if( TKORT_HANDLE_USED( h ) = 0 ) then return res

	IOLOCK()

	if( (h->hooks->pfnSeek <> 0) andalso (h->hooks->pfnTell <> 0) ) then
		dim as longint old_pos = any
		dim as long r = h->hooks->pfnTell( h, @old_pos )
		if( r = 0 ) then r = h->hooks->pfnSeek( h, 0, TKORT_SEEK_END )
		if( r = 0 ) then
			r = h->hooks->pfnTell( h, @res )
			'' The restore is NOT checked -- fbc ignores its result, so a
			'' failure here leaves the handle at the end and reports the size.
			h->hooks->pfnSeek( h, old_pos, TKORT_SEEK_SET )
		end if
	end if

	IOUNLOCK()
	return res

end function

'' SEEK. Note the order: 1-based first, then records.
function tkort_FileSeekEx alias "fb_FileSeekEx" _
	( byval h as FB_FILE ptr, byval newpos as longint ) as long

	if( TKORT_HANDLE_USED( h ) = 0 ) then
		return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end if

	IOLOCK()

	'' ANY MODIFYING NON-READ OPERATION DROPS THE PUT-BACK BUFFER. A character
	'' pushed back before a seek belongs to a position the seek just left.
	h->putback_size = 0

	newpos -= 1
	if( h->mode = FB_FILE_MODE_RANDOM ) then newpos = newpos * h->reclen

	dim as long res = any
	if( h->hooks->pfnSeek <> 0 ) then
		res = h->hooks->pfnSeek( h, newpos, TKORT_SEEK_SET )
	else
		res = tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end if

	IOUNLOCK()
	return res

end function

end extern

extern "c"   '' NON-FBCALL: the platform hooks these two call.
	declare function tkrt_hFileFlushEx alias "fb_hFileFlushEx" ( byval f as any ptr ) as long
	declare function tkrt_hFileSetEofEx alias "fb_hFileSetEofEx" ( byval f as any ptr ) as long
end extern

extern "c"   '' NON-FBCALL: the *Ex forms take a handle.

'' Only a WRITABLE mode may be flushed or truncated. INPUT is rejected, which is
'' why this is a mode test rather than a hook test.
private function hWritableMode( byval m as long ) as integer
	if( m = FB_FILE_MODE_BINARY ) then return -1
	if( m = FB_FILE_MODE_RANDOM ) then return -1
	if( m = FB_FILE_MODE_OUTPUT ) then return -1
	if( m = FB_FILE_MODE_APPEND ) then return -1
	return 0
end function

'' FLUSH. systembuffers <> 0 also pushes the C stream buffer down to the OS,
'' which is a second, separate flush through the opaque FILE*.
function tkort_FileFlushEx alias "fb_FileFlushEx" _
	( byval h as FB_FILE ptr, byval systembuffers as long ) as long

	IOLOCK()

	if( TKORT_HANDLE_USED( h ) = 0 ) then
		IOUNLOCK()
		return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end if

	if( hWritableMode( h->mode ) = 0 ) then
		IOUNLOCK()
		return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end if

	dim as long res = any
	if( h->hooks->pfnFlush <> 0 ) then
		res = h->hooks->pfnFlush( h )
		if( (res = FB_RTERROR_OK) andalso (systembuffers <> 0) ) then
			res = tkrt_hFileFlushEx( h->opaque )
		end if
	else
		res = tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end if

	IOUNLOCK()
	return res

end function

'' SETEOF truncates at the CURRENT position -- everything from it onward goes.
'' It flushes first, because the buffered bytes belong before the cut.
function tkort_FileSetEofEx alias "fb_FileSetEofEx" ( byval h as FB_FILE ptr ) as long

	IOLOCK()

	if( TKORT_HANDLE_USED( h ) = 0 ) then
		IOUNLOCK()
		return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end if

	if( hWritableMode( h->mode ) = 0 ) then
		IOUNLOCK()
		return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end if

	'' NOTE THE NESTED LOCK. fb_FileFlushEx takes it again, and FB_STRLOCK is
	'' recursive on both platforms -- which is what makes this legal rather than
	'' a deadlock. RFC-0002 records the recursion; this is the first place in
	'' tiko-rt that relies on it.
	dim as long res = tkort_FileFlushEx( h, 0 )
	if( res = FB_RTERROR_OK ) then res = tkrt_hFileSetEofEx( h->opaque )

	IOUNLOCK()
	return res

end function

'' ------------------------------------------------------------------ LOCK
''
'' THE TWO DO NOT AGREE WITH EACH OTHER, and that is the whole point:
''
''     LOCK   calls the hook with ( inipos - 1, endpos - inipos )
''     UNLOCK calls the hook with ( inipos,     endpos - inipos )
''
'' Both start from the same `--inipos` conversion, and then LOCK subtracts ONE
'' MORE. So LOCK #f, 2, 8 locks from byte 0 while UNLOCK #f, 2, 8 tries to
'' release from byte 1 -- a range that was never locked -- and the OS refuses.
'' Measured: fbc returns FB_RTERROR_FILEIO (3) for the unlock and for every
'' subsequent lock of the same range.
''
'' THE FIRST VERSION HERE APPLIED THE -1 TO BOTH, which is the obvious tidy-up
'' and makes unlock SUCCEED. That is a different runtime, not a better one: a
'' program that locks and unlocks sees 0 where fbc gives 3, and one that relies
'' on the failure sees nothing. The differential caught it on the first run.
''
'' Also asymmetric, and also kept: LOCK tests FB_HANDLE_USED -- handle AND hooks
'' -- while UNLOCK tests only `hooks != NULL`. An unlock on a NULL handle
'' therefore dereferences it where the matching lock would have returned an
'' error, which is why the differential does not call it that way.

function tkort_FileLockEx alias "fb_FileLockEx" _
	( byval h as FB_FILE ptr, byval inipos as longint, byval endpos as longint ) as long

	if( (inipos < 1) orelse (endpos <= inipos) ) then
		return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end if
	if( TKORT_HANDLE_USED( h ) = 0 ) then
		return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end if

	IOLOCK()

	inipos -= 1
	if( h->mode = FB_FILE_MODE_RANDOM ) then
		inipos = h->reclen * inipos
		endpos = inipos + h->reclen
	else
		endpos -= 1
	end if

	dim as long res = any
	if( h->hooks->pfnLock <> 0 ) then
		'' inipos - 1: the second decrement. See the note above.
		res = h->hooks->pfnLock( h, inipos - 1, endpos - inipos )
	else
		res = tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end if

	IOUNLOCK()
	return res

end function

function tkort_FileUnlockEx alias "fb_FileUnlockEx" _
	( byval h as FB_FILE ptr, byval inipos as longint, byval endpos as longint ) as long

	if( (inipos < 1) orelse (endpos <= inipos) ) then
		return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end if

	'' NO FB_HANDLE_USED TEST -- fbc checks only `hooks` here. See the note above.

	IOLOCK()

	inipos -= 1
	if( h->mode = FB_FILE_MODE_RANDOM ) then
		inipos = h->reclen * inipos
		endpos = inipos + h->reclen
	else
		endpos -= 1
	end if

	dim as long res = any
	if( h->hooks <> 0 ) then
		if( h->hooks->pfnUnlock <> 0 ) then
			'' inipos, NOT inipos - 1. The asymmetry with LOCK is deliberate.
			res = h->hooks->pfnUnlock( h, inipos, endpos - inipos )
		else
			res = tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
		end if
	else
		res = tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end if

	IOUNLOCK()
	return res

end function

end extern

'' ================================================ the file-number tier: FBCALL

extern "rtlib"

function tkort_FileTell alias "fb_FileTell" ( byval fnum as long ) as longint
	return tkort_FileTellEx( TKORT_FILE_TO_HANDLE( fnum ) )
end function

function tkort_FileSize alias "fb_FileSize" ( byval fnum as long ) as longint
	return tkort_FileSizeEx( TKORT_FILE_TO_HANDLE( fnum ) )
end function

'' SEEK takes a 32-bit position and SeekLarge a 64-bit one; both reach the same
'' dispatcher, so the only difference is how much of a large offset survives the
'' call.
function tkort_FileSeek alias "fb_FileSeek" _
	( byval fnum as long, byval newpos as long ) as long
	return tkort_FileSeekEx( TKORT_FILE_TO_HANDLE( fnum ), newpos )
end function

function tkort_FileSeekLarge alias "fb_FileSeekLarge" _
	( byval fnum as long, byval newpos as longint ) as long
	return tkort_FileSeekEx( TKORT_FILE_TO_HANDLE( fnum ), newpos )
end function

function tkort_FileFlush alias "fb_FileFlush" _
	( byval fnum as long, byval systembuffers as long ) as long
	return tkort_FileFlushEx( TKORT_FILE_TO_HANDLE( fnum ), systembuffers )
end function

function tkort_FileSetEof alias "fb_FileSetEof" ( byval fnum as long ) as long
	return tkort_FileSetEofEx( TKORT_FILE_TO_HANDLE( fnum ) )
end function

'' The unsigned parameters are fbc's: a negative position is rejected by the
'' inipos < 1 test after conversion, not by the type.
function tkort_FileLock alias "fb_FileLock" _
	( byval fnum as long, byval inipos as ulong, byval endpos as ulong ) as long
	return tkort_FileLockEx( TKORT_FILE_TO_HANDLE( fnum ), inipos, endpos )
end function

function tkort_FileLockLarge alias "fb_FileLockLarge" _
	( byval fnum as long, byval inipos as longint, byval endpos as longint ) as long
	return tkort_FileLockEx( TKORT_FILE_TO_HANDLE( fnum ), inipos, endpos )
end function

function tkort_FileUnlock alias "fb_FileUnlock" _
	( byval fnum as long, byval inipos as ulong, byval endpos as ulong ) as long
	return tkort_FileUnlockEx( TKORT_FILE_TO_HANDLE( fnum ), inipos, endpos )
end function

function tkort_FileUnlockLarge alias "fb_FileUnlockLarge" _
	( byval fnum as long, byval inipos as longint, byval endpos as longint ) as long
	return tkort_FileUnlockEx( TKORT_FILE_TO_HANDLE( fnum ), inipos, endpos )
end function

end extern
