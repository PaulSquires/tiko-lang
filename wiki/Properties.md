[Home](Home) › [Tutorials](Category-Tutorials) › **Properties**

# Properties

Properties are a special mix of member variable and member procedure.

 They provide a way to set or retrieve values of an object, through normal looking assignments or member accesses, but also let the object perform actions if it needs to update itself.

 **Basic properties**
 Declaring and using setter and getter properties.
 **Indexed properties**
 Properties with an additional parameter.

Basic properties

A property is declared similar to a [member procedure](Member-Procedures), except that the [Property](Property) keyword is used instead of [`Sub`](Sub) or [`Function`](procedures-Function). For example, let's consider a window class for a windowing system or GUI library.

```freebasic
Type Window

Private:

    As String title_

End Type

Dim As Window w
```

 In order to set the window's title, a *setter* property can be added:

```freebasic
Type Window

    Declare Property title(ByRef s As String)

Private:

    As String title_

End Type

Property Window.title(ByRef s As String)

    this.title_ = s

End Property

Dim As Window w

w.title = "My Window"
```

 It is very similar to a member [Sub](Sub), as it takes a parameter and updates the object to the new state based on the parameter. However, the syntax for sending this parameter is a basic assignment, not a function call. By assigning the new value to the `title` property, the property procedure will automatically be called with the given new value, and can update the window to reflect the change. It is up to the object how to represent the property state internally.

 By design, properties can only be assigned one value at a time, and as a result the property procedure can not have more than one parameter.

 After setting the window title, it should also be possible to retrieve it. Here is how to add a *getter* property:

```freebasic
Type Window

    '' setter

    Declare Property title(ByRef s As String)

    '' getter

    Declare Property title() As String

Private:

    As String title_

End Type

'' setter

Property Window.title(ByRef s As String)

    this.title_ = s

End Property

'' getter

Property Window.title() As String

    Return this.title_

End Property

Dim As Window w

w.title = "My Window"

Print w.title
```

 The getter is very similar to a [Function](procedures-Function). It is supposed to return the current value of the property, and it allows the current value to be calculated from other internal values, if needed. Note that both *setter* and *getter* use the same identifier, indicating they handle the same property.

 Just like [method overloading](Member-Procedures), it is possible to specify multiple setters, provided they have different parameter types:

```freebasic
Type Window

    Declare Property title(ByRef s As String)

    Declare Property title(ByVal i As Integer)

    Declare Property title() As String

Private:

    As String title_

End Type

Property Window.title(ByRef s As String)

    this.title_ = s

End Property

Property Window.title(ByVal i As Integer)

    this.title_ = "Number: " & i

End Property

Property Window.title() As String

    Return this.title_

End Property

Dim As Window w

w.title = "My Window"

Print w.title

w.title = 5

Print w.title
```

 In comparison to this example of properties, here is similar code that does not use properties:

```freebasic
Type Window

    Declare Sub set_title(ByRef s As String)

    Declare Sub set_title(ByVal i As Integer)

    Declare Function get_title() As String

Private:

    As String title

End Type

Sub Window.set_title(ByRef s As String)

    this.title = s

End Sub

Sub Window.set_title(ByVal i As Integer)

    this.title = "Number: " & i

End Sub

Function Window.get_title() As String

    Return this.title

End Function

Dim As Window w

w.set_title("My Window")

Print w.get_title()

w.set_title(5)

Print w.get_title()
```

 The code is basically the same, only the syntax is different. Properties are specifically designed to combine the setter/getter concept and the language's normal way of literally [assigning](Assignment-Operators) and [accessing](Type-or-Class-Operators) values to a class' member variables. It is up to the programmers to decide which way they prefer.

 Here is an example demonstrating a text user interface window class allowing to set position and title using properties:

```freebasic
Namespace tui

    Type Point

        Dim As Integer x, y

    End Type

    Type char

        Dim As UByte value

        Dim As UByte Color

    End Type

    Type Window

        '' public

        Declare Constructor _

            ( _

                x As Integer = 1, y As Integer = 1, _

                w As Integer = 20, h As Integer = 5, _

                title As ZString Ptr = 0 _

            )

        Declare Destructor

        Declare Sub show

        '' title property

        Declare Property title As String

        Declare Property title( new_title As String )

        '' position properties

        Declare Property x As Integer

        Declare Property x( new_x As Integer )

        Declare Property y As Integer

        Declare Property y( new_y As Integer )

    Private:

        Declare Sub redraw

        Declare Sub remove

        Declare Sub drawtitle

        Dim As String p_title

        Dim As Point Pos

        Dim As Point siz

    End Type

    Constructor Window _

        ( _

            x_ As Integer, y_ As Integer, _

            w_ As Integer, h_ As Integer, _

            title_ As ZString Ptr _

        )

        pos.x = x_

        pos.y = y_

        siz.x = w_

        siz.y = h_

        If( title_ = 0 ) Then

            title_ = @"untitled"

        End If

        p_title = *title_

    End Constructor

    Destructor Window

        Color 7, 0

        Cls

    End Destructor

    Property window.title As String

        title = p_title

    End Property

    Property window.title( new_title As String )

        p_title = new_title

        drawtitle

    End Property

    Property window.x As Integer

        Return pos.x

    End Property

    Property window.x( new_x As Integer )

        remove

        pos.x = new_x

        redraw

    End Property

    Property window.y As Integer

        Property = pos.y

    End Property

    Property window.y( new_y As Integer )

        remove

        pos.y = new_y

        redraw

    End Property

    Sub window.show

        redraw

    End Sub

    Sub window.drawtitle

        Locate pos.y, pos.x

        Color 15, 1

        Print Space( siz.x );

        Locate pos.y, pos.x + (siz.x \ 2) - (Len( p_title ) \ 2)

        Print p_title;

    End Sub

    Sub window.remove

        Color 0, 0

        Var sp = Space( siz.x )

        For i As Integer = pos.y To pos.y + siz.y - 1

            Locate i, pos.x

            Print sp;

        Next

    End Sub

    Sub window.redraw

        drawtitle

        Color 8, 7

        Var sp = Space( siz.x )

        For i As Integer = pos.y + 1 To pos.y + siz.y - 1

            Locate i, pos.x

            Print sp;

        Next

    End Sub

End Namespace

Dim win As tui.window = tui.window( 3, 5, 50, 15 )

win.show

Sleep 500

win.title = "Window 1"

Sleep 250

win.x = win.x + 10

Sleep 250

win.title = "Window 2"

Sleep 250

win.y = win.y - 2

Sleep 250

Locate 25, 1

Color 7, 0

Print "Press any key...";

Sleep
```

 Note how updating the window's position or title automatically causes the window to be redrawn.

Indexed properties

Properties can have an additional parameter that is called an `index` (currently only one additional parameter is allowed). The index is specified in parentheses behind the property's name, as if the property was an array (with only one dimension). For example:

```freebasic
Type IntArray

    '' setters

    Declare Property value(index As Integer, v As Integer)

    Declare Property value(index As String, v As Integer)

    Declare Property value(index As Integer, v As String)

    Declare Property value(index As String, v As String)

    '' getters

    Declare Property value(index As Integer) As Integer

    Declare Property value(index As String) As Integer

Private:

    Dim As Integer data_(0 To 9)

End Type

Property IntArray.value(index As Integer) As Integer

    Return This.data_(index)

End Property

Property IntArray.value(index As String) As Integer

    Return This.data_(CInt(index))

End Property

Property IntArray.value(index As Integer, v As Integer)

    This.data_(index) = v

End Property

Property IntArray.value(index As String, v As Integer)

    This.data_(CInt(index)) = v

End Property

Property IntArray.value(index As Integer, v As String)

    This.data_(index) = CInt(v)

End Property

Property IntArray.value(index As String, v As String)

    This.data_(CInt(index)) = CInt(v)

End Property

Dim a As IntArray

a.value(0) = 1234

a.value("1") = 5678

a.value(2) = "-1234"

a.value("3") = "-5678"

Print a.value(0)

Print a.value("1")

Print a.value(2)

Print a.value("3")

Sleep
```

This simulates an integer array that can be assigned strings, and even be indexed with strings. See KeyPgProperty for another example.

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
