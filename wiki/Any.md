[Home](Home) › [Procedures](Category-Procedures) › **Any**

# Any

The Any keyword is used as a placeholder for a type or value in various ways.

## Syntax

```freebasic
Dim identifier As Any Pointer|Ptr
Declare Sub|Function identifier ( ByRef identifier As Any [ , ... ] )
Dim identifier(Any [, Any...]) As DataType
[ Declare ] { Sub | Function } proc_name ( param(Any [, Any...]) As DataType )
Dim identifier As DataType = Any
New DataType ( Any )
New(Address) DataType [count] { Any }
InStr|InStrRev ( identifier, Any substring )
```

## Description

- Pointers (1st syntax):

A special pointer type called the `Any Ptr` (or "`Any Pointer`") allows pointing to any variable type. If you cast it to a `DataType Ptr`, it can be indexed or dereferenced to access the memory as an instance of `DataType`. Pointer arithmetic is allowed on an `Any Ptr`, and treats it like a `Byte Ptr`: The pointer is changed by increments of `1`.

 A pure `Any Ptr` has no type checking by the compiler. It can be implicitly converted to and from other pointer types through assignment or parameter passing.

 `Any` on its own is not a valid data type for a variable. Also, it is illegal to dereference an `Any Ptr` (although an `Any Ptr Ptr` may be dereferenced to produce a `Any Ptr`).

 This should not be confused with `Variant`, a Visual Basic data type which can contain any type of variable. FreeBASIC does not provide native support for a `Variant` type.

- Byref parameters (2nd syntax):

**`Any`** can be used in procedure prototypes (in a [`Declare`](Declare) statement) with [`ByRef`](Byref-Parameters) parameters to disable the compiler checking for the correct type of the variable passed (this includes the array parameters because always implicitly passed by reference).
 Obviously, this does not work with overload procedures, and therefore neither with UDT member procedures.  
 This use of `Any` exists for compatibility with QB, but can be superseded by procedure overloading.

- Array dimensions (3rd/4th syntax):

In array declarations, **`Any`** can be specified in place of the array bounds in order to create a dynamic array with a certain amount of dimensions that is determined based on the number of **`Any`**s specified (use the syntax with **`Any`** is mandatory when declaring a dynamic array member inside a [`Type`](Type-Udt)).

 In parameter declarations, **`Any`** can be also specified instead of empty parenthesis in order to fix the amount of dimensions.

- Initialization (5th/6th/7th syntax):

`Any` can be used as a fake initializer to disable the default initialization of variables to `0`, leaving the variable uninitialized. This may save time in critical sections of a program. It is the program's responsibility to fill the variables with meaningful data before reading it.

 For a UDT, the member data fields are also not initialized, and the default constructors, if they exist, are not called.

 Comparison to C/C++: This matches the behavior of a variable declaration without initialization value in C/C++.

 `Any` is not allowed when the `DataType` is a var-len [`String`](String), because there is no string character data, and not initializing the descriptor would be an aberration.

 For a var-len array, **`Any`** is used only once at the declaration level, not at each resize level with [`ReDim`](Redim) ([`Erase`](Erase) does not reset this initialization state).

 Similar to **`Any`** initializers for variables, **`Any`** can also be used with the [`New Expression`](Operator-New-Expression) or [`Placement New`](Operator-Placement-New) operators in order to leave the newly created object uninitialized (only allowed with data types that do not have a constructor, also excluding the var-len string type).

- Instr/InstrRev (8th syntax):

**`Any`** can be used with [`InStr`](Instr) or [`InStrRev`](Instrrev) as a qualifier for the `substring` parameter, to indicate that any individual character in it may be matched.

- Procptr (9th syntax):

**`Any`**, ie any procedure signature, does not induce any particular selection (compared to its non-use), but just allows for writing [`ProcPtr`](Operator-Procptr-Procedure-Pointer-and-Vtable-Index) always with 2 arguments.

## Remarks

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect.

### Differences from QB

- Pointers and initializers are new to FreeBASIC.

### See also

- [`Dim`](Dim)
- [`Declare`](Declare)

## Examples

```freebasic
Declare Sub echo(ByVal x As Any Ptr) '' echo will accept any pointer type

Dim As Integer a(0 To 9) = Any '' this variable is not initialized

Dim As Double  d(0 To 4)

Dim p As Any Ptr

Dim pa As Integer Ptr = @a(0)

Print "Not initialized ";

echo pa       '' pass to echo a pointer to integer

Dim pd As Double Ptr = @d(0)

Print "Initialized ";

echo pd       '' pass to echo a pointer to double

p = pa     '' assign to p a pointer to integer

p = pd     '' assign to p a pointer to double

Sleep

Sub echo (ByVal x As Any Ptr)

    Dim As Integer i

    For i = 0 To 39

        'echo interprets the data in the pointer as bytes

        Print Cast(UByte Ptr, x)[i] & " ";

    Next

    Print

End Sub
```

```freebasic
'Example of ANY disabling the variable type checking

Declare Sub echo (ByRef a As Any) '' ANY disables the checking for the type of data passed to the function

Dim x As Single

x = -15

echo x                  '' Passing a single to a function that expects an integer. The compiler does not complain!!

Sleep

Sub echo (ByRef a As Integer)

  Print Hex(a)

End Sub
```

```freebasic
Dim a(Any) As Integer ' 1-dimensional dynamic array

Dim b(Any, Any) As Integer ' 2-dimensional dynamic array

Dim c(Any, Any, Any) As Integer ' 3-dimensional dynamic array

' etc.

' Further Redims or array accesses must have a matching amount of dimensions

ReDim a(0 To 1)

ReDim b(1 To 10, 2 To 5)

ReDim c(0 To 9, 0 To 5, 0 To 1)
```

---

**Category:** [Procedures](Category-Procedures)  
**Kind:** sub

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
