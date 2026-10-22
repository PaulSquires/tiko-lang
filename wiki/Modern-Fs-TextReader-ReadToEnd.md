[Home](Home) › [Filesystem](Category-Filesystem) › [File Streams](Category-File-Streams) › **TextReader.ReadToEnd**

# TextReader.ReadToEnd

Appends all the remaining decoded text to a string.

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
**Category:** [File Streams](Category-File-Streams)
**Documented under:** Streams
