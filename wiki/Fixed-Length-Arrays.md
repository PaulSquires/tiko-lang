[Home](Home) › [Tutorials](Category-Tutorials) › **Fixed-length Arrays**

# Fixed-length Arrays

Fixed-size homogeneous data structures.

Overview

Fixed-length arrays are [arrays](programmer-s-guide-Arrays) that have a fixed constant size throughout the execution of a program. The memory used by a fixed-length array to store its elements is allocated at compile-time, either on the stack or in the `.BSS` or `.DATA` sections of the executable, depending on whether [`Static`](procedures-Static) (or [`Shared`](Shared)) was used to define it. This may allow for quicker program execution since the memory for the array is already allocated, unlike [variable-length arrays](Variable-Length-Arrays), whose element memory isn't allocated until runtime.

 Fixed-length arrays with *[automatic storage](Storage-Classes)*, have their elements allocated on the program stack, and pointers to these elements remain valid only while the array is in scope. The elements of fixed-length arrays with *[static storage](Storage-Classes)* are allocated in the `.DATA` or `.BSS` sections of the executable, depending on whether or not they are initialized when defined, so pointers to these elements remain valid for the entire execution of the program. Fixed-length arrays of any storage class cannot be resized during program execution, only [variable-length arrays](Variable-Length-Arrays) can.

 Fixed-length arrays may also be used as data members inside [user-defined types](User-Defined-Types), in which case the array is directly allocated as part of the user-defined type structure.

Declaration

A fixed-length array is declared with either the [`Dim`](Dim) or [`Static`](procedures-Static) keywords, followed by a variable identifier, a parenthesized list of boundaries and an element [data type](Standard-Data-Types).

```freebasic
'' Defines a one-dimensional fixed-length array of type INTEGER having automatic storage.

Dim arrayOfIntegers(69) As Integer

'' Defines a one-dimensional fixed-length array of type SHORT having static storage.

Static arrayOfShorts(420) As Short
```

There are various ways to specify an array's amount of elements. Each array can have between 1 or 8 dimensions. Each dimension has a lower bound and an upper bound.

```freebasic
Dim a(1) As Integer  '' 1-dimensional, 2 elements (0 and 1)

Dim b(0 To 1) As Integer  '' 1-dimensional, 2 elements (0 and 1)

Dim c(5 To 10) As Integer  '' 1-dimensional, 6 elements (5, 6, 7, 8, 9 and 10)

Dim d(1 To 2, 1 To 2) As Integer  '' 2-dimensional, 4 elements: (1,1), (1,2), (2,1), (2,2)

Dim e(9, 9, 9, 9) As Integer '' 4-dimensional, 10 * 10 * 10 * 10 elements
```

For an array to be declared fixed-length, the boundaries must be specified using only number literals or [`Const`](Const) values or [`Enum`](Enum) constants.

```freebasic
Const myLowerBound = -5

Const myUpperBound = 10

'' Declares a one-dimensional fixed-length array, holding myUpperBound - myLowerBound + 1 String objects.

Dim arrayOfStrings(myLowerBound To myUpperBound) As String

'' Declares a one-dimensional fixed-length array of bytes,

'' big enough to hold an INTEGER.

Dim arrayOfBytes(0 To SizeOf(Integer) - 1) As Byte
```

Declaration with initializer

The fixed-length arrays may be given values at the time of their declaration by following the array declaration with an initializer (variable-length arrays declarations can't use initializers).  
 These initializing array values are given in comma-delimited values enclosed by curly brackets. These methods of initializing array values can be nested within one another for complex assignments, allowing for arrays of any dimension to be initialized.

```freebasic
'' Declare an array of 2 by 5 elements followed by an initializer

Dim array(1 To 2, 1 To 5) As Integer => {{1, 2, 3, 4, 5}, {1, 2, 3, 4, 5}}
```

Any upper bound can be an ellipsis `"..."` (3 dots). This will cause to upper bound to be set automatically based on the number of elements found in the initializer. When ellipsis is used in this manner, an initializer must be used.

```freebasic
'' Declare (with one ellipsis) an array of 2 by 5 elements followed by an initializer

Dim array(1 To 2, 1 To ...) As Integer => {{1, 2, 3, 4, 5}, {1, 2, 3, 4, 5}}
```

```freebasic
'' Declare (with two ellipsis) an array of 2 by 5 elements followed by an initializer

Dim array(1 To ..., 1 To ...) As Integer => {{1, 2, 3, 4, 5}, {1, 2, 3, 4, 5}}
```

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
