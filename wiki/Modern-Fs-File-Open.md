[Home](Home) › [Filesystem](Category-Filesystem) › [File Streams](Category-File-Streams) › **File.Open**

# File.Open

Opens a file the way an OpenOptions says: read, write, append, create and more.

## Syntax

```freebasic
File.Open( p, opts )
```

## Notes

- Opens p as opts says. See [OpenOptions](Modern-Fs-OpenOptions) for the rules.
- A directory is FS_IS_A_DIRECTORY.

## Examples

```freebasic
#import "std/fs"
using fs

dim as ustring dir_ = CreateTempDir( "tkdoc" ).Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
dim as OpenOptions o = OpenOptionsWrite( )
dim as File f
print f.Open( p, o ).IsOk( )    '' true
f.Close( )

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [File Streams](Category-File-Streams)
**Documented under:** Files
