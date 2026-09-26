[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PathHasExtension**

# PathHasExtension

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Filesystem Library](Category-Filesystem), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

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

**Library:** [Filesystem Library](Category-Filesystem) ✨  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Paths  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
