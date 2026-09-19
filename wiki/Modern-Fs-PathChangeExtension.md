[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PathChangeExtension**

# PathChangeExtension

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

ext with or without its dot; "" removes

## Syntax

```freebasic
PathChangeExtension( p, ext )
```

## Notes

- ext with or without its dot; "" removes

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

print PathChangeExtension( "main.bas", ".o" )       '' main.o

'' The dot is optional in the argument -- both forms mean the same
print PathChangeExtension( "main.bas", "o" )        '' main.o

'' An EMPTY extension REMOVES it
print PathChangeExtension( "main.bas", "" )         '' main

'' A file with no extension gains one
print PathChangeExtension( "README", ".md" )        '' README.md
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Paths  
**Source:** `docs/filesystem/filesystem.txt` in the tiko-lang repository.
