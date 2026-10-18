[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **Copy**

# Copy

FsResultI64

## Syntax

```freebasic
Copy( src, dst [, bufSize ] )
```

## Notes

- Reads src from its position to its end and writes everything to dst with WriteAll. Returns the number of bytes copied.
- dst is not flushed.
- A failure on either side keeps its code and native code, with Operation "Copy". bufSize below 1 is FS_INVALID_ARGUMENT; the default is 65536.

## Examples

```freebasic
#import "std/fs"
using fs


dim as MemoryStream src = MemoryStream( "copy me" )
dim as MemoryStream dst
print Copy( src, dst ).Value( )    '' 7
print dst.ToUtf8Text( )            '' copy me
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Streams
