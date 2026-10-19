[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.FromUnixMilliseconds**

# Instant.FromUnixMilliseconds

Returns the moment a number of milliseconds after 1970-01-01 UTC.

## Syntax

```freebasic
Instant.FromUnixMilliseconds
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as Instant i = Instant.FromUnixMilliseconds( 1767225600123ll )

print i.ToIsoString( )       '' 2026-01-01T00:00:00.1230000Z
print i.UnixMilliseconds     '' 1767225600123

'' The millisecond form most APIs and file formats use
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
