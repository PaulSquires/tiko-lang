[Home](Home) › [Operators](Category-Operators) › **Operator -> (Pointer To Member Access)**

# Operator -> (Pointer To Member Access)

Returns a reference to a member from a pointer to an object

## Syntax

```freebasic
Declare Operator -> ( ByRef lhs As T Ptr ) ByRef As U
```

## Parameters

- `lhs`
- `T`
- `rhs`
- `U`
- `rhs`

## Description

**`Operator ->` (Pointer to member access)** returns a reference to a member of an object through a pointer to that object. It has the effect of dereferencing a pointer to an object, then using [`Operator . (Member Access)`](Operator-Member-Access). For example, `"p->member"` is equivalent to `"x.member"`, if *x* is an object of user-defined type and *p* is a pointer to an object of the same type. `"p->member"` is equivalent to `"(*p).member"`.

 This operator can be overloaded for user-defined types.

## Return Value

Returns a reference to the member specified by `rhs`.

## Remarks

### Usage

`result = lhs -> rhs`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect.

### Differences from QB

- New to FreeBASIC

### See also

- [`Operator . (Member Access)`](Operator-Member-Access)
- [`Operator @ (Address Of)`](Operator-Address-of)
- [`Operator * (Value Of)`](Operator-Value-of)

## Examples

```freebasic
Type rect

    x As Integer

    y As Integer

End Type

Dim r As rect

Dim rp As rect Pointer = @r

rp->x = 4

rp->y = 2

Print "x = " & rp->x & ", y = " & rp->y

Sleep
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
