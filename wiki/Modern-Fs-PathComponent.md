[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PathComponent**

# PathComponent

Holds one part of a path: its kind, such as root or parent, and its text.

## Syntax

```freebasic
type PathComponent
    Kind( ) as PathComponentKind     '' PATH_PREFIX PATH_ROOT PATH_CURDIR PATH_PARENT PATH_NORMAL
    Text( ) as ustring
    PrefixKind( ) as long            '' PATH_PREFIX_DISK, _UNC, _VERBATIM, _VERBATIM_UNC, _VERBATIM_DISK, _DEVICE
end type
```

## Notes

- PrefixKind( ) is 0 unless Kind( ) is PATH_PREFIX.

## Examples

```freebasic
#import "std/fs"
using fs

for each c in PathComponents( "C:" & chr( 92 ) & "tools", FB_PATH_WIN32 )
    print c.Kind( ), c.Text( ), c.PrefixKind( )
next
''  0  C:  1
''  1  \  0
''  4  tools  0
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Paths
