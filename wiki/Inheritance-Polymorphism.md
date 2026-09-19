[Home](Home) › [Tutorials](Category-Tutorials) › **Inheritance Polymorphism**

# Inheritance Polymorphism

The **Inheritance Polymorphism** is the ability of calling from the base-type the member procedures of derived-types without worrying about the real type of the processed objects.

 **Preamble:**

 Inheritance polymorphism (sub-type polymorphism) is the concept of providing a single interface to entities that can have different types.  
 More precisely, a same interface is implemented by member procedures having the same identifier in each type belonging to the same inheritance hierarchy.

 Thanks to the 'abstract'/'virtual' procedures, one can write a code using only the base-type that will automatically call the derived-type procedures.  
 It is then possible to call the procedure of an object without worrying about its intrinsic type.

 By using the same procedure name for several different types, the polymorphism allows a much more generic programming (abstraction).  
 The coder does not have to know, when calling a base procedure, the precise type of object on which the procedure will apply. He just needs to know that this type will implement the procedure.

 For example a procedure *'moving()'* will perform the appropriate movement according to the real derived-type of the instance referenced at the time of the call. This will allow the program to say *'instance.moving()'* without having to worry about the real derived-type of *'instance'*.

Inheritance polymorphism operating

The ability to redefine a procedure in a derived-type inheriting from a base-type is called specialization.  
 It is then possible to call the procedure of an object without worrying about its intrinsic type: it is the inheritance polymorphism.

 This makes it possible to abstract the details of the specialized types of an object family, by masking them by a common interface which is the base-type.

 *Designation of objects using pointers or references of base-type*

Considering a collection of objects whose instantiate types are derived-types from a base-type, then all these objects can be manipulated in an uniform way by considering them as objects of the base-type.  
 Better, certain behaviors can be specialized according to the instantiate type of each object. In other words, the use of distinct objects of the same inheritance hierarchy is homogeneous even if the behavior of these objects remains specific.

 Thus, a base-type pointer or reference, pointing to an instance of a derived-type, can be used to manipulate such an object.

*Overriding the abstract/virtual procedures in the base-type by specialized procedures in derived-types*

To can declare abstract/virtual procedures in a type, this type must 'Extends' (directly or indirectly) the built-in 'Object' type.

 A derived-type can override an abstract/virtual procedure declared in its base-type, by declaring a procedure with the same identifier and signature, meaning same number and type of parameters, same calling convention, and if any, same return type (or a return of a derived-type for return by reference or by pointer):

**-** Normally a base-type reference/pointer can access only a procedure in the same type or in a type upper in hierarchy (static binding at compile-time), even if this reference/pointer refers to an object of instantiate type derived from the base-type.
 **-** But when the base-type procedure is abstract/virtual, this tells the running program to resolve the override procedure the most derived relating to the real object type (dynamic binding at run-time).

**Restriction:**

Polymorphism is not directly compatible with:

**-** any operators 'New\[\]' or 'Delete\[\]' (the array versions for statement/expression/overload operators) because the use of a sub-type pointer (instead of the real type) fails for accessing the other elements (except the first),
 **-** even the overload operator 'Delete' is not directly compatible because it can not be declared virtual (being static).

Instead of having to call such an operator 'Delete(\[\])' statement on derived-type pointer, the safest way is to simply call (on base-type pointer) an overridden user virtual member procedure that will automatically launch the operator 'Delete(\[\])' statement at derived-type level.

Inheritance polymorphism learning, through example: 'Graph type collection'

In the below proposed example, the polymorphic part is broken down to better bring out all the elements necessary for the mechanics of polymorphism.

 The generic base-type chosen is any 'Graphic Form' defined by two graphic points and a color (abstraction).  
 The specialized derived-types are a 'Graphic Line', a 'Graphic Box', and a 'Graphic Circle' (all defined by two graphic points and a color):

**-** The 'Graphic Line' connects the point 1 and the point 2.
 **-** The 'Graphic Box' has as opposite vertices the point 1 (at the top and on the left) and the point 2 (in bottom and on the right).
 **-** The 'Graphic Circle' has as center the point 1 and go through point 2.

 The abstract procedure declared in the generic base-type, and which must be defined in each specialized derived-type, is the graphic drawing of the specialized form in a graphic window.  
 The two graphic points and the color being generic data, they so induce three generic data fields in the generic base-type, included by composition.  
 A 'graphic point' type is also defined with encapsulation of the x/y coordinate values (declared private), in order to control their validity (depending on the defined graphic screen size) by means of properties (but public these ones).

 Notations:

**-** Generic base-type name: *'GraphicForm2P'*
 **-** Specialized derived-type names: *'GraphicLine2P'*, *'GraphicBox2P'*, *'GraphicCircle2P'*
 **-** Virtual procedure name: *'drawGraphicForm2P()'*
 **-** Additional type name (include by composition within the generic type): *'GraphicPoint'*

- *'GraphicPoint'* type declaration (additional type for composition within generic base-type):

**-** The two coordinates (*'\_x'* and *'\_y'*) are private as well as the two static internal functions (*'xValid'* and *'yValid'*) to return the validity of each coordinate passed as argument, compared to the graphic window size.
 **-** For each coordinate, there are two public properties (*'x'* or *'y'*) as user interface: a getter, and a setter which tests the validity of the given value.
 **-** The public non default constructor calls also the setters to initialize the two coordinates.

```freebasic
Type GraphicPoint
	Public:  '' user interface
		Declare Constructor ()
		Declare Constructor (Byval x0 As Integer = 0, Byval y0 As Integer = 0)
		Declare Property x () As Integer          '' x-coordinate getter
		Declare Property x (Byval x0 As Integer)  '' x-coordinate setter (control if inside open graphic window)
		Declare Property y () As Integer          '' y-coordinate getter
		Declare Property y (Byval y0 As Integer)  '' y-coordinate setter (control if inside open graphic window)
	Private:  '' hidden members
		Dim As Integer _x, _y
		Declare Static Function xValid (Byval x0 As Integer) As Integer  '' x-coordinate inside open graphic window?
		Declare Static Function yValid (Byval y0 As Integer) As Integer  '' y-coordinate inside open graphic window?
End Type
```

- *'GraphicForm2P'* type declaration (generic base-type):

**-** Two public graphic point variables (*'pt1'* and *'pt2'*) and a public color variable (*'col'*) are included within the base type by composition.
 **-** A public abstract procedure (*'drawGraphicForm2P()'*) is declared (but without any body defining it).
 **-** Although the base type is non-instantiable, a protected constructor is still defined to initialize the data fields, but called from each derived type constructor only.
 **-** A virtual destructor (with an empty body) is declared, for getting compatibility with a derived type declaring its own destructor (not the case here). This base type destructor is public to be able to be called on a base type pointer or reference.

```freebasic
Type GraphicForm2P Extends Object  '' abstract graphic form defined by two points
	Public:  '' user interface
		Dim As GraphicPoint pt1, pt2
		Dim As Integer col
		Declare Abstract Sub drawGraphicForm2P ()  '' request procedure implementation for instantiable derived type
		Declare Virtual Destructor ()              '' for polymorphic compatibility with any derived type
	Protected:  '' hidden members
		Declare Constructor ()
		Declare Constructor (Byref p1 As GraphicPoint = Type(0, 0), Byref p2 As GraphicPoint = Type(0, 0), Byval col0 As Integer = 0)
End Type
```

- *'GraphicLine2P'*, *'GraphicBox2P'*, *'GraphicCircle2P'* type declarations (specialized derived-types):

**-** For each derived type, the same public procedure (*'drawGraphicForm2P()'*) is declared, but its body is specialized for each derived type.
 **-** For each derived type, a public constructor is declared and defined to initialize the base data fields (by calling the base constructor). No destructor because nothing specific to destroy from this derived type.

```freebasic
Type GraphicLine2P Extends GraphicForm2P  '' graphic line from point 1 to point 2
	Public:  '' user interface
		Declare Constructor (Byref p1 As GraphicPoint = Type(0, 0), Byref p2 As GraphicPoint = Type(0, 0), Byval col0 As Integer = 0)
		Declare Sub drawGraphicForm2P () Override  '' overridden procedure
End Type
```

```freebasic
Type GraphicBox2P Extends GraphicForm2P  '' graphic box from point 1 to point 2
	Public:  '' user interface
		Declare Constructor (Byref p1 As GraphicPoint = Type(0, 0), Byref p2 As GraphicPoint = Type(0, 0), Byval col0 As Integer = 0)
		Declare Sub drawGraphicForm2P () Override  '' overridden procedure
End Type
```

```freebasic
Type GraphicCircle2P Extends GraphicForm2P  '' graph circle centered on point1 and passing by point 2
	Public:  '' user interface
		Declare Constructor (Byref p1 As GraphicPoint = Type(0, 0), Byref p2 As GraphicPoint = Type(0, 0), Byval col0 As Integer = 0)
		Declare Sub drawGraphicForm2P () Override  '' overridden procedure
End Type
```

- Full code of example:

**-** Three graphic points (used by the six forms) are constructed.
 **-** To be able to trigger polymorphism, a base type-pointer array (*'pgf'*) is declared then initialized with instances of different derived types, in order to constitute a collection of objects from different types (but all having a common base type).
 **-** So, the same compiled code line, put in a loop, processes all instances from different types (*'pgf(I)->drawGraphicForm2P()'* or *'Delete pgf(I)'*), because the polymorphism mechanic allows to call each specialized procedure at run-time.

```freebasic
Type GraphicPoint

    Public:  '' user interface

        Declare Constructor ()

        Declare Constructor (ByVal x0 As Integer = 0, ByVal y0 As Integer = 0)

        Declare Property x () As Integer          '' x-coordinate getter

        Declare Property x (ByVal x0 As Integer)  '' x-coordinate setter (control if inside open graphic window)

        Declare Property y () As Integer          '' y-coordinate getter

        Declare Property y (ByVal y0 As Integer)  '' y-coordinate setter (control if inside open graphic window)

    Private:  '' hidden members

        Dim As Integer _x, _y

        Declare Static Function xValid (ByVal x0 As Integer) As Integer  '' x-coordinate inside open graphic window?

        Declare Static Function yValid (ByVal y0 As Integer) As Integer  '' y-coordinate inside open graphic window?

End Type

Constructor GraphicPoint ()

End Constructor

Constructor GraphicPoint (ByVal x0 As Integer = 0, ByVal y0 As Integer = 0)

    This.x = x0

    This.y = y0

End Constructor

Property GraphicPoint.x () As Integer

    Return This._x

End Property

Property GraphicPoint.x (ByVal x0 As Integer)

    If GraphicPoint.xValid(x0) Then This._x = x0

End Property

Property GraphicPoint.y () As Integer

    Return This._y

End Property

Property GraphicPoint.y (ByVal y0 As Integer)

    If GraphicPoint.yValid(y0) Then This._y = y0

End Property

Static Function GraphicPoint.xValid (ByVal x0 As Integer) As Integer

    If ScreenPtr = 0 Then Return 0  '' no open graphic window

    Dim As Long w

    ScreenInfo(w)

    If x0 >= 0 And x0 <= w - 1 Then Return -1 Else Return 0

End Function

Static Function GraphicPoint.yValid (ByVal y0 As Integer) As Integer

    If ScreenPtr = 0 Then Return 0  '' no open graphic window

    Dim As Long h

    ScreenInfo( , h)

    If y0 >= 0 And y0 <= h - 1 Then Return -1 Else Return 0

End Function

Type GraphicForm2P Extends Object  '' abstract graphic form defined by two points

    Public:  '' user interface

        Dim As GraphicPoint pt1, pt2

        Dim As Integer col

        Declare Abstract Sub drawGraphicForm2P ()  '' request procedure implementation for instantiable derived type

        Declare Virtual Destructor ()              '' for polymorphic compatibility with any derived type

    Protected:  '' hidden members

        Declare Constructor ()

        Declare Constructor (ByRef p1 As GraphicPoint = Type(0, 0), ByRef p2 As GraphicPoint = Type(0, 0), ByVal col0 As Integer = 0)

End Type

Virtual Destructor GraphicForm2P ()

End Destructor

Constructor GraphicForm2P ()  '' implementation not absolutely necessary

End Constructor

Constructor GraphicForm2P (ByRef p1 As GraphicPoint = Type(0, 0), ByRef p2 As GraphicPoint = Type(0, 0), ByVal col0 As Integer = 0)

    This.pt1 = p1

    This.pt2 = p2

    This.col = col0

End Constructor

Type GraphicLine2P Extends GraphicForm2P  '' graphic line from point 1 to point 2

    Public:  '' user interface

        Declare Constructor (ByRef p1 As GraphicPoint = Type(0, 0), ByRef p2 As GraphicPoint = Type(0, 0), ByVal col0 As Integer = 0)

        Declare Sub drawGraphicForm2P () Override  '' overridden procedure

End Type

Constructor GraphicLine2P (ByRef p1 As GraphicPoint = Type(0, 0), ByRef p2 As GraphicPoint = Type(0, 0), ByVal col0 As Integer = 0)

    Base(p1, p2, col0)  '' call the base type constructor

End Constructor

Sub GraphicLine2P.drawGraphicForm2P ()

    If ScreenPtr <> 0 Then  '' open graphic window

        Line (This.pt1.x, This.pt1.y)-(This.pt2.x, This.pt2.y), This.col

    End If

End Sub

Type GraphicBox2P Extends GraphicForm2P  '' graphic box from point 1 to point 2

    Public:  '' user interface

        Declare Constructor (ByRef p1 As GraphicPoint = Type(0, 0), ByRef p2 As GraphicPoint = Type(0, 0), ByVal col0 As Integer = 0)

        Declare Sub drawGraphicForm2P () Override  '' overridden procedure

End Type

Constructor GraphicBox2P (ByRef p1 As GraphicPoint = Type(0, 0), ByRef p2 As GraphicPoint = Type(0, 0), ByVal col0 As Integer = 0)

    Base(p1, p2, col0)  '' call the base type constructor

End Constructor

Sub GraphicBox2P.drawGraphicForm2P ()

    If ScreenPtr <> 0 Then  '' open graphic window

        Line (This.pt1.x, This.pt1.y)-(This.pt2.x, This.pt2.y), This.col, B

    End If

End Sub

Type GraphicCircle2P Extends GraphicForm2P  '' graph circle centered on point1 and passing by point 2

    Public:  '' user interface

        Declare Constructor (ByRef p1 As GraphicPoint = Type(0, 0), ByRef p2 As GraphicPoint = Type(0, 0), ByVal col0 As Integer = 0)

        Declare Sub drawGraphicForm2P () Override  '' overridden procedure

End Type

Constructor GraphicCircle2P (ByRef p1 As GraphicPoint = Type(0, 0), ByRef p2 As GraphicPoint = Type(0, 0), ByVal col0 As Integer = 0)

    Base(p1, p2, col0)  '' call the base type constructor

End Constructor

Sub GraphicCircle2P.drawGraphicForm2P ()

    If ScreenPtr <> 0 Then  '' open graphic window

        Dim As Integer r = Sqr((This.pt2.x - This.pt1.x) * (This.pt2.x - This.pt1.x) + (This.pt2.y - This.pt1.y) * (This.pt2.y - This.pt1.y))

        Circle (This.pt1.x, This.pt1.y), r, This.col

    End If

End Sub

Screen 12  '' open graphic window

Dim As GraphicPoint p1 = GraphicPoint(320, 240)  '' to construct graphic point 1

Dim As GraphicPoint p2 = GraphicPoint(500, 350)  '' to construct graphic point 2

Dim As GraphicPoint p3 = GraphicPoint(280, 170)  '' to construct graphic point 2

'' array of base type pointer referring to instances of different derived types

Dim As GraphicForm2P Ptr pgf (...) = {New GraphicLine2P(p1, p2, 14), New GraphicBox2P(p1, p2, 13), New GraphicCircle2P(p1, p2, 12), _

                                      New GraphicLine2P(p1, p3, 11), New GraphicBox2P(p1, p3, 10), New GraphicCircle2P(p1, p3, 09)}

For I As Integer = LBound(pgf) To UBound(pgf)

    pgf(I)->drawGraphicForm2P()  '' accessing dedicated overridden procedure by polymorphism

Next I

For I As Integer = LBound(pgf) To UBound(pgf)

    Delete pgf(I)  '' accessing dedicated overridden destructor (if necessary) by polymorphism

Next I

Sleep
```

 See the graphics output by running this code.

See also

- [`Type (Udt)`](Type-Udt), [`Extends`](Extends), [`Object`](Object), [`Operator Is (Rtti)`](Operator-Is-Run-Time-Type-Information)
  [`Virtual`](Virtual), [`Abstract`](Abstract), [`Override`](Override)  
  [`Pointer`](Pointer-Ptr), [`Reference`](Byref-Variables)  
  [Composition, Aggregation, Inheritance](Composition-Aggregation-Inheritance)  
  [OBJECT built-in and RTTI info](Object-Built-in-and-Rtti-Info)  
  [Use Implicit / Overload New(\[\]) and Delete(\[\]) Operators with Inheritance Polymorphism](Use-Implicit-Overload-New-and-Delete-Operators-with-Inheritance-Polymorphism)

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
