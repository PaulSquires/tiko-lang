'' filestr.bas -- PUT and GET for STRING destinations: eight entry points over
'' two fbc members.
''
'' Thin over the data path, with three differences that are all worth naming.
''
'' FB_STRSETUP_DYN, NOT _FIX. The two differ in one branch: DYN takes a fixed
'' ZSTRING's declared size less the terminator, while FIX walks it with strlen.
'' Here the destination is a BUFFER TO FILL, not text to read, so its declared
'' capacity is what matters and a strlen of uninitialised bytes would be
'' meaningless. RFC-0002 section 4 says the choice is per-entry-point and must
'' not be made by taste; this is one of the places it bites.
''
'' PUT WRITES NOTHING FOR AN EMPTY STRING AND CALLS THAT SUCCESS; GET REFUSES AN
'' EMPTY DESTINATION AND CALLS IT AN ERROR. Same test, opposite verdicts, because
'' writing nothing is meaningful and reading into nowhere is not.
''
'' GET NUL-TERMINATES what it read, at data[len] -- which is why the destination
'' must have been allocated with room for it, and why this cannot be pointed at
'' a bare fixed buffer of exactly the right size.
''
'' AND GET PASSES `len` BY REFERENCE AS BOTH THE REQUEST AND THE RESULT: it goes
'' in as the capacity and comes back as what was actually read, which is then
'' both the terminator's index and the caller's byte count.

#include once "inc/descriptors.bi"
#include once "inc/file.bi"

const FB_RTERROR_OK = 0
const FB_RTERROR_ILLEGALFUNCTIONCALL = 1

extern "rtlib"
	declare function tkrt_ErrorSetNum alias "fb_ErrorSetNum" ( byval e as long ) as long
	declare function tkrt_DelTemp alias "fb_hStrDelTemp" ( byval s as FBSTRING ptr ) as long
end extern

extern "c"   '' NON-FBCALL: the data-path *Ex forms.
	declare function tkrt_PutDataEx alias "fb_FilePutDataEx" _
		( byval h as FB_FILE ptr, byval pos_ as longint, byval data_ as any ptr, _
		  byval length as uinteger, byval adjust as long, byval chknl as long, _
		  byval is_uni as long ) as long
	declare function tkrt_GetDataEx alias "fb_FileGetDataEx" _
		( byval h as FB_FILE ptr, byval pos_ as longint, byval dst as any ptr, _
		  byval length as uinteger, byval bytesread as uinteger ptr, _
		  byval adjust as long, byval is_uni as long ) as long
end extern

extern "c"   '' NON-FBCALL: fb_file.h declares the *Ex forms plainly.

function tkort_FilePutStrEx alias "fb_FilePutStrEx" _
	( byval h as FB_FILE ptr, byval pos_ as longint, byval str_ as any ptr, _
	  byval str_len as integer ) as long

	dim as zstring ptr data_ = any
	dim as integer length = any
	FB_STRSETUP_DYN( str_, str_len, data_, length )

	dim as long res = any
	if( (data_ <> 0) andalso (length > 0) ) then
		'' checknewline TRUE: writing a string through PUT keeps PRINT's comma
		'' padding correct, which is the whole reason that flag exists.
		res = tkrt_PutDataEx( h, pos_, data_, length, -1, -1, 0 )
	else
		'' Nothing to write is SUCCESS.
		res = tkrt_ErrorSetNum( FB_RTERROR_OK )
	end if

	if( str_len = -1 ) then tkrt_DelTemp( cptr( FBSTRING ptr, str_ ) )

	return res

end function

function tkort_FileGetStrEx alias "fb_FileGetStrEx" _
	( byval h as FB_FILE ptr, byval pos_ as longint, byval str_ as any ptr, _
	  byval str_len as integer, byval bytesread as uinteger ptr ) as long

	if( bytesread <> 0 ) then *bytesread = 0

	if( TKORT_HANDLE_USED( h ) = 0 ) then
		return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end if

	dim as zstring ptr data_ = any
	dim as integer length = any
	FB_STRSETUP_DYN( str_, str_len, data_, length )

	dim as long res = any
	dim as uinteger got = length

	if( (data_ <> 0) andalso (length > 0) ) then
		res = tkrt_GetDataEx( h, pos_, data_, got, @got, -1, 0 )
		'' The terminator goes at what was ACTUALLY read, not at the capacity.
		data_[got] = 0
	else
		'' Nowhere to read into is an ERROR -- the opposite of PUT's verdict on
		'' the same condition.
		res = tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
		got = 0
	end if

	if( bytesread <> 0 ) then *bytesread = got

	'' Releasing a fix-len argument frees the temp DESCRIPTOR fbc built for it.
	if( str_len = -1 ) then tkrt_DelTemp( cptr( FBSTRING ptr, str_ ) )

	return res

end function

end extern

extern "rtlib"

function tkort_FilePutStr alias "fb_FilePutStr" _
	( byval fnum as long, byval pos_ as long, byval str_ as any ptr, _
	  byval str_len as integer ) as long
	return tkort_FilePutStrEx( TKORT_FILE_TO_HANDLE( fnum ), pos_, str_, str_len )
end function

function tkort_FilePutStrLarge alias "fb_FilePutStrLarge" _
	( byval fnum as long, byval pos_ as longint, byval str_ as any ptr, _
	  byval str_len as integer ) as long
	return tkort_FilePutStrEx( TKORT_FILE_TO_HANDLE( fnum ), pos_, str_, str_len )
end function

function tkort_FileGetStr alias "fb_FileGetStr" _
	( byval fnum as long, byval pos_ as long, byval str_ as any ptr, _
	  byval str_len as integer ) as long
	return tkort_FileGetStrEx( TKORT_FILE_TO_HANDLE( fnum ), pos_, str_, str_len, 0 )
end function

function tkort_FileGetStrLarge alias "fb_FileGetStrLarge" _
	( byval fnum as long, byval pos_ as longint, byval str_ as any ptr, _
	  byval str_len as integer ) as long
	return tkort_FileGetStrEx( TKORT_FILE_TO_HANDLE( fnum ), pos_, str_, str_len, 0 )
end function

function tkort_FileGetStrIOB alias "fb_FileGetStrIOB" _
	( byval fnum as long, byval pos_ as long, byval str_ as any ptr, _
	  byval str_len as integer, byval bytesread as uinteger ptr ) as long
	return tkort_FileGetStrEx( TKORT_FILE_TO_HANDLE( fnum ), pos_, str_, str_len, bytesread )
end function

function tkort_FileGetStrLargeIOB alias "fb_FileGetStrLargeIOB" _
	( byval fnum as long, byval pos_ as longint, byval str_ as any ptr, _
	  byval str_len as integer, byval bytesread as uinteger ptr ) as long
	return tkort_FileGetStrEx( TKORT_FILE_TO_HANDLE( fnum ), pos_, str_, str_len, bytesread )
end function

end extern
