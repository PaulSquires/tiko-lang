[Home](Home) › [User Defined Types](Category-User-Defined-Types) › **This**

# This

Hidden instance parameter passed to non-static member functions in a Type or Class

## Syntax

```freebasic
This.fieldname
With This
.fieldname
End With
```

## Description

`This` is a reference to an instance of a [`Type`](Type-Udt) or [`Class`](Class) that is passed (through a hidden [`Byref Parameter`](Byref-Parameters)) to all non-static member functions of that type or class. Non-static member functions are procedures declared inside the body of a [`Type`](Type-Udt) or [`Class`](Class) and include [`Sub`](Sub-Member), [`Function`](Function-Member), [`Constructor`](Constructor), [`Destructor`](Destructor), assignment or [`Cast`](Operator-Cast) [`Operator`](Operator), and [`Property`](Property) procedures.

 The `This` additional parameter also has the same data type as the [`Type`](Type-Udt) or [`Class`](Class) in which the procedure is declared. Therefore using it corresponds to referring to the instance declared name on which the non-static member function is called.

 The `This` parameter can be used just like any other variable, ie., pass it to procedures taking an object of the same type, call other member procedures and access member data using [`Operator . (Member Access)`](Operator-Member-Access), etc.

 Most of the time, using `This` explicitly for member access is unnecessary; member procedures can refer to other members of the instance which they are passed directly by name, without having to qualify it with `This` and [`Operator . (Member Access)`](Operator-Member-Access). The only times when you need to qualify member names with `This` is when the member is shadowed, for example by duplicating its name for a local variable or parameter. In these situations, qualifying the member name is the only way to refer to these masked member names.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`Base (Member Access)`](Base-Member-Access)
- [`Class`](Class)
- [`Type`](Type-Udt)

## Examples

```freebasic
Type sometype

    Declare Sub MyCall()

    value As Integer

End Type

Dim example As sometype

'' Set element test to 0

example.value = 0

Print example.value

example.MyCall()

'' Output should now be 10

Print example.value

End 0

Sub sometype.MyCall()

    This.value = 10

End Sub
```

---

**Category:** [User Defined Types](Category-User-Defined-Types)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
