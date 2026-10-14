# Logging, Terminal UIs and SQLite

Three libraries cover three things most programs end up doing. A program that runs for any length
of time needs to say what it did, and **`std/logs`** writes that record properly: with levels,
typed fields, more than one destination and no lines torn apart by threads. A tool that a person
drives from a terminal can do better than `print` and `input`, and **`std/tui`** builds full-screen
interfaces from a grid of cells, a layout solver and some thirty widgets. A program that keeps data
between runs usually wants a database rather than files of its own invention, and **`db/sqlite`**
puts SQLite, the most widely deployed database there is, an `#import` away.

The chapter ends with a map of the finance library, the rest of the `std/money` module from
Chapter 26.

## Logging

```tiko
{{#include ../examples/ch27/log-demo.tiko}}
```

```text
{{#include ../examples/ch27/log-demo.out}}
```

Three objects make a log. A **`Logger`** is what the program calls. A **sink** is where records
go — `ConsoleSink` to the terminal, `FileSink` to a file — and a logger may have several. A
**renderer** turns a record into text: `TextRenderer` for people, `JsonRenderer` for programs.
`lg.AddSink( @con )` connects them. **The logger does not own its sinks**: it keeps a pointer, so
a sink must live at least as long as every logger that uses it.

### Levels

Every record has a **level**, from least to most severe: `LOG_TRACE`, `LOG_DEBUG`, `LOG_INFO`,
`LOG_WARN`, `LOG_ERROR` and `LOG_FATAL` (10 to 60, ten apart so a program can define its own in
between), plus `LOG_OFF`. **`MinLevel`** discards everything below it, and a discarded record is
never built — its fields are not converted, and nothing is allocated. Its arguments are still
evaluated, though: `lg.Trace( ).AddText( "dump", Expensive( ) )` calls `Expensive` whatever the level.

`LOG_FATAL` is a severity and nothing more. It does not end the program; a library that called
`end` on its host's behalf would be a bad library. Write the `end` yourself.

`LevelName`, `LevelNameShort` and `LevelFromName` convert to and from text, so a level can come
from a configuration file or the command line. `LevelFromName` leaves its output unchanged when the
name is not a level — a typo in a setting does not silently switch logging off.

### Records with fields

`lg.Info( "message" )` logs a line. For anything with data in it, **`lg.Warn( )`** without a
message starts a record, each **field** method adds a name and a value, and **`Msg( "text" )`**
finishes and sends it: `AddText`, `AddInt`, `AddUInt`, `AddFloat`, `AddBool`, `AddPtr`, and `AddTime` and `AddSpan` for
Chapter 25's `Instant` and `TimeSpan`. The values keep their types all the way to the renderer, so a
JSON renderer writes `3` and not `"3"`. A record that is never finished is never sent: forgetting
`Msg( )` costs a missing line, which is noticed, rather than a stray one.

**`WithField( name, value )`** returns a **child logger** that adds that field to every record it
writes, with the parent's level and sinks — `db` above marks everything from the database layer.
The child is a copy: changing the parent later does not change it.

### Files, JSON and the default logger

```tiko
{{#include ../examples/ch27/log-json.tiko}}
```

```text
{{#include ../examples/ch27/log-json.out}}
```

**`FileSink( path, @renderer )`** appends to a file. It can also **rotate** the file — set
`policy` to `RP_SIZE`, `RP_DAILY` or `RP_BOTH`, with `maxbytes` and `maxbackups` — so a long-running
program's log does not grow without bound. `JsonRenderer` writes one JSON object per line, which
log-collecting tools read directly; each object begins with the time, which the listing skips
because it is different on every run.

```tiko
{{#include ../examples/ch27/log-default.tiko}}
```

```text
{{#include ../examples/ch27/log-default.out}}
```

Passing a logger to every procedure that might log is tedious. The **default logger** is one
logger for the whole program, and `std/logs` holds it, so there is nothing to define:
**`LogInit`** attaches a sink and sets the level, **`DefaultLogger( )`** reaches it from anywhere, and
**`LogShutdown`** flushes and closes its sinks. It is not called for you at exit, so a program
calls it last, or risks losing its final lines.

A sink that cannot write — a full disk, a deleted folder — does not stop the program or return an
error to every log call. It counts what it dropped (`DroppedCount( )`) and reports the failure
through a handler that `SetLogErrorHandler` replaces. **`AsyncSink`** wraps another sink and writes
from a background thread, so a slow destination does not slow the program down; its `policy`
decides what happens when its queue is full — wait (`OP_BLOCK`), or drop the newest or oldest
record and count it.

**Every sink is safe to share between threads.** Each one holds a lock while it renders and writes
a record, so two threads' records never interleave inside a line — which `print #` to a shared
file does not promise. And a `ConsoleSink` writes to **stderr** by default: logs are diagnostics,
and a program whose output is piped into another must not mix them into the pipe. It colours the
level word on a terminal and never when its output is redirected.

## Terminal user interfaces

`std/tui` draws full-screen terminal programs: editors, dashboards, wizards, the menus of an
installer. It works on a grid of cells, and three ideas carry the whole library.

**The application is three methods.** A `TuiApp` has `Init`, which sets up state; `Update`, which
receives an event (a key, the mouse, a resize, a timer tick) and changes state; and `View`, which
draws the screen from state. Update never draws and View never changes anything.

**The screen is redrawn from scratch every frame, and only the difference is written.** There is no
tree of widget objects to keep in step with the data. `View` describes the whole screen each time;
the library compares that with the previous frame and sends the terminal only the cells that
changed. An unchanged frame costs nothing.

**Widgets are values; their state is yours.** A widget is built in `View` and thrown away. What must
survive between frames — a list's selection, a text box's contents, which widget has the focus —
lives in a state record that your app owns and the widget points at.

```tiko
{{#include ../examples/ch27/tui-hello.tiko}}
```

```text
{{#include ../examples/ch27/tui-hello.out}}
```

A real program ends with **`tui.TuiRun( app, tui.TuiTermOptionsDefault( ) )`**, which takes over the
terminal, runs the loop — wait for events, apply them all, draw once — and restores the terminal
on the way out, even after a crash. It returns a `Result`: run with its output redirected, it
fails with a message instead of drawing a dashboard into a file.

The listing does what a test does instead. **`TuiRenderOnce( app, screen )`** draws one frame into
a screen with no terminal at all and returns the bytes it would have sent, and `screen.Front( )`
holds the cells, which `Dump` prints. `Update` is a plain method, so feeding it an event is just a
call. The byte counts show the difference engine at work: the first frame draws everything, the
second only the changed digit, the third nothing.

`Update` returns a **command**: `TuiNone( )`, `TuiRedraw( )`, `TuiQuit( code )`, or
`TuiTick( ms )` to receive a timer event — one tick per call, so an animation re-arms it on each
tick.

### Layout and widgets

```tiko
{{#include ../examples/ch27/tui-widgets.tiko}}
```

```text
{{#include ../examples/ch27/tui-widgets.out}}
```

**Layout** divides a rectangle by constraints: `TuiLength( n )` for exactly `n` cells,
`TuiPercent`, `TuiRatio`, `TuiMin_` and `TuiMax_`, and `TuiFill( )` for a share of what is left.
`TuiSplitV` stacks the pieces and `TuiSplitH` puts them side by side, and splitting a piece again
builds any screen. The result is the same for the same sizes on every platform.

The listing uses four widgets: **`TuiBlock`** (a border with titles, whose `Inner` is the space
inside), **`TuiList`**, **`TuiTable`** with columns sized by the same constraints, and
**`TuiStatusBar`**. The rest of the set includes `TuiParagraph`, `TuiTabs`, `TuiGauge` and
`TuiSpinner`; the form widgets `TuiTextInput`, `TuiTextArea`, `TuiCheckbox`, `TuiRadioGroup` and
`TuiSelect`, with a `TuiFocusRing` that moves the focus on Tab; the overlays `TuiPopup`,
`TuiMessageBox` and `TuiMenuBar`; `TuiTree`; and the charts `TuiGraph`, `TuiSparkline`,
`TuiBarChart` and `TuiMeter`.

The listings draw `TUIBORDER_ASCII` borders so that the output prints anywhere. A real program
usually wants `TUIBORDER_ROUNDED` or `TUIBORDER_PLAIN`, drawn with the box-drawing characters,
and colour: a `TuiStyle` sets foreground, background and attributes, in 24-bit colour that the
library steps down to what the terminal supports.

```admonish danger title="Pitfall"
**A focusable widget must outlive the frame.** A focus ring holds pointers to widgets, so a
`TuiTextInput` declared inside `View` is gone by the time Tab moves to it, and the form cannot be
navigated. Make every widget that takes the focus a field of the app, as the state records are.
```

## SQLite

SQLite is a database in a library: no server, one file per database (or none, in memory), and
the SQL language. The **`db/sqlite`** module wraps it: `#import "db/sqlite"`, and its names are
written `sqlite.Database` and so on (or bare, after `using sqlite`).

```tiko
{{#include ../examples/ch27/contacts-db.tiko}}
```

```text
{{#include ../examples/ch27/contacts-db.out}}
```

A **`Database`** opens a file with `Open( path )` or a private in-memory database with
`OpenMemory( )`. **`Execute`** runs a statement that returns no rows; **`Query`** runs one that does,
and **`QueryFirst`** and **`QueryScalar`** return just the first row or the first value. Each
returns a `Result` (Chapter 17), and a failure carries SQLite's message: the last line of the
listing is a `not null` constraint refusing a row.

```admonish danger title="Pitfall"
**Never build SQL by pasting values into the text.** `"... where name = '" & name & "'"` breaks on
the first name with an apostrophe in it, and lets anyone who controls the value rewrite the query.
Write `?` where each value goes and pass the values with `sqlite.Args( … )`: they travel
separately from the SQL and cannot change what it means.
```

A row is read by column name — `r[ "email" ]` — or by position, and each value converts with
`AsText( )`, `AsInt64( )`, `AsDouble( )` or `AsBlob( )`; `IsNull( )` tells a missing value from an
empty one. Text is `ustring` throughout, stored as UTF-8.

**A `Transaction`** groups statements: `Begin`, then `Commit` to keep everything or `Rollback` to
undo everything, as the listing does with its `delete`. A transaction is also how many inserts
become fast: each statement outside one is its own transaction, written to disk separately.

A `Database`, `Statement` and `Transaction` are **handles**: they cannot be copied (Chapter 21), so
they are passed `byref`. For a statement run many times, `db.Prepare( stmt, sql )` compiles it once
and `Bind` gives it new values each time.

### Importing CSV

```text
{{#include ../examples/ch27/people.csv}}
```

```tiko
{{#include ../examples/ch27/csv-import.tiko}}
```

```text
{{#include ../examples/ch27/csv-import.out}}
```

The same module has **`ImportCsv( db, table, path )`**, which reads real CSV
— quoted fields, commas and doubled quotes inside them, line breaks inside quotes, either kind of
line ending — creates the table from the header row, and loads every line in one transaction. An
empty field arrives as NULL. `ImportCsvWith` takes a `CsvOptions` for another delimiter or a file
without a header, and **`ExportCsv( db, sql, path )`** writes a query's result back out.

## The finance library

Chapter 26 used `Decimal`, `Currency` and loan schedules from **`#import "std/money"`**. The same
module carries the rest of a finance library, one source file per subject, all built on `Decimal`:

| File | Covers |
|---|---|
| `fincore.tiko` | interest, rates and the conventions they are quoted in; compounding and payment frequency; day counts |
| `fintvm.tiko` | the time value of money: present and future value, annuities |
| `finloan.tiko` | loans, mortgages and amortization schedules |
| `fincash.tiko` | cash flows: net present value, internal rate of return, payback |
| `findeprec.tiko` | depreciation, by six methods |
| `finport.tiko` | portfolio returns and risk: volatility, drawdown, Sharpe and Sortino ratios |
| `finsolve.tiko` | the one root finder behind every implied rate |
| `finerror.tiko` | `FinanceError`, which every fallible call returns in its `Result` |

Each calculation is exact where it can be — growth over a whole number of periods, every sum and
product of money — and uses `float64` only where a fractional power or a solver makes that
impossible, converting back to `Decimal` at a fixed scale. The comments in `pkg/std/money` document
every function, and all of them are reached as `money.`.

## What it costs

- **A disabled log level costs one comparison.** An enabled record costs its fields, the
  rendering, and a lock per sink.
- **A frame costs its drawing plus a cell-by-cell comparison** of the whole screen; an
  unchanged frame writes nothing, and an idle interface uses no processor time.
- **Each SQL statement outside a transaction is a separate write to disk.** Thousands of inserts
  belong in one transaction; a prepared statement saves compiling the SQL each time.
- **`db/sqlite` links SQLite itself into the program**, from a static library of about 2 MB that
  ships with tiko; nothing needs installing on the machine that runs it.

## Summary

- `#import "std/logs"`: a `Logger` with `MinLevel` and sinks; `Info( "text" )`, or
  `Warn( ).AddText( … ).AddInt( … ).Msg( "text" )` for fields; `WithField` for a child logger.
- Sinks: `ConsoleSink` (stderr by default), `FileSink` with rotation, `AsyncSink`; renderers:
  `TextRenderer`, `JsonRenderer`. The logger does not own its sinks.
- `LogInit`, `DefaultLogger( )` and `LogShutdown` for the one program-wide logger, which
  `std/logs` holds.
- `#import "std/tui"`: a `TuiApp` with `Init`, `Update` and `View`; `TuiRun` drives it, and
  `TuiRenderOnce` draws a frame with no terminal. Layout with constraints, widgets as values, state
  in the app.
- `#import "db/sqlite"`: `Database`, `Execute`, `Query`, parameters with `?` and `Args`,
  `Transaction`; every call returns a `Result`. `ImportCsv` and `ExportCsv` move CSV.
- `std/money` also carries rates, the time value of money, loans, cash flows, depreciation and
  portfolio measures.

## Exercises

1. Store a list of sales in a table, then print each region's total and number of sales, largest
   first, with one SQL query. {solution="ex27-01"}
2. Set a logger's minimum level from a level name given on the command line, falling back to
   `INFO` for a name that is not a level. {solution="ex27-02"}
3. Add a `FileSink` to `log-demo.tiko` beside the console, so every record goes to both. What
   happens to the file if the program is run twice?
4. Make `tui-widgets.tiko` respond to the Down key by moving the list's selection, and check it the
   way `tui-hello.tiko` checks its key press.
5. Import a CSV file of your own, then use a `Transaction` to delete the rows that fail a check and
   roll back if more than half of them would go.
