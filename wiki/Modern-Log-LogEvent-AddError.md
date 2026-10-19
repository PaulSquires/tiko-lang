[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LogEvent.AddError**

# LogEvent.AddError

Adds a filesystem error as fields: its message, its code and any system error code.

## Syntax

```freebasic
AddError( v as FsError )
```

## Notes

- expands to error, error.code and error.os

## Examples

```freebasic
#import "std/fs"
#import "std/containers"
#import "std/outcome"
#import "std/numeric"
#import "std/logs"
using logs, fs, containers, outcome, numeric


dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

'' One call expands to THREE fields -- the message, the code and the OS
'' error -- so a filesystem failure is logged the same way every time
'' FsError's fields are read-only accessors -- Code( ), OsCode( ),
'' Path( ) -- so one is built through its constructor, not assigned to
dim e as FsError = FsError( FS_NOT_FOUND, 2, "CreateFileW", "data.csv" )
lg.Error( ).AddError( e ).Msg( "open failed" )
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members
