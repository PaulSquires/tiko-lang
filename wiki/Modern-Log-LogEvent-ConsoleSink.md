[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **LogEvent.ConsoleSink**

# LogEvent.ConsoleSink

stderr, own TextRenderer

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

'' It is the only sink in phase 1: FileSink and rotation are phase 3,
'' AsyncSink phase 6
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members
