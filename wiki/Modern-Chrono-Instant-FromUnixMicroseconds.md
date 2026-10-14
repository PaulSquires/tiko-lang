[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **FromUnixMicroseconds**

# FromUnixMicroseconds

An Instant from a count of microseconds since the Unix epoch.

## Syntax

```freebasic
Instant.FromUnixMicroseconds( byval v as int64 ) as Instant
```

## Notes

- The finest of the three Unix-epoch constructors. Below this, use `FromTicks`, whose unit is 100 ns.
- Negative values are before 1970 and are perfectly valid.
- Out of range gives Invalid rather than wrapping.

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as Instant i = Instant.FromUnixMicroseconds( 1500000 )

print i.UnixMicroseconds     '' 1500000
print i.UnixMilliseconds     '' 1500
print i.ToIsoString( )       '' 1970-01-01T00:00:01.5000000Z
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** Members
