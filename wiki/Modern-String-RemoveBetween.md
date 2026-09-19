[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **RemoveBetween**

# RemoveBetween

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [String Library](Category-String-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

Deletes from each opening delimiter through its matching closing one.

## Syntax

```freebasic
RemoveBetween( s, opening, closing [, removeAll] [, start] [, ignoreCase] )
```

## Notes

- The delimiters go too, not just the text between them.
- `removeAll` repeats until no pair is left; the default removes only the first.
- An **unbalanced opener stops the walk** and leaves the rest alone, so a stray `(` does not swallow the tail of the string.
- `closing` is searched from the end of `opening`, so a pair cannot be crossed.

## Examples

```freebasic
#include once "fb/string.bi"
using FB

print RemoveBetween( "blah (text) blah", "(", ")" )       '' blah  blah

'' removeAll repeats until no pair is left
print RemoveBetween( "var1(34), var2( 73 ), var3(any)", "(", ")", true )
                             '' var1, var2, var3

'' An unbalanced opener stops the walk rather than swallowing the tail
print RemoveBetween( "keep (this", "(", ")" )             '' keep (this
```

---

**Library:** [String Library](Category-String-Library) ✨  
**Category:** [String Library](Category-String-Library)  
**Documented under:** Members  
**Source:** `docs/string/string.txt` in the tiko-lang repository.
