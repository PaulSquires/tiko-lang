[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PathRootLen**

# PathRootLen

length of the root prefix, in code units

## Syntax

```freebasic
PathRootLen( p )
```

## Notes

- length of the root prefix, in code units

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

print PathRootLen( "C:\dev\src" )         '' 3 -- "C:\"
print PathRootLen( "relative" )           '' 0

'' The length in CODE UNITS, so it can index the original string
dim as ustring p = "C:\dev\src"
print mid( p, PathRootLen( p ) + 1 )      '' dev\src
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Paths  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
