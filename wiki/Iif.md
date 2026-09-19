[Home](Home) › [Miscellaneous Keywords](Category-Miscellaneous-Keywords) › **IIf**

# IIf

Conditional function that returns one of two values.

## Syntax

```freebasic
IIf ( condition, expr_if_true, expr_if_false )
```

## Parameters

- `condition`
- `expr_if_true`
- `condition`
- `expr_if_false`
- `condition`
- `expr_if_true`

## Description

`IIf` returns a different numeric or string or UDT value (not a reference) depending of the result of a conditional expression evaluated at run-time.  
 Its typical use is in the middle of an expression; it avoids splitting it to put a conditional in the middle.

 `IIf` only evaluates the expression that it needs to return. This saves time, and can also be useful to prevent evaluating expressions that might be invalid depending on the `condition`.

 When `IIf` treats expressions of mixed numeric types (conditional expression evaluated at run-time):

**Note:** If the condition evaluation can be done at compile time (if the comparison expression is a constant), the usage rules are a bit more flexible and `IIf` can for example return a reference or even return a function call (but not a sub call).

## Return Value

if `condition` is non-zero, `expr_if_true`, otherwise `expr_if_false`

## Remarks

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Iif`.

### Differences from QB

- New to FreeBASIC

### See also

- [`If...Then`](If-Then)

## Examples

```freebasic
Dim As Integer a, b, x, y, z

a = (x + y + IIf(b > 0, 4, 7)) \ z
```

 is equivalent to:

```freebasic
Dim As Integer a, b, x, y, z, temp

If b > 0 Then temp = 4 Else temp = 7

a = (x + y + temp) \ z
```

```freebasic
Dim As Integer I

I = -10

Print I, IIf(I>0, "positive", IIf(I=0, "null", "negative"))

I = 0

Print I, IIf(I>0, "positive", IIf(I=0, "null", "negative"))

I = 10

Print I, IIf(I>0, "positive", IIf(I=0, "null", "negative"))

Sleep
```

```freebasic
Type UDT1

  Dim As Integer I1

End Type

Type UDT2 Extends UDT1

  Dim As Integer I2

End Type

Dim As UDT1 u1, u10 = (1)

Dim As UDT2 u2, u20 = (2, 3)

u1 = IIf(0, u10, u20)

Print u1.I1

u1 = IIf(1, u10, u20)

Print u1.I1

u2 = IIf(0 , u10, u20)

Print u2.I1; u2.I2

'u2 = Iif(1, u10, u20) ''Invalid assignment/conversion

Sleep
```

---

**Category:** [Miscellaneous Keywords](Category-Miscellaneous-Keywords)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
