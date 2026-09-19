[Home](Home) › [Bit Manipulation](Category-Bit-Manipulation) › **LoByte**

# LoByte

Gets the lowest byte of the operand.

## Syntax

```freebasic
#define LoByte( expr ) (Cast(UInteger, expr) And &h000000FF)
```

## Parameters

- `expr`

## Description

This macro converts the numeric expression `expr` to an [`UInteger`](Uinteger) value, then expands to an [`UInteger`](Uinteger) representing the value of its least-significant (low) byte.

## Return Value

Returns the value of the low byte of *expr*.

## Remarks

### Usage

`result = LoByte( expr )`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__LOBYTE`.

### Differences from QB

- New to FreeBASIC

### See also

- [`HiByte`](Hibyte)
- [`LoWord`](Loword)
- [`HiWord`](Hiword)

## Examples

```freebasic
Dim N As UInteger

'Note there are 16 bits

N = &b1010101110000001

Print "N is                                       "; N

Print "The binary representation of N is          "; Bin(N)

Print "The most significant byte (MSB) of N is    "; HiByte(N)

Print "The least significant byte (LSB) of N is   "; LoByte(N)

Print "The binary representation of the MSB is    "; Bin(HiByte(N))

Print "The binary representation of the LSB is    "; Bin(LoByte(N))

Sleep
```

 The output would look like:

```freebasic
N Is                                       43905
The Binary representation of N Is          1010101110000001
The most significant Byte (MSB) of N Is    171
The least significant Byte (LSB) of N Is   129
The Binary representation of the MSB Is    10101011
The Binary representation of the LSB Is    10000001
```

---

**Category:** [Bit Manipulation](Category-Bit-Manipulation)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
