[Home](Home) › [Tutorials](Category-Tutorials) › **Member Access Rights and Encapsulation**

# Member Access Rights and Encapsulation

Restricting member access to certain parts of code.

Member Access Rights

*Overview*

All members of a [`Type`](Type-Udt) - including member data, procedures, constants, etc. - belong in one of three different classifications, each with its own rules dictating where in code they may be accessed, or referred to.  
 These rules are called access rights.  
 There are public, protected and private members, and they are declared in a [`Type`](Type-Udt) definition following a [`Public`](Public-Access-Control), [`Protected`](Protected-Access-Control) or [`Private`](Private-Access-Control) label, respectively.

 By default, that is, without an access classification label, members of a [`Type`](Type-Udt) are public.

*Public members*

Public members can be referred to from anywhere; they are accessible from, for example, member procedures or module-level code or procedures.

*Protected members*

Protected members can only be accessed from member procedures of the [`Type`](Type-Udt) they are declared in, or member procedures of a derived [`Type`](Type-Udt). They are not accessible to outside code.

*Private members*

Private members can only be accessed from member procedures of the [`Type`](Type-Udt) they are declared in. They are not accessible to outside code or member procedures from a derived [`Type`](Type-Udt).

*Constructors and destructors*

Constructors and destructors follow the same rules as any other member:

**-** When public, objects can be instantiated and destroyed from anywhere in code.
 **-** When protected, objects can be instantiated and destroyed only from member procedures of their [`Type`](Type-Udt) or a derived [`Type`](Type-Udt).
 **-** Private constructors and destructors restrict object instantiation solely to member procedures of their [`Type`](Type-Udt).

Encapsulation

*Overview*

Encapsulation is the process of keeping the details about how an object is implemented hidden away from users of the object.  
 Instead, users of the object access the object through a public interface.  
 In this way, users are able to use the object without having to understand how it is implemented.

 Encapsulation is implemented via access specifiers (Private, Protected or Public).  
 Typically, all member variables of the [`Type`](Type-Udt) are made private (hiding the implementation details), and most member procedures are made public (exposing an interface for the user).  
 Although requiring users of the [`Type`](Type-Udt) to use the public interface may seem more burdensome than providing public access to the member variables directly, doing so actually provides a large number of useful benefits that help encourage [`Type`](Type-Udt) re-usability and maintainability.

*Benefit of encapsulated Types*

**Protection:**

Global access to variables is dangerous because you don’t have strict control over who has access to the global variable, or how they use it.  
 Only the public members of a [`Type`](Type-Udt) suffers from the same problem, but just on a smaller scale.

 Encapsulation allows the programmer of a [`Type`](Type-Udt) to:

**-** Actively control the access to its internals (pointers, variables, ...), by: none / read only / write only / read & write.
 **-** Secure operations, by denying certain destructive user actions (like pointer overwriting, deallocating, ...)

**Abstraction:**

With a fully encapsulated [`Type`](Type-Udt), you only need to know what member procedures are publicly available to use the [`Type`](Type-Udt), what arguments they take, and what values they return. It doesn’t matter how the [`Type`](Type-Udt) was implemented internally.

 For example, a [`Type`](Type-Udt) holding a list of names could have been implemented using different data structures.  
 In order to use the [`Type`](Type-Udt), you don’t need to know (or care) which.  
 This dramatically reduces the complexity of your programs, and also reduces mistakes.

 Hiding the internal implementation details:

**-** internal members declared as Private/Protected and user interface using methods and properties as getter/setter,
 **-** in addition to define constructors, copy-constructor, destructor, assignment operators, ... ,

provides some abstraction.  
 More than any other reason, this is the key advantage of encapsulation.

Examples

- In the example below, the data member `hour`, `minute`, and `second` are private while the member procedures `set_Time()`, `get_Time()` and `increment_Time()` are public:

**-** As all data is declared as private, the data is only accessible through the public procedures provided by the [`Type`](Type-Udt).
 **-** This also allows programmers to validate changes to data members before making such a change. In this example, the `set_Time()` procedure would be written to check to valid values for time (hour between 0 and 23, minute and second between 0 and 59).

```freebasic
Type my_Time

    Public:

        Declare Sub set_Time (ByVal new_Hour As UByte, ByVal new_Minute As UByte, ByVal new_Second As UByte)

        Declare Sub get_Time (ByRef curr_Hour As UByte, ByRef curr_Minute As UByte, ByRef curr_Second As UByte)

        Declare Function get_Time () As String

        Declare Sub increment_Time ()

    Private:

        Dim As UByte Hour

        Dim As UByte Minute

        Dim As UByte Second

End Type
```

Example of use:

```freebasic
Type my_Time

    Public:

        Declare Sub set_Time (ByVal new_Hour As UByte, ByVal new_Minute As UByte, ByVal new_Second As UByte)

        Declare Sub get_Time (ByRef curr_Hour As UByte, ByRef curr_Minute As UByte, ByRef curr_Second As UByte)

        Declare Function get_Time () As String

        Declare Sub increment_Time ()

    Private:

        Dim As UByte Hour

        Dim As UByte Minute

        Dim As UByte Second

End Type

Sub my_Time.set_Time (ByVal new_Hour As UByte, ByVal new_Minute As UByte, ByVal new_Second As UByte)

    If new_Hour <= 23 And new_Minute <= 59 And New_Second <= 59 Then

        This.Hour = new_Hour

        This.Minute = new_Minute

        This.Second = new_Second

    End If

End Sub

Sub my_Time.get_Time (ByRef curr_Hour As UByte, ByRef curr_Minute As UByte, ByRef curr_Second As UByte)

    curr_Hour = This.Hour

    curr_Minute = This.Minute

    curr_Second = This.Second

End Sub

Function my_Time.get_Time () As String

    Return Right("0" & Str(This.Hour), 2) & ":" & Right("0" & Str(This.Minute), 2) & ":" & Right("0" & Str(This.second), 2)

End Function

Sub my_Time.increment_Time ()

    This.Second += 1

    If This.Second = 60 Then

        This.Second = 0

        This.Minute += 1

        If This.Minute = 60 Then

            This.Minute = 0

            This.Hour += 1

            If This.Hour = 24 Then

                This.Hour = 0

            End If

        End If

    End If

End Sub

Dim As my_Time my_T

Dim As UByte h, m, s

Input "Hour? ", h

Input "Minute? ", m

Input "Second? ", s

my_T.set_Time(h, m, s)

Print

Dim As Double Tr = Int(Timer)

Do

    If Tr <> Int(Timer) Then

        Tr = Int(Timer)

        my_T.increment_Time()

        Locate  , 1, 0

        Print my_T.get_Time;

    End If

    Sleep 100, 1

Loop Until Inkey <> ""

Print
```

- For a more advanced example using OOP (with encapsulation + abstraction + inheritance + polymorphism), see the example (Graph type collection) in ['Inheritance Polymorphism'](Inheritance-Polymorphism).

See also

- [Properties](Properties)

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
