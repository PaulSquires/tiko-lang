[Home](Home) › [Operators](Category-Operators) › **Operator Strptr (String Pointer)**

# Operator Strptr (String Pointer)

Returns the address of a string's character data.

## Syntax

```freebasic
Declare Operator StrPtr ( ByRef lhs As String ) As ZString Ptr
Declare Operator StrPtr ( ByRef lhs As WString ) As WString Ptr
```

## Parameters

- `lhs`

## Description

This operator returns a `ZString/WString Ptr` that points to the beginning of a string/wstring's character data. `Operator Strptr` is the proper method for acquiring the address of a string's character data.  
 In case of empty [`String`](String) (only for variable length strings), `Operator Strptr` returns a null pointer.

 The related [`Operator Varptr (Variable Pointer)`](Operator-Varptr-Variable-Pointer) and [`Operator @ (Address Of)`](Operator-Address-of), when used with a [`String`](String), return the address of the internal string descriptor.  
 When a variable length string is modified, the address of its descriptor remains always the same, but the the string's character data address (returned by `Operator Strptr`) may change (like any allocated memory that must be reallocated).  
 When a fixed length string is modified, the string's character data address (returned by `Operator Strptr`) is unchanged.

 **Note:** For a variable length string, the operator returns a `ZString Const Ptr` (because returning by reference the string's characters pointer set in the string descriptor, this one is to be considered as read only). If the keyword [`Var`](Var) is used to declare/initialize a user pointer from `Operator Strptr`, this user pointer is also defined as read only (it can not be modified further).

 **Warning:** Dereferencing a zstring pointer to a fixed-length string of STRING\*N type (which has no terminal null character) can lead to an extension of the string by some pollution, or even an outright crash.

## Return Value

Returns a `ZString/WString Ptr` to a string/wstring's character data (null value in case of empty string).

## Remarks

### Usage

`result = StrPtr ( lhs )`

### Differences from QB

- New to FreeBASIC, but does exactly the same thing as [`SAdd`](Sadd)

### See also

- [`SAdd`](Sadd)
- [`VarPtr`](Operator-Varptr-Variable-Pointer)
- [`ProcPtr`](Operator-Procptr-Procedure-Pointer-and-Vtable-Index)

## Examples

```freebasic
'' This example uses Strptr to demonstrate using pointers with strings

Dim myString As String

Dim toMyStringDesc As Any Ptr

Dim toMyString As ZString Ptr

'' Note that using standard VARPTR notation will return a pointer to the

'' descriptor, not the string data itself

myString = "Improper method for Strings"

toMyStringDesc = @myString

Print myString

Print Hex( toMyStringDesc )

Print

'' However, using Strptr returns the proper pointer

myString = "Hello World Examples Are Silly"

toMyString = StrPtr(myString)

Print myString

Print *toMyString

Print

'' And the pointer acts like pointers to other types

myString = "MyString has now changed"

Print myString

Print *toMyString

Print
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
