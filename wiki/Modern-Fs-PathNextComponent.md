[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PathNextComponent**

# PathNextComponent

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

the cursor PathSplit uses

## Syntax

```freebasic
PathNextComponent( p, gram, from, outlen )
```

## Notes

- the cursor PathSplit uses

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

'' The cursor PathSplit is built on, so the C side never allocates. It
'' returns the ZERO-BASED OFFSET of the next component and writes its
'' length through the last argument.
''
'' A NEGATIVE RETURN means there is nothing left -- NOT zero, which is a
'' perfectly good offset and will loop forever if you test for it.
dim as ustring p = PathNormalize( "C:\dev\src" )
dim as integer at = 0, clen = 0, start_

do
    start_ = PathNextComponent( p, FB_PATH_NATIVE, at, clen )
    if start_ < 0 then exit do
    print mid( p, start_ + 1, clen )     '' dev / src
    at = start_ + clen
loop

'' Like PathSplit, it walks the components only -- the root is not one
'' of them. The offset is 0-based and MID is 1-based, hence the + 1.
```

---

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Paths  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
