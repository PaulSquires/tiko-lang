[Home](Home) › [Array Functions](Category-Array-Functions) › **ReDim**

# ReDim

Creates or resizes a variable-length array; elements are reset unless Preserve is used.

## Syntax

```freebasic
Declaring a Dynamic Array:
ReDim [ Shared ] symbolname([subscript [, ...]]) As datatype [, ...]
ReDim [ Shared ] As datatype symbolname([subscript [, ...]]) [, ...]
Resizing a Dynamic Array:
ReDim [ Preserve ] symbolname([subscript [, ...]]) [, ...]
or:
ReDim [ Preserve ] [ ( ] expression [ ) ] ([subscript [, ...]]) [, ...]
```

## Parameters

- `symbolname`
- `expression`
- `(expression)`
- `subscript`
- `lowerbound To ] upperbound`

## Description

`ReDim` can be used to define new variable-length arrays, or resize existing variable-length arrays while keeping the same number of dimensions. `ReDim` always produces variable-length arrays, so, unlike [`Dim`](Dim), variable-length arrays can be defined with constant subscripts.

 When defining a new variable-length array, its elements are default constructed. For simple data types like [`Integer`](Integer) or [`Double`](Double), the elements are initialized to zero (`0`). For user-defined types with a default constructor, that will be called.

 When used with in a user-defined type, `ReDim` creates variable-length arrays while being able to pre-size them with constant subscripts.

 **NOTES**:

## Remarks

### Differences from QB

- [`Preserve`](Preserve) was in Visual Basic, but not in QBASIC.
- Multi-dimensional arrays in FreeBASIC are in row-major order, rather than column-major order.

### See also

- [`Common`](Common)
- [`Dim`](Dim)
- [`Erase`](Erase)
- [`Extern`](Extern)
- [`LBound`](Lbound)
- [`Preserve`](Preserve)
- [`Shared`](Shared)
- [`Static`](procedures-Static)
- [`UBound`](Ubound)
- [`Var`](Var)

## Examples

```freebasic
'' Define a variable-length array with 5 elements

ReDim array(0 To 4) As Integer

For index As Integer = LBound(array) To UBound(array)

    array(index) = index

Next

'' Resize a variable-length array with 10 elements

'' (the lower bound should be kept the same)

ReDim Preserve array(0 To 9)

Print "index", "value"

For index As Integer = LBound(array) To UBound(array)

    Print index, array(index)

Next
```

 This program will produce the following output:

```freebasic
index         value
 0             0
 1             1
 2             2
 3             3
 4             4
 5             0
 6             0
 7             0
 8             0
 9             0
```

```freebasic
'' Define a variable-length array

Dim array() As Integer

'' ReDim array to have 3*4 elements

ReDim array(1 To 3, 1 To 4)

Dim As Integer n = 1, i, j

Print "3 * 4:"

Print

For i = LBound(array, 1) To UBound(array, 1)

    For j = LBound(array, 2) To UBound(array, 2)

        array(i, j) = n

        Print Using "##  "; array(i, j);

        n += 1

    Next

    Print

Next

Print

'' ReDim Preserve array to have 4*4 elements, preserving the contents

'' (only the first upper bound should be changed)

ReDim Preserve array(1 To 4, 1 To 4)

Print "4 * 4:"

Print

For i = LBound(array, 1) To UBound(array, 1)

    For j = LBound(array, 2) To UBound(array, 2)

        Print Using "##  "; array(i, j);

    Next

    Print

Next

Print

'' ReDim Preserve array to have 2*4 elements, preserving but trancating the contents

'' (only the first upper bound should be changed)

ReDim Preserve array(1 To 2, 1 To 4)

Print "2 * 4:"

Print

For i = LBound(array, 1) To UBound(array, 1)

    For j = LBound(array, 2) To UBound(array, 2)

        Print Using "##  "; array(i, j);

    Next

    Print

Next

Print
```

 This program will produce the following output:

```freebasic
3 * 4:

 1   2   3   4
 5   6   7   8
 9  10  11  12

4 * 4:

 1   2   3   4
 5   6   7   8
 9  10  11  12
 0   0   0   0

2 * 4:

 1   2   3   4
 5   6   7   8
```

```freebasic
'' Define a variable-length array as UDT field

Type UDT

   Dim As Integer array(Any)

End Type

Dim As UDT u(0 To 3)

'' For use of Redim with a complex array expression

'' (especially if the array expression itself contains parentheses),

'' the array expression must be enclosed in parentheses

'' in order to solve the parsing ambiguity:

''    Redim u(0).array(0 To 9)

''    induces error 4: Duplicated definition, u in 'Redim u(0).array(0 To 9)'

ReDim (u(0).array)(0 To 9)
```

---

**Category:** [Array Functions](Category-Array-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
