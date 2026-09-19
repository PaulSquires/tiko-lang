[Home](Home) › [Standard Data Types](Category-Standard-Data-Types) › **UByte**

# UByte

Standard data type: 8 bit unsigned. Equivalent to Unsigned Byte.

## Syntax

```freebasic
Dim variable As UByte
```

## Description

8-bit unsigned whole-number data type. Can hold a value in the range of 0 to 255.

## Remarks

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Ubyte`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Byte`](Byte)
- [`CUByte`](Cubyte)
- [`Table with variable types overview, limits and suffixes`](Standard-Data-Type-Limits)

## Examples

```freebasic
Dim ubytevar As UByte

ubytevar = 200

Print "ubytevar= ", ubytevar
```

```freebasic
Dim x As UByte = 0

  Dim y As UByte = &HFF

  Print "UByte Range = "; x; " to "; y
```

 Output:

```freebasic
UByte Range = 0 to 255
```

---

**Category:** [Standard Data Types](Category-Standard-Data-Types)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
