[Home](Home) › [User Defined Types](Category-User-Defined-Types) › **With**

# With

Statement block to allow implicit access to fields in a user defined type variable

## Syntax

```freebasic
With user_defined_var
statements
End With
```

## Description

The `With...End With` block allows the omission of the name of a variable of a user-defined [`Type`](Type-Udt) when referring to its fields. The fields may then be accessed with just a single period (`.`) before them, e.g. if the [`Type`](Type-Udt) contains an field element called "*`element`*", then it could be accessed within the `With` block as "`.element`".

 It can be used as a shorthand to save typing and avoid cluttering the source.  
 `With` can also be used with dereferenced pointers as the second example shows, with temporary instances (with explicit or implicit constructor) as the third example, and even with temporary types (without any constructor), because destruction of such temporary instances/types is deferred to the end of the `With` scope.  
 But returns byref of functions from temporary instances/types taken as arguments are not supported (and no error message).

 `With` blocks may be nested. In this case, only the innermost `With` block is active, and any outer ones are ignored until the inner one is closed again. See the third example for an illustration of this.

 Internally, the address of the variable is taken at the start of the `With` block, and then is used to calculate any element accesses within the block.  
 Note that this means that [`Goto`](Goto) should not be used to jump into a `With` block, otherwise the address will not have been set, and the results of trying to access it will be undefined.

 *Note for `With` block used inside member procedure:
 To access duplicated symbols defined as global outside the Type, add two dots as prefix: "`..SomeSymbol`" (inside a `With...End With` block).*

## Remarks

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__With`.
  In the *[-lang qb](Compiler-Option-Lang)* and *[-lang fblite](Compiler-Option-Lang)* dialects, variables declared inside a `With`..`End With` block have a function-wide [scope](Variable-Scope) as in QB.  
  In the *[-lang fb](Compiler-Option-Lang)* and *[-lang deprecated](Compiler-Option-Lang)* dialects, variables declared inside a `With`..`End With` block are visible only inside the block, and can't be accessed outside it.

### Differences from QB

- New to FreeBASIC

### See also

- [`Type`](Type-Udt)

## Examples

```freebasic
Type rect_type

    x As Single

    y As Single

End Type

Dim the_rectangle As rect_type

Dim As Integer temp, t

With the_rectangle

    temp = .x

    .x = 234 * t + 48 + .y

    .y = 321 * t + 2

End With
```

```freebasic
Type rect_type

    x As Single

    y As Single

End Type

Dim the_rectangle As rect_type Ptr

the_rectangle = CAllocate( 5 * Len( rect_type ) )

Dim As Integer loopvar, temp, t

For loopvar = 0 To 4

  With the_rectangle[loopvar]  '' dereferenced pointer

    temp = .x

    .x = 234 * t + 48 + .y

    .y = 321 * t + 2

  End With

Next
```

```freebasic
Type rect_type

    x As Single

    y As Single

    Declare Constructor()

    Declare Constructor(ByVal x0 As Single, ByVal y0 As Single)

End Type

Constructor rect_type()

End Constructor

Constructor rect_type(ByVal x0 As Single, ByVal y0 As Single)

    This.x = x0

    This.y = y0

End Constructor

Dim the_rectangle As rect_type

With rect_type(1, 2)  '' temporary instance created here held up to 'End With'

    the_rectangle.x = .x + .y  '' 1 + 2 = 3

    the_rectangle.y = .x - .y  '' 1 - 2 = -1

End With
```

```freebasic
Type rect_type

    x As Single

    y As Single

End Type

Dim As rect_type rect1, rect2

'' Nested With blocks

With rect1

    .x = 1

    .y = 2

    With rect2

        .x = 3

        .y = 4

    End With

End With

Print rect1.x, rect1.y '' 1,  2

Print rect2.x, rect2.y '' 3,  4
```

---

**Category:** [User Defined Types](Category-User-Defined-Types)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
