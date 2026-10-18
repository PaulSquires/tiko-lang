# Logging

A log is three kinds of object. A **`Logger`** is what the program calls. A
**sink** is where records go: `ConsoleSink` to the terminal, `FileSink` to a
file, and a logger may have several. A **renderer** turns a record into text:
`TextRenderer` for people, `JsonRenderer` for programs.

```tiko
{{#include ../../examples/libraries/logging.tiko}}
```

**Output**

```text
{{#include ../../examples/libraries/logging.out}}
```

`lg.AddSink( @con )` connects a sink. The logger keeps a pointer and does not
own the sink, so the sink must live at least as long as the logger.

**Levels**, from least to most severe: `LOG_TRACE`, `LOG_DEBUG`, `LOG_INFO`,
`LOG_WARN`, `LOG_ERROR` and `LOG_FATAL`, numbered 10 to 60. `MinLevel` discards
everything below it, and a discarded record is never built. `LOG_FATAL` is
only a severity: it does not end the program.

**Fields.** `lg.Info( "text" )` logs a line. `lg.Warn( )` with no message
starts a record instead; `AddText`, `AddInt`, `AddFloat`, `AddBool` and the
other field methods add a name and a typed value, and `Msg( "text" )` finishes
the record and sends it. A record that is never finished is never sent.

**Child loggers.** `WithField( name, value )` returns a new logger that adds
that field to every record it writes, with the parent's level and sinks, so a
whole layer of a program can be marked at once.

`LevelName` and `LevelFromName` convert between levels and text.
`LevelFromName` returns `false` and leaves its result alone for a name that is
not a level, so a typo in a setting does not switch logging off.

### Activities

1. Raise `MinLevel` to `LOG_WARN` and predict which lines remain.
2. Make a second child logger with `"component"` set to `"http"` and log a
   request through it.
