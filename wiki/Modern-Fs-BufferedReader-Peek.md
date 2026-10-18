[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **BufferedReader.Peek**

# BufferedReader.Peek

FsResultI64

## Syntax

```freebasic
BufferedReader.Peek( n, buf )
```

## Notes

- Up to n bytes ahead -- at most the buffer's capacity -- WITHOUT consuming them. buf's contents are replaced; returns the count, which is less than n only at the end of the data.

## Examples

```freebasic
#import "std/fs"
#import "std/containers"
using fs

dim as MemoryStream m = MemoryStream( "PK..." )
dim as BufferedReader br = BufferedReader( m )
dim as containers.Array( of ubyte ) b
br.Peek( 2, b )
print chr( b[0], b[1] )    '' PK
dim as ubyte c
br.ReadByte( c )
print chr( c )             '' P -- still there
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Streams
