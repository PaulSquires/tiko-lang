[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **Stream.ReadToEnd**

# Stream.ReadToEnd

Appends every remaining byte to an Array; returns how many.

## Syntax

```freebasic
Stream.ReadToEnd( buf )
```

## Notes

- Reads from the position to the end and APPENDS the bytes to buf, an Array( of ubyte ). Returns the number appended.

## Examples

```freebasic
#import "std/fs"
#import "std/containers"
using fs

dim as MemoryStream m = MemoryStream( "abc" )
dim as containers.Array( of ubyte ) b
print m.ReadToEnd( b ).Value( ), b.Count( )    '' 3 3
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Streams
