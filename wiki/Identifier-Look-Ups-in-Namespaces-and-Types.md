[Home](Home) › [Tutorials](Category-Tutorials) › **Identifier Look-ups in namespaces and types**

# Identifier Look-ups in namespaces and types

When referencing to an **identifier** is encountered in a program, a **look-up** is performed to locate the declaration that introduced that identifier.

 **Preamble:**

 The identifiers to look-up can be unqualified or qualified:

**-** An unqualified identifier is an identifier that does not have a prefix to specify what scope it comes from.
 **-** A qualified identifier includes a prefix to clarify the interpretive scope by overriding the default scope.

Scope priority hierarchy

Unqualified identifier look-ups verify the priority hierarchy as follows:

Unqualified identifiers for look-up can be:

**-** Variable identifiers.

=> Look-up order: \[1\], \[2\], \[3\], \[4\].

**-** Procedure identifiers.

=> Look-up order: \[1\], \[2\], \[3\], \[4\].

**-** Type/Union identifiers.

=> Look-up order: \[1\], \[3\], \[4\].

**-** Enum identifiers, not their field symbols alone.

=> Look-up order: \[1\], \[3\], \[4\].

If a qualified identifier with a prefix referring to a namespace is used instead of an unqualified identifier, the previous rules for unqualified identifiers are amended as follows:

=> Look-up order: \[1\], \[4\].

If a qualified identifier with a prefix (`object-name/This` or [`Base (Member Access)`](Base-Member-Access)) referring to a type is used instead of an unqualified identifier, the previous rules for unqualified identifiers are amended as follows:

=> Look-up order: \[1\], \[2\].

Full process

The full process simplifies the problem by dealing with it in two successive phases:

The problem is thus simplified to one single full overload resolution within a same scope (instead of a full overload resolution within each scope candidate, and then the difficult choice of the best result among the scope candidates).

 The coding of a very optimized resolution process (the best of human intelligence) for a procedure identifier is cumbersome, because having to take into account from the start the complete signature of the called procedure (identifier of the procedure + type and number of parameters + calling convention + return type if it exists).  
 In addition, it must be taken into account that the signature deduced from the call may not necessarily be identical but just compatible with certain declared ones in the scope candidates.

 *Identifier look-ups for the overload non-member operators*

Currently, the look-up for the overload non-member operator identifiers is simplified by the fact that the compiler always define these operators in the global namespace even if the user declared them in named namespaces.  
 But the global namespace is always a scope candidate when looking-up for a non-member overload operator identifier from another scope, because this operator identifier cannot be used with a qualifier prefix but always as an unqualified identifier (seen from the operator call, the global namespace is either the current namescape or a parent namescape).

*Identifier look-ups for the Using commands*

The look-up for the Using command identifiers follows rules similar to those of a Type.

Examples

The following four codes test different look-ups both for one unqualified and one qualified identifier of procedures defined in different scope cases (from the highest to the lowest priority hierarchy):

```freebasic
Sub duplicateSub()

    Print "   ..duplicateSub"

End Sub

Namespace M

    Sub duplicateSub()

        Print "   M.duplicateSub"

    End Sub

End Namespace

Namespace N

    Sub duplicateSub()

        Print "   N.duplicateSub"

    End Sub

    Namespace P

        Using M

        Sub duplicateSub()

            Print "   N.P.duplicateSub"

        End Sub

        Sub test()

            Using M  '' useless, but just to demonstrate that does not increase priority level of imported namespace

            duplicateSub()

        End Sub

    End Namespace

End Namespace

Print "From Namespace:"

' "N.P.test()" calls the unqualified identifier "duplicateSub"

' "N.P.duplicateSub()" calls the qualified identifier "N.P.duplicateSub"

N.P.test()               '' "N.P.duplicateSub" expected : in (1) current namespace/type

N.P.duplicateSub()       '' "N.P.duplicateSub" expected : in (1) current namespace/type

Print

Sleep
```

```freebasic
Sub duplicateSub()

    Print "   ..duplicateSub"

End Sub

Namespace M

    Sub duplicateSub()

        Print "   M.duplicateSub"

    End Sub

End Namespace

Namespace N

    Sub duplicateSub()

        Print "   N.duplicateSub"

    End Sub

    Namespace P

        Using M

        'Sub duplicateSub()

        '    Print "   N.P.duplicateSub"

        'End Sub

        Sub test()

            Using M  '' useless, but just to demonstrate that does not increase priority level of imported namespace

            duplicateSub()

        End Sub

    End Namespace

End Namespace

Print "From Namespace:"

' "N.P.test()" calls the unqualified identifier "duplicateSub"

' "N.P.duplicateSub()" calls the qualified identifier "N.P.duplicateSub"

N.P.test()               '' "N.duplicateSub" expected : in [3] parent namespaces (by nesting)

N.P.duplicateSub()       '' "M.duplicateSub" expected : in [4] imported namespaces (by 'Using')

Print

Sleep
```

```freebasic
Sub duplicateSub()

    Print "   ..duplicateSub"

End Sub

Namespace M

    Sub duplicateSub()

        Print "   M.duplicateSub"

    End Sub

End Namespace

Namespace N

    'Sub duplicateSub()

    '    Print "   N.duplicateSub"

    'End Sub

    Namespace P

        Using M

        'Sub duplicateSub()

        '    Print "   N.P.duplicateSub"

        'End Sub

        Sub test()

            Using M  '' useless, but just to demonstrate that does not increase priority level of imported namespace

            duplicateSub()

        End Sub

    End Namespace

End Namespace

Print "From Namespace:"

' "N.P.test()" calls the unqualified identifier "duplicateSub"

' "N.P.duplicateSub()" calls the qualified identifier "N.P.duplicateSub"

N.P.test()               '' "..duplicateSub" expected : in [3] parent namespaces (by nesting)

N.P.duplicateSub()       '' "M.duplicateSub" expected : in [4] imported namespaces (by 'Using')

Print

Sleep
```

```freebasic
'Sub duplicateSub()

'    Print "   ..duplicateSub"

'End Sub

Namespace M

    Sub duplicateSub()

        Print "   M.duplicateSub"

    End Sub

End Namespace

Namespace N

    'Sub duplicateSub()

    '    Print "   N.duplicateSub"

    'End Sub

    Namespace P

        Using M

        'Sub duplicateSub()

        '    Print "   N.P.duplicateSub"

        'End Sub

        Sub test()

            Using M  '' useless, but just to demonstrate that does not increase priority level of imported namespace

            duplicateSub()

        End Sub

    End Namespace

End Namespace

Print "From Namespace:"

' "N.P.test()" calls the unqualified identifier "duplicateSub"

' "N.P.duplicateSub()" calls the qualified identifier "N.P.duplicateSub"

N.P.test()               '' "M.duplicateSub" expected : in [4] imported namespaces (by 'Using')

N.P.duplicateSub()       '' "M.duplicateSub" expected : in [4] imported namespaces (by 'Using')

Print

Sleep
```

The following six codes test different look-ups both for one unqualified and one qualified identifier of variables defined in different scope cases (from the highest to the lowest priority hierarchy):

```freebasic
Dim Shared As ZString * 32 duplicateVar = "   ..duplicateVar"

Namespace M

    Dim As ZString *32 duplicateVar = "   M.duplicateVar"

End Namespace

Namespace N

    Using M

    Dim As ZString * 32 duplicateVar = "   N.duplicateVar"

    Type Parent Extends Object

        Dim As ZString * 32 duplicateVar = "   N.Parent.duplicateVar"

    End Type

    Type Child Extends Parent

        Dim As ZString * 32 duplicateVar = "   N.Child.duplicateVar"

    End Type

    Type GrandChild Extends Child

        Dim As ZString * 32 duplicateVar = "   N.GrandChild.duplicateVar"

        Declare Sub test()

    End Type

    Sub GrandChild.test()

        Using M  '' useless, but just to demonstrate that does not increase priority level of imported namespace

        Print duplicateVar

    End Sub

End Namespace

Print "From Type:"

Dim As N.GrandChild gc

' "gc.test()" calls the unqualified identifier "duplicateVar"

' "Print gc.duplicateVar" calls the qualified identifier "gc.duplicateVar"

gc.test()                '' "N.GrandChild.duplicateVar" expected : in [1] current namespace/type

Print gc.duplicateVar    '' "N.GrandChild.duplicateVar" expected : in [1] current namespace/type

Print

Sleep
```

```freebasic
Dim Shared As ZString * 32 duplicateVar = "   ..duplicateVar"

Namespace M

    Dim As ZString *32 duplicateVar = "   M.duplicateVar"

End Namespace

Namespace N

    Using M

    Dim As ZString * 32 duplicateVar = "   N.duplicateVar"

    Type Parent Extends Object

        Dim As ZString * 32 duplicateVar = "   N.Parent.duplicateVar"

    End Type

    Type Child Extends Parent

        Dim As ZString * 32 duplicateVar = "   N.Child.duplicateVar"

    End Type

    Type GrandChild Extends Child

        'Dim As Zstring * 32 duplicateVar = "   N.GrandChild.duplicateVar"

        Declare Sub test()

    End Type

    Sub GrandChild.test()

        Using M  '' useless, but just to demonstrate that does not increase priority level of imported namespace

        Print duplicateVar

    End Sub

End Namespace

Print "From Type:"

Dim As N.GrandChild gc

' "gc.test()" calls the unqualified identifier "duplicateVar"

' "Print gc.duplicateVar" calls the qualified identifier "gc.duplicateVar"

gc.test()                '' "N.Child.duplicateVar" expected : in [2] base types (by 'Extends')

Print gc.duplicateVar    '' "N.Child.duplicateVar" expected : in [2] base types (by 'Extends')

Print

Sleep
```

```freebasic
Dim Shared As ZString * 32 duplicateVar = "   ..duplicateVar"

Namespace M

    Dim As ZString *32 duplicateVar = "   M.duplicateVar"

End Namespace

Namespace N

    Using M

    Dim As ZString * 32 duplicateVar = "   N.duplicateVar"

    Type Parent Extends Object

        Dim As ZString * 32 duplicateVar = "   N.Parent.duplicateVar"

    End Type

    Type Child Extends Parent

        'Dim As Zstring * 32 duplicateVar = "   N.Child.duplicateVar"

    End Type

    Type GrandChild Extends Child

        'Dim As Zstring * 32 duplicateVar = "   N.GrandChild.duplicateVar"

        Declare Sub test()

    End Type

    Sub GrandChild.test()

        Using M  '' useless, but just to demonstrate that does not increase priority level of imported namespace

        Print duplicateVar

    End Sub

End Namespace

Print "From Type:"

Dim As N.GrandChild gc

' "gc.test()" calls the unqualified identifier "duplicateVar"

' "Print gc.duplicateVar" calls the qualified identifier "gc.duplicateVar"

gc.test()                '' "N.Parent.duplicateVar" expected : in [2] base types (by 'Extends')

Print gc.duplicateVar    '' "N.Parent.duplicateVar" expected : in [2] base types (by 'Extends')

Print

Sleep
```

```freebasic
Dim Shared As ZString * 32 duplicateVar = "   ..duplicateVar"

Namespace M

    Dim As ZString *32 duplicateVar = "   M.duplicateVar"

End Namespace

Namespace N

    Using M

    Dim As ZString * 32 duplicateVar = "   N.duplicateVar"

    Type Parent Extends Object

        'Dim As Zstring * 32 duplicateVar = "   N.Parent.duplicateVar"

    End Type

    Type Child Extends Parent

        'Dim As Zstring * 32 duplicateVar = "   N.Child.duplicateVar"

    End Type

    Type GrandChild Extends Child

        'Dim As Zstring * 32 duplicateVar = "   N.GrandChild.duplicateVar"

        Declare Sub test()

    End Type

    Sub GrandChild.test()

        Using M  '' useless, but just to demonstrate that does not increase priority level of imported namespace

        Print duplicateVar

    End Sub

End Namespace

Print "From Type:"

Dim As N.GrandChild gc

' "gc.test()" calls the unqualified identifier "duplicateVar"

' "Print gc.duplicateVar" calls the qualified identifier "gc.duplicateVar"

gc.test()                '' "N.duplicateVar" expected : in [3] parent namespaces (by nesting)

'Print gc.duplicateVar   '' error

Print

Sleep
```

```freebasic
Dim Shared As ZString * 32 duplicateVar = "   ..duplicateVar"

Namespace M

    Dim As ZString *32 duplicateVar = "   M.duplicateVar"

End Namespace

Namespace N

    Using M

    'Dim As Zstring * 32 duplicateVar = "   N.duplicateVar"

    Type Parent Extends Object

        'Dim As Zstring * 32 duplicateVar = "   N.Parent.duplicateVar"

    End Type

    Type Child Extends Parent

        'Dim As Zstring * 32 duplicateVar = "   N.Child.duplicateVar"

    End Type

    Type GrandChild Extends Child

        'Dim As Zstring * 32 duplicateVar = "   N.GrandChild.duplicateVar"

        Declare Sub test()

    End Type

    Sub GrandChild.test()

        Using M  '' useless, but just to demonstrate that does not increase priority level of imported namespace

        Print duplicateVar

    End Sub

End Namespace

Print "From Type:"

Dim As N.GrandChild gc

' "gc.test()" calls the unqualified identifier "duplicateVar"

' "Print gc.duplicateVar" calls the qualified identifier "gc.duplicateVar"

gc.test()                '' "..duplicateVar" expected : in [3] parent namespaces (by nesting)

'Print gc.duplicateVar   '' error

Print

Sleep
```

```freebasic
'Dim Shared As Zstring * 32 duplicateVar = "   ..duplicateVar"

Namespace M

    Dim As ZString *32 duplicateVar = "   M.duplicateVar"

End Namespace

Namespace N

    Using M

    'Dim As Zstring * 32 duplicateVar = "   N.duplicateVar"

    Type Parent Extends Object

        'Dim As Zstring * 32 duplicateVar = "   N.Parent.duplicateVar"

    End Type

    Type Child Extends Parent

        'Dim As Zstring * 32 duplicateVar = "   N.Child.duplicateVar"

    End Type

    Type GrandChild Extends Child

        'Dim As Zstring * 32 duplicateVar = "   N.GrandChild.duplicateVar"

        Declare Sub test()

    End Type

    Sub GrandChild.test()

        Using M  '' useless, but just to demonstrate that does not increase priority level of imported namespace

        Print duplicateVar

    End Sub

End Namespace

Print "From Type:"

Dim As N.GrandChild gc

' "gc.test()" calls the unqualified identifier "duplicateVar"

' "Print gc.duplicateVar" calls the qualified identifier "gc.duplicateVar"

gc.test()                '' "M.duplicateVar" expected : in [4] imported namespaces (by 'Using')

'Print gc.duplicateVar   '' error

Print

Sleep
```

The following four codes test different look-ups both for one unqualified and one qualified identifier of types defined in different scope cases (from the highest to the lowest priority hierarchy):

```freebasic
Type duplicateType

    Dim As ZString * 32 root = "   ..duplicateType"

End Type

Namespace M

    Type duplicateType

        Dim As ZString * 32 root = "   M.duplicateType"

    End Type

End Namespace

Namespace N

    Type duplicateType

        Dim As ZString * 32 root = "   N.duplicateType"

    End Type

    Namespace P

        Using M

        Type duplicateType

            Dim As ZString * 32 root = "   N.P.duplicateType"

        End Type

        Sub test()

            Using M  '' useless, but just to demonstrate that does not increase priority level of imported namespace

            Print Type<duplicateType>.root

        End Sub

    End Namespace

End Namespace

' "N.P.test()" calls the unqualified identifier "duplicateType"

' "Print Type<N.P.duplicateType>.root" calls the qualified identifier "N.P.duplicateType"

Print "From Namespace:"

N.P.test()                          '' "N.P.duplicateSub" expected : in (1) current namespace/type

Print Type<N.P.duplicateType>.root  '' "N.P.duplicateSub" expected : in (1) current namespace/type

Print

Sleep
```

```freebasic
Type duplicateType

    Dim As ZString * 32 root = "   ..duplicateType"

End Type

Namespace M

    Type duplicateType

        Dim As ZString * 32 root = "   M.duplicateType"

    End Type

End Namespace

Namespace N

    Type duplicateType

        Dim As ZString * 32 root = "   N.duplicateType"

    End Type

    Namespace P

        Using M

        'Type duplicateType

        '    Dim As Zstring * 32 root = "   N.P.duplicateType"

        'End type

        Sub test()

            Using M  '' useless, but just to demonstrate that does not increase priority level of imported namespace

            Print Type<duplicateType>.root

        End Sub

    End Namespace

End Namespace

' "N.P.test()" calls the unqualified identifier "duplicateType"

' "Print Type<N.P.duplicateType>.root" calls the qualified identifier "N.P.duplicateType"

Print "From Namespace:"

N.P.test()                          '' "N.duplicateSub" expected : in [3] parent namespaces (by nesting)

Print Type<N.P.duplicateType>.root  '' "M.duplicateSub" expected : in [4] imported namespaces (by 'Using')

Print

Sleep
```

```freebasic
Type duplicateType

    Dim As ZString * 32 root = "   ..duplicateType"

End Type

Namespace M

    Type duplicateType

        Dim As ZString * 32 root = "   M.duplicateType"

    End Type

End Namespace

Namespace N

    'Type duplicateType

    '    Dim As Zstring * 32 root = "   N.duplicateType"

    'End type

    Namespace P

        Using M

        'Type duplicateType

        '    Dim As Zstring * 32 root = "   N.P.duplicateType"

        'End type

        Sub test()

            Using M  '' useless, but just to demonstrate that does not increase priority level of imported namespace

            Print Type<duplicateType>.root

        End Sub

    End Namespace

End Namespace

' "N.P.test()" calls the unqualified identifier "duplicateType"

' "Print Type<N.P.duplicateType>.root" calls the qualified identifier "N.P.duplicateType"

Print "From Namespace:"

N.P.test()                          '' "..duplicateSub" expected : in [3] parent namespaces (by nesting)

Print Type<N.P.duplicateType>.root  '' "M.duplicateSub" expected : in [4] imported namespaces (by 'Using')

Print

Sleep
```

```freebasic
'Type duplicateType

'    Dim As Zstring * 32 root = "   ..duplicateType"

'End type

Namespace M

    Type duplicateType

        Dim As ZString * 32 root = "   M.duplicateType"

    End Type

End Namespace

Namespace N

    'Type duplicateType

    '    Dim As Zstring * 32 root = "   N.duplicateType"

    'End type

    Namespace P

        Using M

        'Type duplicateType

        '    Dim As Zstring * 32 root = "   N.P.duplicateType"

        'End type

        Sub test()

            Using M  '' useless, but just to demonstrate that does not increase priority level of imported namespace

            Print Type<duplicateType>.root

        End Sub

    End Namespace

End Namespace

' "N.P.test()" calls the unqualified identifier "duplicateType"

' "Print Type<N.P.duplicateType>.root" calls the qualified identifier "N.P.duplicateType"

Print "From Namespace:"

N.P.test()                          '' "M.duplicateSub" expected : in [4] imported namespaces (by 'Using')

Print Type<N.P.duplicateType>.root  '' "M.duplicateSub" expected : in [4] imported namespaces (by 'Using')

Print

Sleep
```

The following four codes test different look-ups both for one unqualified and one qualified identifier of enums defined in different scope cases (from the highest to the lowest priority hierarchy):

```freebasic
Dim Shared As ZString * 32 root(...) = {"   ..duplicateEnum", "   M.duplicateEnum", "   N.duplicateEnum", "   N.P.duplicateEnum"}

Enum duplicateEnum

    nb = 0

End Enum

Namespace M

    Enum duplicateEnum

        nb = 1

    End Enum

End Namespace

Namespace N

    Enum duplicateEnum

        nb = 2

    End Enum

    Namespace P

        Using M

        Enum duplicateEnum

            nb = 3

        End Enum

        Sub test()

            Using M  '' useless, but just to demonstrate that does not increase priority level of imported namespace

            Print root(duplicateEnum.nb)

        End Sub

    End Namespace

End Namespace

' "N.P.test()" calls the unqualified identifier "duplicateEnum"

' "Print root(N.P.duplicateEnum.nb)" calls the qualified identifier "N.P.duplicateEnum"

Print "From Namespace:"

N.P.test()                        '' "N.P.duplicateEnum" expected : in (1) current namespace/type

Print root(N.P.duplicateEnum.nb)  '' "N.P.duplicateEnum" expected : in (1) current namespace/type

Print

Sleep
```

```freebasic
Dim Shared As ZString * 32 root(...) = {"   ..duplicateEnum", "   M.duplicateEnum", "   N.duplicateEnum", "   N.P.duplicateEnum"}

Enum duplicateEnum

    nb = 0

End Enum

Namespace M

    Enum duplicateEnum

        nb = 1

    End Enum

End Namespace

Namespace N

    Enum duplicateEnum

        nb = 2

    End Enum

    Namespace P

        Using M

        'Enum duplicateEnum

        '    nb = 3

        'End Enum

        Sub test()

            Using M  '' useless, but just to demonstrate that does not increase priority level of imported namespace

            Print root(duplicateEnum.nb)

        End Sub

    End Namespace

End Namespace

' "N.P.test()" calls the unqualified identifier "duplicateEnum"

' "Print root(N.P.duplicateEnum.nb)" calls the qualified identifier "N.P.duplicateEnum"

Print "From Namespace:"

N.P.test()                        '' "N.duplicateEnum" expected : in [3] parent namespaces (by nesting)

Print root(N.P.duplicateEnum.nb)  '' "M.duplicateEnum" expected : in [4] imported namespaces (by 'Using')

Print

Sleep
```

```freebasic
Dim Shared As ZString * 32 root(...) = {"   ..duplicateEnum", "   M.duplicateEnum", "   N.duplicateEnum", "   N.P.duplicateEnum"}

Enum duplicateEnum

    nb = 0

End Enum

Namespace M

    Enum duplicateEnum

        nb = 1

    End Enum

End Namespace

Namespace N

    'Enum duplicateEnum

    '    nb = 2

    'End Enum

    Namespace P

        Using M

        'Enum duplicateEnum

        '    nb = 3

        'End Enum

        Sub test()

            Using M  '' useless, but just to demonstrate that does not increase priority level of imported namespace

            Print root(duplicateEnum.nb)

        End Sub

    End Namespace

End Namespace

' "N.P.test()" calls the unqualified identifier "duplicateEnum"

' "Print root(N.P.duplicateEnum.nb)" calls the qualified identifier "N.P.duplicateEnum"

Print "From Namespace:"

N.P.test()                        '' "..duplicateEnum" expected : in [3] parent namespaces (by nesting)

Print root(N.P.duplicateEnum.nb)  '' "M.duplicateEnum" expected : in [4] imported namespaces (by 'Using')

Print

Sleep
```

```freebasic
Dim Shared As ZString * 32 root(...) = {"   ..duplicateEnum", "   M.duplicateEnum", "   N.duplicateEnum", "   N.P.duplicateEnum"}

'Enum duplicateEnum

'    nb = 0

'End Enum

Namespace M

    Enum duplicateEnum

        nb = 1

    End Enum

End Namespace

Namespace N

    'Enum duplicateEnum

    '    nb = 2

    'End Enum

    Namespace P

        Using M

        'Enum duplicateEnum

        '    nb = 3

        'End Enum

        Sub test()

            Using M  '' useless, but just to demonstrate that does not increase priority level of imported namespace

            Print root(duplicateEnum.nb)

        End Sub

    End Namespace

End Namespace

' "N.P.test()" calls the unqualified identifier "duplicateEnum"

' "Print root(N.P.duplicateEnum.nb)" calls the qualified identifier "N.P.duplicateEnum"

Print "From Namespace:"

N.P.test()                        '' "M.duplicateEnum" expected : in [4] imported namespaces (by 'Using')

Print root(N.P.duplicateEnum.nb)  '' "M.duplicateEnum" expected : in [4] imported namespaces (by 'Using')

Print

Sleep
```

Version


See also

- [Identifier Rules](Identifier-Rules)

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
