[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PathComponents**

# PathComponents

PathComponentRange -- for each yields a PathComponent

## Syntax

```freebasic
PathComponents( p [, gram ] )
```

## Notes

- The pieces of p, in order, as written: no normalisation, except that a "." after the first component is dropped.
- Under the Windows grammar a root splits into a PATH_PREFIX ("C:", a UNC share, a \\?\ or \\.\ form) and the PATH_ROOT separator after it; "C:x" has a prefix and no root.
- PathComponentList( p, comps [, gram ] ) fills an Array( of PathComponent ) instead.

## Examples

```freebasic
#import "std/fs"
using fs

for each c in PathComponents( "/usr/./lib/../bin", FB_PATH_POSIX )
    print c.Kind( ), c.Text( )
next
''  1  /
''  4  usr
''  4  lib
''  3  ..
''  4  bin
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Paths
