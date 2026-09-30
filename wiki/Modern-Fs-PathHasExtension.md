[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PathHasExtension**

# PathHasExtension

## Syntax

```freebasic
PathHasExtension( p )
```

## Examples

```freebasic
#include once "fb/filesystem.bi"
using FB

print PathHasExtension( "main.tko" )       '' true
print PathHasExtension( "README" )        '' false
print PathHasExtension( ".gitignore" )    '' false -- a name, not an extension

'' Reads better than comparing PathExtension against ""
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Paths  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
