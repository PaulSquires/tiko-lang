[Home](Home) › [User Defined Types](Category-User-Defined-Types) › **Base (Member Access)**

# Base (Member Access)

Provides explicit access to base type members in non-static methods of a Type

## Syntax

```freebasic
Base.member
Base [ .Base ... ] .member
```

## Description

`Base` provides a way to explicitly access members of a specific base type, in the context of non-static methods of a user-defined type derived from another type using [`Extends`](Extends).

 By using `Base` repeatedly, as in `base.base.base.member`, it is possible to access any desired base type, in case there are multiple levels of inheritance.

 `Base` is especially useful when a base type's member is shadowed by a local variable or member of a derived type using the same identifier. `Base` then allows unambiguous access to the base type.

 For virtual methods, base.method() always calls the base method and never the overriding method.

 **Note:** There is no specific syntax with `Base` to access a member operator of a specific base type. The only way is to apply the operator on the instance beforehand up-casted to the right type (but for virtual operators, this workaround does not allow to call the base operator when overridden, because that does not modify the run-time type of the instance but only its compile-time type).

## Remarks

### Dialect Differences

- Methods are only supported in the *[-lang fb](Compiler-Option-Lang)* dialect, hence `Base` has no function in other dialects.

### Differences from QB

- New to FreeBASIC

### See also

- [`Base (Initializer)`](Base-Initializer)
- [`This`](This)
- [`Type`](Type-Udt)
- [`Extends`](Extends)
- [`Extends Zstring`](Extends-Zstring)
- [`Extends Wstring`](Extends-Wstring)
- [`Option Base`](Option-Base)

## Examples

```freebasic
Type Parent

    As Integer a

    Declare Constructor(ByVal As Integer = 0)

    Declare Sub show()

End Type

Constructor Parent(ByVal a As Integer = 0)

    This.a = a

End Constructor

Sub Parent.show()

    Print "parent", a

End Sub

Type Child Extends Parent

    As Integer a

    Declare Constructor(ByVal As Integer = 0)

    Declare Sub show()

End Type

Constructor Child(ByVal a As Integer = 0)

    '' Call base type's constructor

    Base(a * 3)

    This.a = a

End Constructor

Sub Child.show()

    '' Call base type's show() method, not ours

    Base.show()

    '' Show both a fields, the base type's and ours'

    Print "child", Base.a, a

End Sub

Type GrandChild Extends Child

    As Integer a

    Declare Constructor(ByVal As Integer = 0)

    Declare Sub show()

End Type

Constructor GrandChild(ByVal a As Integer = 0)

    '' Call base type's constructor

    Base(a * 2)

    This.a = a

End Constructor

Sub GrandChild.show()

    '' Call base type's show() method, not ours

    Base.show()

    '' Show both a fields, the base.base type's, the base type's and ours'

    Print "grandchild", Base.Base.a, Base.a, a

End Sub

Dim As GrandChild x = GrandChild(3)

x.show()
```

---

**Category:** [User Defined Types](Category-User-Defined-Types)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
