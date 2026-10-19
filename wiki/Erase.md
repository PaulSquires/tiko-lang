[Home](Home) › [Array Functions](Category-Array-Functions) › **Erase**

# Erase

Frees a variable-length array's elements, or resets those of a fixed-length array.

## Syntax

```freebasic
Declare Sub Erase ( array As Any [, ... ] )
```

## Parameters

- `array`

## Description

Using `Erase` on a fixed-length array resets all elements without freeing the allocated memory.  
 In case of objects, there is destruction then re-construction.

 Using `Erase` on a variable-length array (array already sized) frees the memory allocated for the array elements, but the array remains declared at its same scope level (with the same datatype and number of dimensions), only the high/low bounds values of each dimension are reset (-1/0).  
 In case of objects, there is destruction before freeing memory.

## Remarks

### Usage

`Erase( array0 [, array1 ... arrayN ] )`

### Differences from QB

- None

### See also

- [`Common`](Common)
- [`Dim`](Dim)
- [`Extern`](Extern)
- [`LBound`](Lbound)
- [`ReDim`](Redim)
- [`Static`](procedures-Static)
- [`UBound`](Ubound)
- [`Var`](Var)

## Examples

```freebasic
Dim MyArray1(1 To 10) As Integer

ReDim MyArray2(1 To 10) As Integer

Erase MyArray1, MyArray2
```

 Example showing the before and after results of single-dimension arrays:

```freebasic
Dim MyArray1(1 To 10) As Integer

ReDim MyArray2(1 To 10) As Integer

Print "MyArray1", LBound( MyArray1 ), UBound( MyArray1 ) ' prints: MyArray1       1             10

Print "MyArray2", LBound( MyArray2 ), UBound( MyArray2 ) ' prints: MyArray2       1             10

Erase MyArray1, MyArray2

Print "MyArray1", LBound( MyArray1 ), UBound( MyArray1 ) ' prints: MyArray1       1             10

Print "MyArray2", LBound( MyArray2 ), UBound( MyArray2 ) ' prints: MyArray2       0            -1
```

Example showing the before and after results of multi-dimension arrays:

```freebasic
Dim MyArray1(1 To 3, 4 To 9) As Integer

ReDim MyArray2(1 To 3, 4 To 9) As Integer

Print , "LOWER", "UPPER"

Print "MyArray1", _

      LBound( MyArray1, 1 ); ", "; LBound( MyArray1, 2 ), _

      UBound( MyArray1, 1 ); ", "; UBound( MyArray1, 2 )

Print "MyArray2", _

      LBound( MyArray2, 1 ); ", "; LBound( MyArray2, 2 ), _

      UBound( MyArray2, 1 ); ", "; UBound( MyArray2, 2 )

Erase MyArray1, MyArray2

Print

Print "MyArray1", _

      LBound( MyArray1, 1 ); ", "; LBound( MyArray1, 2 ), _

      UBound( MyArray1, 1 ); ", "; UBound( MyArray1, 2 )

Print "MyArray2", _

      LBound( MyArray2, 1 ); ", "; LBound( MyArray2, 2 ), _

      UBound( MyArray2, 1 ); ", "; UBound( MyArray2, 2 )
```

 The above example will output:

```freebasic
              LOWER         UPPER
MyArray1       1,  4         3,  9
MyArray2       1,  4         3,  9

MyArray1       1,  4         3,  9
MyArray2       0,  0        -1, -1

```

---

**Category:** [Array Functions](Category-Array-Functions)  
**Kind:** sub

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
