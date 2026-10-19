[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **GetDiskSpace**

# GetDiskSpace

Returns the total, free and available bytes of the volume a path is on.

## Syntax

```freebasic
GetDiskSpace( p )
```

## Notes

- FsResultSpace

## Examples

```freebasic
#import "std/fs"
using fs

dim r as FsResultSpace = GetDiskSpace( "." )

print r.IsOk( )              '' true

dim sp as DiskSpace = r.Value( )
print sp.TotalBytes > 0      '' -1 (true)
print sp.AvailableBytes <= sp.FreeBytes    '' -1 (true)

'' Three numbers, and the difference between the last two is quotas
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Volumes
