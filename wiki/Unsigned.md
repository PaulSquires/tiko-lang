[Home](Home) › [Standard Data Types](Category-Standard-Data-Types) › **Unsigned**

# Unsigned

Integer data type modifier

## Syntax

```freebasic
Dim variable As Unsigned {integer-based data type}
```

## Description

Forces an integer-based data type to be unsigned (cannot contain negative numbers, but has its maximum value doubled).

## Remarks

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Unsigned`.

### Differences from QB

- New to FreeBASIC

### See also

- [`UInteger`](Uinteger)

## Examples

```freebasic
'e.g. notice what is displayed:

Dim x As Unsigned Integer

x = -1

Print x

'output is 4294967295
```

---

**Category:** [Standard Data Types](Category-Standard-Data-Types)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
