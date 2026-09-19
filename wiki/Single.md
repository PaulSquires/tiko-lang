[Home](Home) › [Standard Data Types](Category-Standard-Data-Types) › **Single**

# Single

Standard data type: 32 bit floating point

## Syntax

```freebasic
Dim variable As Single
```

## Description

Single is a 32-bit, floating point data type used to store decimal numbers. They can hold positive values in the range `1.401298e-45` to `3.402823e+38`, or negative values in the range `-1.401298e-45` to `-3.402823e+38`, or zero (`0`). They contain at most 24 bits of precision, or about 6 decimal digits.

 They are similar to [`Double`](Double) data types, but less precise.

## Remarks

### Differences from QB

- None

### See also

- [`Double`](Double) More precise float type
- [`CSng`](Csng)
- [`Table with variable types overview, limits and suffixes`](Standard-Data-Type-Limits)

## Examples

```freebasic
'Example of using a single variable.

Dim a As Single

a = 1.9857665

Print a

Sleep
```

---

**Category:** [Standard Data Types](Category-Standard-Data-Types)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
