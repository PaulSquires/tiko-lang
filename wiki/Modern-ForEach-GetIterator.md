[Home](Home) › [For Each](Category-For-Each) › [For Each](Category-For-Each) › **GetIterator**

# GetIterator

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [For Each](Category-For-Each), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

## Syntax

```freebasic
GetIterator( )
```

## Examples

```freebasic
#include once "fb/array.bi"
using FB

'' RFC-0002: a type is iterable when it has GetIterator( ), and the
'' iterator it hands back has IsValid( ), Value( ) and MoveNext( ).
'' `for each` is rewritten into exactly those three calls.
dim v as Array( of long )
v.Push( 1 ) : v.Push( 2 ) : v.Push( 3 )

for each x in v
    print x;
next
print                        '' 1 2 3

'' Which is this, written out:
dim it as ArrayIterator( of long ) = v.GetIterator( )
while it.IsValid( )
    print it.Value( );
    it.MoveNext( )
wend
print                        '' 1 2 3
```

---

**Library:** [For Each](Category-For-Each) ✨  
**Category:** [For Each](Category-For-Each)  
**Documented under:** What Can Be Walked  
**Source:** `docs/for_each/for-each.txt` in the tiko-lang repository.
