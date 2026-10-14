[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PatternIsRecursive**

# PatternIsRecursive

## Syntax

```freebasic
PatternIsRecursive( pattern )
```

## Examples

```freebasic
#import "std/fs"
using fs

'' ** means "this directory and everything under it"
print PatternIsRecursive( "src\**\*.bas" )        '' true
print PatternIsRecursive( "src\*.bas" )           '' false

'' Worth testing before a Glob, because a recursive pattern can walk an
'' arbitrarily large tree
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Glob
