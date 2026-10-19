[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.WithOffset**

# Instant.WithOffset

Attaches a UTC offset in minutes, keeping the clock reading and changing the moment.

## Syntax

```freebasic
Instant.WithOffset( offMin )
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
'' ATTACHES an offset, keeping the civil fields exactly as they are --
'' it REINTERPRETS which moment this reading names
dim as DateTime z = d.WithOffset( 60 )

print z.Hour                 '' 14, unchanged
print z.ToIsoString( )       '' 2026-08-13T14:30:05.1230000+01:00

'' ToOffset is the other one: same moment, different clock
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
