[Home](Home) › [Operators](Category-Operators) › **Operator . (Member Access)**

# Operator . (Member Access)

Returns a reference to a member from a reference to an object

## Syntax

```freebasic
Declare Operator . ( ByRef lhs As T ) ByRef As U
```

## Parameters

- `lhs`
- `T`
- `rhs`
- `U`
- `rhs`

## Description

**`Operator .` (Member access)** returns a reference to a member of an object.

 **`Operator .` (Member access)** can also be used to access members of an implicit object inside a [`With..End With`](With) block.

 This operator cannot be overloaded.

## Return Value

Returns a reference to the member specified by `rhs`.

## Remarks

### Usage

`result = lhs . rhs`

### Dialect Differences

- None

### Differences from QB

- None

### See also

- [`Operator -> (Pointer To Member Access)`](Operator-Pointer-to-Member-Access)
- [`Operator @ (Address Of)`](Operator-Address-of)
- [`Operator * (Value Of)`](Operator-Value-of)
- [`With..End With`](With)

## Examples

```freebasic
Type T

    As Integer a, b

End Type

Dim x As T

'' Access the member 'a' of x.

x.a = 10

'' Access the member 'b' of x.

With x

    .b = 20

End With
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
