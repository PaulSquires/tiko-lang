'' throw.bas -- ERROR, RESUME and the handler hook: six entry points over one
'' fbc member.
''
'' THE DECISION EVERY PATH MAKES IS "HANDLER OR DIE". With a user handler
'' installed, the context is filled in and the handler's address is RETURNED --
'' this code does not call it. The compiler emits a jump to whatever comes
'' back, which is why the return type is a function pointer and why returning
'' NULL by mistake would jump to address zero rather than fail cleanly.
''
'' WITHOUT A HANDLER, fb_Die BUILDS A MESSAGE AND ENDS THE PROGRAM. It is
'' static in fbc, so there is no symbol to match and none is exported here.
''
'' fb_Die WRITES INTO __fb_errmsg AND PUBLISHES IT VIA __fb_ctx.errmsg. It does
'' not print: fb_hRtExit does that on the way out. Printing here would emit the
'' message twice under -exx, once from each.
''
'' THE MESSAGE IS ASSEMBLED WITH snprintf, WHICH IS MSVCRT ON WINDOWS while
'' sprintf is MinGW (inc/fmt.bi). It matters here only for %d, where the two
'' agree -- but the call is matched rather than the implementation chosen.
''
'' RESUME AND RESUME NEXT CLEAR *BOTH* LABELS, not just the one they used. A
'' second RESUME with no intervening error must die rather than loop back to a
'' stale label, and clearing only the label taken would let RESUME NEXT still
'' fire after a RESUME.

#include once "inc/descriptors.bi"
#include once "inc/rterror.bi"
#include once "inc/ctx.bi"
#include once "inc/fmt.bi"

const FB_TLSKEY_ERROR as long = 0

extern "rtlib"
	declare function fb_TlsGetCtx alias "fb_TlsGetCtx" _
		( byval idx as long, byval length as uinteger, byval dtor as any ptr ) as any ptr
	declare sub tkrt_End alias "fb_End" ( byval errlevel as long )
end extern

private function hCtx( ) as FB_ERRORCTX ptr
	return cptr( FB_ERRORCTX ptr, _
		fb_TlsGetCtx( FB_TLSKEY_ERROR, sizeof( FB_ERRORCTX ), 0 ) )
end function

'' Indexed by FB_RTERROR. NOTE fbc's trailing comments here are misaligned --
'' SIGTERM appears twice and SIGABRT is against the quit text -- but the
'' STRINGS are in the right order and the strings are what is observable.
'' Reproduce the strings, not the comments.
private function hErrMessage( byval n as long ) as zstring ptr
	select case n
	case 0  : return @""
	case 1  : return @"illegal function call"
	case 2  : return @"file not found"
	case 3  : return @"file I/O error"
	case 4  : return @"out of memory"
	case 5  : return @"illegal resume"
	case 6  : return @"out of bounds array access"
	case 7  : return @"null pointer access"
	case 8  : return @"no privileges"
	case 9  : return @!"\"interrupted\" signal"
	case 10 : return @!"\"illegal instruction\" signal"
	case 11 : return @!"\"floating point error\" signal"
	case 12 : return @!"\"segmentation violation\" signal"
	case 13 : return @!"\"termination request\" signal"
	case 14 : return @!"\"abnormal termination\" signal"
	case 15 : return @!"\"quit request\" signal"
	case 16 : return @"return without gosub"
	case 17 : return @"end of file"
	case 18 : return @"array not dimensioned"
	case 19 : return @"wrong number of dimensions"
	end select
	return @""
end function

'' Builds the abort message and ends the program. STATIC in fbc: no symbol.
''
'' THE PREPOSITION CHANGES WITH THE LINE NUMBER -- " of MOD::FUN()" when a line
'' is known and " in MOD::FUN()" when it is not. fbc picks it with an inline
'' conditional on line_num > 0, and the two words are not interchangeable in
'' the output a test compares.
private sub hDie( byval err_num as long, byval line_num as long, _
                  byval mod_name as zstring ptr, byval fun_name as zstring ptr, _
                  byval msg as zstring ptr )

	'' integer, not long: it is a byte offset into the message buffer, and
	'' snprintf returns a C int that is widened here explicitly.
	dim as integer pos_ = 0
	dim as zstring ptr em = cptr( zstring ptr, @__fb_errmsg )
	dim as zstring ptr prep = any

	pos_ += tkrt_snprintf( em + pos_, FB_ERRMSG_SIZE - pos_, _
	                       @!"\nAborting due to runtime error %d", err_num )

	'' The range test is what keeps an unknown code from indexing the table.
	if( (err_num >= 0) andalso (err_num < FB_RTERROR_MAX) ) then
		pos_ += tkrt_snprintf( em + pos_, FB_ERRMSG_SIZE - pos_, _
		                       @" (%s)", hErrMessage( err_num ) )
	end if

	if( line_num > 0 ) then
		pos_ += tkrt_snprintf( em + pos_, FB_ERRMSG_SIZE - pos_, _
		                       @" at line %d", line_num )
	end if

	if( mod_name <> 0 ) then
		if( line_num > 0 ) then prep = @"of" else prep = @"in"
		if( fun_name <> 0 ) then
			pos_ += tkrt_snprintf( em + pos_, FB_ERRMSG_SIZE - pos_, _
			                       @" %s %s::%s()", prep, mod_name, fun_name )
		else
			pos_ += tkrt_snprintf( em + pos_, FB_ERRMSG_SIZE - pos_, _
			                       @" %s %s()", prep, mod_name )
		end if
	end if

	if( msg <> 0 ) then
		pos_ += tkrt_snprintf( em + pos_, FB_ERRMSG_SIZE - pos_, @", %s", msg )
	end if

	pos_ += tkrt_snprintf( em + pos_, FB_ERRMSG_SIZE - pos_, @!"\n\n" )

	em[FB_ERRMSG_SIZE - 1] = 0

	'' Published, not printed -- fb_hRtExit shows it on the way out.
	TKORT_CTX_ERRMSG() = em

	tkrt_End( err_num )
end sub

'' NON-FBCALL: fb_error.h declares the throwers plain; only fb_ErrorSetHandler
'' carries FBCALL. Getting this wrong is invisible except on win32.
extern "c"   '' NON-FBCALL: the throw/resume entry points, per fb_error.h.

'' Returns the HANDLER for the compiler to jump to, or dies. Never returns
'' normally when there is no handler.
function tkort_ErrorThrowMsg alias "fb_ErrorThrowMsg" _
	( byval err_num as long, byval line_num as long, byval mod_name as zstring ptr, _
	  byval msg as zstring ptr, byval res_label as any ptr, _
	  byval resnext_label as any ptr ) as FB_ERRHANDLER

	dim as FB_ERRORCTX ptr ctx = hCtx( )

	if( ctx->handler <> 0 ) then
		ctx->err_num = err_num
		ctx->line_num = line_num
		'' The module name is kept only when one is GIVEN: a NULL leaves the
		'' previous name in place rather than clearing it, so a throw from a
		'' module without a name still reports the last one known.
		if( mod_name <> 0 ) then ctx->mod_name = mod_name
		ctx->res_lbl = res_label
		ctx->resnxt_lbl = resnext_label
		return ctx->handler
	end if

	'' No handler: die. The module name falls back to the context's.
	dim as zstring ptr mn = mod_name
	if( mn = 0 ) then mn = ctx->mod_name
	hDie( err_num, line_num, mn, ctx->fun_name, msg )
	return 0
end function

function tkort_ErrorThrowEx alias "fb_ErrorThrowEx" _
	( byval err_num as long, byval line_num as long, byval mod_name as zstring ptr, _
	  byval res_label as any ptr, byval resnext_label as any ptr ) as FB_ERRHANDLER
	return tkort_ErrorThrowMsg( err_num, line_num, mod_name, 0, res_label, resnext_label )
end function

'' Rethrows whatever error number is already in the context -- ERROR with no
'' argument, and the path RESUME takes after a handler returns.
function tkort_ErrorThrowAt alias "fb_ErrorThrowAt" _
	( byval line_num as long, byval mod_name as zstring ptr, _
	  byval res_label as any ptr, byval resnext_label as any ptr ) as FB_ERRHANDLER
	dim as FB_ERRORCTX ptr ctx = hCtx( )
	return tkort_ErrorThrowEx( ctx->err_num, line_num, mod_name, res_label, resnext_label )
end function

'' Both resume paths clear BOTH labels -- see the header.
function tkort_ErrorResume alias "fb_ErrorResume" ( ) as any ptr
	dim as FB_ERRORCTX ptr ctx = hCtx( )
	dim as any ptr label_ = ctx->res_lbl
	if( label_ = 0 ) then
		hDie( FB_RTERROR_ILLEGALRESUME, -1, ctx->mod_name, ctx->fun_name, 0 )
	end if
	ctx->res_lbl = 0
	ctx->resnxt_lbl = 0
	return label_
end function

function tkort_ErrorResumeNext alias "fb_ErrorResumeNext" ( ) as any ptr
	dim as FB_ERRORCTX ptr ctx = hCtx( )
	dim as any ptr label_ = ctx->resnxt_lbl
	if( label_ = 0 ) then
		hDie( FB_RTERROR_ILLEGALRESUME, -1, ctx->mod_name, ctx->fun_name, 0 )
	end if
	ctx->res_lbl = 0
	ctx->resnxt_lbl = 0
	return label_
end function

end extern

extern "rtlib"

'' FBCALL, unlike its neighbours. Returns the OLD handler, so ON ERROR can be
'' nested and restored.
function tkort_ErrorSetHandler alias "fb_ErrorSetHandler" _
	( byval newhandler as FB_ERRHANDLER ) as FB_ERRHANDLER
	dim as FB_ERRORCTX ptr ctx = hCtx( )
	dim as FB_ERRHANDLER oldhandler = ctx->handler
	ctx->handler = newhandler
	return oldhandler
end function

end extern
