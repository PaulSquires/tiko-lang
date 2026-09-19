[Home](Home) › [Standard Data Types](Category-Standard-Data-Types) › **ULong**

# ULong

Standard data type: 32-bit unsigned integer. Equivalent to Unsigned Long.

## Syntax

```freebasic
Dim variable As ULong
```

## Description

32-bit unsigned whole-number data type. Can hold values from `0` to `4294967295`. Corresponds to an unsigned DWORD.

## Remarks

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Ulong`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Long`](Long)
- [`UInteger`](Uinteger)
- [`ULongInt`](Ulongint)
- [`Table with variable types overview, limits and suffixes`](Standard-Data-Type-Limits)

## Examples

```freebasic
  Dim x As ULong = 0

  Dim y As ULong = &HFFFFFFFF

  Print "ULong Range = "; x; " to "; y
```

 **Output:**

```freebasic
ULong Range = 0 to 4294967295
```

---

**Category:** [Standard Data Types](Category-Standard-Data-Types)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
