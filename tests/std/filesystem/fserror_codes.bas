'' fs.FsError -- C:\dev\docs\filesystem\RFC-0001-errors.md.
''
'' THE ENUM/CONSTANT CROSS-CHECK IS THE POINT OF THIS FILE. FsErrorCode in
'' inc/fb/fserror.bi and FB_FS_* in src/rtlib/fb_filesystem.h are two hand-kept
'' lists of the same sixteen codes, and a divergence between them would be total
'' and silent: every error in the module would report the wrong kind.
''
'' They are checked THROUGH fb_UStrFsErrorMessage, whose table in fs_errmsg.c is
'' indexed by the C constant. Asserting the FB enumerator against the message
'' text ties the two lists together without needing a third declaration of the
'' constants -- if the enum shifts by one, every message shifts with it and
'' every assertion below fails at once.
''
'' NOT VERIFIED HERE: that reading the wrong side of a Result raises
'' FB_RTERROR_ILLEGALFUNCTIONCALL. That needs `on error`, which needs -e, which
'' the unit-test harness does not pass; an unhandled error() would abort the
'' whole run rather than fail one case. It is asserted in result.bi's own tests.

#import "std/fs"
#include "fbcunit.bi"

#include once "fb/result.bi"

using fs

using FB
SUITE( fbc_tests.filesystem.fserror_codes )

	'' One assertion per code, so a mismatch names itself rather than
	'' reporting "the table is wrong somewhere".
	TEST( message_table_matches_enum )
		CU_ASSERT_EQUAL( FsErrorMessage( FS_OK ), "no error" )
		CU_ASSERT_EQUAL( FsErrorMessage( FS_NOT_FOUND ), "no such file or directory" )
		CU_ASSERT_EQUAL( FsErrorMessage( FS_ACCESS_DENIED ), "access denied" )
		CU_ASSERT_EQUAL( FsErrorMessage( FS_ALREADY_EXISTS ), "already exists" )
		CU_ASSERT_EQUAL( FsErrorMessage( FS_NOT_A_DIRECTORY ), "not a directory" )
		CU_ASSERT_EQUAL( FsErrorMessage( FS_IS_A_DIRECTORY ), "is a directory" )
		CU_ASSERT_EQUAL( FsErrorMessage( FS_DIR_NOT_EMPTY ), "directory not empty" )
		CU_ASSERT_EQUAL( FsErrorMessage( FS_INVALID_PATH ), "invalid path" )
		CU_ASSERT_EQUAL( FsErrorMessage( FS_NAME_TOO_LONG ), "name too long" )
		CU_ASSERT_EQUAL( FsErrorMessage( FS_LOOP ), "too many symbolic links" )
		CU_ASSERT_EQUAL( FsErrorMessage( FS_NO_SPACE ), "no space left on device" )
		CU_ASSERT_EQUAL( FsErrorMessage( FS_READ_ONLY ), "read-only" )
		CU_ASSERT_EQUAL( FsErrorMessage( FS_IN_USE ), "in use" )
		CU_ASSERT_EQUAL( FsErrorMessage( FS_CROSS_DEVICE ), "cross-device link" )
		CU_ASSERT_EQUAL( FsErrorMessage( FS_INTERRUPTED ), "interrupted" )
		CU_ASSERT_EQUAL( FsErrorMessage( FS_UNSUPPORTED ), "unsupported" )
		CU_ASSERT_EQUAL( FsErrorMessage( FS_UNKNOWN ), "unknown error" )
	END_TEST

	'' The enumerators must be contiguous from 0, because the C table is
	'' indexed by them directly. If someone inserts a code without adding a
	'' message, this catches it even if every assertion above still passes.
	TEST( enum_is_contiguous_from_zero )
		CU_ASSERT_EQUAL( FS_OK, 0 )
		CU_ASSERT_EQUAL( FS_NOT_FOUND, 1 )
		CU_ASSERT_EQUAL( FS_UNKNOWN, 16 )
	END_TEST

	'' Out-of-range codes fall back rather than reading off the end of the
	'' table -- this is a C array index reachable from FB, so it is asserted.
	TEST( out_of_range_code_falls_back )
		CU_ASSERT_EQUAL( FsErrorMessage( cast( FsErrorCode, 999 ) ), "unknown error" )
		CU_ASSERT_EQUAL( FsErrorMessage( cast( FsErrorCode, -1 ) ), "unknown error" )
	END_TEST

	'' A default FsError is not meaningful; it exists because Result
	'' default-constructs both slots (result.bi:33). It must be FS_UNKNOWN,
	'' never FS_OK -- a default that read as success would make every
	'' forgotten assignment a silent pass.
	TEST( default_error_is_unknown_not_ok )
		dim as FsError e

		CU_ASSERT_EQUAL( e.Code( ), FS_UNKNOWN )
		CU_ASSERT_NOT_EQUAL( e.Code( ), FS_OK )
		CU_ASSERT_EQUAL( e.OsCode( ), 0 )
		CU_ASSERT_EQUAL( e.Path( ), "" )
		CU_ASSERT_EQUAL( e.Path2( ), "" )
		CU_ASSERT_EQUAL( e.Operation( ), "" )
		CU_ASSERT_EQUAL( e.Message( ), "unknown error" )
	END_TEST

	'' A default-constructed Result is a FAILURE (result.bi:24). This is the
	'' property that makes a forgotten assignment read as an error.
	TEST( default_result_is_failure )
		dim as FsResultBool rb
		dim as FsResultUStr ru

		CU_ASSERT_FALSE( rb.IsOk( ) )
		CU_ASSERT_FALSE( ru.IsOk( ) )
		CU_ASSERT_EQUAL( rb.Failure( ).Code( ), FS_UNKNOWN )
	END_TEST

	TEST( fsfail_carries_context )
		dim as FsResultUStr r = FsFail( of ustring )( FS_NOT_FOUND, "CreateFileW", "C:\nope\x.bas" )

		CU_ASSERT_FALSE( r.IsOk( ) )
		CU_ASSERT_EQUAL( r.Failure( ).Code( ), FS_NOT_FOUND )
		CU_ASSERT_EQUAL( r.Failure( ).Operation( ), "CreateFileW" )
		CU_ASSERT_EQUAL( r.Failure( ).Path( ), "C:\nope\x.bas" )
		CU_ASSERT_EQUAL( r.Failure( ).Message( ), "no such file or directory" )
	END_TEST

	'' The error OWNS its strings -- it outlives the call that produced it,
	'' which is the entire point of returning one. A path containing an
	'' unpaired surrogate must survive byte-for-byte: that is the property
	'' the whole USTRING-as-kernel decision exists to protect, and a narrow
	'' round trip would destroy it silently.
	TEST( path_survives_including_lone_surrogate )
		dim as ustring odd = "x" + wchr( &hD800 ) + "y"
		dim as FsResultUStr r = FsFail( of ustring )( FS_INVALID_PATH, "op", odd )

		CU_ASSERT_EQUAL( len( r.Failure( ).Path( ) ), 3 )
		CU_ASSERT_EQUAL( r.Failure( ).Path( ), odd )
	END_TEST

	TEST( ok_side_carries_value )
		dim as FsResultUStr r = Ok( of ustring, FsError )( "C:\dev" )

		CU_ASSERT_TRUE( r.IsOk( ) )
		CU_ASSERT_EQUAL( r.Value( ), "C:\dev" )
	END_TEST

END_SUITE
