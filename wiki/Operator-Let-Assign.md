[Home](Home) › [Operators](Category-Operators) › **Operator Let (Assign)**

# Operator Let (Assign)

Indicates the assignment operator when overloading Operator = (Assignment)

## Syntax

```freebasic
{ Type | Class | Union } typename
Declare Operator Let ( [ ByRef | ByVal ] rhs As datatype )
End { Type | Class | Union }
Operator typename.Let ( [ ByRef | ByVal ] rhs As datatype )
```

## Parameters

- `typename`
- `lhs`
- `rhs`

## Description

`Let` is used to overload the [`Operator =[>] (Assignment)`](Operator-Assign) operator and to distinguish it from the comparison operator [`Operator = (Equal)`](Operator-Equal).

 `lhs =[>] rhs` will assign the `rhs` to `lhs` by invoking the `Let` operator procedure defined in `typename`.  
 This includes the case of an object returned from a function by value, by using `Function =[>] rhs` (or `function_identifier =[>] rhs`) assignment.

 An operator `Let` (assign) must be defined if the shallow implicit copy is not sufficient. This happens in cases when the object manages dynamically allocated memory or other resources which need to be specially copied (for example if a member pointer points to dynamically allocated memory, the implicit assignment operator will simply copy the pointer value instead of allocate memory and then perform the copy of data).

Note: It is safe to do a check for self-assignment at the top of the `Let` body (by comparing the address of implicit 'this' instance with the address of 'rhs' parameter) to avoid object destruction if previously allocated memory is first deallocated (see example below).

When the operator `Let` (assign) is defined for copy assignment, its parameter (the object to clone) can not be passed by value.

## Remarks

### Usage

`lhs = rhs`*or*`lhs => rhs`

### Version

- Before fbc version 1.20.0, assigning one array was not supported.

### Dialect Differences

- In the *[-lang qb](Compiler-Option-Lang)* and *[-lang fblite](Compiler-Option-Lang)* dialects, this operator cannot be overloaded.
  In the *[-lang qb](Compiler-Option-Lang)* and *[-lang fblite](Compiler-Option-Lang)* dialects, an assignment expression can be preceded by the [`Let`](Let) keyword.

### Differences from QB

- None.

### See also

- [`Let`](Let)
- [`Operator Let() (Assignment)`](Operator-Let-Assignment)
- [`Operator =[>] (Assignment)`](Operator-Assign)
- [`Operator = (Equal)`](Operator-Equal)
- [Coercion and Conversion](Coercion-and-Conversion)

## Examples

```freebasic
Type UDT

  Public:

    Declare Constructor (ByVal zp As Const ZString Ptr)  ''constructor with string initializer

    Declare Operator Let (ByRef rhs As UDT)              ''operator Let (assignment)

    Declare Function getString () As String              ''function to get string

    Declare Destructor ()                                ''destructor

  Private:

    Dim zp As ZString Ptr                                ''private pointer to avoid direct access

End Type

Constructor UDT (ByVal zp As Const ZString Ptr)

  This.zp = CAllocate(Len(*zp) + 1)

  *This.zp = *zp

End Constructor

Operator UDT.Let (ByRef rhs As UDT)

  If @This <> @rhs Then  '' check for self-assignment to avoid object destruction

    Deallocate(This.zp)

    This.zp = CAllocate(Len(*rhs.zp) + 1)

    *This.zp = *rhs.zp

  End If

End Operator

Function UDT.getString () As String

  Return *This.zp

End Function

Destructor UDT ()

  Deallocate(This.zp)

End Destructor

Dim u As UDT = UDT("")

u = Type<UDT>("Thanks to the overloading operator Let (assign)")

Print u.getString

Sleep
```

 Output:

```freebasic
Thanks to the overloading operator Let (assign)
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
