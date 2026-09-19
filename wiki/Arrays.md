[Home](Home) › [Compiler Internals](Category-Compiler-Internals) › **Arrays**

# Arrays

An array in fbc is a collection of elements where each element has the same type and is accessed with an index in to the array.

 Example:

```freebasic
'' one dimensional array (1 index)

    Dim a(1 To 10) As Integer

    Print a(1)  '' first element (integer)

    Print a(10) '' last element (integer)

    '' two dimensional array (2 indexes)

    Dim b(1 To 2, 1 To 5) As Integer

    Print b(1,1) '' first element (integer)

    Print b(2,5) '' last element (integer)
```

 ***Array Dimensions and Bounds***

 The number of dimensions refers to the number of indexes that are required to be given to access an element of an array. The number of dimensions may or may not be part of the declaration. If the number of dimensions are known at compile time within the scope that the array is used, fbc can check and error if the wrong number of indexes are specified.

 The bounds of an array are the allowable minimum and maximum index values for each dimension. Accessing an array element with an index or indexes that are outside the array bounds of a dimension is undefined behaviour.

 fbc can check and error if an index or indexes (access) are outside the bounds of the array when compiled with '-exx' or '-earray' compile options. If the array bounds are compile-time constant, and the array access is compile-time constant, fbc can check if an array access is outside the bounds of the array at compile time. Otherwise, the array bounds check must occur at run-time if either the bounds or the access is non-constant.

 ***Fixed dimension versus unknown dimension***

 The number of dimensions may be fixed or unknown. fbc will attempt to determine the number of dimensions an array is expected to have based on declarations for the array. If fbc cannot determine the number of dimensions at compile time, the number of dimensions will become fixed on first redimension of the array at run time.

 Example: fixed 2 dimension, dynamic bounds

```freebasic
Dim a(Any, Any) As Integer

ReDim a(1 To 2, 1 To 5)
```

 Example: Dynamic dimension, dynamic bounds

```freebasic
Dim a() As Integer

'' then only one of on first time use ...

ReDim a(1 To 10)

ReDim a(1 To 2, 1 To 5)

ReDim a(1 To 2, 1 To 5, 1 To 3)
```

 Once number of dimensions are known to fbc, within the scope of the array, fbc will error if any access to the error has wrong number of dimensions. Or if still unknown at compile time, as in the case of an array passed as argument to a procedure and resized, the number of dimensions become fixed at run time.

 ***Fixed bounds versus Dynamic bounds***

 Fixed length arrays have array bounds that are known at compile-time. Dynamic (or variable length) arrays have array bounds that can be altered and resized at run-time, and may be considered unknown at compile time.

 Example: fixed (constant) bounds and constant access

```freebasic
Dim a(1 To 10) As Integer

Print a(11) '' compile time array out-of-bounds
```

 Example: fixed bounds and non-constant access

```freebasic
Dim a(1 To 10) As Integer

Dim i As Integer

Print a(i) '' run time array out-of-bounds
```

 Example: dynamic bounds

```freebasic
Dim a(Any) As Integer '' 1 dimensional, empty

ReDim a(1 To 10)      '' resized to 10 elements

Print a(11) '' run time array out-of-bounds

Print a(i)  '' run time array out-of-bounds
```

 ***Static Array versus Dynamic Array***

 Arrays may have static or dynamic memory allocation. The descriptor may be static or dynamic, and memory space for the data may be static or dynamic. The terms static and dynamic may be overused and so may lose meaning when describing an array. In this context static versus dynamic should not be confused with fixed-length or variable-length. In this context we are referring to how and where the array descriptor and it's associated data are allocated in memory, and to some extent the life time of the variable.

 For an array descriptor to be valid, it must be initialized. An uninitialized array descriptor will almost certainly lead to undefined behaviour at run time.

 The array descriptor itself may be allocated in .bss, .data, on stack or on heap, depending on the declaration of the array. Though typically not in .bss section because an array descriptor usually must be initialized to some non-zero default values to be usable.

 The array's data may be located in .bss section, .data section, on stack or on heap, depending on the declaration of the array. In fbc's current implementation, the array data for variable-length arrays is always allocated on the heap (i.e. malloc()).

 ***Array Descriptor***

 See [Fbarray (Array Descriptor Structure And Access)](Fbarray-Array-Descriptor-Structure-and-Access).

---

**Category:** [Compiler Internals](Category-Compiler-Internals)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
