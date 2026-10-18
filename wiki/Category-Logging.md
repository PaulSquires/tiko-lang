[Home](Home) › [All Categories](Categories) › **Logging**

# Logging

**Logging** is a program keeping a running diary of what it does. As it works, it writes short records -- "server started", "user ada logged in", "could not open config.ini" -- each stamped with the time and marked with how important it is. Nobody reads the diary while things go well. When something goes wrong, often on a machine you cannot sit at, it is how you find out what happened and in what order.

A log record is more than a PRINT. It carries a **level** -- from TRACE, for fine detail, up to FATAL -- so you can switch the noisy ones off without touching the code. It carries **fields**, named values such as `user=ada` or `attempts=3`, that a person can read and a tool can search. And it goes to a **sink**: the console, a file, or anywhere else you choose, without the code that logs needing to know which.

std/logs is tiko's logging library. A **Logger** takes your records and passes them to the sinks you attach to it:

```freebasic
#import "std/logs"
using logs

dim shared as ConsoleSink con
dim shared as Logger lg

lg.MinLevel = LOG_DEBUG
lg.AddSink( @con )

lg.Info( "server started" )

lg.Warn( ).AddText( "user", "quinn" ).AddInt( "attempts", 3 ).Msg( "login failed" )
' 2026-08-12T23:06:34.361Z  WARN   login failed  user=quinn attempts=3
```

It is a library and nothing else: every line of it is tiko, with no compiler change.

## What You Get

- **A level on every record**, and one comparison to filter it out.
- **A timestamp taken for you**: UTC, RFC 3339, sub-second -- plus a monotonic reading, so records still order correctly when the wall clock jumps.
- **Typed fields.** `attempts` stays a number all the way to the sink, so the JSON renderer writes `3`, not `"3"`.
- **A pluggable sink**, so a library can log without knowing the destination.
- **Thread-safe writes.** One mutex per sink, held across the whole write.
- **Child loggers** carrying inherited fields.
- **A call that cannot fail.** No Result, no raise, ever.

And one thing you do not get, which is the reason to read the next section: a format string. Fields arrive through a **chained builder**.

## The Call Site

Two forms. Use the first unless you have something to capture.

```freebasic
lg.Info( "server started" )                       ' one line, no fields

lg.Warn( ).AddText( "user", u ) _                     ' the builder
          .AddInt( "attempts", n ) _
          .Msg( "login failed" )
```

Each field method returns BYREF to the same event; `.Msg( )` is the only method that commits. `.Send( )` commits with the message already set, or empty.

**The event lives on the caller's stack.** `lg.Info( )` returns a LogEvent by value and the chain runs on that temporary, which is what makes this thread-safe with no thread-local storage -- and tiko has none user code can reach.

**An event that is never committed emits nothing.** The destructor does not auto-send. A forgotten `.Msg( )` is a missing line, which you notice; the alternative is a line you never asked for, which you do not.

**A disabled level builds nothing.** Not "builds it and throws it away" -- the field methods return immediately, no LogField is constructed and no array grows. This is asserted, not checked by eye: the test counts value constructions, not output.

What it does not avoid is **evaluating the arguments**:

```freebasic
lg.Trace( ).AddText( "dump", ExpensiveDump( ) ).Msg( "state" )
```

ExpensiveDump( ) runs whether trace is on or not. That is irreducible at run time in a language with no lazy arguments, and it is what the [logging macros](#the-default-logger-and-the-macros) remove at compile time.

## Levels

```text
LOG_TRACE = 10    LOG_DEBUG = 20    LOG_INFO  = 30
LOG_WARN  = 40    LOG_ERROR = 50    LOG_FATAL = 60    LOG_OFF = 1000
```

**Spaced by ten** so you can define your own level between two of these and have every comparison, filter and renderer keep working. Only Go's log/slog gets this right among the mainstream designs.

**LOG_FATAL does not terminate anything.** It is a severity. spdlog and logrus do terminate, so someone will expect it; a library that calls END on behalf of its host is not a library. Write the two statements.

```text
LevelName( lv ) as ustring              "WARN"; an unnamed level gives "40"
LevelNameShort( lv ) as ustring         "WRN"
LevelFromName( s, byref out ) as boolean  "warn" / "WRN" / "40", any case
LevelToSyslog( lv ) as int32            RFC 5424 severity
```

LevelFromName leaves the out-parameter alone when it fails -- a typo in an environment variable must not silently turn logging off.

## Fields And Values

A field is a name and a LogValue: a tag plus a union, nine tags, closed.

```text
LK_NULL  LK_BOOL  LK_INT  LK_UINT  LK_DBL
LK_STR   LK_PTR   LK_INSTANT  LK_TIMESPAN
```

The set is **closed** so a renderer can SELECT CASE over it with no `case else` meaning "I do not know what this is". Adding a tenth is a change to every renderer in the same commit.

The ustring sits **outside** the union, so every LogValue carries a string descriptor whether or not it is a string: `sizeof( LogValue )` is 40 on windows-x86_64, the same for an integer field as for a string one. That is the price of the string case, it is paid by every field, and it is why the event reserves its field array in one go rather than growing it per push.

## Members

### Logger

```text
MinLevel as LogLevel                  property, get and set
Name as ustring                       property, get and set; the component
Enabled( lv ) as boolean              one comparison, no lock

AddSink( s as Sink ptr )              the LOGGER DOES NOT OWN THE SINK
RemoveSink( s ) / ClearSinks( )
SinkCount( ) as int32

WithField( k, v as LogValue ) as Logger_    child, by value, deep copy
WithName( n ) as Logger_                    child with a component name

Log( lv ) as LogEvent                 and Trace/Debug/Info/Warn/Error/Fatal
Log( lv, m )                          and the same six taking a message
Emit( r as LogRecord )                a finished record, to the sinks
Flush( )                              reaches every attached sink
```

### LogEvent

Every one returns BYREF to the same event:

```text
AddText( k, v as ustring )    AddInt( k, v as int64 )
AddUInt( k, v as uint64 )     AddFloat( k, v as float64 )
AddBool( k, v as boolean )    AddPtr( k, v as any ptr )
AddTime( k, v as Instant )    AddSpan( k, v as TimeSpan )
AddValue( k, v as LogValue )  any tag, built by hand

AddError( v as FsError )      expands to error, error.code and error.os
Site( file, line, func )      the call site; the logging macros fill it in

Msg( m )                      sets the message and commits
Send( )                       commits
```

### TextRenderer

Four public fields; set them directly:

```text
stamp as TextStamp        TS_ISO_UTC (default), TS_ISO_LOCAL, TS_TIME_ONLY,
                          TS_MONO, TS_NONE
colour as boolean         FALSE; THE SINK sets this, see below
showsite as boolean       FALSE; appends "(file:line FUNC)"
levelwide as boolean      TRUE; pads the level to 5 for column alignment

Render( r, byref outbuf as ustring )    APPENDS, and does not clear
```

### ConsoleSink

```text
ConsoleSink( )                              stderr, own TextRenderer
ConsoleSink( target )                       CT_STDERR or CT_STDOUT
ConsoleSink( target, r as Renderer ptr )    your renderer, not owned

Write( r ) / Flush( ) / Close( )
DroppedCount( ) as uint64
Colour as boolean         property; overrides the auto-detection
IsConsole as boolean      property; FALSE when redirected
```

**Stderr by default.** Logs are diagnostics, not output: a program whose stdout is piped into another must not have its log lines land in the pipe.

## Child Loggers

```freebasic
dim as Logger db = lg.WithField( "component", LogValue( "db" ) )
db.Info( ).AddInt( "rows", 42 ).Msg( "query complete" )
' INFO   query complete  component=db rows=42
```

Returns a **new** Logger by value carrying the parent's level, sinks and inherited fields plus the new one. The parent is untouched and the child does not alias it.

**Inherited fields come first**, call-site fields last, so "most specific last" is available to any renderer that wants last-wins. A duplicate key is kept, not merged -- hiding one would hide the parent/child collision that produced it.

**A child is a snapshot.** Raising the parent's MinLevel afterwards does not raise the child's, and a sink added to the parent later does not reach the child. That is the right default for what WithField is for: a subsystem that captures its logger once at startup.

Ambient per-thread context -- Serilog's LogContext, Logback's MDC, Python's contextvars -- is not provided, and not merely unimplemented. It needs user-reachable thread-local storage, and tiko has none: the runtime's thread-local slots are a closed set of seven runtime-owned keys.

## Sinks And Locking

```freebasic
type Sink extends object
    declare abstract sub Write( byref r as LogRecord )
    declare abstract sub Flush( )
    declare abstract sub Close( )
    declare abstract function DroppedCount( ) as uint64
    declare virtual destructor( )
end type
```

Write takes the **record**, not rendered text, so a sink picks its own renderer and AsyncSink can defer rendering to its worker thread. Close must be idempotent. DroppedCount never resets.

**One mutex per sink, held across the whole write.** Not per logger -- that would not protect a sink shared by a parent and its child -- and not global, which would make every log call in the process contend on one thing.

The rule this enforces: **a record renders and writes as one unit**, and no record ever appears inside another. Two threads writing to one file handle with PRINT # can interleave inside a line, and nothing reports it. That silent corruption is the single worst property of every hand-rolled logger, and it is why locking is built in rather than left to you.

**A sink must not log.** Nothing enforces it; a sink that logs to itself re-enters a held mutex.

**The logger does not own its sinks** -- AddSink stores a pointer. A sink must outlive every logger holding it, which is what makes copying a Logger cheap and obviously not a duplicated file handle. A module-level sink is the simplest way to say that.

AddSink, RemoveSink and ClearSinks are configuration-time operations and are not safe against concurrent logging. Locking the sink list would put an acquisition on every log call to protect against something that happens at startup.

## Encoding And Colour

Renderers produce ustring. **Sinks produce bytes, and own the encoding:**

| Destination | Encoding |
| --- | --- |
| Windows, console | wide text via WriteConsoleW, bypassing the console code page -- CP437 would otherwise mangle every non-ASCII character in a record |
| Windows, redirected | UTF-8 |
| POSIX | UTF-8 |

The renderer emits colour but **never decides whether to** -- it does not know where the bytes are going, and a file full of `ESC[32m` is the standard way this is got wrong. ConsoleSink decides, from three tests in this order:

1. `NO_COLOR` set to anything non-empty -- off (see no-color.org).
2. The destination is not a character device -- off (redirected).
3. Enabling VT processing failed -- off (old Windows).

Set the Colour property afterwards to override all three, for a CI system that wants colour in a captured stream.

Colour wraps **the level word only**, never the message or the fields, which may contain arbitrary text including escape sequences of their own.

## More Sinks And Renderers

### FileSink And Rotation

```freebasic
dim as FileSink app = FileSink( "logs/app.log" )
app.policy     = RP_SIZE          ' RP_NONE (default), RP_SIZE, RP_DAILY, RP_BOTH
app.maxbytes   = 10 * 1024 * 1024 ' default 10 MiB
app.maxbackups = 5                ' default 5; 0 keeps every backup
app.flushevery = TRUE             ' default TRUE
```

- The file is UTF-8 with no BOM, and is appended to -- never truncated.
- `app.log` is always the live file. Rotation renames it to `app.1.log` (shifting `app.1` to `app.2`, and so on) and deletes past `maxbackups`.
- Size rotation checks **before** each record, so a file may pass `maxbytes` by one record, and a record is never split. Daily rotation uses the record's local day; a clock stepped back does not rotate.
- **The directory must exist.** The sink never creates one; if it cannot open, every record is a counted drop and the error handler is told.
- A rotation that fails -- a backup held open elsewhere -- is counted in `RotateFailures( )`; the sink keeps writing to the live file and tries again after another `maxbytes` or day.
- Also: `Path`, `BackupPath( n )`, `IsOpen`, `Flush( )` (to the disk) and `Close( )`.

`FileSink( path, @renderer )` takes a renderer of your own, such as a JsonRenderer.

### AsyncSink

Wraps any other sink, so that logging never waits on the disk:

```freebasic
dim as AsyncSink queue = AsyncSink( @app )   ' a queue of 4096 records by default
queue.policy = OP_BLOCK                      ' the default
lg.AddSink( @queue )
' ...
queue.Close( )                               ' REQUIRED -- see below
```

The caller copies the record into a queue and returns; one worker thread writes records **in order**, keeping the timestamps taken on the calling thread. When the queue is full:

| Policy | What happens |
| --- | --- |
| `OP_BLOCK` (default) | the caller waits for room; nothing is lost |
| `OP_DROP_NEWEST` | the incoming record is dropped, counted and reported |
| `OP_DROP_OLDEST` | the oldest queued record is dropped, counted and reported |

**A clean shutdown loses nothing:** `Close( )` stops accepting, lets the worker drain the queue, then flushes and closes the inner sink. `Flush( )` drains without stopping. **An unclean exit loses what is queued** -- that is what asynchronous means; use a synchronous sink if you need the last line before a crash. `QueueDepth( )` shows the backlog.

### JsonRenderer

Writes one JSON object per line, for log tools to read:

```text
TextRenderer:  2026-10-03T14:02:11.482Z  WARN   db  login failed  user=quinn attempts=3
JsonRenderer:  {"time":"2026-10-03T14:02:11.4823311Z","level":"WARN","logger":"db","msg":"login failed","user":"quinn","attempts":3}
```

Its fields: `timekey`, `levelkey`, `namekey`, `msgkey`, `monokey` and `sitekey` rename the reserved keys; `levelnum` writes `30` instead of `"INFO"`; `showmono` and `showsite` add the monotonic reading and the call site. Control characters, `"`, `\` and U+2028/9 are escaped; an integer beyond ±2⁵³ is written as a string; NaN and ±Infinity are strings; a key used twice becomes `key#2`, and a field may never take a reserved key's name. Every line is valid JSON.

## The Default Logger And The Macros

One process-wide logger, for code that should not own one:

```freebasic
#import "std/logs"
using logs

dim as FileSink app = FileSink( "logs/app.log" )

LogInit( @app, LOG_DEBUG )              ' attach a sink, set the level
DefaultLogger( ).Info( "from anywhere" )

logs.LogInfo( "service starting" )
logs.LogEventWarn( AddText( "path", "data.csv" ).AddInt( "code", 2 ), "write failed" )

LogShutdown( )                          ' flush and close every sink -- call it last
```

- std/logs is a module, compiled once, so `DefaultLogger( )` exists **once per program** however many files import it.
- Before `LogInit` it has no sinks: a library that logs early is silent.
- The **`FB_LOG`** environment variable (`debug`, `WRN`, `40`, ...) overrides the level `LogInit` is given; an unreadable value is ignored.
- `LogShutdown` is not automatic. With an AsyncSink it is what keeps the last records.

The macros `logs.LogTrace` ... `logs.LogFatal( m )` and `logs.LogEventTrace` ... `logs.LogEventFatal( fields, m )` log to the default logger and record **where they are written** -- file, line and procedure -- which `showsite` prints. They are exported macros, so they are written qualified.

**Below `LOG_MIN_LEVEL` a macro expands to nothing**, its arguments included -- which is how a trace call costs nothing at all in a release build. Set it in your project's tiko.toml under `[defines]`: a module never sees its importer's `-d` options. A level that is compiled in but switched off at run time still evaluates its message argument.

## When Logging Fails

No function that emits a record returns a Result, and none can raise. This **deliberately breaks** the convention the rest of the standard library follows: std/fs returns `Result( of T, FsError )` from everything fallible, and is right to. The caller of a log function has nothing useful to do with a failure -- the most common context for a log call is already inside an error path -- and a Result that every call site ignores is worse than no Result, because it looks checked.

Silent failure was rejected outright, though: a log file that has been dead since Tuesday and says nothing about it is the worst failure mode this module could have. Mainstream logging libraries reached the same answer, and several grew a second, out-of-band channel to report that the first one broke -- Serilog's SelfLog, Logback's StatusManager, spdlog's err_handler. This module's version:

- every sink counts what it could not write in **`DroppedCount( )`**, which never resets;
- **`SetLogErrorHandler( @MyHandler )`** installs one process-wide handler, a `LogErrorHandler`: `sub( byref sinkname as ustring, byref reason as ustring, byval oscode as long )`. It is called outside the sink's lock, so it may log; at most once a second per sink, with the number of reports held back; and anything it leaves in ERR is undone;
- the default, `LogDefaultErrorHandler`, prints one line to stderr;
- `SetLogErrorHandler( 0 )` silences reporting, and the counters still count.

## Member Names

Every field method is named `Add` plus the kind of value it adds -- AddText, AddInt, AddUInt, AddFloat, AddBool, AddPtr, AddTime, AddSpan, AddValue, AddError -- so a call reads as a sentence and no name looks like a built-in:

```freebasic
lg.Warn( ).AddText( "user", u ).AddInt( "attempts", n ).Msg( "login failed" )
```

The kind stays in the name on purpose: AddInt and AddFloat decide whether the JSON renderer writes `3` or `3.0`, so that choice is visible at the call site rather than left to overload resolution.

The logger's own level methods keep their plain names -- `lg.Error( "boom" )`, `lg.Log( lv )` -- because being an intrinsic is not enough to block a member name; only a keyword or a statement is. WithField is the one exception for that reason: WITH is a statement, so a member called `With` is refused (TKO0600).

One more, for anyone deriving from these types: `type Logger as Logger_` makes Logger an incomplete type inside the module, so a member returning a logger by value is declared `as Logger_`. Callers write `dim as Logger`.

## Writing Your Own Sink

The interface is public, and this is the whole of the sink a Windows GUI program wants -- there is no console for ConsoleSink to write to:

```freebasic
#import "std/logs"
#include once "windows.bi"

type DebugSink extends logs.Sink
    declare sub Write( byref r as logs.LogRecord ) override
    declare sub Flush( ) override
    declare sub Close( ) override
    declare function DroppedCount( ) as uint64 override
    private:
    m_lock as any ptr
    m_rend as logs.TextRenderer
end type

sub DebugSink.Write( byref r as logs.LogRecord )
    dim as ustring buf
    mutexlock( this.m_lock )
    this.m_rend.Render( r, buf )
    OutputDebugStringW( buf )        ' ustring is UTF-16 on Windows
    mutexunlock( this.m_lock )
end sub

sub DebugSink.Flush( ) : end sub
sub DebugSink.Close( ) : end sub
function DebugSink.DroppedCount( ) as uint64 : return 0 : end function
```

`Write` must not fail and must not log, and it takes its own lock for the whole write when more than one thread can reach it.

std/logs declares none of the handful of Win32 functions it needs itself: it resolves them at run time with DYLIBLOAD / DYLIBSYMBOL. Declaring GetStdHandle at module level would clash with windows.bi in every program that includes it -- and most programs that want a logger are Win32 programs.

## Tests

logging/logrecord.bas and logger_sinks.bas -- 23 tests, 155 assertions, one block per numbered rule of the design they cover, named after that rule so a failure names what it broke.

logrecord.bas pins the value layer: all nine constructors round-tripping both tag and value (a constructor that sets the right tag and loses the value would pass any test that only read the text), `sizeof( LogValue ) = 40`, the tag numbers themselves -- so that inserting a tag in the middle fails here rather than silently changing what an old record means -- the level spacing, parsing that leaves its out-parameter alone on failure, and the three non-finite doubles built at run time so the compiler cannot fold them away.

logger_sinks.bas pins four guarantees -- a filtered event builds no record; two sinks receive the same record, and removing one leaves the other alone; the text output is byte-exact with colour on and off; and four threads to one sink give an exact line count with no line torn -- plus what only commits, the parent/child field order and snapshot semantics, and field quoting.

See also: [Date and Time](Category-Date-and-Time-Chrono) (Instant, TimeSpan, WallClock, Stopwatch), [Filesystem](Category-Filesystem), [Result](Category-Result) (the convention this module breaks), [Goroutines and Channels](Category-Goroutines-and-Channels).

## API reference

One page per entry, 32 in all:

|   |   |   |   |   |
|---|---|---|---|---|
| [AddSink](Modern-Log-AddSink) | [LevelFromName](Modern-Log-LevelFromName) | [LogEvent.DroppedCount](Modern-Log-LogEvent-DroppedCount) | [LogEvent.AddSpan](Modern-Log-LogEvent-AddSpan) | [SinkCount](Modern-Log-SinkCount) |
| [ClearSinks](Modern-Log-ClearSinks) | [LevelName](Modern-Log-LevelName) | [LogEvent.AddError](Modern-Log-LogEvent-AddError) | [LogEvent.AddText](Modern-Log-LogEvent-AddText) | [Trace](Modern-Log-Trace) |
| [Debug](Modern-Log-Debug) | [LevelNameShort](Modern-Log-LevelNameShort) | [LogEvent.Flush](Modern-Log-LogEvent-Flush) | [LogEvent.AddTime](Modern-Log-LogEvent-AddTime) | [Warn](Modern-Log-Warn) |
| [Emit](Modern-Log-Emit) | [LevelToSyslog](Modern-Log-LevelToSyslog) | [LogEvent.AddInt](Modern-Log-LogEvent-AddInt) | [LogEvent.AddUInt](Modern-Log-LogEvent-AddUInt) | [WithField](Modern-Log-WithField) |
| [Enabled](Modern-Log-Enabled) | [Log](Modern-Log-Log) | [LogEvent.Msg](Modern-Log-LogEvent-Msg) | [LogEvent.AddValue](Modern-Log-LogEvent-AddValue) | [WithName](Modern-Log-WithName) |
| [Error](Modern-Log-Error) | [LogEvent.AddBool](Modern-Log-LogEvent-AddBool) | [LogEvent.AddPtr](Modern-Log-LogEvent-AddPtr) | [LogEvent.Write](Modern-Log-LogEvent-Write) |  |
| [Fatal](Modern-Log-Fatal) | [LogEvent.Close](Modern-Log-LogEvent-Close) | [LogEvent.Render](Modern-Log-LogEvent-Render) | [MinLevel](Modern-Log-MinLevel) |  |
| [Flush](Modern-Log-Flush) | [LogEvent.ConsoleSink](Modern-Log-LogEvent-ConsoleSink) | [LogEvent.Send](Modern-Log-LogEvent-Send) | [Name](Modern-Log-Name) |  |
| [Info](Modern-Log-Info) | [LogEvent.AddFloat](Modern-Log-LogEvent-AddFloat) | [LogEvent.Site](Modern-Log-LogEvent-Site) | [RemoveSink](Modern-Log-RemoveSink) |  |

---



---

[Home](Home) · [Keyword Index](Keyword-Index)
