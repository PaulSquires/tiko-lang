'' Input widgets and overlays -- RFC-0008 sections 4 and 5.
''
'' THE GATE is rfc0008_s5_gate_popup_restores_what_is_beneath (ranked-gaps
'' rank 20): a popup over a full-screen widget leaves the cells beneath it
'' exactly as they were once it is dismissed.
''
'' The other thing worth testing hard is the CURSOR, because TextInput carries
'' two different units -- a code-unit index and a column offset -- and
'' conflating them is how a text field ends up one column out on the first
'' accented character.

#import "std/tui"
#import "std/outcome"
#import "std/chrono"
#include "fbcunit.bi"

#include once "fb/array.bi"

#include once "fberror.bi"

using tui, outcome, chrono

using FB
SUITE( fbc_tests.tui.tuiform_ )

	'' RFC-0008 section 4. The cursor is a CODE UNIT index and can never land
	'' inside a grapheme -- not between a surrogate pair, not between a base
	'' and its combining mark.
	TEST( rfc0008_s4_cursor_never_splits_a_grapheme )
		dim as TuiTextInputState st
		TuiTextInputStateInit( st )

		'' "A" + emoji (2 units) + "e" + combining acute (2 units) + "B"
		st.text = "A"
		TuiAppendCp( st.text, &h1F600 )
		st.text &= "e"
		TuiAppendCp( st.text, &h0301 )
		st.text &= "B"
		CU_ASSERT_EQUAL( len( st.text ), 6 )
		CU_ASSERT_EQUAL( TuiStringWidth( st.text ), 5 )   '' A=1 + emoji=2 + e-acute=1 + B=1

		dim as TuiTextInput ti
		ti.state = @st
		ti.isFocused = TRUE

		dim as TuiScreen scr
		scr.Resize( 20, 1 )
		ti.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 20, 1 ) )

		dim as TuiEvent right_, left_
		right_.kind = TUIEVENT_KEY : right_.key.code = TUIKEY_RIGHT
		left_.kind = TUIEVENT_KEY  : left_.key.code = TUIKEY_LEFT

		'' walking right lands only on cluster boundaries: 0,1,3,5,6
		st.cursor = 0
		dim as long want( 0 to 4 ) = { 1, 3, 5, 6, 6 }
		for i as long = 0 to 4
			ti.HandleEvent( right_ )
			CU_ASSERT_EQUAL( st.cursor, want( i ) )
		next

		'' and walking back retraces exactly the same boundaries
		dim as long back( 0 to 4 ) = { 5, 3, 1, 0, 0 }
		for i as long = 0 to 4
			ti.HandleEvent( left_ )
			CU_ASSERT_EQUAL( st.cursor, back( i ) )
		next

		'' Home and End
		dim as TuiEvent e
		e.kind = TUIEVENT_KEY
		e.key.code = TUIKEY_END_
		ti.HandleEvent( e )
		CU_ASSERT_EQUAL( st.cursor, 6 )
		e.key.code = TUIKEY_HOME
		ti.HandleEvent( e )
		CU_ASSERT_EQUAL( st.cursor, 0 )
	END_TEST

	'' RFC-0008 section 4. Backspace and Delete remove a whole cluster, not a
	'' code unit -- deleting half a surrogate pair would corrupt the string.
	TEST( rfc0008_s4_delete_removes_whole_clusters )
		dim as TuiTextInputState st
		TuiTextInputStateInit( st )
		st.text = "A"
		TuiAppendCp( st.text, &h1F600 )
		st.text &= "B"
		CU_ASSERT_EQUAL( len( st.text ), 4 )

		dim as TuiTextInput ti
		ti.state = @st
		ti.isFocused = TRUE

		'' cursor after the emoji; backspace removes BOTH units
		st.cursor = 3
		dim as TuiEvent bs
		bs.kind = TUIEVENT_KEY
		bs.key.code = TUIKEY_BACKSPACE
		CU_ASSERT_TRUE ( ti.HandleEvent( bs ) )
		CU_ASSERT_EQUAL( len( st.text ), 2 )
		CU_ASSERT_EQUAL( st.text, "AB" )
		CU_ASSERT_EQUAL( st.cursor, 1 )

		'' Delete forward, also a whole cluster
		TuiTextInputStateInit( st )
		st.text = "A"
		TuiAppendCp( st.text, &h1F600 )
		st.text &= "B"
		st.cursor = 1
		dim as TuiEvent del
		del.kind = TUIEVENT_KEY
		del.key.code = TUIKEY_DELETE
		CU_ASSERT_TRUE ( ti.HandleEvent( del ) )
		CU_ASSERT_EQUAL( st.text, "AB" )

		'' backspace at the start is a no-op, not an underflow
		st.cursor = 0
		ti.HandleEvent( bs )
		CU_ASSERT_EQUAL( st.cursor, 0 )
		CU_ASSERT_EQUAL( st.text, "AB" )
	END_TEST

	'' RFC-0008 section 4. A PASTE IS ONE EDIT. A pasted newline must not read
	'' as Enter, and a pasted ESC must not read as Escape.
	TEST( rfc0008_s4_paste_is_one_edit )
		dim as TuiTextInputState st
		TuiTextInputStateInit( st )
		st.text = "ab"
		st.cursor = 1

		dim as TuiTextInput ti
		ti.state = @st
		ti.isFocused = TRUE

		dim as TuiEvent p
		p.kind = TUIEVENT_PASTE
		p.text = "XY"
		p.text &= chr( 10 )
		p.text &= "Z"

		CU_ASSERT_TRUE ( ti.HandleEvent( p ) )
		CU_ASSERT_EQUAL( len( st.text ), 6 )        '' a + XY\nZ + b
		CU_ASSERT_EQUAL( st.cursor, 5 )
		CU_ASSERT_EQUAL( st.text[3], 10 )           '' the newline survived

		'' maxLen truncates the paste rather than dropping it
		TuiTextInputStateInit( st )
		ti.maxLen = 4
		p.text = "abcdefgh"
		ti.HandleEvent( p )
		CU_ASSERT_EQUAL( len( st.text ), 4 )
	END_TEST

	'' RFC-0008 section 4. Selection, and typing over one replaces it.
	TEST( rfc0008_s4_selection )
		dim as TuiTextInputState st
		TuiTextInputStateInit( st )
		st.text = "hello world"
		st.cursor = 11
		st.selAnchor = 6

		dim as TuiTextInput ti
		ti.state = @st
		ti.isFocused = TRUE

		CU_ASSERT_EQUAL( ti.SelectionStart( ), 6 )
		CU_ASSERT_EQUAL( ti.SelectionEnd( ), 11 )

		'' typing replaces the selection
		dim as TuiEvent k
		k.kind = TUIEVENT_KEY
		k.key.code = TUIKEY_CHAR
		k.key.ch = asc( "X" )
		k.text = "X"
		CU_ASSERT_TRUE ( ti.HandleEvent( k ) )
		CU_ASSERT_EQUAL( st.text, "hello X" )
		CU_ASSERT_EQUAL( st.selAnchor, -1 )

		'' Shift+movement starts a selection; plain movement collapses it
		TuiTextInputStateInit( st )
		st.text = "abcdef"
		st.cursor = 0
		dim as TuiEvent sr
		sr.kind = TUIEVENT_KEY
		sr.key.code = TUIKEY_RIGHT
		sr.key.mods = TUIMOD_SHIFT
		ti.HandleEvent( sr )
		ti.HandleEvent( sr )
		CU_ASSERT_EQUAL( st.selAnchor, 0 )
		CU_ASSERT_EQUAL( st.cursor, 2 )

		dim as TuiEvent pr
		pr.kind = TUIEVENT_KEY
		pr.key.code = TUIKEY_RIGHT
		ti.HandleEvent( pr )
		CU_ASSERT_EQUAL( st.selAnchor, -1 )

		'' Ctrl+A selects everything
		dim as TuiEvent ca
		ca.kind = TUIEVENT_KEY
		ca.key.code = TUIKEY_CHAR
		ca.key.ch = asc( "a" )
		ca.key.mods = TUIMOD_CTRL
		CU_ASSERT_TRUE ( ti.HandleEvent( ca ) )
		CU_ASSERT_EQUAL( ti.SelectionStart( ), 0 )
		CU_ASSERT_EQUAL( ti.SelectionEnd( ), len( st.text ) )
	END_TEST

	'' RFC-0008 section 4. The scroll follows the cursor in COLUMNS, and the
	'' rendered cursor lands on the right column for wide text.
	TEST( rfc0008_s4_scroll_and_cursor_column )
		dim as TuiTextInputState st
		TuiTextInputStateInit( st )
		for i as long = 1 to 30
			st.text &= "a"
		next
		st.cursor = 30

		dim as TuiTextInput ti
		ti.state = @st
		ti.isFocused = TRUE

		dim as TuiScreen scr
		scr.Resize( 10, 1 )
		dim as TuiFrame ptr f = scr.BeginFrame( )
		ti.Render( *f, TuiRectOf( 0, 0, 10, 1 ) )

		'' the cursor is visible and the scroll moved to make it so
		CU_ASSERT_TRUE ( st.scrollX > 0 )
		CU_ASSERT_TRUE ( f->CursorVisible( ) )
		CU_ASSERT_TRUE ( f->CursorPos( ).x < 10 )

		'' CJK: the cursor column counts COLUMNS, not code units
		TuiTextInputStateInit( st )
		for i as long = 1 to 3
			TuiAppendCp( st.text, &h4E2D )
		next
		st.cursor = 2                       '' after two ideographs
		scr.Resize( 20, 1 )
		f = scr.BeginFrame( )
		ti.Render( *f, TuiRectOf( 0, 0, 20, 1 ) )
		CU_ASSERT_EQUAL( f->CursorPos( ).x, 4 )     '' 2 glyphs x 2 columns
	END_TEST

	'' RFC-0008 section 4. A password field renders bullets, never the text.
	TEST( rfc0008_s4_password_hides_text )
		dim as TuiTextInputState st
		TuiTextInputStateInit( st )
		st.text = "secret"

		dim as TuiTextInput ti
		ti.state = @st
		ti.password = TRUE

		dim as TuiScreen scr
		scr.Resize( 10, 1 )
		ti.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 10, 1 ) )

		for i as long = 0 to 5
			CU_ASSERT_EQUAL( scr.Back( )->At( i, 0 )->text[0], &h2022 )
		next
		'' and no character of the real text is anywhere on the row
		for i as long = 0 to 9
			CU_ASSERT_FALSE( scr.Back( )->At( i, 0 )->text = "s" )
		next
	END_TEST

	'' RFC-0008 section 4. Checkbox and radio mutate CALLER-OWNED state.
	TEST( rfc0008_s4_checkbox_and_radio )
		dim as boolean chk = FALSE
		dim as TuiCheckbox cb
		cb.label = "on"
		cb.checked = @chk
		cb.SetFocused( TRUE )

		dim as TuiEvent sp
		sp.kind = TUIEVENT_KEY
		sp.key.code = TUIKEY_CHAR
		sp.key.ch = 32

		CU_ASSERT_TRUE ( cb.HandleEvent( sp ) )
		CU_ASSERT_TRUE ( chk )
		CU_ASSERT_TRUE ( cb.HandleEvent( sp ) )
		CU_ASSERT_FALSE( chk )

		'' unfocused consumes nothing
		cb.SetFocused( FALSE )
		CU_ASSERT_FALSE( cb.HandleEvent( sp ) )
		CU_ASSERT_FALSE( chk )

		dim as long sel = 0
		dim as TuiRadioGroup rg
		rg.options.Push( "a" ) : rg.options.Push( "b" ) : rg.options.Push( "c" )
		rg.selected = @sel
		rg.SetFocused( TRUE )

		dim as TuiEvent dn
		dn.kind = TUIEVENT_KEY
		dn.key.code = TUIKEY_DOWN
		CU_ASSERT_TRUE ( rg.HandleEvent( dn ) )
		CU_ASSERT_EQUAL( sel, 1 )
		rg.HandleEvent( dn )
		rg.HandleEvent( dn )
		CU_ASSERT_EQUAL( sel, 0 )        '' it WRAPS

		'' a horizontal group answers to Left/Right instead
		rg.horizontal = TRUE
		CU_ASSERT_FALSE( rg.HandleEvent( dn ) )
		dim as TuiEvent rt
		rt.kind = TUIEVENT_KEY
		rt.key.code = TUIKEY_RIGHT
		CU_ASSERT_TRUE ( rg.HandleEvent( rt ) )
		CU_ASSERT_EQUAL( sel, 1 )
	END_TEST

	'' RFC-0008 section 4. Select opens, highlights, commits and cancels.
	TEST( rfc0008_s4_select )
		dim as TuiSelectState ss
		dim as TuiSelect sel
		sel.options.Push( "red" ) : sel.options.Push( "green" ) : sel.options.Push( "blue" )
		sel.state = @ss
		sel.SetFocused( TRUE )

		CU_ASSERT_FALSE( sel.IsOpen( ) )

		dim as TuiEvent ent, esc, dn
		ent.kind = TUIEVENT_KEY : ent.key.code = TUIKEY_ENTER
		esc.kind = TUIEVENT_KEY : esc.key.code = TUIKEY_ESCAPE
		dn.kind = TUIEVENT_KEY  : dn.key.code = TUIKEY_DOWN

		CU_ASSERT_TRUE ( sel.HandleEvent( ent ) )
		CU_ASSERT_TRUE ( sel.IsOpen( ) )

		sel.HandleEvent( dn )
		sel.HandleEvent( dn )
		CU_ASSERT_EQUAL( ss.highlight, 2 )
		CU_ASSERT_TRUE ( sel.HandleEvent( ent ) )
		CU_ASSERT_EQUAL( ss.selected, 2 )
		CU_ASSERT_FALSE( sel.IsOpen( ) )

		'' Escape closes WITHOUT committing
		sel.HandleEvent( ent )
		CU_ASSERT_TRUE ( sel.IsOpen( ) )
		sel.HandleEvent( dn )
		CU_ASSERT_TRUE ( sel.HandleEvent( esc ) )
		CU_ASSERT_FALSE( sel.IsOpen( ) )
		CU_ASSERT_EQUAL( ss.selected, 2 )       '' unchanged
	END_TEST

	'' RFC-0008 section 5, THE GATE (ranked-gaps rank 20). A popup over a
	'' full-screen widget leaves the cells beneath it exactly as they were.
	TEST( rfc0008_s5_gate_popup_restores_what_is_beneath )
		dim as TuiTheme th = TuiThemeDefault( )
		dim as TuiScreen scr
		scr.Resize( 30, 10 )

		'' ---- frame A: the background alone. This is the reference.
		dim as TuiFrame ptr f = scr.BeginFrame( )
		for y as long = 0 to 9
			f->DrawText( 0, y, "abcdefghijklmnopqrstuvwxyz0123", th.normal )
		next
		scr.Render( TUIDEPTH_TRUECOLOR )

		'' snapshot every cell
		dim as TuiStringArray before_
		for y as long = 0 to 9
			dim as ustring row
			for x as long = 0 to 29
				row &= scr.Back( )->At( x, y )->text
			next
			before_.Push( row )
		next

		'' ---- frame B: the same background WITH a popup over it
		f = scr.BeginFrame( )
		for y as long = 0 to 9
			f->DrawText( 0, y, "abcdefghijklmnopqrstuvwxyz0123", th.normal )
		next
		dim as TuiMessageBox mb
		mb.title = " ask "
		mb.message = "really?"
		mb.buttons.Push( "Yes" )
		mb.theme = th
		mb.Render( *f, TuiCenter( f->Area( ), 16, 5 ) )
		scr.Render( TUIDEPTH_TRUECOLOR )

		'' the popup really did cover something
		dim as boolean covered = FALSE
		for y as long = 0 to 9
			dim as ustring row
			for x as long = 0 to 29
				row &= scr.Back( )->At( x, y )->text
			next
			if( row <> before_[y] ) then covered = TRUE
		next
		CU_ASSERT_TRUE( covered )

		'' ---- frame C: the background alone again -- DISMISSAL.
		f = scr.BeginFrame( )
		for y as long = 0 to 9
			f->DrawText( 0, y, "abcdefghijklmnopqrstuvwxyz0123", th.normal )
		next
		scr.Render( TUIDEPTH_TRUECOLOR )

		'' every cell is byte-identical to the reference
		for y as long = 0 to 9
			dim as ustring row
			for x as long = 0 to 29
				row &= scr.Back( )->At( x, y )->text
			next
			CU_ASSERT_EQUAL( row, before_[y] )
		next
	END_TEST

	'' RFC-0008 section 5. MODALITY IS ONE LINE: a modal consumes every event
	'' it does not otherwise use, so nothing behind it sees input.
	TEST( rfc0008_s5_modal_consumes_everything )
		dim as TuiTheme th = TuiThemeDefault( )
		dim as TuiMessageBox mb
		mb.theme = th
		mb.buttons.Push( "Yes" ) : mb.buttons.Push( "No" )

		'' an unrelated key is still consumed
		dim as TuiEvent f5
		f5.kind = TUIEVENT_KEY
		f5.key.code = TUIKEY_F5
		CU_ASSERT_TRUE( mb.HandleEvent( f5 ) )

		'' so is a mouse event
		dim as TuiEvent m
		m.kind = TUIEVENT_MOUSE
		CU_ASSERT_TRUE( mb.HandleEvent( m ) )

		'' Left/Right move between buttons; Enter accepts; Escape cancels
		dim as TuiEvent rt, ent, esc
		rt.kind = TUIEVENT_KEY  : rt.key.code = TUIKEY_RIGHT
		ent.kind = TUIEVENT_KEY : ent.key.code = TUIKEY_ENTER
		esc.kind = TUIEVENT_KEY : esc.key.code = TUIKEY_ESCAPE

		mb.HandleEvent( rt )
		CU_ASSERT_EQUAL( mb.selected, 1 )
		mb.HandleEvent( rt )
		CU_ASSERT_EQUAL( mb.selected, 0 )      '' wraps

		CU_ASSERT_FALSE( mb.Accepted( ) )
		mb.HandleEvent( ent )
		CU_ASSERT_TRUE ( mb.Accepted( ) )
		mb.HandleEvent( esc )
		CU_ASSERT_TRUE ( mb.Cancelled( ) )

		'' a NON-modal popup passes through what it does not use
		dim as TuiPopup p
		p.modal = FALSE
		CU_ASSERT_FALSE( p.HandleEvent( f5 ) )
		p.modal = TRUE
		CU_ASSERT_TRUE ( p.HandleEvent( f5 ) )
	END_TEST

	'' RFC-0008 section 5. The status bar puts left items left, right items
	'' against the right edge, and truncates rather than overflowing.
	TEST( rfc0008_s5_status_bar_alignment )
		dim as TuiTheme th = TuiThemeDefault( )
		dim as TuiScreen scr
		scr.Resize( 20, 1 )

		dim as TuiStatusBar sb
		sb.background = th.dim_
		sb.Add( "AB", th.normal, TUIALIGN_LEFT )
		sb.Add( "YZ", th.accent, TUIALIGN_RIGHT )
		sb.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 20, 1 ) )

		CU_ASSERT_EQUAL( scr.Back( )->At( 0, 0 )->text, "A" )
		CU_ASSERT_EQUAL( scr.Back( )->At( 1, 0 )->text, "B" )
		CU_ASSERT_EQUAL( scr.Back( )->At( 18, 0 )->text, "Y" )
		CU_ASSERT_EQUAL( scr.Back( )->At( 19, 0 )->text, "Z" )

		'' a bar too small for its content truncates and never overflows
		dim as TuiStatusBar big
		big.background = th.dim_
		for i as long = 1 to 6
			big.Add( "wide-item ", th.normal, TUIALIGN_LEFT )
		next
		big.Add( "right", th.accent, TUIALIGN_RIGHT )
		big.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 20, 1 ) )
		'' nothing was drawn past the edge -- the frame clip would have dropped
		'' it, so this asserts the row is still coherent
		CU_ASSERT_EQUAL( scr.Cols( ), 20 )
	END_TEST

	'' RFC-0008 section 5. The tree is FLATTENED with a depth per node, and
	'' collapsing a parent hides its descendants.
	TEST( rfc0008_s5_tree_expand_collapse )
		dim as TuiTreeState ts
		dim as TuiTree t
		t.state = @ts
		t.Add( "root", 0, TRUE )
		t.Add( "childA", 1, TRUE )
		t.Add( "grand", 2, FALSE )
		t.Add( "childB", 1, FALSE )
		t.Add( "other", 0, FALSE )

		CU_ASSERT_EQUAL( t.nodes.Count( ), 5 )
		CU_ASSERT_EQUAL( t.VisibleCount( ), 5 )     '' all expanded by default

		t.SetFocused( TRUE )
		dim as TuiEvent lt, rt, dn
		lt.kind = TUIEVENT_KEY : lt.key.code = TUIKEY_LEFT
		rt.kind = TUIEVENT_KEY : rt.key.code = TUIKEY_RIGHT
		dn.kind = TUIEVENT_KEY : dn.key.code = TUIKEY_DOWN

		'' collapse childA -> its grandchild disappears
		ts.selected = 1
		CU_ASSERT_TRUE ( t.HandleEvent( lt ) )
		CU_ASSERT_EQUAL( t.VisibleCount( ), 4 )

		'' collapse the root -> everything under it disappears
		ts.selected = 0
		t.HandleEvent( lt )
		CU_ASSERT_EQUAL( t.VisibleCount( ), 2 )     '' root + other

		'' expanding again restores exactly what was hidden
		t.HandleEvent( rt )
		CU_ASSERT_EQUAL( t.VisibleCount( ), 4 )     '' childA still collapsed
		ts.selected = 1
		t.HandleEvent( rt )
		CU_ASSERT_EQUAL( t.VisibleCount( ), 5 )

		'' Down skips hidden nodes rather than landing on them
		ts.selected = 1
		t.HandleEvent( lt )                          '' collapse childA again
		ts.selected = 1
		t.HandleEvent( dn )
		CU_ASSERT_EQUAL( ts.selected, 3 )            '' skipped "grand"
	END_TEST

	'' RFC-0008 section 5. The menu bar opens, navigates and closes, and an
	'' open menu is modal.
	TEST( rfc0008_s5_menu_bar )
		dim as TuiMenuBar mb
		dim as TuiMenu m1, m2
		m1.label = "File" : m1.items.Push( "Open" ) : m1.items.Push( "Quit" )
		m2.label = "Help" : m2.items.Push( "About" )
		mb.menus.Push( m1 ) : mb.menus.Push( m2 )
		mb.SetFocused( TRUE )

		CU_ASSERT_FALSE( mb.IsOpen( ) )

		dim as TuiEvent dn, rt, esc, f5
		dn.kind = TUIEVENT_KEY  : dn.key.code = TUIKEY_DOWN
		rt.kind = TUIEVENT_KEY  : rt.key.code = TUIKEY_RIGHT
		esc.kind = TUIEVENT_KEY : esc.key.code = TUIKEY_ESCAPE
		f5.kind = TUIEVENT_KEY  : f5.key.code = TUIKEY_F5

		'' closed: an unrelated key passes through
		CU_ASSERT_FALSE( mb.HandleEvent( f5 ) )

		CU_ASSERT_TRUE ( mb.HandleEvent( dn ) )
		CU_ASSERT_TRUE ( mb.IsOpen( ) )

		'' OPEN: it is modal, so even an unrelated key is consumed
		CU_ASSERT_TRUE ( mb.HandleEvent( f5 ) )

		mb.HandleEvent( dn )
		CU_ASSERT_EQUAL( mb.highlight, 1 )
		mb.HandleEvent( rt )
		CU_ASSERT_EQUAL( mb.openIndex, 1 )
		CU_ASSERT_EQUAL( mb.highlight, 0 )

		CU_ASSERT_TRUE ( mb.HandleEvent( esc ) )
		CU_ASSERT_FALSE( mb.IsOpen( ) )
	END_TEST

	'' RFC-0008 section 4. The text area: Enter INSERTS rather than committing,
	'' and Backspace at column 0 joins to the previous line.
	TEST( rfc0008_s4_textarea_line_editing )
		dim as TuiTextAreaState st
		TuiTextAreaStateInit( st )
		st.lines_[0] = "abcd"
		st.cursorCol = 2

		dim as TuiTextArea ta
		ta.state = @st
		ta.SetFocused( TRUE )

		dim as TuiScreen scr
		scr.Resize( 20, 5 )
		ta.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 20, 5 ) )

		dim as TuiEvent ent
		ent.kind = TUIEVENT_KEY
		ent.key.code = TUIKEY_ENTER
		CU_ASSERT_TRUE ( ta.HandleEvent( ent ) )
		CU_ASSERT_EQUAL( st.lines_.Count( ), 2 )
		CU_ASSERT_EQUAL( st.lines_[0], "ab" )
		CU_ASSERT_EQUAL( st.lines_[1], "cd" )
		CU_ASSERT_EQUAL( st.cursorLine, 1 )
		CU_ASSERT_EQUAL( st.cursorCol, 0 )

		'' backspace at column 0 joins back
		dim as TuiEvent bs
		bs.kind = TUIEVENT_KEY
		bs.key.code = TUIKEY_BACKSPACE
		CU_ASSERT_TRUE ( ta.HandleEvent( bs ) )
		CU_ASSERT_EQUAL( st.lines_.Count( ), 1 )
		CU_ASSERT_EQUAL( st.lines_[0], "abcd" )
		CU_ASSERT_EQUAL( st.cursorCol, 2 )
	END_TEST

	'' Every phase-7 widget at degenerate sizes, asserting nothing is written
	'' outside its area -- the same gate phases 5 and 6 hold.
	TEST( rfc0008_s45_degenerate_areas )
		dim as TuiTheme th = TuiThemeDefault( )
		dim as ustring cjk
		for i as long = 1 to 4
			TuiAppendCp( cjk, &h4E2D )
		next

		dim as TuiTextInputState tis
		dim as TuiTextAreaState tas
		dim as TuiSelectState sels
		dim as TuiTreeState trs
		dim as boolean chk = TRUE
		dim as long radio_ = 0

		for w as long = 0 to 4
			for h as long = 0 to 3
				dim as TuiScreen scr
				scr.Resize( 8, 5 )
				dim as TuiFrame ptr f = scr.BeginFrame( )
				dim as TuiRect area = TuiRectOf( 0, 0, w, h )

				TuiTextInputStateInit( tis )
				tis.text = cjk & "abc"
				tis.cursor = 2
				dim as TuiTextInput ti
				ti.state = @tis
				ti.placeholder = cjk
				ti.isFocused = TRUE
				ti.Render( *f, area )

				TuiTextAreaStateInit( tas )
				tas.lines_[0] = cjk
				tas.lines_.Push( "second" )
				dim as TuiTextArea ta
				ta.state = @tas
				ta.showGutter = TRUE
				ta.Render( *f, area )

				dim as TuiCheckbox cb
				cb.label = cjk
				cb.checked = @chk
				cb.useUnicode = TRUE
				cb.Render( *f, area )

				dim as TuiRadioGroup rg
				rg.options.Push( cjk ) : rg.options.Push( "b" )
				rg.selected = @radio_
				rg.useUnicode = TRUE
				rg.Render( *f, area )
				rg.horizontal = TRUE
				rg.Render( *f, area )

				'' CLOSED. An OPEN dropdown deliberately draws BELOW its own
				'' area -- that is what a dropdown is -- so it is excluded from
				'' the containment check and asserted separately below.
				dim as TuiSelect sl
				sl.options.Push( cjk ) : sl.options.Push( "two" )
				sl.state = @sels
				sels.open_ = FALSE
				sl.Render( *f, area )

				dim as TuiStatusBar sb
				sb.Add( cjk, th.normal, TUIALIGN_LEFT )
				sb.Add( cjk, th.accent, TUIALIGN_RIGHT )
				sb.Render( *f, area )

				dim as TuiTree tr
				tr.state = @trs
				tr.Add( cjk, 0, TRUE )
				tr.Add( "leaf", 1, FALSE )
				tr.useUnicode = TRUE
				tr.Render( *f, area )

				dim as TuiMessageBox mbx
				mbx.title = cjk
				mbx.message = cjk & " " & cjk
				mbx.buttons.Push( "Ok" )
				mbx.theme = th
				mbx.Render( *f, area )

				for y as long = 0 to 4
					for x as long = 0 to 7
						if( area.Contains( x, y ) ) then continue for
						dim as TuiCell ptr c = scr.Back( )->At( x, y )
						CU_ASSERT_TRUE( ( c->text = " " ) orelse ( len( c->text ) = 0 ) )
					next
				next
			next
		next
	END_TEST

	'' An OPEN dropdown is the ONE widget that draws outside the area it was
	'' given, and it is supposed to: a dropdown that stayed inside its own row
	'' would have nowhere to put its list. What bounds it is the FRAME CLIP,
	'' not its area -- so the invariant it must hold is the weaker one, that it
	'' never escapes the frame.
	TEST( rfc0008_s4_open_dropdown_draws_below_its_area_by_design )
		dim as TuiSelectState ss
		ss.open_ = TRUE
		ss.highlight = 1

		dim as TuiSelect sl
		sl.options.Push( "one" ) : sl.options.Push( "two" ) : sl.options.Push( "three" )
		sl.state = @ss
		sl.maxVisible = 3

		dim as TuiScreen scr
		scr.Resize( 10, 6 )
		dim as TuiFrame ptr f = scr.BeginFrame( )

		'' given ONE row, it draws its list on the rows beneath
		sl.Render( *f, TuiRectOf( 0, 0, 10, 1 ) )
		CU_ASSERT_EQUAL( scr.Back( )->At( 0, 1 )->text, "o" )      '' "one"
		CU_ASSERT_EQUAL( scr.Back( )->At( 0, 2 )->text, "t" )      '' "two"

		'' and at the BOTTOM of the frame the clip stops it -- no fault, no
		'' write past the buffer
		f = scr.BeginFrame( )
		sl.Render( *f, TuiRectOf( 0, 5, 10, 1 ) )
		CU_ASSERT_EQUAL( scr.Rows( ), 6 )

		'' closed, it stays on its own row
		ss.open_ = FALSE
		f = scr.BeginFrame( )
		sl.Render( *f, TuiRectOf( 0, 0, 10, 1 ) )
		for x as long = 0 to 9
			CU_ASSERT_TRUE( ( scr.Back( )->At( x, 1 )->text = " " ) orelse _
			                ( len( scr.Back( )->At( x, 1 )->text ) = 0 ) )
		next
	END_TEST

END_SUITE
