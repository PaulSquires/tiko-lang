[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **ToLocaleTimeString**

# ToLocaleTimeString

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Chrono Date and Time](Category-Date-and-Time-Chrono), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

The time of day as the machine's locale writes it.

## Syntax

```freebasic
ToLocaleTimeString( byval style as long = lsShort ) as string
```

## Notes

- Locale dependent, like every `ToLocale*` member: for display only, never for storage.
- The time half of `ToLocaleString`; `ToLocaleDateString` is the date half.
- A ustring form, `ToLocaleTimeUString`, exists for call sites already working in ustring.

## Examples

```freebasic
#include once "fb/chrono.bi"
using FB

dim as DateTime d = DateTime( 2026, 8, 13, 14, 30, 5, 0 )

print len( d.ToLocaleTimeString( ) ) > 0      '' -1 (true)
print len( d.ToLocaleTimeString( lsLong ) ) > 0        '' -1 (true)
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono) ✨  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** Members  
**Source:** `docs/datetime/datetime.txt` in the tiko-lang repository.
