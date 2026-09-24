'' devfileencod.bas -- the ENCODING file device: UTF-8, UTF-16 and UTF-32 files.
'' Ten symbols across eight fbc members.
''
'' THE BOM IS THE WHOLE PROTOCOL. An ENCODING file carries a byte order mark and
'' nothing else marks it, so OPEN FOR INPUT reads three or two or four bytes and
'' FAILS WITH ERROR 3 if they are not the mark it expected. That is why opening
'' an ASCII file with ENCODING "utf8" is an I/O error rather than a file of
'' mojibake -- and why fb_FileOpenEncod routes ASCII to the PLAIN device, which
'' has no BOM step at all.
''
'' APPEND OPENS FOR READING FIRST, AND THAT IS NOT AN OVERSIGHT. The BOM has to
'' be checked before appending, and a stream opened "ab" cannot be read -- so the
'' file is opened "rb", the mark is verified, and only then is it freopen'd "ab".
'' If the file did not exist, the whole thing degrades to OUTPUT and a fresh mark
'' is written. An APPEND that skipped the check would happily add UTF-8 to a
'' UTF-16 file.
''
'' ONLY LITTLE-ENDIAN IS SUPPORTED, and fbc says so in its own source. The BOM
'' comparisons are against the little-endian byte orders; a big-endian file reads
'' as a bad mark, i.e. error 3.
''
'' THE BOM IS READ INTO A FOUR-BYTE INTEGER THAT IS ONLY PARTLY FILLED. fbc reads
'' 3 bytes for UTF-8 into an `int bom = 0` and compares against 0x00BFBBEF, so the
'' top byte is whatever the initialiser left -- zero. Reproduced by zeroing the
'' whole word first and reading into its low bytes, because the comparison
'' depends on it.
''
'' READS DECODE ONE CODE POINT AT A TIME AND SUBSTITUTE '?' WHEN IT DOES NOT FIT.
'' To a narrow string every code point above 255 becomes '?'; to a wstring the
'' answer depends on the target, because FB_WCHAR is TWO BYTES ON WINDOWS AND
'' FOUR ON LINUX. That is the single biggest divergence in this file: the same
'' UTF-8 source produces surrogate PAIRS on Windows and single units on Linux,
'' and a version that reinterpreted rather than re-encoded would be accidentally
'' right on Windows and wrong on Linux.
''
'' LINE INPUT DOES NOT USE THE READ HOOKS. It goes one character at a time
'' through fb_FileGetDataEx, which is what handles the decoding AND the put-back
'' buffer -- so a CR not followed by LF is pushed back rather than consumed.
'' Reading a line through fb_hFileRead_UTFToChar instead would lose that byte.

#include once "inc/descriptors.bi"
#include once "inc/file.bi"
#include once "inc/iolock.bi"
#include once "inc/rterror.bi"
#include once "inc/sysbind.bi"

const FB_FILE_ACCESS_ANY       = 0
const FB_FILE_ACCESS_READWRITE = 3

'' fb_unicode.h, verbatim.
const UTF16_MAX_BMP        = &h0000FFFFu
const UTF16_SUR_HIGH_START = &hD800u
const UTF16_SUR_HIGH_END   = &hDBFFu
const UTF16_SUR_LOW_START  = &hDC00u
const UTF16_HALFSHIFT      = 10
const UTF16_HALFBASE       = &h00010000u
const UTF16_HALFMASK       = &h000003FFu

'' '?', the substitution for anything that will not fit the destination width.
const SUBST = 63

const STAGE = 1024

type TKORT_UTF8_TRAILING
	as byte v( 0 to 255 )
end type
type TKORT_UTF8_OFFSETS
	as ulong v( 0 to 5 )
end type

extern "rtlib"
	declare function tkrt_ErrorSetNum alias "fb_ErrorSetNum" ( byval e as long ) as long
	declare sub tkrt_StrDelete alias "fb_StrDelete" ( byval s as FBSTRING ptr )
	declare function tkrt_StrConcatAssign alias "fb_StrConcatAssign" _
		( byval dst as any ptr, byval dst_size as integer, _
		  byval src as any ptr, byval src_size as integer, byval fillrem as long ) as any ptr
	declare function tkrt_WstrConcatAssign alias "fb_WstrConcatAssign" _
		( byval dst as wstring ptr, byval dst_chars as integer, byval src as wstring ptr ) as wstring ptr
end extern

extern "c"   '' NON-FBCALL: the tables are DATA, and the rest are h-prefixed
             '' internals or *Ex forms -- all undecorated in fbc's win32 archive.
	extern __fb_utf8_trailingTb alias "__fb_utf8_trailingTb" as TKORT_UTF8_TRAILING
	extern __fb_utf8_offsetsTb alias "__fb_utf8_offsetsTb" as TKORT_UTF8_OFFSETS

	declare sub tkrt_ConvertPath alias "fb_hConvertPath" ( byval p as zstring ptr )
	declare sub tkrt_SetFileBufSize alias "fb_hSetFileBufSize" ( byval fp as FILE ptr )
	declare function tkrt_DevFileGetSize alias "fb_DevFileGetSize" _
		( byval fp as FILE ptr, byval m as long, byval e as long, byval b as long ) as longint

	'' The eight hooks this device shares with the plain FILE* one -- seek,
	'' tell, close, eof, lock, unlock and flush are identical, because the
	'' encoding lives in the READ and WRITE paths and nowhere else.
	declare function tkrt_DevFileEof alias "fb_DevFileEof" ( byval h as FB_FILE ptr ) as long
	declare function tkrt_DevFileClose alias "fb_DevFileClose" ( byval h as FB_FILE ptr ) as long
	declare function tkrt_DevFileSeek alias "fb_DevFileSeek" _
		( byval h as FB_FILE ptr, byval o as longint, byval w as long ) as long
	declare function tkrt_DevFileTell alias "fb_DevFileTell" _
		( byval h as FB_FILE ptr, byval p as longint ptr ) as long
	declare function tkrt_DevFileLock alias "fb_DevFileLock" _
		( byval h as FB_FILE ptr, byval p as longint, byval s as longint ) as long
	declare function tkrt_DevFileUnlock alias "fb_DevFileUnlock" _
		( byval h as FB_FILE ptr, byval p as longint, byval s as longint ) as long
	declare function tkrt_DevFileFlush alias "fb_DevFileFlush" ( byval h as FB_FILE ptr ) as long

	declare function tkrt_CharToUTF alias "fb_CharToUTF" _
		( byval encod as long, byval src as ubyte ptr, byval chars as integer, _
		  byval dst as ubyte ptr, byval bytes_ as integer ptr ) as ubyte ptr
	declare function tkrt_WCharToUTF alias "fb_WCharToUTF" _
		( byval encod as long, byval src as wstring ptr, byval chars as integer, _
		  byval dst as ubyte ptr, byval bytes_ as integer ptr ) as ubyte ptr

	declare function tkrt_GetDataEx alias "fb_FileGetDataEx" _
		( byval h as FB_FILE ptr, byval pos_ as longint, byval dst as any ptr, _
		  byval length as uinteger, byval bytesread as uinteger ptr, _
		  byval adjust as long, byval is_uni as long ) as long
	declare function tkrt_PutBackEx alias "fb_FilePutBackEx" _
		( byval h as FB_FILE ptr, byval src as any ptr, byval chars as uinteger ) as long
end extern

'' Every name below is plain cdecl, forward declarations included -- see
'' devfile.bas's header for why the declarations have to be inside the block.
extern "c"   '' NON-FBCALL: fb_device.h declares these without FBCALL; they are
             '' reached through FB_FILE_HOOKS.

declare function tkort_DevFileOpenEncod alias "fb_DevFileOpenEncod" _
	( byval h as FB_FILE ptr, byval filename as zstring ptr, byval fname_len as uinteger ) as long
declare function tkort_DevFileReadEncod alias "fb_DevFileReadEncod" _
	( byval h as FB_FILE ptr, byval dst as any ptr, byval max_chars as uinteger ptr ) as long
declare function tkort_DevFileReadEncodWstr alias "fb_DevFileReadEncodWstr" _
	( byval h as FB_FILE ptr, byval dst as wstring ptr, byval max_chars as uinteger ptr ) as long
declare function tkort_DevFileReadLineEncod alias "fb_DevFileReadLineEncod" _
	( byval h as FB_FILE ptr, byval dst as FBSTRING ptr ) as long
declare function tkort_DevFileReadLineEncodWstr alias "fb_DevFileReadLineEncodWstr" _
	( byval h as FB_FILE ptr, byval dst as wstring ptr, byval max_chars as integer ) as long
declare function tkort_DevFileWriteEncod alias "fb_DevFileWriteEncod" _
	( byval h as FB_FILE ptr, byval buffer as any ptr, byval chars as uinteger ) as long
declare function tkort_DevFileWriteEncodWstr alias "fb_DevFileWriteEncodWstr" _
	( byval h as FB_FILE ptr, byval buffer as wstring ptr, byval chars as uinteger ) as long
declare function tkort_ReadUTFToChar alias "fb_hFileRead_UTFToChar" _
	( byval fp as FILE ptr, byval encod as long, byval dst as ubyte ptr, byval max_chars as integer ) as integer
declare function tkort_ReadUTFToWchar alias "fb_hFileRead_UTFToWchar" _
	( byval fp as FILE ptr, byval encod as long, byval dst as wstring ptr, byval max_chars as integer ) as integer

end extern

'' SEVEN OF THE FOURTEEN SLOTS ARE THE PLAIN DEVICE'S. Only the four reads and
'' the two writes differ; pfnSetWidth is NULL here for the same reason it is
'' there.
dim shared as FB_FILE_HOOKS hooks_dev_file_encod = ( _
	@tkrt_DevFileEof, _
	@tkrt_DevFileClose, _
	@tkrt_DevFileSeek, _
	@tkrt_DevFileTell, _
	@tkort_DevFileReadEncod, _
	@tkort_DevFileReadEncodWstr, _
	@tkort_DevFileWriteEncod, _
	@tkort_DevFileWriteEncodWstr, _
	@tkrt_DevFileLock, _
	@tkrt_DevFileUnlock, _
	@tkort_DevFileReadLineEncod, _
	@tkort_DevFileReadLineEncodWstr, _
	0, _
	@tkrt_DevFileFlush )

'' ------------------------------------------------------------------ the BOM

'' READ INTO A ZEROED WORD, LOW BYTES FIRST. The comparison is against a value
'' whose high byte is zero for the three-byte UTF-8 mark, so the word must be
'' cleared before the partial read -- see the file header.
private function hCheckBOM( byval fp as FILE ptr, byval encod as long ) as long
	dim as ulong bom = 0

	select case encod
	case FB_FILE_ENCOD_UTF8
		if( fread( @bom, 3, 1, fp ) <> 1 ) then return 0
		return iif( bom = &h00BFBBEFu, 1, 0 )

	case FB_FILE_ENCOD_UTF16
		if( fread( @bom, 2, 1, fp ) <> 1 ) then return 0
		return iif( bom = &h0000FEFFu, 1, 0 )

	case FB_FILE_ENCOD_UTF32
		if( fread( @bom, 4, 1, fp ) <> 1 ) then return 0
		return iif( bom = &h0000FEFFu, 1, 0 )
	end select

	return 0
end function

private function hWriteBOM( byval fp as FILE ptr, byval encod as long ) as long
	dim as ulong bom = any

	select case encod
	case FB_FILE_ENCOD_UTF8
		bom = &h00BFBBEFu
		if( fwrite( @bom, 3, 1, fp ) <> 1 ) then return 0

	case FB_FILE_ENCOD_UTF16
		bom = &h0000FEFFu
		if( fwrite( @bom, 2, 1, fp ) <> 1 ) then return 0

	case FB_FILE_ENCOD_UTF32
		bom = &h0000FEFFu
		if( fwrite( @bom, 4, 1, fp ) <> 1 ) then return 0

	case else
		'' ASCII has no mark, and reaching here means the handle was routed to
		'' the wrong device -- an error, not a silent success.
		return 0
	end select

	return 1
end function

'' ------------------------------------------------------------------ decoding

'' The UTF-8 accumulator, shared by the three decoders that read UTF-8. Reads one
'' lead byte, looks up how many continuation bytes follow, reads them in ONE
'' call, then folds six bits at a time and subtracts the offset that undoes the
'' lead-byte marker bits. Returns -1 at end of input.
private function hDecodeUTF8( byval fp as FILE ptr ) as long

	dim as ubyte c(0 to 6) = any
	dim as ulong wc = 0
	dim as integer extbytes = any, i = any

	if( fread( @c(0), 1, 1, fp ) <> 1 ) then return -1

	extbytes = __fb_utf8_trailingTb.v( c(0) )

	if( extbytes > 0 ) then
		if( fread( @c(1), extbytes, 1, fp ) <> 1 ) then return -1
	end if

	'' The C is a fall-through switch on extbytes; the loop is the same
	'' arithmetic, and the trailing shift-per-byte-except-the-last is what the
	'' fall-through produces.
	for i = 0 to extbytes
		wc += c(i)
		if( i < extbytes ) then wc shl= 6
	next

	wc -= __fb_utf8_offsetsTb.v( extbytes )

	return cast( long, wc )
end function

extern "c"   '' NON-FBCALL, as declared above.

'' ANYTHING ABOVE 255 BECOMES '?'. A narrow destination has one byte per
'' character, so there is no other answer -- and a UTF-16 surrogate pair is read
'' as two units and yields ONE '?', not two.
function tkort_ReadUTFToChar alias "fb_hFileRead_UTFToChar" _
	( byval fp as FILE ptr, byval encod as long, byval dst as ubyte ptr, byval max_chars as integer ) as integer

	dim as integer chars = max_chars
	dim as long wc = any
	dim as ushort c16 = any
	dim as ulong c32 = any
	dim as ubyte ptr d = dst

	select case encod
	case FB_FILE_ENCOD_UTF8
		while( chars > 0 )
			wc = hDecodeUTF8( fp )
			if( wc < 0 ) then exit while
			if( cast( ulong, wc ) > 255 ) then wc = SUBST
			*d = cast( ubyte, wc )
			d += 1
			chars -= 1
		wend

	case FB_FILE_ENCOD_UTF16
		while( chars > 0 )
			if( fread( @c16, 2, 1, fp ) <> 1 ) then exit while
			if( c16 > 255 ) then
				'' A high surrogate consumes its partner as well, so the pair
				'' collapses to a single '?'.
				if( (c16 >= UTF16_SUR_HIGH_START) andalso (c16 <= UTF16_SUR_HIGH_END) ) then
					if( fread( @c16, 2, 1, fp ) <> 1 ) then exit while
				end if
				c16 = SUBST
			end if
			*d = cast( ubyte, c16 )
			d += 1
			chars -= 1
		wend

	case FB_FILE_ENCOD_UTF32
		while( chars > 0 )
			if( fread( @c32, 4, 1, fp ) <> 1 ) then exit while
			if( c32 > 255 ) then c32 = SUBST
			*d = cast( ubyte, c32 )
			d += 1
			chars -= 1
		wend

	case else
		return 0
	end select

	return max_chars - chars
end function

'' THE DESTINATION WIDTH DECIDES EVERYTHING HERE, and it is TWO BYTES ON WINDOWS
'' AND FOUR ON LINUX. fbc writes this as a switch on sizeof(FB_WCHAR) that the C
'' compiler folds; the #if below folds it at compile time for the same reason,
'' and keeps the two shapes visibly separate rather than hiding a width
'' assumption inside a cast.
function tkort_ReadUTFToWchar alias "fb_hFileRead_UTFToWchar" _
	( byval fp as FILE ptr, byval encod as long, byval dst as wstring ptr, byval max_chars as integer ) as integer

	dim as integer chars = max_chars
	dim as long wc = any
	dim as ulong c = any, c2 = any

	#if sizeof( wstring ) = 2
		dim as ushort ptr d = cast( ushort ptr, dst )
	#else
		dim as ulong ptr d = cast( ulong ptr, dst )
	#endif

	select case encod
	case FB_FILE_ENCOD_UTF8
		while( chars > 0 )
			wc = hDecodeUTF8( fp )
			if( wc < 0 ) then exit while
			c = cast( ulong, wc )
			#if sizeof( wstring ) = 2
				if( c <= UTF16_MAX_BMP ) then
					*d = cast( ushort, c )
					d += 1
				else
					'' A pair needs TWO slots, and if only one is left the
					'' character is DROPPED rather than half-written -- which
					'' is what fbc does, and why the count can come back short
					'' of max_chars without end of file.
					if( chars > 1 ) then
						c -= UTF16_HALFBASE
						*d = cast( ushort, (c shr UTF16_HALFSHIFT) + UTF16_SUR_HIGH_START )
						d += 1
						*d = cast( ushort, (c and UTF16_HALFMASK) + UTF16_SUR_LOW_START )
						d += 1
						chars -= 1
					end if
				end if
			#else
				*d = c
				d += 1
			#endif
			chars -= 1
		wend

	case FB_FILE_ENCOD_UTF16
		#if sizeof( wstring ) = 2
			'' Same width: a straight block read, and the count is fread's.
			return fread( dst, 2, max_chars, fp )
		#else
			while( chars > 0 )
				if( fread( @c, 2, 1, fp ) <> 1 ) then exit while
				c and= &h0000FFFFu
				if( (c >= UTF16_SUR_HIGH_START) andalso (c <= UTF16_SUR_HIGH_END) ) then
					if( fread( @c2, 2, 1, fp ) <> 1 ) then exit while
					c2 and= &h0000FFFFu
					c = ((c - UTF16_SUR_HIGH_START) shl UTF16_HALFSHIFT) + _
					    (c2 - UTF16_SUR_LOW_START) + UTF16_HALFBASE
				end if
				*d = c
				d += 1
				chars -= 1
			wend
		#endif

	case FB_FILE_ENCOD_UTF32
		#if sizeof( wstring ) = 2
			while( chars > 0 )
				if( fread( @c, 4, 1, fp ) <> 1 ) then exit while
				if( c > UTF16_MAX_BMP ) then
					c -= UTF16_HALFBASE
					if( chars > 1 ) then
						*d = cast( ushort, (c shr UTF16_HALFSHIFT) + UTF16_SUR_HIGH_START )
						d += 1
						chars -= 1
					end if
					c = (c and UTF16_HALFMASK) + UTF16_SUR_LOW_START
				end if
				*d = cast( ushort, c )
				d += 1
				chars -= 1
			wend
		#else
			return fread( dst, 4, max_chars, fp )
		#endif

	case else
		return 0
	end select

	return max_chars - chars
end function

'' ------------------------------------------------------------------ open

function tkort_DevFileOpenEncod alias "fb_DevFileOpenEncod" _
	( byval h as FB_FILE ptr, byval filename as zstring ptr, byval fname_len as uinteger ) as long

	dim as FILE ptr fp = 0
	dim as zstring ptr openmask = 0
	dim as zstring * (STAGE) stage_ = any
	dim as zstring ptr fname = @stage_
	dim as any ptr heap_ = 0
	dim as long effective_mode = any

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

	tkrt_ConvertPath( fname )

	h->hooks = @hooks_dev_file_encod
	effective_mode = h->mode

	select case h->mode
	case FB_FILE_MODE_INPUT, FB_FILE_MODE_APPEND
		'' READ FIRST EVEN FOR APPEND -- the mark cannot be checked on an "ab"
		'' stream. See the file header.
		openmask = @"rb"
	case FB_FILE_MODE_OUTPUT
		openmask = @"wb"
	case else
		'' BINARY and RANDOM have no encoding: PUT# would emit raw bytes into a
		'' text file.
		if( heap_ <> 0 ) then free( heap_ )
		TKORT_IOUNLOCK()
		return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end select

	fp = fopen( fname, openmask )

	if( h->mode = FB_FILE_MODE_APPEND ) then
		if( fp = 0 ) then
			'' No such file: APPEND becomes OUTPUT and a fresh mark is written
			'' below.
			effective_mode = FB_FILE_MODE_OUTPUT
			openmask = @"ab"
			fp = fopen( fname, openmask )
		else
			tkrt_SetFileBufSize( fp )
			if( hCheckBOM( fp, h->encod ) = 0 ) then
				fclose( fp )
				if( heap_ <> 0 ) then free( heap_ )
				TKORT_IOUNLOCK()
				return tkrt_ErrorSetNum( FB_RTERROR_FILEIO )
			else
				openmask = @"ab"
				fp = freopen( fname, openmask, fp )
			end if
		end if
	end if

	if( fp = 0 ) then
		if( heap_ <> 0 ) then free( heap_ )
		TKORT_IOUNLOCK()
		return tkrt_ErrorSetNum( FB_RTERROR_FILENOTFOUND )
	end if

	tkrt_SetFileBufSize( fp )

	h->opaque = fp

	if( h->access = FB_FILE_ACCESS_ANY ) then h->access = FB_FILE_ACCESS_READWRITE

	select case effective_mode
	case FB_FILE_MODE_INPUT
		if( hCheckBOM( fp, h->encod ) = 0 ) then
			fclose( fp )
			if( heap_ <> 0 ) then free( heap_ )
			TKORT_IOUNLOCK()
			return tkrt_ErrorSetNum( FB_RTERROR_FILEIO )
		end if

	case FB_FILE_MODE_OUTPUT
		'' ERROR 2 ON A FAILED BOM WRITE, not 3 -- fbc's choice, and the
		'' distinction is visible to a program that tests ERR.
		if( hWriteBOM( fp, h->encod ) = 0 ) then
			fclose( fp )
			if( heap_ <> 0 ) then free( heap_ )
			TKORT_IOUNLOCK()
			return tkrt_ErrorSetNum( FB_RTERROR_FILENOTFOUND )
		end if
	end select

	'' Measured with seek_back TRUE, so the stream ends up past the mark rather
	'' than at byte zero.
	h->size = tkrt_DevFileGetSize( fp, h->mode, h->encod, 1 )
	if( h->size = -1 ) then
		fclose( fp )
		if( heap_ <> 0 ) then free( heap_ )
		TKORT_IOUNLOCK()
		return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end if

	if( heap_ <> 0 ) then free( heap_ )

	TKORT_IOUNLOCK()

	return tkrt_ErrorSetNum( FB_RTERROR_OK )
end function

'' ------------------------------------------------------------------ read

private function hReadStream( byval h as FB_FILE ptr ) as FILE ptr
	dim as FILE ptr fp = cast( FILE ptr, h->opaque )
	if( (fp = stdout) orelse (fp = stderr) ) then return stdin
	return fp
end function

function tkort_DevFileReadEncod alias "fb_DevFileReadEncod" _
	( byval h as FB_FILE ptr, byval dst as any ptr, byval max_chars as uinteger ptr ) as long

	TKORT_IOLOCK()

	dim as uinteger want = *max_chars
	dim as FILE ptr fp = hReadStream( h )
	if( fp = 0 ) then
		TKORT_IOUNLOCK()
		return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end if

	dim as uinteger chars = tkort_ReadUTFToChar( fp, h->encod, cast( ubyte ptr, dst ), want )

	if( chars <> want ) then
		memset( cast( ubyte ptr, dst ) + chars, 0, want - chars )
	end if

	*max_chars = chars

	TKORT_IOUNLOCK()
	return tkrt_ErrorSetNum( FB_RTERROR_OK )
end function

function tkort_DevFileReadEncodWstr alias "fb_DevFileReadEncodWstr" _
	( byval h as FB_FILE ptr, byval dst as wstring ptr, byval max_chars as uinteger ptr ) as long

	TKORT_IOLOCK()

	dim as uinteger want = *max_chars
	dim as FILE ptr fp = hReadStream( h )
	if( fp = 0 ) then
		TKORT_IOUNLOCK()
		return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end if

	dim as uinteger chars = tkort_ReadUTFToWchar( fp, h->encod, dst, want )

	'' The fill is in CHARACTERS times the wchar width, which differs per
	'' target -- a byte count here would zero a quarter of the tail on Linux.
	if( chars <> want ) then
		memset( cast( ubyte ptr, dst ) + chars * sizeof( wstring ), 0, _
		        (want - chars) * sizeof( wstring ) )
	end if

	*max_chars = chars

	TKORT_IOUNLOCK()
	return tkrt_ErrorSetNum( FB_RTERROR_OK )
end function

'' ------------------------------------------------------------------ line input

'' ONE CHARACTER AT A TIME THROUGH fb_FileGetDataEx, which does the decoding and
'' owns the put-back buffer. A CR is followed by a peek: if the next character is
'' not LF it is PUSHED BACK, so a lone CR terminates the line without eating the
'' character after it.
function tkort_DevFileReadLineEncod alias "fb_DevFileReadLineEncod" _
	( byval h as FB_FILE ptr, byval dst as FBSTRING ptr ) as long

	dim as long res = FB_RTERROR_OK

	TKORT_IOLOCK()

	dim as FILE ptr fp = hReadStream( h )
	if( fp = 0 ) then
		TKORT_IOUNLOCK()
		return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end if

	'' Cleared first: everything below is concat-assign.
	tkrt_StrDelete( dst )

	dim as zstring * 2 c = any
	dim as uinteger length_ = any

	do
		res = tkrt_GetDataEx( h, 0, @c, 1, @length_, 0, 0 )
		if( (res <> FB_RTERROR_OK) orelse (length_ = 0) ) then exit do

		if( c[0] = 13 ) then
			res = tkrt_GetDataEx( h, 0, @c, 1, @length_, 0, 0 )
			if( (res <> FB_RTERROR_OK) orelse (length_ = 0) ) then exit do
			if( c[0] <> 10 ) then tkrt_PutBackEx( h, @c, 1 )
			exit do
		end if

		if( c[0] = 10 ) then exit do

		c[1] = 0
		tkrt_StrConcatAssign( dst, -1, @c, 1, FB_FALSE )
	loop

	TKORT_IOUNLOCK()

	return res
end function

'' THE LENGTH PASSED TO fb_FileGetDataEx IS IN WCHARS, NOT BYTES, because
'' is_unicode is TRUE -- passing a byte count would read half a character on
'' Windows and a quarter on Linux.
function tkort_DevFileReadLineEncodWstr alias "fb_DevFileReadLineEncodWstr" _
	( byval h as FB_FILE ptr, byval dst as wstring ptr, byval max_chars as integer ) as long

	dim as long res = FB_RTERROR_OK

	TKORT_IOLOCK()

	dim as FILE ptr fp = hReadStream( h )
	if( fp = 0 ) then
		TKORT_IOUNLOCK()
		return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end if

	dst[0] = 0

	dim as wstring * 2 c = any
	dim as uinteger length_ = any

	do
		res = tkrt_GetDataEx( h, 0, @c, 1, @length_, 0, 1 )
		if( (res <> FB_RTERROR_OK) orelse (length_ = 0) ) then exit do

		if( c[0] = 13 ) then
			res = tkrt_GetDataEx( h, 0, @c, 1, @length_, 0, 1 )
			if( (res <> FB_RTERROR_OK) orelse (length_ = 0) ) then exit do
			if( c[0] <> 10 ) then tkrt_PutBackEx( h, @c, 1 )
			exit do
		end if

		if( c[0] = 10 ) then exit do

		c[1] = 0
		tkrt_WstrConcatAssign( dst, max_chars, @c )
	loop

	TKORT_IOUNLOCK()

	return res
end function

'' ------------------------------------------------------------------ write

'' THE CONVERTED BUFFER IS FREED ONLY IF IT IS NOT THE SOURCE. fb_CharToUTF may
'' return its input unchanged when no conversion was needed, and freeing that
'' would free the caller's memory.
function tkort_DevFileWriteEncod alias "fb_DevFileWriteEncod" _
	( byval h as FB_FILE ptr, byval buffer as any ptr, byval chars as uinteger ) as long

	TKORT_IOLOCK()

	dim as FILE ptr fp = cast( FILE ptr, h->opaque )
	if( fp = 0 ) then
		TKORT_IOUNLOCK()
		return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end if

	dim as integer bytes_ = any
	dim as ubyte ptr encod_buffer = tkrt_CharToUTF( h->encod, cast( ubyte ptr, buffer ), _
	                                                chars, 0, @bytes_ )

	if( encod_buffer <> 0 ) then
		if( fwrite( encod_buffer, 1, bytes_, fp ) <> bytes_ ) then
			'' NOT FREED ON THIS PATH -- fbc returns without releasing the
			'' buffer, and the leak is reproduced rather than fixed, because
			'' fixing it here would make allocation-count parity fail.
			TKORT_IOUNLOCK()
			return tkrt_ErrorSetNum( FB_RTERROR_FILEIO )
		end if

		if( encod_buffer <> cast( ubyte ptr, buffer ) ) then free( encod_buffer )
	end if

	TKORT_IOUNLOCK()
	return tkrt_ErrorSetNum( FB_RTERROR_OK )
end function

function tkort_DevFileWriteEncodWstr alias "fb_DevFileWriteEncodWstr" _
	( byval h as FB_FILE ptr, byval buffer as wstring ptr, byval chars as uinteger ) as long

	TKORT_IOLOCK()

	dim as FILE ptr fp = cast( FILE ptr, h->opaque )
	if( fp = 0 ) then
		TKORT_IOUNLOCK()
		return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end if

	dim as integer bytes_ = any
	dim as ubyte ptr encod_buffer = tkrt_WCharToUTF( h->encod, buffer, chars, 0, @bytes_ )

	if( encod_buffer <> 0 ) then
		if( fwrite( encod_buffer, 1, bytes_, fp ) <> bytes_ ) then
			TKORT_IOUNLOCK()
			return tkrt_ErrorSetNum( FB_RTERROR_FILEIO )
		end if

		if( encod_buffer <> cast( ubyte ptr, buffer ) ) then free( encod_buffer )
	end if

	TKORT_IOUNLOCK()
	return tkrt_ErrorSetNum( FB_RTERROR_OK )
end function

end extern
