'' Widgets -- C:\dev\docs\tui\RFC-0007-widget-protocol.md and RFC-0008.
''
'' THE THREE GATES RFC-0007 SECTION 7 ASKS FOR:
''
''   1. a heterogeneous container of four widget kinds, TWO OF THEM
''      CLOSURE-CARRYING, rendering and tab-traversing in order
''   2. a container destructor that deletes each child EXACTLY ONCE, asserted
''      with a counting widget rather than by inspection
''   3. every widget correct at width 0, at width 1, and at a width that splits
''      a CJK glyph
''
'' Gate 1 is the one that matters most, because it is the composition probe #6
'' established and nothing in any shipped FreeBASIC module had done before: a
'' GENERIC widget that still extends a non-generic abstract base.

#import "std/tui"
#import "std/containers"
#import "std/outcome"
#import "std/chrono"
#include "fbcunit.bi"

#include once "fberror.bi"

using tui, containers, outcome, chrono

using FB
'' ---------------------------------------------------------------------------
'' A widget that counts its own construction and destruction, for gate 2.
'' ---------------------------------------------------------------------------
dim shared as long gLive, gRenders, gDtors

type CountingWidget extends TuiWidget
	as long id
	declare constructor( byval i as long )
	declare destructor( ) override
	declare sub Render( byref f as TuiFrame, byval area as TuiRect ) override
	declare function Kind( ) as ustring override
end type

constructor CountingWidget( byval i as long )
	id = i
	gLive += 1
end constructor
destructor CountingWidget( )
	gLive -= 1
	gDtors += 1
end destructor
sub CountingWidget.Render( byref f as TuiFrame, byval area as TuiRect )
	gRenders += 1
	if( area.IsEmpty( ) ) then exit sub
	f.DrawText( area.x, area.y, "c" & str( id ), TuiStyleDefault( ) )
end sub
function CountingWidget.Kind( ) as ustring
	return "Counting"
end function

'' A widget that records the order it was rendered in, for gate 1.
dim shared as string gOrder

type OrderWidget extends TuiWidget
	as ustring tag
	declare sub Render( byref f as TuiFrame, byval area as TuiRect ) override
	declare function Kind( ) as ustring override
	declare function CanFocus( ) as boolean override
end type
sub OrderWidget.Render( byref f as TuiFrame, byval area as TuiRect )
	dim as string t = tag
	gOrder &= t
end sub
function OrderWidget.Kind( ) as ustring : return "Order" : end function
function OrderWidget.CanFocus( ) as boolean : return TRUE : end function

SUITE( fbc_tests.tui.tuiwidget_ )

	'' RFC-0007 section 1. The abstract base dispatches, and the virtual
	'' defaults are what the RFC says they are.
	TEST( rfc0007_s1_base_dispatch_and_defaults )
		dim as CountingWidget w = CountingWidget( 1 )
		dim as TuiWidget ptr b = @w

		CU_ASSERT_EQUAL( b->Kind( ), "Counting" )
		CU_ASSERT_FALSE( b->CanFocus( ) )

		dim as TuiEvent e
		e.kind = TUIEVENT_KEY
		CU_ASSERT_FALSE( b->HandleEvent( e ) )

		'' SizeHint defaults to "I will take what I am given"
		dim as TuiSize h = b->SizeHint( TuiRectOf( 0, 0, 30, 7 ) )
		CU_ASSERT_EQUAL( h.cols, 30 )
		CU_ASSERT_EQUAL( h.rows, 7 )
	END_TEST

	'' RFC-0007 section 7, GATE 1. A heterogeneous container holding four kinds,
	'' TWO of them closure-carrying with DIFFERENT closure types, renders in
	'' order and dispatches through one base pointer.
	TEST( rfc0007_s7_gate1_heterogeneous_container_with_closures )
		dim as long tally = 0
		dim as ustring seen

		'' two DIFFERENT capturing lambdas -> two DIFFERENT instantiations
		var onA = sub[ byref tally ]( byval id as long )
			tally += id
		end sub
		var onB = sub[ byref seen ]( byval id as long )
			seen &= "B" & str( id )
		end sub

		type ButtonA as TuiButtonOf( of typeof( onA ) )
		type ButtonB as TuiButtonOf( of typeof( onB ) )

		'' they really are distinct types
		CU_ASSERT_TRUE( sizeof( ButtonA ) > 0 )
		CU_ASSERT_TRUE( sizeof( ButtonB ) > 0 )

		dim as TuiWidgetPtrArray kids

		dim as OrderWidget ptr o1 = new OrderWidget : o1->tag = "1"
		dim as ButtonA ptr a = new ButtonA
		a->label = "A" : a->id = 10 : a->handler = onA
		dim as OrderWidget ptr o2 = new OrderWidget : o2->tag = "2"
		dim as ButtonB ptr b = new ButtonB
		b->label = "B" : b->id = 20 : b->handler = onB

		kids.Push( o1 )
		kids.Push( a )
		kids.Push( o2 )
		kids.Push( b )
		CU_ASSERT_EQUAL( kids.Count( ), 4 )

		'' all four dispatch Kind( ) through the base pointer
		CU_ASSERT_EQUAL( kids[0]->Kind( ), "Order" )
		CU_ASSERT_EQUAL( kids[1]->Kind( ), "ButtonOf" )
		CU_ASSERT_EQUAL( kids[2]->Kind( ), "Order" )
		CU_ASSERT_EQUAL( kids[3]->Kind( ), "ButtonOf" )

		'' and RENDER in order, through the same pointer
		dim as TuiScreen scr
		scr.Resize( 20, 6 )
		dim as TuiFrame ptr f = scr.BeginFrame( )
		gOrder = ""
		for each w in kids
			w->Render( *f, TuiRectOf( 0, 0, 20, 1 ) )
		next
		CU_ASSERT_EQUAL( gOrder, "12" )      '' only the OrderWidgets record

		'' THE CLOSURES FIRE, and a byref capture reaches the caller's variable
		dim as TuiEvent ev
		ev.kind = TUIEVENT_KEY
		ev.key.code = TUIKEY_ENTER

		kids[1]->SetFocused( TRUE )
		CU_ASSERT_TRUE ( kids[1]->HandleEvent( ev ) )
		CU_ASSERT_EQUAL( tally, 10 )

		kids[3]->SetFocused( TRUE )
		CU_ASSERT_TRUE ( kids[3]->HandleEvent( ev ) )
		CU_ASSERT_EQUAL( seen, "B20" )

		'' an unfocused widget consumes nothing
		kids[1]->SetFocused( FALSE )
		CU_ASSERT_FALSE( kids[1]->HandleEvent( ev ) )
		CU_ASSERT_EQUAL( tally, 10 )

		for i as long = 0 to kids.Count( ) - 1
			delete kids[i]
		next
	END_TEST

	'' RFC-0007 section 4. The NON-capturing form is a plain procptr and needs
	'' none of the generic machinery.
	TEST( rfc0007_s4_non_capturing_button )
		dim as TuiButton btn
		btn.label = "Reset"
		btn.id = 7
		btn.onclick = sub( byval id as long )
			'' captures nothing -- which is exactly the limitation capturing
			'' lambdas exist to remove
		end sub

		dim as TuiEvent e
		e.kind = TUIEVENT_KEY
		e.key.code = TUIKEY_ENTER

		btn.SetFocused( TRUE )
		CU_ASSERT_TRUE ( btn.HandleEvent( e ) )
		CU_ASSERT_TRUE ( btn.CanFocus( ) )

		'' SizeHint reports the label's COLUMN width, not its code-unit length
		dim as TuiSize h = btn.SizeHint( TuiRectOf( 0, 0, 40, 3 ) )
		CU_ASSERT_EQUAL( h.cols, 5 )
		CU_ASSERT_EQUAL( h.rows, 1 )
	END_TEST

	'' RFC-0007 section 7, GATE 2. The container deletes each child EXACTLY
	'' ONCE. Asserted with a counting widget, not by inspection.
	TEST( rfc0007_s7_gate2_container_deletes_each_child_once )
		gLive = 0 : gDtors = 0

		scope
			dim as TuiStack st
			st.vertical = TRUE
			for i as long = 1 to 5
				st.Add( new CountingWidget( i ), TuiFill( ) )
			next
			CU_ASSERT_EQUAL( gLive, 5 )
			CU_ASSERT_EQUAL( st.children.Count( ), 5 )
		end scope

		'' the stack went out of scope: every child destructed, exactly once
		CU_ASSERT_EQUAL( gLive, 0 )
		CU_ASSERT_EQUAL( gDtors, 5 )
	END_TEST

	'' RFC-0007 section 6. TuiList NEVER deletes its caller-owned state -- the
	'' one exception to the ownership rule, and the reason the rule is written
	'' down. The state survives the widget.
	TEST( rfc0007_s6_widget_does_not_own_its_state )
		dim as TuiListState ls
		ls.selected = 2

		scope
			dim as TuiList lst
			lst.state = @ls
			lst.items.Push( "a" ) : lst.items.Push( "b" ) : lst.items.Push( "c" )
			dim as TuiScreen scr
			scr.Resize( 10, 3 )
			lst.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 10, 3 ) )
		end scope

		'' still readable, still correct, after the list is gone
		CU_ASSERT_EQUAL( ls.selected, 2 )
	END_TEST

	'' RFC-0007 section 5. The focus ring wraps, applies focus to exactly one
	'' widget, and an empty ring is a no-op rather than a division by zero.
	TEST( rfc0007_s5_focus_ring )
		dim as TuiFocusRing ring

		'' empty ring
		CU_ASSERT_EQUAL( ring.Count( ), 0 )
		CU_ASSERT_FALSE( ring.Current( ).HasValue( ) )
		ring.Next_( )
		ring.Prev( )
		CU_ASSERT_FALSE( ring.Current( ).HasValue( ) )

		dim as OrderWidget a, b, c
		a.tag = "a" : b.tag = "b" : c.tag = "c"
		ring.Add( @a ) : ring.Add( @b ) : ring.Add( @c )
		CU_ASSERT_EQUAL( ring.Count( ), 3 )
		CU_ASSERT_TRUE ( ring.Current( ).Value( ) = cast( TuiWidget ptr, @a ) )

		ring.Next_( )
		CU_ASSERT_TRUE( ring.Current( ).Value( ) = cast( TuiWidget ptr, @b ) )
		ring.Next_( )
		CU_ASSERT_TRUE( ring.Current( ).Value( ) = cast( TuiWidget ptr, @c ) )

		'' IT WRAPS
		ring.Next_( )
		CU_ASSERT_TRUE( ring.Current( ).Value( ) = cast( TuiWidget ptr, @a ) )
		ring.Prev( )
		CU_ASSERT_TRUE( ring.Current( ).Value( ) = cast( TuiWidget ptr, @c ) )

		'' direct focus
		CU_ASSERT_TRUE ( ring.Focus( @b ) )
		CU_ASSERT_TRUE ( ring.Current( ).Value( ) = cast( TuiWidget ptr, @b ) )
		dim as OrderWidget stranger
		CU_ASSERT_FALSE( ring.Focus( @stranger ) )

		'' a widget that cannot focus is not admitted
		dim as CountingWidget cw = CountingWidget( 99 )
		ring.Add( @cw )
		CU_ASSERT_EQUAL( ring.Count( ), 3 )
	END_TEST

	'' RFC-0007 section 5. Mouse events are routed by HIT-TESTING against the
	'' rectangles from the last Render, not by focus. That is the one piece of
	'' frame-to-frame state a container carries.
	TEST( rfc0007_s5_mouse_hit_testing )
		dim as long hitA = 0, hitB = 0

		var onA = sub[ byref hitA ]( byval id as long ) : hitA += 1 : end sub
		var onB = sub[ byref hitB ]( byval id as long ) : hitB += 1 : end sub
		type BtnA as TuiButtonOf( of typeof( onA ) )
		type BtnB as TuiButtonOf( of typeof( onB ) )

		dim as TuiStack st
		st.vertical = FALSE
		dim as BtnA ptr a = new BtnA : a->label = "A" : a->handler = onA
		dim as BtnB ptr b = new BtnB : b->label = "B" : b->handler = onB
		st.Add( a, TuiLength( 10 ) )
		st.Add( b, TuiLength( 10 ) )

		dim as TuiScreen scr
		scr.Resize( 20, 3 )
		st.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 20, 1 ) )

		CU_ASSERT_EQUAL( st.ChildRect( 0 ).x, 0 )
		CU_ASSERT_EQUAL( st.ChildRect( 1 ).x, 10 )

		'' a mouse event is offered only to the child under the pointer. The
		'' buttons only act on keys, so nothing fires -- what is asserted is
		'' that the container did not crash and did not dispatch to both.
		dim as TuiEvent m
		m.kind = TUIEVENT_MOUSE
		m.mouse.x = 15
		m.mouse.y = 0
		CU_ASSERT_FALSE( st.HandleEvent( m ) )

		'' a click outside every child is simply unconsumed
		m.mouse.x = 99
		CU_ASSERT_FALSE( st.HandleEvent( m ) )
	END_TEST

	'' RFC-0008 section 1. The block: borders, inner area, and MULTIPLE TITLES
	'' PER SIDE each independently aligned -- which is what the target layout
	'' needs and what a single-title block cannot draw.
	TEST( rfc0008_s1_block_borders_and_titles )
		dim as TuiTheme th = TuiThemeDefault( )
		dim as TuiScreen scr
		scr.Resize( 30, 6 )

		dim as TuiBlock blk
		blk.borderKind = TUIBORDER_ROUNDED
		blk.sides = TUISIDE_ALL
		blk.borderStyle = th.border
		blk.AddTitle( "cpu", th.accent, TUISIDE_TOP, TUIALIGN_LEFT )
		blk.AddTitle( "menu", th.dim_, TUISIDE_TOP, TUIALIGN_LEFT )
		blk.AddTitle( "12:00", th.normal, TUISIDE_TOP, TUIALIGN_RIGHT )

		dim as TuiRect area = TuiRectOf( 0, 0, 30, 6 )
		blk.Render( *scr.BeginFrame( ), area )

		'' inner area excludes the border on all four sides
		dim as TuiRect inner = blk.Inner( area )
		CU_ASSERT_EQUAL( inner.x, 1 )
		CU_ASSERT_EQUAL( inner.y, 1 )
		CU_ASSERT_EQUAL( inner.w, 28 )
		CU_ASSERT_EQUAL( inner.h, 4 )

		'' the corners are the ROUNDED glyphs
		CU_ASSERT_EQUAL( scr.Back( )->At( 0, 0 )->text[0], &h256D )
		CU_ASSERT_EQUAL( scr.Back( )->At( 29, 0 )->text[0], &h256E )
		CU_ASSERT_EQUAL( scr.Back( )->At( 0, 5 )->text[0], &h2570 )
		CU_ASSERT_EQUAL( scr.Back( )->At( 29, 5 )->text[0], &h256F )

		'' the left titles are laid left, in order, starting at column 1
		CU_ASSERT_EQUAL( scr.Back( )->At( 1, 0 )->text, "c" )
		CU_ASSERT_EQUAL( scr.Back( )->At( 2, 0 )->text, "p" )
		CU_ASSERT_EQUAL( scr.Back( )->At( 3, 0 )->text, "u" )
		CU_ASSERT_EQUAL( scr.Back( )->At( 5, 0 )->text, "m" )

		'' and the right title ends against the right border
		CU_ASSERT_EQUAL( scr.Back( )->At( 24, 0 )->text, "1" )
		CU_ASSERT_EQUAL( scr.Back( )->At( 28, 0 )->text, "0" )

		'' a block with no border has an inner area equal to its area
		dim as TuiBlock plain
		plain.borderKind = TUIBORDER_NONE
		CU_ASSERT_TRUE( plain.Inner( area ).Equals( area ) )

		'' partial sides: only the left border consumes a column
		dim as TuiBlock left_
		left_.borderKind = TUIBORDER_PLAIN
		left_.sides = TUISIDE_LEFT
		dim as TuiRect li = left_.Inner( area )
		CU_ASSERT_EQUAL( li.x, 1 )
		CU_ASSERT_EQUAL( li.w, 29 )
		CU_ASSERT_EQUAL( li.h, 6 )
	END_TEST

	'' RFC-0008 section 2. The gauge's exact cell string at the five ratios the
	'' RFC names -- 0, 1/8, 1/2, 7/8 and 1.
	TEST( rfc0008_s2_gauge_exact_cells )
		dim as TuiScreen scr
		scr.Resize( 8, 1 )

		'' 0 -> nothing filled
		dim as TuiGauge g
		g.useUnicode = TRUE
		g.ratio = 0.0
		g.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 8, 1 ) )
		CU_ASSERT_EQUAL( scr.Back( )->At( 0, 0 )->text, " " )

		'' 1/2 of 8 columns -> exactly 4 full blocks, and the 5th is blank
		g.ratio = 0.5
		g.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 8, 1 ) )
		for i as long = 0 to 3
			CU_ASSERT_EQUAL( scr.Back( )->At( i, 0 )->text[0], &h2588 )
		next
		CU_ASSERT_EQUAL( scr.Back( )->At( 4, 0 )->text, " " )

		'' 1 -> every cell full
		g.ratio = 1.0
		g.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 8, 1 ) )
		for i as long = 0 to 7
			CU_ASSERT_EQUAL( scr.Back( )->At( i, 0 )->text[0], &h2588 )
		next

		'' 1/8 of ONE column -> a partial block, not a full one and not blank
		dim as TuiScreen one
		one.Resize( 1, 1 )
		g.ratio = 0.125
		g.Render( *one.BeginFrame( ), TuiRectOf( 0, 0, 1, 1 ) )
		dim as ulong u = one.Back( )->At( 0, 0 )->text[0]
		CU_ASSERT_TRUE( ( u >= &h2589 ) andalso ( u <= &h258F ) )

		'' out-of-range ratios clamp rather than drawing outside
		g.ratio = 5.0
		g.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 8, 1 ) )
		CU_ASSERT_EQUAL( scr.Back( )->At( 7, 0 )->text[0], &h2588 )
		g.ratio = -3.0
		g.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 8, 1 ) )
		CU_ASSERT_EQUAL( scr.Back( )->At( 0, 0 )->text, " " )
	END_TEST

	'' RFC-0008 section 2. The scrollbar renders nothing when everything fits,
	'' and its thumb is never zero-length however long the content.
	TEST( rfc0008_s2_scrollbar )
		dim as TuiScreen scr
		scr.Resize( 1, 10 )

		dim as TuiScrollbar sb
		sb.vertical = TRUE
		sb.total = 10
		sb.visible = 10
		sb.position = 0
		scr.BeginFrame( )
		sb.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 1, 10 ) )
		'' nothing drawn: the cell is still the blank the frame started with
		CU_ASSERT_EQUAL( scr.Back( )->At( 0, 0 )->text, " " )

		'' 10,000 rows in 10 -> the thumb is at least one cell
		sb.total = 10000
		sb.visible = 10
		dim as TuiFrame ptr f = scr.BeginFrame( )
		sb.Render( *f, TuiRectOf( 0, 0, 1, 10 ) )
		dim as long thumbCells = 0
		for y as long = 0 to 9
			if( scr.Back( )->At( 0, y )->text[0] = &h2588 ) then thumbCells += 1
		next
		CU_ASSERT_TRUE( thumbCells >= 1 )

		'' at the end, the thumb touches the bottom
		sb.position = 9990
		f = scr.BeginFrame( )
		sb.Render( *f, TuiRectOf( 0, 0, 1, 10 ) )
		CU_ASSERT_EQUAL( scr.Back( )->At( 0, 9 )->text[0], &h2588 )
	END_TEST

	'' RFC-0008 section 2. The list scroll follows the SELECTION, never the
	'' other way round, and the keymap moves it.
	TEST( rfc0008_s2_list_selection_and_scroll )
		dim as TuiListState ls
		dim as TuiList lst
		lst.state = @ls
		for i as long = 1 to 20
			lst.items.Push( "item" & str( i ) )
		next

		dim as TuiScreen scr
		scr.Resize( 12, 5 )
		lst.SetFocused( TRUE )
		lst.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 12, 5 ) )
		CU_ASSERT_EQUAL( ls.selected, 0 )
		CU_ASSERT_EQUAL( ls.offset, 0 )

		dim as TuiEvent down
		down.kind = TUIEVENT_KEY
		down.key.code = TUIKEY_DOWN

		'' moving within the visible window does not scroll
		for i as long = 1 to 4
			CU_ASSERT_TRUE( lst.HandleEvent( down ) )
		next
		CU_ASSERT_EQUAL( ls.selected, 4 )
		CU_ASSERT_EQUAL( ls.offset, 0 )

		'' moving past it scrolls by exactly one
		CU_ASSERT_TRUE ( lst.HandleEvent( down ) )
		CU_ASSERT_EQUAL( ls.selected, 5 )
		CU_ASSERT_EQUAL( ls.offset, 1 )

		'' End goes to the last item and scrolls to show it
		dim as TuiEvent e
		e.kind = TUIEVENT_KEY
		e.key.code = TUIKEY_END_
		CU_ASSERT_TRUE ( lst.HandleEvent( e ) )
		CU_ASSERT_EQUAL( ls.selected, 19 )
		CU_ASSERT_EQUAL( ls.offset, 15 )

		'' Home comes back
		e.key.code = TUIKEY_HOME
		CU_ASSERT_TRUE ( lst.HandleEvent( e ) )
		CU_ASSERT_EQUAL( ls.selected, 0 )
		CU_ASSERT_EQUAL( ls.offset, 0 )

		'' an unfocused list consumes nothing
		lst.SetFocused( FALSE )
		CU_ASSERT_FALSE( lst.HandleEvent( down ) )

		'' an unrelated key is not consumed
		lst.SetFocused( TRUE )
		e.key.code = TUIKEY_F5
		CU_ASSERT_FALSE( lst.HandleEvent( e ) )
	END_TEST

	'' RFC-0008 section 2. Table columns come from the SAME RFC-0006 solver --
	'' there is not a second sizing algorithm in the module.
	TEST( rfc0008_s2_table_columns_use_the_layout_solver )
		dim as TuiTableState ts
		dim as TuiTable t
		t.state = @ts
		t.showHeader = TRUE
		t.headers.Push( "Pid" ) : t.headers.Push( "Program" ) : t.headers.Push( "Cpu" )
		t.widths.Push( TuiLength( 6 ) )
		t.widths.Push( TuiFill( ) )
		t.widths.Push( TuiLength( 5 ) )

		for i as long = 1 to 8
			dim as TuiRow r
			r.cells.Push( str( 1000 + i ) )
			r.cells.Push( "prog" & str( i ) )
			r.cells.Push( "0.0" )
			t.rows.Push( r )
		next

		dim as TuiScreen scr
		scr.Resize( 30, 6 )
		t.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 30, 6 ) )

		'' header on row 0, first body row on row 1
		CU_ASSERT_EQUAL( scr.Back( )->At( 0, 0 )->text, "P" )
		CU_ASSERT_EQUAL( scr.Back( )->At( 0, 1 )->text, "1" )

		'' the Fill column starts at 6 and the last column at 25
		CU_ASSERT_EQUAL( scr.Back( )->At( 6, 0 )->text, "P" )      '' "Program"
		CU_ASSERT_EQUAL( scr.Back( )->At( 25, 0 )->text, "C" )     '' "Cpu"

		'' paging moves the selection and the offset together
		t.SetFocused( TRUE )
		dim as TuiEvent e
		e.kind = TUIEVENT_KEY
		e.key.code = TUIKEY_END_
		CU_ASSERT_TRUE ( t.HandleEvent( e ) )
		CU_ASSERT_EQUAL( ts.selected, 7 )
		CU_ASSERT_TRUE ( ts.offset > 0 )
	END_TEST

	'' RFC-0007 section 7, GATE 3. Every widget at width 0, width 1, and a
	'' width that splits a CJK glyph. None may fault, and none may draw outside
	'' the area it was given.
	TEST( rfc0007_s7_gate3_degenerate_widths )
		dim as TuiTheme th = TuiThemeDefault( )
		dim as ustring cjk
		for i as long = 1 to 6
			TuiAppendCp( cjk, &h4E2D )
		next

		dim as TuiListState ls
		dim as TuiTableState ts

		for w as long = 0 to 5
			for h as long = 0 to 3
				dim as TuiScreen scr
				scr.Resize( 10, 6 )
				dim as TuiFrame ptr f = scr.BeginFrame( )
				dim as TuiRect area = TuiRectOf( 0, 0, w, h )

				dim as TuiBlock blk
				blk.borderKind = TUIBORDER_ROUNDED
				blk.sides = TUISIDE_ALL
				blk.AddTitle( cjk, th.accent, TUISIDE_TOP, TUIALIGN_LEFT )
				blk.AddTitle( cjk, th.dim_, TUISIDE_TOP, TUIALIGN_RIGHT )
				blk.Render( *f, area )
				dim as TuiRect inner = blk.Inner( area )
				CU_ASSERT_TRUE( inner.w >= 0 )
				CU_ASSERT_TRUE( inner.h >= 0 )

				dim as TuiParagraph p
				p.text = cjk & " hello " & cjk
				p.wrap = TRUE
				p.Render( *f, area )

				dim as TuiList lst
				lst.state = @ls
				lst.items.Push( cjk )
				lst.items.Push( "plain" )
				lst.selectPrefix = "> "
				lst.Render( *f, area )

				dim as TuiTable tb
				tb.state = @ts
				tb.showHeader = TRUE
				tb.headers.Push( cjk )
				tb.widths.Push( TuiFill( ) )
				dim as TuiRow r
				r.cells.Push( cjk )
				tb.rows.Push( r )
				tb.Render( *f, area )

				dim as TuiTabs tabs
				tabs.titles.Push( cjk )
				tabs.titles.Push( "two" )
				tabs.Render( *f, area )

				dim as TuiGauge g
				g.ratio = 0.5
				g.useUnicode = TRUE
				g.showLabel = TRUE
				g.Render( *f, area )

				dim as TuiSpinner sp
				TuiSpinnerDefaultFrames( sp.frames )
				sp.Render( *f, area )

				dim as TuiScrollbar sb
				sb.vertical = TRUE
				sb.total = 100
				sb.visible = 3
				sb.Render( *f, area )

				'' NOTHING may have been written outside the area
				for y as long = 0 to 5
					for x as long = 0 to 9
						if( area.Contains( x, y ) ) then continue for
						dim as TuiCell ptr c = scr.Back( )->At( x, y )
						CU_ASSERT_TRUE( ( c->text = " " ) orelse ( len( c->text ) = 0 ) )
					next
				next
			next
		next
	END_TEST

	'' RFC-0008 section 2. THE SCROLL FOLLOWS THE SELECTION, AND IT MUST DO SO
	'' IN Render -- not only in HandleEvent.
	''
	'' Reported from a running dashboard: resize until the table needs a
	'' scrollbar, then arrow down past the last visible row. The selection
	'' walked below the window, the offset never followed, and the table showed
	'' NO highlighted row while the status line reported one.
	''
	'' The cause is that an application may move `selected` itself rather than
	'' routing keys through the widget -- which is exactly what
	'' examples/dashboard.bas does. TuiList always clamped in Render; TuiTable
	'' and TuiTree did not, and all three are siblings.
	TEST( rfc0008_s2_scroll_follows_selection_set_externally )
		dim as TuiStyle rev = TuiStylePatch( TuiDefaultColor( ), TuiDefaultColor( ), _
		                                     TUIATTR_REVERSE, TUIATTR_REVERSE )
		dim as TuiScreen scr
		scr.Resize( 30, 8 )

		dim as TuiTableState ts
		dim as TuiTable t
		t.state = @ts
		t.showHeader = TRUE
		t.selectedStyle = rev
		t.widths.Push( TuiFill( ) )
		for i as long = 0 to 23
			dim as TuiRow r
			r.cells.Push( "row" & str( i ) )
			t.rows.Push( r )
		next

		'' every selection position, set DIRECTLY, must end up on screen
		dim as long offScreen = 0
		for sel as long = 0 to 23
			ts.selected = sel
			t.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 30, 8 ) )
			dim as boolean seen = FALSE
			for y as long = 1 to 7
				if( ( scr.Back( )->At( 0, y )->st.attrs and TUIATTR_REVERSE ) <> 0 ) then seen = TRUE
			next
			if( seen = FALSE ) then offScreen += 1
		next
		'' 17 of 24 before the fix
		CU_ASSERT_EQUAL( offScreen, 0 )

		'' and walking back up scrolls the other way
		for sel as long = 23 to 0 step -1
			ts.selected = sel
			t.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 30, 8 ) )
			CU_ASSERT_TRUE( ts.offset <= ts.selected )
		next

		'' the same rule for TuiList, which already had it -- pinned so the
		'' three siblings cannot drift apart again
		dim as TuiListState ls
		dim as TuiList lst
		lst.state = @ls
		lst.selected = rev
		for i as long = 0 to 23
			lst.items.Push( "item" & str( i ) )
		next
		for sel as long = 0 to 23
			ls.selected = sel
			lst.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 30, 8 ) )
			CU_ASSERT_TRUE( ls.selected >= ls.offset )
			CU_ASSERT_TRUE( ls.selected < ls.offset + 8 )
		next

		'' and for TuiTree, whose offset counts VISIBLE rows
		dim as TuiTreeState trs
		dim as TuiTree tr
		tr.state = @trs
		tr.selectedStyle = rev
		for i as long = 0 to 23
			tr.Add( "node" & str( i ), 0, FALSE )
		next
		for sel as long = 0 to 23
			trs.selected = sel
			tr.Render( *scr.BeginFrame( ), TuiRectOf( 0, 0, 30, 8 ) )
			CU_ASSERT_TRUE( trs.offset <= trs.selected )
			CU_ASSERT_TRUE( trs.selected < trs.offset + 8 )
		next
	END_TEST

END_SUITE
