[Home](Home) › [Bit Manipulation](Category-Bit-Manipulation) › **Bit**

# Bit

Gets the state of an individual bit in an integer value.

## Syntax

```freebasic
#define Bit( value, bit_number ) (((value) And (Cast(TypeOf(value), 1) Shl (bit_number))) <> 0)
```

## Parameters

- `value`
- `bit_number`

## Description

This macro expands to an integer value indicating whether or not the bit specified by `bit_number` is set in the integer `value`. Behaves as \``(value And 1 Shl bit_number) <> 0`\`.

 The valid range of values for `bit_number` depends on the size, in bits, of \``TypeOf(value)`\`, which is \``0`\` (from the lowest bit) through \``SizeOf(value) * 8 - 1`\` (up to the highest bit). See [Standard Datatype Limits](Standard-Data-Type-Limits) for a table of the standard datatypes and their sizes.  
 For the `bit_number` values outside the valid range, the results of this macro are undefined.

## Return Value

Returns an [`Integer`](Integer) value of `-1` if the bit is set, or `0` if the bit is cleared.

## Remarks

### Usage

`result = Bit( value, bit_number )`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Bit`.

### Differences from QB

- New to FreeBASIC

### See also

- [`BitSet`](Bitset)
- [`BitReset`](Bitreset)

## Examples

```freebasic
Print Bit(&B1000, 3)

Print Bit(4,2)

Print Bit(5,1)

Print Bit(&H8000000000000000ULL,63)
```

 will produce the output:

```freebasic
-1
-1
 0
-1
```

---

**Category:** [Bit Manipulation](Category-Bit-Manipulation)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
