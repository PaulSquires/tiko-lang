[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **MatchPattern**

# MatchPattern

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

boolean. PURE -- no syscalls.

## Syntax

```freebasic
MatchPattern( s, pattern )
```

## Notes

- boolean. PURE -- no syscalls.

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

'' PURE -- no syscalls. It matches TEXT against a glob, and never asks
'' whether anything exists.
print MatchPattern( "main.tko", "*.tko" )          '' true
print MatchPattern( "main.ti", "*.tko" )           '' false

'' ? is one character, [] is a set
print MatchPattern( "a1.tko", "a?.tko" )           '' true
print MatchPattern( "a1.tko", "a[0-9].tko" )       '' true

'' Case follows the grammar, so this is true on Windows
print MatchPattern( "MAIN.TKO", "*.tko" )
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Glob  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
