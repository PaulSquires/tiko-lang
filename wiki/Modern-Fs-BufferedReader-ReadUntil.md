[Home](Home) › [Filesystem](Category-Filesystem) › [File Streams](Category-File-Streams) › **BufferedReader.ReadUntil**

# BufferedReader.ReadUntil

Appends bytes up to and including a delimiter to an Array; returns the count.

## Syntax

```freebasic
BufferedReader.ReadUntil( delim, buf )
```

## Notes

- APPENDS bytes up to and including delim (or to the end) to buf, an Array( of ubyte ). Returns the number appended; 0 at the end.

## Examples

```freebasic
#import "std/fs"
#import "std/containers"
using fs

dim as MemoryStream m = MemoryStream( "key=value" )
dim as BufferedReader br = BufferedReader( m )
dim as containers.Array( of ubyte ) b
print br.ReadUntil( asc( "=" ), b ).Value( )    '' 4 -- k e y =
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [File Streams](Category-File-Streams)
**Documented under:** Streams
