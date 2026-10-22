[Home](Home) › [Filesystem](Category-Filesystem) › [File Streams](Category-File-Streams) › **BufferedReader.ReadLine**

# BufferedReader.ReadLine

Reads the next line as raw bytes in a string, not decoded; returns false at the end.

## Syntax

```freebasic
BufferedReader.ReadLine( line )
```

## Notes

- The next line as BYTES, in a string: not decoded, so a binary or non-UTF-8 line comes back unchanged. FALSE at the end.
- Lines are ReadAllLines' lines: a line ends at LF; one CR before the LF is dropped; a CR anywhere else is text; the last line needs no LF; a final LF is not followed by an empty line.
- For decoded text, use a TextReader.

## Examples

```freebasic
#import "std/fs"
using fs

dim as MemoryStream m = MemoryStream( "a" & chr( 13, 10 ) & "b" )
dim as BufferedReader br = BufferedReader( m )
dim as string ln
print br.ReadLine( ln ).Value( ), ln    '' true a
print br.ReadLine( ln ).Value( ), ln    '' true b
print br.ReadLine( ln ).Value( )        '' false
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [File Streams](Category-File-Streams)
**Documented under:** Streams
