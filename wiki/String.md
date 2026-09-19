[Home](Home) › [Operators](Category-Operators) › **String**

# String

Standard data type: 8 bit character string

## Syntax

```freebasic
Dim variable As String [ * size]
```

## Description

A `String` is an array of characters.

 A `String` declared without the `size` parameter is dynamically resized depending on the length of the string. The length can range from 0 bytes to 2 gigabytes. A descriptor contains a pointer to the actual string, the length of the string, and the amount of space allocated for it. [`VarPtr`](Operator-Varptr-Variable-Pointer) will return a pointer to the descriptor, while [`StrPtr`](Operator-Strptr-String-Pointer) will point to the actual string.

 Because of the hidden descriptor with a `String`, manual allocation of space, for example using the memory allocation function [`CAllocate`](Callocate) (preferentially), for a `String` is not encouraged. The common way to ensure a certain amount of space is reserved for a `String`, to prevent unnecessary allocations inside a loop for instance, is to use the [`Space`](Space) or [`String`](String-Function) functions.

 Nevertheless if necessary, dynamic allocation may be carefully used by means of the memory allocation functions [`Allocate`](Allocate), [`CAllocate`](Callocate), [`Reallocate`](Reallocate) (see precautions for use) and string pointer (which is a pointer to a string descriptor, not string data). When memory is allocated to hold string descriptors, the string must always be destroyed (setting to `"``"`) before deallocate each string descriptor (allowing to deallocate the memory taken up by the string data), otherwise, it is not possible to deallocate it later, and it may induce memory leak in the program continuation.

 A simpler and safer method for dynamic allocation /deallocation is to use the advanced [`New`](Operator-New-Expression) / [`Delete`](Operator-Delete-Statement) keyword (which itself also calls the constructor / destructor of the string object).

 Despite the use of the descriptor, an implicit `NULL` character (`Chr(0)`) is added to the end of the string, to allow passing them to functions in external libraries without making slow copies. FreeBASIC's internal functions will ignore this character, and not treat it as part of the string.

 A `String` declared with a `fixed size` (numeric constant, or expression that can be evaluated at compile time) is a QB-style fixed length string, with the exception that unused characters are set to 0 before fbc version 1.20.0, or set to space since fbc version 1.20.0, regardless of what "-lang" compiler option is used. It has no descriptor and it is not resized to fit its contents. As in QB, if data overflows the size of the string, it is truncated on the right side.  
 Only before fbc version 1.20.0, fixed length strings were also terminated with a `NULL` character, and so they used `size + 1` bytes of space. This `NULL` terminator is removed since fbc version 1.20.0, to prevent the redundant character complicating data layout in user-defined [`Type`](Type-Udt)s.
 **Note:** Before fbc version 1.20.0, it was not recommended to use explicit `NULL` character (`Chr(0)`) in a string expression involving a fixed length string variable because this could lead to different unexpected results depending on usage context (initialization, assignment, concatenation, ...).
 **Note**: Since fbc version 1.20.0, dereferencing a pointer to a fixed length string can lead to an extension of the string by some pollution, or even to an outright crash (because there is no longer `NULL` terminal character).

 String variable names need not end in a dollar sign `$` as in other dialects of BASIC. In *[lang fb](Freebasic-Dialects)* variable suffixes, including the dollar sign, are disallowed entirely.

## Remarks

### Version

- Before fbc 1.20.0, fixed length strings were terminated with a NULL character, and so they used size + 1 bytes of space.

### Differences from QB

- In QB the strings were limited to 32767 characters.
  In QB, the unused characters of a fixed-length string were initialized with 32 (space, or " ", in ASCII).  
  In QB static or fixed-size strings were often used in records to represent a number of bytes of data; for example, a string of 1 length to represent 1 byte in a UDT read from a file. This was not possible in FreeBASIC before fbc version 1.20.0 since strings always had an `NULL` character following (when converting before fbc version 1.20.0 QBasic code that reads UDTs from files, make sure all instances of "`As String * n`" are replaced with "`As uByte (0 to n - 1)`" or your files will be incompatible).

### See also

- [`String (Function)`](String-Function)
- [`Space`](Space)
- [`ZString`](Zstring)
- [`WString`](Wstring)
- [`Str`](Str)
- [`StrPtr`](Operator-Strptr-String-Pointer)
- [`VarPtr`](Operator-Varptr-Variable-Pointer)
- [`Standard Data Type Limits`](Standard-Data-Type-Limits)
- [`Operator [] (String Index)`](Operator-String-Index)
- [`String Operators`](String-Operators)

## Examples

```freebasic
'' Variable length

Dim a As String

a = "Hello"

Print a

a += ", world!"

Print a

Dim As String b = "Welcome to FreeBASIC"

Print b + "! " + a
```

```freebasic
'' QB-like $ suffixes

#lang "qb"

'' DIM based on $ suffix

Dim a$

a$ = "Hello"

'' Implicit declaration based on $ suffix

b$ = ", world!"

Print a$ + b$
```

```freebasic
'' Variable-length strings as buffers

'' Reserving space for a string,

'' using Space() to produce lots of space characters (ASCII 32)

Dim As String mybigstring = Space(1024)

Print "buffer address: &h" & Hex( StrPtr( mybigstring ), 8 ) & ", length: " & Len( mybigstring )

'' Explicitly destroying a string

mybigstring = ""

Print "buffer address: &h" & Hex( StrPtr( mybigstring ), 8 ) & ", length: " & Len( mybigstring )
```

```freebasic
'' Variable-length string as Const parameter

'' Const qualifier preventing string from being modified

Sub silly_print( ByRef printme As Const String )

    Print ".o0( " & printme & " )0o."

    'next line will cause error if uncommented

    'printme = "silly printed"

End Sub

Dim As String status = "OK"

silly_print( "Hello FreeBASIC!" )

silly_print( "Status: " + status )
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
