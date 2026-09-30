[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PathToNative**

# PathToNative

NO '.' or '..' resolution

## Syntax

```freebasic
PathToNative( p )
```

## Notes

- separators to native, duplicates collapsed, but

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

'' Rewrites the separators to the platform's own, so a path read from a
'' config file written on the other platform still works
print PathToNative( "C:/dev/src" )       '' C:\dev\src on Windows

'' It changes separators only -- it does not normalise, resolve or
'' validate anything
print PathToNative( "a/b//c" )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Paths  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
