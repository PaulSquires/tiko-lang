[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **Tally**

# Tally

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [String Library](Category-String-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

Non-overlapping occurrences. "aaaa" contains "aa" TWICE.

## Syntax

```freebasic
Tally( s, match [, ic] )
```

## Notes

- O(n*m) — long

## Examples

```freebasic
#include once "fb/string.bi"
using FB

dim as ustring csv = "a,b,,c"

print Tally( csv, "," )              '' 3 -- one per separator
print Tally( "aaaa", "aa" )          '' 2 -- occurrences never overlap
print Tally( "Hello", "L", true )    '' 2 -- ignoreCase
print Tally( csv, "" )               '' 0 -- an empty match counts nothing
```

---

**Library:** [String Library](Category-String-Library) ✨  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
