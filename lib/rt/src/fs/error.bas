'' error.bas -- the native error mapping: two entry points over one fbc
'' member, split by platform.
''
'' THE ONLY PLACE A NATIVE ERROR IS INTERPRETED. fb_FsOsError keeps the raw
'' value regardless, so nothing here loses information -- a caller that needs
'' the exact GetLastError or errno can still have it.
''
'' THE TABLE DOES NOT GUESS. Windows returns ERROR_ACCESS_DENIED for a wide
'' range of unrelated causes, including deleting a read-only file and opening a
'' directory as a file; it maps to ACCESS_DENIED and leaves the OS code intact.
'' Where a specific operation knows better -- RemoveFile on a file whose
'' read-only attribute is set -- that operation checks the attribute itself and
'' reports READ_ONLY. The same rule is why EEXIST maps to ALREADY_EXISTS here
'' while RemoveDir re-maps it to DIR_NOT_EMPTY.
''
'' EINTR IS MAPPED, NOT RETRIED. Retrying is the caller's decision, and a
'' library that hides EINTR also hides a signal the program may care about.
''
'' TWO CODES HAVE NO WINDOWS SOURCE: IS_A_DIRECTORY is synthesised higher up by
'' checking the kind before opening, and INTERRUPTED cannot occur there at all.

#include once "inc/descriptors.bi"
#include once "inc/fserror.bi"

#if defined( __FB_WIN32__ ) or defined( __FB_WIN64__ )

'' PREFIXED TKW_ because several of these names are already defined by a
'' header reached through the includes, and a second CONST is an error rather
'' than a compatible redefinition. The values are the Win32 ones.
const TKW_ERROR_FILE_NOT_FOUND        = 2
const TKW_ERROR_PATH_NOT_FOUND        = 3
const TKW_ERROR_ACCESS_DENIED        = 5
const TKW_ERROR_NOT_SAME_DEVICE       = 17
const TKW_ERROR_INVALID_FUNCTION      = 1
const TKW_ERROR_WRITE_PROTECT         = 19
const TKW_ERROR_SHARING_VIOLATION     = 32
const TKW_ERROR_LOCK_VIOLATION        = 33
const TKW_ERROR_HANDLE_DISK_FULL      = 39
const TKW_ERROR_NOT_SUPPORTED         = 50
const TKW_ERROR_BAD_NETPATH           = 53
const TKW_ERROR_BAD_NET_NAME          = 67
const TKW_ERROR_FILE_EXISTS           = 80
const TKW_ERROR_INVALID_NAME          = 123
const TKW_ERROR_DIR_NOT_EMPTY         = 145
const TKW_ERROR_ALREADY_EXISTS        = 183
const TKW_ERROR_FILENAME_EXCED_RANGE  = 206
const TKW_ERROR_DISK_FULL             = 112
const TKW_ERROR_INVALID_DRIVE         = 15
const TKW_ERROR_BAD_PATHNAME          = 161
const TKW_ERROR_BUFFER_OVERFLOW       = 111
const TKW_ERROR_DIRECTORY            = 267
const TKW_ERROR_PRIVILEGE_NOT_HELD    = 1314
const TKW_ERROR_CANT_RESOLVE_FILENAME = 1921
const TKW_ERROR_REPARSE_TAG_INVALID   = 4394
const TKW_ERROR_USER_MAPPED_FILE      = 1224
const TKW_NO_ERROR                   = 0

extern "c"   '' NON-FBCALL: a kernel32 import, not an rtlib entry point.
	declare function w_GetLastError stdcall alias "GetLastError" ( ) as ulong
end extern

extern "rtlib"

function tkort_FsOsError alias "fb_FsOsError" ( ) as long
	return cast( long, w_GetLastError( ) )
end function

function tkort_FsMapOsError alias "fb_FsMapOsError" ( ) as long
	select case cast( long, w_GetLastError( ) )
	case TKW_ERROR_FILE_NOT_FOUND, TKW_ERROR_PATH_NOT_FOUND, TKW_ERROR_INVALID_DRIVE, _
	     TKW_ERROR_BAD_NETPATH, TKW_ERROR_BAD_NET_NAME
		return FB_FS_NOT_FOUND

	'' See the header: this one covers many unrelated causes and is not
	'' refined here.
	case TKW_ERROR_ACCESS_DENIED, TKW_ERROR_PRIVILEGE_NOT_HELD
		return FB_FS_ACCESS_DENIED

	case TKW_ERROR_FILE_EXISTS, TKW_ERROR_ALREADY_EXISTS
		return FB_FS_ALREADY_EXISTS

	case TKW_ERROR_DIRECTORY
		return FB_FS_NOT_A_DIRECTORY

	case TKW_ERROR_DIR_NOT_EMPTY
		return FB_FS_DIR_NOT_EMPTY

	case TKW_ERROR_INVALID_NAME, TKW_ERROR_BAD_PATHNAME
		return FB_FS_INVALID_PATH

	case TKW_ERROR_FILENAME_EXCED_RANGE, TKW_ERROR_BUFFER_OVERFLOW
		return FB_FS_NAME_TOO_LONG

	case TKW_ERROR_CANT_RESOLVE_FILENAME, TKW_ERROR_REPARSE_TAG_INVALID
		return FB_FS_LOOP

	case TKW_ERROR_DISK_FULL, TKW_ERROR_HANDLE_DISK_FULL
		return FB_FS_NO_SPACE

	case TKW_ERROR_WRITE_PROTECT
		return FB_FS_READ_ONLY

	case TKW_ERROR_SHARING_VIOLATION, TKW_ERROR_LOCK_VIOLATION, TKW_ERROR_USER_MAPPED_FILE
		return FB_FS_IN_USE

	case TKW_ERROR_NOT_SAME_DEVICE
		return FB_FS_CROSS_DEVICE

	case TKW_ERROR_NOT_SUPPORTED, TKW_ERROR_INVALID_FUNCTION
		return FB_FS_UNSUPPORTED

	case TKW_NO_ERROR
		return FB_FS_OK
	end select

	return FB_FS_UNKNOWN
end function

end extern

#else

'' errno is a MACRO in C -- *__errno_location( ) on glibc -- not a variable, so
'' it is reached through the accessor rather than declared as data. Getting
'' that wrong reads a fixed address that is not this thread's errno.
extern "c"   '' NON-FBCALL: libc, not an rtlib entry point.
	declare function u_errno_location alias "__errno_location" ( ) as long ptr
end extern

const EPERM_ = 1, ENOENT_ = 2, EINTR_ = 4, EIO_ = 5
const EBADF_ = 9, EACCES_ = 13, EBUSY_ = 16, EEXIST_ = 17
const EXDEV_ = 18, ENOTDIR_ = 20, EISDIR_ = 21, EINVAL_ = 22
const EFBIG_ = 27, ENOSPC_ = 28, EROFS_ = 30, ENAMETOOLONG_ = 36
const ENOSYS_ = 38, ENOTEMPTY_ = 39, ELOOP_ = 40, EILSEQ_ = 84
const EOPNOTSUPP_ = 95, ETXTBSY_ = 26, EDQUOT_ = 122

extern "rtlib"

function tkort_FsOsError alias "fb_FsOsError" ( ) as long
	return *u_errno_location( )
end function

function tkort_FsMapOsError alias "fb_FsMapOsError" ( ) as long
	select case *u_errno_location( )
	case ENOENT_
		return FB_FS_NOT_FOUND

	case EACCES_, EPERM_
		return FB_FS_ACCESS_DENIED

	'' Right for every call but rmdir, which re-maps it itself.
	case EEXIST_
		return FB_FS_ALREADY_EXISTS

	case ENOTDIR_
		return FB_FS_NOT_A_DIRECTORY

	case EISDIR_
		return FB_FS_IS_A_DIRECTORY

	case ENOTEMPTY_
		return FB_FS_DIR_NOT_EMPTY

	case EINVAL_, EILSEQ_
		return FB_FS_INVALID_PATH

	case ENAMETOOLONG_
		return FB_FS_NAME_TOO_LONG

	case ELOOP_
		return FB_FS_LOOP

	case ENOSPC_, EFBIG_, EDQUOT_
		return FB_FS_NO_SPACE

	case EROFS_
		return FB_FS_READ_ONLY

	case EBUSY_, ETXTBSY_
		return FB_FS_IN_USE

	case EXDEV_
		return FB_FS_CROSS_DEVICE

	'' Mapped, not retried -- see the header.
	case EINTR_
		return FB_FS_INTERRUPTED

	case ENOSYS_, EOPNOTSUPP_
		return FB_FS_UNSUPPORTED

	case 0
		return FB_FS_OK
	end select

	return FB_FS_UNKNOWN
end function

end extern

#endif
