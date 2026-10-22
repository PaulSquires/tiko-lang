[Home](Home) › [Filesystem](Category-Filesystem) › [File Streams](Category-File-Streams) › **Stream.Read**

# Stream.Read

Reads up to n bytes and returns how many; 0 means the end of the data.

## Syntax

```freebasic
Stream.Read( buf, n )
```

## Notes

- Reads up to n bytes into buf and returns how many it read -- possibly fewer than n.
- Ok( 0 ) for n > 0 means the end of the data, and nothing else does. n = 0 returns Ok( 0 ) and touches nothing.
- n < 0, or a null buf with n > 0, is FS_INVALID_ARGUMENT.

## Examples

```freebasic
#import "std/fs"
using fs

dim as MemoryStream m = MemoryStream( "abc" )
dim as ubyte b( 0 to 7 )
print m.Read( @b(0), 8 ).Value( )    '' 3 -- fewer than asked
print m.Read( @b(0), 8 ).Value( )    '' 0 -- the end
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [File Streams](Category-File-Streams)
**Documented under:** Streams
