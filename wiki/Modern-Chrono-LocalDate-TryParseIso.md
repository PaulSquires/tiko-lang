[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalDate.TryParseIso**

# LocalDate.TryParseIso

## Syntax

```freebasic
LocalDate.TryParseIso
```

## Examples

```freebasic
#import "std/chrono"
using chrono

dim as LocalDate d

if LocalDate.TryParseIso( "2026-08-13", d ) then print d.ToIsoString( )

'' FALSE on a bad string -- and NOTE WHAT HAPPENS TO THE OUTPUT. It is
'' set to Invalid FIRST and only overwritten on success, so a failed
'' parse DESTROYS whatever was in the variable. Do not keep a previous
'' value there and expect it to survive.
print LocalDate.TryParseIso( "2026-02-30", d )     '' false
print d.IsValid                                    '' false -- clobbered
print "[" & d.ToIsoString( ) & "]"                 '' [] -- not the old date
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
