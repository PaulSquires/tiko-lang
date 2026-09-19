[Home](Home) › [Tutorials](Category-Tutorials) › **Member Procedures**

# Member Procedures

Procedures with full access to members of a [`Type`](Type-Udt) or [`Class`](Class)

 **Declaration and definition**
 Declaring and defining member procedures.
 **Usage**
 Calling member procedures.
 **The hidden parameter, This**
 Implicit access to the instance with which non-static member procedures are called.
 **Access rights**
 Referring to other members in member procedures.
 **Overloading**
 Declaring two or more member procedures with the same name.
 **Static member procedures**
 Differences from non-static member procedures.

 *The term 'member procedure' refers to both static and non-static member procedures, unless otherwise noted.*

Declaration and definition

Member procedures are declared much like normal module-level procedures except that they are declared within, and defined outside, a [`Type`](Type-Udt) or [`Class`](Class) definition \[1\].

 When defining member procedures, the procedure name is prefixed with the name of the [`Type`](Type-Udt) or [`Class`](Class) and the member access operator ([`Operator . (Member Access)`](Operator-Member-Access)). It is an error to define a member procedure without a matching declaration in the [`Type`](Type-Udt) or [`Class`](Class) definition.

 The following example declares and defines a [`Sub`](Sub) and [`Function`](procedures-Function) member procedure:

```freebasic
'' foo1.bi

Type foo

    Declare Sub f (As Integer)

    Declare Function g As Integer

    i As Integer

End Type

Sub foo.f (n As Integer)

    Print n

End Sub

Function foo.g As Integer

    Return 420

End Function
```

Usage

Member procedures are referred to just like member data, that is, their name is prefixed with the name of an object instance and the member access operator ([`Operator . (Member Access)`](Operator-Member-Access)) \[2\].

 The following example, using the code from the last example, calls [`Sub`](Sub) and [`Function`](procedures-Function) member procedures:

```freebasic
'' ... foo with non-static members as before ...

#include Once "foo1.bi"

Dim bar As foo

bar.f(bar.g())
```

The hidden parameter, This

Member procedures actually have an additional parameter than what they are declared with \[3\]. When they are called, using the name of an instance and [`Operator . (Member Access)`](Operator-Member-Access), a reference to that instance is passed along with any other arguments in the call, allowing the member procedure direct access to the instance.

 The additional parameter added by the compiler is called [`This`](This), and since it's a reference, any modifications to [`This`](This) are actually modifications to the instance that was passed to the member procedure when it was called. You can use [`This`](This) just like any other variable, ie., pass it to procedures taking a object of the same type, call other member procedures and access member data using [`Operator . (Member Access)`](Operator-Member-Access), etc.

 Most of the time, however, using [`This`](This) explicitly is unnecessary; member procedures can refer to other members of the instance which they are passed directly by name, without having to qualify it with [`This`](This) and [`Operator . (Member Access)`](Operator-Member-Access). The only times when you need to qualify member names with [`This`](This) is when the member name is hidden, for example, by a parameter or local variable. In these situations, qualifying the member name is the only way to refer to these hidden member names.

```freebasic
Note:

To access duplicated symbols defined as global outside the Type, add one or preferably two dot(s) as prefix:
```

.SomeSymbol`or preferably`..SomeSymbol`(or only`..SomeSymbol`if inside a With..End With block).`

 The following example uses the [`This`](This) keyword to refer to member data whose name is hidden by a parameter and local variable:

```freebasic
Type foo

    Declare Sub f (i As Integer)

    Declare Sub g ()

    i As Integer = 420

End Type

Sub foo.f (i As Integer)

    '' A parameter hides T.i, so it needs to be qualified to be used:

    Print this.i

End Sub

Sub foo.g ()

    '' A local variable hides T.i, so it needs to be qualified to be used:

    Dim i As Integer

    Print this.i

End Sub
```

Access rights

Unlike normal module-level procedures, member procedures have full access rights to the members of the [`Type`](Type-Udt) or [`Class`](Class) they are declared in; they can refer to the public, protected and private members of a [`Type`](Type-Udt) or [`Class`](Class).

Overloading

A member procedure can be declared to have the same name as another member procedure, provided the parameters are different, either in number or in type. This is referred to as overloading.

 Only the parameters are used to determine if a procedure declaration is a valid overload. For example, a [`Type`](Type-Udt) or [`Class`](Class) could have static and non-static member procedures with the same name, or [`Sub`](Sub) and [`Function`](procedures-Function) member procedures with the same name

 Unlike a module-level procedure, which needs to specify the [`Overload`](Overload) clause in the declaration to allow overloading it, a member procedure is overloadable by default, and does not need the [`Overload`](Overload) clause.

```freebasic
Type T

    Declare Sub f

    '' Different number of parameters:

    Declare Sub f (As Integer)

    '' Different type of parameters:

    Declare Sub f (ByRef As String)

    '' Again, parameters are different:

    Declare Function f (As UByte) As Integer

    '' following three members would cause an error,

    '' number of parameters and/or types do not differ:

    '' Declare Function f As Integer

    '' Declare Function f (As UByte) As String

    '' Declare Static Function f (As UByte) As Integer

    '' ...

    somedata As Any Ptr

End Type
```

Static member procedures

Static member procedures are declared and defined much in the same way as non-static member procedures, with the [`Static`](procedures-Static) keyword preceding the declaration and definition.

 Member procedures defined using the [`Static`](procedures-Static) keyword must be declared with the [`Static`](procedures-Static) keyword in the [Type](Type-Udt) or [Class](Class) definition, or a compiler error will occur. Like non-static member procedures, it is an error to define a static member procedure without a matching declaration in the [Type](Type-Udt) or [Class](Class) definition.

 Do not confuse this with procedure definitions that specify static storage for their variables and objects by appending the [`Static`](procedures-Static) keyword to the procedure header. The [`Static`](procedures-Static) keyword can be used in both contexts, however; static member procedures can be defined with static variable and object storage.

 The following example declares two static member procedures, the first of which also has static variable and object storage. Note that the [`Static`](procedures-Static) keyword is optional in the member procedure definition:

```freebasic
'' foo2.bi

Type foo

    Declare Static Sub f (As Integer)

    Declare Static Function g As Integer

    i As Integer

End Type

Static Sub foo.f (n As Integer) Static

    Print n

End Sub

Function foo.g As Integer

    Return 420

End Function
```

 Static member procedures can be called like non-static member procedures, qualifying the name of the procedure with the name of an instance and the member access operator ([`Operator . (Member Access)`](Operator-Member-Access)).

 They can also be called by qualifying the procedure name with the name of the [`Type`](Type-Udt) or [`Class`](Class) they were declared in and the member access operator ([`Operator . (Member Access)`](Operator-Member-Access)). In other words, an instance is not required in order to call static-member procedures.

 The following example, using the code from the last example, uses both ways to call static member procedures:

```freebasic
'' ... foo with static members as before ...

#include Once "foo2.bi"

Dim bar As foo

bar.f(foo.g())
```

 Unlike non-static member procedures, which are declared with an extra [`This`](This) parameter, static member procedures do not get passed an instance when called. Because of this, static member procedures can only refer to constants, enumerations, other static members (data or procedures), etc., without qualifying their names. Static member procedures can still refer to non-static members when qualified with an instance, for example: a parameter or local variable.

 The following example refers to a non-static member from a static procedure:

```freebasic
Type foo

    Declare Static Sub f (ByRef As foo)

    i As Integer

End Type

Sub foo.f (ByRef self As foo)

    '' Ok, self is an instance of foo:

    Print self.i

    '' would cause error

    '' cannot access non-static members, no foo instance:

    '' Print i

End Sub
```

 \[1\] *In the future, member procedures may be able to be defined within the [`Type`](Type-Udt) or [`Class`](Class) definition.*  
 \[2\] *Static member procedures do not require an object instance in order to be called.*  
 \[3\] *Static member procedures do not have this extra parameter added by the compiler, and so cannot access the object instance from which it was called with.*

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
