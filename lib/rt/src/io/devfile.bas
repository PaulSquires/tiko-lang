'' devfile.bas -- the FILE* device: OPEN on a real file. Twenty symbols across
'' sixteen fbc members, and portable to all three targets.
''
'' THE DEVICE IS A `FILE *` IN handle->opaque AND NOTHING ELSE. There is no
'' per-handle info block here, unlike the SCREEN device -- everything the hooks
'' need is either in FB_FILE or in the stdio stream. A NULL opaque is the closed
'' state and every hook tests for it, because CLOSE leaves the handle in the
'' table with its hooks still attached.
''
'' THE HOOK TABLE IS STATIC AND COMPLETE, unlike the SCREEN device's. Files can
'' do everything, so there is no linker-driven feature switch and no lazy fill:
'' one initialised table, taken by address at open. The single NULL is
'' pfnSetWidth -- a file has no width -- and PRINT's TAB/SPC handling reads that
'' NULL as "not a terminal".
''
'' OPEN FOR INPUT OPENS THE FILE TWICE, and that is not redundancy. fseeko is
'' unreliable in text mode, so the size is measured with the file open in BINARY
'' mode and the stream is then freopen'd in text mode -- because text mode is
'' what INPUT needs for newline conversion and for the EOF character. Measuring
'' the size in text mode instead gives a number that is right on Linux and wrong
'' on Windows by one byte per line ending.
''
'' EOF ASKS TWO DIFFERENT QUESTIONS. In BINARY and RANDOM it compares the stream
'' position against the size recorded at open -- so it reports true when the NEXT
'' read would hit the end, which is QB's meaning. In text mode it cannot, because
'' ftello in text mode is not a byte offset; it calls feof and, if that is false,
'' PEEKS ONE CHARACTER and pushes it back. The peek is the part that makes
'' `while not eof(1)` terminate on the last line rather than one iteration late.
''
'' READS FILL THE TAIL WITH NULs. A short read is not an error here: the
'' remainder of the caller's buffer is zeroed and the actual count is returned
'' through pLength. GET on a record past the end therefore yields a zeroed record
'' rather than stale stack.
''
'' THE WIDE PATHS ARE NARROW PATHS WITH A CONVERSION ON EACH END, deliberately:
'' a file opened without ENCODING is a byte file, so fb_wstr_ConvFromA and
'' fb_wstr_ConvToA are what make a wstring GET work at all. ENCODING files go
'' through dev_file_encod_*, which is a different member and not this one.
''
'' alloca IS NOT AVAILABLE IN FREEBASIC, so the two conversion buffers and the
'' filename buffer use a stack array up to a threshold and malloc above it. The
'' THRESHOLD IS NOT THE OBSERVABLE, though -- fbc returns OUT OF MEMORY only on a
'' failed malloc, i.e. only for lengths at or above FB_LOCALBUFF_MAXLEN, so the
'' out-of-memory boundary would differ if this file's local size were treated as
'' the boundary. It is not: STAGE only decides where the staging bytes live.

#include once "inc/descriptors.bi"
#include once "inc/file.bi"
#include once "inc/iolock.bi"
#include once "inc/rterror.bi"
#include once "crt/stdio.bi"
#include once "crt/stdlib.bi"
#include once "crt/string.bi"

'' fb.h.
const FB_FILE_BUFSIZE     = 8192

'' fb_file.h. ANY is zero, so a handle whose access was never set opens
'' read/write and is then REWRITTEN to READWRITE on success -- code downstream
'' tests for READWRITE and would not recognise ANY.
const FB_FILE_ACCESS_ANY       = 0
const FB_FILE_ACCESS_READ      = 1
const FB_FILE_ACCESS_WRITE     = 2
const FB_FILE_ACCESS_READWRITE = 3

'' stdio.h, and the values are the same on all three targets.
const SEEK_SET_ = 0
const SEEK_END_ = 2
const IOFBF_    = 0

'' The chunk the large-transfer loops use. Not a tuning knob: a single fread of
'' more than 2 GB is not portable, so the transfer is split.
const CHUNK = 1048576

'' Where the staging bytes live, not what the caller can ask for. See the header.
const STAGE = 1024

extern "rtlib"
	declare function tkrt_ErrorSetNum alias "fb_ErrorSetNum" ( byval e as long ) as long
	declare function tkrt_StrAssign alias "fb_StrAssign" _
		( byval dst as any ptr, byval dst_size as integer, _
		  byval src as any ptr, byval src_size as integer, byval fill_rem as long ) as any ptr
	declare function tkrt_StrConcatAssign alias "fb_StrConcatAssign" _
		( byval dst as any ptr, byval dst_size as integer, _
		  byval src as any ptr, byval src_size as integer, byval fillrem as long ) as any ptr
	declare sub tkrt_StrDelete alias "fb_StrDelete" ( byval s as FBSTRING ptr )
	declare function tkrt_WstrAssignFromA alias "fb_WstrAssignFromA" _
		( byval dst as wstring ptr, byval dst_chars as integer, _
		  byval src as any ptr, byval src_size as integer ) as wstring ptr
end extern

extern "c"   '' NON-FBCALL: the h-prefixed internals and the two libc 64-bit
             '' seek names, all undecorated in fbc's win32 archive.
	declare sub tkrt_ConvertPath alias "fb_hConvertPath" ( byval p as zstring ptr )
	declare function tkrt_hFileLock alias "fb_hFileLock" _
		( byval f as FILE ptr, byval inipos as longint, byval sz as longint ) as long
	declare function tkrt_hFileUnlock alias "fb_hFileUnlock" _
		( byval f as FILE ptr, byval inipos as longint, byval sz as longint ) as long
	declare function tkrt_ConvFromA alias "fb_wstr_ConvFromA" _
		( byval dst as wstring ptr, byval dst_chars as integer, byval src as zstring ptr ) as integer
	declare function tkrt_ConvToA alias "fb_wstr_ConvToA" _
		( byval dst as zstring ptr, byval dst_chars as integer, byval src as wstring ptr ) as integer
	declare function tkrt_fseeko cdecl alias "fseeko" _
		( byval f as FILE ptr, byval off as longint, byval whence as long ) as long
	declare function tkrt_ftello cdecl alias "ftello" ( byval f as FILE ptr ) as longint
end extern

'' The reader hook fb_DevFileReadLineDumb takes. NULL means "use fgets".
type FnDevReadString as function cdecl _
	( byval buffer as zstring ptr, byval count as uinteger, byval fp as FILE ptr ) as zstring ptr

'' EVERY NAME BELOW IS PLAIN cdecl, INCLUDING THE FORWARD DECLARATIONS. The
'' declarations are inside the block on purpose: devscrn2.bas left eight of them
'' outside one, they took FreeBASIC's win32 default of stdcall, and the
'' definitions in the extern block did not override them -- symbols.sh went from
'' seventeen mismatches to eight rather than to zero.
extern "c"   '' NON-FBCALL: every dev_file name is undecorated in fbc's win32
             '' archive -- fb_device.h declares them without FBCALL, because
             '' they are reached through FB_FILE_HOOKS rather than called by
             '' generated code.

declare function tkort_DevFileEof alias "fb_DevFileEof" ( byval h as FB_FILE ptr ) as long
declare function tkort_DevFileClose alias "fb_DevFileClose" ( byval h as FB_FILE ptr ) as long
declare function tkort_DevFileSeek alias "fb_DevFileSeek" _
	( byval h as FB_FILE ptr, byval offset as longint, byval whence as long ) as long
declare function tkort_DevFileTell alias "fb_DevFileTell" _
	( byval h as FB_FILE ptr, byval pOffset as longint ptr ) as long
declare function tkort_DevFileRead alias "fb_DevFileRead" _
	( byval h as FB_FILE ptr, byval dst as any ptr, byval pLength as uinteger ptr ) as long
declare function tkort_DevFileReadWstr alias "fb_DevFileReadWstr" _
	( byval h as FB_FILE ptr, byval dst as wstring ptr, byval pchars as uinteger ptr ) as long
declare function tkort_DevFileWrite alias "fb_DevFileWrite" _
	( byval h as FB_FILE ptr, byval value as any ptr, byval valuelen as uinteger ) as long
declare function tkort_DevFileWriteWstr alias "fb_DevFileWriteWstr" _
	( byval h as FB_FILE ptr, byval value as wstring ptr, byval valuelen as uinteger ) as long
declare function tkort_DevFileLock alias "fb_DevFileLock" _
	( byval h as FB_FILE ptr, byval position as longint, byval sz as longint ) as long
declare function tkort_DevFileUnlock alias "fb_DevFileUnlock" _
	( byval h as FB_FILE ptr, byval position as longint, byval sz as longint ) as long
declare function tkort_DevFileReadLine alias "fb_DevFileReadLine" _
	( byval h as FB_FILE ptr, byval dst as FBSTRING ptr ) as long
declare function tkort_DevFileReadLineWstr alias "fb_DevFileReadLineWstr" _
	( byval h as FB_FILE ptr, byval dst as wstring ptr, byval dst_chars as integer ) as long
declare function tkort_DevFileFlush alias "fb_DevFileFlush" ( byval h as FB_FILE ptr ) as long
declare function tkort_DevFileReadLineDumb alias "fb_DevFileReadLineDumb" _
	( byval fp as FILE ptr, byval dst as FBSTRING ptr, byval pfnReadString as FnDevReadString ) as long
declare function tkort_hDevFileSeekStart alias "fb_hDevFileSeekStart" _
	( byval fp as FILE ptr, byval mode as long, byval encod as long, byval seek_zero as long ) as long
declare function tkort_DevFileGetSize alias "fb_DevFileGetSize" _
	( byval fp as FILE ptr, byval mode as long, byval encod as long, byval seek_back as long ) as longint
declare sub tkort_hSetFileBufSize alias "fb_hSetFileBufSize" ( byval fp as FILE ptr )

end extern

'' STATIC AND FULLY INITIALISED, unlike the SCREEN device's table -- and it can
'' be, because every one of these functions is declared above and defined in this
'' same file. The thirteenth slot is pfnSetWidth and is deliberately NULL.
dim shared as FB_FILE_HOOKS hooks_dev_file = ( _
	@tkort_DevFileEof, _
	@tkort_DevFileClose, _
	@tkort_DevFileSeek, _
	@tkort_DevFileTell, _
	@tkort_DevFileRead, _
	@tkort_DevFileReadWstr, _
	@tkort_DevFileWrite, _
	@tkort_DevFileWriteWstr, _
	@tkort_DevFileLock, _
	@tkort_DevFileUnlock, _
	@tkort_DevFileReadLine, _
	@tkort_DevFileReadLineWstr, _
	0, _
	@tkort_DevFileFlush )

'' fbc uses strcasecmp, which MinGW spells _stricmp. Written out rather than
'' bound, because binding it needs a different name per platform for four lines
'' of code and the comparison is only ever against the literal "CON".
private function hEqualsCON( byval s as zstring ptr ) as long
	dim as ubyte ptr p = cast( ubyte ptr, s )
	dim as ubyte c = any
	dim as ubyte want(0 to 2) = { 67, 79, 78 }
	for i as integer = 0 to 2
		c = p[i]
		if( (c >= 97) andalso (c <= 122) ) then c -= 32
		if( c <> want(i) ) then return 0
	next
	return iif( p[3] = 0, 1, 0 )
end function

extern "c"   '' NON-FBCALL, as declared above.

'' ------------------------------------------------------------------ open

sub tkort_hSetFileBufSize alias "fb_hSetFileBufSize" ( byval fp as FILE ptr )
	'' setvbuf is only legal before any I/O on the stream, which is why every
	'' caller below does it immediately after fopen/freopen and nowhere else.
	setvbuf( fp, 0, IOFBF_, FB_FILE_BUFSIZE )
end sub

'' SKIP THE BYTE ORDER MARK, and only that. In ASCII the function is a no-op
'' unless seek_zero was asked for -- returning 0 without moving -- because
'' rewinding an ASCII stream to 0 on every open would undo an APPEND.
function tkort_hDevFileSeekStart alias "fb_hDevFileSeekStart" _
	( byval fp as FILE ptr, byval mode as long, byval encod as long, byval seek_zero as long ) as long

	dim as uinteger ofs = any

	select case encod
	case FB_FILE_ENCOD_UTF8
		ofs = 3
	case FB_FILE_ENCOD_UTF16
		ofs = 2
	case FB_FILE_ENCOD_UTF32
		ofs = 4
	case else
		if( seek_zero = 0 ) then return 0
		ofs = 0
	end select

	return tkrt_fseeko( fp, ofs, SEEK_SET_ )
end function

'' -1 IS THE FAILURE VALUE AND ALSO THE "NOT MEASURED YET" VALUE, which is why
'' fb_DevFileOpen sets handle->size = -1 before the switch and tests it after.
function tkort_DevFileGetSize alias "fb_DevFileGetSize" _
	( byval fp as FILE ptr, byval mode as long, byval encod as long, byval seek_back as long ) as longint

	dim as longint sz = 0

	select case mode
	case FB_FILE_MODE_BINARY, FB_FILE_MODE_RANDOM, FB_FILE_MODE_INPUT
		if( tkrt_fseeko( fp, 0, SEEK_END_ ) <> 0 ) then return -1
		sz = tkrt_ftello( fp )
		if( seek_back <> 0 ) then
			tkort_hDevFileSeekStart( fp, mode, encod, 1 )
		end if

	case FB_FILE_MODE_APPEND
		'' No seek: an APPEND stream is already at the end.
		sz = tkrt_ftello( fp )
	end select

	return sz
end function

function tkort_DevFileOpen alias "fb_DevFileOpen" _
	( byval h as FB_FILE ptr, byval filename as zstring ptr, byval fname_len as uinteger ) as long

	dim as FILE ptr fp = 0
	dim as zstring ptr openmask = 0
	dim as zstring * (STAGE) local_ = any
	dim as zstring ptr fname = @local_
	dim as any ptr heap_ = 0

	TKORT_IOLOCK()

	if( fname_len >= STAGE ) then
		heap_ = malloc( fname_len + 1 )
		if( heap_ = 0 ) then
			TKORT_IOUNLOCK()
			return tkrt_ErrorSetNum( FB_RTERROR_OUTOFMEM )
		end if
		fname = cast( zstring ptr, heap_ )
	end if
	memcpy( fname, filename, fname_len )
	cast( ubyte ptr, fname )[fname_len] = 0

	'' Slashes to whatever this platform uses. fbc's own, still.
	tkrt_ConvertPath( fname )

	h->hooks = @hooks_dev_file

	select case h->mode
	case FB_FILE_MODE_APPEND
		openmask = @"ab"
	case FB_FILE_MODE_INPUT
		'' "rt" FAILS IF THE FILE DOES NOT EXIST, and that is the whole
		'' difference between INPUT and the others: OPEN FOR INPUT on a
		'' missing file is error 2, not an empty file.
		openmask = @"rt"
	case FB_FILE_MODE_OUTPUT
		openmask = @"wb"
	case FB_FILE_MODE_BINARY, FB_FILE_MODE_RANDOM
		select case h->access
		case FB_FILE_ACCESS_WRITE
			openmask = @"wb"
		case FB_FILE_ACCESS_READ
			openmask = @"rb"
		case else
			'' NOT "w+b": that would TRUNCATE an existing file, and BINARY
			'' access defaults to read/write on a file that already exists.
			openmask = @"r+b"
		end select
	end select

	if( openmask = 0 ) then
		if( heap_ <> 0 ) then free( heap_ )
		TKORT_IOUNLOCK()
		return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end if

	h->size = -1

	select case h->mode
	case FB_FILE_MODE_BINARY, FB_FILE_MODE_RANDOM
		fp = fopen( fname, openmask )
		if( fp = 0 ) then
			'' r+b failed, so the file is missing. In ANY or READWRITE the
			'' open CREATES it -- which is why `OPEN "new" FOR BINARY AS #1`
			'' works on a file that does not exist yet.
			if( (h->access = FB_FILE_ACCESS_ANY) orelse (h->access = FB_FILE_ACCESS_READWRITE) ) then
				fp = fopen( fname, @"w+b" )
				'' And if even creating fails -- a read-only directory -- ANY
				'' falls back to read-only and REWRITES access to match, so
				'' that a later write reports the right error rather than
				'' succeeding into nothing.
				if( (fp = 0) andalso (h->access = FB_FILE_ACCESS_ANY) ) then
					fp = fopen( fname, @"rb" )
					if( fp <> 0 ) then h->access = FB_FILE_ACCESS_READ
				end if
			end if
			if( fp = 0 ) then
				if( heap_ <> 0 ) then free( heap_ )
				TKORT_IOUNLOCK()
				return tkrt_ErrorSetNum( FB_RTERROR_FILENOTFOUND )
			end if
		end if
		tkort_hSetFileBufSize( fp )

	case FB_FILE_MODE_INPUT
		'' Twice: binary to measure, text to read. See the file header.
		fp = fopen( fname, @"rb" )
		if( fp = 0 ) then
			if( heap_ <> 0 ) then free( heap_ )
			TKORT_IOUNLOCK()
			return tkrt_ErrorSetNum( FB_RTERROR_FILENOTFOUND )
		end if
		tkort_hSetFileBufSize( fp )

		h->size = tkort_DevFileGetSize( fp, FB_FILE_MODE_INPUT, h->encod, 0 )
		if( h->size = -1 ) then
			fclose( fp )
			if( heap_ <> 0 ) then free( heap_ )
			TKORT_IOUNLOCK()
			return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
		end if

		fp = freopen( fname, openmask, fp )
		if( fp = 0 ) then
			if( heap_ <> 0 ) then free( heap_ )
			TKORT_IOUNLOCK()
			return tkrt_ErrorSetNum( FB_RTERROR_FILENOTFOUND )
		end if
		tkort_hSetFileBufSize( fp )

		tkort_hDevFileSeekStart( fp, FB_FILE_MODE_INPUT, h->encod, 0 )

	case else
		fp = fopen( fname, openmask )
		if( fp = 0 ) then
			if( heap_ <> 0 ) then free( heap_ )
			TKORT_IOUNLOCK()
			return tkrt_ErrorSetNum( FB_RTERROR_FILENOTFOUND )
		end if
		tkort_hSetFileBufSize( fp )
	end select

	if( h->size = -1 ) then
		h->size = tkort_DevFileGetSize( fp, h->mode, h->encod, 1 )
		if( h->size = -1 ) then
			fclose( fp )
			if( heap_ <> 0 ) then free( heap_ )
			TKORT_IOUNLOCK()
			return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
		end if
	end if

	h->opaque = fp
	if( h->access = FB_FILE_ACCESS_ANY ) then h->access = FB_FILE_ACCESS_READWRITE

	'' ONLY FOR TAB(n) AND SPC(n). The console device is not installed here --
	'' the type is recorded so PRINT's column tracking knows the width matters.
	if( hEqualsCON( fname ) <> 0 ) then h->type_ = FB_FILE_TYPE_CONSOLE

	if( heap_ <> 0 ) then free( heap_ )

	TKORT_IOUNLOCK()

	return tkrt_ErrorSetNum( FB_RTERROR_OK )
end function

'' ------------------------------------------------------------------ close

'' NOT AN ERROR ON A CLOSED HANDLE. CLOSE on a handle whose opaque is already
'' NULL succeeds, because the end-of-program flush can reach here a second time.
function tkort_DevFileClose alias "fb_DevFileClose" ( byval h as FB_FILE ptr ) as long
	TKORT_IOLOCK()
	dim as FILE ptr fp = cast( FILE ptr, h->opaque )
	if( fp <> 0 ) then fclose( fp )
	h->opaque = 0
	TKORT_IOUNLOCK()
	return tkrt_ErrorSetNum( FB_RTERROR_OK )
end function

'' ------------------------------------------------------------------ eof

function tkort_DevFileEof alias "fb_DevFileEof" ( byval h as FB_FILE ptr ) as long

	dim as long is_eof = any, c = any

	TKORT_IOLOCK()

	dim as FILE ptr fp = cast( FILE ptr, h->opaque )
	if( fp = 0 ) then
		TKORT_IOUNLOCK()
		return FB_TRUE
	end if

	select case h->mode
	case FB_FILE_MODE_BINARY, FB_FILE_MODE_RANDOM
		'' The put-back buffer is fb_FileEofEx's business, not this hook's.
		is_eof = iif( tkrt_ftello( fp ) >= h->size, 1, 0 )

	case else
		'' ftello is not a byte offset in text mode, so position cannot be
		'' compared against size. feof answers "the LAST read hit the end";
		'' the peek answers "the NEXT one will".
		is_eof = iif( feof( fp ) <> 0, 1, 0 )
		if( is_eof = 0 ) then
			c = getc( fp )
			is_eof = iif( c = -1, 1, 0 )
			if( is_eof = 0 ) then ungetc( c, fp )
		end if
	end select

	TKORT_IOUNLOCK()

	return iif( is_eof <> 0, FB_TRUE, FB_FALSE )
end function

'' ------------------------------------------------------------------ seek/tell

function tkort_DevFileSeek alias "fb_DevFileSeek" _
	( byval h as FB_FILE ptr, byval offset as longint, byval whence as long ) as long

	TKORT_IOLOCK()
	dim as FILE ptr fp = cast( FILE ptr, h->opaque )
	if( fp = 0 ) then
		TKORT_IOUNLOCK()
		return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end if
	dim as long ok = iif( tkrt_fseeko( fp, offset, whence ) = 0, 1, 0 )
	dim as long res = tkrt_ErrorSetNum( iif( ok <> 0, FB_RTERROR_OK, FB_RTERROR_FILEIO ) )
	TKORT_IOUNLOCK()
	return res
end function

function tkort_DevFileTell alias "fb_DevFileTell" _
	( byval h as FB_FILE ptr, byval pOffset as longint ptr ) as long

	TKORT_IOLOCK()
	dim as FILE ptr fp = cast( FILE ptr, h->opaque )
	if( fp = 0 ) then
		TKORT_IOUNLOCK()
		return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end if
	*pOffset = tkrt_ftello( fp )
	TKORT_IOUNLOCK()
	return tkrt_ErrorSetNum( FB_RTERROR_OK )
end function

'' ------------------------------------------------------------------ lock

'' SIZE ZERO IS REJECTED BEFORE THE LOCK IS TAKEN, and before the handle is even
'' looked at -- an empty range is an illegal function call, not a no-op.
function tkort_DevFileLock alias "fb_DevFileLock" _
	( byval h as FB_FILE ptr, byval position as longint, byval sz as longint ) as long

	if( sz = 0 ) then return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )

	TKORT_IOLOCK()
	dim as FILE ptr fp = cast( FILE ptr, h->opaque )
	if( fp = 0 ) then
		TKORT_IOUNLOCK()
		return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end if
	dim as long res = tkrt_hFileLock( fp, position, sz )
	TKORT_IOUNLOCK()
	return res
end function

function tkort_DevFileUnlock alias "fb_DevFileUnlock" _
	( byval h as FB_FILE ptr, byval position as longint, byval sz as longint ) as long

	if( sz = 0 ) then return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )

	TKORT_IOLOCK()
	dim as FILE ptr fp = cast( FILE ptr, h->opaque )
	if( fp = 0 ) then
		TKORT_IOUNLOCK()
		return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end if
	dim as long res = tkrt_hFileUnlock( fp, position, sz )
	TKORT_IOUNLOCK()
	return res
end function

'' ------------------------------------------------------------------ flush

function tkort_DevFileFlush alias "fb_DevFileFlush" ( byval h as FB_FILE ptr ) as long
	TKORT_IOLOCK()
	dim as FILE ptr fp = cast( FILE ptr, h->opaque )
	if( fp = 0 ) then
		TKORT_IOUNLOCK()
		return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end if
	if( fflush( fp ) <> 0 ) then
		TKORT_IOUNLOCK()
		return tkrt_ErrorSetNum( FB_RTERROR_FILEIO )
	end if
	TKORT_IOUNLOCK()
	return tkrt_ErrorSetNum( FB_RTERROR_OK )
end function

'' ------------------------------------------------------------------ read/write

'' Split into 1 MB chunks, and STOPS EARLY on a short chunk rather than trying
'' the next one -- a partial read means end of file or an error, and continuing
'' would return a total that skips a hole.
private function hFreadLarge( byval p as any ptr, byval nbytes as uinteger, byval fp as FILE ptr ) as uinteger
	dim as uinteger total = 0, n = any
	dim as ubyte ptr q = cast( ubyte ptr, p )
	dim as uinteger left_ = nbytes
	while( left_ > CHUNK )
		n = fread( q, 1, CHUNK, fp )
		total += n
		if( n < CHUNK ) then return total
		q += CHUNK
		left_ -= CHUNK
	wend
	if( left_ > 0 ) then total += fread( q, 1, left_, fp )
	return total
end function

private function hFwriteLarge( byval p as any ptr, byval nbytes as uinteger, byval fp as FILE ptr ) as uinteger
	dim as uinteger total = 0, n = any
	dim as ubyte ptr q = cast( ubyte ptr, p )
	dim as uinteger left_ = nbytes
	while( left_ > CHUNK )
		n = fwrite( q, 1, CHUNK, fp )
		total += n
		if( n < CHUNK ) then return total
		q += CHUNK
		left_ -= CHUNK
	wend
	if( left_ > 0 ) then total += fwrite( q, 1, left_, fp )
	return total
end function

'' A NULL HANDLE MEANS stdin, and so does a handle whose stream is stdout or
'' stderr. That is not a guess: fb_DevScrnInit_Read installs this function as the
'' SCREEN device's reader when input is redirected, and it arrives with the
'' screen handle -- whose opaque is the output stream.
private function hReadStream( byval h as FB_FILE ptr ) as FILE ptr
	if( h = 0 ) then return stdin
	dim as FILE ptr fp = cast( FILE ptr, h->opaque )
	if( (fp = stdout) orelse (fp = stderr) ) then return stdin
	return fp
end function

function tkort_DevFileRead alias "fb_DevFileRead" _
	( byval h as FB_FILE ptr, byval dst as any ptr, byval pLength as uinteger ptr ) as long

	TKORT_IOLOCK()

	dim as uinteger length_ = *pLength
	dim as FILE ptr fp = hReadStream( h )
	if( fp = 0 ) then
		TKORT_IOUNLOCK()
		return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end if

	dim as uinteger rlen = hFreadLarge( dst, length_, fp )

	'' THE TAIL IS ZEROED, not left alone: a GET past the end yields a zeroed
	'' record rather than whatever the caller's buffer held.
	if( rlen <> length_ ) then
		memset( cast( ubyte ptr, dst ) + rlen, 0, length_ - rlen )
	end if

	*pLength = rlen

	TKORT_IOUNLOCK()
	return tkrt_ErrorSetNum( FB_RTERROR_OK )
end function

function tkort_DevFileWrite alias "fb_DevFileWrite" _
	( byval h as FB_FILE ptr, byval value as any ptr, byval valuelen as uinteger ) as long

	TKORT_IOLOCK()
	dim as FILE ptr fp = cast( FILE ptr, h->opaque )
	if( fp = 0 ) then
		TKORT_IOUNLOCK()
		return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end if
	if( hFwriteLarge( value, valuelen, fp ) <> valuelen ) then
		TKORT_IOUNLOCK()
		return tkrt_ErrorSetNum( FB_RTERROR_FILEIO )
	end if
	TKORT_IOUNLOCK()
	return tkrt_ErrorSetNum( FB_RTERROR_OK )
end function

function tkort_DevFileReadWstr alias "fb_DevFileReadWstr" _
	( byval h as FB_FILE ptr, byval dst as wstring ptr, byval pchars as uinteger ptr ) as long

	TKORT_IOLOCK()

	dim as FILE ptr fp = hReadStream( h )
	if( fp = 0 ) then
		TKORT_IOUNLOCK()
		return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end if

	dim as uinteger want = *pchars
	dim as zstring * (STAGE) local_ = any
	dim as zstring ptr buf = @local_
	dim as any ptr heap_ = 0

	if( want >= STAGE ) then
		heap_ = malloc( want + 1 )
		if( heap_ = 0 ) then
			TKORT_IOUNLOCK()
			return tkrt_ErrorSetNum( FB_RTERROR_OUTOFMEM )
		end if
		buf = cast( zstring ptr, heap_ )
	end if

	'' Plain fread, not the chunked one: fbc's wide read is a single call.
	dim as uinteger chars = fread( buf, 1, want, fp )
	cast( ubyte ptr, buf )[chars] = 0

	'' A file opened without ENCODING is a BYTE file, so this is a widening
	'' conversion and not a decode -- ENCODING files go through
	'' fb_DevFileReadEncodWstr instead.
	tkrt_ConvFromA( dst, chars, buf )

	if( heap_ <> 0 ) then free( heap_ )

	if( chars <> want ) then
		memset( cast( ubyte ptr, dst ) + chars * sizeof( wstring ), 0, _
		        (want - chars) * sizeof( wstring ) )
	end if

	*pchars = chars

	TKORT_IOUNLOCK()
	return tkrt_ErrorSetNum( FB_RTERROR_OK )
end function

function tkort_DevFileWriteWstr alias "fb_DevFileWriteWstr" _
	( byval h as FB_FILE ptr, byval src as wstring ptr, byval chars as uinteger ) as long

	TKORT_IOLOCK()

	dim as FILE ptr fp = cast( FILE ptr, h->opaque )
	if( fp = 0 ) then
		TKORT_IOUNLOCK()
		return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end if

	dim as zstring * (STAGE) local_ = any
	dim as zstring ptr buf = @local_
	dim as any ptr heap_ = 0

	if( chars >= STAGE ) then
		heap_ = malloc( chars + 1 )
		if( heap_ = 0 ) then
			TKORT_IOUNLOCK()
			return tkrt_ErrorSetNum( FB_RTERROR_OUTOFMEM )
		end if
		buf = cast( zstring ptr, heap_ )
	end if

	tkrt_ConvToA( buf, chars, src )

	dim as long ok = iif( fwrite( buf, 1, chars, fp ) = chars, 1, 0 )

	if( heap_ <> 0 ) then free( heap_ )

	TKORT_IOUNLOCK()
	return tkrt_ErrorSetNum( iif( ok <> 0, FB_RTERROR_OK, FB_RTERROR_FILEIO ) )
end function

'' ------------------------------------------------------------------ line input

'' THE 512-BYTE BUFFER IS SCANNED BACKWARDS, and that is what makes a line longer
'' than the buffer work. fgets stops at a newline OR at 511 bytes; the loop walks
'' back from the end looking for the first non-NUL, and whether that byte is a
'' CR/LF decides "line complete" versus "buffer full, go round again". A forward
'' scan for CR/LF cannot tell the two apart when the line ends exactly at the
'' boundary.
''
'' THE CR/LF PAIR IS FILTERED ONLY WHEN THE LF IS NOT THE FIRST BYTE. A buffer
'' beginning with LF is a genuinely empty line whose CR was consumed by the
'' previous round, so looking one byte back would read outside the buffer.
''
'' EOF ON THE FIRST ROUND DELETES dst AND RETURNS 17. On a later round it returns
'' 17 with the partial line intact -- LINE INPUT on a file with no trailing
'' newline yields the last line AND the end-of-file error.
function tkort_DevFileReadLineDumb alias "fb_DevFileReadLineDumb" _
	( byval fp as FILE ptr, byval dst as FBSTRING ptr, byval pfnReadString as FnDevReadString ) as long

	dim as long res = tkrt_ErrorSetNum( FB_RTERROR_OK )
	dim as uinteger buffer_len = any
	dim as long found = any, first_run = any
	dim as zstring * 512 buffer = any
	dim as FBSTRING src
	dim as ubyte ptr b = cast( ubyte ptr, @buffer )
	dim as integer tmp_buf_len = any
	dim as ubyte ch = any
	dim as zstring ptr got = any

	src.data = @buffer
	src.len = 0
	src.size = 0

	buffer_len = 512
	first_run = 1

	TKORT_IOLOCK()

	found = 0
	while( found = 0 )
		memset( @buffer, 0, buffer_len )

		if( pfnReadString = 0 ) then
			got = fgets( @buffer, 512, fp )
		else
			got = pfnReadString( @buffer, 512, fp )
		end if

		if( got = 0 ) then
			'' End of file is NOT an error here -- it is a distinct return
			'' the caller has to see, because LINE INPUT must stop.
			res = FB_RTERROR_ENDOFFILE
			if( first_run <> 0 ) then tkrt_StrDelete( dst )
			exit while
		end if

		'' The last byte is always the NUL fgets wrote.
		buffer_len = 512 - 1

		'' Backwards, per the header.
		do
			buffer_len -= 1
			ch = b[buffer_len]
			if( (ch = 13) orelse (ch = 10) ) then
				found = 1
				exit do
			elseif( ch <> 0 ) then
				'' A real character at the end: the buffer filled before a
				'' newline arrived.
				exit do
			end if
		loop while( buffer_len <> 0 )

		if( found = 0 ) then
			buffer_len += 1
			tmp_buf_len = buffer_len
		else
			tmp_buf_len = buffer_len + 1
			if( (b[buffer_len] = 10) andalso (buffer_len <> 0) ) then
				if( b[buffer_len - 1] = 13 ) then buffer_len -= 1
			end if
			b[buffer_len] = 0
		end if

		src.size = buffer_len
		src.len = buffer_len

		if( first_run <> 0 ) then
			tkrt_StrAssign( dst, -1, @src, -1, 0 )
		else
			tkrt_StrConcatAssign( dst, -1, @src, -1, 0 )
		end if

		first_run = 0
		buffer_len = tmp_buf_len
	wend

	TKORT_IOUNLOCK()

	return res
end function

function tkort_DevFileReadLine alias "fb_DevFileReadLine" _
	( byval h as FB_FILE ptr, byval dst as FBSTRING ptr ) as long

	TKORT_IOLOCK()
	dim as FILE ptr fp = hReadStream( h )
	if( fp = 0 ) then
		TKORT_IOUNLOCK()
		return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end if
	dim as long res = tkort_DevFileReadLineDumb( fp, dst, 0 )
	TKORT_IOUNLOCK()
	return res
end function

'' THE TEMPORARY IS DELETED ON EVERY PATH, and the assignment happens for END OF
'' FILE too -- the last unterminated line still has to reach the caller.
function tkort_DevFileReadLineWstr alias "fb_DevFileReadLineWstr" _
	( byval h as FB_FILE ptr, byval dst as wstring ptr, byval dst_chars as integer ) as long

	dim as FBSTRING temp

	TKORT_IOLOCK()

	dim as FILE ptr fp = hReadStream( h )
	if( fp = 0 ) then
		TKORT_IOUNLOCK()
		return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end if

	temp.data = 0
	temp.len = 0
	temp.size = 0

	dim as long res = tkort_DevFileReadLineDumb( fp, @temp, 0 )

	if( (res = FB_RTERROR_OK) orelse (res = FB_RTERROR_ENDOFFILE) ) then
		tkrt_WstrAssignFromA( dst, dst_chars, @temp, -1 )
	end if

	tkrt_StrDelete( @temp )

	TKORT_IOUNLOCK()

	return res
end function

end extern
