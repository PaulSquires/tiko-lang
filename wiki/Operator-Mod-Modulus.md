[Home](Home) › [Operators](Category-Operators) › **Operator Mod (Modulus)**

# Operator Mod (Modulus)

Finds the remainder from a division operation

## Syntax

```freebasic
Declare Operator Mod ( ByRef lhs As Integer, ByRef rhs As Integer ) As Integer
```

## Parameters

- `lhs`
- `rhs`

## Description

**`Operator Mod` (Modulus)** divides two [`Integer`](Integer) expressions and returns the remainder. Float numeric values are converted to [`Integer`](Integer) by rounding up or down.

 Neither of the operands are modified in any way.

 This operator can be overloaded for user-defined types.

## Return Value

Returns the remainder of a division operation.

## Remarks

### Usage

`result = lhs Mod rhs`

### Dialect Differences

- In the *[-lang qb](Compiler-Option-Lang)* dialect, this operator cannot be overloaded.

### Differences from QB

- None

### See also

- [Mathematical Functions](Mathematical-Functions)

## Examples

```freebasic
Print 47 Mod 7

Print 5.6 Mod 2.1

Print 5.1 Mod 2.8
```

 Output:

```freebasic
5
0
2
```

 This is because:

- 47 divided by 7 gives a remainder of 5
  5.6 is rounded to 6 while 2.1 is rounded to 2. This makes the problem 6 MOD 2 which means 6 divided by 2 which gives a remainder of 0
  5.1 is rounded to 5 while 2.8 is rounded to 3. This makes the problem 5 MOD 3 which means 5 divided by 3 which gives a remainder of 2

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
