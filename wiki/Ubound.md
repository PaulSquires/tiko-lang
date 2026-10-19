[Home](Home) › [Array Functions](Category-Array-Functions) › **UBound**

# UBound

Returns the highest valid index of an array dimension, or -1 if there is none.

## Syntax

```freebasic
Declare Function UBound ( array() As Any, ByVal dimension As Integer = 1 ) As Integer
```

## Parameters

- `array`
- `dimension`

## Description

`UBound` returns the largest value that can be used as an index into a particular dimension of an array.

 Array dimensions are numbered from one (`1`) to `n`, where `n` is the total number of dimensions. If `dimension` is not specified, `UBound` will return the upper bound of the first dimension.

 If `dimension` is zero (0), `UBound` returns `n`, the number of dimensions in the array. For any other `dimension` values outside of the valid range `1`..`n`, the result is `-1`. This can be used to detect the number of dimensions of variable-length arrays, and in combination with the result of `Lbound()` for such cases, whether a given dimension exists, or whether the array is empty (zero dimensions). See the [`LBound`](Lbound) page for more information.

## Return Value

Returns the upper bound of an array's dimension.

## Remarks

### Usage

`result = UBound( array [, dimension ] )`

### See also

- [`LBound`](Lbound)
- [`Static`](procedures-Static)
- [`Dim`](Dim)
- [`ReDim`](Redim)
- [`SizeOf`](Sizeof)

## Examples

```freebasic
Dim array(-10 To 10, 5 To 15, 1 To 2) As Integer

Print UBound(array) 'returns 10

Print UBound(array, 2) 'returns 15

Print UBound(array, 3) 'returns 2
```

```freebasic
'' determining the size of an array

Dim As Short array(0 To 9)

Dim As Integer arraylen, arraysize

arraylen = UBound(array) - LBound(array) + 1

arraysize = arraylen * SizeOf( Short )

Print "Number of elements in array:", arraylen    '10

Print "Number of bytes used in array:", arraysize '10 * 2 = 20
```

```freebasic
'' determining the size of a multi-dimensional array

Dim As Long array4D(1 To 2, 1 To 3, 1 To 4, 1 To 5)

Dim As Integer arraylen, arraysize

arraylen = (UBound(array4D, 4) - LBound(array4D, 4) + 1) _

         * (UBound(array4D, 3) - LBound(array4D, 3) + 1) _

         * (UBound(array4D, 2) - LBound(array4D, 2) + 1) _

         * (UBound(array4D, 1) - LBound(array4D, 1) + 1)

arraysize = arraylen * SizeOf( Long )

Print "Number of elements in array:", arraylen    '2 * 3 * 4 * 5 = 120

Print "Number of bytes used in array:", arraysize '120 * 4 = 480
```

```freebasic
'' determining whether an array is empty

Dim array() As Integer

Print "lbound: "; LBound( array ), "ubound: "; UBound( array )  ''  0 and -1

If LBound( array ) > UBound( array ) Then

    Print "array is empty"

Else

    Print "array is not empty"

End If
```

```freebasic
Sub printArrayDimensions( array() As Integer )

    Print "dimensions: " & UBound( array, 0 )

    '' For each dimension...

    For d As Integer = LBound( array, 0 ) To UBound( array, 0 )

        Print "dimension " & d & ": " & LBound( array, d ) & " to " & UBound( array, d )

    Next

End Sub

Dim array() As Integer

printArrayDimensions( array() )

Print "---"

ReDim array(10 To 11, 20 To 22)

printArrayDimensions( array() )
```

---

**Category:** [Array Functions](Category-Array-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
