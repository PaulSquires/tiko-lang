[Home](Home) › [User Defined Types](Category-User-Defined-Types) › **Type (Alias)**

# Type (Alias)

Declares an alternative name for a type

## Syntax

```freebasic
Type typename As symbol
```

## Parameters

- `typename`
- `symbol`
- `typename`

## Description

`symbol` may refer to any declared data type including a built-in data type, [`Sub`](Sub) or [`Function`](procedures-Function) pointer, [`Type`](Type-Udt) declaration, [`Union`](Union) declaration, or [`Enum`](Enum) declaration.

 A Type Alias can be used to allow forward declarations of parameters in procedure declarations, but only used with pointers (whatever their passing mode), or otherwise with parameters (excluding arrays) but passed or returned only by reference. Generally the bodies of such procedures need to be implemented further in the code once the actual types are well defined (for example because of the passing of such a reference; or when such a pointer passed is then dereferenced in any form).  
 A Type Alias can also be used to allow forward declarations of data fields in [User Defined Types](user-defined-types-User-Defined-Types), but only used with pointers.

 A type alias must be used to allow declaration of pointer to a function pointer, otherwise ptr applies on return type and not on function.

 A Type Alias declaration can also be nested inside a UDT structure declaration for a `Type or a`[Union](Union).

## Remarks

### Version

- Since fbc 1.10.0: Nesting of a Type Alias declaration inside a structure declaring a UDT (Type or Union) is allowed.

### Differences from QB

- New to FreeBASIC

### See also

- [`Type...End Type`](Type-Udt)
- [`Type (Temporary)`](Type-Temporary)

## Examples

```freebasic
Type ParentFwd As Parent

Type Child

    Name As ZString * 32

    ParentRef As ParentFwd Ptr

    ''...

End Type

Type Parent

    Name As ZString * 32

    ChildList(0 To 9) As Child

    ''...

End Type

Dim p As Parent

p.Name = "Foo"

With p.ChildList(0)

    .Name = "Jr."

    .ParentRef = @p

    '' ...

End With

With p.ChildList(0)

    Print .Name; " is child of "; .parentRef->Name

End With
```

```freebasic
Function triple (ByVal i As Integer) As Integer

    Return 3 * i

End Function

Type As Function (ByVal As Integer) As Integer function_alias

'Dim As Function (Byval As Integer) As Integer f  ''this syntax works but is less readable than the next code line

Dim As function_alias f

f = @triple

Print f(123)

'Dim As Function (Byval As Integer) As Integer Ptr pf  ''this syntax does not work because Ptr applies on Integer and not on function

Dim As function_alias Ptr pf                           ''this syntax works

pf = @f

Print (*pf)(123)  ''the dereferenced pointer to procedure pointer must be enclosed in parentheses
```

---

**Category:** [User Defined Types](Category-User-Defined-Types)  
**Kind:** alias

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
