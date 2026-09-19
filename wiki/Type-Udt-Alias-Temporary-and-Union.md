[Home](Home) › [Tutorials](Category-Tutorials) › **Type (UDT/Alias/Temporary) and Union**

# Type (UDT/Alias/Temporary) and Union

The different keywords **Type (UDT)**, **Type (Alias)**, **Type (Temporary)**, and **Union**.

Definition

There may be confusion in the user mind between the different keywords **Type** and **Union** (despite the documentation that distinguishes them from each other through some different pages):

Declares/Defines a user structure of non overlapping data with possibly member procedures:

**- Named Type**: Type that has a name that can be referenced to declare the data type.
 **- Anonymous Type**: Type that does not have a name and so cannot be referenced by a name.

Declares a user defined type name from other user defined or standard data types.

Creates a temporary instance of a user defined type.

Declares/Defines a user structure of overlapping data with possibly member procedures but no object fields (or bases) with constructors or destructors (directly on indirectly):

**- Named Union**: Union that has a name that can be referenced to declare the data type.
 **- Anonymous Union**: Union that does not have a name and so cannot be referenced by a name.

Complexity level for a Type/Union structure:

**- Trivial structure**: Named or Anonymous structure that has no member procedures (directly on indirectly).
 **- Complex structure**: Named Structure that has member procedure(s) (directly or indirectly).
 **- Extended structure**: Named structure that inherits from another named structure.

Type/Union structure can be also nested inside another Type/Union structure:

**- Nested Named Type**: Named Type that is nested inside another Named Type/Union structure.
 **- Nested Anonymous Type**: Anonymous Type that is nested inside another Named or Anonymous Union structure.
 **- Nested Named Union**: Named Union that is nested inside another Named Type/Union structure.
 **- Nested Anonymous Union**: Anonymous Union that is nested inside another Named or Anonymous Type structure.

Type (Alias) declaration can be also nested inside a Type/Union structure:

**-** Nested Type (Alias) declaration allows declaration of an inner alias inside a Type/Union and according to the access right of the place.

Description

The main purpose of Nested Named Types/Unions is:

**-** To allow relationships between Types and Unions to be expressed in an understandable way.
 **-** Such a Type or Union has its own namespace in which to organize related symbols - and provide visibility access ([`Public`](Public)/[`Protected`](Protected-Access-Control)/[`Private`](Private)) for Types only - to give finer-grained control over access to members.
 **-** When there are circular dependencies between Types/Unions, Nested Named Type/Union usage can avoid using Type (Alias) and forward referencing.

Without Nested Named Types/Unions:

**-** Relationships can still be expressed between Types/Unions but have the disadvantage that all Types/Unions must be publicly accessible.
 **-** [`Namespace`](Namespace) use can help organize scope of visibility but the problem remains that \*all\* Types/Unions must be visible.
 **-** In some situations this allows a user (or the author himself) to inadvertently use a Type/Union in a way that it was never intended, potentially creating valid but error-prone code.
 **-** This problem can be reduced by hiding Types/Unions through of forward declarations (via Type (Alias)) and putting private symbols in a separate module, but creates new problems by fragmenting the code.

Anonymous Type (or Union):

**-** Does not have a name and cannot be referenced by name.
 **-** May only appear nested within a Named Union (or Type) or another Anonymous Union (or Type) .
 **-** Declares fields within the structure that nests it, either at separate memory locations (Nested Type) or overlapping memory locations (Nested Union).
 **-** Fields can be referenced.
 **-** Cannot contain any static members or procedures declarations (directly or indirectly) => Trivial structure.

Named Type (or Union):

**-** Has a name that can be referenced to declare the data type for fields, variables, parameters, arrays, etc.
 **-** Can appear on its own or nested inside another Named Type (or Union).
 **-** Declaration of the Type (or Union) only.
 **-** Does not declare any fields within the structure that nests it, so it does not add any size to it.
 **-** Can contain static member(s) or procedure declaration(s) (directly or indirectly) => Trivial/Complex structure.

Complexity level for Type/Union structure versus scope location:

**-** Trivial structure: Named or Anonymous Type/Union that can be declared at global / namespace / nested scopes or inside local scopes (like Scope or Sub).
 **-** Complex structure: Named Type/Union that must be declared at the global / namespace / nested scope with definitions at the global / namespace scope.
 **-** Extended structure: Named Type/Union declared in a scope that has visibility to its Base's scope (currently in same scope than its Base).

The main structure (Type/Union) must be always Named, the other (Nested) structures can be Anonymous or Named.  
 Mostly everything it can be done in a Named Type/Union can also be done in a Nested Named Type/Union, including the inheritance capability (as base or as derived).  
 Nested Anonymous Type/Union can not have procedure members or static data members (same restriction than for a Named Type/Union inside a local scope).

Example

Example: 'Named Type' <- 'Nested Anonymous Union' <- 'Nested Anonymous Type':

```freebasic
Type T  '' named

    Union  '' anonymous

        Dim a As Short

        Type  '' anonymous

            Dim b1 As Byte

            Dim b2 As Byte

        End Type

    End Union

    Declare Sub proc()

End Type

Sub T.proc()

    b1 = 1

    b2 = 2

    Print b1, b2, a

End Sub

Dim x As T

x.proc()

Sleep
```

Example of circular dependencies between two main types solved by Nested Named Type usage (to avoid using type aliases and forward referencing):

```freebasic
'' example of two dependent types, with a type alias and a forward referencing:

'

'Type list As list_

'

'Type listnode

'    text As String

'    parent As list Ptr

'End Type

'

'Type list_

'    first As listnode Ptr

'    count As Integer

'End Type

'' same example of two dependent types, but with simply one of them a Nested Named Type:

Type list

    count As Integer

    Type listnode

        text As String

        parent As list Ptr

    End Type

    first As listnode Ptr

End Type
```

Example to check access syntaxes and access rights:

```freebasic
Type UDT1

    Private:

        Dim As Integer I1 = 123

        Type UDT2

            Private:

                Dim As Integer I2 = 456

            Public:

                Declare Function returnI2() As Integer

        End Type

    Public:

        Type UDT3

            Private:

                Dim As Integer I3 = 789

            Public:

                Declare Function returnI3() As Integer

        End Type

        Declare Function returnI1() As Integer

        Dim As UDT2 t2

        Dim As UDT3 t3

End Type

Function UDT1.returnI1() As Integer

    Return This.I1

End Function

Function UDT1.UDT2.returnI2() As Integer

    Return This.I2

End Function

Function UDT1.UDT3.returnI3() As Integer

    Return This.I3

End Function

Dim As UDT1 t11

'Print t11.I1            '' error 202: Illegal member access

                         ''    I1 is in the private section of UDT1

Print t11.returnI1()     '' OK, returnI1() is in the public section of UDT1

'Print t11.t2.I2         '' error 202: Illegal member access

                         ''    t2 is in the public section of UDT1, but I2 is in the private section of UDT2

Print t11.t2.returnI2()  '' OK, t2 is in the public section of UDT1, and returnI2() is in the public section of UDT2

'Print t11.t3.I3         '' error 202: Illegal member access

                         ''    t3 is in the public section of UDT1, but I3 is in the private section of UDT3

Print t11.t3.returnI3()  '' OK, t3 is in the public section of UDT1, and returnI3() is in the public section of UDT3

Print

'Dim As UDT1.UDT2 t21    '' error 202: Illegal member access

                         ''    UDT2 is in the private section of UDT1

Dim As UDT1.UDT3 t31     '' OK, UDT3 is in the public section of UDT1

'Print t31.I3            '' error 202: Illegal member access

                         ''    I3 is in the private section of UDT3

Print t31.returnI3()     '' OK, returnI3() is in the public section of UDT3

Sleep
```

Example of what we can do with nested named types.  
 This is just the declaration part, but gives a few things worth pointing out:

```freebasic
Type MemoryTable

    Private:

        '' private members visible within MemoryTable only

        Const default_alignment = 16

        m_bytes_per_node As UInteger = 0

        m_nodes_per_chunk As UInteger = 0

        Type Chunk

            m_owner As MemoryTable Ptr

            m_nodes As UInteger

            m_prevChunk As Chunk Ptr

            m_data As Any Ptr

        End Type

        Declare Sub allocChunk()

        m_headChunk As Chunk Ptr = 0

    Protected:

        '' protected members visible within MemoryTable and derived types

        Declare Constructor()

        Type Iterator

            Private:

                m_chunk As Chunk Ptr

                m_index As Integer

            Protected:

                Declare Constructor()

                Declare Constructor(ByVal table As MemoryTable Ptr)

                Declare Property item() As Any Ptr

            Public:

                Declare Property hasItem() As Boolean

                Declare Sub nextItem()

        End Type

        Declare Function newNode() As Any Ptr

    Public:

        '' public member visible from outside the type

        Declare Constructor(ByVal bytes As UInteger, nodes As UInteger)

        Declare Destructor()

End Type
```

See also

- [Overview (User Defined Types)](User-Defined-Types)
- [Type Aliases](Type-Aliases)
- [Temporary Types](Type-Temporary)
- [Constructors and Destructors (basics)](Constructors-and-Destructors-Basics)
- [Member Access Rights and Encapsulation](Member-Access-Rights-and-Encapsulation)

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
