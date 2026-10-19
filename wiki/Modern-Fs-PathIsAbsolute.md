[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PathIsAbsolute**

# PathIsAbsolute

Returns true if a path needs no current folder; C:dev and \dev are not absolute.

## Syntax

```freebasic
PathIsAbsolute( p )
```

## Notes

- see the Windows note below

## Examples

```freebasic
#import "std/fs"
using fs

print PathIsAbsolute( "C:\dev" )          '' true
print PathIsAbsolute( "dev\src" )        '' false

'' A ROOTED BUT DRIVE-RELATIVE Windows path is NOT absolute: "\dev"
'' means "the current drive's \dev", so it still depends on where you
'' are
print PathIsAbsolute( "\dev" )           '' false
print PathIsAbsolute( "\\srv\share" )    '' true -- UNC needs no drive
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Paths
