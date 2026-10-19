[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PathHasExtension**

# PathHasExtension

Returns true if the file name has an extension; a dotfile has none.

## Syntax

```freebasic
PathHasExtension( p )
```

## Examples

```freebasic
#import "std/fs"
using fs

print PathHasExtension( "main.tiko" )       '' true
print PathHasExtension( "README" )        '' false
print PathHasExtension( ".gitignore" )    '' false -- a name, not an extension

'' Reads better than comparing PathExtension against ""
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Paths
