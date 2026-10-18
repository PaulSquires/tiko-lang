[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **TextReader.ReadLine**

# TextReader.ReadLine

FsResultBool

## Syntax

```freebasic
TextReader.ReadLine( line )
```

## Notes

- The next line, decoded, in a ustring. FALSE at the end.
- Lines are ReadAllLines' lines: a line ends at LF; one CR before the LF is dropped; a CR anywhere else is text; the last line needs no LF; a final LF is not followed by an empty line.

## Examples

```freebasic
#import "std/fs"
using fs

dim as MemoryStream m = MemoryStream( "one" & chr( 13, 10 ) & "two" )
dim as TextReader tr = TextReader( m )
dim as ustring ln
tr.ReadLine( ln ) : print ln    '' one
tr.ReadLine( ln ) : print ln    '' two
print tr.ReadLine( ln ).Value( )    '' false
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Streams
