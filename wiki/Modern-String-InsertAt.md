[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **InsertAt**

# InsertAt

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [String Library](Category-String-Library), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

O(n)

## Syntax

```freebasic
InsertAt( s, insert, position )
```

## Notes

- O(n)

## Examples

```freebasic
#include once "fb/string.bi"
using FB

print InsertAt( "1234567890", "--", 6 )    '' 12345--67890
print InsertAt( "12345", "--", 99 )        '' 12345-- -- past the end appends
print InsertAt( "12345", "--", 0 )         '' 12345 -- below 1 does not insert

'' The one-sided wrap Wrap deliberately does not do
print InsertAt( "value", "$", 1 )          '' $value
```

---

**Library:** [String Library](Category-String-Library) ✨  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the tiko-lang repository.
