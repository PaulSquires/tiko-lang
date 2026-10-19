[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **CreateSymlink**

# CreateSymlink

Creates a symbolic link to a target; on Windows this usually needs privilege.

## Syntax

```freebasic
CreateSymlink( target, lnk [, targetIsDir ] )
```

## Notes

- FsResultBool

## Examples

```freebasic
#import "std/fs"
using fs

dim td as FsResultUStr = CreateTempDir( "fbdoc" )
dim as ustring dir_ = td.Value( )
dim as ustring p = PathJoin( dir_, "f.txt" )
WriteAllText( p, "hello" )

'' NEEDS PRIVILEGE ON WINDOWS -- Administrator, or Developer Mode. So
'' this is one of the few calls where a failure is the ORDINARY outcome
'' and must be handled rather than asserted.
dim as ustring lnk = PathJoin( dir_, "link.txt" )
dim r as FsResultBool = CreateSymlink( p, lnk )

if r.IsOk( ) then
    print IsLink( lnk )      '' true
    print ReadLink( lnk ).Value( ) = p       '' -1 (true)
else
    print "not permitted: " & r.Failure( ).Message( )
end if

'' targetIsDir matters on Windows, where a directory symlink and a file
'' symlink are different objects and the target may not exist yet

RemoveDirAll( dir_ )
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Links And Permissions
