[Home](Home) › [Logging](Category-Logging) › [Logging](Category-Logging) › **Name**

# Name

This logger's component name, attached to every record it makes.

## Syntax

```freebasic
Name as ustring             '' get and set
```

## Notes

- A property, like `MinLevel`.
- It is what lets one subsystem's lines be told apart at the sink.
- `WithName` makes a **child** carrying a different name; assigning this changes the logger in place.

## Examples

```freebasic
#import "std/logs"
using logs

dim con as ConsoleSink
dim lg as Logger
lg.AddSink( @con )

lg.Name = "app"
print lg.Name                '' app

lg.Info( "carries the name app" )

'' WithName makes a child instead of changing this one
dim net_ as Logger = lg.WithName( "net" )
print net_.Name              '' net
print lg.Name                '' app -- unchanged
```

---

**Library:** [Logging](Category-Logging)  
**Category:** [Logging](Category-Logging)  
**Documented under:** Members  
**Source:** `docs/logging/logging.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
