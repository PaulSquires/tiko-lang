[Home](Home) › [Operators](Category-Operators) › **Operator Let() (Assignment)**

# Operator Let() (Assignment)

Assigns fields of a user defined type to a list of variables

## Syntax

```freebasic
Let( variable1 [, variable2 [, ... ]] ) = UDT_var
Let( variable1 [, variable2 [, ... ]] ) => UDT_var
```

## Parameters

- `variable1 [, variable2 [, ... ]] Comma separated list of variables to receive the values of the UDT`
- `UDT_var`

## Description

Assigns the values from the `UDT_var` variable's fields to the list of variables.

 When the `UDT` [`Extends`](Extends) a Base, the first variable (`variable1`) assigned by the operator then corresponds to a Base instance (only the other variables are those to receive the values of the data fields of the `UDT`).

 Union is not supported.

## Remarks

### Dialect Differences

- Only available in the *[-lang fb](Compiler-Option-Lang)* dialect.

### Differences from QB

- New to FreeBASIC

### See also

- [`Let`](Let)
- [`Operator =[>] (Assignment)`](Operator-Assign)
- [`Operator Let (Assignment)`](Operator-Let-Assign)

## Examples

```freebasic
Type Vector3D

    x As Double

    y As Double

    z As Double

End Type

Dim a As Vector3D = ( 5, 7, 9 )

Dim x As Double, y As Double

'' Get the first two fields only

Let( x, y ) = a

Print "x = "; x

Print "y = "; y
```

 Output:

```freebasic
x =  5
y =  7
```

```freebasic
Type Parent

    Dim As Integer p1, p2

End Type

Type Child Extends Parent

    Dim As Integer c1, c2

End Type

Type GrandChild Extends Child

    Dim As Integer gc1, gc2

End Type

Dim As GrandChild gc = Type(1, 2, 3, 4, 5, 6)

Dim As Integer i1, i2

Dim As Integer j1, j2

Dim As Parent p

Dim As Child c

Let(c, i1, i2) = gc

Print c.p1, c.p2, c.c1, c.c2, i1, i2

Let(p, j1, j2) = gc

Print p.p1, p.p2, j1, j2
```

 Output:

```freebasic
 1             2             3             4             5             6
 1             2             5             6
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
