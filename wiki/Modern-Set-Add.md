[Home](Home) › [Set](Category-Set) › [Set](Category-Set) › **Add**

# Add

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [Set](Category-Set), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
Add( byref v as T ) as boolean
```

## Examples

```freebasic
#include once "fb/set.bi"
using FB

dim seen as Set( of ustring )

print seen.Add( "ada" )      '' true -- inserted
print seen.Add( "ada" )      '' false -- already there

'' Deduplicating a stream in one pass
dim as ustring names( 0 to 2 ) = { "ada", "grace", "ada" }
dim uniq as Set( of ustring )
for i as integer = 0 to ubound( names )
    if uniq.Add( names( i ) ) then print "new: " & names( i )
next
```

---

**Library:** [Set](Category-Set) ✨  
**Category:** [Set](Category-Set)  
**Documented under:** Members  
**Source:** `docs/set/set.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
