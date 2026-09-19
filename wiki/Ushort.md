[Home](Home) › [Standard Data Types](Category-Standard-Data-Types) › **UShort**

# UShort

Standard data type: 16 bit unsigned. Equivalent to Unsigned Short.

## Syntax

```freebasic
Dim variable As UShort
```

## Description

16-bit unsigned whole-number data type. Can hold values from 0 to 65535.

## Remarks

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Ushort`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Short`](Short)
- [`CUShort`](Cushort)
- [`Table with variable types overview, limits and suffixes`](Standard-Data-Type-Limits)

## Examples

```freebasic
Dim x As UShort = 0

  Dim y As UShort = &HFFFF

  Print "UShort Range = "; x; " to "; y
```

 Output:

```freebasic
UShort Range = 0 to 65535
```

---

**Category:** [Standard Data Types](Category-Standard-Data-Types)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
