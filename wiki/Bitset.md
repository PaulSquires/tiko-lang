[Home](Home) › [Bit Manipulation](Category-Bit-Manipulation) › **BitSet**

# BitSet

Gets the value with a specified bit set, from a copied integer.

## Syntax

```freebasic
#define BitSet( value, bit_number ) ((value) Or (Cast(TypeOf(Value), 1) Shl (bit_number)))
```

## Parameters

- `value`
- `bit_number`

## Description

This macro expands to a copy of the integer `value` with the specified `bit_number` set (to *on*, or \``1`\`). Behaves as \``value Or (1 Shl bit_number)`\`.  
 To set a specified bit in a variable, the following assignment can be used: `variable = BitSet( variable, bit_number )`

 The valid range of values for `bit_number` depends on the size, in bits, of \``TypeOf(value)`\`, which is \``0`\` (from the lowest bit) through \``SizeOf(value) * 8 - 1`\` (up to the highest bit). See [Standard Datatype Limits](Standard-Data-Type-Limits) for a table of the standard datatypes and their sizes.  
 For the `bit_number` values outside the valid range, the results of this macro are undefined.

## Return Value

Returns the integer value with the specified bit set.

## Remarks

### Usage

`result = BitSet( value, bit_number )`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Bitset`.

### Differences from QB

- New to FreeBASIC.

### See also

- [`Bit`](Bit)
- [`BitReset`](Bitreset)

## Examples

```freebasic
Print Bin(BitSet(&b10001,2))

Print BitSet(4, 0)

Print Hex(BitSet(1ull, 63))
```

 will produce the output:

```freebasic
10101
 5
8000000000000001
```

---

**Category:** [Bit Manipulation](Category-Bit-Manipulation)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
