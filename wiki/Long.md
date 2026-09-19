[Home](Home) › [Standard Data Types](Category-Standard-Data-Types) › **Long**

# Long

Standard data type: 32-bit signed integer

## Syntax

```freebasic
Dim variable As Long
```

## Description

32-bit signed whole-number data type. Can hold values from `-2147483648` to `2147483647`. Corresponds to a signed DWORD.

## Remarks

### See also

- [`Integer`](Integer)
- [`LongInt`](Longint)
- [`ULong`](Ulong)
- [`Table with variable types overview, limits and suffixes`](Standard-Data-Type-Limits)

## Examples

```freebasic
Dim x As Long = &H80000000

  Dim y As Long = &H7FFFFFFF

  Print "Long Range = "; x; " to "; y
```

 **Output:**

```freebasic
Long Range = -2147483648 to  2147483647
```

---

**Category:** [Standard Data Types](Category-Standard-Data-Types)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
