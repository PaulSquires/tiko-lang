[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **DiskSpace.TotalBytes**

# DiskSpace.TotalBytes

## Syntax

```freebasic
DiskSpace.TotalBytes
```

## Examples

```freebasic
#import "std/fs"
using fs

dim sp as DiskSpace = GetDiskSpace( "." ).Value( )

print sp.TotalBytes > 0      '' -1 (true)

'' The capacity of the VOLUME the path is on -- not of the directory,
'' and not of any quota applied to you
print sp.TotalBytes >= sp.FreeBytes        '' -1 (true)
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Volumes
