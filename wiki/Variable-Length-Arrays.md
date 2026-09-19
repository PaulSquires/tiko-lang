[Home](Home) › [Tutorials](Category-Tutorials) › **Variable-length Arrays**

# Variable-length Arrays

Resizable homogeneous data structures. Also known as "dynamic arrays".

Overview

Variable-length arrays are [arrays](programmer-s-guide-Arrays) that can, during program execution, either be resized to hold more or less elements, or have their dimension\[s\] use a different subscript range. The memory used by a variable-length array to store its elements is allocated at runtime in the heap, as opposed to fixed-length arrays whose data is either allocated on the program stack or in the `.BSS` or `.DATA` sections of the executable, depending on whether they were defined with [`Static`](procedures-Static) (or [`Shared`](Shared)).

 Variable-length arrays may also be used as data members inside [user-defined types](User-Defined-Types). As opposed to fixed-length arrays though, the array is not allocated as part of the user-defined type structure, because user-defined types cannot be variable-length. Instead, the user-defined type only contains the array descriptor that is used to hold and access the variable-length array behind the scenes, and the array is still allocated on the heap, as with variable-length array variables.

 Variable-length arrays are often called "dynamic arrays" because their size can change dynamically at runtime, instead of being fixed-size.

Declaration

A variable-length array is declared with either the [`Dim`](Dim) or [`ReDim`](Redim) keywords, followed by a variable identifier, a parenthesized list of boundaries and an element [data type](Standard-Data-Types). For an array to be declared variable-length, it must be declared with unknown boundaries, or with variable (non-constant) boundaries. [`ReDim`](Redim) always defines variable-length arrays, whether the specified boundaries are constant or not.

```freebasic
'' Declares a one-dimensional variable-length array of integers, with initially 2 elements (0 and 1)

ReDim a(0 To 1) As Integer

'' Declares a 1-dimensional variable-length array without initial bounds.

'' It must be resized using Redim before it can be used for the first time.

Dim b(Any) As Integer

'' Same, but 2-dimensional

Dim c(Any, Any) As Integer

Dim myLowerBound As Integer = -5

Dim myUpperBound As Integer = 10

'' Declares a 1-dimensional variable-length array by specifying variable (non-constant) boundaries.

'' The array will have myUpperBound - myLowerBound + 1 elements.

Dim d(myLowerBound To myUpperBound) As Integer

'' Declares a variable-length array whose amount of dimensions will be determined

'' by the first Redim or array access found. The array has no initial bounds and must

'' be resized using Redim before it can be used for the first time.

Dim e() As Integer
```

Resizing

Resizing a variable-length array refers to "redefining" the array with different boundaries, allowing the array to grow or shrink. Elements outside the new subscript range\[s\] are erased; object elements will be destroyed. If the array is resized to a larger size, new elements are added initialized with a zero or *null* value; object elements are default-constructed. Variable-length arrays are resized using the [`ReDim`](Redim) keyword following the same form as definition. In this case the element data type may be omitted from the [`ReDim`](Redim) statement.

```freebasic
'' Define an empty 1-dimensional variable-length array of SINGLE elements...

Dim array(Any) As Single

'' Resize the array to hold 10 SINGLE elements...

ReDim array(0 To 9) As Single

'' The data type may be omitted when resizing:

ReDim array(10 To 19)
```

 Resizing an array cannot change its amount of dimensions, but only the boundaries of each dimension.

 By default, element values of a variable-length array are lost when resized. To retain the previous element values during a resize, use the [`Preserve`](Preserve) keyword.

See also

- [Fixed-length Arrays](Fixed-Length-Arrays)
- [Passing Arguments to Procedures](Passing-Arguments-to-Procedures)
- [Passing Arrays to Procedures](Passing-Arrays-to-Procedures)
- [... (Ellipsis)](Ellipsis)

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
