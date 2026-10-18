[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **CacheDir**

# CacheDir

FsResultUStr -- where files that can be regenerated belong

## Syntax

```freebasic
CacheDir( )
```

## Notes

- Windows: the LocalAppData known folder, falling back to %LOCALAPPDATA%. Windows has no separate cache folder.
- Linux: $XDG_CACHE_HOME when it is set and absolute, otherwise ~/.cache.
- Nothing is created and no application name is added: it says where the directory SHOULD be, and the caller joins its own name and creates what it needs with CreateDirAll.

## Examples

```freebasic
#import "std/fs"
using fs

dim as FsResultUStr r = CacheDir( )
if r.IsOk( ) then
    dim as ustring mine = PathJoin( r.Value( ), "myapp" )
    print PathIsAbsolute( mine )    '' true
    '' CreateDirAll( mine ) before writing anything there
else
    print r.Failure( ).Message( )
end if
```

---

**Library:** [Filesystem Library](Category-Filesystem)
**Category:** [Filesystem](Category-Filesystem)
**Documented under:** Directories
