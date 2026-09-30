[Home](Home) › [Filesystem](Category-Filesystem) › [Filesystem Library](Category-Filesystem) › **PathSplit**

# PathSplit

fills an Array( of ustring ); returns the count

## Syntax

```freebasic
PathSplit( p, comps )
```

## Notes

- fills an Array( of ustring ); returns the count

## Examples

```freebasic
#import "std/fs"
using FB

'' Fills an Array with the components and returns the count.
''
'' THE ROOT IS NOT A COMPONENT. "C:\dev\src\main.tko" splits into
'' three, not four -- PathRoot joined with these reconstructs the
'' normalised path, and that is the round trip the split guarantees.
dim parts as Array( of ustring )
dim as int32 n = PathSplit( "C:\dev\src\main.tko", parts )

print n                      '' 3
for i as int32 = 0 to parts.Count - 1
    print parts[ i ]         '' dev / src / main.tko
next

print PathRoot( "C:\dev\src\main.tko" )      '' C:\  -- the missing piece

'' It splits the NORMALISED path, so "." and ".." are already resolved
'' and never come back as components
```

---

**Library:** [Filesystem Library](Category-Filesystem)  
**Category:** [Filesystem](Category-Filesystem)  
**Documented under:** Paths  
**Source:** `docs/filesystem/filesystem.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
