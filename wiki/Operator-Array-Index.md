[Home](Home) › [Operators](Category-Operators) › **Operator () (Array Index)**

# Operator () (Array Index)

Returns a reference to an element in an array

## Syntax

```freebasic
Declare Operator () ( lhs() As T, ByRef rhs As Integer, ... ) ByRef As T
```

## Parameters

- `lhs`
- `rhs`
- `T`

## Description

This operator returns a reference to an element in an array. For multidimensional arrays, multiple indexes must be specified (up to the total number of dimensions of the array).

 For any dimension `d` in array `a`, any index less than `LBound(a, d)` or greater than `UBound(a, d)` will result in a runtime error.

## Remarks

### Usage

```freebasic
result = lhs ( rhs [, ...] )

or

lhs ( rhs [, ...] ) = value
```

### Differences from QB

- None

### See also

- [`Operator [] (Pointer Index)`](Operator-Pointer-Index)

## Examples

```freebasic
Dim array(0 To 4) As Integer = { 0, 1, 2, 3, 4 }

For index As Integer = 0 To 4

    Print array(index);

Next

Print
```

 will produce the output:

```freebasic
 0 1 2 3 4
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
