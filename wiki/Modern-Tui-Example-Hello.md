[Home](Home) › [Terminal TUI Library](Category-Terminal-TUI-Library) › [Examples](Category-Terminal-TUI-Library) › **hello.bas**

# hello.bas

> **The smallest complete program.** A complete, working program from [Terminal TUI Library](Category-Terminal-TUI-Library). It lives at `docs/tui/examples/hello.bas` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).

One centred box, a keypress counter and a clean exit. Ninety lines, and every part of the module's shape is in it: a TuiApp with Init/Update/View, a TuiBlock with titles on two sides, a centred layout that re-centres itself on resize, and the TuiRun result checked before anything is printed.

## Build and run

```freebasic
tiko hello.bas        ' win64-msvc on Windows, linux-x86_64 on Linux
```

Run it from a REAL TERMINAL. Redirected output is rejected with an honest error rather than a dashboard drawn into a pipe. tiko builds it with no diagnostics for win64-msvc and win64, and compiles it for linux-x86_64 with `-c` (measured 2026-09-24 at origin/master 50c71751; built, not run: it is interactive). fbc builds it clean at `-w all`.

## What to notice

- `Init` returns `TuiNone( )` -- this application wants no timer.
- `View` builds its widgets as LOCALS. That is correct here because nothing points at them afterwards; a focusable widget could not be a local.
- `TuiCenter` is recomputed every frame, so the box follows a resize with no resize handling beyond returning `TuiRedraw( )`.
- PRINT appears only AFTER `TuiRun` returns. Inside a session it is banned -- on Linux a stray PRINT can emit CSI 6n and block.

## Source

```freebasic
'' examples/hello.bas -- the smallest complete TUI program.
''
'' Build (win64-msvc, win64 or linux-x86_64):
''     tiko hello.bas
''
'' Run it from a real terminal. Redirected output is rejected with an honest
'' error rather than a dashboard drawn into a pipe.

#include once "fb/tui.bi"
using FB

'' ---------------------------------------------------------------------------
'' The model. Update mutates it, View reads it, and nothing else touches it.
'' ---------------------------------------------------------------------------
type HelloApp extends TuiApp
	as long presses
	as ustring lastKey
	as TuiTheme theme

	declare function Init( ) as TuiCmd override
	declare function Update( byref e as TuiEvent ) as TuiCmd override
	declare sub View( byref f as TuiFrame ) override
end type

function HelloApp.Init( ) as TuiCmd
	presses = 0
	lastKey = "(none yet)"
	theme = TuiThemeDefault( )
	return TuiNone( )
end function

function HelloApp.Update( byref e as TuiEvent ) as TuiCmd
	select case e.kind
	case TUIEVENT_KEY
		'' q or Esc quits. Ctrl+C never arrives as a key -- ISIG is cleared in
		'' raw mode -- so TuiRun handles it, not us.
		if( e.key.code = TUIKEY_ESCAPE ) then return TuiQuit( 0 )
		if( e.key.IsChar( ) andalso ( e.key.ch = asc( "q" ) ) ) then return TuiQuit( 0 )

		presses += 1
		lastKey = TuiKeyName( e.key )
		return TuiRedraw( )

	case TUIEVENT_RESIZE
		'' TuiRun has already resized and invalidated the screen.
		return TuiRedraw( )
	end select

	return TuiNone( )
end function

sub HelloApp.View( byref f as TuiFrame )
	'' one centred box, whatever the terminal size is
	dim as TuiRect box = TuiCenter( f.Area( ), 44, 7 )

	dim as TuiBlock frame_
	frame_.borderKind = TUIBORDER_ROUNDED
	frame_.sides = TUISIDE_ALL
	frame_.borderStyle = theme.border
	frame_.fill = TRUE
	frame_.fillStyle = theme.normal
	frame_.AddTitle( " hello ", theme.title, TUISIDE_TOP, TUIALIGN_CENTER )
	frame_.AddTitle( " q quits ", theme.dim_, TUISIDE_BOTTOM, TUIALIGN_RIGHT )
	frame_.Render( f, box )

	dim as TuiParagraph p
	p.align = TUIALIGN_CENTER
	p.st = theme.normal
	p.wrap = TRUE
	p.text = "keys pressed: " & str( presses ) & chr( 10 ) & _
	         "last: " & lastKey & chr( 10 ) & chr( 10 ) & _
	         "press q or Esc to quit"
	p.Render( f, frame_.Inner( box ) )
end sub

'' ---------------------------------------------------------------------------
dim as TuiTermOptions opts = TuiTermOptionsDefault( )

dim as HelloApp app
dim as TuiRunResult r = TuiRun( app, opts )

'' TuiRun has fully restored the terminal by the time it returns, so ordinary
'' PRINT is safe again HERE and only here. Inside a session it is banned: on
'' Linux a stray PRINT emits CSI 6n and can block. RFC-0002 section 7.
if( r.IsOk( ) = false ) then
	print "hello: " & r.Failure( ).Message( )
	end 1
end if
end r.Value( )
```

---

**Library:** [Terminal TUI Library](Category-Terminal-TUI-Library)  
**Other examples:** [form.bas](Modern-Tui-Example-Form) · [dashboard.bas](Modern-Tui-Example-Dashboard)
  
**Source:** `docs/tui/examples/hello.bas` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)