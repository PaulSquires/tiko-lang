[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **GlobRoot**

# GlobRoot

the directory a pattern will be walked from

## Syntax

```freebasic
GlobRoot( pattern )
```

## Notes

- the directory a pattern will be walked from

## Examples

```freebasic
#import "std/fs"
using fs

'' The directory a pattern will be walked FROM -- the fixed prefix
'' before the first wildcard
print GlobRoot( "C:\dev\src\*.tiko" )     '' C:\dev\src
print GlobRoot( "C:\dev\**\*.tiko" )      '' C:\dev

'' A pattern with no wildcard at all is its own parent
print GlobRoot( "C:\dev\main.tiko" )       '' C:\dev

'' Pure: it parses the pattern and touches nothing
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Glob
