[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PathIsReserved**

# PathIsReserved

Returns true if a part of the path is a Windows device name such as CON or NUL.

## Syntax

```freebasic
PathIsReserved( p [, gram ] )
```

## Notes

- Under the Windows grammar, TRUE when any component is a reserved device name -- CON, PRN, AUX, NUL, CONIN$, CONOUT$, COM1-COM9, LPT1-LPT9 and their superscript-digit forms -- in any case, with or without an extension. Always FALSE under the POSIX grammar.

## Examples

```freebasic
#import "std/fs"
using fs

print PathIsReserved( "logs" & chr( 92 ) & "Com1.txt", FB_PATH_WIN32 )    '' true
print PathIsReserved( "com10", FB_PATH_WIN32 )                           '' false
print PathIsReserved( "con", FB_PATH_POSIX )                             '' false
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Paths
