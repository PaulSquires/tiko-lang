[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PathFilePrefix**

# PathFilePrefix

ustring

## Syntax

```freebasic
PathFilePrefix( p [, gram ] )
```

## Notes

- The file name up to its FIRST dot, a leading dot not counting. PathStem stops at the LAST dot.

## Examples

```freebasic
#import "std/fs"
using fs

print PathFilePrefix( "/d/archive.tar.gz", FB_PATH_POSIX )    '' archive
print PathStem( "/d/archive.tar.gz", FB_PATH_POSIX )          '' archive.tar
print PathFilePrefix( ".bashrc", FB_PATH_POSIX )             '' .bashrc
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Paths
