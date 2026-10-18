[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **RemoveDirAll**

# RemoveDirAll

rm -rf; FsResultI64, the number of objects removed

## Syntax

```freebasic
RemoveDirAll( p )
```

## Notes

- rm -rf; FsResultI64, the number of objects removed, p itself included.
- A symbolic link or junction inside the tree is removed as a link and never entered.
- **p itself a link is refused** with FS_NOT_A_DIRECTORY, and nothing is deleted; so is a file. Remove a link with RemoveFile (or RemoveDir for a directory link on Windows).
- Every directory is opened relative to its already-open parent, without following a link, and every deletion is made relative to an open directory. A subdirectory that another process swaps for a link while the removal runs is removed as the link it has become; what the link points to is not touched.
- Read-only files are removed, as `rm -rf` and `del /f` do.
- On failure it reports the first error and stops. An entry that disappears meanwhile is not an error.

## Examples

```freebasic
#import "std/fs"
using fs

'' Everything below happens inside a temp directory of its own, and is
'' removed at the end
dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )

'' rm -rf, and it returns THE NUMBER OF OBJECTS REMOVED rather than a
'' bare success flag
CreateDirAll( PathJoin( dir_, "a", "b" ) )
WriteAllText( PathJoin( dir_, "a", "f.txt" ), "x" )

dim r as FsResultI64 = RemoveDirAll( PathJoin( dir_, "a" ) )
print r.IsOk( )              '' true
print r.Value( )             '' 3 -- b, f.txt and a itself

print Exists( PathJoin( dir_, "a" ) )    '' false

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** File Operations
