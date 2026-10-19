[Home](Home) › [Array Functions](Category-Array-Functions) › **Preserve**

# Preserve

Keeps the existing elements when ReDim resizes an array.

## Syntax

```freebasic
ReDim Preserve array(...) [As datatype]
```

## Description

Used with [`ReDim`](Redim) so that when an array is resized, data is not reset but is preserved. This means when the array is enlarged that only new data is reset, while the old data remains the same (but not necessarily at the same absolute addresses in memory).

 **NOTE**: `ReDim Preserve` may not work as expected in all cases:

[`Preserve`](Preserve)'s current behavior is to keep the original data contiguous in memory, and only expand or truncate the size of the memory (if resizing is not possible, the whole original data block is first shifted to another memory location).  
 Its behavior (with a single dimension) is well-defined only when the upper bound is changed. If the lower bound is changed, the current result is that the data is in effect shifted to start at the new lower bound.  
 If there are multiple dimensions, only the upper bound of only the first dimension may be changed safely. If the first dimension is reduced, the existing mappable data may be lost. If lower-order dimensions are resized at all, the effects can be hard to predict (because multidimensional arrays are stored in row-major order : values differing only in the last index are contiguous).

## Remarks

### Differences from QB

- `Preserve` wasn't supported until PDS 7.1

### See also

- [`Dim`](Dim)
- [`LBound`](Lbound)
- [`ReDim`](Redim)
- [`UBound`](Ubound)

## Examples

```freebasic
ReDim array(1 To 3) As Integer

Dim i As Integer

array(1) = 10

array(2) = 5

array(3) = 8

ReDim Preserve array(1 To 10)

For i = 1 To 10

    Print "array("; i; ") = "; array(i)

Next
```

---

**Category:** [Array Functions](Category-Array-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
