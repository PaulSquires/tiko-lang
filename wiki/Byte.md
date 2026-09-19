[Home](Home) › [Standard Data Types](Category-Standard-Data-Types) › **Byte**

# Byte

Standard data type: 8 bit signed

## Syntax

```freebasic
Dim variable As Byte
```

## Description

8-bit signed whole-number data type. Can hold a value in the range of -128 to 127.

## Remarks

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Byte`.

### Differences from QB

- New to FreeBASIC

### See also

- [`UByte`](Ubyte)
- [`CByte`](Cbyte)
- [`Table with variable types overview, limits and suffixes`](Standard-Data-Type-Limits)

## Examples

```freebasic
Dim bytevar As Byte

  bytevar = 100

  Print "bytevar= ", bytevar
```

```freebasic
Dim x As Byte = CByte(&H80)

Dim y As Byte = CByte(&H7F)

Print "Byte Range = "; x; " to "; y
```

 **Output:**

```freebasic
Byte Range = -128 to  127
```

---

**Category:** [Standard Data Types](Category-Standard-Data-Types)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
