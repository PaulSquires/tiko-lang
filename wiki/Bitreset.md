[Home](Home) › [Bit Manipulation](Category-Bit-Manipulation) › **BitReset**

# BitReset

Returns a copy of an integer with the numbered bit cleared to 0.

## Syntax

```freebasic
#define BitReset( value, bit_number ) ((value) And Not (Cast(TypeOf(Value), 1) Shl (bit_number)))
```

## Parameters

- `value`
- `bit_number`

## Description

This macro expands to a copy of the integer `value` with the specified `bit_number` cleared (to *off*, or \``0`\`). Behaves as \``value And Not (1 Shl bit_number)`\`.  
 To clear a specified bit in a variable, the following assignment can be used: `variable = BitReset( variable, bit_number )`

 The valid range of values for `bit_number` depends on the size, in bits, of \``TypeOf(value)`\`, which is \``0`\` (from the lowest bit) through \``SizeOf(value) * 8 - 1`\` (up to the highest bit). See [Standard Datatype Limits](Standard-Data-Type-Limits) for a table of the standard datatypes and their sizes.  
 For the `bit_number` values outside the valid range, the results of this macro are undefined.

## Return Value

Returns the integer value with the specified bit cleared.

## Remarks

### Usage

`result = BitReset( value, bit_number )`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Bitreset`.

### Differences from QB

- New to FreeBASIC.

### See also

- [`Bit`](Bit)
- [`BitSet`](Bitset)

## Examples

```freebasic
Print Bin(BitReset(&b10101, 2))

Print BitReset(5,0)

Print Hex(BitReset(&h8000000000000001,63))
```

 will produce the output:

```freebasic
10001
 4
1
```

---

**Category:** [Bit Manipulation](Category-Bit-Manipulation)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
