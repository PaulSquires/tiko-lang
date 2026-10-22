[Home](Home) › [Filesystem](Category-Filesystem) › [File Streams](Category-File-Streams) › **ReadAllText**

# ReadAllText

Reads a whole file as UTF-8 text into a string, or fails if it cannot be read.

## Syntax

```freebasic
ReadAllText( p )
ReadAllText( p, maxBytes )    '' FS_TOO_LARGE above maxBytes, before anything is read
ReadAllText( p, enc [, mode ] )   '' in a TextEncoding: Utf16LE( ), Ansi( ), CodePage( n ), ...
```

## Notes

- FsResultUStr
- With an encoding, that encoding is used whatever the file starts with; only a BOM that matches it is skipped. `mode` is TEXT_REPLACE (bytes that do not decode become U+FFFD, the default) or TEXT_STRICT (they fail with FS_INVALID_DATA). See [Choosing An Encoding](Category-File-Streams#choosing-an-encoding).

## Examples

```freebasic
#import "std/fs"
using fs

'' Everything below happens inside a temp directory of its own, and is
'' removed at the end
dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )

dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "hello" )

dim r as FsResultUStr = ReadAllText( p )
print r.IsOk( )              '' true
print r.Value( )             '' hello

'' A missing file is a FAILURE, not an empty string -- which is the
'' whole point of returning a Result
dim miss as FsResultUStr = ReadAllText( PathJoin( dir_, "nope.txt" ) )
print miss.IsOk( )                       '' false
print miss.Failure( ).Code( ) = FS_NOT_FOUND     '' -1 (true)

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [File Streams](Category-File-Streams)  
**Documented under:** File Operations
