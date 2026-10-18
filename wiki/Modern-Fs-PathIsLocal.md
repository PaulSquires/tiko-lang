[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PathIsLocal**

# PathIsLocal

boolean

## Syntax

```freebasic
PathIsLocal( p [, gram ] )
```

## Notes

- TRUE when p is not empty, has no root and no drive, and does not climb above where it starts once "." and ".." are resolved. Under the Windows grammar it also names no reserved device and contains no ':'.
- The check to make before PathJoin( base, name ) with a name you did not write. It is lexical: a symbolic link inside base can still lead out.

## Examples

```freebasic
#import "std/fs"
using fs

print PathIsLocal( "docs/readme.md", FB_PATH_POSIX )    '' true
print PathIsLocal( "../etc/passwd", FB_PATH_POSIX )     '' false
print PathIsLocal( "a/../../b", FB_PATH_POSIX )         '' false
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Paths
