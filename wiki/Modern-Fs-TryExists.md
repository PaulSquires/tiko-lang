[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **TryExists**

# TryExists

FsResultBool

## Syntax

```freebasic
TryExists( p )
```

## Notes

- Ok( true ) when p exists, following symbolic links.
- Ok( false ) only when p is absent: FS_NOT_FOUND, or FS_NOT_A_DIRECTORY when a component of the path is a file. A dangling symbolic link is Ok( false ).
- Every other failure -- FS_ACCESS_DENIED, FS_LOOP, an IO error -- comes back as the failure it is, because the answer is unknown.

## Examples

```freebasic
#import "std/fs"
using fs

dim td as FsResultUStr = CreateTempDir( "tkdoc" )
dim as ustring dir_ = td.Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "hello" )

print TryExists( p ).Value( )                          '' true
print TryExists( PathJoin( dir_, "nope" ) ).Value( )   '' false

'' Exists says false both for "not there" and for "could not look".
'' TryExists keeps them apart: a denied parent directory is a failure,
'' not a false.
dim as FsResultBool r = TryExists( PathJoin( dir_, "nope" ) )
if( r.IsOk( ) ) then
    print iif( r.Value( ), "there", "absent" )
else
    print "unknown: "; r.Failure( ).Message( )
end if

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Metadata
