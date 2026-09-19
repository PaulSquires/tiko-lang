[Home](Home) › [Operators](Category-Operators) › **Operator New Expression**

# Operator New Expression

Operator to dynamically allocate memory and construct data of a specified type.

## Parameters

- `datatype`
- `initializers`
- `count`

## Description

The `New Expression` operator dynamically allocates memory and constructs a specified data type.

 For simple types, like integers, an initial value can be given. For types without constructors, initial values can be specified for each field (either with default initializer at data-field declaration, or with initializer list as in `New datatype (initializers, ..)` if all type data-fields are numeric primitives only and without any default initializers). For types with at least one constructor, the initialize list (if any) must match an existing constructor. If no initializers are given, the default values for those types will be set.

 `New[] Expression` operator is the (one-dimensional) array-version of the `New Expression` operator and allocates enough memory for the specified number of objects. The default constructor for the type will be used to set the initial values for each item.

 Objects created with `New Expression` operator must be freed with [`Delete Statement`](Operator-Delete-Statement) operator. Object array created with `New[] Expression` operator must be freed with `Delete[] Statement` operator, the array-version of [`Delete Statement`](Operator-Delete-Statement) operator. You cannot mix and match the different versions of the operators.

 Specifying an initial value of [`Any`](Any), as in `New datatype (Any)` will allocate memory for the type, but not initialize the data. This is only valid on data types that do not have constructors (otherwise for data types with constructors, syntax of simple memory allocation with pointer conversion, like *Cptr(datatype Ptr, Allocate(Sizeof(datatype)))*, can be substituted to the invalid use of New...Any).

 Specifying an initial value of [`Any`](Any), as in `New datatype[count] {Any}` will allocate memory for the array, but not initialize the data. This is only valid on data types that do not have constructors (otherwise for data types with constructors, syntax of simple memory allocation with pointer conversion, like *Cptr(datatype Ptr, Allocate(count \* Sizeof(datatype)))*, can be substituted to the invalid use of New...Any).

 The total memory, in bytes, to be allocated with `New datatype[count]` expression is calculated as `sizeof(datatype) * count`, plus `sizeof(uinteger)` if there is an implicit or explicit [`Destructor`](Destructor). The total memory requested in bytes to be allocated must not overflow the value that can be held by a [`UInteger`](Uinteger). The extra `uinteger`, if allocated, stores the number of elements as part of the allocation, so that [`Delete Statement`](Operator-Delete-Statement) can determine the count of destructors to call.

 If the memory allocation fails, a null pointer is returned and no constructors are called.

 The dynamic memory allocation process part provided by the `New Expression` operator can be overloaded for user-defined types as a member operator [`New Overload`](Operator-New-Overload). The following process part for data construction can never be modified.

 **Note:** Using `pointer = New datatype[count]` may be unsafe if `pointer` was declared with a type different from `datatype` (for sub-type polymorphism purpose for example), because the pointer arithmetic fails to access the elements if the pointer type size is different from the size of `datatype` (when using [`Operator [] (Pointer Index)`](Operator-Pointer-Index) or adding an offset (element number) to the pointer, or even when `Delete[] Statement` itself (the array-version of [`Delete Statement`](Operator-Delete-Statement)) must destroy the elements).

## Return Value

A pointer of type [datatype](Data-Types) to the newly allocated data, or null pointer if the memory allocation failed.

## Remarks

### Usage

```freebasic
result = New datatype

or

result = New datatype ( initializers, ... )

or

result = New datatype[ count ]
```

### Dialect Differences

- Only available in the *[-lang fb](Compiler-Option-Lang)* dialect.

### Differences from QB

- New to FreeBASIC

### See also

- [`Delete Statement`](Operator-Delete-Statement)
- [`Placement New`](Operator-Placement-New)
- [`New Overload`](Operator-New-Overload)

## Examples

```freebasic
Type Rational

    As Integer numerator, denominator

End Type

' Create and initialize a "rational" and store its address.

Dim p As Rational Ptr = New Rational(3, 4)

' Test if null return pointer

If (p = 0) Then

    Print "Error: unable to allocate memory"

Else

    Print p->numerator & "/" & p->denominator

    ' Destroy the rational and give its memory back to the system.

    Delete p

End If

Sleep
```

```freebasic
' Allocate memory for 100 integers and store the address of the first one.

Dim p As Integer Ptr = New Integer[100]

' Test if null return pointer

If (p = 0) Then

    Print "Error: unable to allocate memory"

Else

    ' Assign some values to the integers in the array.

    For i As Integer = 0 To 99

        p[i] = i

    Next

    ' Free the entire integer array.

    Delete[] p

End If

Print "Done."

Sleep
```

```freebasic
'' Example of nested New [] to get a 2-dimentional object array (4*3)

Type UDT

    Dim As Integer N

    Declare Constructor ()

    Declare Destructor ()

End Type

Constructor UDT ()

    Print "Constructor",

End Constructor

Destructor UDT ()

    Print "Destructor",

End Destructor

Dim As UDT Ptr Ptr p = New UDT Ptr [4]  '' New [] allocation for the first dimension:

                                        ''   no internal allocation of extra uinteger because

                                        ''   allocation of array of pointers (to UDT objects with destructor)

For I As Integer = 0 To 3

    p[I] = New UDT [5]                  '' New [] allocations for the last dimension:

                                        ''   internal allocation of an extra uinteger for each New [],

                                        ''   because allocation of an array of UDT objects with destructor

    Print

Next I

For I As Integer = 0 To 3

    For J As Integer = 0 To 4

        p[I][J].N = I * 10 + J  '' assignment of each object array element

    Next J

Next I

Print

For I As Integer = 0 To 3

    For J As Integer = 0 To 4

        Print p[I][J].N,        '' display of each object array element

    Next J

    Print

Next I

Print

For I As Integer = 0 To 3

    Delete [] p[I]  '' Delete [] deallocations for the last dimension

    Print

Next I

Delete [] p         '' Delete [] deallocation for the first dimension)

Print

Sleep
```

Output example:

```freebasic
Constructor   Constructor   Constructor   Constructor   Constructor
Constructor   Constructor   Constructor   Constructor   Constructor
Constructor   Constructor   Constructor   Constructor   Constructor
Constructor   Constructor   Constructor   Constructor   Constructor

 0             1             2             3             4
 10            11            12            13            14
 20            21            22            23            24
 30            31            32            33            34

Destructor    Destructor    Destructor    Destructor    Destructor
Destructor    Destructor    Destructor    Destructor    Destructor
Destructor    Destructor    Destructor    Destructor    Destructor
Destructor    Destructor    Destructor    Destructor    Destructor
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
