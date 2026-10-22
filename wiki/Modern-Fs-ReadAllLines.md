[Home](Home) › [Filesystem](Category-Filesystem) › [File Streams](Category-File-Streams) › **ReadAllLines**

# ReadAllLines

Reads a file's lines into an Array, without their line endings; returns the count.

## Syntax

```freebasic
ReadAllLines( p, lines )
ReadAllLines( p, lines, enc [, mode ] )   '' in a TextEncoding; the same lines in every encoding
```

## Notes

- FsResultLong -- fills Array( of ustring )

## Examples

```freebasic
#import "std/containers"
#import "std/fs"
using fs, containers

'' Everything below happens inside a temp directory of its own, and is
'' removed at the end
dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )

dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "one" & chr(10) & "two" & chr(10) & "three" )

dim lines_ as Array( of ustring )
dim r as FsResultLong = ReadAllLines( p, lines_ )

print r.IsOk( )              '' true
print r.Value( )             '' 3 -- the count comes back as the value
print lines_[ 1 ]            '' two

'' The line endings are not included, and CRLF and LF both split

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [File Streams](Category-File-Streams)  
**Documented under:** File Operations
