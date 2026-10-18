[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **Stream.WriteUtf8**

# Stream.WriteUtf8

FsResultBool

## Syntax

```freebasic
Stream.WriteUtf8( s )
```

## Notes

- Writes s as UTF-8 with no BOM -- the encoding WriteAllText uses. A lone surrogate is written as U+FFFD.

## Examples

```freebasic
#import "std/fs"
using fs

dim as MemoryStream m
m.WriteUtf8( "na" & wchr( &hEF ) & "ve" )
print m.Length( )    '' 6 -- the i with diaeresis is two bytes
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Streams
