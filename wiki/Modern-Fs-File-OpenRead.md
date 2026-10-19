[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **File.OpenRead**

# File.OpenRead

Opens an existing file for reading only.

## Syntax

```freebasic
File.OpenRead( p )
```

## Notes

- Read only; the file must exist (FS_NOT_FOUND otherwise).

## Examples

```freebasic
#import "std/fs"
using fs

dim as ustring dir_ = CreateTempDir( "tkdoc" ).Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
dim as File f
print cbool( f.OpenRead( p ).Failure( ).Code( ) = FS_NOT_FOUND )    '' true

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Files
