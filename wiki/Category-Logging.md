[Home](Home) › [All Categories](Categories) › **Logging**

# Logging

```freebasic
#import "std/logs"
using logs

dim shared as ConsoleSink con
dim shared as Logger lg

lg.MinLevel = LOG_DEBUG
lg.AddSink( @con )

lg.Info( "server started" )

lg.Warn( ).Str( "user", u ).Int_( "attempts", n ).Msg( "login failed" )
' 2026-08-12T23:06:34.361Z  WARN   login failed  user=quinn attempts=3
```

Without this module, a program that logs grows a WriteLog( ) that opens a file, appends a line and closes it: no level, no timestamp, no structure, no rotation, and no lock. This module replaces that. It ships ALONGSIDE PRINT, PRINT #, OPEN and ERR and changes none of them.

LIBRARY ONLY. Every line is tiko -- no compiler change, and unlike std/fs, not one line of C in the runtime.

## What You Get

```freebasic
A LEVEL on every record, and one comparison to filter it out.
A TIMESTAMP taken for you: UTC, RFC-3339, sub-second -- plus a monotonic
  reading, so records still order correctly when the wall clock jumps.
TYPED FIELDS. 'attempts' stays a number all the way to the sink, so the
  JSON renderer (phase 2) can emit 3 rather than "3".
A PLUGGABLE SINK, so a library can log without knowing the destination.
THREAD-SAFE WRITES. One mutex per sink, held across the whole write.
CHILD LOGGERS carrying inherited fields.
A CALL THAT CANNOT FAIL. No Result, no raise, ever.
```

And one thing you do not get, which is the reason to read the next section: a format string. Fields arrive through a CHAINED BUILDER.

## The Call Site

Two forms. Use the first unless you have something to capture.

```freebasic
lg.Info( "server started" )                       ' one line, no fields

lg.Warn( ).Str( "user", u ) _                     ' the builder
          .Int_( "attempts", n ) _
          .Msg( "login failed" )
```

Each field method returns BYREF to the same event; .Msg( ) is the only method that commits. .Send( ) commits with the message already set or empty.

THE EVENT LIVES ON THE CALLER'S STACK. lg.Info( ) returns a LogEvent by value and the chain runs on that temporary, which is what makes this thread-safe with no thread-local storage -- and tiko has none user code can reach.

AN EVENT THAT IS NEVER COMMITTED EMITS NOTHING. The destructor does not auto-send. A forgotten .Msg( ) is a missing line, which you notice; the alternative is a line you never asked for, which you do not.

A DISABLED LEVEL BUILDS NOTHING. Not "builds it and throws it away" -- the field methods return immediately, no LogField is constructed and no array grows. Asserted, not asserted-by-eye: the test counts value constructions, not output.

What it does NOT avoid is EVALUATING THE ARGUMENTS.

```freebasic
lg.Trace( ).Str( "dump", ExpensiveDump( ) ).Msg( "state" )
```

ExpensiveDump( ) runs whether trace is on or not. That is irreducible at run time in a language with no lazy arguments, and it is what the phase-5 macro layer exists to delete.

## Levels

```freebasic
LOG_TRACE = 10    LOG_DEBUG = 20    LOG_INFO  = 30
LOG_WARN  = 40    LOG_ERROR = 50    LOG_FATAL = 60    LOG_OFF = 1000
```

SPACED BY TEN so you can define your own level between two of these and have every comparison, filter and renderer keep working. Only Go's log/slog gets this right among the mainstream designs.

LOG_FATAL DOES NOT TERMINATE ANYTHING. It is a severity. spdlog and logrus do terminate, so someone will expect it; a library that calls END on behalf of its host is not a library. Write the two statements.

```freebasic
LevelName( lv ) as ustring              "WARN"; an unnamed level gives "40"
LevelNameShort( lv ) as ustring         "WRN"
LevelFromName( s, byref out ) as boolean  "warn" / "WRN" / "40", any case
LevelToSyslog( lv ) as int32            RFC 5424 severity
```

LevelFromName leaves the out-parameter ALONE when it fails -- a typo in an environment variable must not silently turn logging off.

## Fields AND Values

A field is a name and a LogValue: a tag plus a union, nine tags, closed.

```freebasic
LK_NULL  LK_BOOL  LK_INT  LK_UINT  LK_DBL
LK_STR   LK_PTR   LK_INSTANT  LK_TIMESPAN
```

The set is CLOSED so a renderer can SELECT CASE over it with no 'case else' meaning "I do not know what this is". Adding a tenth is a change to every renderer in the same commit.

The obvious layout does not compile:

```freebasic
union
    s as ustring        ' error 161: Var-len strings cannot be part of
end union               '            UNION's or nested TYPE's
```

so the ustring sits OUTSIDE the union and EVERY LogValue carries a string descriptor whether or not it is a string. sizeof( LogValue ) = 40 on win64, the same for an integer field as for a string one. That is the price of the string case, it is paid by every field, and it is why the event reserves its field array in one go rather than growing it per push.

## Members

Logger:

```freebasic
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

LogEvent -- every one returns BYREF to the same event:

```freebasic
Str( k, v as ustring )        Int_( k, v as int64 )
UInt( k, v as uint64 )      Dbl( k, v as float64 )
Bool( k, v as boolean )       Ptr_( k, v as any ptr )
Time( k, v as Instant )       Span( k, v as TimeSpan )
Val( k, v as LogValue )       any tag, built by hand

Err( v as FsError )           expands to error, error.code and error.os
Site( file, line, func )      what the phase-5 macros will fill in

Msg( m )                      sets the message and commits
Send( )                       commits
```

TextRenderer -- four public fields, set them directly:

```freebasic
stamp as TextStamp        TS_ISO_UTC (default), TS_ISO_LOCAL, TS_TIME_ONLY,
                          TS_MONO, TS_NONE
colour as boolean         FALSE; THE SINK sets this, see below
showsite as boolean       FALSE; appends "(file:line FUNC)"
levelwide as boolean      TRUE; pads the level to 5 for column alignment

Render( r, byref outbuf as ustring )    APPENDS, and does not clear
```

ConsoleSink:

```freebasic
ConsoleSink( )                              stderr, own TextRenderer
ConsoleSink( target )                       CT_STDERR or CT_STDOUT
ConsoleSink( target, r as Renderer ptr )    your renderer, not owned

Write( r ) / Flush( ) / Close( )
DroppedCount( ) as uint64
Colour as boolean         property; overrides the auto-detection
IsConsole as boolean      property; FALSE when redirected
```

STDERR BY DEFAULT. Logs are diagnostics, not output: a program whose stdout is piped into another must not have its log lines land in the pipe.

## Child Loggers

```freebasic
dim as Logger db = lg.WithField( "component", LogValue( "db" ) )
db.Info( ).Int_( "rows", 42 ).Msg( "query complete" )
' INFO   query complete  component=db rows=42
```

Returns a NEW Logger by value carrying the parent's level, sinks and inherited fields plus the new one. The parent is untouched and the child does not alias it.

INHERITED FIELDS COME FIRST, call-site fields last, so "most specific last" is available to any renderer that wants last-wins. A duplicate key is KEPT, not merged -- hiding one would hide the parent/child collision that produced it.

A CHILD IS A SNAPSHOT. Raising the parent's MinLevel afterwards does not raise the child's, and a sink added to the parent later does not reach the child. That is the right default for what WithField is for: a subsystem that captures its logger once at startup.

Ambient per-thread context -- Serilog's LogContext, Logback's MDC, Python's contextvars -- is NOT provided and is not merely unimplemented. It needs user-reachable thread-local storage, and tiko has none: fb_thread.h serves a CLOSED enum of seven runtime-owned keys.

## Sinks AND Locking

```freebasic
type Sink extends object
    declare abstract sub Write( byref r as LogRecord )
    declare abstract sub Flush( )
    declare abstract sub Close( )
    declare abstract function DroppedCount( ) as uint64
    declare virtual destructor( )
end type
```

Write takes the RECORD, not rendered text, so a sink picks its own renderer and the phase-6 AsyncSink can defer rendering to its worker thread. Close must be IDEMPOTENT. DroppedCount never resets.

ONE MUTEX PER SINK, HELD ACROSS THE WHOLE WRITE. Not per-logger -- that would not protect a sink shared by a parent and its child -- and not global, which would make every log call in the process contend on one thing.

The rule this enforces: A RECORD RENDERS AND WRITES AS ONE UNIT, and no record ever appears inside another. PRINT # gives no such guarantee -- two threads on one file handle interleave INSIDE a line, and nothing reports it. That silent corruption is the single worst property of every hand-rolled logger, and it is why locking is a phase-1 item rather than a refinement.

A SINK MUST NOT LOG. Nothing enforces it; a sink that logs to itself re-enters a held mutex.

THE LOGGER DOES NOT OWN ITS SINKS -- AddSink stores a pointer. A sink must outlive every logger holding it, which is what makes copying a Logger cheap and obviously not a duplicated file handle. A module-level 'dim shared' sink is the simplest way to say that.

AddSink, RemoveSink and ClearSinks are CONFIGURATION-TIME operations and are not safe against concurrent logging. Locking the sink list would put an acquisition on every log call to protect against something that happens at startup.

## Encoding AND Colour

Renderers produce ustring. SINKS PRODUCE BYTES, and own the encoding:

```freebasic
Windows, console          wide text via WriteConsoleW, bypassing the console
                          code page -- CP437 would otherwise mangle every
                          non-ASCII character in a record
Windows, redirected       UTF-8
POSIX                     UTF-8
```

The renderer emits colour but NEVER DECIDES WHETHER TO -- it does not know where the bytes are going, and a file full of ESC\[32m is the standard way this is got wrong. ConsoleSink decides, from three tests in this order:

```freebasic
1. NO_COLOR set to anything non-empty        -> off  (no-color.org)
2. the destination is not a character device -> off  (redirected)
3. enabling VT processing failed             -> off  (old Windows)
```

Set the Colour property afterwards to override all three, for a CI system that wants colour into a captured stream.

Colour wraps THE LEVEL WORD ONLY, never the message or the fields, which may contain arbitrary text including escape sequences of their own.

## What Cannot Fail

No function that emits a record returns a Result, and none can raise.

This DELIBERATELY BREAKS the convention the rest of this library follows. std/fs returns Result( of T, FsError ) from everything fallible and is right to. The caller of a log function has nothing useful to do with a failure -- the most common context for a log call is already inside an error path -- and a Result that every call site ignores is worse than no Result, because it looks checked.

Every mainstream logging library guarantees the same thing, and three of them grew a SECOND, out-of-band channel to report that the first one broke: Serilog's SelfLog, Logback's StatusManager, spdlog's err_handler. DroppedCount is this module's version; the OnLogError handler that goes with it is phase 4.

Silent failure was rejected outright. A log file that has been dead since Tuesday and says nothing about it is the worst failure mode this module could have.

## The Three Renamed Members

Three, and all three are the language rather than taste. Each was MEASURED as a member of a UDT inside a namespace, which is the context that decides it:

```freebasic
Int_        INT is a keyword                    error 4
Ptr_        PTR is a keyword                    error 4
WithField   WITH is a statement, so 'With' is   error 4
```

And these are FINE, which is not obvious, since several of them are intrinsics:

```freebasic
Str    Val    Error    Time    Log    Bool    Dbl    Span    Msg    Send
```

So it is lg.Error( "boom" ), not lg.Error\_( ), and .Val( k, v ) for a LogValue built by hand. Being an intrinsic function is not enough to block a member name; being a KEYWORD or a STATEMENT is.

Note that Str SHADOWS the intrinsic STR( ) inside its own type's member bodies -- error 58 if you call STR( ) there. That is why LogValueToText is a free function and not a member.

One more, for anyone deriving from these types: 'type Logger as Logger\_' makes Logger an INCOMPLETE type inside the module, so a member returning a logger by value is declared 'as Logger\_'. Callers write 'dim as Logger'.

## NOT In This Phase

Phase 1 ships the record, the logger, the builder, TextRenderer and ConsoleSink. Still to come, in order:

```freebasic
2   JsonRenderer -- one JSON object per line, with the eleven rules
3   FileSink, size and daily rotation
4   OnLogError, and the process-wide default logger logs.DefaultLogger( )
5   logs.LogInfo( m ) and friends -- __FILE__/__LINE__/__FUNCTION__ and
    compile-time elision below LOG_MIN_LEVEL
6   AsyncSink over tasks.Channel, with an explicit overflow policy
```

THE PROCESS-WIDE DEFAULT LOGGER IS logs.DefaultLogger( ). std/logs is a module, compiled once, so its 'dim shared' default logger exists ONCE PER PROGRAM however many files import it. logs.LogInit( @sink, level ) gives it a sink, logs.LogShutdown( ) flushes and closes it, and logs.LogInfo( m ) and the other five level macros write to it. LOG_MIN_LEVEL, which compiles calls below a level away, goes in a tiko.toml's [defines]: a module never sees its importer's -d.

DECLINED, not deferred: OS-native sinks (OutputDebugString, Windows Event Log, syslog), printf-style format strings, sampling and rate limiting, file-based configuration, and a logger hierarchy resolved by dotted name.

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

Note that std/logs declares none of the handful of Win32 functions it needs: it resolves them at run time with DYLIBLOAD / DYLIBSYMBOL. Declaring GetStdHandle globally would make any program that includes windows.bi fail with error 4 -- and most programs that want a logger are Win32 programs.

## Measured AND NOT Measured

Asserted: a filtered call performs no sink write AND no value construction; four threads x 10,000 records through one sink produce an exact line count with no line containing a fragment of another; the text output is byte-exact with colour forced both ways.

NOT measured: throughput. There is no benchmark, so "a lock per sink is cheap enough" is an argument, not a number.

NOT observed: ConsoleSink's own serialisation. The thread test drives a capture sink built on the identical mutex-around-render-and-emit pattern; seeing the shipped sink's writes would need a child process with redirected stderr.

NOT exercised by any test: the Windows CONSOLE path. Under the harness stderr is redirected, so every run took the not-a-tty branch -- WriteConsoleW, the VT-mode enable and the wide encoding have been run by hand only.

## Tests

logging/logrecord.bas and logger_sinks.bas -- 23 tests, 155 assertions, one block per numbered rule of the design it covers, named after that rule so a failure names what it broke.

logrecord.bas pins the value layer: all nine constructors round-tripping both TAG and VALUE (a constructor that sets the right tag and loses the value would pass any test that only read the text), sizeof( LogValue ) = 40, the tag numbers themselves so that inserting a tag in the middle fails here rather than silently changing what an old record means, the level spacing, parsing that leaves its out-parameter alone on failure, and the three non-finite doubles built at run time so the compiler cannot fold them away.

logger_sinks.bas pins the four phase-1 gates, plus what only commits, the parent/child field order and snapshot semantics, and field quoting.

See also: [Date and Time](Category-Date-and-Time-Chrono) (Instant, TimeSpan, WallClock, Stopwatch), [Filesystem](Category-Filesystem), [Result](Category-Result) (the convention this module breaks), [Goroutines and Channels](Category-Goroutines-and-Channels) (tasks.Channel).

## API reference

One page per entry, 32 in all:

[AddSink](Modern-Log-AddSink) · [ClearSinks](Modern-Log-ClearSinks) · [Debug](Modern-Log-Debug) · [Emit](Modern-Log-Emit) · [Enabled](Modern-Log-Enabled) · [Error](Modern-Log-Error) · [Fatal](Modern-Log-Fatal) · [Flush](Modern-Log-Flush) · [Info](Modern-Log-Info) · [LevelFromName](Modern-Log-LevelFromName) · [LevelName](Modern-Log-LevelName) · [LevelNameShort](Modern-Log-LevelNameShort) · [LevelToSyslog](Modern-Log-LevelToSyslog) · [Log](Modern-Log-Log) · [LogEvent.Bool](Modern-Log-LogEvent-Bool) · [LogEvent.Close](Modern-Log-LogEvent-Close) · [LogEvent.ConsoleSink](Modern-Log-LogEvent-ConsoleSink) · [LogEvent.Dbl](Modern-Log-LogEvent-Dbl) · [LogEvent.DroppedCount](Modern-Log-LogEvent-DroppedCount) · [LogEvent.Err](Modern-Log-LogEvent-Err) · [LogEvent.Flush](Modern-Log-LogEvent-Flush) · [LogEvent.Int_](Modern-Log-LogEvent-Int) · [LogEvent.Msg](Modern-Log-LogEvent-Msg) · [LogEvent.Ptr_](Modern-Log-LogEvent-Ptr) · [LogEvent.Render](Modern-Log-LogEvent-Render) · [LogEvent.Send](Modern-Log-LogEvent-Send) · [LogEvent.Site](Modern-Log-LogEvent-Site) · [LogEvent.Span](Modern-Log-LogEvent-Span) · [LogEvent.Str](Modern-Log-LogEvent-Str) · [LogEvent.Time](Modern-Log-LogEvent-Time) · [LogEvent.UInt](Modern-Log-LogEvent-UInt) · [LogEvent.Val](Modern-Log-LogEvent-Val) · [LogEvent.Write](Modern-Log-LogEvent-Write) · [MinLevel](Modern-Log-MinLevel) · [Name](Modern-Log-Name) · [RemoveSink](Modern-Log-RemoveSink) · [SinkCount](Modern-Log-SinkCount) · [Trace](Modern-Log-Trace) · [Warn](Modern-Log-Warn) · [WithField](Modern-Log-WithField) · [WithName](Modern-Log-WithName)

---



---

[Home](Home) · [Keyword Index](Keyword-Index)
