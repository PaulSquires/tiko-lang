[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **ConsoleSink**

# ConsoleSink

Holds a sink that writes to stderr or stdout, in colour only on a terminal.

## Syntax

```freebasic
ConsoleSink( )
ConsoleSink( target )
ConsoleSink( target, r as Renderer ptr )
```

## Notes

- stderr, own TextRenderer
- CT_STDERR or CT_STDOUT
- your renderer, not owned

## Examples

```freebasic
#import "std/logs"
using logs

'' Writes to stderr, with its own TextRenderer. Detects whether the
'' handle is a terminal, so colour is not emitted into a redirected file.
dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

lg.Info( "to stderr" )

'' FileSink writes to a file, with rotation, and AsyncSink moves the
'' writing of any other sink onto a background thread
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members
