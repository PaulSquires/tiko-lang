[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PathParent**

# PathParent

Returns the path without its last part, or an empty string for a root.

## Syntax

```freebasic
PathParent( p )
```

## Notes

- "" for a root and for a single relative component

## Examples

```freebasic
#import "std/fs"
using fs

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
