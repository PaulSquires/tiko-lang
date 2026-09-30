[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **SpanOf**

# SpanOf

O(n*k)   long

## Syntax

```freebasic
SpanOf( start, s, chars [, ic] )
```

## Notes

- O(n*k) — long

## Examples

```freebasic
#include once "fb/string.bi"
using FB

print SpanOf( 1, "   x", " " )        '' 3 -- three leading spaces
print SpanOf( 1, "x", " " )           '' 0 -- stops immediately
print SpanOf( 4, "   xyz", "xyz" )    '' 3 -- counts from position 4 on

'' Skipping indentation without a trim
dim as ustring line_ = "    indented"
print mid( line_, SpanOf( 1, line_, " " ) + 1 )    '' indented
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
