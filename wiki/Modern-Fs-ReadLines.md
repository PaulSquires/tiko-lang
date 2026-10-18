[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **ReadLines**

# ReadLines

LineRange -- for each yields one FsResultUStr per line

## Syntax

```freebasic
ReadLines( p [, mode ] )
```

## Notes

- Reads p a line at a time, so memory is the buffer plus the longest line, never the whole file.
- Lines are ReadAllLines' lines: a line ends at LF; one CR before the LF is dropped; a CR anywhere else is text; the last line needs no LF; a final LF is not followed by an empty line.
- A failure is a yielded element, not an exception and not silence: a file that cannot be opened gives exactly one element, the failure; a read error ends the sequence after it.
- Leaving the loop early -- exit for, goto, return -- closes the file.

## Examples

```freebasic
#import "std/fs"
using fs

dim as ustring dir_ = CreateTempDir( "tkdoc" ).Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "one" & chr( 10 ) & "two" )
for each ln in ReadLines( p )
    if ln.IsOk( ) then print ln.Value( )
next
'' one
'' two
for each ln in ReadLines( PathJoin( dir_, "missing.txt" ) )
    print ln.Failure( ).Message( )    '' no such file or directory
next
RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** File Operations
