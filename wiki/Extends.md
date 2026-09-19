[Home](Home) › [User Defined Types](Category-User-Defined-Types) › **Extends**

# Extends

Specifies a base type from which to derive a new type

## Syntax

```freebasic
Type|Union typename Extends base_typename
...
End Type|Union
```

## Description

`Extends` declares `typename` to be derived from `base_typename`. The derived user-defined type, `typename`, inherits fields and methods of the `base_typename` base type. `typename` objects may be used in place of `base_typename` objects. Fields and methods inherited from `base_typename` will be implicitly accessible like members of `typename`.  
 However, a member will shadow an inherited member if they have the same identifier. The [`Base (Member Access)`](Base-Member-Access) keyword can be used to explicitly access members of the base type shadowed by local members.

 User-defined types that extend another type will include the base type structure at their beginning, and their size as reported by [`Sizeof()`](Sizeof) is the sum of their base type's size plus the size needed for any regular data fields (non-static data fields). Since the inherited members make sure that the structure is not empty, a derived type is not required to have regular data fields of its own.

 In `typename` (the derived user-defined type), the fields can share the same memory space than the `base_typename` only if `typename` is a [`Union`](Union). Here it does not matter whether `base_typename` is a [`Union`](Union) or not.  
 If only `base_typename` is a [`Union`](Union), then it will not be affected by fields from `typename` (the derived user-defined type).  
 As a [`Union`](Union) is not allowed to have complex fields (i.e. user-defined types with constructor/destructor, or dynamic strings), a derived [`Union`](Union) cannot be allowed to have (contain) a complex `base_typename`.

 The [`Base (Initializer)`](Base-Initializer) keyword can be used at the top of constructor of derived user-defined type. It allows to specify an initializer or constructor call for the base type.

 Extending the built-in [`Object`](Object) type allows a user-defined type to be used with [`Operator Is`](Operator-Is-Run-Time-Type-Information) to perform run-time type checks, to support [`Virtual`](Virtual) and [`Abstract`](Abstract) methods, and to use the [`Override`](Override) method attribute.

 **Note:** UDT pointer can only be cast to pointer types of "widened compatibility" (up or even down in the inheritance hierarchy), or to `Any Ptr`. Otherwise, cast to `Any Ptr` first (or to `Object Ptr` first if both types are directly or indirectly derived from [`Object`](Object)).

## Remarks

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Extends`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Type`](Type-Udt)
- [`Union`](Union)
- [`Base (Initializer)`](Base-Initializer)
- [`Base (Member Access)`](Base-Member-Access)
- [`Object`](Object)
- [`Operator Is`](Operator-Is-Run-Time-Type-Information)
- [`Virtual`](Virtual)
- [`Abstract`](Abstract)
- [`Override`](Override)
- [`Extends Zstring`](Extends-Zstring)
- [`Extends Wstring`](Extends-Wstring)

## Examples

```freebasic
Type SchoolMember 'Represents any school member'

    Declare Constructor ()

    Declare Sub Init (ByRef _name As String, ByVal _age As Integer)

    As String Name

    As Integer age

End Type

Constructor SchoolMember ()

    Print "Initialized SchoolMember"

End Constructor

Sub SchoolMember.Init (ByRef _name As String, ByVal _age As Integer)

    This.name = _name

    This.age = _age

    Print "Name: "; This.name; "   Age:"; This.age

End Sub

Type Teacher Extends SchoolMember 'Represents a teacher derived from SchoolMember'

    Declare Constructor (ByRef _name As String, ByVal _age As Integer, ByVal _salary As Integer)

    As Integer salary

    Declare Sub Tell ()

End Type

Constructor Teacher (ByRef _name As String, ByVal _age As Integer, ByVal _salary As Integer)

    Print "Initialized Teacher"

    This.Init(_name, _age) 'implicit access to base member procedure'

    This.salary = _salary

End Constructor

Sub Teacher.Tell ()

    Print "Salary:"; This.salary

End Sub

Type Student Extends SchoolMember 'Represents a student derived from SchoolMember'

    Declare Constructor (ByRef _name As String, ByVal _age As Integer, ByVal _marks As Integer)

    As Integer marks

    Declare Sub Tell ()

End Type

Constructor Student (ByRef _name As String, ByVal _age As Integer, ByVal _marks As Integer)

    Print "Initialized Student"

    This.Init(_name, _age) 'implicit access to base member procedure'

    This.marks = _marks

End Constructor

Sub Student.Tell ()

    Print "Marks:"; This.marks

End Sub

Dim As Teacher t = Teacher("Mrs. Shrividya", 40, 30000)

t.Tell()

Print

Dim As Student s = Student("Swaroop", 22, 75)

s.Tell()
```

```freebasic
' Example using all eight keywords of inheritance:

'   'Extends', 'Base.', 'Base()', 'Object', 'Is' operator, 'Virtual', 'Abstract', 'Override'

Type root Extends Object ' 'Extends' to activate RTTI by inheritance of predefined Object type

  Declare Function ObjectHierarchy () As String

  Declare Abstract Function ObjectRealType () As String ' 'Abstract' declares function without local body

                                                        '    which must be overriden

  Dim Name As String

  Declare Virtual Destructor () ' 'Virtual' declares destructor with body ('Abstract' forbidden)

Protected:

  Declare Constructor () ' to avoid user construction from root

  Declare Constructor (ByRef rhs As root) '' to avoid user copy-construction from root

End Type ' derived type may be member data empty

Constructor root ()

End Constructor

Function root.ObjectHierarchy () As String

  Return "Object(forRTTI) <- root"

End Function

Virtual Destructor root ()

  Print "root destructor"

End Destructor

Type animal Extends root ' 'Extends' to inherit of root

  Declare Constructor (ByRef _name As String = "")

  Declare Function ObjectHierarchy () As String

  Declare Virtual Function ObjectRealType () As String Override ' 'Virtual' declares function with local

                                                                '    body which can be overriden

                                                                ' 'Override' to check if the function is

                                                                '    well an override

  Declare Virtual Destructor () Override ' 'Virtual' declares destructor with local body

                                         ' 'Override' to check if the destructor is well an override

End Type

Constructor animal (ByRef _name As String = "")

  This.name = _name

End Constructor

Function animal.ObjectHierarchy () As String

  Return Base.ObjectHierarchy & " <- animal" ' 'Base.' allows to access to parent member function

End Function

Virtual Function animal.ObjectRealType () As String

  Return "animal"

End Function

Virtual Destructor animal ()

  Print "  animal destructor: " & This.name

End Destructor

Type dog Extends animal ' 'Extends' to inherit of animal

  Declare Constructor (ByRef _name As String = "")

  Declare Function ObjectHierarchy () As String

  Declare Function ObjectRealType () As String Override ' 'Override' to check if the function is well an

                                                        '    override

  Declare Destructor () Override ' 'Override' to check if the destructor is well an override

End Type ' derived type may be member data empty

Constructor dog (ByRef _name As String = "")

  Base(_name) ' 'Base()' allows to call parent constructor

End Constructor

Function dog.ObjectHierarchy () As String

  Return Base.ObjectHierarchy & " <- dog" ' 'Base.' allows to access to parent member function

End Function

Function dog.ObjectRealType () As String

  Return "dog"

End Function

Destructor dog ()

  Print "    dog destructor: " & This.name

End Destructor

Type cat Extends animal ' 'Extends' to inherit of animal

  Declare Constructor (ByRef _name As String = "")

  Declare Function ObjectHierarchy () As String

  Declare Function ObjectRealType () As String Override ' 'Override' to check if the function is well an

                                                        '    override

  Declare Destructor () Override ' 'Override' to check if the destructor is well an override

End Type ' derived type may be member data empty

Constructor cat (ByRef _name As String = "")

  Base(_name) ' 'Base()' allows to call parent constructor

End Constructor

Function cat.ObjectHierarchy () As String

  Return Base.ObjectHierarchy & " <- cat" ' 'Base.' allows to access to parent member function

End Function

Function cat.ObjectRealType () As String

  Return "cat"

End Function

Destructor cat ()

  Print "    cat destructor: " & This.name

End Destructor

Sub PrintInfo (ByVal p As root Ptr) ' must be put after definition of animal type, dog type and cat type

  Print "  " & p->Name, "  " & p->ObjectRealType, "           ";

  If *p Is dog Then ' 'Is' allows to check compatibility with type symbol

    Print  Cast(dog Ptr, p)->ObjectHierarchy

  ElseIf *p Is cat Then ' 'Is' allows to check compatibility with type symbol

    Print Cast(cat Ptr, p)->ObjectHierarchy

  ElseIf *p Is animal Then ' 'Is' allows to check compatibility with type symbol

    Print Cast(animal Ptr, p)->ObjectHierarchy

  End If

End Sub

Print "Name:", "Object (real):         Hierarchy:"

Dim a As root Ptr = New animal("Mouse")

PrintInfo(a)

Dim d As root Ptr = New dog("Buddy")

PrintInfo(d)

Dim c As root Ptr = New cat("Tiger")

Printinfo(c)

Print

Delete a

Delete d

Delete c
```

---

**Category:** [User Defined Types](Category-User-Defined-Types)  
**Kind:** type

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
