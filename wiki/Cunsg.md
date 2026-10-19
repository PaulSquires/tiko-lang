[Home](Home) › [Converting Data Types](Category-Converting-Data-Types) › **CUnsg**

# CUnsg

Converts a signed value to unsigned, so division and shifts treat it as unsigned.

## Syntax

```freebasic
CUnsg ( expression )
```

## Remarks

### Usage

`variable = CUnsg ( expression )`  
 Converts a signed `expression` to an unsigned one, useful to force unsigned behavior of division or multiplication (including with [`Shl`](Operator-Shl-Shift-Left) and [`Shr`](Operator-Shr-Shift-Right)).

 This is the opposite of [`CSign`](Csign).

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Cunsg`.

### Differences from QB

- New to FreeBASIC

### See also

- [`CSign`](Csign)

## Examples

```freebasic
Dim value As Short = -1

Print CUnsg(value)  '' will print 65535
```

---

**Category:** [Converting Data Types](Category-Converting-Data-Types)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
