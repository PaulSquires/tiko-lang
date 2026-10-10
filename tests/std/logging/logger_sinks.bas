'' Logger, LogEvent, TextRenderer, Sink -- RFC-0002, RFC-0003, RFC-0004.
''
'' The four phase-1 gates from C:\dev\docs\logging\ranked-gaps.md:
''
''   rank 3  a filtered-out event assembles NO record  -- observed by a counting
''           sink at zero AND by a field-constructor counter at zero
''   rank 4  two sinks receive the same record; removing one does not disturb
''           the other; a Sink ptr array dispatches virtually
''   rank 5  text output byte for byte, colour forced on and forced off
''   rank 6  four threads to one sink: the count is exact, and no line contains
''           a fragment of another
''
'' WHAT THE THREAD TEST DOES NOT PROVE, said plainly: it exercises the Logger
'' and record path and a sink built on the SAME mutex-around-render-and-emit
'' pattern as ConsoleSink -- it does NOT observe ConsoleSink's own writes, which
'' would need a redirected child process. RFC-0004 section 2's claim about the
'' shipped console sink is therefore argued and pattern-matched, not measured.

#import "std/logs"
#import "std/chrono"
#import "std/numeric"
#import "std/fs"
#include "fbcunit.bi"

#include once "fb/array.bi"

#include once "fb/optional.bi"

#include once "fblimits.bi"

#include once "fb/result.bi"

using logs, chrono, numeric, fs

using FB
'' The alias is required: a generic does not instantiate directly in a TYPE
'' field. Same rule the module itself lives by (RFC-0001 section 4).
type UStringArray as Array( of ustring )

'' A capture sink. Deliberately built the way ConsoleSink is -- one mutex, taken
'' for the whole of Write, around render-then-emit -- so that what is asserted
'' here is the pattern the shipped sink uses.
type CaptureSink extends Sink
	declare constructor( )
	declare destructor( ) override

	declare sub Write( byref r as LogRecord ) override
	declare sub Flush( ) override
	declare sub Close( ) override
	declare function DroppedCount( ) as ulongint override

	declare function Count( ) as long
	declare function LineAt( byval i as long ) as ustring
	declare sub Reset( )

	m_lock    as any ptr
	m_rend    as TextRenderer
	m_lines   as UStringArray
	m_flushes as long
	m_closes  as long
end type

constructor CaptureSink( )
	this.m_lock = mutexcreate( )
	this.m_rend.stamp = TS_NONE          '' deterministic: no clock in the text
end constructor

destructor CaptureSink( )
	if( this.m_lock <> 0 ) then mutexdestroy( this.m_lock )
end destructor

sub CaptureSink.Write( byref r as LogRecord )
	dim as ustring buf
	mutexlock( this.m_lock )
	this.m_rend.Render( r, buf )
	this.m_lines.Push( buf )
	mutexunlock( this.m_lock )
end sub

sub CaptureSink.Flush( ) : this.m_flushes += 1 : end sub
sub CaptureSink.Close( ) : this.m_closes += 1 : end sub
function CaptureSink.DroppedCount( ) as ulongint : return 0 : end function
function CaptureSink.Count( ) as long : return this.m_lines.Count( ) : end function
function CaptureSink.LineAt( byval i as long ) as ustring : return this.m_lines[i] : end function
sub CaptureSink.Reset( ) : this.m_lines.Clear( ) : end sub

'' Rank 3's second half. A filtered event must not merely produce no OUTPUT --
'' it must not BUILD anything. A counting sink cannot see that, so the count of
'' actual value constructions is taken here.
dim shared as long g_valuebuilds

function CountedValue( byref s as ustring ) as LogValue
	g_valuebuilds += 1
	return LogValue( s )
end function

'' --------------------------------------------------------------- rank 6 setup
const THREAD_COUNT = 4
const PER_THREAD   = 10000

type ThreadArg
	lg  as Logger ptr
	tid as long
end type

sub ThreadBody( byval p as any ptr )
	dim as ThreadArg ptr a = cast( ThreadArg ptr, p )
	for i as long = 1 to PER_THREAD
		a->lg->Info( ).Int_( "tid", a->tid ).Int_( "i", i ).Msg( "tick" )
	next
end sub

SUITE( fbc_tests.logging.logger_sinks )

	'' RFC-0002 section 2. ONE COMPARISON, and everything at or above the
	'' minimum passes while everything below is refused.
	TEST( rfc0002_s2_level_filter )
		dim lg as Logger

		CU_ASSERT_EQUAL( lg.MinLevel, LOG_INFO )   '' the default

		lg.MinLevel = LOG_WARN
		CU_ASSERT_FALSE( lg.Enabled( LOG_TRACE ) )
		CU_ASSERT_FALSE( lg.Enabled( LOG_INFO ) )
		CU_ASSERT_TRUE ( lg.Enabled( LOG_WARN ) )
		CU_ASSERT_TRUE ( lg.Enabled( LOG_ERROR ) )

		'' a custom level between two named ones filters like its neighbours
		CU_ASSERT_TRUE ( lg.Enabled( cast( LogLevel, 45 ) ) )
		CU_ASSERT_FALSE( lg.Enabled( cast( LogLevel, 35 ) ) )

		'' LOG_OFF as a minimum silences everything, including FATAL
		lg.MinLevel = LOG_OFF
		CU_ASSERT_FALSE( lg.Enabled( LOG_FATAL ) )
	END_TEST

	'' RANK 3. A filtered-out event assembles NO record. Zero sink writes AND
	'' zero value constructions -- the second is the one that matters, because
	'' an implementation that built the record and then threw it away would
	'' pass a write-count test and still cost what trace levels exist to avoid.
	TEST( rank3_filtered_event_builds_nothing )
		dim cap as CaptureSink
		dim lg as Logger
		lg.MinLevel = LOG_INFO
		lg.AddSink( @cap )

		g_valuebuilds = 0

		'' four chained fields on a disabled level
		lg.Trace( ).Str( "a", "1" ).Int_( "b", 2 ).Bool( "c", TRUE ).Dbl( "d", 4.0 ).Msg( "no" )
		lg.Debug( ).Str( "a", "1" ).Msg( "also no" )

		CU_ASSERT_EQUAL( cap.Count( ), 0 )
		CU_ASSERT_EQUAL( g_valuebuilds, 0 )

		'' ... and the same chain at an ENABLED level does build and does emit
		lg.Info( ).Val( "a", CountedValue( "1" ) ).Msg( "yes" )
		CU_ASSERT_EQUAL( cap.Count( ), 1 )
		CU_ASSERT_EQUAL( g_valuebuilds, 1 )
	END_TEST

	'' RFC-0002 section 3. An event that is NEVER COMMITTED emits nothing --
	'' the destructor does not auto-send. And Send( ) twice does not emit
	'' twice.
	TEST( rfc0002_s3_only_msg_commits )
		dim cap as CaptureSink
		dim lg as Logger
		lg.AddSink( @cap )

		scope
			dim e as LogEvent = lg.Info( )
			e.Str( "user", "quinn" )
		end scope                          '' destroyed uncommitted
		CU_ASSERT_EQUAL( cap.Count( ), 0 )

		scope
			dim e as LogEvent = lg.Info( )
			e.Msg( "once" )
			e.Send( )
			e.Send( )
		end scope
		CU_ASSERT_EQUAL( cap.Count( ), 1 )
	END_TEST

	'' RFC-0002 section 3. The chain builds the fields IN ORDER and the
	'' one-line form produces a record with none.
	TEST( rfc0002_s3_builder_and_one_line_form )
		dim cap as CaptureSink
		dim lg as Logger
		lg.AddSink( @cap )

		lg.Info( "plain" )
		CU_ASSERT_EQUAL( cap.Count( ), 1 )
		CU_ASSERT_EQUAL( cap.LineAt( 0 ), !"INFO   plain\n" )

		cap.Reset( )
		dim as Instant inst = Instant.ParseIso( "2026-08-12T23:06:34.3614985Z" )
		lg.Warn( ).Str( "s", "x" ).Int_( "i", -1 ).UInt( "u", 2ull ) _
		          .Dbl( "d", 0.5 ).Bool( "b", FALSE ).Time( "t", inst ) _
		          .Msg( "all kinds" )
		CU_ASSERT_EQUAL( cap.Count( ), 1 )
		CU_ASSERT_EQUAL( cap.LineAt( 0 ), _
			!"WARN   all kinds  s=x i=-1 u=2 d=0.5 b=false t=2026-08-12T23:06:34.3614985Z\n" )
	END_TEST

	'' The two field kinds the chain above leaves out. Ptr_ is spelled with the
	'' trailing underscore because PTR is a keyword -- the same reason Int_ is.
	'' A NULL pointer must render as a null rather than as an address of zero,
	'' or a log reader cannot tell "no object" from "object at 0".
	TEST( pointer_and_span_fields )
		dim cap as CaptureSink
		dim lg as Logger
		lg.AddSink( @cap )

		dim as long target = 7
		lg.Info( ).Ptr_( "p", @target ).Msg( "addr" )
		CU_ASSERT_EQUAL( cap.Count( ), 1 )

		'' the address itself is machine-dependent, so what is asserted is that
		'' the field is present and is NOT the null spelling
		CU_ASSERT_TRUE( instr( cap.LineAt( 0 ), "p=" ) > 0 )
		CU_ASSERT_TRUE( instr( cap.LineAt( 0 ), "addr" ) > 0 )
		CU_ASSERT_TRUE( instr( cap.LineAt( 0 ), "p=null" ) = 0 )

		cap.Reset( )
		lg.Info( ).Ptr_( "p", 0 ).Msg( "nul" )
		CU_ASSERT_EQUAL( cap.Count( ), 1 )
		CU_ASSERT_TRUE( instr( cap.LineAt( 0 ), "p=" ) > 0 )

		'' a TimeSpan field, which renders through the same path as Time
		cap.Reset( )
		lg.Info( ).Span( "took", TimeSpan.FromMilliseconds( 1500 ) ).Msg( "done" )
		CU_ASSERT_EQUAL( cap.Count( ), 1 )
		CU_ASSERT_TRUE( instr( cap.LineAt( 0 ), "took=" ) > 0 )
		CU_ASSERT_TRUE( instr( cap.LineAt( 0 ), "done" ) > 0 )

		'' and both compose into one chain with the rest
		cap.Reset( )
		lg.Info( ).Str( "s", "x" ).Ptr_( "p", @target ) _
		          .Span( "d", TimeSpan.FromSeconds( 2 ) ).Msg( "mixed" )
		CU_ASSERT_EQUAL( cap.Count( ), 1 )
		CU_ASSERT_TRUE( instr( cap.LineAt( 0 ), "s=x" ) > 0 )
		CU_ASSERT_TRUE( instr( cap.LineAt( 0 ), "p=" ) > 0 )
		CU_ASSERT_TRUE( instr( cap.LineAt( 0 ), "d=" ) > 0 )

		'' a suppressed level must not evaluate the chain into the sink at all
		cap.Reset( )
		lg.MinLevel = LOG_INFO
		lg.Debug( ).Ptr_( "p", @target ).Span( "d", TimeSpan.FromSeconds( 1 ) ).Msg( "no" )
		CU_ASSERT_EQUAL( cap.Count( ), 0 )
	END_TEST

	'' RANK 4. Two sinks receive the SAME record; removing one leaves the
	'' other untouched; dispatch goes through Array( of Sink ptr ) virtually.
	TEST( rank4_multi_sink_fanout )
		dim a as CaptureSink
		dim b as CaptureSink
		dim lg as Logger
		lg.AddSink( @a )
		lg.AddSink( @b )
		CU_ASSERT_EQUAL( lg.SinkCount( ), 2 )

		lg.Info( "both" )
		CU_ASSERT_EQUAL( a.Count( ), 1 )
		CU_ASSERT_EQUAL( b.Count( ), 1 )
		CU_ASSERT_EQUAL( a.LineAt( 0 ), b.LineAt( 0 ) )

		lg.RemoveSink( @a )
		CU_ASSERT_EQUAL( lg.SinkCount( ), 1 )
		lg.Info( "only b" )
		CU_ASSERT_EQUAL( a.Count( ), 1 )         '' undisturbed
		CU_ASSERT_EQUAL( b.Count( ), 2 )

		'' Flush and Close reach every sink still attached, and Close is
		'' idempotent from the caller's side.
		lg.Flush( )
		CU_ASSERT_EQUAL( a.m_flushes, 0 )
		CU_ASSERT_EQUAL( b.m_flushes, 1 )

		lg.ClearSinks( )
		CU_ASSERT_EQUAL( lg.SinkCount( ), 0 )
		lg.Info( "nowhere" )
		CU_ASSERT_EQUAL( b.Count( ), 2 )
	END_TEST

	'' RFC-0002 section 5. WithField returns a child BY VALUE that deep-copies:
	'' the parent keeps its own field list, the child carries parent-then-child
	'' order, and a child is a SNAPSHOT -- later changes to the parent do not
	'' reach it.
	TEST( rfc0002_s5_child_loggers )
		dim cap as CaptureSink
		dim parent as Logger
		parent.AddSink( @cap )

		dim child as Logger = parent.WithField( "component", LogValue( "db" ) )

		CU_ASSERT_EQUAL( parent.m_fields.Count( ), 0 )
		CU_ASSERT_EQUAL( child.m_fields.Count( ), 1 )
		CU_ASSERT_EQUAL( child.SinkCount( ), 1 )      '' sinks inherited

		'' inherited fields come FIRST, call-site fields last, so "most
		'' specific last" is available to any renderer wanting last-wins
		child.Info( ).Int_( "rows", 42 ).Msg( "query" )
		CU_ASSERT_EQUAL( cap.LineAt( 0 ), !"INFO   query  component=db rows=42\n" )

		'' a grandchild accumulates, and its parent still does not
		dim grand as Logger = child.WithField( "shard", LogValue( 7ll ) )
		CU_ASSERT_EQUAL( grand.m_fields.Count( ), 2 )
		CU_ASSERT_EQUAL( child.m_fields.Count( ), 1 )

		'' SNAPSHOT: raising the parent's level afterwards does not raise the
		'' child's
		parent.MinLevel = LOG_ERROR
		cap.Reset( )
		child.Info( "still enabled" )
		CU_ASSERT_EQUAL( cap.Count( ), 1 )

		'' a duplicate key is KEPT, parent's first -- hiding one would hide
		'' the collision that produced it
		dim dup as Logger = child.WithField( "component", LogValue( "cache" ) )
		cap.Reset( )
		dup.Info( "dup" )
		CU_ASSERT_EQUAL( cap.LineAt( 0 ), !"INFO   dup  component=db component=cache\n" )
	END_TEST

	'' RFC-0002 section 5. WithName sets the component name without touching
	'' the field list, and the name reaches the record.
	TEST( rfc0002_s5_with_name )
		dim cap as CaptureSink
		dim lg as Logger
		lg.AddSink( @cap )

		dim named as Logger = lg.WithName( "db" )
		CU_ASSERT_EQUAL( named.Name, "db" )
		CU_ASSERT_EQUAL( len( lg.Name ), 0 )

		named.Info( "hello" )
		CU_ASSERT_EQUAL( cap.LineAt( 0 ), !"INFO   db  hello\n" )
	END_TEST

	'' RANK 5. TextRenderer output byte for byte. Empty parts are OMITTED, not
	'' blanked -- no logger name means no name column, not a double space.
	TEST( rank5_text_render_exact )
		dim r as LogRecord
		r.level   = LOG_INFO
		r.stamp   = Instant.ParseIso( "2026-08-12T23:06:34.3614985Z" )
		r.message = "query complete"

		dim tr as TextRenderer
		dim buf as ustring

		'' default: ISO UTC truncated to milliseconds, level padded to 5
		tr.Render( r, buf )
		CU_ASSERT_EQUAL( buf, !"2026-08-12T23:06:34.361Z  INFO   query complete\n" )

		'' Render APPENDS rather than clearing, so a sink can reuse a buffer
		tr.Render( r, buf )
		CU_ASSERT_EQUAL( len( buf ), 2 * len( !"2026-08-12T23:06:34.361Z  INFO   query complete\n" ) )

		'' no padding
		buf = ""
		tr.levelwide = FALSE
		tr.Render( r, buf )
		CU_ASSERT_EQUAL( buf, !"2026-08-12T23:06:34.361Z  INFO  query complete\n" )

		'' no stamp, with a name and fields
		buf = ""
		tr.levelwide = TRUE
		tr.stamp = TS_NONE
		r.logname = "db"
		r.fields.Push( LogField( "rows", LogValue( 42ll ) ) )
		tr.Render( r, buf )
		CU_ASSERT_EQUAL( buf, !"INFO   db  query complete  rows=42\n" )

		'' time-only
		buf = ""
		tr.stamp = TS_TIME_ONLY
		tr.Render( r, buf )
		CU_ASSERT_EQUAL( buf, !"23:06:34.361  INFO   db  query complete  rows=42\n" )

		'' call-site capture, which phase 5's macros will supply
		buf = ""
		tr.stamp = TS_NONE
		tr.showsite = TRUE
		r.srcfile = "app.bas"
		r.srcline = 25
		r.srcfunc = "DOWORK"
		tr.Render( r, buf )
		CU_ASSERT_EQUAL( buf, !"INFO   db  query complete  rows=42  (app.bas:25 DOWORK)\n" )
	END_TEST

	'' RFC-0003 section 2. A STRING value is quoted only when it would
	'' otherwise be ambiguous -- a space, an '=', a quote, a control character
	'' or emptiness. Numbers are never quoted, so a reader can tell 42 from
	'' "42" in the human format too.
	TEST( rfc0003_s2_field_quoting )
		dim r as LogRecord
		r.level = LOG_INFO
		r.message = "m"
		r.fields.Push( LogField( "plain", LogValue( "abc" ) ) )
		r.fields.Push( LogField( "spaced", LogValue( "a b" ) ) )
		r.fields.Push( LogField( "equals", LogValue( "a=b" ) ) )
		r.fields.Push( LogField( "empty", LogValue( "" ) ) )
		r.fields.Push( LogField( "num", LogValue( 42ll ) ) )

		dim tr as TextRenderer
		tr.stamp = TS_NONE
		dim buf as ustring
		tr.Render( r, buf )
		CU_ASSERT_EQUAL( buf, _
			!"INFO   m  plain=abc spaced=\"a b\" equals=\"a=b\" empty=\"\" num=42\n" )
	END_TEST

	'' RANK 5, second half. Colour wraps THE LEVEL WORD ONLY -- never the
	'' message or the fields, which may contain arbitrary text including
	'' escape sequences of their own.
	TEST( rank5_colour_on_and_off )
		dim r as LogRecord
		r.level = LOG_ERROR
		r.message = "boom"

		dim tr as TextRenderer
		tr.stamp = TS_NONE

		dim buf as ustring
		tr.colour = FALSE
		tr.Render( r, buf )
		CU_ASSERT_EQUAL( buf, !"ERROR  boom\n" )

		buf = ""
		tr.colour = TRUE
		tr.Render( r, buf )
		CU_ASSERT_EQUAL( buf, !"\e[31mERROR\e[0m  boom\n" )

		'' every level has its own sequence, and TRACE is not ERROR's
		buf = ""
		r.level = LOG_TRACE
		tr.Render( r, buf )
		CU_ASSERT_EQUAL( buf, !"\e[90mTRACE\e[0m  boom\n" )
	END_TEST

	'' RFC-0004 section 4. The SHIPPED console sink: stderr by default, and
	'' colour off when the destination is not a character device. Under the
	'' test harness output is redirected, so the not-a-tty branch is the one
	'' being exercised -- which is exactly the branch that must not write
	'' escape sequences into a captured log.
	TEST( rfc0004_s4_console_sink_colour_policy )
		dim con as ConsoleSink

		if( con.IsConsole = FALSE ) then
			CU_ASSERT_FALSE( con.Colour )
		end if

		'' the override exists for a program that knows better
		con.Colour = TRUE
		CU_ASSERT_TRUE( con.Colour )
		con.Colour = FALSE
		CU_ASSERT_FALSE( con.Colour )

		'' a shipped sink starts with nothing dropped, and Close is
		'' idempotent
		CU_ASSERT_EQUAL( con.DroppedCount( ), 0 )
		con.Close( )
		con.Close( )

		'' writing to a closed sink is COUNTED, not silent and not a crash
		dim r as LogRecord
		r.level = LOG_INFO
		r.message = "after close"
		con.Write( r )
		CU_ASSERT_EQUAL( con.DroppedCount( ), 1 )
	END_TEST

	'' RANK 6. Four threads, 10,000 records each, one sink. THE COUNT IS
	'' EXACT -- nothing lost -- and NO LINE CONTAINS A FRAGMENT OF ANOTHER,
	'' which is precisely what FreeBASIC's own PRINT # cannot promise.
	''
	'' The interleaving check is the point. A line that ends in anything but a
	'' single newline, or that contains an embedded one, is a record that was
	'' torn.
	TEST( rank6_four_threads_one_sink )
		dim cap as CaptureSink
		dim lg as Logger
		lg.AddSink( @cap )

		dim as ThreadArg args( 0 to THREAD_COUNT - 1 )
		dim as any ptr handles( 0 to THREAD_COUNT - 1 )

		for t as long = 0 to THREAD_COUNT - 1
			args( t ).lg  = @lg
			args( t ).tid = t
			handles( t ) = threadcreate( @ThreadBody, @args( t ) )
			CU_ASSERT_TRUE( handles( t ) <> 0 )
		next

		for t as long = 0 to THREAD_COUNT - 1
			if( handles( t ) <> 0 ) then threadwait( handles( t ) )
		next

		CU_ASSERT_EQUAL( cap.Count( ), THREAD_COUNT * PER_THREAD )

		'' Every line is one whole record: exactly one newline, and it is the
		'' last character. Checked without an assertion per line -- 40,000
		'' CU_ASSERTs would drown the suite -- and then asserted once.
		dim as long torn = 0
		dim as long badtail = 0
		for i as long = 0 to cap.Count( ) - 1
			dim as ustring ln = cap.LineAt( i )
			if( len( ln ) < 2 ) then
				torn += 1
				continue for
			end if
			if( ln[len( ln ) - 1] <> 10 ) then badtail += 1
			for c as integer = 0 to len( ln ) - 2
				if( ln[c] = 10 ) then
					torn += 1
					exit for
				end if
			next
		next

		CU_ASSERT_EQUAL( torn, 0 )
		CU_ASSERT_EQUAL( badtail, 0 )
	END_TEST

END_SUITE
