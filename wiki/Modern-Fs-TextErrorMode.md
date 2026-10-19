[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **TextErrorMode**

# TextErrorMode

Holds what a TextReader does with invalid UTF-8: replace it or fail.

## Syntax

```freebasic
enum TextErrorMode
    TEXT_REPLACE = 0    '' U+FFFD in its place, as ReadAllText does
    TEXT_STRICT  = 1    '' FS_INVALID_DATA
end enum
```

## Examples

```freebasic
#import "std/fs"
using fs

dim as MemoryStream m = MemoryStream( "x" )
dim as TextReader tr = TextReader( m, TEXT_STRICT )
dim as ustring ln
print tr.ReadLine( ln ).IsOk( )    '' true
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Streams
