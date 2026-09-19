[Home](Home) › [Tutorials](Category-Tutorials) › **Numeric Types**

# Numeric Types

Of all built-in data-types, **Numeric Types** are those dedicated to the representation of all kinds of numbers.

 FreeBASIC supplies several numeric data types for handling numbers in various representations.  
 Of these, integer types represent only integer numbers (positive, negative, and zero), and floating-point types represent real numbers.

Integer types

Integer types are those that represent only integer numbers:

**-** `Byte 8-bit`
 **-** `Short 16-bit`
 **-** `Long 32-bit`
 **-** `Integer 32-bit or 64-bit (*)`
 **-** `LongInt 64-bit`
 **-** `Integer<8|16|32|64> 8|16|32|64-bit`

**-** `UByte 8-bit`
 **-** `UShort 16-bit`
 **-** `ULong 32-bit`
 **-** `UInteger 32-bit or 64-bit (*)`
 **-** `ULongInt 64-bit`
 **-** `Uinteger<8|16|32|64> 8|16|32|64-bit`

Floating-point types

Floating-point types are those that represent real numbers:

**-** `Single 32-bit`

**-** `Double 64-bits`

Pseudo-integer types

Other types that also represent but indirectly integer numbers:

**-** `Enum (32-bit or 64-bit) (*)`

**-** `Boolean (1-bit useful in 8-bit)`

Pointer types

Pointers are types whose values `(uinteger)` are addresses in memory (they are said to 'point' to this memory).  
 The type of data that is pointed to depends on the type of pointer (an Integer Pointer points to Integer data).  
 Pointers are declared like any other variable, with the suffix `pointer` or `ptr` following the type name:

**-** `{DataType|Any} {Pointer|Ptr} (32-bit or 64-bit) (*)`

`(*)` `INTEGER`, `UINTEGER`, and `ENUM` data types vary with platform, matching the size of `POINTER`.

Example

Size (in bits) of all types above:

```freebasic
Print Using "A  BYTE     is ##"; SizeOf(Byte)     * 8; : Print "-bit"

Print Using "A  SHORT    is ##"; SizeOf(Short)    * 8; : Print "-bit"

Print Using "A  LONG     is ##"; SizeOf(Long)     * 8; : Print "-bit"

Print Using "An INTEGER  is ##"; SizeOf(Integer)  * 8; : Print "-bit"

Print Using "A  LONGINT  is ##"; SizeOf(LongInt)  * 8; : Print "-bit"

Print Using "An UBYTE    is ##"; SizeOf(UByte)    * 8; : Print "-bit"

Print Using "An USHORT   is ##"; SizeOf(UShort)   * 8; : Print "-bit"

Print Using "An ULONG    is ##"; SizeOf(ULong)    * 8; : Print "-bit"

Print Using "An UINTEGER is ##"; SizeOf(UInteger) * 8; : Print "-bit"

Print Using "An ULONGINT is ##"; SizeOf(ULongInt) * 8; : Print "-bit"

Print

Print Using "A  SINGLE   is ##"; SizeOf(Single)   * 8; : Print "-bit"

Print Using "A  DOUBLE   is ##"; SizeOf(Double)   * 8; : Print "-bit"

Print

Enum myENUM : option1 = 1 : option2 : End Enum

Print Using "An ENUM     is ##"; SizeOf(myENUM)   * 8; : Print "-bit"

Print

Print Using "A  BOOLEAN  is ##"; SizeOf(Boolean)  * 8; : Print "-bit"

Print

Print Using "A  POINTER  is ##"; SizeOf(Any Ptr)  * 8; : Print "-bit"

Sleep
```

 Output example for win64:

```freebasic
A  BYTE     is  8-bit
A  SHORT    is 16-bit
A  LONG     is 32-bit
An INTEGER  is 64-bit
A  LONGINT  is 64-bit
An UBYTE    is  8-bit
An USHORT   is 16-bit
An ULONG    is 32-bit
An UINTEGER is 64-bit
An ULONGINT is 64-bit

A  SINGLE   is 32-bit
A  DOUBLE   is 64-bit

An ENUM     is 64-bit

A  BOOLEAN  is  8-bit

A  POINTER  is 64-bit

```

See also

- [`Standard Data Types`](Standard-Data-Types)
- [`Standard Data Type Limits`](Standard-Data-Type-Limits)
- [Coercion and Conversion](Coercion-and-Conversion)

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
