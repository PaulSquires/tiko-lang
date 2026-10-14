[Home](Home) › [Standard Data Types](Category-Standard-Data-Types) › **Boolean**

# Boolean

Standard data type

## Syntax

```freebasic
Dim variable As Boolean
```

## Description

Boolean data type. Can hold the values [`True`](True) or [`False`](False)  
 Default value on initialization is [`False`](False)

 **Notes on definition of boolean data type:**

*- Ideally, the definition of the boolean data type is that it holds the value of [`True`](True) or [`False`](False), and that's it. However, to make this concept a reality, we need a definition that uses real world connections.
 - A more realistic definition is that the boolean data type is a 1-bit integer, having the value 0 to indicate [`False`](False) and 1 to indicate [`True`](True).
 - For a practical definition, we must consider, yet again, additional factors. The most significant factor is that the hardware (processor) on which code is executed does not directly support a 1-bit data type; the smallest register or memory size we can work with is 8-bits or 1-byte.
 - Assume "false" is 0 in both C/C++ and FB. C/C++ has logical 'not' operator '!' such that '!0' produces '1'. FB has a bitwise [`Not`](Operator-Not-Complement) operator such that 'not 0' produces '-1'.
 - Nevertheless the definition under the hood for a FB boolean remains an 1-bit integer, zero extended to fill larger integer types.
 - Therefore when assigning a boolean with an integer value (by implicit conversion and not with the [`False`](False) or [`True`](True) value), '0' induces the [`False`](False) state and '1' or '-1' induces the [`True`](True) state (any other value also induces the [`True`](True) state, but with a warning message).
 - Otherwise when assigning a numeric type with a boolean (by implicit conversion), [`False`](False) induces the '0' value and [`True`](True) induces the '-1' value.
 - However, the purpose and intent of the boolean data type remains, that it should only ever hold a [`True`](True) value or [`False`](False) value, regardless of the underlying details.*

## Remarks

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Boolean`.

### Differences from QB

- New to FreeBASIC

### See also

- [`CBool`](Cbool)
- [`True`](True)
- [`False`](False)
- [`Table with variable types overview, limits and suffixes`](Standard-Data-Type-Limits)

## Examples

```freebasic
Dim boolvar As Boolean

boolvar = True

Print "boolvar = ", boolvar
```

 Output:

```freebasic
boolvar =     true
```

---

**Category:** [Standard Data Types](Category-Standard-Data-Types)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
