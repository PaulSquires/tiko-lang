# The default logger

Passing a logger to every procedure that might log is tedious. `std/logs`
holds one **default logger** for the whole program, and a set of macros that
write to it from anywhere.

```tiko
{{#include ../../examples/libraries/macros.tiko}}
```

**Output**

```text
{{#include ../../examples/libraries/macros.out}}
```

| Macro | Writes |
|---|---|
| `logs.LogTrace( m )` ... `logs.LogFatal( m )` | a message at that level |
| `logs.LogEventInfo( fields, m )` and its siblings | a message with fields |

The `fields` argument of a `LogEvent` macro is a chain of field calls with no
object in front, `AddText( "path", path ).AddInt( "bytes", bytes )`, which the
macro attaches to the record it starts. `logs.DefaultLogger( )` is the logger
itself, for anything the macros do not cover.

Because they are macros, they capture the file, line and procedure they were
written in, which a renderer prints when its `showsite` is set. They are also
removed from the program entirely below the `LOG_MIN_LEVEL` setting, which a
project sets in the `[defines]` of its `tiko.toml`.

`LogInit( @sink, level )` attaches the sink and sets the level.
**`LogShutdown( )` is not called for you** when the program ends: call it last,
or the final lines may be lost.

### Activities

1. Call `logs.LogEventWarn` from inside `SaveSettings` when `bytes` is zero.
2. Set `tr.showsite = true` and look at what each line gains.
