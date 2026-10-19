[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PathStem**

# PathStem

Returns the file name without its extension; a dotfile such as .gitignore keeps its name.

## Syntax

```freebasic
PathStem( p )
```

## Notes

- the leaf without its extension

## Examples

```freebasic
#import "std/fs"
using fs

'' The leaf without its extension
print PathStem( "C:\dev\main.tiko" )      '' main
print PathStem( "archive.tar.gz" )        '' archive.tar -- the LAST dot only

'' A dotfile with no extension keeps its whole name
print PathStem( ".gitignore" )            '' .gitignore
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Paths
