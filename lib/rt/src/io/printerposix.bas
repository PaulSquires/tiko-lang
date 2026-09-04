'' printerposix.bas -- fb_PrinterOpen, fb_PrinterWrite, fb_PrinterWriteWstr and
'' fb_PrinterClose: the POSIX printer driver. Four symbols, one fbc member
'' (unix/io_printer.o).
''
'' EMPTY-ON: win64
''
'' THE WINDOWS HALF STAYS fbc's. win32/io_printer.c is 873 lines of GDI device
'' contexts, spooler enumeration and a rendered-page abstraction; this one is
'' 194 lines of `popen( "lp ..." )`. They share a header and nothing else. The
'' gate deletes fbc's members per target, so taking the POSIX half alone is
'' legal: Linux gets tiko-rt's, Windows keeps fbc's, and neither archive has a
'' hole.
''
'' THERE ARE TWO COMPLETELY DIFFERENT DEVICES BEHIND ONE ENTRY POINT, chosen by
'' the port number:
''
''   PORT 0  the CUPS SPOOLER, driven by shelling out to `lp` through popen.
''           driver_opaque is the pipe.
''   PORT n  /dev/lp(n-1), opened with fopen. driver_opaque is the FILE*.
''
'' Nothing distinguishes them afterwards except iPort, which is why Close reads
'' it again to decide between pclose and fclose -- calling the wrong one on the
'' wrong handle is undefined, and there is no tag in the structure to prevent it.
''
'' THE SHELL COMMAND IS SANITISED AFTER IT IS BUILT, NOT BEFORE. The printer name
'' and the document title are pasted straight into the command line, and only
'' then is the WHOLE STRING swept for "`&;|>^$\" with every hit replaced by an
'' underscore. That ordering is deliberate on fbc's part and it is why the
'' quotes fbc itself inserted survive: a filter applied to the name alone could
'' not tell fbc's quotes from the user's.
''
'' IT IS STILL NOT A QUOTING FUNCTION. A double quote is NOT in the strip set, so
'' a printer name containing one closes fbc's quote early. What the sweep buys is
'' that the remainder cannot start a new command, pipe, or expansion -- the
'' characters that would do so are exactly the ones removed. Reproduced verbatim,
'' character for character: changing the set would change which names are
'' accepted, and this is a security-relevant string that must match fbc's.
''
'' exec_lp_cmd's DEFAULT-PRINTER TEST IS BROKEN, AND THE BREAKAGE IS LOAD-BEARING.
'' The test for a leading "no" (as in `lpstat -d` printing "no system default
'' destination") sits INSIDE `if( !fgets( ... ) )` -- i.e. it only runs when the
'' read FAILED, so it inspects the PREVIOUS line still sitting in the buffer, or
'' on the very first iteration a buffer that has never been written. In practice
'' have_default therefore stays TRUE almost always and the function reports
'' success on `lpstat -d`'s exit code alone.
''
'' Reproduced exactly. Fixing it would make OPEN "LPT:" start REFUSING on
'' machines with no default printer, where today it proceeds and fails later at
'' the `lp` call -- a visible behaviour change, not a tidy-up.
''
'' lp_buf IS A 256-BYTE FILE-STATIC AND IS NOT THREAD-SAFE. Two threads opening
'' printers at once share it. fbc's, kept: making it a local would change the
'' defect above from "reads the previous line" to "reads uninitialised stack",
'' which is worse.
''
'' alloca IS REPLACED BY malloc/free throughout, as everywhere else in tiko-rt,
'' and here it adds a failure mode fbc does not have: a failed allocation
'' returns FB_RTERROR_OUTOFMEM where fbc could not fail at all.

#include once "inc/descriptors.bi"
#include once "inc/rterror.bi"
#include once "inc/file.bi"
#include once "crt/stdio.bi"
#include once "crt/stdlib.bi"
#include once "crt/string.bi"

#ifndef __FB_WIN32__

'' DEV_LPT_INFO and DEV_LPT_PROTOCOL, from fb_printer.h -- spelled again here as
'' in src/io/devlptio.bas and src/io/devlptopen.bas, with the same #asserts
'' keeping the copies honest.
type DEV_LPT_INFO
	as any ptr      driver_opaque
	as zstring ptr  pszDevice
	as long         iPort
	as uinteger     uiRefCount
end type

type DEV_LPT_PROTOCOL
	as zstring ptr proto
	as long        iPort
	as zstring ptr name_
	as zstring ptr title_
	as zstring ptr emu
end type

#assert sizeof( DEV_LPT_PROTOCOL ) = 40
#assert offsetof( DEV_LPT_PROTOCOL, name_ ) = 16

extern "c"   '' NON-FBCALL: CRT.
	declare function crt_popen alias "popen" _
		( byval cmd as zstring ptr, byval mode_ as zstring ptr ) as FILE ptr
	declare function crt_pclose alias "pclose" ( byval f as FILE ptr ) as long
end extern

extern "c"   '' NON-FBCALL: rtlib internals, declared plain in fb_printer.h and
             '' fb_unicode.h.
	declare function tkrt_DevLptParseProtocol alias "fb_DevLptParseProtocol" _
		( byval lpt_proto_out as DEV_LPT_PROTOCOL ptr ptr, byval proto_raw as zstring ptr, _
		  byval proto_raw_len as uinteger, byval subst_prn as long ) as long
	declare function tkrt_WCharToUTF alias "fb_WCharToUTF" _
		( byval encod as long, byval src as wstring ptr, byval chars as integer, _
		  byval dst as zstring ptr, byval bytes as integer ptr ) as zstring ptr
end extern

extern "rtlib"   '' FBCALL: fb_ErrorSetNum is decorated on win32 -- and this file
                 '' is empty there, but the declaration stays correct either way.
	declare function tkrt_ErrorSetNum alias "fb_ErrorSetNum" ( byval e as long ) as long
end extern

'' FILE-STATIC AND SHARED BETWEEN THREADS -- see the file header.
dim shared as zstring * 256 tkort_lp_buf

'' Runs a shell command and returns its exit status shifted down eight bits.
''
'' THE test_default BRANCH IS THE BROKEN ONE. See the file header: the "no
'' default printer" check is inside the FAILED-read arm, so it examines the
'' previous line rather than the current one. Reproduced exactly.
private function tkort_exec_lp_cmd( byval cmd as zstring ptr, byval test_default as long ) as long

	dim as long have_default = -1        '' assume a default printer exists
	dim as long result_ = -1

	dim as FILE ptr fp = crt_popen( cmd, @"r" )
	if( fp <> 0 ) then
		while( feof( fp ) = 0 )
			if( fgets( @tkort_lp_buf, 256, fp ) = 0 ) then
				'' READS THE **PREVIOUS** LINE. fbc's, kept -- see the header.
				if( (test_default <> 0) andalso (have_default <> 0) andalso _
				    (strlen( @tkort_lp_buf ) > 2) ) then
					dim as ubyte c0 = cptr( ubyte ptr, @tkort_lp_buf )[0]
					dim as ubyte c1 = cptr( ubyte ptr, @tkort_lp_buf )[1]
					if( ((c0 = 110) orelse (c0 = 78)) andalso _
					    ((c1 = 111) orelse (c1 = 79)) ) then      '' "no" / "NO"
						have_default = 0
					end if
				end if
			end if
		wend

		result_ = crt_pclose( fp ) shr 8

		if( (test_default <> 0) andalso (have_default = 0) ) then result_ = -1
	end if

	return result_
end function

extern "c"   '' NON-FBCALL: fb_printer.h declares all four plainly.

function tkort_PrinterOpen alias "fb_PrinterOpen" _
	( byval devInfo as DEV_LPT_INFO ptr, byval iPort as long, _
	  byval pszDeviceRaw as zstring ptr ) as long

	dim as long result_ = any
	dim as zstring ptr filename = 0
	dim as FILE ptr fp = any
	dim as DEV_LPT_PROTOCOL ptr lpt_proto = 0

	if( tkrt_DevLptParseProtocol( @lpt_proto, pszDeviceRaw, strlen( pszDeviceRaw ), 1 ) = 0 ) then
		if( lpt_proto <> 0 ) then free( lpt_proto )
		return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end if

	devInfo->iPort = iPort

	if( devInfo->iPort = 0 ) then
		'' ---------------------------------------------------- THE SPOOLER

		'' malloc, not alloca -- and unlike fbc's, this can fail.
		filename = cast( zstring ptr, malloc( strlen( pszDeviceRaw ) + 64 ) )
		if( filename = 0 ) then
			if( lpt_proto <> 0 ) then free( lpt_proto )
			return tkrt_ErrorSetNum( FB_RTERROR_OUTOFMEM )
		end if

		if( (lpt_proto->name_ <> 0) andalso (cptr( ubyte ptr, lpt_proto->name_ )[0] <> 0) ) then
			'' A NAMED PRINTER MUST EXIST FIRST. `lpstat -v "name"` is asked
			'' before anything is built, and a non-zero status is reported as
			'' FILE NOT FOUND rather than as a printer error.
			strcpy( filename, @"lpstat -v """ )
			strcat( filename, lpt_proto->name_ )
			strcat( filename, @""" 2>&1 " )
			if( tkort_exec_lp_cmd( filename, 0 ) <> 0 ) then
				free( filename )
				if( lpt_proto <> 0 ) then free( lpt_proto )
				return tkrt_ErrorSetNum( FB_RTERROR_FILENOTFOUND )
			end if

			strcpy( filename, @"lp " )
			strcat( filename, @"-d """ )
			strcat( filename, lpt_proto->name_ )
			strcat( filename, @""" " )
		else
			'' NO NAME: there must be a DEFAULT printer -- and this is the call
			'' whose test is broken. See the file header.
			strcpy( filename, @"lpstat -d 2>&1" )
			if( tkort_exec_lp_cmd( filename, 1 ) <> 0 ) then
				free( filename )
				if( lpt_proto <> 0 ) then free( lpt_proto )
				return tkrt_ErrorSetNum( FB_RTERROR_FILENOTFOUND )
			end if
			strcpy( filename, @"lp " )
		end if

		if( cptr( ubyte ptr, lpt_proto->title_ )[0] <> 0 ) then
			strcat( filename, @"-t """ )
			strcat( filename, lpt_proto->title_ )
			strcat( filename, @"""" )
		else
			strcat( filename, @"-t ""FreeBASIC document""" )
		end if

		'' -s suppresses the job id, and the bare - reads the document from
		'' stdin, which is the pipe opened below.
		strcat( filename, @" -s -" )

		'' SANITISED AFTER ASSEMBLY, NOT BEFORE -- see the file header for why
		'' that ordering matters and what it does and does not buy.
		scope
			dim as ubyte ptr ptr_ = cast( ubyte ptr, strpbrk( filename, @"`&;|>^$\" ) )
			while( ptr_ <> 0 )
				*ptr_ = 95                                   '' '_'
				ptr_ = cast( ubyte ptr, strpbrk( cast( zstring ptr, ptr_ ), @"`&;|>^$\" ) )
			wend
		end scope

		'' AND THE REDIRECTION IS APPENDED **AFTER** THE SWEEP, so its own '&'
		'' and '>' survive. Doing it before would have turned them into
		'' underscores and left the string "_ /dev/null" on the command line.
		strcat( filename, @" &> /dev/null" )

		fp = crt_popen( filename, @"w" )
		if( fp = 0 ) then
			devInfo->driver_opaque = 0
			result_ = tkrt_ErrorSetNum( FB_RTERROR_FILENOTFOUND )
		else
			devInfo->driver_opaque = fp
			result_ = tkrt_ErrorSetNum( FB_RTERROR_OK )
		end if

		free( filename )
	else
		'' ------------------------------------------------- THE DEVICE NODE
		''
		'' /dev/lp0 IS LPT1 -- the port number is one-based and the node is not.
		filename = cast( zstring ptr, malloc( 7 + 11 + 1 ) )
		if( filename = 0 ) then
			if( lpt_proto <> 0 ) then free( lpt_proto )
			return tkrt_ErrorSetNum( FB_RTERROR_OUTOFMEM )
		end if

		sprintf( filename, @"/dev/lp%d", devInfo->iPort - 1 )
		fp = fopen( filename, @"wb" )

		if( fp = 0 ) then
			devInfo->driver_opaque = 0
			result_ = tkrt_ErrorSetNum( FB_RTERROR_FILENOTFOUND )
		else
			devInfo->driver_opaque = fp
			result_ = tkrt_ErrorSetNum( FB_RTERROR_OK )
		end if

		free( filename )
	end if

	if( lpt_proto <> 0 ) then free( lpt_proto )

	return result_
end function

'' ONE fwrite OF THE WHOLE BLOCK, and the test is that it returned 1 -- i.e. one
'' complete ITEM of `length` bytes. A partial write returns 0 and is reported as
'' FILEIO with no indication of how much got through.
function tkort_PrinterWrite alias "fb_PrinterWrite" _
	( byval devInfo as DEV_LPT_INFO ptr, byval data_ as any ptr, byval length_ as uinteger ) as long

	dim as FILE ptr fp = cast( FILE ptr, devInfo->driver_opaque )
	if( fwrite( data_, length_, 1, fp ) <> 1 ) then
		return tkrt_ErrorSetNum( FB_RTERROR_FILEIO )
	end if
	return tkrt_ErrorSetNum( FB_RTERROR_OK )
end function

'' THE WIDE WRITE CONVERTS TO UTF-8 -- unlike the serial device's, which emits
'' raw code units. fbc's own comment here is "!!!FIXME!!! is this ok?", and the
'' answer it settled on is what ships.
function tkort_PrinterWriteWstr alias "fb_PrinterWriteWstr" _
	( byval devInfo as DEV_LPT_INFO ptr, byval buffer as wstring ptr, byval chars as uinteger ) as long

	dim as FILE ptr fp = cast( FILE ptr, devInfo->driver_opaque )
	dim as integer bytes_ = any

	'' Four bytes per code unit is the most UTF-8 can need, plus the terminator.
	dim as zstring ptr temp = cast( zstring ptr, malloc( chars * 4 + 1 ) )
	if( temp = 0 ) then return tkrt_ErrorSetNum( FB_RTERROR_OUTOFMEM )

	tkrt_WCharToUTF( FB_FILE_ENCOD_UTF8, buffer, cast( integer, chars ), temp, @bytes_ )
	temp[bytes_] = 0

	if( fwrite( temp, bytes_, 1, fp ) <> 1 ) then
		free( temp )
		return tkrt_ErrorSetNum( FB_RTERROR_FILEIO )
	end if

	free( temp )
	return tkrt_ErrorSetNum( FB_RTERROR_OK )
end function

'' CLOSE READS iPort AGAIN to pick between pclose and fclose -- see the file
'' header. And only the SPOOLER's status is checked: a failing fclose on a
'' device node is ignored.
function tkort_PrinterClose alias "fb_PrinterClose" _
	( byval devInfo as DEV_LPT_INFO ptr ) as long

	if( devInfo->iPort = 0 ) then
		dim as long result_ = crt_pclose( cast( FILE ptr, devInfo->driver_opaque ) ) shr 8
		devInfo->driver_opaque = 0
		if( result_ <> 0 ) then return tkrt_ErrorSetNum( FB_RTERROR_FILEIO )
	else
		fclose( cast( FILE ptr, devInfo->driver_opaque ) )
		devInfo->driver_opaque = 0
	end if

	return tkrt_ErrorSetNum( FB_RTERROR_OK )
end function

end extern

#endif
