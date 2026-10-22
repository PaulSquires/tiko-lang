[Home](Home) › [Filesystem](Category-Filesystem) › [File Streams](Category-File-Streams) › **AppendAllText**

# AppendAllText

Adds text to the end of a file, creating the file if it is not there.

## Syntax

```freebasic
AppendAllText( p, s )
AppendAllText( p, s, enc [, mode ] )   '' in a TextEncoding; TEXT_STRICT by default
```

## Notes

- FsResultBool
- With an encoding: if the file starts with a BOM for a different UTF encoding, the call fails with FS_INVALID_DATA and the file is not changed. A new or empty file gets the encoding's BOM; a file with text in it never gets another. See [Choosing An Encoding](Category-File-Streams#choosing-an-encoding).

## Examples

```freebasic
#import "std/fs"
using fs

'' Everything below happens inside a temp directory of its own, and is
'' removed at the end
dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )

dim as ustring p = PathJoin( dir_, "log.txt" )

WriteAllText( p, "one" )
AppendAllText( p, " two" )
print ReadAllText( p ).Value( )          '' one two

'' It CREATES the file when it is not there, so an append-only log needs
'' no separate first-write case
dim as ustring fresh = PathJoin( dir_, "new.txt" )
AppendAllText( fresh, "first" )
print ReadAllText( fresh ).Value( )      '' first

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [File Streams](Category-File-Streams)  
**Documented under:** File Operations
