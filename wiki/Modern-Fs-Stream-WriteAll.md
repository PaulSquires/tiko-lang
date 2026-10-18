[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **Stream.WriteAll**

# Stream.WriteAll

FsResultBool

## Syntax

```freebasic
Stream.WriteAll( buf, n )
```

## Notes

- Writes all n bytes, calling Write as often as it takes.

## Examples

```freebasic
#import "std/fs"
using fs

dim as MemoryStream m
dim as ubyte b( 0 to 2 ) = { 65, 66, 67 }
print m.WriteAll( @b(0), 3 ).IsOk( )    '' true
print m.ToUtf8Text( )                   '' ABC
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Streams
