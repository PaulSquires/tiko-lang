[Home](Home) › [Standard Data Types](Category-Standard-Data-Types) › **Integer**

# Integer

Standard data type: 32-bit or 64-bit signed, same size as SizeOf(Any Ptr)

## Syntax

```freebasic
Dim variable As Integer
Dim variable As Integer<bits>
```

## Parameters

- `bits`

## Description

**Integer** is the main data type FreeBASIC uses for integer math and bitwise operations. It is the default type for number literals.

 In the first form Integer is a 32-bit or 64-bit signed whole-number data type, depending on the target platform.

 If an explicit bit size is given (the second form), a data type is provided that can hold values from `-1LL Shl (bits-1)` up to `(1LL Shl (bits-1)) - 1`. The selected data type is [`Byte`](Byte) for **Integer<8>**, [`Short`](Short) for **Integer<16>**, [`Long`](Long) for **Integer<32>** and [`LongInt`](Longint) for **Integer<64>**.

## Remarks

### Dialect Differences

- In the *[-lang fb](Compiler-Option-Lang)* and *[-lang fblite](Compiler-Option-Lang)* dialects, the `Integer` data type is 32-bit or 64-bit depending on target platform
  In the *[-lang qb](Compiler-Option-Lang)* dialect, the `Integer` data type is 16-bit, regardless of platform.

### Differences from QB

- The ability to select a bit size is new to FreeBASIC
- The INTEGER type is always 16 bits wide in QB.

### See also

- [`Long`](Long)
- [`LongInt`](Longint)
- [`UInteger`](Uinteger)
- [`CInt`](Cint)
- [`Table with variable types overview, limits and suffixes`](Standard-Data-Type-Limits)

## Examples

```freebasic
#ifdef __FB_64BIT__

    Dim x As Integer = &H8000000000000000

    Dim y As Integer = &H7FFFFFFFFFFFFFFF

    Print "Integer Range = "; x; " to "; y

#else

    Dim x As Integer = &H80000000

    Dim y As Integer = &H7FFFFFFF

    Print "Integer Range = "; x; " to "; y

#endif
```

---

**Category:** [Standard Data Types](Category-Standard-Data-Types)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
