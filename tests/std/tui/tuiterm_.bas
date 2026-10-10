'' The backend -- C:\dev\docs\tui\RFC-0002-backend-and-capabilities.md.
''
'' THIS SUITE EXISTS AS MUCH TO COMPILE tuiterm.bi AS TO ASSERT ANYTHING.
'' Phase 1 shipped with tuicore and tuibuffer suites only, and a defect in
'' tuiterm.bi that made it uncompilable on linux-x86_64 -- unprefixed `read` and
'' `write` extern declarations colliding with crt.bi -- got all the way to a
'' hand build before anything noticed. A header with no suite is a header that
'' is not built on both targets.
''
'' What can be asserted here is bounded, and the boundary is honest: under the
'' test harness stdout is REDIRECTED, so every run takes the not-a-terminal
'' path. That is a feature for these tests -- it is the branch most likely to be
'' hit by accident in the field and least likely to be looked at -- but it means
'' raw mode, the alternate screen and the restore contract are NOT exercised
'' here. Those are verified by hand; see the phase-1 notes in README.md.

#import "std/tui"
#import "std/chrono"
#include "fbcunit.bi"

'' Deliberately included AFTER fb/tui.bi. This is the collision that broke the
'' Linux build: crt.bi declares read/write/signal/poll/raise, and tuiterm.bi's
'' own externs must not fight with them.
#include once "crt.bi"

#include once "fb/array.bi"

#include once "fb/result.bi"

#include once "fb/optional.bi"

using tui, chrono

using FB
SUITE( fbc_tests.tui.tuiterm_ )

	'' RFC-0002 section 1. A default-constructed TuiError is NONE, so there is
	'' no uninitialised state that reads as a failure.
	TEST( rfc0002_s1_error_defaults_to_none )
		dim as TuiError e
		CU_ASSERT_EQUAL( e.code, TUIERR_NONE )
		CU_ASSERT_EQUAL( e.Message( ), "no error" )
	END_TEST

	'' RFC-0002 section 1. Every code produces a message that names the code
	'' AND carries the detail -- an error whose text drops the detail is worse
	'' than no error type at all.
	TEST( rfc0002_s1_every_error_code_has_a_message )
		dim as TuiError nt = TuiError( TUIERR_NOTATTY, "stdout is a pipe" )
		CU_ASSERT_TRUE( instr( nt.Message( ), "not a terminal" ) > 0 )
		CU_ASSERT_TRUE( instr( nt.Message( ), "stdout is a pipe" ) > 0 )

		dim as TuiError rm = TuiError( TUIERR_RAWMODE, "tcsetattr", 13 )
		CU_ASSERT_TRUE( instr( rm.Message( ), "raw mode" ) > 0 )
		CU_ASSERT_TRUE( instr( rm.Message( ), "tcsetattr" ) > 0 )
		CU_ASSERT_TRUE( instr( rm.Message( ), "13" ) > 0 )

		'' an oscode of 0 is omitted rather than printed as "(os 0)"
		CU_ASSERT_TRUE( instr( TuiError( TUIERR_IO, "x" ).Message( ), "os" ) = 0 )

		for c as long = TUIERR_NONE to TUIERR_SIZE
			dim as TuiError e = TuiError( cast( TuiErrorCode, c ), "" )
			CU_ASSERT_TRUE( len( e.Message( ) ) > 0 )
		next
	END_TEST

	'' RFC-0002 section 1. Result has NO constructor: it is built with
	'' FB.Ok / FB.Fail. A default-constructed Result is a FAILURE, which is the
	'' only safe default -- a Result nobody has set must not read as success.
	TEST( rfc0002_s1_result_construction )
		dim as TuiSizeResult defaulted
		CU_ASSERT_FALSE( defaulted.IsOk( ) )

		dim as TuiSizeResult good = Ok( of TuiSize, TuiError )( TuiSizeOf( 120, 30 ) )
		CU_ASSERT_TRUE ( good.IsOk( ) )
		CU_ASSERT_EQUAL( good.Value( ).cols, 120 )
		CU_ASSERT_EQUAL( good.Value( ).rows, 30 )

		dim as TuiSizeResult bad = Fail( of TuiSize, TuiError )( TuiError( TUIERR_NOTATTY, "pipe" ) )
		CU_ASSERT_FALSE( bad.IsOk( ) )
		CU_ASSERT_EQUAL( bad.Failure( ).code, TUIERR_NOTATTY )
	END_TEST

	'' RFC-0002 section 2. The default options are the ones a dashboard wants,
	'' and mouse is OFF by default because enabling it changes what the
	'' terminal sends and a program that does not read mouse events would then
	'' see them as garbage keys.
	TEST( rfc0002_s2_default_options )
		dim as TuiTermOptions o = TuiTermOptionsDefault( )
		CU_ASSERT_TRUE ( o.altScreen )
		CU_ASSERT_TRUE ( o.rawMode )
		CU_ASSERT_TRUE ( o.hideCursor )
		CU_ASSERT_TRUE ( o.bracketedPaste )
		CU_ASSERT_FALSE( o.mouse )
		CU_ASSERT_FALSE( o.focusEvents )
	END_TEST

	'' RFC-0002 section 6. Leave must undo Enter in EXACTLY reverse order, and
	'' every mode Enter turns on must have its 'l' counterpart. A mode left on
	'' is a terminal the user has to fix by hand.
	TEST( rfc0002_s6_leave_undoes_every_mode_enter_sets )
		dim as TuiTermOptions o = TuiTermOptionsDefault( )
		o.mouse = TRUE
		o.focusEvents = TRUE

		dim as string en = TuiEnterSeq( o )
		dim as string lv = TuiLeaveSeq( o )

		'' every private mode set with 'h' is cleared with 'l'
		CU_ASSERT_TRUE( instr( en, "[?1049h" ) > 0 )
		CU_ASSERT_TRUE( instr( lv, "[?1049l" ) > 0 )
		CU_ASSERT_TRUE( instr( en, "[?25l" ) > 0 )
		CU_ASSERT_TRUE( instr( lv, "[?25h" ) > 0 )
		CU_ASSERT_TRUE( instr( en, "[?2004h" ) > 0 )
		CU_ASSERT_TRUE( instr( lv, "[?2004l" ) > 0 )
		CU_ASSERT_TRUE( instr( en, "[?1006h" ) > 0 )
		CU_ASSERT_TRUE( instr( lv, "[?1006l" ) > 0 )
		CU_ASSERT_TRUE( instr( en, "[?1004h" ) > 0 )
		CU_ASSERT_TRUE( instr( lv, "[?1004l" ) > 0 )

		'' the alternate screen is exited LAST, after everything else is undone
		CU_ASSERT_TRUE( instr( lv, "[?1049l" ) > instr( lv, "[?2004l" ) )
		CU_ASSERT_TRUE( instr( lv, "[?1049l" ) > instr( lv, "[?25h" ) )

		'' and the style is reset FIRST, so nothing bleeds onto the main screen
		CU_ASSERT_TRUE( instr( lv, "[0m" ) = 2 )

		'' options that were off produce no sequence in either direction
		dim as TuiTermOptions bare
		CU_ASSERT_EQUAL( len( TuiEnterSeq( bare ) ), 0 )
		CU_ASSERT_TRUE ( instr( TuiLeaveSeq( bare ), "[?1049l" ) = 0 )

		'' the leave sequence must fit the fixed async-signal-safe buffer that
		'' the emergency restore path writes from
		CU_ASSERT_TRUE( len( lv ) < 128 )
	END_TEST

	'' RFC-0002 section 9. VT coordinates are 1-based; everything in the module
	'' is 0-based, and the conversion happens in ONE place.
	'' RFC-0002 section 3. THE MOUSE DEFECT, as a test.
	''
	'' Asking for mouse:=TRUE was not enough on Windows: QuickEdit is on by
	'' default and the console eats every mouse event for text selection, so the
	'' application saw none. The whole of it is in this mode word.
	#ifdef __FB_WIN32__
	TEST( rfc0002_s3_windows_mouse_requires_clearing_quickedit )
		'' the mode a real console hands you: cooked input, QuickEdit on
		dim as DWORD found = ENABLE_LINE_INPUT or ENABLE_ECHO_INPUT or _
		                     ENABLE_PROCESSED_INPUT or ENABLE_QUICK_EDIT_MODE or _
		                     ENABLE_INSERT_MODE or ENABLE_EXTENDED_FLAGS

		dim as TuiTermOptions o = TuiTermOptionsDefault( )
		o.mouse = TRUE
		dim as DWORD m = TuiWin32InputMode( found, o )

		'' raw: the three cooked-input bits are gone
		CU_ASSERT_EQUAL( m and ENABLE_LINE_INPUT, 0 )
		CU_ASSERT_EQUAL( m and ENABLE_ECHO_INPUT, 0 )
		CU_ASSERT_EQUAL( m and ENABLE_PROCESSED_INPUT, 0 )
		'' resize events still arrive
		CU_ASSERT_TRUE ( ( m and ENABLE_WINDOW_INPUT ) <> 0 )

		'' and the mouse actually works: reporting ON, QuickEdit OFF, and
		'' EXTENDED_FLAGS set -- without which the QuickEdit clear is ignored
		CU_ASSERT_TRUE ( ( m and ENABLE_MOUSE_INPUT ) <> 0 )
		CU_ASSERT_TRUE ( ( m and ENABLE_EXTENDED_FLAGS ) <> 0 )
		CU_ASSERT_EQUAL( m and ENABLE_QUICK_EDIT_MODE, 0 )

		'' unrelated bits the console had are preserved
		CU_ASSERT_TRUE ( ( m and ENABLE_INSERT_MODE ) <> 0 )

		'' no mouse asked for: nothing is touched beyond raw mode. QuickEdit
		'' stays as the user set it, because it is theirs and not ours.
		o.mouse = FALSE
		dim as DWORD n = TuiWin32InputMode( found, o )
		CU_ASSERT_EQUAL( n and ENABLE_MOUSE_INPUT, 0 )
		CU_ASSERT_TRUE ( ( n and ENABLE_QUICK_EDIT_MODE ) <> 0 )
	END_TEST
	#endif

	TEST( rfc0002_s9_cursor_sequences_are_one_based )
		CU_ASSERT_EQUAL( TuiCursorTo( 0, 0 ), chr( 27 ) & "[1;1H" )
		CU_ASSERT_EQUAL( TuiCursorTo( 4, 2 ), chr( 27 ) & "[3;5H" )
		CU_ASSERT_EQUAL( TuiCursorTo( 119, 29 ), chr( 27 ) & "[30;120H" )

		CU_ASSERT_EQUAL( TuiShowCursorSeq( TRUE ),  chr( 27 ) & "[?25h" )
		CU_ASSERT_EQUAL( TuiShowCursorSeq( FALSE ), chr( 27 ) & "[?25l" )
		CU_ASSERT_EQUAL( TuiClearScreenSeq( ), chr( 27 ) & "[2J" )
	END_TEST

	'' RFC-0002 sections 3 and 4. Under the harness stdout is redirected, so
	'' this is the NOT-A-TERMINAL path -- and it must be a clean, reported
	'' failure rather than a crash or a silent success. A program that draws a
	'' dashboard into a pipe is worse than one that says why it cannot.
	TEST( rfc0002_s3_redirected_stdout_is_not_a_terminal )
		dim as TuiTerminal term

		dim as TuiCaps c = term.Caps( )
		CU_ASSERT_FALSE( c.isTerminal )
		CU_ASSERT_EQUAL( c.depth, TUIDEPTH_MONO )

		'' Enter must FAIL, and must not leave the object thinking it is active
		dim as TuiUnitResult r = term.Enter( TuiTermOptionsDefault( ) )
		CU_ASSERT_FALSE( r.IsOk( ) )
		CU_ASSERT_EQUAL( r.Failure( ).code, TUIERR_NOTATTY )
		CU_ASSERT_FALSE( term.IsActive( ) )

		'' Leave on a terminal that never entered is a no-op, not an error
		CU_ASSERT_TRUE( term.Leave( ).IsOk( ) )

		'' and it is idempotent
		CU_ASSERT_TRUE( term.Leave( ).IsOk( ) )
		CU_ASSERT_FALSE( term.IsActive( ) )
	END_TEST

	'' RFC-0002 section 4. Size NEVER returns a zero or negative dimension. On
	'' Linux this is the fallback chain that exists because TIOCGWINSZ was
	'' measured SUCCEEDING and reporting 0x0 under a pty -- success is not a
	'' size.
	TEST( rfc0002_s4_size_is_never_zero )
		dim as TuiTerminal term
		dim as TuiSizeResult r = term.Size( )

		if( r.IsOk( ) ) then
			CU_ASSERT_TRUE( r.Value( ).cols > 0 )
			CU_ASSERT_TRUE( r.Value( ).rows > 0 )
		else
			'' a reported failure is equally acceptable -- what is not
			'' acceptable is Ok( 0 x 0 )
			CU_ASSERT_TRUE( r.Failure( ).code <> TUIERR_NONE )
		end if
	END_TEST

	'' RFC-0002 section 9. Write BUFFERS and Flush issues one OS write, so a
	'' full frame is one syscall rather than one per cell. Flush must also
	'' reset the pending count, or the next frame re-emits the last one.
	TEST( rfc0002_s9_writes_are_buffered_until_flush )
		dim as TuiTerminal term

		CU_ASSERT_EQUAL( term.Pending( ), 0 )
		term.Write( "hello" )
		CU_ASSERT_EQUAL( term.Pending( ), 5 )
		term.Write( " world" )
		CU_ASSERT_EQUAL( term.Pending( ), 11 )

		'' an empty write changes nothing
		term.Write( "" )
		CU_ASSERT_EQUAL( term.Pending( ), 11 )

		'' Discard drops the buffer without writing it
		term.Discard( )
		CU_ASSERT_EQUAL( term.Pending( ), 0 )

		'' Flush on an empty buffer is a no-op that still succeeds
		CU_ASSERT_TRUE ( term.Flush( ).IsOk( ) )
		CU_ASSERT_EQUAL( term.Pending( ), 0 )
	END_TEST

	'' RFC-0004 section 6. TakeResize CONSUMES the flag, so one resize is
	'' delivered once. With no resize pending it must report FALSE rather than
	'' synthesising an event.
	TEST( rfc0004_s6_takeresize_consumes_the_flag )
		dim as TuiTerminal term
		CU_ASSERT_FALSE( term.TakeResize( ) )
		CU_ASSERT_FALSE( term.TakeResize( ) )
	END_TEST

	'' The whole module composes: a screen rendered against a terminal that is
	'' not a terminal still produces correct BYTES. This is what makes the diff
	'' testable without a tty at all.
	TEST( phase1_render_composes_without_a_terminal )
		dim as TuiTerminal term
		dim as TuiScreen scr
		scr.Resize( 20, 3 )

		dim as TuiFrame ptr f = scr.BeginFrame( )
		f->DrawText( 1, 1, "hi", TuiStyleDefault( ) )
		dim as string bytes_ = scr.Render( term.Caps( ).depth )
		CU_ASSERT_TRUE( len( bytes_ ) > 0 )

		term.Write( bytes_ )
		CU_ASSERT_EQUAL( term.Pending( ), len( bytes_ ) )
		term.Discard( )

		'' second identical frame: still zero bytes, terminal or no terminal
		f = scr.BeginFrame( )
		f->DrawText( 1, 1, "hi", TuiStyleDefault( ) )
		CU_ASSERT_EQUAL( len( scr.Render( term.Caps( ).depth ) ), 0 )
	END_TEST

END_SUITE
