[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PatternWildcardAt**

# PatternWildcardAt

offset of the first wildcard, or -1

## Syntax

```freebasic
PatternWildcardAt( pattern )
```

## Notes

- offset of the first wildcard, or -1

## Examples

```freebasic
#import "std/fs"
using FB

'' The offset of the first wildcard, or -1 when the pattern is a plain
'' path with nothing to expand
print PatternWildcardAt( "src\*.tiko" )    '' 5
print PatternWildcardAt( "src\main.tiko" ) '' -1

'' What Glob uses to decide how much of a pattern is a fixed directory
'' prefix it can walk to directly
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Glob  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
