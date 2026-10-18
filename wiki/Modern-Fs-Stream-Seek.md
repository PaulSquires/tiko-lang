[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **Stream.Seek**

# Stream.Seek

FsResultI64

## Syntax

```freebasic
Stream.Seek( offset [, origin ] )
```

## Notes

- Moves the position and returns the new absolute position. origin is a SeekOrigin, SEEK_FROM_START by default.
- A resulting position below 0 is FS_INVALID_ARGUMENT. Past the end is allowed.

## Examples

```freebasic
#import "std/fs"
using fs

dim as MemoryStream m = MemoryStream( "abcdef" )
print m.Seek( -2, SEEK_FROM_END ).Value( )    '' 4
print m.Seek( -9, SEEK_FROM_CURRENT ).IsOk( ) '' false
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Streams
