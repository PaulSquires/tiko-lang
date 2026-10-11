[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PathChangeExtension**

# PathChangeExtension

ext with or without its dot; "" removes

## Syntax

```freebasic
PathChangeExtension( p, ext )
```

## Notes

- ext with or without its dot; "" removes

## Examples

```freebasic
#import "std/fs"
using fs

print PathChangeExtension( "main.tiko", ".o" )       '' main.o

'' The dot is optional in the argument -- both forms mean the same
print PathChangeExtension( "main.tiko", "o" )        '' main.o

'' An EMPTY extension REMOVES it
print PathChangeExtension( "main.tiko", "" )         '' main

'' A file with no extension gains one
print PathChangeExtension( "README", ".md" )        '' README.md
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Paths  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
