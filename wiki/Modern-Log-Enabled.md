[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **Enabled**

# Enabled

Whether a record at this level would be emitted.

## Syntax

```freebasic
Enabled( byval lv as LogLevel ) as boolean
```

## Notes

- The guard for a message that is **expensive to build**: formatting, joining or serialising something that will then be thrown away.
- It compares against `MinLevel`, so it answers the same question the level methods ask internally -- this just lets a caller ask first.
- Cheap: a comparison, no allocation.

## Examples

```freebasic
#import "std/logs"
using logs

dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

lg.MinLevel = LOG_INFO

print lg.Enabled( LOG_INFO )     '' true
print lg.Enabled( LOG_DEBUG )    '' false -- below MinLevel

'' The point of it: skip work that would be discarded
if lg.Enabled( LOG_DEBUG ) then
    lg.Debug( ).AddText( "dump", "something expensive to build" ).Msg( "state" )
end if
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members
