[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.TryFormat**

# Instant.TryFormat

## Syntax

```freebasic
Instant.TryFormat( pattern, result )
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
dim as ustring out_

'' The non-raising form of the pattern ToString: FALSE on a pattern it
'' cannot render, rather than an Invalid-looking string
if d.TryFormat( "yyyy-MM-dd HH:mm", out_ ) then print out_

print d.TryFormat( "yyyy", out_ )        '' true
print out_                                '' 2026
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
