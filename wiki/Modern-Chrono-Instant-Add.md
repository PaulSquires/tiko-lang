[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.Add**

# Instant.Add

## Syntax

```freebasic
Instant.Add( span )
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
print d.Add( TimeSpan.FromHours( 2 ) ).Hour       '' 16

'' IMMUTABLE -- the receiver is untouched
d.Add( TimeSpan.FromHours( 2 ) )
print d.Hour                 '' 14
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
