[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **MatchPattern**

# MatchPattern

boolean. PURE -- no syscalls.

## Syntax

```freebasic
MatchPattern( s, pattern )
```

## Notes

- boolean. PURE -- no syscalls.

## Examples

```freebasic
#import "std/fs"
using fs

'' PURE -- no syscalls. It matches TEXT against a glob, and never asks
'' whether anything exists.
print MatchPattern( "main.tiko", "*.tiko" )          '' true
print MatchPattern( "main.ti", "*.tiko" )           '' false

'' ? is one character, [] is a set
print MatchPattern( "a1.tiko", "a?.tiko" )           '' true
print MatchPattern( "a1.tiko", "a[0-9].tiko" )       '' true

'' Case follows the grammar, so this is true on Windows
print MatchPattern( "MAIN.TIKO", "*.tiko" )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Glob  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
