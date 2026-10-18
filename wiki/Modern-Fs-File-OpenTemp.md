[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **File.OpenTemp**

# File.OpenTemp

FsResultBool

## Syntax

```freebasic
File.OpenTemp( [ dir ] [, prefix ] )
```

## Notes

- Creates and opens, Read + Write, a new file named prefix ("tiko" by default) plus 16 random hex digits, in dir -- the system temp directory when dir is empty.
- It is never deleted automatically: remove it yourself, with defer if you like.

## Examples

```freebasic
#import "std/fs"
using fs

dim as ustring dir_ = CreateTempDir( "tkdoc" ).Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
dim as File t
print t.OpenTemp( dir_ ).IsOk( )    '' true
print left( PathFileName( t.Path( ) ), 4 )    '' tiko
t.Close( )
RemoveFile( t.Path( ) )

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Files
