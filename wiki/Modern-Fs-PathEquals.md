[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PathEquals**

# PathEquals

normalized, case-insensitive on Windows

## Syntax

```freebasic
PathEquals( a, b )
```

## Notes

- normalized, case-insensitive on Windows

## Examples

```freebasic
#import "std/fs"
using FB

'' Compares NORMALIZED paths, and case-insensitively where the grammar
'' says the platform is
print PathEquals( "C:\dev\src", "C:\dev\\src\" )    '' true
print PathEquals( "C:\DEV", "c:\dev" )               '' true on Windows

print PathEquals( "C:\dev", "C:\other" )             '' false

'' Still PURE: it compares text, so two different paths that happen to
'' reach the same file through a symlink are not equal here
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Paths  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
