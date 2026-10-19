[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PathAddExtension**

# PathAddExtension

Adds an extension after any already there, so a.tar becomes a.tar.gz.

## Syntax

```freebasic
PathAddExtension( p, ext [, gram ] )
```

## Notes

- Adds ext after any extension already there; PathChangeExtension replaces it instead.
- A leading dot in ext is not doubled. A trailing separator does not hide the name: "dir/" becomes "dir.gz". An empty ext, or a path with no file name, comes back unchanged.

## Examples

```freebasic
#import "std/fs"
using fs

print PathAddExtension( "data.tar", "gz", FB_PATH_POSIX )         '' data.tar.gz
print PathChangeExtension( "data.tar", "gz", FB_PATH_POSIX )      '' data.gz
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Paths
