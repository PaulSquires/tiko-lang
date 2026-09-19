[Home](Home) › [Mathematical Functions](Category-Mathematical-Functions) › **Double**

# Double

Standard data type: 64 bit floating point

## Syntax

```freebasic
Dim variable As Double
```

## Description

Double is a 64-bit, floating-point data type used to store more precise decimal numbers. They can hold positive values in the range `4.940656458412465e-324` to `1.797693134862316e+308`, or negative values in the range `-4.940656458412465e-324` to `-1.797693134862316e+308`, or zero (`0`). They contain at most 53 bits of precision, or about 15 decimal digits.

 `Double`s have a greater range and precision than [`Single`](Single)s, they still have limited accuracy which can lead to significant inaccuracies if not used properly. They are dyadic numbers - i.e. they can only accurately hold multiples of powers of two, which will lead to inaccuracies in most base-10 fractions.

## Remarks

### Differences from QB

- None

### See also

- [`Single`](Single) Less precise float type
- [`CDbl`](Cdbl)
- [`Table with variable types overview, limits and suffixes`](Standard-Data-Type-Limits)

## Examples

```freebasic
'Example of using a double variable.

Dim a As Double

a = 1.985766472453666

Print a

Sleep
```

---

**Category:** [Mathematical Functions](Category-Mathematical-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
