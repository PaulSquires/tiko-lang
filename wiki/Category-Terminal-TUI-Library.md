[Home](Home) › [All Categories](Categories) › **Terminal TUI Library**

# Terminal TUI Library

> 📘 **Working examples:** [hello.tiko](Modern-Tui-Example-Hello) · [form.tiko](Modern-Tui-Example-Form) · [dashboard.tiko](Modern-Tui-Example-Dashboard) — complete programs.

```freebasic
#import "std/numeric"
#import "std/tui"
using tui, numeric

type HelloApp extends TuiApp
    as int32 presses
    declare function Init( ) as TuiCmd override
    declare function Update( byref e as TuiEvent ) as TuiCmd override
    declare sub View( byref f as TuiFrame ) override
end type

function HelloApp.Init( ) as TuiCmd
    presses = 0
    return TuiNone( )
end function

function HelloApp.Update( byref e as TuiEvent ) as TuiCmd
    if( e.kind = TUIEVENT_KEY ) then
        if( e.key.code = TUIKEY_ESCAPE ) then return TuiQuit( 0 )
        presses += 1
        return TuiRedraw( )
    end if
    return TuiNone( )
end function

sub HelloApp.View( byref f as TuiFrame )
    dim as TuiBlock b
    b.borderKind = TUIBORDER_ROUNDED
    b.sides = TUISIDE_ALL
    b.AddTitle( " hello ", TuiStyleDefault( ), TUISIDE_TOP, TUIALIGN_CENTER )
    b.Render( f, f.Area( ) )

    dim as TuiParagraph p
    p.align = TUIALIGN_CENTER
    p.text = "keys pressed: " & str( presses )
    p.Render( f, b.Inner( f.Area( ) ) )
end sub

dim as HelloApp app
dim as TuiRunResult r = TuiRun( app, TuiTermOptionsDefault( ) )
```

FreeBASIC's console surface is SCREEN, LOCATE, COLOR, INKEY and GETMOUSE. That is sixteen colours, no key modifiers, no resize notification, no bracketed paste, and on Linux no mouse at all. Every FB program that wants a dashboard, a wizard or an interactive CLI grows its own LOCATE/PRINT scaffolding and stops at the same ceiling. This module replaces that ceiling.

It ships ALONGSIDE the legacy console and changes none of it. SCREEN, LOCATE, COLOR and INKEY remain bit-for-bit what they were.

LIBRARY ONLY. Every line is FreeBASIC. No compiler change, no new runtime C -- the terminal is driven by declaring Win32 and libc entry points from FB.

TARGETS: tiko's three, all x86-64 -- windows-x86_64 (the default on Windows), win64 and linux-x86_64. There is no 32-bit target.

## What You Get

```freebasic
A CELL GRID that is float64-buffered and DIFFED, so an unchanged frame
  costs zero bytes and a changed one costs only what changed.
24-BIT COLOUR with an automatic downgrade ladder -- truecolour, 256,
  ANSI-16 or mono, chosen from what the terminal actually reports.
REAL KEY EVENTS: named keys, Ctrl/Alt/Shift modifiers, function keys,
  and a VT parser that does not confuse Esc with the start of a sequence.
A MOUSE, on both platforms, including the wheel.
RESIZE as an event rather than a poll.
CORRECT COLUMN WIDTHS for CJK, combining marks and zero-width characters,
  from a generated Unicode 17.0.0 East Asian Width table.
A CONSTRAINT LAYOUT SOLVER -- Length, Percent, Ratio, Min, Max, Fill --
  that splits a rectangle deterministically.
THIRTY-ODD WIDGETS: blocks, paragraphs, lists, tables, tabs, gauges,
  text inputs, checkboxes, radio groups, selects, popups, menus, trees,
  braille line graphs, sparklines, bar charts and gradient meters.
AN APPLICATION LOOP in the Elm/Bubbletea shape: Init, Update, View.
A TERMINAL THAT IS ALWAYS RESTORED, including after a crash or a signal.
```

And one thing you do not get, which is worth knowing before you start: there is no retained widget tree. Widgets are values you rebuild every frame. See THE IMMEDIATE-MODE BARGAIN below -- it is the single idea the rest follows from.

## The Three Examples

Working programs, not sketches. They live in examples/ next to this file:

```freebasic
examples/hello.tiko       the smallest complete program -- one box, one
                         keypress counter, a clean exit
examples/form.tiko        focus traversal across text inputs, a checkbox,
                         a radio group and a select, with a confirm
                         dialog on submit
examples/dashboard.tiko   the btop-style screen this module was measured
                         against: braille history plots, gradient meters,
                         a scrolling process table with a scrollbar, a
                         status bar, mouse support and a 250 ms tick
```

Build and run:

```freebasic
tiko examples/hello.tiko        ' windows-x86_64 on Windows, linux-x86_64 on Linux
```

With a packaged toolchain no -i and no -p are needed: the modules and the runtime are in it. Run them from a REAL TERMINAL -- redirected output is rejected with an honest error rather than a dashboard drawn into a pipe.

tiko builds all three with no diagnostics for windows-x86_64 and win64, and compiles them for linux-x86_64 with `-c`; they were built, not run, because they need a real terminal.

Read dashboard.tiko if you read only one. Everything in this document appears in it.

## The Immediate-Mode Bargain

There is no widget tree, no layout invalidation and no dirty-flag propagation. Every frame you describe the whole screen from your own state; the module diffs that description against the last one and writes only the difference.

```freebasic
sub MyApp.View( byref f as TuiFrame )
    dim as TuiParagraph p          '' a LOCAL. Built and thrown away.
    p.text = "hits: " & str( hits )
    p.Render( f, f.Area( ) )
end sub
```

What you gain: a frame is a pure function of your state, so it is reproducible, testable without a terminal, and impossible to leave stale.

What it costs, and the rule that follows from it:

```freebasic
WIDGETS THAT HOLD FOCUS OR EDITING STATE MUST OUTLIVE THE FRAME.
```

A TuiParagraph can be a local because nothing points at it afterwards. A TuiTextInput cannot: the focus ring holds a TuiWidget PTR, and a local dies at END SUB. Make focusable widgets FIELDS OF YOUR APP.

This is not a hypothetical. examples/form.tiko was written with its inputs as locals and could not Tab to any of them; it is defect 2 in the docset README.

```freebasic
type FormApp extends TuiApp
    as TuiTextInput   nameBox      '' FIELDS -- they live as long as the app
    as TuiCheckbox    agree
    as TuiFocusRing   ring

    as TuiTextInputState nameState    '' state is caller-owned; see below
end type
```

Widget STATE structs (TuiTextInputState, TuiListState, TuiTableState, TuiSelectState, TuiTreeState, TuiTextAreaState) are always owned by you and pointed at by the widget. The widget never allocates or frees them. That is what lets a widget be a throwaway value while the scroll position survives.

## The Application Loop

Three methods. Update never draws; View never mutates. That separation is the only rule, and it is what makes a frame reproducible from state.

```freebasic
type TuiApp extends Object
    declare abstract function Init( ) as TuiCmd
    declare abstract function Update( byref e as TuiEvent ) as TuiCmd
    declare abstract sub View( byref f as TuiFrame )
    declare virtual sub Shutdown( )
    declare virtual destructor( )
end type

declare function TuiRun( byref app as TuiApp, _
                         byval opts as TuiTermOptions ) as TuiRunResult
```

TuiRunResult is Result( of long, TuiError ). It carries the application's exit code, or the error that stopped it from STARTING -- a program whose stdout is a pipe gets TUIERR_NOTATTY here and can print an honest message.

```freebasic
dim as TuiRunResult r = TuiRun( app, TuiTermOptionsDefault( ) )
if( r.IsOk( ) = false ) then
    print "myapp: " & r.Failure( ).Message( )     '' safe: TuiRun has
    end 1                                         '' already restored
end if
end r.Value( )
```

INIT RETURNS A COMMAND, and it has to. TuiTick is one-shot -- Update re-arms it in response to the tick it fired -- so the FIRST tick can only come from Init, which is the only thing that runs before the first poll. An Init that returns TuiNone( ) simply schedules nothing.

```freebasic
function DashApp.Init( ) as TuiCmd
    LoadEverything( )
    return TuiTick( 250 )        '' start animating
end function

function DashApp.Update( byref e as TuiEvent ) as TuiCmd
    if( e.kind = TUIEVENT_TICK ) then
        Sample( )
        return TuiTick( 250 )    '' RE-ARM. One-shot, remember.
    end if
    return TuiNone( )
end function
```

The loop, in order: poll for an event with a budget; drain every further pending event without rendering; deliver a due tick; render once if anything changed and the frame deadline has passed.

DRAINING MATTERS. A held arrow key or a mouse drag delivers faster than the frame rate. The loop applies every pending event and renders ONCE, so the frame reflects the latest state rather than lagging behind a queue it can never catch up with.

NOTHING DIRTY, NOTHING DRAWN. An idle TUI blocks in the poll and uses no CPU.

## Commands

```freebasic
TuiNone( )              do nothing
TuiRedraw( )            mark dirty; the next frame is rendered
TuiQuit( code )         leave the loop, return code (default 0)
TuiTick( ms )           deliver one TUIEVENT_TICK after ms. ONE-SHOT.
                        A negative delay clamps to 0.
TuiInvalidate( )        force a FULL repaint, not a diff
TuiSuspend( )           leave the terminal, raise SIGTSTP, come back
```

TuiCmd is a plain value -- .kind and .arg -- so an app can build one and pass it around before returning it.

TuiRunOptions tunes the loop:

```freebasic
dim as TuiRunOptions ro = TuiRunOptionsDefault( )
ro.fps = 30                  '' default 60
ro.quitOnCtrlC = FALSE       '' default TRUE
TuiRun( app, opts, ro )
```

quitOnCtrlC exists because raw mode clears ISIG: Ctrl+C never arrives as a signal and never arrives as a key either unless the loop synthesises it.

## Running Without a Terminal

```freebasic
declare function TuiRenderOnce( byref app as TuiApp, _
                                byref scr as TuiScreen ) as string
```

One Init/View cycle against a screen with no terminal at all, returning the bytes the renderer would have written. This is how the module's own suites test applications, and how the benchmark measures frame cost:

```freebasic
dim as MyApp app
dim as TuiScreen scr
scr.Resize( 80, 24 )
app.Init( )

dim as string frame1 = TuiRenderOnce( app, scr )    '' non-empty
dim as string frame2 = TuiRenderOnce( app, scr )    '' EMPTY -- nothing
                                                   '' changed
```

Render the same state twice and the second frame is zero bytes. That is the diff's whole bargain, and it is worth asserting in your own tests.

## Terminal: Enter, Leave, Restore

TuiRun does all of this for you. Use TuiTerminal directly only when you are writing your own loop.

```freebasic
dim as TuiTerminal term
dim as TuiUnitResult er = term.Enter( TuiTermOptionsDefault( ) )
if( er.IsOk( ) = false ) then ...
defer term.Leave( )              '' AT PROCEDURE SCOPE. See below.

term.Write( someBytes )
term.Flush( )
```

TuiTermOptions, all boolean. TuiTermOptionsDefault turns on the first four:

```freebasic
altScreen          ON   switch to the alternate screen, so the user's
                        scrollback survives
rawMode            ON   no line buffering, no echo, no signal keys
hideCursor         ON   hide the hardware cursor
bracketedPaste     ON   a paste arrives as one event, not N keystrokes
mouse              OFF  report mouse press, release, motion and wheel
focusEvents        OFF  report terminal focus in/out
```

THE MOUSE IS OPT-IN, and this catches people. A program that never asks will never receive a mouse event however much else is right:

```freebasic
dim as TuiTermOptions opts = TuiTermOptionsDefault( )
opts.mouse = TRUE                '' examples/dashboard.tiko does exactly this
TuiRun( app, opts )
```

Both are off by default because a program that does not use them should not be making the terminal send them.

THE DEFER GOES AT PROCEDURE SCOPE. tiko-lang's defer fires at the end of the ENCLOSING BLOCK, so a defer written inside the IF that checked Enter would restore the terminal before your loop ran. This is measured behaviour, not a guess.

The module also installs a last-resort restore -- SetConsoleCtrlHandler on Windows, a signal handler on Linux -- so a crash or a Ctrl+Break does not leave the user's shell in raw mode with the cursor hidden. The leave sequence is pre-rendered into a fixed async-signal-safe buffer for exactly that path.

DO NOT PRINT INSIDE A SESSION. On Linux a stray PRINT can emit CSI 6n and block. Ordinary PRINT is safe only after TuiRun returns, which it does with the terminal fully restored.

CAPABILITIES are detected once, from TERM, COLORTERM, WT_SESSION, the Windows build number and GetConsoleMode:

```freebasic
dim as TuiCaps c = term.Caps( )
c.isTerminal        false when stdout is a pipe -- Enter fails in that case
c.depth             TUIDEPTH_MONO / _ANSI16 / _256 / _TRUECOLOR
c.mouse
c.bracketedPaste
c.focusEvents
c.unicode           false means fall back to ASCII borders and glyphs
```

TuiTerminal members: Enter, Leave, IsActive, Size, Caps, DetectCaps, Write, WriteText, Flush, Discard, Pending, TakeResize.

ON WINDOWS, two settings are not optional and are handled for you:

```freebasic
SetConsoleOutputCP( 65001 ). Render( ) emits UTF-8 and Flush( ) sends it
with WriteFile, which the console decodes in its OUTPUT code page -- 437 or
1252 by default. Without this every non-ASCII glyph is mojibake, one cell
per UTF-8 int8.

ENABLE_QUICK_EDIT_MODE cleared, ENABLE_EXTENDED_FLAGS set. QuickEdit is on
by default in most Windows consoles and CONSUMES EVERY MOUSE EVENT for text
selection, and clearing it is silently ignored unless EXTENDED_FLAGS is set
in the same call. QuickEdit is the user's setting, so it is only cleared
when you asked for the mouse, and Leave restores the whole saved mode word.
```

## Geometry

```freebasic
TuiRect     x, y, w, h        the only rectangle
TuiPos      x, y
TuiSize     cols, rows
TuiMargin   left, top, right, bottom

TuiRectOf( x, y, w, h )
TuiSizeOf( cols, rows )
TuiMarginOf( l, t, r, b )
TuiMarginAll( n )

r.Right( )                  x + w
r.Bottom( )                 y + h
r.IsEmpty( )                w <= 0 or h <= 0
r.Contains( px, py )
r.Intersect( other )        the overlap, possibly empty
r.Inner( margin )           shrunk by a margin, never negative
r.Equals( other )
```

Everything is 0-BASED. VT coordinates are 1-based and the conversion happens in exactly one place, inside the renderer, where you never see it.

## Colour and Style

TuiColor is a tagged value, four bytes, and never a UNION -- ustring inside a union is rejected by the compiler and the layout was designed around that.

```freebasic
TuiDefaultColor( )              "whatever the terminal's default is"
TuiAnsi( TUIC_BRIGHTBLUE )      one of the 16
TuiIndexed( 214 )               the 256-colour cube
TuiRgb( 235, 80, 80 )           24-bit

TuiBlack( ) TuiRed( ) TuiGreen( ) TuiYellow( ) TuiBlue( ) TuiMagenta( )
TuiCyan( ) TuiWhite( ) and the eight TuiBright*( ) forms

c.IsDefault( )  c.Equals( o )  c.Index( )
```

THE DOWNGRADE LADDER runs at write time, not at build time. You always write the colour you mean; the renderer reduces it to what the terminal can show.

```freebasic
TUIDEPTH_TRUECOLOR    exact
TUIDEPTH_256          TuiRgbTo256 -- the 6x6x6 cube plus the grey ramp
TUIDEPTH_ANSI16       TuiRgbTo16
TUIDEPTH_MONO         luminance threshold, via TuiLuminance
```

TuiStyle is fg, bg, attrs and a MASK:

```freebasic
dim as TuiStyle s = TuiStyleOf( TuiRgb( 200, 200, 200 ), _
                                TuiRgb( 20, 20, 30 ), _
                                TUIATTR_BOLD )
TuiStyleDefault( )

s.HasAttr( TUIATTR_UNDERLINE )
s.Equals( o )
s.Patch( over )         '' compose: `over` supplies only what it SETS
```

PATCH IS THE ONE TO UNDERSTAND. Assigning a style REPLACES it, so drawing with a style whose bg is default erases whatever was filled underneath. Patch merges using the mask, so a style that sets only fg leaves the background alone.

```freebasic
dim as TuiStyle hl = base.Patch( accent )    '' accent's fg over base's bg
```

This was defect 4 in the docset README: a focused text input punched a black hole through its own focus fill because a secondary style was assigned rather than patched.

Attributes are bitflags: TUIATTR_BOLD, _DIM, _ITALIC, _UNDERLINE, _BLINK, _REVERSE, _STRIKE, _HIDDEN.

TuiTheme is twelve named styles -- normal, dim_, accent, selected, disabled, border, borderFocused, title, success, warning, danger, info. There is no ambient theme singleton; you hold a theme and pass it where it is needed.

```freebasic
dim as TuiTheme th = TuiThemeDefault( )      '' colour
dim as TuiTheme mo = TuiThemeMono( )         '' attributes only
```

## The Buffer and the Frame

TuiScreen owns two buffers and the diff between them. TuiFrame is what View draws into.

```freebasic
scr.Resize( cols, rows )
dim as TuiFrame ptr f = scr.BeginFrame( )
'' ... draw ...
dim as string bytes = scr.Render( TUIDEPTH_TRUECOLOR )
scr.Invalidate( )                '' next Render is a full repaint
```

Drawing on a frame CANNOT FAIL. Everything is clipped; out-of-clip writes are dropped silently. There is no Result on any drawing call, which is why widget code reads the way it does.

```freebasic
f.Area( )                                  the whole buffer
f.Clip( )                                  the current clip rect
f.SetCell( x, y, ch, st )
f.DrawText( x, y, s, st )                  returns COLUMNS advanced
f.FillRect( r, ch, st )
f.BlendStyle( r, over )                    Patch every cell in r
f.PushClip( r ) / f.PopClip( saved )
f.PushLayer( r ) / f.PopLayer( )           overlays: popups draw here
f.SetCursor( x, y ) / f.HideCursor( )
f.CursorVisible( ) / f.CursorPos( )
```

A WIDE GLYPH occupies two cells: the base cell carries the character with width 2 and the next cell is a continuation. The diff knows about this and never splits a pair.

DrawText returning columns rather than characters is deliberate -- it is what you add to x to place the next thing.

## Unicode Width

```freebasic
TuiCharWidth( cp )              0, 1 or 2 columns for one codepoint
TuiStringWidth( s )             columns for a whole ustring
TuiTruncate( s, maxCols, ell )  cut to fit. THE ELLIPSIS DEFAULTS TO "..."
                                and counts toward maxCols -- pass "" for a
                                hard cut
TuiWrap( s, cols )              TuiStringArray of wrapped lines. The break
                                space stays on the line it broke after, so
                                a wrapped line can measure one column wider
                                than you expect
```

The table is generated from Unicode 17.0.0 UCD: 123 wide ranges, 378 zero-width, 179 ambiguous. Wide/Fullwidth measure 2; Mn, Me and Cf measure 0.

AMBIGUOUS WIDTH is narrow by default, which is right for Western terminals and wrong for a CJK locale. One global switch, and it is global on purpose -- a per-call parameter would be threaded through every widget:

```freebasic
TuiSetAmbiguousWide( TRUE )
TuiAmbiguousWide( )
```

WHAT THIS DOES NOT DO, stated plainly because the failure is silent: there is no UAX-29 grapheme clustering. An emoji ZWJ sequence measures as the sum of its parts, so a family emoji is over-measured and will overrun a box. A regional- indicator flag pair measures 2, which happens to be correct. Combining marks attach correctly; everything else that needs full clustering does not.

## Layout

A constraint solver over one rectangle, split horizontally or vertically. No CSS, no flexbox, no parser.

```freebasic
TuiLength( n )          exactly n cells
TuiPercent( n )         n% of the total
TuiRatio( num, den )
TuiMin_( n )            at least n
TuiMax_( n )            at most n
TuiFill( weight )       share what is left, by weight (default 1)

dim as TuiConstraintArray cs
cs.Push( TuiLength( 3 ) )
cs.Push( TuiFill( ) )
cs.Push( TuiLength( 1 ) )
dim as TuiRectArray band = TuiSplitV( f.Area( ), cs )
'' band[0] header, band[1] body, band[2] status bar

TuiSplitH( area, cs )       side by side
TuiSplitV( area, cs )       stacked
TuiSolve( total, cs )       the raw sizes, if you want them yourself
```

Nest freely -- splitting a result again is how dashboard.tiko builds its two-column screen with three stacked panels on the left.

```freebasic
TuiPad( r, margin )         shrink by a margin
TuiPadAll( r, n )           shrink by n on every side
TuiCenter( outer, w, h )    a w-by-h rect centred in outer
TuiAlignIn( outer, w, a )   left / centre / right within outer
```

THE REMAINDER RULE is stated exactly so the result is deterministic: fixed constraints are satisfied first, FILL shares what is left by weight, and any odd cell left over by integer division goes to the earlier slots. Over- subscription shrinks right to left. The same constraints on the same width always give the same answer, on both platforms.

## Events

```freebasic
TuiEvent
    .kind       TUIEVENT_KEY / _MOUSE / _RESIZE / _PASTE / _FOCUS / _TICK
    .key        TuiKey
    .mouse      TuiMouse
    .size       TuiSize, for RESIZE
    .text       ustring, for PASTE
    .focused    boolean, for FOCUS

TuiKey
    .code       TUIKEY_CHAR, or a named key
    .ch         the codepoint, when code = TUIKEY_CHAR
    .mods       TUIMOD_SHIFT / _ALT / _CTRL, bitwise
    .IsChar( )
    .HasMod( m )

TuiMouse
    .kind       TUIMOUSE_PRESS / _RELEASE / _MOVE / _WHEELUP / _WHEELDOWN
    .button     TUIBTN_LEFT / _MIDDLE / _RIGHT / _NONE
    .x, .y      0-based cell coordinates
    .mods
```

Named keys: ENTER, TAB, BACKSPACE, ESCAPE, UP, DOWN, LEFT, RIGHT, HOME, END_, PAGEUP, PAGEDOWN, INSERT, DELETE, F1..F12. END_ has the underscore because END is a statement.

```freebasic
TuiKeyName( k )         "Ctrl+Shift+F5", for display and for logs
```

The usual keyboard shape:

```freebasic
function MyApp.Update( byref e as TuiEvent ) as TuiCmd
    select case e.kind
    case TUIEVENT_KEY
        if( e.key.code = TUIKEY_ESCAPE ) then return TuiQuit( 0 )
        if( e.key.IsChar( ) andalso ( e.key.ch = asc( "q" ) ) ) then
            return TuiQuit( 0 )
        end if
        ...
    case TUIEVENT_MOUSE
        select case e.mouse.kind
        case TUIMOUSE_WHEELDOWN : sel += 3
        case TUIMOUSE_PRESS
            if( bodyRect.Contains( e.mouse.x, e.mouse.y ) ) then ...
        end select
    case TUIEVENT_RESIZE
        return TuiRedraw( )      '' the loop has already resized the screen
    end select
    return TuiNone( )
end function
```

MIXING BOOLEAN AND NON-BOOLEAN operands in one ANDALSO chain is warning 38, and it only appears at -w all. IsChar( ) and HasMod( ) return bare booleans while a comparison does not; hoist to explicit boolean locals when a chain gets long.

TuiInput is the parser, if you drive your own loop: Feed, NextEvent, PushEvent, Reset, Buffered, Queued, WaitingOnLoneEsc.

ESC IS AMBIGUOUS and always will be. A lone Esc and the start of a CSI sequence begin with the same byte, so the parser waits briefly before deciding. That is what WaitingOnLoneEsc reports and why an Esc keypress is marginally slower than any other.

## Widgets

Every widget derives from the abstract TuiWidget, so a container can hold a mixed Array( of TuiWidget ptr ):

```freebasic
type TuiWidget extends Object
    declare abstract sub Render( byref f as TuiFrame, byval area as TuiRect )
    declare abstract function Kind( ) as ustring
    declare virtual function HandleEvent( byref e as TuiEvent ) as boolean
    declare virtual function SizeHint( byval avail as TuiRect ) as TuiSize
    declare virtual function CanFocus( ) as boolean
    declare virtual sub SetFocused( byval on_ as boolean )
    declare virtual destructor( )
end type
```

HandleEvent returns TRUE when it CONSUMED the event. A container offers the event to its focused child first and only acts if the child declined.

FOCUS is a ring you build and drive:

```freebasic
ring.Add( @nameBox )
ring.Add( @agree )
ring.Next_( )                   '' Tab
ring.Prev( )                    '' Shift+Tab
ring.Focus( @agree )
ring.Current( )                 '' Optional( of TuiWidget ptr )
ring.Count( ) / ring.Clear( )
```

The ring calls SetFocused for you; it never owns or frees anything.

```freebasic
THE RING HOLDS POINTERS. Everything you Add must outlive the frame.
```

## The Core Catalogue

TuiBlock -- a border with titles, and the Inner( ) rect inside it.

```freebasic
dim as TuiBlock b
b.borderKind = TUIBORDER_ROUNDED     '' NONE PLAIN ROUNDED DOUBLE THICK ASCII
b.sides = TUISIDE_ALL                '' or TOP or LEFT, bitwise
b.borderStyle = th.border
b.fill = TRUE : b.fillStyle = th.normal
b.AddTitle( " cpu ", th.accent, TUISIDE_TOP, TUIALIGN_LEFT )
b.AddTitle( " 12f ", th.dim_, TUISIDE_TOP, TUIALIGN_RIGHT )
'' NOTE THE ORDER: side, THEN align. A three-argument call sets the SIDE,
'' and passing an alignment there is accepted in silence.
b.Render( f, area )
dim as TuiRect inner = b.Inner( area )
```

Several titles on one border, each independently aligned. That is how the btop-style header row is built.

TuiParagraph -- text, wrapped or not, aligned, scrollable.

```freebasic
p.text = "..." : p.wrap = TRUE : p.align = TUIALIGN_CENTER : p.scrollY = 0
```

Embedded chr(10) starts a new line. Wrapping is by TuiWrap, so it is width-correct for CJK.

TuiList -- a selection list with its own scroll.

```freebasic
dim as TuiListState st            '' YOURS. The list only points at it.
lst.items.Push( "one" ) : lst.items.Push( "two" )
lst.state = @st
lst.selectPrefix = "> "
lst.wrapSelection = TRUE
lst.Render( f, area )
```

Keys: Up, Down, PageUp, PageDown, Home, End. st.selected = -1 means nothing is selected.

TuiTable -- columns sized by the same constraints as the layout solver.

```freebasic
t.headers.Push( "Pid" ) : t.widths.Push( TuiLength( 7 ) )
t.headers.Push( "Program" ) : t.widths.Push( TuiFill( ) )
dim as TuiRow r : r.cells.Push( "25513" ) : r.cells.Push( "zed" )
t.rows.Push( r )
t.state = @tableState
t.showHeader = TRUE
```

TuiTabs, TuiGauge, TuiSpinner, TuiScrollbar round out the set.

```freebasic
gauge.ratio = 0.42 : gauge.showLabel = TRUE
spinner.Advance( )                       '' call it on a tick
sc.total = 240 : sc.visible = 20 : sc.position = st.offset
```

LIST, TABLE AND TREE ALL CLAMP IN Render, not only in HandleEvent. An application that owns its own keymap sets .selected directly, and used to be able to walk the selection off the bottom of the window -- defect 5 in the docset README, 17 of 24 positions wrong before the fix.

## Input Widgets

```freebasic
TuiTextInput     one line, cursor, selection, password mode
TuiTextArea      many lines, optional gutter
TuiCheckbox
TuiRadioGroup    horizontal or vertical
TuiSelect        a dropdown that opens over whatever is beneath it

dim as TuiTextInputState st
TuiTextInputStateInit( st )          '' a SUB: it initialises in place
st.text = "initial text"

box.state = @st
box.placeholder = "your name"
box.normal = th.normal
box.focused_ = th.selected           '' MAKE THESE DIFFERENT, or focus is
box.Render( f, area )                '' invisible

print st.text                        '' read the value straight out
```

EVERY FORM WIDGET POINTS AT YOUR STORAGE, and the shape varies by what it holds. TuiTextInput, TuiTextArea, TuiSelect take a .state pointer; TuiCheckbox takes a `boolean ptr checked` and TuiRadioGroup a `int32 ptr selected`, because their whole state is one value:

```freebasic
dim as boolean agreed
dim as int32 choice

chk.label = "I agree" : chk.checked = @agreed
rg.options.Push( "one" ) : rg.options.Push( "two" )
rg.selected = @choice
```

Editing keys: Left/Right, Ctrl+Left/Right by word, Home/End, Backspace, Delete, Shift+arrows to select, and typing replaces a selection. Cursor positions are CODE UNITS; scroll is COLUMNS.

```freebasic
TuiTextInput.SelectionStart / SelectionEnd / DeleteSelection / Insert
TuiSelect.IsOpen
TuiTextAreaStateInit( state )       '' also a sub, also in place. It leaves
                                    '' ONE EMPTY LINE: a text area with no
                                    '' lines has nowhere to put the cursor
```

SECONDARY STYLES COMPOSE, they do not replace. Placeholder, selection, the active radio option and the selected message-box button are all drawn with base.Patch( ... ) so the widget's own background survives. If you write a new widget, follow that.

## Overlays and Chrome

```freebasic
TuiPopup         a floating block, optionally modal, optionally dimming
TuiMessageBox    title, message, buttons, an INFO/WARNING/ERROR/QUESTION
                 kind, and Accepted( ) / Cancelled( )
TuiMenuBar       menus with drop-downs
TuiStatusBar     items aligned left or right along one row
TuiTree          collapsible nodes with depth, guides and its own scroll

dim as TuiMessageBox mb
mb.title = "Confirm" : mb.message = "Submit the form?"
mb.buttons.Push( "Yes" ) : mb.buttons.Push( "No" )
mb.msgKind = TUIMSG_QUESTION
mb.theme = th
mb.Render( f, f.Area( ) )
if( mb.Accepted( ) ) then ...

sb.Add( " q quit ", th.danger, TUIALIGN_LEFT )
sb.Add( "3/24 ", th.accent, TUIALIGN_RIGHT )      '' hard against the edge

tree.Add( "src", 0, TRUE, 1 )        '' label, depth, hasChildren, userId
tree.Add( "main.tiko", 1, FALSE, 2 )
tree.state = @treeState
```

A POPUP DRAWS OUTSIDE ITS AREA on purpose -- that is what an overlay is. It pushes a layer, and the layer is what makes the cells beneath it restorable when the popup closes. The same is true of an open TuiSelect dropdown.

## Charts

TuiCanvas is a braille sub-cell surface: each terminal cell holds a 2x4 dot grid, so a 40x10 cell area is a 80x40 dot canvas.

```freebasic
dim as TuiCanvas cv = TuiCanvas( 40, 10 )        '' CELLS
cv.Dot( 12, 7, TuiRgb( 120, 220, 160 ) )
cv.Line_( 0, 0, 79, 39, TuiRgb( 200, 80, 80 ) )
cv.Blit( f, area )

cv.DotWidth( ) / DotHeight( ) / CellCols( ) / CellRows( ) / Pattern( cx, cy )
```

The braille block uses the HISTORICAL dot order, which is not raster order -- U+2800 plus a bit set where bit 6 is the bottom-left dot, not the fourth in reading order. Pattern( ) exposes the byte if you want to check it.

```freebasic
TuiGraph        one or more series, braille / block / bar, auto-scaled
TuiSparkline    a float32 row of block characters
TuiBarChart     labelled bars, horizontal or vertical
TuiMeter        a gradient bar with optional partial-cell precision

g.graphKind = TUIGRAPH_BRAILLE
g.autoScale = FALSE : g.minY = 0 : g.maxY = 100
dim as TuiSeries s
for i as int32 = 0 to 199 : s.data.Push( SomeValue( i ) ) : next
s.color = TuiRgb( 120, 220, 160 )
g.series.Push( s )
g.Render( f, area )

m.ratio = 0.62
m.from_ = TuiRgb( 80, 220, 120 ) : m.to_ = TuiRgb( 235, 80, 80 )
m.partialCells = TRUE            '' eighth-block sub-cell precision
m.meterStyle = TUIMETER_SEGMENTED
```

THE RIGHTMOST SAMPLE IS THE NEWEST. A history plot pushes and drops from the front; the graph draws left to right.

## Performance

tiko builds and runs the module's bench program at 200x50 -- 10,000 cells, a braille graph and fifty gradient meters, sixty frames -- on windows-x86_64 with default options. Its build writes 833,656 bytes over the sixty changing frames, none over sixty unchanged ones, and took about 4.2 ms per changing frame.

## Testing Your Own Application

TuiRenderOnce needs no terminal, so an app's View is directly testable:

```freebasic
dim as MyApp app
dim as TuiScreen scr
scr.Resize( 40, 10 )
app.Init( )
app.someField = 42
dim as string frame = TuiRenderOnce( app, scr )
'' assert against `frame`, or read cells out of scr.Front( )
```

Update is a plain function of an event, so feed it one:

```freebasic
dim as TuiEvent k
k.kind = TUIEVENT_KEY : k.key.code = TUIKEY_DOWN
assert( app.Update( k ).kind = TUICMD_REDRAW )
```

A WARNING FROM THIS MODULE'S OWN HISTORY, worth repeating because it will happen to you too. Seven defects were found by running the examples after the suites were green, and the pattern was the same every time: THE SUITES ASSERT WHAT THE MODULE PRODUCES, and the failures were in what a terminal then does with it, or in state carried across calls. A cell-buffer dump cannot catch a wrong output code page, an SGR run leaking into the next frame, or a console that eats mouse events before your process sees them. When something looks wrong on screen and the tests are green, believe the screen.

## Errors

Split by layer, deliberately:

```freebasic
Result( of T, TuiError )    terminal setup, teardown and I/O
never-fail                  all drawing -- out-of-clip writes are dropped
Optional( of T )            lookups, such as TuiFocusRing.Current

TuiError.code               TUIERR_NONE / _NOTATTY / _RAWMODE / _IO /
                            _UNSUPPORTED / _SIZE
TuiError.detail             what was being attempted
TuiError.Message( )         a formatted line, including the OS error
```

## Files

```freebasic
#import "std/tui"   the module, imported whole. pkg/std/tui/ holds:

tui.tiko            the umbrella
tuicore.tiko        geometry, colour, style, theme
tuiterm.tiko        terminal, capabilities, raw mode, restore
tuibuffer.tiko      cells, buffer, frame, screen, the diff
tuiinput.tiko       events, the VT grammar, PollEvent
tuiwidth.tiko       Unicode column widths, truncate, wrap
tuilayout.tiko      the constraint solver
tuiwidget.tiko      the widget protocol, focus ring, buttons, stack
tuiwidgets.tiko     block, paragraph, list, table, tabs, gauge, spinner,
                    scrollbar
tuidraw.tiko        canvas, graph, sparkline, bar chart, meter
tuiform.tiko        text input, text area, checkbox, radio, select
tuichrome.tiko      popup, message box, menu bar, status bar, tree
```

Every name belongs to the module and carries a Tui prefix, following the LogRecord/LogSink precedent. `using tui` at the top of your program is the normal thing to do.

## Naming Traps

FreeBASIC is case-insensitive and has a large statement vocabulary, so several obvious names are unavailable. These are the ones that bite:

```freebasic
kind        collides with the abstract Kind( ) -- hence borderKind,
            graphKind, msgKind, meterStyle
end         a statement -- hence TUIKEY_END_
next        a statement -- hence TuiFocusRing.Next_
line        a statement -- hence TuiCanvas.Line_
min, max    intrinsics -- hence TuiMin_, TuiMax_
stop        a statement -- hence Stop_ in sibling modules
dim         a statement -- hence dim_ on TuiTheme
error       an intrinsic -- hence TUIMSG_ERROR_
focused     collides in some widgets -- hence focused_
from, to    hence from_ and to_ on TuiMeter
open        a statement -- hence open_ on TuiSelectState
lines       hence lines_ on TuiTextAreaState
```

A capturing lambda cannot be given module-level storage -- `var shared h = sub[...]` is error 11 -- and it cannot be converted to a plain procptr, which is error 355. That is why button callbacks come in two forms: TuiButton with a plain TuiOnClick pointer, and the generic TuiButtonOf( of F ) for anything that captures.

## What This Module Does Not Do

Stated so you can plan around it rather than discover it:

```freebasic
No UAX-29 grapheme clustering. Emoji ZWJ sequences measure wrong.
No CSS-like styling or stylesheet language.
No images -- no sixel, no kitty graphics protocol.
No terminfo parsing. Capabilities come from environment variables and
  the console API, not from a terminfo database.
No accessibility layer.
No async/thread bridge yet. A channel-based input layer is deferred
  because its own first rule -- the terminal is not thread-safe -- cannot
  be tested without a tty.
```

## Tests

The module's fbcunit suites are not part of tiko-lang. tiko's own suite pins the fix that made the module build at all: tests/diagnostics/override-unused-generic.test.

## Examples

Three complete, working programs. tiko builds all three with no diagnostics for windows-x86_64 and win64, and compiles them for linux-x86_64 with `-c` (built, not run: they need a real terminal).

- [hello.tiko](Modern-Tui-Example-Hello) — the smallest complete program: one box, a keypress counter, a clean exit.
- [form.tiko](Modern-Tui-Example-Form) — focus traversal across text inputs, a checkbox, a radio group and a select, with a confirm dialog on submit.
- [dashboard.tiko](Modern-Tui-Example-Dashboard) — the btop-style screen this module was measured against: braille history plots, gradient meters, a scrolling process table, mouse support and a 250 ms tick.

## Dialects

-lang fb. The module is namespaced, uses abstract types with `override` throughout, and needs tiko-lang's generics, `ustring`, `Result`, `Optional` and capturing lambdas.

## API reference

One page per entry, 253 in all:

[TuiAlignIn](Modern-Tui-TuiAlignIn) · [TuiAmbiguousWide](Modern-Tui-TuiAmbiguousWide) · [TuiAnsi](Modern-Tui-TuiAnsi) · [TuiApp](Modern-Tui-TuiApp) · [TuiApp.Init](Modern-Tui-TuiApp-Init) · [TuiApp.Shutdown](Modern-Tui-TuiApp-Shutdown) · [TuiApp.Update](Modern-Tui-TuiApp-Update) · [TuiApp.View](Modern-Tui-TuiApp-View) · [TuiBar](Modern-Tui-TuiBar) · [TuiBarChart](Modern-Tui-TuiBarChart) · [TuiBlack](Modern-Tui-TuiBlack) · [TuiBlock](Modern-Tui-TuiBlock) · [TuiBlock.AddTitle](Modern-Tui-TuiBlock-AddTitle) · [TuiBlock.Inner](Modern-Tui-TuiBlock-Inner) · [TuiBlue](Modern-Tui-TuiBlue) · [TuiBorderGlyphs](Modern-Tui-TuiBorderGlyphs) · [TuiBorderSet](Modern-Tui-TuiBorderSet) · [TuiBrightBlack](Modern-Tui-TuiBrightBlack) · [TuiBrightBlue](Modern-Tui-TuiBrightBlue) · [TuiBrightCyan](Modern-Tui-TuiBrightCyan) · [TuiBrightGreen](Modern-Tui-TuiBrightGreen) · [TuiBrightMagenta](Modern-Tui-TuiBrightMagenta) · [TuiBrightRed](Modern-Tui-TuiBrightRed) · [TuiBrightWhite](Modern-Tui-TuiBrightWhite) · [TuiBrightYellow](Modern-Tui-TuiBrightYellow) · [TuiBuffer](Modern-Tui-TuiBuffer) · [TuiBuffer.At](Modern-Tui-TuiBuffer-At) · [TuiBuffer.Clear](Modern-Tui-TuiBuffer-Clear) · [TuiBuffer.Count](Modern-Tui-TuiBuffer-Count) · [TuiBuffer.InBounds](Modern-Tui-TuiBuffer-InBounds) · [TuiBuffer.Resize](Modern-Tui-TuiBuffer-Resize) · [TuiButton](Modern-Tui-TuiButton) · [TuiButtonOf](Modern-Tui-TuiButtonOf) · [TuiCanvas](Modern-Tui-TuiCanvas) · [TuiCanvas.Blit](Modern-Tui-TuiCanvas-Blit) · [TuiCanvas.CellCols](Modern-Tui-TuiCanvas-CellCols) · [TuiCanvas.CellRows](Modern-Tui-TuiCanvas-CellRows) · [TuiCanvas.Clear](Modern-Tui-TuiCanvas-Clear) · [TuiCanvas.Dot](Modern-Tui-TuiCanvas-Dot) · [TuiCanvas.DotHeight](Modern-Tui-TuiCanvas-DotHeight) · [TuiCanvas.DotWidth](Modern-Tui-TuiCanvas-DotWidth) · [TuiCanvas.Line_](Modern-Tui-TuiCanvas-Line) · [TuiCanvas.Pattern](Modern-Tui-TuiCanvas-Pattern) · [TuiCanvas.Resize](Modern-Tui-TuiCanvas-Resize) · [TuiCaps](Modern-Tui-TuiCaps) · [TuiCell](Modern-Tui-TuiCell) · [TuiCell.Equals](Modern-Tui-TuiCell-Equals) · [TuiCell.SetChar](Modern-Tui-TuiCell-SetChar) · [TuiCellBlank](Modern-Tui-TuiCellBlank) · [TuiCenter](Modern-Tui-TuiCenter) · [TuiCharWidth](Modern-Tui-TuiCharWidth) · [TuiCheckbox](Modern-Tui-TuiCheckbox) · [TuiClearScreenSeq](Modern-Tui-TuiClearScreenSeq) · [TuiClockMs](Modern-Tui-TuiClockMs) · [TuiCmd](Modern-Tui-TuiCmd) · [TuiColor](Modern-Tui-TuiColor) · [TuiColor.Equals](Modern-Tui-TuiColor-Equals) · [TuiColor.Index](Modern-Tui-TuiColor-Index) · [TuiColor.IsDefault](Modern-Tui-TuiColor-IsDefault) · [TuiConstraint](Modern-Tui-TuiConstraint) · [TuiCursorTo](Modern-Tui-TuiCursorTo) · [TuiCyan](Modern-Tui-TuiCyan) · [TuiDefaultColor](Modern-Tui-TuiDefaultColor) · [TuiDowngrade](Modern-Tui-TuiDowngrade) · [TuiDowngradeStyle](Modern-Tui-TuiDowngradeStyle) · [TuiEnterSeq](Modern-Tui-TuiEnterSeq) · [TuiError](Modern-Tui-TuiError) · [TuiError.Message](Modern-Tui-TuiError-Message) · [TuiEvent](Modern-Tui-TuiEvent) · [TuiFill](Modern-Tui-TuiFill) · [TuiFocusRing](Modern-Tui-TuiFocusRing) · [TuiFocusRing.Add](Modern-Tui-TuiFocusRing-Add) · [TuiFocusRing.Clear](Modern-Tui-TuiFocusRing-Clear) · [TuiFocusRing.Count](Modern-Tui-TuiFocusRing-Count) · [TuiFocusRing.Current](Modern-Tui-TuiFocusRing-Current) · [TuiFocusRing.Focus](Modern-Tui-TuiFocusRing-Focus) · [TuiFocusRing.Next_](Modern-Tui-TuiFocusRing-Next) · [TuiFocusRing.Prev](Modern-Tui-TuiFocusRing-Prev) · [TuiFrame](Modern-Tui-TuiFrame) · [TuiFrame.Area](Modern-Tui-TuiFrame-Area) · [TuiFrame.BlendStyle](Modern-Tui-TuiFrame-BlendStyle) · [TuiFrame.Clip](Modern-Tui-TuiFrame-Clip) · [TuiFrame.CursorPos](Modern-Tui-TuiFrame-CursorPos) · [TuiFrame.CursorVisible](Modern-Tui-TuiFrame-CursorVisible) · [TuiFrame.DrawText](Modern-Tui-TuiFrame-DrawText) · [TuiFrame.FillRect](Modern-Tui-TuiFrame-FillRect) · [TuiFrame.HideCursor](Modern-Tui-TuiFrame-HideCursor) · [TuiFrame.PopClip](Modern-Tui-TuiFrame-PopClip) · [TuiFrame.PopLayer](Modern-Tui-TuiFrame-PopLayer) · [TuiFrame.PushClip](Modern-Tui-TuiFrame-PushClip) · [TuiFrame.PushLayer](Modern-Tui-TuiFrame-PushLayer) · [TuiFrame.SetCell](Modern-Tui-TuiFrame-SetCell) · [TuiFrame.SetCursor](Modern-Tui-TuiFrame-SetCursor) · [TuiGauge](Modern-Tui-TuiGauge) · [TuiGraph](Modern-Tui-TuiGraph) · [TuiGreen](Modern-Tui-TuiGreen) · [TuiIndexed](Modern-Tui-TuiIndexed) · [TuiInput](Modern-Tui-TuiInput) · [TuiInput.Buffered](Modern-Tui-TuiInput-Buffered) · [TuiInput.Feed](Modern-Tui-TuiInput-Feed) · [TuiInput.NextEvent](Modern-Tui-TuiInput-NextEvent) · [TuiInput.PushEvent](Modern-Tui-TuiInput-PushEvent) · [TuiInput.Queued](Modern-Tui-TuiInput-Queued) · [TuiInput.Reset](Modern-Tui-TuiInput-Reset) · [TuiInput.WaitingOnLoneEsc](Modern-Tui-TuiInput-WaitingOnLoneEsc) · [TuiInvalidate](Modern-Tui-TuiInvalidate) · [TuiKey](Modern-Tui-TuiKey) · [TuiKey.HasMod](Modern-Tui-TuiKey-HasMod) · [TuiKey.IsChar](Modern-Tui-TuiKey-IsChar) · [TuiKeyName](Modern-Tui-TuiKeyName) · [TuiLeaveSeq](Modern-Tui-TuiLeaveSeq) · [TuiLength](Modern-Tui-TuiLength) · [TuiLerpColor](Modern-Tui-TuiLerpColor) · [TuiList](Modern-Tui-TuiList) · [TuiListState](Modern-Tui-TuiListState) · [TuiLuminance](Modern-Tui-TuiLuminance) · [TuiMagenta](Modern-Tui-TuiMagenta) · [TuiMargin](Modern-Tui-TuiMargin) · [TuiMarginAll](Modern-Tui-TuiMarginAll) · [TuiMarginOf](Modern-Tui-TuiMarginOf) · [TuiMax_](Modern-Tui-TuiMax) · [TuiMenu](Modern-Tui-TuiMenu) · [TuiMenuBar](Modern-Tui-TuiMenuBar) · [TuiMenuBar.IsOpen](Modern-Tui-TuiMenuBar-IsOpen) · [TuiMessageBox](Modern-Tui-TuiMessageBox) · [TuiMessageBox.Accepted](Modern-Tui-TuiMessageBox-Accepted) · [TuiMessageBox.Cancelled](Modern-Tui-TuiMessageBox-Cancelled) · [TuiMeter](Modern-Tui-TuiMeter) · [TuiMin_](Modern-Tui-TuiMin) · [TuiMouse](Modern-Tui-TuiMouse) · [TuiNone](Modern-Tui-TuiNone) · [TuiPad](Modern-Tui-TuiPad) · [TuiPadAll](Modern-Tui-TuiPadAll) · [TuiParagraph](Modern-Tui-TuiParagraph) · [TuiPercent](Modern-Tui-TuiPercent) · [TuiPopup](Modern-Tui-TuiPopup) · [TuiPos](Modern-Tui-TuiPos) · [TuiQuit](Modern-Tui-TuiQuit) · [TuiRadioGroup](Modern-Tui-TuiRadioGroup) · [TuiRatio](Modern-Tui-TuiRatio) · [TuiRect](Modern-Tui-TuiRect) · [TuiRect.Bottom](Modern-Tui-TuiRect-Bottom) · [TuiRect.Contains](Modern-Tui-TuiRect-Contains) · [TuiRect.Equals](Modern-Tui-TuiRect-Equals) · [TuiRect.Inner](Modern-Tui-TuiRect-Inner) · [TuiRect.Intersect](Modern-Tui-TuiRect-Intersect) · [TuiRect.IsEmpty](Modern-Tui-TuiRect-IsEmpty) · [TuiRect.Right](Modern-Tui-TuiRect-Right) · [TuiRectOf](Modern-Tui-TuiRectOf) · [TuiRed](Modern-Tui-TuiRed) · [TuiRedraw](Modern-Tui-TuiRedraw) · [TuiRenderOnce](Modern-Tui-TuiRenderOnce) · [TuiRgb](Modern-Tui-TuiRgb) · [TuiRgbTo16](Modern-Tui-TuiRgbTo16) · [TuiRgbTo256](Modern-Tui-TuiRgbTo256) · [TuiRow](Modern-Tui-TuiRow) · [TuiRun](Modern-Tui-TuiRun) · [TuiRunOptions](Modern-Tui-TuiRunOptions) · [TuiRunOptionsDefault](Modern-Tui-TuiRunOptionsDefault) · [TuiScreen](Modern-Tui-TuiScreen) · [TuiScreen.Back](Modern-Tui-TuiScreen-Back) · [TuiScreen.BeginFrame](Modern-Tui-TuiScreen-BeginFrame) · [TuiScreen.Cols](Modern-Tui-TuiScreen-Cols) · [TuiScreen.Front](Modern-Tui-TuiScreen-Front) · [TuiScreen.Invalidate](Modern-Tui-TuiScreen-Invalidate) · [TuiScreen.Render](Modern-Tui-TuiScreen-Render) · [TuiScreen.Resize](Modern-Tui-TuiScreen-Resize) · [TuiScreen.Rows](Modern-Tui-TuiScreen-Rows) · [TuiScrollbar](Modern-Tui-TuiScrollbar) · [TuiSelect](Modern-Tui-TuiSelect) · [TuiSelect.IsOpen](Modern-Tui-TuiSelect-IsOpen) · [TuiSelectState](Modern-Tui-TuiSelectState) · [TuiSeries](Modern-Tui-TuiSeries) · [TuiSetAmbiguousWide](Modern-Tui-TuiSetAmbiguousWide) · [TuiSgr](Modern-Tui-TuiSgr) · [TuiSgrReset](Modern-Tui-TuiSgrReset) · [TuiShowCursorSeq](Modern-Tui-TuiShowCursorSeq) · [TuiSize](Modern-Tui-TuiSize) · [TuiSizeOf](Modern-Tui-TuiSizeOf) · [TuiSolve](Modern-Tui-TuiSolve) · [TuiSparkline](Modern-Tui-TuiSparkline) · [TuiSpinner](Modern-Tui-TuiSpinner) · [TuiSpinner.Advance](Modern-Tui-TuiSpinner-Advance) · [TuiSpinnerDefaultFrames](Modern-Tui-TuiSpinnerDefaultFrames) · [TuiSplitH](Modern-Tui-TuiSplitH) · [TuiSplitV](Modern-Tui-TuiSplitV) · [TuiStack](Modern-Tui-TuiStack) · [TuiStack.Add](Modern-Tui-TuiStack-Add) · [TuiStack.ChildRect](Modern-Tui-TuiStack-ChildRect) · [TuiStatusBar](Modern-Tui-TuiStatusBar) · [TuiStatusBar.Add](Modern-Tui-TuiStatusBar-Add) · [TuiStatusItem](Modern-Tui-TuiStatusItem) · [TuiStatusItemOf](Modern-Tui-TuiStatusItemOf) · [TuiStringWidth](Modern-Tui-TuiStringWidth) · [TuiStyle](Modern-Tui-TuiStyle) · [TuiStyle.Equals](Modern-Tui-TuiStyle-Equals) · [TuiStyle.HasAttr](Modern-Tui-TuiStyle-HasAttr) · [TuiStyle.Patch](Modern-Tui-TuiStyle-Patch) · [TuiStyleDefault](Modern-Tui-TuiStyleDefault) · [TuiStyleOf](Modern-Tui-TuiStyleOf) · [TuiStylePatch](Modern-Tui-TuiStylePatch) · [TuiSuspend](Modern-Tui-TuiSuspend) · [TuiTable](Modern-Tui-TuiTable) · [TuiTableState](Modern-Tui-TuiTableState) · [TuiTabs](Modern-Tui-TuiTabs) · [TuiTermOptions](Modern-Tui-TuiTermOptions) · [TuiTermOptionsDefault](Modern-Tui-TuiTermOptionsDefault) · [TuiTerminal](Modern-Tui-TuiTerminal) · [TuiTerminal.Caps](Modern-Tui-TuiTerminal-Caps) · [TuiTerminal.DetectCaps](Modern-Tui-TuiTerminal-DetectCaps) · [TuiTerminal.Discard](Modern-Tui-TuiTerminal-Discard) · [TuiTerminal.Enter](Modern-Tui-TuiTerminal-Enter) · [TuiTerminal.Flush](Modern-Tui-TuiTerminal-Flush) · [TuiTerminal.IsActive](Modern-Tui-TuiTerminal-IsActive) · [TuiTerminal.Leave](Modern-Tui-TuiTerminal-Leave) · [TuiTerminal.Pending](Modern-Tui-TuiTerminal-Pending) · [TuiTerminal.Size](Modern-Tui-TuiTerminal-Size) · [TuiTerminal.TakeResize](Modern-Tui-TuiTerminal-TakeResize) · [TuiTerminal.Write](Modern-Tui-TuiTerminal-Write) · [TuiTerminal.WriteText](Modern-Tui-TuiTerminal-WriteText) · [TuiTextArea](Modern-Tui-TuiTextArea) · [TuiTextAreaState](Modern-Tui-TuiTextAreaState) · [TuiTextAreaStateInit](Modern-Tui-TuiTextAreaStateInit) · [TuiTextInput](Modern-Tui-TuiTextInput) · [TuiTextInput.DeleteSelection](Modern-Tui-TuiTextInput-DeleteSelection) · [TuiTextInput.Insert](Modern-Tui-TuiTextInput-Insert) · [TuiTextInput.SelectionEnd](Modern-Tui-TuiTextInput-SelectionEnd) · [TuiTextInput.SelectionStart](Modern-Tui-TuiTextInput-SelectionStart) · [TuiTextInputState](Modern-Tui-TuiTextInputState) · [TuiTextInputStateInit](Modern-Tui-TuiTextInputStateInit) · [TuiTheme](Modern-Tui-TuiTheme) · [TuiThemeDefault](Modern-Tui-TuiThemeDefault) · [TuiThemeMono](Modern-Tui-TuiThemeMono) · [TuiTick](Modern-Tui-TuiTick) · [TuiTitle](Modern-Tui-TuiTitle) · [TuiTitleOf](Modern-Tui-TuiTitleOf) · [TuiTree](Modern-Tui-TuiTree) · [TuiTree.Add](Modern-Tui-TuiTree-Add) · [TuiTree.VisibleCount](Modern-Tui-TuiTree-VisibleCount) · [TuiTreeNode](Modern-Tui-TuiTreeNode) · [TuiTreeState](Modern-Tui-TuiTreeState) · [TuiTruncate](Modern-Tui-TuiTruncate) · [TuiWhite](Modern-Tui-TuiWhite) · [TuiWidget](Modern-Tui-TuiWidget) · [TuiWidget.CanFocus](Modern-Tui-TuiWidget-CanFocus) · [TuiWidget.HandleEvent](Modern-Tui-TuiWidget-HandleEvent) · [TuiWidget.Kind](Modern-Tui-TuiWidget-Kind) · [TuiWidget.Render](Modern-Tui-TuiWidget-Render) · [TuiWidget.SetFocused](Modern-Tui-TuiWidget-SetFocused) · [TuiWidget.SizeHint](Modern-Tui-TuiWidget-SizeHint) · [TuiWin32InputMode](Modern-Tui-TuiWin32InputMode) · [TuiWrap](Modern-Tui-TuiWrap) · [TuiYellow](Modern-Tui-TuiYellow)

---



---

[Home](Home) · [Keyword Index](Keyword-Index)
