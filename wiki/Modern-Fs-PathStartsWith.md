[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PathStartsWith**

# PathStartsWith

## Syntax

```freebasic
PathStartsWith( p, pre )
```

## Examples

```freebasic
#import "std/fs"
using fs

'' Whole-COMPONENT prefix test, not a string prefix -- which is what
'' makes it safe for a containment check
print PathStartsWith( "C:\dev\src", "C:\dev" )       '' true

'' "C:\development" does NOT start with "C:\dev", though the text does
print PathStartsWith( "C:\development", "C:\dev" )    '' false

'' The check to use before trusting a user-supplied path to stay inside
'' a directory -- after normalising it
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Paths
