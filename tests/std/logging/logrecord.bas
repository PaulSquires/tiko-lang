'' The value layer -- C:\dev\docs\logging\RFC-0001-record.md.
''
'' One TEST block per numbered rule of the RFC, named after it, so a failure
'' names the rule it broke.
''
'' Nothing here does I/O or takes a lock: RFC-0001 says every operation in this
'' layer is TOTAL, and the point of the file is to hold that claim.

#import "std/logs"
#import "std/chrono"
#import "std/numeric"
#import "std/fs"
#import "std/outcome"
#include "fbcunit.bi"

#include once "fb/array.bi"

#include once "fblimits.bi"

#include once "fberror.bi"

using logs, chrono, numeric, fs, outcome

using FB
SUITE( fbc_tests.logging.logrecord_ )

	'' RFC-0001 section 1. The layout the compiler FORCED. A ustring inside
	'' the UNION is `error 161: Var-len strings cannot be part of UNION's`, so
	'' the string sits outside it and every LogValue pays for a descriptor it
	'' usually does not use.
	''
	'' 40 is asserted rather than described because it is the number the RFC
	'' quotes and the reason LogEvent reserves its field array in one go. If a
	'' later change makes it move, this test is where that gets noticed.
	TEST( rfc0001_s1_logvalue_layout )
		CU_ASSERT_EQUAL( sizeof( LogValue ), 40 )

		'' LK_NULL is tag 0, so a default-constructed value is a valid null
		'' and never an uninitialised read.
		dim v as LogValue
		CU_ASSERT_EQUAL( v.kind, LK_NULL )
		CU_ASSERT_EQUAL( LogValueToText( v ), "null" )
	END_TEST

	'' RFC-0001 section 1. Every one of the nine constructors round-trips its
	'' TAG and its VALUE. A constructor that sets the right tag and loses the
	'' value would pass any test that only looked at the text.
	TEST( rfc0001_s1_every_constructor_round_trips )
		dim as ustring su = "quinn"

		dim vb as LogValue = LogValue( TRUE )
		CU_ASSERT_EQUAL( vb.kind, LK_BOOL )
		CU_ASSERT_TRUE ( vb.b )

		dim vi as LogValue = LogValue( -9223372036854775807ll )
		CU_ASSERT_EQUAL( vi.kind, LK_INT )
		CU_ASSERT_EQUAL( vi.i, -9223372036854775807ll )

		dim vu as LogValue = LogValue( 18446744073709551615ull )
		CU_ASSERT_EQUAL( vu.kind, LK_UINT )
		CU_ASSERT_EQUAL( vu.u, 18446744073709551615ull )

		dim vd as LogValue = LogValue( 3.5 )
		CU_ASSERT_EQUAL( vd.kind, LK_DBL )
		CU_ASSERT_DOUBLE_EXACT( vd.d, 3.5 )

		dim vs as LogValue = LogValue( su )
		CU_ASSERT_EQUAL( vs.kind, LK_STR )
		CU_ASSERT_EQUAL( vs.s, su )

		dim as long anchor = 7
		dim vp as LogValue = LogValue( cast( any ptr, @anchor ) )
		CU_ASSERT_EQUAL( vp.kind, LK_PTR )
		CU_ASSERT_EQUAL( vp.p, cast( any ptr, @anchor ) )

		dim as Instant inst = Instant( 638000000000000000ll )
		dim vt as LogValue = LogValue( inst )
		CU_ASSERT_EQUAL( vt.kind, LK_INSTANT )
		CU_ASSERT_EQUAL( vt.tk, inst.Ticks )

		dim as TimeSpan ts = TimeSpan.FromMilliseconds( 13.4 )
		dim vsp as LogValue = LogValue( ts )
		CU_ASSERT_EQUAL( vsp.kind, LK_TIMESPAN )
		CU_ASSERT_EQUAL( vsp.tk, ts.Ticks )
	END_TEST

	'' RFC-0001 section 2. The tag set is CLOSED -- nine tags, no tenth, so a
	'' renderer can switch over it with no `case else` meaning "I do not know
	'' what this is". Asserted by value so that inserting a tag in the middle
	'' (which would renumber the rest) fails here rather than silently
	'' changing what an old record means.
	TEST( rfc0001_s2_tag_set_is_closed_and_ordered )
		CU_ASSERT_EQUAL( LK_NULL, 0 )
		CU_ASSERT_EQUAL( LK_BOOL, 1 )
		CU_ASSERT_EQUAL( LK_INT, 2 )
		CU_ASSERT_EQUAL( LK_UINT, 3 )
		CU_ASSERT_EQUAL( LK_DBL, 4 )
		CU_ASSERT_EQUAL( LK_STR, 5 )
		CU_ASSERT_EQUAL( LK_PTR, 6 )
		CU_ASSERT_EQUAL( LK_INSTANT, 7 )
		CU_ASSERT_EQUAL( LK_TIMESPAN, 8 )
	END_TEST

	'' RFC-0001 section 3. SPACED BY TEN, so a program can put its own level
	'' between two of these and have every comparison keep working. The gap is
	'' the feature; asserting the values is asserting the gap.
	TEST( rfc0001_s3_levels_are_spaced_by_ten )
		CU_ASSERT_EQUAL( LOG_TRACE, 10 )
		CU_ASSERT_EQUAL( LOG_DEBUG, 20 )
		CU_ASSERT_EQUAL( LOG_INFO, 30 )
		CU_ASSERT_EQUAL( LOG_WARN, 40 )
		CU_ASSERT_EQUAL( LOG_ERROR, 50 )
		CU_ASSERT_EQUAL( LOG_FATAL, 60 )
		CU_ASSERT_EQUAL( LOG_OFF, 1000 )

		'' and the ordering every filter depends on
		CU_ASSERT_TRUE( LOG_TRACE < LOG_DEBUG )
		CU_ASSERT_TRUE( LOG_ERROR < LOG_FATAL )
		CU_ASSERT_TRUE( LOG_FATAL < LOG_OFF )
	END_TEST

	'' RFC-0001 section 3. An unnamed intermediate level renders as its
	'' NUMBER -- never an empty string and never a runtime error. Custom
	'' levels are supported by construction, so a renderer must be able to
	'' print one it has never heard of.
	TEST( rfc0001_s3_level_names )
		CU_ASSERT_EQUAL( LevelName( LOG_TRACE ), "TRACE" )
		CU_ASSERT_EQUAL( LevelName( LOG_WARN ), "WARN" )
		CU_ASSERT_EQUAL( LevelName( LOG_FATAL ), "FATAL" )
		CU_ASSERT_EQUAL( LevelNameShort( LOG_INFO ), "INF" )
		CU_ASSERT_EQUAL( LevelNameShort( LOG_ERROR ), "ERR" )

		CU_ASSERT_EQUAL( LevelName( cast( LogLevel, 35 ) ), "35" )
		CU_ASSERT_TRUE ( len( LevelName( cast( LogLevel, 35 ) ) ) > 0 )
	END_TEST

	'' RFC-0001 section 3. Parsing accepts the long form, the short form and a
	'' bare number, case-insensitively -- so FB_LOG=warn, FB_LOG=WRN and
	'' FB_LOG=40 all mean the same thing (RFC-0002 section 9).
	''
	'' AND IT REJECTS RUBBISH WITHOUT TOUCHING THE OUT-PARAMETER: a typo in an
	'' environment variable must not silently turn logging off.
	TEST( rfc0001_s3_level_parsing )
		dim as LogLevel lv

		CU_ASSERT_TRUE ( LevelFromName( "warn", lv ) )
		CU_ASSERT_EQUAL( lv, LOG_WARN )
		CU_ASSERT_TRUE ( LevelFromName( "WARNING", lv ) )
		CU_ASSERT_EQUAL( lv, LOG_WARN )
		CU_ASSERT_TRUE ( LevelFromName( "wrn", lv ) )
		CU_ASSERT_EQUAL( lv, LOG_WARN )
		CU_ASSERT_TRUE ( LevelFromName( "  Trace  ", lv ) )
		CU_ASSERT_EQUAL( lv, LOG_TRACE )
		CU_ASSERT_TRUE ( LevelFromName( "45", lv ) )
		CU_ASSERT_EQUAL( lv, cast( LogLevel, 45 ) )
		CU_ASSERT_TRUE ( LevelFromName( "off", lv ) )
		CU_ASSERT_EQUAL( lv, LOG_OFF )

		lv = LOG_INFO
		CU_ASSERT_FALSE( LevelFromName( "zzz", lv ) )
		CU_ASSERT_EQUAL( lv, LOG_INFO )
		CU_ASSERT_FALSE( LevelFromName( "", lv ) )
		CU_ASSERT_EQUAL( lv, LOG_INFO )
		CU_ASSERT_FALSE( LevelFromName( "4x", lv ) )
		CU_ASSERT_EQUAL( lv, LOG_INFO )
	END_TEST

	'' RFC-0001 section 3. The documented LOSSY direction: Notice(5),
	'' Alert(1) and Emergency(0) have no source level, and every six-level
	'' library makes the same choice. Intermediate levels map by threshold,
	'' which is what makes a custom level usable by a syslog sink.
	TEST( rfc0001_s3_syslog_mapping )
		CU_ASSERT_EQUAL( LevelToSyslog( LOG_TRACE ), 7 )
		CU_ASSERT_EQUAL( LevelToSyslog( LOG_DEBUG ), 7 )
		CU_ASSERT_EQUAL( LevelToSyslog( LOG_INFO ), 6 )
		CU_ASSERT_EQUAL( LevelToSyslog( LOG_WARN ), 4 )
		CU_ASSERT_EQUAL( LevelToSyslog( LOG_ERROR ), 3 )
		CU_ASSERT_EQUAL( LevelToSyslog( LOG_FATAL ), 2 )

		'' a level between WARN and ERROR is a warning, not an error
		CU_ASSERT_EQUAL( LevelToSyslog( cast( LogLevel, 45 ) ), 4 )
	END_TEST

	'' RFC-0001 section 4. The ALIAS IS REQUIRED, not stylistic: a generic
	'' does not instantiate directly in a TYPE field. This test exists because
	'' the aliased form compiling is the load-bearing fact behind the whole
	'' field-carrier decision.
	TEST( rfc0001_s4_field_array_in_a_type_field )
		dim r as LogRecord

		CU_ASSERT_EQUAL( r.fields.Count( ), 0 )
		r.fields.Push( LogField( "user", LogValue( "quinn" ) ) )
		r.fields.Push( LogField( "n", LogValue( 5ll ) ) )
		CU_ASSERT_EQUAL( r.fields.Count( ), 2 )
		CU_ASSERT_EQUAL( r.fields[0].name, "user" )
		CU_ASSERT_EQUAL( r.fields[1].value.i, 5ll )

		'' Names are NOT deduplicated here -- the collision rule belongs to
		'' each renderer, which is the only layer with an escaping rule.
		r.fields.Push( LogField( "user", LogValue( "other" ) ) )
		CU_ASSERT_EQUAL( r.fields.Count( ), 3 )
		CU_ASSERT_EQUAL( r.fields[0].name, r.fields[2].name )
	END_TEST

	'' RFC-0001 section 6. Rendering is BY TAG, and NOTHING CONSULTS THE
	'' LOCALE -- a log that changes its decimal separator on a French machine
	'' is a log that breaks every tool reading it.
	TEST( rfc0001_s6_value_text )
		dim as ustring su = "quinn"

		CU_ASSERT_EQUAL( LogValueToText( LogValue( ) ), "null" )
		CU_ASSERT_EQUAL( LogValueToText( LogValue( TRUE ) ), "true" )
		CU_ASSERT_EQUAL( LogValueToText( LogValue( FALSE ) ), "false" )
		CU_ASSERT_EQUAL( LogValueToText( LogValue( 42ll ) ), "42" )
		CU_ASSERT_EQUAL( LogValueToText( LogValue( -42ll ) ), "-42" )
		CU_ASSERT_EQUAL( LogValueToText( LogValue( su ) ), su )

		'' the unsigned case is why LK_UINT is a separate tag: as a longint
		'' this value is -1
		CU_ASSERT_EQUAL( LogValueToText( LogValue( 18446744073709551615ull ) ), _
		                 "18446744073709551615" )

		CU_ASSERT_EQUAL( LogValueToText( LogValue( 3.5 ) ), "3.5" )

		'' an Instant renders as RFC-3339, which is the whole interop point
		dim as Instant inst = Instant.ParseIso( "2026-08-12T23:06:34.3614985Z" )
		CU_ASSERT_EQUAL( LogValueToText( LogValue( inst ) ), _
		                 "2026-08-12T23:06:34.3614985Z" )
	END_TEST

	'' RFC-0001 section 6. JSON has no NaN and no Infinity, and a bare NaN
	'' produces a line no strict parser accepts. They are NAMED rather than
	'' emitted as null, because null would destroy the difference between
	'' "not a number" and "no value".
	TEST( rfc0001_s6_non_finite_doubles_are_named )
		dim as double zero = 0.0
		dim as double one = 1.0

		'' built at run time so the compiler cannot fold them away
		dim as double pinf = one / zero
		dim as double ninf = -one / zero
		dim as double nan_ = zero / zero

		CU_ASSERT_EQUAL( LogValueToText( LogValue( pinf ) ), "+Inf" )
		CU_ASSERT_EQUAL( LogValueToText( LogValue( ninf ) ), "-Inf" )
		CU_ASSERT_EQUAL( LogValueToText( LogValue( nan_ ) ), "NaN" )
	END_TEST

	'' RFC-0001 section 5. TWO CLOCKS. `stamp` is absolute UTC so it
	'' correlates with anything outside the process; `mono` never goes
	'' backwards, so two records still order correctly across an NTP
	'' correction or a DST shift -- which the wall clock cannot promise.
	TEST( rfc0001_s5_record_carries_both_clocks )
		dim r as LogRecord

		CU_ASSERT_EQUAL( r.mono, 0 )
		CU_ASSERT_EQUAL( len( r.message ), 0 )
		CU_ASSERT_EQUAL( r.srcline, 0 )

		r.stamp = WallClock.UtcNow( )
		CU_ASSERT_TRUE( r.stamp.IsValid )
		CU_ASSERT_TRUE( r.stamp.Ticks > 0 )
	END_TEST

END_SUITE
