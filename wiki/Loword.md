[Home](Home) › [Bit Manipulation](Category-Bit-Manipulation) › **LoWord**

# LoWord

Returns the lowest 16 bits of a number.

## Syntax

```freebasic
#define LoWord( expr ) (Cast(UInteger, expr) And &h0000FFFF)
```

## Parameters

- `expr`

## Description

This macro converts the numeric expression `expr` to an [`UInteger`](Uinteger) value, then expands to an [`UInteger`](Uinteger) representing the value of its least-significant (low) 16bit word.

## Return Value

Returns the value of the low word of *expr*.

## Remarks

### Usage

`result = LoWord( expr )`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__LOWORD`.

### Differences from QB

- New to FreeBASIC

### See also

- [`LoByte`](Lobyte)
- [`HiByte`](Hibyte)
- [`HiWord`](Hiword)

## Examples

```freebasic
Dim N As UInteger

'Note there are 32 bits

N = &b10000000000000011111111111111111

Print "N is                                       "; N

Print "The binary representation of N is          "; Bin(N)

Print "The most significant word (MSW) of N is    "; HiWord(N)

Print "The least significant word (LSW) of N is   "; LoWord(N)

Print "The binary representation of the MSW is    "; Bin(HiWord(N))

Print "The binary representation of the LSW is    "; Bin(LoWord(N))

Sleep
```

 The output would look like:

```freebasic
N Is                                       2147614719
The Binary representation of N Is          10000000000000011111111111111111
The most significant word (MSW) of N Is    32769
The least significant word (LSW) of N Is   65535
The Binary representation of the MSW Is    1000000000000001
The Binary representation of the LSW Is    1111111111111111
```

---

**Category:** [Bit Manipulation](Category-Bit-Manipulation)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
