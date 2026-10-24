[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalTime.ParseIso**

# LocalTime.ParseIso

Reads ISO text such as 14:30:05 into a time of day, or Invalid on failure.

## Syntax

```freebasic
LocalTime.ParseIso( text )        '' text: a string or a ustring
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as LocalTime t = LocalTime.ParseIso( "14:30:05" )
print t.Hour & " " & t.Minute            '' 14 30

print LocalTime.ParseIso( "14:30:05.123" ).Millisecond      '' 123

'' A bad string yields Invalid -- there is no exception and no ERR( ).
'' Use TryParseIso when the difference matters at the call site.
print LocalTime.ParseIso( "not a time" ).IsValid            '' false
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
