[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **CreateTempFile**

# CreateTempFile

Creates a uniquely named temporary file and returns its path; it is not deleted for you.

## Syntax

```freebasic
CreateTempFile( [ prefix ] )
```

## Notes

- CREATES it and returns the path
- `prefix` defaults to `"tiko"`.

## Examples

```freebasic
#import "std/fs"
using fs

dim r as FsResultUStr = CreateTempFile( "fbdoc" )
dim as ustring p = r.Value( )

print r.IsOk( )              '' true
print IsFile( p )            '' true -- it exists, empty, already created

WriteAllText( p, "hello" )
print ReadAllText( p ).Value( )          '' hello

'' Created atomically, and NOT deleted automatically
RemoveFile( p )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** File Operations
