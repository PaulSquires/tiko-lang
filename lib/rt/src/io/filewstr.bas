'' filewstr.bas -- PUT and GET for WSTRING destinations, and the ARRAY forms:
'' fourteen entry points over four fbc members.
''
'' THE WIDE GET IS NOT THE MIRROR OF THE WIDE PUT.
''
'' PUT is the narrow path with is_unicode set -- the device layer does the rest.
'' GET reads RAW BYTES into the wide buffer and terminates by hand, because EOF
'' can land on an ODD BYTE COUNT:
''
''     read ( dst_chars - 1 ) * sizeof( wchar ) bytes
''     round the byte count UP to a whole character
''     write the terminator at that character index
''
'' The round-up is what lets a file whose length is not a multiple of the
'' character width still produce a terminated wstring. Truncating instead would
'' drop the partial character AND put the terminator one place early.
''
'' A DEREFERENCED WSTRING PTR ARRIVES WITH dst_chars = 0, and the capacity is
'' then taken from the buffer's OWN CONTENTS plus one -- so GET on such a pointer
'' reads as many characters as the buffer already held. A real contract, and the
'' reason a freshly allocated wide buffer must be terminated before it is filled.
''
'' A ONE-CHARACTER BUFFER IS REJECTED: room for the terminator alone is not room
'' for data, and that is an error rather than a zero-length read.

#include once "inc/descriptors.bi"
#include once "inc/file.bi"
#include once "inc/wstr.bi"

const FB_RTERROR_OK = 0
const FB_RTERROR_ILLEGALFUNCTIONCALL = 1

extern "rtlib"
	declare function tkrt_ErrorSetNum alias "fb_ErrorSetNum" ( byval e as long ) as long
end extern

extern "c"   '' NON-FBCALL: the data-path forms.
	declare function tkrt_PutDataEx alias "fb_FilePutDataEx" _
		( byval h as FB_FILE ptr, byval pos_ as longint, byval data_ as any ptr, _
		  byval length as uinteger, byval adjust as long, byval chknl as long, _
		  byval is_uni as long ) as long
	declare function tkrt_GetDataEx alias "fb_FileGetDataEx" _
		( byval h as FB_FILE ptr, byval pos_ as longint, byval dst as any ptr, _
		  byval length as uinteger, byval bytesread as uinteger ptr, _
		  byval adjust as long, byval is_uni as long ) as long
	declare function tkrt_PutData alias "fb_FilePutData" _
		( byval fnum as long, byval pos_ as longint, byval data_ as any ptr, _
		  byval length as uinteger, byval adjust as long, byval chknl as long ) as long
end extern

extern "c"   '' NON-FBCALL: fb_file.h declares the *Ex forms plainly.

function tkort_FilePutWstrEx alias "fb_FilePutWstrEx" _
	( byval h as FB_FILE ptr, byval pos_ as longint, byval str_ as wstring ptr, _
	  byval length as integer ) as long
	if( (str_ <> 0) andalso (length > 0) ) then
		return tkrt_PutDataEx( h, pos_, str_, length, -1, -1, -1 )
	end if
	return tkrt_ErrorSetNum( FB_RTERROR_OK )
end function

function tkort_FileGetWstrEx alias "fb_FileGetWstrEx" _
	( byval h as FB_FILE ptr, byval pos_ as longint, byval dst as wstring ptr, _
	  byval dst_chars as integer, byval bytesread as uinteger ptr ) as long

	if( bytesread <> 0 ) then *bytesread = 0

	if( TKORT_HANDLE_USED( h ) = 0 ) then
		return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end if
	if( dst = 0 ) then return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	if( dst_chars < 0 ) then return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )

	if( dst_chars = 0 ) then dst_chars = FB_WSTR_LEN( dst ) + 1
	if( dst_chars < 2 ) then return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )

	dim as uinteger rawbytesread = any
	dim as long res = tkrt_GetDataEx( h, pos_, dst, _
	                                  (dst_chars - 1) * sizeof( wstring ), _
	                                  @rawbytesread, -1, 0 )
	if( res <> FB_RTERROR_OK ) then return res

	if( bytesread <> 0 ) then *bytesread = rawbytesread

	dim as integer extra = rawbytesread mod sizeof( wstring )
	if( extra > 0 ) then rawbytesread += sizeof( wstring ) - extra

	'' Terminate through a byte pointer, so the width is the target's and the
	'' wstring-index trap in inc/wstr.bi cannot apply.
	dim as ubyte ptr b = cptr( ubyte ptr, dst )
	for k as integer = 0 to sizeof( wstring ) - 1
		b[rawbytesread + k] = 0
	next

	return FB_RTERROR_OK

end function

end extern

extern "rtlib"

function tkort_FilePutWstr alias "fb_FilePutWstr" _
	( byval fnum as long, byval pos_ as long, byval str_ as wstring ptr, _
	  byval str_len as integer ) as long
	return tkort_FilePutWstrEx( TKORT_FILE_TO_HANDLE( fnum ), pos_, str_, str_len )
end function

function tkort_FilePutWstrLarge alias "fb_FilePutWstrLarge" _
	( byval fnum as long, byval pos_ as longint, byval str_ as wstring ptr, _
	  byval str_len as integer ) as long
	return tkort_FilePutWstrEx( TKORT_FILE_TO_HANDLE( fnum ), pos_, str_, str_len )
end function

function tkort_FileGetWstr alias "fb_FileGetWstr" _
	( byval fnum as long, byval pos_ as long, byval dst as wstring ptr, _
	  byval dst_chars as integer ) as long
	return tkort_FileGetWstrEx( TKORT_FILE_TO_HANDLE( fnum ), pos_, dst, dst_chars, 0 )
end function

function tkort_FileGetWstrLarge alias "fb_FileGetWstrLarge" _
	( byval fnum as long, byval pos_ as longint, byval dst as wstring ptr, _
	  byval dst_chars as integer ) as long
	return tkort_FileGetWstrEx( TKORT_FILE_TO_HANDLE( fnum ), pos_, dst, dst_chars, 0 )
end function

function tkort_FileGetWstrIOB alias "fb_FileGetWstrIOB" _
	( byval fnum as long, byval pos_ as long, byval dst as wstring ptr, _
	  byval dst_chars as integer, byval bytesread as uinteger ptr ) as long
	return tkort_FileGetWstrEx( TKORT_FILE_TO_HANDLE( fnum ), pos_, dst, dst_chars, bytesread )
end function

function tkort_FileGetWstrLargeIOB alias "fb_FileGetWstrLargeIOB" _
	( byval fnum as long, byval pos_ as longint, byval dst as wstring ptr, _
	  byval dst_chars as integer, byval bytesread as uinteger ptr ) as long
	return tkort_FileGetWstrEx( TKORT_FILE_TO_HANDLE( fnum ), pos_, dst, dst_chars, bytesread )
end function

'' ------------------------------------------------------------- the arrays
''
'' Straight through with the descriptor's own ptr and size, so element type and
'' dimensions are irrelevant -- an array is a byte range here.
''
'' NOTE GET USES THE HANDLE FORM AND PUT USES THE FILE-NUMBER FORM. That is fbc's
'' shape and costs PUT one extra table lookup; kept so the two match.

function tkort_FileGetArray alias "fb_FileGetArray" _
	( byval fnum as long, byval pos_ as long, byval dst as FBARRAY ptr ) as long
	return tkrt_GetDataEx( TKORT_FILE_TO_HANDLE( fnum ), pos_, dst->base_ptr, dst->size, 0, -1, 0 )
end function

function tkort_FileGetArrayLarge alias "fb_FileGetArrayLarge" _
	( byval fnum as long, byval pos_ as longint, byval dst as FBARRAY ptr ) as long
	return tkrt_GetDataEx( TKORT_FILE_TO_HANDLE( fnum ), pos_, dst->base_ptr, dst->size, 0, -1, 0 )
end function

function tkort_FileGetArrayIOB alias "fb_FileGetArrayIOB" _
	( byval fnum as long, byval pos_ as long, byval dst as FBARRAY ptr, _
	  byval bytesread as uinteger ptr ) as long
	return tkrt_GetDataEx( TKORT_FILE_TO_HANDLE( fnum ), pos_, dst->base_ptr, dst->size, _
	                       bytesread, -1, 0 )
end function

function tkort_FileGetArrayLargeIOB alias "fb_FileGetArrayLargeIOB" _
	( byval fnum as long, byval pos_ as longint, byval dst as FBARRAY ptr, _
	  byval bytesread as uinteger ptr ) as long
	return tkrt_GetDataEx( TKORT_FILE_TO_HANDLE( fnum ), pos_, dst->base_ptr, dst->size, _
	                       bytesread, -1, 0 )
end function

function tkort_FilePutArray alias "fb_FilePutArray" _
	( byval fnum as long, byval pos_ as long, byval src as FBARRAY ptr ) as long
	return tkrt_PutData( fnum, pos_, src->base_ptr, src->size, -1, 0 )
end function

function tkort_FilePutArrayLarge alias "fb_FilePutArrayLarge" _
	( byval fnum as long, byval pos_ as longint, byval src as FBARRAY ptr ) as long
	return tkrt_PutData( fnum, pos_, src->base_ptr, src->size, -1, 0 )
end function

end extern
