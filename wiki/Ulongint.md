[Home](Home) › [Standard Data Types](Category-Standard-Data-Types) › **ULongInt**

# ULongInt

Standard data type: 64 bit unsigned. Equivalent to Unsigned LongInt.

## Syntax

```freebasic
Dim variable As ULongInt
```

## Description

A 64-bit unsigned whole-number data type. Can hold values from 0 to 18 446 744 073 709 551 615. Corresponds to an unsigned QWORD.

## Remarks

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Ulongint`.

### Differences from QB

- New to FreeBASIC

### See also

- [`LongInt`](Longint)
- [`CULngInt`](Culngint)
- [`Table with variable types overview, limits and suffixes`](Standard-Data-Type-Limits)

## Examples

```freebasic
Dim x As ULongInt = 0

Dim y As ULongInt = &HFFFFFFFFFFFFFFFFull

Print "ULongInt Range = "; x; " to "; y
```

 Output:

```freebasic
ULongInt Range = 0 to 18446744073709551615
```

---

**Category:** [Standard Data Types](Category-Standard-Data-Types)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
