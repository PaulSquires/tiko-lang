[Home](Home) › [Filesystem](Category-Filesystem) › [File Streams](Category-File-Streams) › **File.Stat**

# File.Stat

Returns the open file's FileInfo, read from the handle even if the file was renamed.

## Syntax

```freebasic
File.Stat( )
```

## Notes

- The FileInfo of the open file, from the handle -- the same fields Stat( path ) gives, for the object this File has open even if its name has since changed.
- HasCreated( ) is false on POSIX.

## Examples

```freebasic
#import "std/fs"
using fs

dim as ustring dir_ = CreateTempDir( "tkdoc" ).Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
dim as File f
f.Create( p )
f.WriteUtf8( "abc" )
dim as FsResultInfo r = f.Stat( )
print r.Value( ).IsFile( ), r.Value( ).Size( )    '' true 3
f.Close( )

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [File Streams](Category-File-Streams)
**Documented under:** Files
