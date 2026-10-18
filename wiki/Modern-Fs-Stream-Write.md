[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **Stream.Write**

# Stream.Write

FsResultI64

## Syntax

```freebasic
Stream.Write( buf, n )
```

## Notes

- Writes up to n bytes from buf and returns how many it wrote -- possibly fewer, but never 0 for n > 0 without failing. WriteAll writes them all.

## Examples

```freebasic
#import "std/fs"
using fs

dim as MemoryStream m
dim as ubyte b( 0 to 2 ) = { 1, 2, 3 }
print m.Write( @b(0), 3 ).Value( )    '' 3
print m.Length( )                     '' 3
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Streams
