[Home](Home) › [All Categories](Categories) › **Fixed-Width Types**

# Fixed-Width Types

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang category.** Everything below is new in tiko-lang and is not part of stock FreeBASIC 1.20.0.

## The names

Ten type names that say their width, alongside FreeBASIC's own:

| tiko-lang | Same type as | Bytes | Range |
|---|---|---|---|
| `int8` | [Byte](Byte) | 1 | -128 to 127 |
| `uint8` | [UByte](Ubyte) | 1 | 0 to 255 |
| `int16` | [Short](Short) | 2 | -32768 to 32767 |
| `uint16` | [UShort](Ushort) | 2 | 0 to 65535 |
| `int32` | [Long](Long) | 4 | -2147483648 to 2147483647 |
| `uint32` | [ULong](Ulong) | 4 | 0 to 4294967295 |
| `int64` | [LongInt](Longint) | 8 | -9223372036854775808 to 9223372036854775807 |
| `uint64` | [ULongInt](Ulongint) | 8 | 0 to 18446744073709551615 |
| `float32` | [Single](Single) | 4 | IEEE 754 single precision |
| `float64` | [Double](Double) | 8 | IEEE 754 double precision |

The sizes are the same on every target.

## Why they exist

FreeBASIC's names don't say how wide they are, and the same names mean different widths in C. `long` is 32 bits in FreeBASIC on every target, but in C it is 32 bits on Windows and 64 on Linux. The names above follow Go, Nim and C's `<stdint.h>` (`int32_t`), so the width is in the name.

```freebasic
dim as uint8 red = 255
dim as int64 total = 9223372036854775807
dim as float32 ratio = 1 / 3
print red; total; ratio
```

## They are the FreeBASIC types

Each name is a typedef, not a new type: `int32` *is* `long`. Values mix freely with no conversion, a procedure that takes `long` accepts an `int32`, and an overload on `int64` is the overload on `longint`. The names leave no trace in the ABI, so a procedure's linker symbol is the one fbc gives it with the FreeBASIC names:

```freebasic
namespace N
    sub F( byval a as int8, byval b as uint16, byval c as int32, _
           byval d as uint64, byval e as float32, byval g as float64 )
    end sub
end namespace
'' _ZN1N1FEatiyfd under tiko, and under fbc with byte, ushort, long,
'' ulongint, single and double
```

## A program's own declaration wins

The names are not keywords. tiko declares them for every program, but anything the program declares with the same name at module level replaces tiko's, with no diagnostic. Existing code already uses these names: `win/basetsd.bi` declares `type INT32 as long`, and fbc's own tests have variables called `i32` and `bool`. Such code compiles exactly as it does under fbc:

```freebasic
type INT32 as long                      '' the same type: nothing changes
type uint8 as integer                   '' a different type: uint8 is now 8 bytes
dim shared float32 as long = 5          '' not a type: float32 is now this variable
function uint16( byval x as long ) as long
    return x + 1
end function
print sizeof( INT32 ); sizeof( uint8 ); float32; uint16( 6 )
```

This prints `4 8 5 7`, as fbc does. Because FreeBASIC ignores case, `INT32` and `int32` are the same name.

**The program's declaration replaces the name throughout the program**, not just in its own file. `jpeglib.bi` declares `type INT32 as clong`, which is 8 bytes on Linux x86-64. A Linux program that includes it therefore gets an 8-byte `int32`, as it would under fbc.

## What is not included

- **`integer` and `uinteger`** have no fixed-width name, because they are 4 bytes on a 32-bit target and 8 on a 64-bit one.
- **`boolean`** stays as it is, and there is no `bool`. FreeBASIC ignores case, so `bool` would be `BOOL`, which `win/windef.bi` declares as a 4-byte `long`.
- **Pointers** keep the FreeBASIC spelling: `int32 ptr`, `any ptr`.
- **Strings** are unchanged: `string`, `zstring`, `wstring` and [`ustring`](Category-UString) ✨.

## Sharing source with fbc

fbc doesn't know these names. A file that has to compile under both compilers can declare them for fbc only:

```freebasic
#ifndef __TIKO_COMPILER__
    type int8 as byte
    type uint8 as ubyte
    type int16 as short
    type uint16 as ushort
    type int32 as long
    type uint32 as ulong
    type int64 as longint
    type uint64 as ulongint
    type float32 as single
    type float64 as double
#endif
```

See [`__TIKO_COMPILER__`](Category-Tiko-Compiler-Define) ✨.

---

[Home](Home) · [Keyword Index](Keyword-Index)
