[Home](Home) › [Standard Data Types](Category-Standard-Data-Types) › **Pointer | Ptr**

# Pointer | Ptr

A variable declaration type modifier

## Syntax

```freebasic
... As DataType {Pointer | Ptr}
```

## Description

Declares a pointer variable.  
 The variable type can be a predefined type or a user-defined type.

 [`Operator @ (Address Of)`](Operator-Address-of) operator or [`VarPtr`](Operator-Varptr-Variable-Pointer) are used to take the address of a variable. The [`Operator * (Value Of)`](Operator-Value-of) operator is used to dereference the pointer, that is, access the actual value stored in the memory location the pointer is pointing at.

## Remarks

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Pointer` or `__Ptr`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Allocate`](Allocate)

## Examples

```freebasic
' Create the pointer.

Dim p As Integer Ptr

' Create an integer value that we will point to using pointer "p"

Dim num As Integer = 98845

' Point p towards the memory address that variable "num" occupies.

p = @num

' Print the value stored in memory pointed to by pointer "p"

Print "Pointer 'p' ="; *p

Print

' Print the actual location in memory that pointer "p" points at.

Print "Pointer 'p' points to memory location:"

Print p
```

```freebasic
Dim p As ZString Pointer

Dim text As String

text = "Hello World!"

p = StrPtr(text) + 6

Print text

Print *p

'' Output:

'' Hello World!

'' World!
```

```freebasic
Type mytype

    a As Integer = 12345

End Type

Dim As mytype mt

Dim As mytype Ptr pmt

pmt = @mt

Print (*pmt).a  '' or Print pmt->a

'' Output:

'' 12345
```

---

**Category:** [Standard Data Types](Category-Standard-Data-Types)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
