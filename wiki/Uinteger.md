[Home](Home) › [Bit Manipulation](Category-Bit-Manipulation) › **UInteger**

# UInteger

Standard data type: 32-bit or 64-bit unsigned, same size as SizeOf(Any Ptr). Equivalent to Unsigned Integer.

## Syntax

```freebasic
Dim variable As UInteger
Dim variable As UInteger<bits>
```

## Parameters

- `bits`

## Description

32-bit or 64-bit unsigned whole-number data type, depending on the platform.

 If an explicit bit size is given, a data type is provided that can hold values from `0` up to `(1ULL Shl (bits)) - 1`. The selected data type is [`UByte`](Ubyte) for **UInteger<8>**, [`UShort`](Ushort) for **UInteger<16>**, [`ULong`](Ulong) for **UInteger<32>** and [`ULongInt`](Ulongint) for **UInteger<64>**.

## Remarks

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Uinteger`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Integer`](Integer)
- [`Unsigned`](Unsigned)
- [`CUInt`](Cuint)
- [`Table with variable types overview, limits and suffixes`](Standard-Data-Type-Limits)

## Examples

```freebasic
#ifdef __FB_64BIT__

    Dim x As UInteger = 0

    Dim y As UInteger = &HFFFFFFFFFFFFFFFF

    Print "UInteger Range = "; x; " to "; y

#else

    Dim x As UInteger = 0

    Dim y As UInteger = &HFFFFFFFF

    Print "UInteger Range = "; x; " to "; y

#endif
```

---

**Category:** [Bit Manipulation](Category-Bit-Manipulation)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
