[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **DiskSpace.FreeBytes**

# DiskSpace.FreeBytes

Returns the free bytes on the volume, ignoring quotas; the number to report.

## Syntax

```freebasic
DiskSpace.FreeBytes
```

## Examples

```freebasic
#import "std/fs"
using fs

dim sp as DiskSpace = GetDiskSpace( "." ).Value( )

'' Free on the volume, IGNORING QUOTA -- the number to REPORT
print sp.FreeBytes <= sp.TotalBytes        '' -1 (true)

'' AvailableBytes is the one to BRANCH on: under a quota it is smaller,
'' and it is what a write will actually be allowed to use
print sp.AvailableBytes <= sp.FreeBytes    '' -1 (true)
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Volumes
