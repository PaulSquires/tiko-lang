[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **Instant.ToInstant**

# Instant.ToInstant

Returns the moment the date-time names, or Invalid if it has no offset.

## Syntax

```freebasic
Instant.ToInstant
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 123 ).WithOffset( 60 )

'' The moment this civil reading names, using its OWN offset
dim as Instant i = d.ToInstant( )
print i.ToIsoString( )       '' 2026-08-13T13:30:05.1230000Z -- an hour earlier

'' Without an offset there is no moment to compute, so it is Invalid --
'' AssumeUtc is the explicit way through
dim as DateTime u = DateTime( 2026, 8, 13, 14, 30, 5, 123 )
print u.ToInstant( ).IsValid     '' false
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
