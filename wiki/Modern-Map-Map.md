[Home](Home) › [Map](Category-Map) › [Map](Category-Map) › **Map**

# Map

An open-addressed hash map.

## Syntax

```freebasic
Map( of TK, TV )
```

## Notes

- **READING vs WRITING is the thing to know.** `m[ k ]` **inserts** a default-constructed value when `k` is absent; `TryGet` and `Contains` do not. `m[ k ] += 1` just working is why, and `if m[ k ] = 0` silently growing the map is the price.
- The **hash contract**: `K` extends `containers.Hashable` (or is a built-in type), `k = k` must compare, and **equal keys must hash equal**.
- Open addressing with linear probing, power-of-two capacity, tombstones on removal, load factor 0.75. Open addressing rather than chaining means one allocation instead of one per entry, which matters more in a language with no garbage collector.
- **Iteration order is unspecified** and changes across insertions. It is not randomised per process -- stability within one unmodified map is more useful when debugging.

## Examples

```freebasic
#import "std/containers"
using containers

dim ages as Map( of ustring, integer )

ages.Put( "ada", 36 )
print ages.Count             '' 1
print ages[ "ada" ]          '' 36

'' READING an absent key INSERTS it -- use Contains or TryGet to ask
print ages.Contains( "alan" )                 '' false
print ages[ "alan" ]         '' 0
print ages.Count             '' 2 -- the read grew the map

'' OrderedMap is the sibling that iterates in key order
```

---

**Library:** [Map](Category-Map)  
**Category:** [Map](Category-Map)  
**Documented under:** Members  
**Source:** `docs/map/map.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
