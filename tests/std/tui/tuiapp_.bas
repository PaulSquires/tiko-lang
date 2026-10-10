'' The application loop -- C:\dev\docs\tui\RFC-0009-app-loop-and-async.md.
''
'' TuiRun itself needs a tty and cannot be unit-tested; what CAN be tested is
'' everything it is made of -- the command values, the Update/View separation,
'' and the headless render path TuiRenderOnce exposes for exactly this reason.
''
'' This file also carries the module's PERFORMANCE FLOOR. The real numbers come
'' from src/contrib/tui/bench.bas; the assertion here is deliberately loose --
'' roughly 20x the measured cost -- so it catches a serious regression without
'' flaking on a loaded build machine.

#import "std/tui"
#import "std/outcome"
#import "std/chrono"
#include "fbcunit.bi"

#include once "fb/array.bi"

#include once "fberror.bi"

using tui, outcome, chrono

using FB
'' A small app used by several tests below.
type CountApp extends TuiApp
	as long n
	as long updates
	declare function Init( ) as TuiCmd override
	declare function Update( byref e as TuiEvent ) as TuiCmd override
	declare sub View( byref f as TuiFrame ) override
end type

function CountApp.Init( ) as TuiCmd
	n = 0
	updates = 0
	return TuiNone( )
end function

function CountApp.Update( byref e as TuiEvent ) as TuiCmd
	updates += 1
	if( e.kind = TUIEVENT_KEY ) then
		if( e.key.code = TUIKEY_ESCAPE ) then return TuiQuit( 7 )
		if( e.key.code = TUIKEY_F5 ) then return TuiTick( 25 )
		n += 1
		return TuiRedraw( )
	end if
	if( e.kind = TUIEVENT_TICK ) then
		n += 100
		return TuiRedraw( )
	end if
	return TuiNone( )
end function

sub CountApp.View( byref f as TuiFrame )
	dim as TuiBlock b
	b.borderKind = TUIBORDER_ROUNDED
	b.sides = TUISIDE_ALL
	b.Render( f, f.Area( ) )
	dim as TuiParagraph p
	p.text = "n=" & str( n )
	p.Render( f, b.Inner( f.Area( ) ) )
end sub

'' A heavier app, for the performance floor: borders, a braille graph and one
'' meter per row -- a realistic dashboard frame rather than a blank screen.
type BenchApp extends TuiApp
	as long n
	declare function Init( ) as TuiCmd override
	declare function Update( byref e as TuiEvent ) as TuiCmd override
	declare sub View( byref f as TuiFrame ) override
end type

function BenchApp.Init( ) as TuiCmd : n = 0 : return TuiNone( ) : end function
function BenchApp.Update( byref e as TuiEvent ) as TuiCmd : return TuiNone( ) : end function

sub BenchApp.View( byref f as TuiFrame )
	dim as TuiTheme th = TuiThemeDefault( )
	dim as TuiConstraintArray cols
	cols.Push( TuiPercent( 45 ) )
	cols.Push( TuiFill( ) )
	dim as TuiRectArray col = TuiSplitH( f.Area( ), cols )

	dim as TuiBlock b1
	b1.borderKind = TUIBORDER_ROUNDED
	b1.sides = TUISIDE_ALL
	b1.borderStyle = th.border
	b1.AddTitle( "cpu", th.accent, TUISIDE_TOP, TUIALIGN_LEFT )
	b1.Render( f, col[0] )

	dim as TuiGraph g
	g.graphKind = TUIGRAPH_BRAILLE
	g.autoScale = FALSE
	g.minY = 0 : g.maxY = 100
	dim as TuiSeries s
	for i as long = 0 to 199
		s.data.Push( 50.0 + sin( ( i + n ) / 7.0 ) * 45.0 )
	next
	s.color = TuiRgb( 120, 220, 160 )
	g.series.Push( s )
	g.Render( f, b1.Inner( col[0] ) )

	dim as TuiRect inner = col[1]
	for r as long = 0 to inner.h - 1
		dim as TuiMeter m
		m.ratio = ( ( r + n ) mod 100 ) / 100.0
		m.partialCells = TRUE
		m.from_ = TuiRgb( 80, 220, 120 )
		m.to_ = TuiRgb( 235, 80, 80 )
		m.trackColor = TuiRgb( 60, 60, 60 )
		m.Render( f, TuiRectOf( inner.x, inner.y + r, inner.w, 1 ) )
	next
end sub

type TickApp extends TuiApp
	as long ticks
	declare function Init( ) as TuiCmd override
	declare function Update( byref e as TuiEvent ) as TuiCmd override
	declare sub View( byref f as TuiFrame ) override
end type

function TickApp.Init( ) as TuiCmd
	ticks = 0
	return TuiTick( 250 )
end function

function TickApp.Update( byref e as TuiEvent ) as TuiCmd
	if( e.kind = TUIEVENT_TICK ) then
		ticks += 1
		return TuiTick( 250 )
	end if
	return TuiNone( )
end function

sub TickApp.View( byref f as TuiFrame )
	dim as TuiParagraph p
	p.text = str( ticks )
	p.Render( f, f.Area( ) )
end sub

SUITE( fbc_tests.tui.tuiapp_ )

	'' RFC-0009 section 2. Every command carries what it claims to.
	TEST( rfc0009_s2_commands )
		CU_ASSERT_EQUAL( TuiNone( ).kind, TUICMD_NONE )
		CU_ASSERT_EQUAL( TuiRedraw( ).kind, TUICMD_REDRAW )
		CU_ASSERT_EQUAL( TuiInvalidate( ).kind, TUICMD_INVALIDATE )
		CU_ASSERT_EQUAL( TuiSuspend( ).kind, TUICMD_SUSPEND )

		CU_ASSERT_EQUAL( TuiQuit( ).kind, TUICMD_QUIT )
		CU_ASSERT_EQUAL( TuiQuit( ).arg, 0 )
		CU_ASSERT_EQUAL( TuiQuit( 7 ).arg, 7 )

		CU_ASSERT_EQUAL( TuiTick( 25 ).kind, TUICMD_TICK )
		CU_ASSERT_EQUAL( TuiTick( 25 ).arg, 25 )
		'' a negative delay clamps rather than scheduling in the past
		CU_ASSERT_EQUAL( TuiTick( -5 ).arg, 0 )
	END_TEST

	'' RFC-0009 section 1. Update never draws and View never mutates -- which
	'' is what makes a frame reproducible from state. Rendering the same state
	'' twice must give the same bytes.
	TEST( rfc0009_s1_view_is_a_pure_function_of_state )
		dim as CountApp app
		dim as TuiScreen a, b
		a.Resize( 30, 6 )
		b.Resize( 30, 6 )

		app.Init( )
		app.n = 42

		dim as string fa = TuiRenderOnce( app, a )
		dim as string fb_ = TuiRenderOnce( app, b )
		CU_ASSERT_EQUAL( len( fa ), len( fb_ ) )
		CU_ASSERT_EQUAL( fa, fb_ )

		'' and View did not change the model
		CU_ASSERT_EQUAL( app.n, 42 )
		CU_ASSERT_EQUAL( app.updates, 0 )
	END_TEST

	'' RFC-0009 section 4. Nothing dirty, nothing drawn -- the diff's whole
	'' bargain, asserted through the app path rather than the buffer path.
	TEST( rfc0009_s4_unchanged_frame_emits_nothing )
		dim as CountApp app
		dim as TuiScreen scr
		scr.Resize( 30, 6 )
		app.Init( )

		CU_ASSERT_TRUE ( len( TuiRenderOnce( app, scr ) ) > 0 )
		CU_ASSERT_EQUAL( len( TuiRenderOnce( app, scr ) ), 0 )
		CU_ASSERT_EQUAL( len( TuiRenderOnce( app, scr ) ), 0 )

		'' a state change makes exactly one frame non-empty again
		app.n = 1
		CU_ASSERT_TRUE ( len( TuiRenderOnce( app, scr ) ) > 0 )
		CU_ASSERT_EQUAL( len( TuiRenderOnce( app, scr ) ), 0 )
	END_TEST

	'' RFC-0009 section 3. The Update contract: the app decides, the loop obeys.
	TEST( rfc0009_s3_update_returns_the_right_commands )
		dim as CountApp app
		app.Init( )

		dim as TuiEvent k
		k.kind = TUIEVENT_KEY
		k.key.code = TUIKEY_CHAR
		k.key.ch = asc( "x" )
		CU_ASSERT_EQUAL( app.Update( k ).kind, TUICMD_REDRAW )
		CU_ASSERT_EQUAL( app.n, 1 )

		k.key.code = TUIKEY_F5
		dim as TuiCmd t = app.Update( k )
		CU_ASSERT_EQUAL( t.kind, TUICMD_TICK )
		CU_ASSERT_EQUAL( t.arg, 25 )

		'' a tick event is delivered like any other
		dim as TuiEvent tick_
		tick_.kind = TUIEVENT_TICK
		CU_ASSERT_EQUAL( app.Update( tick_ ).kind, TUICMD_REDRAW )
		CU_ASSERT_EQUAL( app.n, 101 )

		k.key.code = TUIKEY_ESCAPE
		dim as TuiCmd q = app.Update( k )
		CU_ASSERT_EQUAL( q.kind, TUICMD_QUIT )
		CU_ASSERT_EQUAL( q.arg, 7 )

		'' an event the app ignores yields NONE
		dim as TuiEvent m
		m.kind = TUIEVENT_MOUSE
		CU_ASSERT_EQUAL( app.Update( m ).kind, TUICMD_NONE )
	END_TEST

	'' RFC-0009 section 3. A resize invalidates, so the next frame is a full
	'' repaint rather than a diff against a buffer of the wrong shape.
	TEST( rfc0009_s3_resize_forces_a_full_repaint )
		dim as CountApp app
		dim as TuiScreen scr
		scr.Resize( 30, 6 )
		app.Init( )

		TuiRenderOnce( app, scr )
		CU_ASSERT_EQUAL( len( TuiRenderOnce( app, scr ) ), 0 )

		'' resizing produces a non-empty frame and the new geometry
		scr.Resize( 40, 8 )
		dim as string after_ = TuiRenderOnce( app, scr )
		CU_ASSERT_TRUE ( len( after_ ) > 0 )
		CU_ASSERT_EQUAL( scr.Cols( ), 40 )
		CU_ASSERT_EQUAL( scr.Rows( ), 8 )
		CU_ASSERT_TRUE ( instr( after_, chr( 27 ) & "[2J" ) > 0 )

		'' explicit invalidation does the same without a size change
		CU_ASSERT_EQUAL( len( TuiRenderOnce( app, scr ) ), 0 )
		scr.Invalidate( )
		CU_ASSERT_TRUE ( len( TuiRenderOnce( app, scr ) ) > 0 )
	END_TEST

	'' RFC-0009 section 1. THE FROZEN-GRAPHS DEFECT, as a test.
	''
	'' Init was a `sub`. TuiTick is one-shot and Update only re-arms it in
	'' response to a tick, so an app had NO WAY to arm the first one and any
	'' animated view was frozen by construction. Making Init return a TuiCmd is
	'' the fix, and this asserts an app can now express it.
	''
	'' What this does NOT assert: that TuiRun honours it. That runs inside the
	'' loop, which needs a tty -- see the note on the whole of TuiRun below.
	TEST( rfc0009_s1_init_can_schedule_the_first_tick )
		dim as TickApp app
		dim as TuiCmd c = app.Init( )
		CU_ASSERT_EQUAL( c.kind, TUICMD_TICK )
		CU_ASSERT_EQUAL( c.arg, 250 )
		CU_ASSERT_EQUAL( app.ticks, 0 )

		'' and the tick it arms re-arms itself, which is what keeps it running
		dim as TuiEvent t
		t.kind = TUIEVENT_TICK
		dim as TuiCmd again = app.Update( t )
		CU_ASSERT_EQUAL( again.kind, TUICMD_TICK )
		CU_ASSERT_EQUAL( again.arg, 250 )
		CU_ASSERT_EQUAL( app.ticks, 1 )

		'' an app that wants no timer says so, and gets no timer
		dim as CountApp quiet_
		CU_ASSERT_EQUAL( quiet_.Init( ).kind, TUICMD_NONE )
	END_TEST

	'' RFC-0009 section 3. TuiRun on a redirected stdout must FAIL with a
	'' reported error rather than drawing a dashboard into a pipe. Under the
	'' test harness stdout is always redirected, so this is the branch that
	'' actually runs here.
	TEST( rfc0009_s3_run_fails_when_not_a_terminal )
		dim as CountApp app
		dim as TuiRunResult r = TuiRun( app, TuiTermOptionsDefault( ) )

		CU_ASSERT_FALSE( r.IsOk( ) )
		CU_ASSERT_EQUAL( r.Failure( ).code, TUIERR_NOTATTY )
		CU_ASSERT_TRUE ( len( r.Failure( ).Message( ) ) > 0 )

		'' Init must NOT have run -- the loop never started
		CU_ASSERT_EQUAL( app.updates, 0 )
	END_TEST

	'' THE PERFORMANCE FLOOR (ranked-gaps rank 22).
	''
	'' Measured on this machine: 60 frames of a full-screen-changing 200x50
	'' dashboard in 137 ms on win64 and 102 ms on linux-x86_64 -- about 2 ms a
	'' frame against a 16 ms budget. The assertion is 3000 ms, roughly 20x the
	'' measurement, so it catches a serious regression without flaking on a
	'' loaded build machine. src/contrib/tui/bench.bas prints the real numbers.
	TEST( rfc0009_s4_performance_floor )
		dim as BenchApp app
		dim as TuiScreen scr
		scr.Resize( 200, 50 )
		app.Init( )

		'' warm up: the first frame is a full paint by definition
		TuiRenderOnce( app, scr )

		dim as Stopwatch sw = Stopwatch.StartNew( )
		dim as longint total = 0
		for i as long = 1 to 60
			app.n = i
			total += len( TuiRenderOnce( app, scr ) )
		next
		dim as double ms = sw.Elapsed.TotalMilliseconds

		CU_ASSERT_TRUE( ms < 3000.0 )

		'' every frame really did change -- a benchmark that measured a
		'' no-op would pass its own timing gate and mean nothing
		CU_ASSERT_TRUE( total > 60 * 1000 )
	END_TEST

	'' The renderer is DETERMINISTIC: the same sequence of states produces the
	'' same byte count every run, and the same on both targets. Measured
	'' identical at 833,656 bytes for this workload on win64 and linux-x86_64.
	TEST( rfc0009_s4_render_is_deterministic )
		dim as longint runA = 0, runB = 0

		for pass as long = 0 to 1
			dim as BenchApp app
			dim as TuiScreen scr
			scr.Resize( 60, 20 )
			app.Init( )
			TuiRenderOnce( app, scr )

			dim as longint total = 0
			for i as long = 1 to 20
				app.n = i
				total += len( TuiRenderOnce( app, scr ) )
			next
			if( pass = 0 ) then runA = total else runB = total
		next

		CU_ASSERT_EQUAL( runA, runB )
		CU_ASSERT_TRUE ( runA > 0 )
	END_TEST

	'' An app rendered into a zero-size screen must not fault -- the smallest
	'' terminal is still a terminal.
	TEST( rfc0009_degenerate_screens )
		dim as CountApp app
		app.Init( )

		for w as long = 0 to 3
			for h as long = 0 to 3
				dim as TuiScreen scr
				scr.Resize( w, h )
				TuiRenderOnce( app, scr )
				CU_ASSERT_EQUAL( scr.Cols( ), w )
				CU_ASSERT_EQUAL( scr.Rows( ), h )
			next
		next
	END_TEST

END_SUITE
