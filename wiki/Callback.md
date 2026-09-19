[Home](Home) › [Tutorials](Category-Tutorials) › **Callback**

# Callback

Callback procedures

Description

From Wikipedia: A callback, also known as a "call-after" function, is any executable code that is passed as an argument to other code; that other code is expected to call back (execute) the argument at a given time. This execution may be immediate as in a synchronous (or blocking) callback, or it might happen at a later time as in an asynchronous (or deferred) callback.

Example

Example where a mathematical function is an argument in plot function call:  
 (the invocation is implemented by calling the 'PlotF()' procedure, and the callback function is the 'Linear()', 'Sinusoidal()', or 'Quadratic()' function)

```freebasic
Type MathFunction As Function( ByVal x As Double ) As Double

Function Linear( ByVal x As Double ) As Double

    Return x

End Function

Function Quadratic( ByVal x As Double ) As Double

    Return x * x

End Function

Function Sinusoidal( ByVal x As Double ) As Double

    Return Sin(x)

End Function

Sub PlotF( ByVal f As MathFunction )

    PSet( -15, f(-15) )

    For x As Double = -15 To 15 Step 0.1

        Line -( x, f(x) )

    Next

End Sub

Screen 19

Window (-15,-10)-(15,10)

PlotF( @Linear )

PlotF( @Sinusoidal )

PlotF( @Quadratic )

Sleep
```

 The three callback processes are synchronous because each callback function is completely executed before 'PlotF()' returns to the caller code.

Similar plotting example (as above) but with a asynchronous callback. Here an artificial delay is added. A more realistic case would be if the data to be plotted is retrieved form a web-server with a response time larger than acceptable for the main loop of our program (prevent blocking behavior):

```freebasic
#include "fbthread.bi"

Type MathFunction As Function( ByVal x As Double ) As Double

Sub ThreadPlot( ByVal p As Any Ptr )

    Sleep 1500, 1  '' sleep added only to check the asynchronous way of the callback

    Dim f As MathFunction = p

    Window (-15,-10)-(15,10)

    PSet( -15, f(-15) )

    For x As Double = -15 To 15 Step 0.1

        Line -( x, f(x) )

    Next

End Sub

Function PlotF( ByVal f As MathFunction ) As String

    Print "Plotting requested"

    ThreadDetach( ThreadCreate( @ThreadPlot, f ) )

    Return "Plotting request taken into account"

End Function

Function Linear( ByVal x As Double ) As Double

    Return x

End Function

Function Quadratic( ByVal x As Double ) As Double

    Return x * x

End Function

Function Sinusoidal( ByVal x As Double ) As Double

    Return Sin(x)

End Function

Screen 19

Print PlotF( @Linear )

Print PlotF( @Sinusoidal )

Print PlotF( @Quadratic )

'' following code added only to check the asynchronous way of callbacks

Print "Main program continues ";

For I As Integer = 1 To 15

    Print ".";

    Sleep 200, 1

Next I

Print

Print "Main program finished"

Sleep
```

 The three callback processes are asynchronous because the 'PlotF()' function returns immediately, and each callback function is executed in parallel with the caller's next code, from a 'ThreadPlot()' thread created (previously) by 'PlotF()' for each of them.

Example of a callback function for comparing values in a array to be sorted by the qsort algorithm:  
 (the invocation is implemented by calling the 'qsort()' procedure, and the callback function is the 'CmpVarLenStr()' function)

```freebasic
#include "crt/stdlib.bi"

Function CmpVarLenStr cdecl( ByVal p1 As Any Ptr, ByVal p2 As Any Ptr ) As Long  '' compare 2 var-len strings

    Dim As String Ptr ps1 = p1

    Dim As String Ptr ps2 = p2

    If *ps1 < *ps2 Then

        Return -1

    ElseIf *ps1 > *ps2 Then

        Return 1

    Else

        Return 0

    End If

End Function

Sub PrintList( array() As String)  '' print a var-len string list

    For I As Integer = LBound(array) To UBound(array)

        Print array(I)

    Next I

    Print

End Sub

Dim forename(1 To 12) As String = {"Madison", "Emily", "Hailey", "Sarah", "Kaitlyn", "Hannah", _

                                   "Jacob", "Christopher", "Nicholas", "Michael", "Matthew", "Joshua" }

Print "LIST OF UNSORTED FORENAMES:"

PrintList( forename() )

qsort( @forename(LBound(forename)), UBound(forename) - LBound(forename) + 1, SizeOf(String), @CmpVarLenStr )

Print "LIST OF SORTED FORENAMES:"

PrintList( forename() )

Sleep
```

 The callback process is synchronous because the callback function is completely executed (several times), (successively) called by 'qsort()', before 'qsort()' returns to the caller code.

See also

- [Sub Pointer](Sub-Pointer)
- [Function Pointer](Function-Pointer)
- [Threads](Threads)
- [OBJECT built-in and RTTI info](Object-Built-in-and-Rtti-Info)

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
