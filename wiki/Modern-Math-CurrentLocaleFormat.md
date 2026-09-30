[Home](Home) › [Math Library](Category-Math-Library) › [Math Library](Category-Math-Library) › **CurrentLocaleFormat**

# CurrentLocaleFormat

The machine's current number-formatting conventions.

## Syntax

```freebasic
CurrentLocaleFormat( ) as NumFormat
```

## Notes

- Fills a `NumFormat` from the OS: `decimalSep`, `groupSep`, and whether grouping is on.
- **Its result depends on the machine**, so it must not be written to a file or asserted on -- it is for presenting a number to the person at the keyboard.
- `ToString` is the locale-independent one, and is what round-trips.

## Examples

```freebasic
#import "std/numeric"
using FB

dim f as NumFormat = CurrentLocaleFormat( )

'' Machine-dependent, so this asserts shape rather than content
print len( f.decimalSep ) > 0                 '' -1 (true)
print len( f.groupSep ) > 0                   '' -1 (true)

'' ToString is the one that does NOT vary, and round-trips
print ToString( 1.5 )        '' 1.5
```

---

**Library:** [Math Library](Category-Math-Library)  
**Category:** [Math Library](Category-Math-Library)  
**Documented under:** Members  
**Source:** `docs/math/math.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
