[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PathRoot**

# PathRoot

"C:\", "\\srv\share\", "/", "" -- see below

## Syntax

```freebasic
PathRoot( p )
```

## Notes

- "C:\", "\\srv\share\", "/", "" -- see below

## Examples

```freebasic
#import "std/fs"
using FB

print PathRoot( "C:\dev\src" )            '' C:\
print PathRoot( "\\srv\share\dir" )      '' \\srv\share\
print PathRoot( "relative\path" )        '' (empty) -- no root at all

'' A UNC share is the root, not just the server: \\srv alone is not a
'' place you can be
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Paths  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
