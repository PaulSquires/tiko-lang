[Home](Home) › [String Library](Category-String-Library) › [String Slices](Category-String-Slices) › **SplitSlices**

# SplitSlices

Walks the parts of a slice between separators, one at a time, in a for each loop.

## Syntax

```freebasic
for each part as const uslice in SplitSlices( v, sep )
```

## Notes

- Each part is a `const` slice of `v`; nothing is copied and no array is built.
- Between two separators, and before a leading or after a trailing one, the part is empty and is still produced, so a text with *n* separators has *n* + 1 parts.
- An empty `sep` produces `v` whole, once.
- The value returned is an iterator — `SliceSplit`, `USliceSplit` or `WSliceSplit` — which is a [view type](String-Slice-Lifetime#view-types): it lives where a slice may.
- When `v` is a `ustring` and `sep` a literal, pass `v[0 to len( v ) - 1]`: otherwise both the `slice` and the `uslice` overloads fit equally and the call is ambiguous.
- O(n) over the whole walk

## Examples

```freebasic
#import "std/strings"
using strings

dim as ustring row = "a,,b,"
for each part as const uslice in SplitSlices( row[0 to len( row ) - 1], "," )
    print "["; part; "]";              '' [a][][b][]
next
print
for each part as const slice in SplitSlices( "one::two", "::" )
    print "["; part; "]";              '' [one][two]
next
print
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Slices](Category-String-Slices)  
**Documented under:** The Functions
