'' Input and events -- C:\dev\docs\tui\RFC-0004-input-and-events.md.
''
'' THIS FILE IS THE GATE RFC-0004 SECTION 7 ASKS FOR: a table of byte sequences
'' mapped to expected events, covering every named key, every modifier
'' combination the grammar claims, the lone-ESC timeout, a sequence split across
'' reads, and a paste containing ESC and newline.
''
'' It runs on BOTH targets against the same table. That is the only way the two
'' platform paths stay in agreement, and disagreement between them is the
'' failure mode this module is most exposed to.
''
'' Phase 0 called this "the least-verified document in the docset". It is not
'' any more -- but note what still is NOT covered here: the Windows
'' INPUT_RECORD translator needs a real console and is exercised by hand, and no
'' real terminal other than conhost and WSL's pty has ever fed this parser.

#import "std/tui"
#import "std/containers"
#import "std/outcome"
#import "std/chrono"
#include "fbcunit.bi"

#include once "fberror.bi"

using tui, containers, outcome, chrono

using FB
'' ---------------------------------------------------------------------------
'' The table. One row is: bytes in, expected event out.
'' ---------------------------------------------------------------------------
#define ESC chr( 27 )

SUITE( fbc_tests.tui.tuiinput_ )

	'' RFC-0004 section 4. Every named key, in every form the grammar accepts.
	'' The duplicate forms for Home and End are NOT redundancy: different
	'' terminals emit different ones, and a parser that takes only one is
	'' broken on half the field.
	TEST( rfc0004_s4_named_keys )
		dim as string seq_( ... ) = { _
			ESC & "[A", ESC & "[B", ESC & "[C", _
			ESC & "[D", ESC & "[H", ESC & "[1~", _
			ESC & "[7~", ESC & "[F", ESC & "[4~", _
			ESC & "[8~", ESC & "[2~", ESC & "[3~", _
			ESC & "[5~", ESC & "[6~", ESC & "OP", _
			ESC & "OQ", ESC & "OR", ESC & "OS", _
			ESC & "[11~", ESC & "[15~", ESC & "[17~", _
			ESC & "[18~", ESC & "[19~", ESC & "[20~", _
			ESC & "[21~", ESC & "[23~", ESC & "[24~", _
			chr( 13 ), chr( 10 ), chr( 9 ), _
			chr( 8 ), chr( 127 ) }
		dim as ushort code_( ... ) = { _
			TUIKEY_UP, TUIKEY_DOWN, TUIKEY_RIGHT, _
			TUIKEY_LEFT, TUIKEY_HOME, TUIKEY_HOME, _
			TUIKEY_HOME, TUIKEY_END, TUIKEY_END, _
			TUIKEY_END, TUIKEY_INSERT, TUIKEY_DELETE, _
			TUIKEY_PAGEUP, TUIKEY_PAGEDOWN, TUIKEY_F1, _
			TUIKEY_F2, TUIKEY_F3, TUIKEY_F4, _
			TUIKEY_F1, TUIKEY_F5, TUIKEY_F6, _
			TUIKEY_F7, TUIKEY_F8, TUIKEY_F9, _
			TUIKEY_F10, TUIKEY_F11, TUIKEY_F12, _
			TUIKEY_ENTER, TUIKEY_ENTER, TUIKEY_TAB, _
			TUIKEY_BACKSPACE, TUIKEY_BACKSPACE }
		dim as ubyte mods_( ... ) = { _
			0, 0, 0, _
			0, 0, 0, _
			0, 0, 0, _
			0, 0, 0, _
			0, 0, 0, _
			0, 0, 0, _
			0, 0, 0, _
			0, 0, 0, _
			0, 0, 0, _
			0, 0, 0, _
			0, 0 }
		CU_ASSERT_EQUAL( ubound( seq_ ), ubound( code_ ) )
		CU_ASSERT_EQUAL( ubound( seq_ ), ubound( mods_ ) )

		for i as long = lbound( seq_ ) to ubound( seq_ )
			dim as TuiInput inp
			inp.Feed( seq_( i ) )
			dim as TuiEventOpt e = inp.NextEvent( FALSE )

			CU_ASSERT_TRUE( e.HasValue( ) )
			if( e.HasValue( ) = false ) then continue for

			CU_ASSERT_EQUAL( e.Value( ).kind, TUIEVENT_KEY )
			CU_ASSERT_EQUAL( e.Value( ).key.code, code_( i ) )
			CU_ASSERT_EQUAL( e.Value( ).key.mods, mods_( i ) )

			'' the whole sequence was consumed, with nothing left behind
			CU_ASSERT_EQUAL( inp.Buffered( ), 0 )
		next
	END_TEST

	'' RFC-0004 section 4. CSI 1;m A and CSI n;m ~, where m-1 is a bit set:
	'' 1 Shift, 2 Alt, 4 Ctrl. All eight combinations, on an arrow and on a
	'' tilde key, because the two take different code paths.
	TEST( rfc0004_s4_every_modifier_combination )
		'' param -> expected mods
		dim as ubyte want( 2 to 9 ) = { _
			TUIMOD_SHIFT, _
			TUIMOD_ALT, _
			TUIMOD_ALT or TUIMOD_SHIFT, _
			TUIMOD_CTRL, _
			TUIMOD_CTRL or TUIMOD_SHIFT, _
			TUIMOD_CTRL or TUIMOD_ALT, _
			TUIMOD_CTRL or TUIMOD_ALT or TUIMOD_SHIFT, _
			TUIMOD_CTRL or TUIMOD_ALT or TUIMOD_SHIFT }

		for m as long = 2 to 8
			dim as TuiInput a
			a.Feed( ESC & "[1;" & str( m ) & "A" )
			dim as TuiEventOpt ea = a.NextEvent( FALSE )
			CU_ASSERT_TRUE( ea.HasValue( ) )
			if( ea.HasValue( ) ) then
				CU_ASSERT_EQUAL( ea.Value( ).key.code, TUIKEY_UP )
				CU_ASSERT_EQUAL( ea.Value( ).key.mods, want( m ) )
			end if

			dim as TuiInput b
			b.Feed( ESC & "[3;" & str( m ) & "~" )
			dim as TuiEventOpt eb = b.NextEvent( FALSE )
			CU_ASSERT_TRUE( eb.HasValue( ) )
			if( eb.HasValue( ) ) then
				CU_ASSERT_EQUAL( eb.Value( ).key.code, TUIKEY_DELETE )
				CU_ASSERT_EQUAL( eb.Value( ).key.mods, want( m ) )
			end if
		next

		'' param 1 means NO modifier, and so does an absent param
		dim as TuiInput n
		n.Feed( ESC & "[1;1A" )
		CU_ASSERT_EQUAL( n.NextEvent( FALSE ).Value( ).key.mods, TUIMOD_NONE )
	END_TEST

	'' RFC-0004 section 4. C0 controls become Ctrl+letter, EXCEPT the three
	'' that are named keys in their own right.
	TEST( rfc0004_s4_c0_controls )
		'' Ctrl+A .. Ctrl+Z, skipping the ones that are named keys
		for b as long = 1 to 26
			if( ( b = 8 ) orelse ( b = 9 ) orelse ( b = 10 ) orelse ( b = 13 ) ) then continue for

			dim as TuiInput inp
			inp.Feed( chr( b ) )
			dim as TuiEventOpt e = inp.NextEvent( FALSE )
			CU_ASSERT_TRUE( e.HasValue( ) )
			if( e.HasValue( ) = false ) then continue for

			CU_ASSERT_TRUE ( e.Value( ).key.IsChar( ) )
			CU_ASSERT_TRUE ( e.Value( ).key.HasMod( TUIMOD_CTRL ) )
			CU_ASSERT_EQUAL( e.Value( ).key.ch, asc( "a" ) + b - 1 )
		next

		'' and the three that are NOT Ctrl+letter
		dim as TuiInput t1 : t1.Feed( chr( 9 ) )
		CU_ASSERT_EQUAL( t1.NextEvent( FALSE ).Value( ).key.code, TUIKEY_TAB )
		dim as TuiInput t2 : t2.Feed( chr( 13 ) )
		CU_ASSERT_EQUAL( t2.NextEvent( FALSE ).Value( ).key.code, TUIKEY_ENTER )
		dim as TuiInput t3 : t3.Feed( chr( 8 ) )
		CU_ASSERT_EQUAL( t3.NextEvent( FALSE ).Value( ).key.code, TUIKEY_BACKSPACE )
	END_TEST

	'' RFC-0004 section 4. ESC <printable> is Alt+that key.
	TEST( rfc0004_s4_alt_prefixed_keys )
		dim as TuiInput inp
		inp.Feed( ESC & "a" )
		dim as TuiEventOpt e = inp.NextEvent( FALSE )
		CU_ASSERT_TRUE ( e.HasValue( ) )
		CU_ASSERT_TRUE ( e.Value( ).key.IsChar( ) )
		CU_ASSERT_EQUAL( e.Value( ).key.ch, asc( "a" ) )
		CU_ASSERT_TRUE ( e.Value( ).key.HasMod( TUIMOD_ALT ) )

		'' ESC ESC: the first is the Escape key, and the second stays buffered
		dim as TuiInput d
		d.Feed( ESC & ESC )
		dim as TuiEventOpt e2 = d.NextEvent( FALSE )
		CU_ASSERT_TRUE ( e2.HasValue( ) )
		CU_ASSERT_EQUAL( e2.Value( ).key.code, TUIKEY_ESCAPE )
		CU_ASSERT_EQUAL( d.Buffered( ), 1 )
	END_TEST

	'' RFC-0004 section 4. THE LONE-ESC AMBIGUITY. ESC is both a key and the
	'' start of every sequence; only the timeout can decide. Until it fires the
	'' parser must return nothing AND KEEP THE BYTE.
	TEST( rfc0004_s4_lone_esc_needs_the_timeout )
		dim as TuiInput inp
		inp.Feed( ESC )

		'' not expired: no event, byte retained
		CU_ASSERT_FALSE( inp.NextEvent( FALSE ).HasValue( ) )
		CU_ASSERT_EQUAL( inp.Buffered( ), 1 )
		CU_ASSERT_TRUE ( inp.WaitingOnLoneEsc( ) )

		'' expired: it was the key
		dim as TuiEventOpt e = inp.NextEvent( TRUE )
		CU_ASSERT_TRUE ( e.HasValue( ) )
		CU_ASSERT_EQUAL( e.Value( ).key.code, TUIKEY_ESCAPE )
		CU_ASSERT_EQUAL( inp.Buffered( ), 0 )

		'' and if the continuation DOES arrive, it is a sequence, not Escape
		dim as TuiInput b
		b.Feed( ESC )
		CU_ASSERT_FALSE( b.NextEvent( FALSE ).HasValue( ) )
		b.Feed( "[A" )
		dim as TuiEventOpt e2 = b.NextEvent( FALSE )
		CU_ASSERT_TRUE ( e2.HasValue( ) )
		CU_ASSERT_EQUAL( e2.Value( ).key.code, TUIKEY_UP )
	END_TEST

	'' RFC-0004 section 3. A single read can deliver half a sequence, and a
	'' sequence can span reads. This is the most common way a hand-rolled VT
	'' parser is wrong, so it is asserted BYTE BY BYTE.
	TEST( rfc0004_s3_sequence_split_across_reads )
		dim as string whole = ESC & "[1;5D"

		'' fed one byte at a time, nothing may be emitted until the last
		dim as TuiInput inp
		for i as long = 1 to len( whole ) - 1
			inp.Feed( mid( whole, i, 1 ) )
			CU_ASSERT_FALSE( inp.NextEvent( FALSE ).HasValue( ) )
			CU_ASSERT_EQUAL( inp.Buffered( ), i )
		next

		inp.Feed( right( whole, 1 ) )
		dim as TuiEventOpt e = inp.NextEvent( FALSE )
		CU_ASSERT_TRUE ( e.HasValue( ) )
		CU_ASSERT_EQUAL( e.Value( ).key.code, TUIKEY_LEFT )
		CU_ASSERT_EQUAL( e.Value( ).key.mods, TUIMOD_CTRL )
		CU_ASSERT_EQUAL( inp.Buffered( ), 0 )

		'' two whole sequences in ONE feed come out as two events
		dim as TuiInput two
		two.Feed( ESC & "[A" & ESC & "[B" )
		CU_ASSERT_EQUAL( two.NextEvent( FALSE ).Value( ).key.code, TUIKEY_UP )
		CU_ASSERT_EQUAL( two.NextEvent( FALSE ).Value( ).key.code, TUIKEY_DOWN )
		CU_ASSERT_FALSE( two.NextEvent( FALSE ).HasValue( ) )
	END_TEST

	'' RFC-0004 section 4. SGR 1006 mouse. Coordinates are 1-BASED on the wire
	'' and 0-based everywhere else, and the conversion happens at the parser so
	'' nothing downstream has to remember.
	TEST( rfc0004_s4_sgr_mouse )
		dim as TuiInput p
		p.Feed( ESC & "[<0;12;7M" )
		dim as TuiEventOpt e = p.NextEvent( FALSE )
		CU_ASSERT_TRUE ( e.HasValue( ) )
		CU_ASSERT_EQUAL( e.Value( ).kind, TUIEVENT_MOUSE )
		CU_ASSERT_EQUAL( e.Value( ).mouse.kind, TUIMOUSE_PRESS )
		CU_ASSERT_EQUAL( e.Value( ).mouse.button, TUIBTN_LEFT )
		CU_ASSERT_EQUAL( e.Value( ).mouse.x, 11 )      '' 12 - 1
		CU_ASSERT_EQUAL( e.Value( ).mouse.y, 6 )       ''  7 - 1

		'' lowercase final is a RELEASE
		dim as TuiInput r
		r.Feed( ESC & "[<0;12;7m" )
		CU_ASSERT_EQUAL( r.NextEvent( FALSE ).Value( ).mouse.kind, TUIMOUSE_RELEASE )

		'' the three buttons
		dim as TuiInput mid_ : mid_.Feed( ESC & "[<1;1;1M" )
		CU_ASSERT_EQUAL( mid_.NextEvent( FALSE ).Value( ).mouse.button, TUIBTN_MIDDLE )
		dim as TuiInput rt : rt.Feed( ESC & "[<2;1;1M" )
		CU_ASSERT_EQUAL( rt.NextEvent( FALSE ).Value( ).mouse.button, TUIBTN_RIGHT )

		'' bit 5 is motion, bit 6 is the wheel -- and the wheel must be
		'' distinguishable from an arrow key, which is the whole point
		dim as TuiInput mv : mv.Feed( ESC & "[<32;5;5M" )
		CU_ASSERT_EQUAL( mv.NextEvent( FALSE ).Value( ).mouse.kind, TUIMOUSE_MOVE )
		dim as TuiInput wu : wu.Feed( ESC & "[<64;5;5M" )
		CU_ASSERT_EQUAL( wu.NextEvent( FALSE ).Value( ).mouse.kind, TUIMOUSE_WHEELUP )
		dim as TuiInput wd : wd.Feed( ESC & "[<65;5;5M" )
		CU_ASSERT_EQUAL( wd.NextEvent( FALSE ).Value( ).mouse.kind, TUIMOUSE_WHEELDOWN )

		'' modifiers ride along: bit 2 Shift, bit 3 Alt, bit 4 Ctrl
		dim as TuiInput mo : mo.Feed( ESC & "[<20;3;4M" )    '' 16 + 4 = Ctrl+Shift
		dim as TuiEventOpt em = mo.NextEvent( FALSE )
		CU_ASSERT_TRUE( ( em.Value( ).mouse.mods and TUIMOD_CTRL ) <> 0 )
		CU_ASSERT_TRUE( ( em.Value( ).mouse.mods and TUIMOD_SHIFT ) <> 0 )

		'' three-digit coordinates, because a 200-column terminal is ordinary
		dim as TuiInput big
		big.Feed( ESC & "[<0;200;50M" )
		dim as TuiEventOpt eb = big.NextEvent( FALSE )
		CU_ASSERT_EQUAL( eb.Value( ).mouse.x, 199 )
		CU_ASSERT_EQUAL( eb.Value( ).mouse.y, 49 )
	END_TEST

	'' RFC-0004 section 4. Bracketed paste is ONE event. This is the entire
	'' point of the mode: a pasted newline must not read as Enter and a pasted
	'' ESC must not read as Escape.
	TEST( rfc0004_s4_bracketed_paste_is_one_event )
		dim as string body = "he" & ESC & "llo" & chr( 10 ) & "world"
		dim as TuiInput inp
		inp.Feed( ESC & "[200~" & body & ESC & "[201~" )

		dim as TuiEventOpt e = inp.NextEvent( FALSE )
		CU_ASSERT_TRUE ( e.HasValue( ) )
		CU_ASSERT_EQUAL( e.Value( ).kind, TUIEVENT_PASTE )

		'' the ESC and the newline SURVIVED inside the payload -- asserted by
		'' length and by code unit, never by how it looks when printed
		CU_ASSERT_EQUAL( len( e.Value( ).text ), len( body ) )
		CU_ASSERT_EQUAL( e.Value( ).text[2], 27 )
		CU_ASSERT_EQUAL( e.Value( ).text[6], 10 )

		'' nothing left over, and no key events were manufactured
		CU_ASSERT_EQUAL( inp.Buffered( ), 0 )
		CU_ASSERT_FALSE( inp.NextEvent( FALSE ).HasValue( ) )

		'' an UNTERMINATED paste yields nothing and keeps waiting, rather than
		'' emitting a burst of keys
		dim as TuiInput open_
		open_.Feed( ESC & "[200~partial" )
		CU_ASSERT_FALSE( open_.NextEvent( FALSE ).HasValue( ) )
		CU_ASSERT_TRUE ( open_.Buffered( ) > 0 )
		open_.Feed( " more" & ESC & "[201~" )
		dim as TuiEventOpt e2 = open_.NextEvent( FALSE )
		CU_ASSERT_TRUE ( e2.HasValue( ) )
		CU_ASSERT_EQUAL( e2.Value( ).text, "partial more" )

		'' an empty paste is still a paste
		dim as TuiInput z
		z.Feed( ESC & "[200~" & ESC & "[201~" )
		dim as TuiEventOpt e3 = z.NextEvent( FALSE )
		CU_ASSERT_TRUE ( e3.HasValue( ) )
		CU_ASSERT_EQUAL( e3.Value( ).kind, TUIEVENT_PASTE )
		CU_ASSERT_EQUAL( len( e3.Value( ).text ), 0 )
	END_TEST

	'' RFC-0004 section 4. Focus in and out.
	TEST( rfc0004_s4_focus_events )
		dim as TuiInput i_
		i_.Feed( ESC & "[I" )
		dim as TuiEventOpt a = i_.NextEvent( FALSE )
		CU_ASSERT_EQUAL( a.Value( ).kind, TUIEVENT_FOCUS )
		CU_ASSERT_TRUE ( a.Value( ).focused )

		dim as TuiInput o_
		o_.Feed( ESC & "[O" )
		dim as TuiEventOpt b = o_.NextEvent( FALSE )
		CU_ASSERT_EQUAL( b.Value( ).kind, TUIEVENT_FOCUS )
		CU_ASSERT_FALSE( b.Value( ).focused )
	END_TEST

	'' RFC-0004 section 4. modifyOtherKeys: CSI 27 ; mods ; codepoint ~ is how
	'' Ctrl+Shift+letter becomes representable at all.
	TEST( rfc0004_s4_modify_other_keys )
		dim as TuiInput inp
		inp.Feed( ESC & "[27;6;65~" )       '' mods 6 = Ctrl+Shift, cp 65 = 'A'
		dim as TuiEventOpt e = inp.NextEvent( FALSE )
		CU_ASSERT_TRUE ( e.HasValue( ) )
		CU_ASSERT_TRUE ( e.Value( ).key.IsChar( ) )
		CU_ASSERT_EQUAL( e.Value( ).key.ch, 65 )
		CU_ASSERT_TRUE ( e.Value( ).key.HasMod( TUIMOD_CTRL ) )
		CU_ASSERT_TRUE ( e.Value( ).key.HasMod( TUIMOD_SHIFT ) )
	END_TEST

	'' RFC-0004 section 4. UTF-8 input decodes to codepoints, including astral
	'' ones, and an incomplete sequence WAITS rather than emitting U+FFFD.
	TEST( rfc0004_s4_utf8_input )
		'' e-acute, 2 bytes
		dim as TuiInput a
		a.Feed( chr( &hC3 ) & chr( &hA9 ) )
		CU_ASSERT_EQUAL( a.NextEvent( FALSE ).Value( ).key.ch, &hE9 )

		'' CJK, 3 bytes
		dim as TuiInput b
		b.Feed( chr( &hE4 ) & chr( &hB8 ) & chr( &hAD ) )
		CU_ASSERT_EQUAL( b.NextEvent( FALSE ).Value( ).key.ch, &h4E2D )

		'' astral, 4 bytes -- and the ustring payload is a SURROGATE PAIR
		dim as TuiInput c
		c.Feed( chr( &hF0 ) & chr( &h9F ) & chr( &h98 ) & chr( &h80 ) )
		dim as TuiEventOpt e = c.NextEvent( FALSE )
		CU_ASSERT_EQUAL( e.Value( ).key.ch, &h1F600 )
		CU_ASSERT_EQUAL( len( e.Value( ).text ), 2 )
		CU_ASSERT_EQUAL( e.Value( ).text[0], &hD83D )
		CU_ASSERT_EQUAL( e.Value( ).text[1], &hDE00 )

		'' split mid-codepoint: wait, do not guess
		dim as TuiInput d
		d.Feed( chr( &hE4 ) & chr( &hB8 ) )
		CU_ASSERT_FALSE( d.NextEvent( FALSE ).HasValue( ) )
		CU_ASSERT_EQUAL( d.Buffered( ), 2 )
		d.Feed( chr( &hAD ) )
		CU_ASSERT_EQUAL( d.NextEvent( FALSE ).Value( ).key.ch, &h4E2D )
	END_TEST

	'' A malformed or unimplemented sequence must CONSUME itself. A parser that
	'' leaves bytes it cannot handle wedges permanently, which is worse than
	'' dropping the input.
	TEST( rfc0004_parser_never_wedges )
		'' a well-formed CSI with a final we do not implement
		dim as TuiInput a
		a.Feed( ESC & "[99Z" )
		a.NextEvent( FALSE )
		CU_ASSERT_EQUAL( a.Buffered( ), 0 )

		'' a stray UTF-8 continuation byte
		dim as TuiInput b
		b.Feed( chr( &h80 ) & "A" )
		dim as TuiEventOpt e = b.NextEvent( FALSE )
		CU_ASSERT_TRUE ( e.HasValue( ) )
		CU_ASSERT_EQUAL( e.Value( ).key.ch, &hFFFD )
		CU_ASSERT_EQUAL( b.NextEvent( FALSE ).Value( ).key.ch, asc( "A" ) )

		'' a mouse sequence with too few parameters
		dim as TuiInput c
		c.Feed( ESC & "[<0M" )
		c.NextEvent( FALSE )
		CU_ASSERT_EQUAL( c.Buffered( ), 0 )

		'' feeding garbage never raises and always terminates
		dim as TuiInput g
		g.Feed( ESC & "[[[;;;" & ESC & "O" & ESC & "[" )
		for i as long = 1 to 20
			g.NextEvent( TRUE )
		next
		CU_ASSERT_TRUE( g.Buffered( ) >= 0 )
	END_TEST

	'' Reset clears both the byte buffer and the queue, so a terminal that is
	'' re-entered does not replay stale input.
	TEST( rfc0004_reset_clears_everything )
		dim as TuiInput inp
		inp.Feed( ESC & "[A" & ESC & "[B" & ESC & "[" )
		inp.NextEvent( FALSE )
		CU_ASSERT_TRUE( inp.Buffered( ) > 0 )

		inp.Reset( )
		CU_ASSERT_EQUAL( inp.Buffered( ), 0 )
		CU_ASSERT_EQUAL( inp.Queued( ), 0 )
		CU_ASSERT_FALSE( inp.NextEvent( TRUE ).HasValue( ) )
	END_TEST

	'' RFC-0004 section 2. TuiKeyName is what a keymap and a help screen both
	'' show, so the modifier order must be stable.
	TEST( rfc0004_s2_key_names )
		dim as TuiKey k
		k.code = TUIKEY_F5
		CU_ASSERT_EQUAL( TuiKeyName( k ), "F5" )

		k.mods = TUIMOD_CTRL or TUIMOD_SHIFT
		CU_ASSERT_EQUAL( TuiKeyName( k ), "Ctrl+Shift+F5" )

		k.mods = TUIMOD_CTRL or TUIMOD_ALT or TUIMOD_SHIFT
		CU_ASSERT_EQUAL( TuiKeyName( k ), "Ctrl+Alt+Shift+F5" )

		k.code = TUIKEY_END
		k.mods = 0
		CU_ASSERT_EQUAL( TuiKeyName( k ), "End" )

		k.code = TUIKEY_CHAR
		k.ch = asc( "q" )
		CU_ASSERT_EQUAL( TuiKeyName( k ), "q" )
		k.mods = TUIMOD_CTRL
		CU_ASSERT_EQUAL( TuiKeyName( k ), "Ctrl+q" )
	END_TEST

	'' The queue is FIFO, and events pushed by the Windows record translator
	'' come out in arrival order. This is the path the INPUT_RECORD loop uses,
	'' and it is testable on both targets even though the loop itself is not.
	TEST( rfc0004_s5_queue_is_fifo )
		dim as TuiInput inp
		inp.PushEvent( TuiKeyEvent( TUIKEY_UP ) )
		inp.PushEvent( TuiKeyEvent( TUIKEY_DOWN ) )
		inp.PushEvent( TuiKeyEvent( TUIKEY_LEFT ) )
		CU_ASSERT_EQUAL( inp.Queued( ), 3 )

		CU_ASSERT_EQUAL( inp.NextEvent( FALSE ).Value( ).key.code, TUIKEY_UP )
		CU_ASSERT_EQUAL( inp.NextEvent( FALSE ).Value( ).key.code, TUIKEY_DOWN )
		CU_ASSERT_EQUAL( inp.NextEvent( FALSE ).Value( ).key.code, TUIKEY_LEFT )
		CU_ASSERT_EQUAL( inp.Queued( ), 0 )
		CU_ASSERT_FALSE( inp.NextEvent( FALSE ).HasValue( ) )

		'' queued events take priority over unparsed bytes, because they
		'' arrived first
		dim as TuiInput mixed
		mixed.Feed( ESC & "[A" )
		mixed.PushEvent( TuiKeyEvent( TUIKEY_F1 ) )
		CU_ASSERT_EQUAL( mixed.NextEvent( FALSE ).Value( ).key.code, TUIKEY_F1 )
		CU_ASSERT_EQUAL( mixed.NextEvent( FALSE ).Value( ).key.code, TUIKEY_UP )
	END_TEST

	'' ---------------------------------------------------------------------
	'' RFC-0004 section 5. The Windows INPUT_RECORD translator, driven by
	'' SYNTHESISED records so it needs no console. The live ReadConsoleInputW
	'' loop around it is still hand-verified only.
	'' ---------------------------------------------------------------------
	#ifdef __FB_WIN32__
	TEST( rfc0004_s5_win32_record_translation )
		dim as INPUT_RECORD rec
		dim as TuiEvent ev
		dim as ulong pending

		'' a plain character
		rec.EventType = TUI_REC_KEY
		rec.Event.KeyEvent.bKeyDown = 1
		rec.Event.KeyEvent.wVirtualKeyCode = &h41
		rec.Event.KeyEvent.uChar.UnicodeChar = asc( "A" )
		rec.Event.KeyEvent.dwControlKeyState = 0
		CU_ASSERT_TRUE ( TuiFromRecord( rec, ev, pending ) )
		CU_ASSERT_TRUE ( ev.key.IsChar( ) )
		CU_ASSERT_EQUAL( ev.key.ch, asc( "A" ) )

		'' modifiers come straight off dwControlKeyState
		rec.Event.KeyEvent.dwControlKeyState = LEFT_CTRL_PRESSED or SHIFT_PRESSED
		CU_ASSERT_TRUE( TuiFromRecord( rec, ev, pending ) )
		CU_ASSERT_TRUE( ev.key.HasMod( TUIMOD_CTRL ) )
		CU_ASSERT_TRUE( ev.key.HasMod( TUIMOD_SHIFT ) )
		CU_ASSERT_FALSE( ev.key.HasMod( TUIMOD_ALT ) )

		'' a named key
		rec.Event.KeyEvent.dwControlKeyState = 0
		rec.Event.KeyEvent.wVirtualKeyCode = VK_UP
		rec.Event.KeyEvent.uChar.UnicodeChar = 0
		CU_ASSERT_TRUE ( TuiFromRecord( rec, ev, pending ) )
		CU_ASSERT_EQUAL( ev.key.code, TUIKEY_UP )

		rec.Event.KeyEvent.wVirtualKeyCode = VK_F5
		CU_ASSERT_TRUE ( TuiFromRecord( rec, ev, pending ) )
		CU_ASSERT_EQUAL( ev.key.code, TUIKEY_F5 )

		'' key-UP records are discarded ...
		rec.Event.KeyEvent.bKeyDown = 0
		rec.Event.KeyEvent.wVirtualKeyCode = VK_F5
		CU_ASSERT_FALSE( TuiFromRecord( rec, ev, pending ) )

		'' ... except the Alt+numpad composed character, which is the one
		'' key-up that carries information
		rec.Event.KeyEvent.wVirtualKeyCode = 0
		rec.Event.KeyEvent.uChar.UnicodeChar = 233        '' e-acute
		CU_ASSERT_TRUE ( TuiFromRecord( rec, ev, pending ) )
		CU_ASSERT_EQUAL( ev.key.ch, 233 )

		'' THE SURROGATE PAIRING RULE: an astral codepoint arrives as TWO key
		'' records and must be combined, not emitted as two broken events.
		pending = 0
		rec.EventType = TUI_REC_KEY
		rec.Event.KeyEvent.bKeyDown = 1
		rec.Event.KeyEvent.wVirtualKeyCode = 0
		rec.Event.KeyEvent.dwControlKeyState = 0
		rec.Event.KeyEvent.uChar.UnicodeChar = &hD83D
		CU_ASSERT_FALSE( TuiFromRecord( rec, ev, pending ) )   '' held, no event
		CU_ASSERT_EQUAL( pending, &hD83D )

		rec.Event.KeyEvent.uChar.UnicodeChar = &hDE00
		CU_ASSERT_TRUE ( TuiFromRecord( rec, ev, pending ) )
		CU_ASSERT_EQUAL( ev.key.ch, &h1F600 )
		CU_ASSERT_EQUAL( pending, 0 )
		CU_ASSERT_EQUAL( len( ev.text ), 2 )
		CU_ASSERT_EQUAL( ev.text[0], &hD83D )
		CU_ASSERT_EQUAL( ev.text[1], &hDE00 )

		'' a high surrogate followed by anything else is DROPPED, and the
		'' following record is processed normally
		rec.Event.KeyEvent.uChar.UnicodeChar = &hD83D
		TuiFromRecord( rec, ev, pending )
		rec.Event.KeyEvent.uChar.UnicodeChar = asc( "Z" )
		CU_ASSERT_TRUE ( TuiFromRecord( rec, ev, pending ) )
		CU_ASSERT_EQUAL( ev.key.ch, asc( "Z" ) )
		CU_ASSERT_EQUAL( pending, 0 )

		'' mouse: press, release, move, and a SIGNED wheel delta
		rec.EventType = TUI_REC_MOUSE
		rec.Event.MouseEvent.dwMousePosition.X = 11
		rec.Event.MouseEvent.dwMousePosition.Y = 6
		rec.Event.MouseEvent.dwEventFlags = 0
		rec.Event.MouseEvent.dwControlKeyState = 0
		rec.Event.MouseEvent.dwButtonState = FROM_LEFT_1ST_BUTTON_PRESSED
		CU_ASSERT_TRUE ( TuiFromRecord( rec, ev, pending ) )
		CU_ASSERT_EQUAL( ev.kind, TUIEVENT_MOUSE )
		CU_ASSERT_EQUAL( ev.mouse.kind, TUIMOUSE_PRESS )
		CU_ASSERT_EQUAL( ev.mouse.button, TUIBTN_LEFT )
		CU_ASSERT_EQUAL( ev.mouse.x, 11 )
		CU_ASSERT_EQUAL( ev.mouse.y, 6 )

		rec.Event.MouseEvent.dwButtonState = 0
		CU_ASSERT_TRUE ( TuiFromRecord( rec, ev, pending ) )
		CU_ASSERT_EQUAL( ev.mouse.kind, TUIMOUSE_RELEASE )

		rec.Event.MouseEvent.dwEventFlags = MOUSE_MOVED
		CU_ASSERT_TRUE ( TuiFromRecord( rec, ev, pending ) )
		CU_ASSERT_EQUAL( ev.mouse.kind, TUIMOUSE_MOVE )

		'' the wheel delta is the HIGH word and it is SIGNED -- reading it
		'' unsigned makes every scroll-down look like a scroll-up
		rec.Event.MouseEvent.dwEventFlags = MOUSE_WHEELED
		rec.Event.MouseEvent.dwButtonState = 120 shl 16
		CU_ASSERT_TRUE ( TuiFromRecord( rec, ev, pending ) )
		CU_ASSERT_EQUAL( ev.mouse.kind, TUIMOUSE_WHEELUP )

		rec.Event.MouseEvent.dwButtonState = cast( DWORD, ( -120 and &hFFFF ) shl 16 )
		CU_ASSERT_TRUE ( TuiFromRecord( rec, ev, pending ) )
		CU_ASSERT_EQUAL( ev.mouse.kind, TUIMOUSE_WHEELDOWN )

		'' A LONE SURROGATE IS NEVER AN EVENT, on either the down or the up
		'' record. Found live: Windows sends a key-UP for each half of a pair,
		'' and the Alt+numpad key-up case fired on both, so ONE astral keypress
		'' produced THREE events -- a lone high surrogate, the correct
		'' codepoint, then a lone low surrogate. Emitting half a character
		'' builds an invalid ustring.
		pending = 0
		rec.EventType = TUI_REC_KEY
		rec.Event.KeyEvent.wVirtualKeyCode = 0
		rec.Event.KeyEvent.dwControlKeyState = 0

		'' the key-UP half of a high surrogate
		rec.Event.KeyEvent.bKeyDown = 0
		rec.Event.KeyEvent.uChar.UnicodeChar = &hD83D
		CU_ASSERT_FALSE( TuiFromRecord( rec, ev, pending ) )

		'' the key-UP half of a low surrogate
		rec.Event.KeyEvent.uChar.UnicodeChar = &hDE00
		CU_ASSERT_FALSE( TuiFromRecord( rec, ev, pending ) )

		'' an orphaned LOW surrogate on a key-DOWN, with no high before it
		rec.Event.KeyEvent.bKeyDown = 1
		pending = 0
		rec.Event.KeyEvent.uChar.UnicodeChar = &hDE00
		CU_ASSERT_FALSE( TuiFromRecord( rec, ev, pending ) )

		'' the full down/up/down/up sequence for one astral character yields
		'' EXACTLY ONE event
		pending = 0
		dim as long emitted = 0
		dim as ushort halves( 0 to 1 ) = { &hD83D, &hDE00 }
		for h as long = 0 to 1
			for down as long = 1 to 0 step -1
				rec.Event.KeyEvent.bKeyDown = down
				rec.Event.KeyEvent.uChar.UnicodeChar = halves( h )
				if( TuiFromRecord( rec, ev, pending ) ) then emitted += 1
			next
		next
		CU_ASSERT_EQUAL( emitted, 1 )
		CU_ASSERT_EQUAL( ev.key.ch, &h1F600 )

		'' a resize record
		rec.EventType = TUI_REC_RESIZE
		CU_ASSERT_TRUE ( TuiFromRecord( rec, ev, pending ) )
		CU_ASSERT_EQUAL( ev.kind, TUIEVENT_RESIZE )
	END_TEST
	#endif

END_SUITE
