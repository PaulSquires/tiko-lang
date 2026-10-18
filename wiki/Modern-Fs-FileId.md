[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **FileId**

# FileId

What makes two paths the same file.

## Syntax

```freebasic
type FileId
    as ulongint Device    '' volume serial (Windows) / st_dev (POSIX)
    as ulongint IdHigh    '' high half of the 128-bit file id on Windows; 0 on POSIX
    as ulongint IdLow     '' low half / st_ino
end type
operator =, <>
```

## Notes

- Two FileIds are equal when both name the same file on the same volume -- through a hard link, a symbolic link followed, or a path spelled differently.
- Not a FileInfo field: on Windows it needs an open handle, so Stat does not pay for it. Ask with GetFileId or File.Id.

## Examples

```freebasic
#import "std/fs"
#import "std/chrono"
using fs

dim as ustring dir_ = CreateTempDir( "tkdoc" ).Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "x" )
dim as FileId a = GetFileId( p ).Value( )
print a = GetFileId( PathJoin( dir_, ".", "f.txt" ) ).Value( )    '' true

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Metadata
