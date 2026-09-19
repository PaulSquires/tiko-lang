[Home](Home) › [Standard Data Types](Category-Standard-Data-Types) › **Short**

# Short

Standard data type: 16 bit signed

## Syntax

```freebasic
Dim variable As Short
```

## Description

16-bit signed whole-number data type. Can hold values from -32768 to 32767.

## Remarks

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Short`.

### Differences from QB

- The name "short" is new to FreeBASIC, however they are the same as integers in QB

### See also

- [`UShort`](Ushort)
- [`CShort`](Cshort)
- [`Table with variable types overview, limits and suffixes`](Standard-Data-Type-Limits)

## Examples

```freebasic
Dim x As Short = CShort(&H8000)

  Dim y As Short = CShort(&H7FFF)

  Print "Short Range = "; x; " to "; y
```

 Output:

```freebasic
Short Range = -32768 to  32767
```

---

**Category:** [Standard Data Types](Category-Standard-Data-Types)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
