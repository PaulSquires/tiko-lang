[Home](Home) › [Filesystem](Category-Filesystem) › [File Streams](Category-File-Streams) › **WriteAllText**

# WriteAllText

Writes a string to a file as UTF-8, creating the file or replacing it.

## Syntax

```freebasic
WriteAllText( p, s )
WriteAllText( p, s, enc [, mode ] )   '' in a TextEncoding: Utf16LE( ), Ansi( ), CodePage( n ), ...
```

## Notes

- FsResultBool
- With an encoding, `mode` is TEXT_STRICT by default: a character the encoding cannot hold fails the call with FS_INVALID_DATA, and the file is not touched. With TEXT_REPLACE it becomes `?`, and the value is `false`. A BOM is written when the encoding has one (`Utf16LE( )` does, `Utf8( )` does not). See [Choosing An Encoding](Category-File-Streams#choosing-an-encoding).

## Examples

```freebasic
#import "std/fs"
using fs

'' Everything below happens inside a temp directory of its own, and is
'' removed at the end
dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )

dim as ustring p = PathJoin( dir_, "f.txt" )

print WriteAllText( p, "hello" ).IsOk( ) '' true
print ReadAllText( p ).Value( )          '' hello

'' TRUNCATES: it replaces the whole file, it does not append
WriteAllText( p, "bye" )
print ReadAllText( p ).Value( )          '' bye

'' Written as UTF-8, with no BOM

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [File Streams](Category-File-Streams)  
**Documented under:** File Operations
