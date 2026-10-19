[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PathExtension**

# PathExtension

Returns the extension with its dot, such as .tiko, or an empty string if there is none.

## Syntax

```freebasic
PathExtension( p )
```

## Notes

- ".tiko", WITH the dot; "" when there is none

## Examples

```freebasic
#import "std/fs"
using fs

'' WITH the dot, which is what makes it concatenate back on cleanly
print PathExtension( "main.tiko" )         '' .tiko
print PathExtension( "archive.tar.gz" )   '' .gz -- the last one

'' Empty when there is none, and a leading dot is a name, not an
'' extension
print "[" & PathExtension( "README" ) & "]"        '' []
print "[" & PathExtension( ".gitignore" ) & "]"    '' []
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Paths
