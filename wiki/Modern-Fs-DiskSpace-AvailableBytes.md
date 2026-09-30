[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **DiskSpace.AvailableBytes**

# DiskSpace.AvailableBytes

## Syntax

```freebasic
DiskSpace.AvailableBytes
```

## Examples

```freebasic
#import "std/fs"
using FB

dim sp as DiskSpace = GetDiskSpace( "." ).Value( )

'' FREE TO THIS USER -- the one to branch on before writing, because a
'' quota can make it far smaller than FreeBytes
print sp.AvailableBytes <= sp.FreeBytes    '' -1 (true)

dim as uint64 need = 1024
if sp.AvailableBytes > need then print "room to write"
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Volumes  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
