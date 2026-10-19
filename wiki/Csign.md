[Home](Home) › [Converting Data Types](Category-Converting-Data-Types) › **CSign**

# CSign

Converts an unsigned value to signed, so division and shifts treat it as signed.

## Syntax

```freebasic
CSign ( expression )
```

## Description

Converts an unsigned `expression` to a signed one, useful to force signed behavior of division or multiplication (including with [`Shl`](Operator-Shl-Shift-Left) and [`Shr`](Operator-Shr-Shift-Right)).

 This is the opposite of [`CUnsg`](Cunsg).

## Remarks

### Usage

`variable = CSign ( expression )`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Csign`.

### Differences from QB

- New to FreeBASIC

### See also

- [`CUnsg`](Cunsg)

## Examples

```freebasic
Dim value As UShort = 65535

Print CSign(value)  '' will print -1
```

---

**Category:** [Converting Data Types](Category-Converting-Data-Types)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
