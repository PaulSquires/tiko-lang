# Terminal UI

`std/tui` draws full-screen terminal programs: dashboards, menus, editors. An
application is a type that extends `tui.TuiApp` and has three methods:

- **`Init`** sets up the state.
- **`Update`** receives an event, such as a key, the mouse, a resize or a
  timer tick, and changes the state. It never draws.
- **`View`** draws the whole screen from the state. It never changes anything.

```tiko
{{#include ../../examples/libraries/tui.tiko}}
```

**Output**

```text
{{#include ../../examples/libraries/tui.out}}
```

A real program ends with `tui.TuiRun( app, tui.TuiTermOptionsDefault( ) )`. It
takes over the terminal, runs the loop (wait for events, apply them, draw once)
and restores the terminal on the way out. It returns a `Result`, and when its
output is not a terminal it fails with `not a terminal` instead of drawing into
a file.

The example does what a test does instead. `TuiRenderOnce( app, screen )`
draws one frame into a screen with no terminal at all and returns the bytes it
would have sent; `screen.Front( )` holds the cells, which `Dump` prints. Since
`Update` is a plain method, feeding it an event is a call.

The byte counts show how drawing works. `View` describes the whole screen every
time, and the library compares it with the previous frame and sends only the
cells that changed: everything the first time, the changed digit the second,
nothing the third.

`Update` returns a command: `TuiNone( )`, `TuiRedraw( )`, `TuiQuit( code )`,
or `TuiTick( ms )` to receive a timer event.

### Activities

1. Make the `+` and `-` characters change the count as well: a character key
   arrives with `e.key.code = tui.TUIKEY_CHAR` and the character in
   `e.key.ch`.
2. Show the count in a second line that says whether it is odd or even.
