[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **Split**

# Split

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [String Library](Category-String-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(n*m)   Array( of T )

## Syntax

```freebasic
Split( s [, delim] [, ic] )
```

## Notes

- O(n*m) — Array( of T )

## Examples

```freebasic
#include once "fb/string.bi"
using FB

dim as Array( of string ) parts = Split( "a,b,,c" )

print parts.Count                 '' 4 -- N delimiters always give N+1 fields
print parts[ 0 ] & "|" & parts[ 2 ]    '' a| -- the empty field is kept

'' Any delimiter, and the round trip always holds
dim as Array( of string ) words = Split( "one two three", " " )
print words.Count                 '' 3
print Join( words, "-" )          '' one-two-three
```

---

**Library:** [String Library](Category-String-Library) ✨  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
