[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **MemoryStream**

# MemoryStream

Holds a growable byte buffer in memory that reads, writes and seeks like a file.

## Syntax

```freebasic
type MemoryStream extends Stream
    declare constructor( )                         '' empty
    declare constructor( buf as Array( of ubyte ) ) '' a copy of buf, position 0
    declare constructor( byref s as const ustring ) '' the UTF-8 bytes of s, position 0
end type
```

## Notes

- Reads, writes and seeks. Writing past the end grows it; writing after a seek beyond the end zero-fills the gap.
- A value: copying a MemoryStream copies its bytes and its position, so two copies never share a buffer.
- For tests, and for building output in memory before one WriteAtomic.

## Examples

```freebasic
#import "std/fs"
using fs


dim as MemoryStream m
m.WriteUtf8( "hello, " )
m.WriteUtf8( "world" )
print m.Length( )             '' 12
print m.ToUtf8Text( )         '' hello, world

dim as MemoryStream copy_ = m
copy_.Seek( 0 )
copy_.WriteUtf8( "J" )
print copy_.ToUtf8Text( )     '' Jello, world
print m.ToUtf8Text( )         '' hello, world -- untouched
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Streams
