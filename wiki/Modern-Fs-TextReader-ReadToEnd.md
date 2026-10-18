[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **TextReader.ReadToEnd**

# TextReader.ReadToEnd

FsResultBool

## Syntax

```freebasic
TextReader.ReadToEnd( s )
```

## Notes

- Everything left, decoded and APPENDED to s. TRUE when anything was appended.

## Examples

```freebasic
#import "std/fs"
using fs

dim as MemoryStream m = MemoryStream( "head" & chr( 10 ) & "rest of it" )
dim as TextReader tr = TextReader( m )
dim as ustring ln, rest
tr.ReadLine( ln )
tr.ReadToEnd( rest )
print rest    '' rest of it
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Streams
