[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **MemoryStream.Clear**

# MemoryStream.Clear

Empties the stream; its length and position become 0.

## Syntax

```freebasic
MemoryStream.Clear( )
```

## Notes

- Empties it: length and position become 0.

## Examples

```freebasic
#import "std/fs"
using fs

dim as MemoryStream m = MemoryStream( "abc" )
m.Clear( )
print m.Length( )    '' 0
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Streams
