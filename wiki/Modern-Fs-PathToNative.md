[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PathToNative**

# PathToNative

Returns the path with the platform's separators, duplicates collapsed, nothing resolved.

## Syntax

```freebasic
PathToNative( p )
```

## Notes

- separators to native, duplicates collapsed, but

## Examples

```freebasic
#import "std/fs"
using fs

'' Rewrites the separators to the platform's own, so a path read from a
'' config file written on the other platform still works
print PathToNative( "C:/work/src" )      '' C:\work\src on Windows

'' It changes separators only -- it does not normalise, resolve or
'' validate anything
print PathToNative( "a/b//c" )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Paths
