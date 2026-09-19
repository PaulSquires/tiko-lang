[Home](Home) › [Standard Data Types](Category-Standard-Data-Types) › **LongInt**

# LongInt

Standard data type: 64 bit signed

## Syntax

```freebasic
Dim variable As LongInt
```

## Description

A 64-bit signed whole-number data type. Can hold values from -9 223 372 036 854 775 808 to 9 223 372 036 854 775 807. Corresponds to a signed QWORD.

## Remarks

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Longint`.

### Differences from QB

- New to FreeBASIC

### See also

- [`ULongInt`](Ulongint)
- [`CLngInt`](Clngint)
- [`Table with variable types overview, limits and suffixes`](Standard-Data-Type-Limits)

## Examples

```freebasic
Dim x As LongInt = &H8000000000000000

  Dim y As LongInt = &H7FFFFFFFFFFFFFFF

  Print "LongInt Range = "; x; " to "; y
```

 **Output:**

```freebasic
LongInt Range = -9223372036854775808 to  9223372036854775807
```

---

**Category:** [Standard Data Types](Category-Standard-Data-Types)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
