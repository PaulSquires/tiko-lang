[Home](Home) › [Function Finder](Function-Finder) › **Logging**

# Logging

The functions to write log messages to the console, files or your own sinks, grouped by what you want to do. The **From** column says what a program needs before it can call one:

- `std/logs`: `#import "std/logs"`, then `using logs` to call it by its bare name.

Jump to: [Log a message](#log-a-message) · [Send logs to the console or a file](#send-logs-to-the-console-or-a-file) · [Add fields to a record](#add-fields-to-a-record) · [Finish and send a record](#finish-and-send-a-record) · [Choose which levels are logged](#choose-which-levels-are-logged) · [Turn levels into names and back](#turn-levels-into-names-and-back) · [Give part of a program its own logger](#give-part-of-a-program-its-own-logger) · [Log from anywhere in the program](#log-from-anywhere-in-the-program) · [Flush and close sinks](#flush-and-close-sinks) · [Format records or write your own sink](#format-records-or-write-your-own-sink) · [Find out when logging fails](#find-out-when-logging-fails)

## Log a message

| Function | What it does | From |
|---|---|---|
| [Logger.Info](Modern-Log-Info) | Logs a message at the info level, or returns a record to add fields to. | `std/logs` |
| [Logger.Warn](Modern-Log-Warn) | Logs a message at the warn level, or returns a record to add fields to. | `std/logs` |
| [Logger.Error](Modern-Log-Error) | Logs a message at the error level, or returns a record to add fields to. | `std/logs` |
| [Logger.Debug](Modern-Log-Debug) | Logs a message at the debug level, or returns a record to add fields to. | `std/logs` |
| [Logger.Trace](Modern-Log-Trace) | Logs a message at trace, the finest level, or returns a record to add fields to. | `std/logs` |
| [Logger.Fatal](Modern-Log-Fatal) | Logs a message at the most severe level, or returns a record; it does not end the program. | `std/logs` |
| [Logger.Log](Modern-Log-Log) | Logs a message at a level you pass, or returns a record to add fields to. | `std/logs` |

## Send logs to the console or a file

| Function | What it does | From |
|---|---|---|
| [ConsoleSink](Modern-Log-LogEvent-ConsoleSink) | Holds a sink that writes to stderr or stdout, in colour only on a terminal. | `std/logs` |
| [FileSink](Category-Logging#filesink-and-rotation) | Holds a sink that appends records to a UTF-8 file, rotating it by size or by day. | `std/logs` |
| [AsyncSink](Category-Logging#asyncsink) | Holds a sink that queues records for a worker thread to write to another sink. | `std/logs` |
| [Logger.AddSink](Modern-Log-AddSink) | Attaches a sink to the logger, which keeps a pointer to it and does not own it. | `std/logs` |
| [Logger.RemoveSink](Modern-Log-RemoveSink) | Detaches one sink; removing one that was never added does nothing. | `std/logs` |
| [Logger.ClearSinks](Modern-Log-ClearSinks) | Detaches every sink, without destroying any of them. | `std/logs` |
| [Logger.SinkCount](Modern-Log-SinkCount) | Returns how many sinks are attached to the logger. | `std/logs` |

## Add fields to a record

| Function | What it does | From |
|---|---|---|
| [LogEvent.AddText](Modern-Log-LogEvent-AddText) | Adds a named text field to the record and returns the record for the next call. | `std/logs` |
| [LogEvent.AddInt](Modern-Log-LogEvent-AddInt) | Adds a named integer field, which stays a number in JSON output. | `std/logs` |
| [LogEvent.AddUInt](Modern-Log-LogEvent-AddUInt) | Adds a named unsigned 64-bit integer field. | `std/logs` |
| [LogEvent.AddFloat](Modern-Log-LogEvent-AddFloat) | Adds a named floating-point field. | `std/logs` |
| [LogEvent.AddBool](Modern-Log-LogEvent-AddBool) | Adds a named true or false field. | `std/logs` |
| [LogEvent.AddPtr](Modern-Log-LogEvent-AddPtr) | Adds a named pointer field, such as the address of an object. | `std/logs` |
| [LogEvent.AddTime](Modern-Log-LogEvent-AddTime) | Adds a named field holding a point in time. | `std/logs` |
| [LogEvent.AddSpan](Modern-Log-LogEvent-AddSpan) | Adds a named field holding a length of time, such as how long a step took. | `std/logs` |
| [LogEvent.AddError](Modern-Log-LogEvent-AddError) | Adds a filesystem error as fields: its message, its code and any system error code. | `std/logs` |
| [LogEvent.AddValue](Modern-Log-LogEvent-AddValue) | Adds a named field from a value you built yourself, of any supported kind. | `std/logs` |
| [LogValue](Category-Logging#fields-and-values) | Holds one field value: null, boolean, number, text, pointer, time or time span. | `std/logs` |

## Finish and send a record

| Function | What it does | From |
|---|---|---|
| [LogEvent.Msg](Modern-Log-LogEvent-Msg) | Sets the message and sends the record; a record that is never sent logs nothing. | `std/logs` |
| [LogEvent.Send](Modern-Log-LogEvent-Send) | Sends the record without a message, for a record that is only fields. | `std/logs` |
| [LogEvent.Site](Modern-Log-LogEvent-Site) | Records the file, line and procedure the record came from. | `std/logs` |
| [Logger.Emit](Modern-Log-Emit) | Sends a finished record straight to every attached sink. | `std/logs` |

## Choose which levels are logged

| Function | What it does | From |
|---|---|---|
| [Logger.MinLevel](Modern-Log-MinLevel) | Sets or returns the lowest level the logger emits; LOG_OFF silences it. | `std/logs` |
| [Logger.Enabled](Modern-Log-Enabled) | Returns true if a record at a level would be emitted, to skip building costly messages. | `std/logs` |

## Turn levels into names and back

| Function | What it does | From |
|---|---|---|
| [LevelName](Modern-Log-LevelName) | Returns a level's name, such as "WARN", or its number if it has no name. | `std/logs` |
| [LevelNameShort](Modern-Log-LevelNameShort) | Returns a level's three-letter name, such as "WRN". | `std/logs` |
| [LevelFromName](Modern-Log-LevelFromName) | Reads a level from a name or number in any case; returns false if it is unknown. | `std/logs` |
| [LevelToSyslog](Modern-Log-LevelToSyslog) | Returns the syslog severity number for a level. | `std/logs` |

## Give part of a program its own logger

| Function | What it does | From |
|---|---|---|
| [Logger.WithField](Modern-Log-WithField) | Returns a child logger that adds one field to every record it makes. | `std/logs` |
| [Logger.WithName](Modern-Log-WithName) | Returns a child logger with its own component name and the parent's sinks. | `std/logs` |
| [Logger.Name](Modern-Log-Name) | Sets or returns the logger's component name, attached to every record it makes. | `std/logs` |

## Log from anywhere in the program

| Function | What it does | From |
|---|---|---|
| [DefaultLogger](Category-Logging#the-default-logger-and-the-macros) | Returns the one process-wide logger; LogInit gives it a sink and LogShutdown closes it. | `std/logs` |

## Flush and close sinks

| Function | What it does | From |
|---|---|---|
| [Logger.Flush](Modern-Log-Flush) | Flushes every sink attached to the logger. | `std/logs` |
| [Sink.Flush](Modern-Log-LogEvent-Flush) | Flushes one sink on its own. | `std/logs` |
| [Sink.Close](Modern-Log-LogEvent-Close) | Closes a sink and releases what it holds; every kind of sink closes the same way. | `std/logs` |

## Format records or write your own sink

| Function | What it does | From |
|---|---|---|
| [TextRenderer](Category-Logging#textrenderer) | Holds the plain-text formatter; its fields set the timestamp, colour and call site. | `std/logs` |
| [TextRenderer.Render](Modern-Log-LogEvent-Render) | Appends a record as one line of text to a buffer, without clearing it first. | `std/logs` |
| [JsonRenderer](Category-Logging#jsonrenderer) | Holds a formatter that writes each record as one line of JSON. | `std/logs` |
| [Sink](Category-Logging#writing-your-own-sink) | Holds the interface every sink implements: Write, Flush, Close and DroppedCount. | `std/logs` |
| [Sink.Write](Modern-Log-LogEvent-Write) | Writes one record to a sink; the method a sink of your own overrides. | `std/logs` |

## Find out when logging fails

| Function | What it does | From |
|---|---|---|
| [Sink.DroppedCount](Modern-Log-LogEvent-DroppedCount) | Returns how many records a sink could not write; the count never resets. | `std/logs` |
| [SetLogErrorHandler](Category-Logging#when-logging-fails) | Sets the one handler told when a sink fails, or 0 to stop the reports. | `std/logs` |

## See Also

- [Logging guide](Category-Logging)
- [Date and Time, for the Instant and TimeSpan fields](Category-Date-and-Time-Chrono)
- [Filesystem, for the errors AddError logs](Category-Filesystem)

---

[Home](Home) · [Function Finder](Function-Finder) · [Keyword Index](Keyword-Index)

<!-- Generated by tools/wikifinder/finder.py. Edit the data, not this page. -->
