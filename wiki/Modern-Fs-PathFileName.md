[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PathFileName**

# PathFileName

the leaf; "" for a root

## Syntax

```freebasic
PathFileName( p )
```

## Notes

- the leaf; "" for a root

## Examples

```freebasic
#import "std/fs"
using fs

print PathFileName( "C:\dev\src\main.tiko" )       '' main.tiko
print PathFileName( "main.tiko" )                  '' main.tiko

'' Empty for a root: there is no leaf there
print "[" & PathFileName( "C:\" ) & "]"           '' []
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Paths  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
