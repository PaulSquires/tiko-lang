[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PatternIsRecursive**

# PatternIsRecursive

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
PatternIsRecursive( pattern )
```

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

'' ** means "this directory and everything under it"
print PatternIsRecursive( "src\**\*.bas" )        '' true
print PatternIsRecursive( "src\*.bas" )           '' false

'' Worth testing before a Glob, because a recursive pattern can walk an
'' arbitrarily large tree
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Glob  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
