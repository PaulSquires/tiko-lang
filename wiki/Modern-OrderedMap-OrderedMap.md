[Home](Home) › [OrderedMap](Category-OrderedMap) › [OrderedMap](Category-OrderedMap) › **OrderedMap**

# OrderedMap

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang API.** Part of [OrderedMap](Category-OrderedMap), added by tiko-lang. Not available in stock FreeBASIC 1.20.0.

A red-black tree map: always sorted by key.

## Syntax

```freebasic
OrderedMap( of TK, TV )
```

## Notes

- **`for each` walks it in ascending key order, always** -- which is the entire reason to reach for it over `FB.Map`.
- The **ordering contract is `<` on TK and nothing else**: no `HashOf` and no `=` are needed. Two keys are the same key when neither is less than the other, which is what std::map means by equivalence.
- `FB.Map` unless you need the order: it is O(1) per operation against this one's O(log n), one allocation instead of one per entry, and no pointer chasing.
- Reading through `m[ k ]` inserts, exactly as in `FB.Map`.

## Examples

```freebasic
#include once "fb/orderedmap.bi"
using FB

dim ages as OrderedMap( of string, integer )
ages.Put( "bob", 41 )
ages.Put( "ada", 36 )

'' ASCENDING KEY ORDER, always -- the reason to pay O(log n)
for each kv in ages
    print kv.key             '' ada / bob
next

'' Keys( ) and Values( ) come out sorted too, so they need no sort after
dim ks as Array( of string ) = ages.Keys( )
print ks[ 0 ]                '' ada
```

---

**Library:** [OrderedMap](Category-OrderedMap) ✨  
**Category:** [OrderedMap](Category-OrderedMap)  
**Documented under:** Members  
**Source:** `docs/ordered/ordered.txt` in the tiko-lang repository.
