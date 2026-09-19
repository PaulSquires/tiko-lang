[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PathParent**

# PathParent

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

"" for a root and for a single relative component

## Syntax

```freebasic
PathParent( p )
```

## Notes

- "" for a root and for a single relative component

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

print PathParent( "C:\dev\src" )          '' C:\dev
print PathParent( "C:\dev" )             '' C:\

'' EMPTY for a root and for a single relative component -- there is
'' nowhere further up, and this is how a walk-up loop terminates
print "[" & PathParent( "C:\" ) & "]"     '' []
print "[" & PathParent( "file.txt" ) & "]" '' []
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Paths  
**Source:** `docs/filesystem/filesystem.txt` in the tiko-lang repository.
