[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.ParseExact**

# Instant.ParseExact

Reads text laid out by a pattern such as "dd/MM/yyyy", or Invalid if it does not match.

## Syntax

```freebasic
Instant.ParseExact( s, pattern )
Instant.ParseExact
```

## Examples

```freebasic
#import "std/chrono"
using chrono

'' Parse against a PATTERN, for text whose layout you already know
dim as DateTime d = DateTime.ParseExact( "13/08/2026", "dd/MM/yyyy" )

print d.Year & "-" & d.Month & "-" & d.Day       '' 2026-8-13

'' The text must match the pattern exactly -- that is the point of it
print DateTime.ParseExact( "2026-08-13", "dd/MM/yyyy" ).IsValid      '' false
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
