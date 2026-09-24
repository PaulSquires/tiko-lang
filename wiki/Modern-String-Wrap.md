[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **Wrap**

# Wrap

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [String Library](Category-String-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(n)

## Syntax

```freebasic
Wrap( s [, open] [, close] )
```

## Notes

- O(n)

## Examples

```freebasic
#include once "fb/string.bi"
using FB

print Wrap( "Paul" )               '' "Paul" -- double quotes by default
print Wrap( "Paul", "'" )          '' 'Paul' -- an empty closing means "same as opening"
print Wrap( "Paul", "<", ">" )     '' <Paul>

'' A genuinely one-sided wrap is InsertAt's job
```

---

**Library:** [String Library](Category-String-Library) ✨  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
