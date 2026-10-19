[Home](Home) › [Array Functions](Category-Array-Functions) › **LBound**

# LBound

Returns the lowest valid index of an array dimension, or 0 if there is none.

## Syntax

```freebasic
Declare Function LBound ( array() As Any, ByVal dimension As Integer = 1 ) As Integer
```

## Parameters

- `array`
- `dimension`

## Description

`LBound` returns the lowest value that can be used as an index into a particular dimension of an array.

 Array dimensions are numbered from one (`1`) to `n`, where `n` is the total number of dimensions. If `dimension` is not specified, `LBound` will return the lower bound of the first dimension.

 If `dimension` is zero (`0`), `LBound` returns `1`, corresponding to the lower bound of the array dimensions `1`..`n`. `UBound` returns `n`, the number of dimensions, in this case. This can be used to detect the array's number of dimensions.

 For any other (non-zero) `dimension` values outside of the valid range `1`..`n`, `LBound` returns `0`. `UBound` returns `-1` in this case. This can be used to detect whether a certain dimension exists in the array, and also works when used on an empty array which does not have any valid dimensions.

 Thus, for empty dynamic arrays, we get:

## Return Value

Returns the lower bound of an array's dimension.

## Remarks

### Usage

`result = LBound( array [, dimension ] )`

### See also

- [`UBound`](Ubound)
- [`Static`](procedures-Static)
- [`Dim`](Dim)
- [`ReDim`](Redim)

## Examples

```freebasic
Dim array(-10 To 10, 5 To 15, 1 To 2) As Integer

Print LBound(array) 'returns -10

Print LBound(array, 2) 'returns 5

Print LBound(array, 3) 'returns 1
```

---

**Category:** [Array Functions](Category-Array-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
