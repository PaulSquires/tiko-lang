[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PathParent**

# PathParent

"" for a root and for a single relative component

## Syntax

```freebasic
PathParent( p )
```

## Notes

- "" for a root and for a single relative component

## Examples

```freebasic
#import "std/fs"
using FB

print PathParent( "C:\dev\src" )          '' C:\dev
print PathParent( "C:\dev" )             '' C:\

'' EMPTY for a root and for a single relative component -- there is
'' nowhere further up, and this is how a walk-up loop terminates
print "[" & PathParent( "C:\" ) & "]"     '' []
print "[" & PathParent( "file.txt" ) & "]" '' []
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Paths  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
