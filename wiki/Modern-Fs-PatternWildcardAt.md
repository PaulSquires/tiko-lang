[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PatternWildcardAt**

# PatternWildcardAt

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

offset of the first wildcard, or -1

## Syntax

```freebasic
PatternWildcardAt( pattern )
```

## Notes

- offset of the first wildcard, or -1

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

'' The offset of the first wildcard, or -1 when the pattern is a plain
'' path with nothing to expand
print PatternWildcardAt( "src\*.tko" )    '' 5
print PatternWildcardAt( "src\main.tko" ) '' -1

'' What Glob uses to decide how much of a pattern is a fixed directory
'' prefix it can walk to directly
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Glob  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
