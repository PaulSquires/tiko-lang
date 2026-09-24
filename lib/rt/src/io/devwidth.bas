'' devwidth.bas -- SPC, TAB, WIDTH # and the line-length setter: four entry
'' points over three fbc members.
''
'' fb_LPos IS NOT HERE, and fb_WidthDev is no longer here EITHER -- it moved to
'' src/io/devwidth2.bas once the obstacle below was removed.
''
'' Both reach into the printer/serial device layer -- fb_DevPrinterGetOffset,
'' fb_DevPrinterSetWidth -- which lives in fbc's io_printer.o and imports
'' winspool. tiko-rt's objects are linked EXPLICITLY by build/diff.sh, so
'' referencing those symbols pulls io_printer.o into every differential program,
'' and every one of them then failed to link on WritePrinter/EndDocPrinter/
'' ClosePrinter -- while the stock program, which never pulls that member, linked
'' fine.
''
'' THAT IS NO LONGER TRUE, and the note that said "naming -l winspool did not
'' resolve it" was left standing after the fix landed. build/diff.sh now links
'' `-l winspool -l gdi32`, and with both of them fb_WidthDev links and all 98
'' differentials pass. The single -l was not enough; gdi32 is the other half,
'' because io_printer.o also imports StartPage/EndPage/DeleteDC from it.
''
'' fb_LPos stays out, and belongs with the io_printer batch.
''
'' SPC AND TAB TAKE COMPLETELY DIFFERENT PATHS FOR A SCREEN AND FOR A FILE, and
'' the difference is not cosmetic. On a screen they ask the console where the
'' cursor actually is and LOCATE to the target, wrapping to new lines as needed.
'' On a file there is no cursor to ask, so TAB emits a newline plus padding and
'' SPC emits spaces. Treating a file like a screen would call fb_GetXY on a
'' handle that has no console behind it.
''
'' fb_PrintBufferEx( NULL, 0, FORCE_ADJUST ) BEFORE READING THE CURSOR is a
'' quirk with a real cause: at the bottom-right cell the console's reported
'' position lags until something forces an adjustment, so without this the tab
'' stop is computed from a stale column.
''
'' TAB WRAPS BY MODULO BUT SPC WRAPS BY LOOP. TAB takes newcol mod cols once;
'' SPC subtracts cols repeatedly, emitting a newline each time. They are not
'' interchangeable -- SPC's spaces have to actually appear.
''
'' WIDTH RETURNS TWO DIFFERENT THINGS. Asked with -1 it returns the current
'' wid; asked with a real wid it SETS it and returns the error code. The
'' same is true of fb_WidthDev. A caller that ignores the argument cannot read
'' the result.
''
'' THE PARAMETER IS `wid`, NOT `width`: WIDTH is a FreeBASIC statement, and
'' like PRESET, RUN, FRAC and ABSOLUTE before it the clash is reported at the
'' USE -- here as "illegal specification, at parameter 2" on the declaration
'' line itself, which at least points at the right place for once.
''

#include once "inc/descriptors.bi"
#include once "inc/file.bi"
#include once "inc/print.bi"
#include once "inc/rterror.bi"
#include once "inc/iolock.bi"
#include once "inc/list.bi"
#include once "inc/fmt.bi"
#include once "inc/sysbind.bi"

extern "c"   '' NON-FBCALL: the handle-taking and device-layer forms.
	declare sub tkrt_DevScrnInitNoOpen alias "fb_DevScrnInit_NoOpen" ( )
	declare sub tkrt_PrintVoidEx alias "fb_PrintVoidEx" ( byval h as FB_FILE ptr, byval mask as long )
	declare sub tkrt_PrintPadEx alias "fb_PrintPadEx" ( byval h as FB_FILE ptr, byval mask as long )
	declare sub tkrt_PrintStringEx alias "fb_PrintStringEx" _
		( byval h as FB_FILE ptr, byval s as FBSTRING ptr, byval mask as long )
end extern

extern "rtlib"
	declare function tkrt_ErrorSetNum alias "fb_ErrorSetNum" ( byval errnum as long ) as long
	declare sub tkrt_PrintBufferEx alias "fb_PrintBufferEx" _
		( byval buffer as any ptr, byval length as uinteger, byval mask as long )
	declare sub tkrt_GetXY alias "fb_GetXY" ( byval col as long ptr, byval row as long ptr )
	declare sub tkrt_GetSize alias "fb_GetSize" ( byval cols as long ptr, byval rows as long ptr )
	declare function tkrt_Locate alias "fb_Locate" _
		( byval row as long, byval col as long, byval cursor as long, _
		  byval top_ as long, byval bot as long ) as long
	declare function tkrt_Width alias "fb_Width" ( byval cols as long, byval rows as long ) as long
	declare function tkrt_StrFill1 alias "fb_StrFill1" _
		( byval cnt as integer, byval ch as long ) as FBSTRING ptr
	declare function tkrt_StrAllocTempDescF alias "fb_StrAllocTempDescF" _
		( byval s as zstring ptr, byval length as integer ) as FBSTRING ptr
end extern

'' Follow the redirection chain, then ask whether that is the screen handle.
private function hIsScreen( byval h as FB_FILE ptr ) as long
	if( h = 0 ) then return 0
	dim as FB_FILE ptr d = h
	while( d->redirection_to <> 0 )
		d = d->redirection_to
	wend
	if( d = TKORT_HANDLE_SCREEN() ) then return 1
	return 0
end function

extern "rtlib"

sub tkort_PrintTab alias "fb_PrintTab" ( byval fnum as long, byval newcol as long )
	dim as FB_FILE ptr handle = any
	dim as long col = any, row = any, cols = any, rows = any

	tkrt_DevScrnInitNoOpen( )
	TKORT_IOLOCK()

	handle = TKORT_FILE_TO_HANDLE( fnum )
	if( handle = 0 ) then
		TKORT_IOUNLOCK()
		exit sub
	end if

	if( hIsScreen( handle ) orelse (handle->type_ = FB_FILE_TYPE_CONSOLE) ) then
		if( handle->type_ = FB_FILE_TYPE_CONSOLE ) then
			if( handle->hooks <> 0 ) then
				if( handle->hooks->pfnFlush <> 0 ) then handle->hooks->pfnFlush( handle )
			end if
		end if

		'' See the header: without this the column can be stale.
		tkrt_PrintBufferEx( 0, 0, FB_PRINT_FORCE_ADJUST )
		tkrt_GetXY( @col, @row )
		tkrt_GetSize( @cols, @rows )

		'' MODULO, not a loop -- TAB moves, it does not emit spaces.
		if( newcol > cols ) then newcol mod= cols

		if( col > newcol ) then
			'' Already past the stop: wrap to the next line first.
			tkrt_PrintVoidEx( handle, FB_PRINT_NEWLINE )
			tkrt_Locate( 0, newcol, -1, 0, 0 )
		elseif( newcol < 1 ) then
			tkrt_Locate( 0, 1, -1, 0, 0 )
		else
			tkrt_Locate( 0, newcol, -1, 0, 0 )
		end if
	else
		if( handle->type_ = FB_FILE_TYPE_PIPE ) then
			'' A pipe has no columns at all; pad and be done.
			tkrt_PrintPadEx( handle, 0 )
		else
			if( (newcol >= 0) andalso (cuint( newcol ) > handle->line_length) ) then
				'' Still short of the stop: pad with spaces on this line.
				tkrt_PrintStringEx( handle, _
					tkrt_StrFill1( newcol - handle->line_length - 1, 32 ), 0 )
			else
				'' Past it: newline, then pad. THE BINARY NEWLINE IS CRLF ON
				'' BOTH PLATFORMS -- see inc/print.bi.
				if( handle->mode = FB_FILE_MODE_BINARY ) then
					tkrt_PrintStringEx( handle, _
						tkrt_StrAllocTempDescF( @TKORT_BIN_NEWLINE, TKORT_BIN_NEWLINE_LEN + 1 ), 0 )
				else
					tkrt_PrintStringEx( handle, _
						tkrt_StrAllocTempDescF( @TKORT_NEWLINE, TKORT_NEWLINE_LEN + 1 ), 0 )
				end if

				if( newcol > 0 ) then
					tkrt_PrintStringEx( handle, tkrt_StrFill1( newcol - 1, 32 ), 0 )
				end if
			end if
		end if
	end if

	TKORT_IOUNLOCK()
end sub

sub tkort_PrintSPC alias "fb_PrintSPC" ( byval fnum as long, byval n as integer )
	dim as FB_FILE ptr handle = any
	dim as long col = any, row = any, cols = any, rows = any, newcol = any

	'' Zero is a no-op BEFORE the screen is initialised -- SPC(0) must not
	'' open a console.
	if( n = 0 ) then exit sub

	tkrt_DevScrnInitNoOpen( )
	TKORT_IOLOCK()

	handle = TKORT_FILE_TO_HANDLE( fnum )
	if( handle = 0 ) then
		TKORT_IOUNLOCK()
		exit sub
	end if

	if( hIsScreen( handle ) orelse (handle->type_ = FB_FILE_TYPE_CONSOLE) ) then
		if( handle->type_ = FB_FILE_TYPE_CONSOLE ) then
			if( handle->hooks <> 0 ) then
				if( handle->hooks->pfnFlush <> 0 ) then handle->hooks->pfnFlush( handle )
			end if
		end if

		tkrt_PrintBufferEx( 0, 0, FB_PRINT_FORCE_ADJUST )
		tkrt_GetXY( @col, @row )
		tkrt_GetSize( @cols, @rows )

		'' A LOOP, not modulo: every skipped line has to be emitted.
		newcol = col + cast( long, n )
		while( newcol > cols )
			tkrt_PrintVoidEx( handle, FB_PRINT_NEWLINE )
			newcol -= cols
		wend

		tkrt_Locate( 0, newcol, -1, 0, 0 )
	else
		tkrt_PrintStringEx( handle, tkrt_StrFill1( n, 32 ), 0 )
	end if

	TKORT_IOUNLOCK()
end sub

end extern

extern "rtlib"

'' FBCALL, EVEN THOUGH IT TAKES A HANDLE. fb_file.h marks it FBCALL, and the
'' *Ex suffix -- not the argument type -- is what identifies the internal cdecl
'' tier. Reasoning from "it takes a handle, so it must be cdecl" put this in an
'' EXTERN "C" block and produced _fb_SetPos where win32 wants _fb_SetPos@8.
'' win64 and Linux cannot tell the difference; only build/symbols.sh on win32
'' catches it, which is the fourth time that check has earned its place.
function tkort_SetPos alias "fb_SetPos" _
	( byval handle as FB_FILE ptr, byval line_length as long ) as long
	TKORT_IOLOCK()
	handle->line_length = line_length
	TKORT_IOUNLOCK()
	return tkrt_ErrorSetNum( FB_RTERROR_OK )
end function

end extern

extern "rtlib"

'' WIDTH #n -- see the header on the two return meanings.
function tkort_WidthFile alias "fb_WidthFile" _
	( byval fnum as long, byval wid as long ) as long
	dim as long cur = wid
	dim as FB_FILE ptr handle = any

	TKORT_IOLOCK()

	handle = TKORT_FILE_TO_HANDLE( fnum )
	if( handle <> 0 ) then
		while( handle->redirection_to <> 0 )
			handle = handle->redirection_to
		wend
	end if

	if( TKORT_HANDLE_USED( handle ) = 0 ) then
		TKORT_IOUNLOCK()
		return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end if

	'' A second, redundant-looking hooks test in fbc. Kept: the deref above
	'' can land on a different handle than the one just checked.
	if( handle->hooks = 0 ) then
		TKORT_IOUNLOCK()
		return tkrt_ErrorSetNum( FB_RTERROR_ILLEGALFUNCTIONCALL )
	end if

	if( handle = TKORT_HANDLE_SCREEN() ) then
		if( wid <> -1 ) then tkrt_Width( wid, -1 )
		cur = cast( long, TKORT_HANDLE_SCREEN()->width )
	else
		if( wid <> -1 ) then
			handle->width = wid
			if( handle->hooks->pfnSetWidth <> 0 ) then
				handle->hooks->pfnSetWidth( handle, wid )
			end if
		end if
		cur = cast( long, handle->width )
	end if

	TKORT_IOUNLOCK()

	if( wid = -1 ) then return cur
	return tkrt_ErrorSetNum( FB_RTERROR_OK )
end function

end extern
