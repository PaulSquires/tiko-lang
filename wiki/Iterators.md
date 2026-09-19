[Home](Home) › [Tutorials](Category-Tutorials) › **Iterators**

# Iterators

The overload Operators **For**, **Next**, and **Step**, allowing to construct User-Defined Types **Iterators** (instead of only intrinsic scalar types iterators) for a For...Next loop

Syntax (declaration)

{ [Type](Type-Udt) | [Class](Class) | [Union](Union) } *typename*

' [`For...Next`](For-Next)' statement with implicit step (1st version of operators)

[Declare](Declare) **Operator** [For](Operator-for-Iteration) ( )  
 [Declare](Declare) **Operator** [Next](Operator-Next-Iteration) ( \[ [ByRef](Byref-Parameters) | [ByVal](Byval) \] *cond* [As](As) *typename* ) [As](As) [Integer](Integer)  
 [Declare](Declare) **Operator** [Step](Operator-Step-Iteration) ( )

' [`For...Next`](For-Next)' statement with explicit step (2nd version of operators)

[Declare](Declare) **Operator** [For](Operator-for-Iteration) ( \[ [ByRef](Byref-Parameters) | [ByVal](Byval) \] *stp* [As](As) *typename* )  
 [Declare](Declare) **Operator** [Next](Operator-Next-Iteration) ( \[ [ByRef](Byref-Parameters) | [ByVal](Byval) \] *cond* [As](As) *typename*, \[ [ByRef](Byref-Parameters) | [ByVal](Byval) \] *stp* [As](As) *typename* ) [As](As) [Integer](Integer)  
 [Declare](Declare) **Operator** [Step](Operator-Step-Iteration) ( \[ [ByRef](Byref-Parameters) | [ByVal](Byval) \] *stp* [As](As) *typename* )

End { [Type](Type-Udt) | [Class](Class) | [Union](Union) }

Usage

[For](For-Next) *iterator* \[ As *typename* \] = *start_value* To *end_value* \[ [Step](For-Next) *step_value* \]

\[*...statements...*\]

[Next](For-Next)

 The first version of operators is used if no `step_value` is given in the [`For...Next`](For-Next) statement.  
 If a `step_value` is given, the second version is used and a step object (initialized with `step-value`) is passed through the `stp` parameter:

**-** to [`Operator For`](Operator-for-Iteration) because eventual additional initialization may use it,
 **-** to [`Operator Next`](Operator-Next-Iteration) because testing for iterating end may depend on it,
 **-** to [`Operator Step`](Operator-Step-Iteration) to increment the iterator object.

Both versions of the operators can coexist (thanks to member overloading) in the same user-defined type (to be able to both use and not use the explicit increment in [`For...Next`](For-Next) statements of the user code).

Parameters

**`(including arguments)`**
 `typename`

name of the [`Type`](Type-Udt), [`Class`](Class), or [`Union`](Union)

`stp`, `step_value`

a `typename` object used as an incremental value

`iterator`

a `typename` object used as an iterator

`cond`, `end_value`

a `typename` object used as a loop-terminating value

`start_value`

a `typename` object used to copy construct or assign to the iterator initially

Description

[`Operator For`](Operator-for-Iteration), [`Operator Next`](Operator-Next-Iteration) and [`Operator Step`](Operator-Step-Iteration) can be overloaded in user-defined type definitions to allow objects of that type to be used as iterators and step values in [`For...Next`](For-Next) loops (instead of the pre-defined for intrinsic scalar types).

 As all non-static member procedures, the 3 operators have passed a hidden [`This`](This) parameter that allows to access by reference to the iterator object (initialized to the `start_value` argument value from the [`For...Next`](For-Next) statement).  
 The `cond` parameter of the [`Operator Next`](Operator-Next-Iteration) allows to access the `end_value` argument value from the [`For...Next`](For-Next) statement.  
 If a `step_value` is given (as argument) in the [`For...Next`](For-Next) statement, the `stp` parameter allows to access this value in the 3 operators.

 **Note:** If no `step_value` is given in the [`For...Next`](For-Next) statement (implicit step), the user-defined type must have a default constructor (implicit or explicit) or a conversion constructor. It is a bug at the moment because if the user defines a default constructor, the compiler does not even use it when initializing the [`For...Next`](For-Next) loop!

 *Operator For*

[`Operator For`](Operator-for-Iteration) is called once immediately after copy constructing or assigning to the iterator object (with the `start_value`), constructing the end object (with the `end_value`), and constructing the step object (with `step_value` if defined in the [`For...Next`](For-Next) statement).  
 [`Operator For`](Operator-for-Iteration) allows to perform any additional initialization needed in preparation for the loop.

*Operator Next*

[`Operator Next`](Operator-Next-Iteration) is called every time the iterator object needs to be checked against the end value. This happens immediately after the call to the [`Operator For`](Operator-for-Iteration), and then immediately after any calls to the [`Operator Step`](Operator-Step-Iteration).  
 [`Operator Next`](Operator-Next-Iteration) should return zero (0) if the loop should be terminated, or non-zero if the loop should continue iterating.  
 The first time [`Operator Next`](Operator-Next-Iteration) is called, no statements in the [`For...Next`](For-Next) body have been executed yet.  
 [`Operator Next`](Operator-Next-Iteration) also allows to perform some processing before the execution of all statements in the [`For...Next`](For-Next) body.

*Operator Step*

[`Operator Step`](Operator-Step-Iteration) is called to increment the iterator object immediately after all statements in the [`For...Next`](For-Next) body are executed.

*Advanced usage*

The above description seems to imply that the 3 arguments `start_value`, `end_value`, and `step_value` must be of the same type as the `iterator` (this is the more obvious use), but it is not quite true:

**-** The `start_value`, `end_value`, and `step_value` arguments can be of any type (of different types among themselves and also of different types from the one of the `iterator`).
 **-** The only constraint is that the `iterator` could be constructed (in case of local `iterator`) or assigned (in case of global `iterator`) from the `start_value` argument (because the `iterator` is implicitly constructed or assigned under the hood).
 **-** Similarly the other arguments `end_value`, and `step_value` must be able to be converted into objects of the same type as the `iterator`.

Algorithm

[`For...Next`](For-Next) loop algorithm around the 3 overload operators:

```freebasic
'                       FOR...NEXT loop
'                              V
'                              |
'            constructing/assigning iterator object
'       (This = start_value from For...Next statement)
'                              |
'                   constructing end object
'       (cond = end_value from For...Next statement)
'                              |
'                   if step_value is defined >---------------------.
'                            else                                  :
'                              v                                   v
'                              :                        constructing step object
'                              :               (stp = step_value from For...Next statement)
'                              :                                   :
'                              :<----------------------------------'
'                              |
'                    calling Operator For
'                              |
'     .----------------------->|
'     |                        |
'     |              calling Operator Next
'     |     (if end-condition verified: =0 returned) >-------------.
'     |               (else: <>0 returned)                         |
'     |                        v                                   |
'     |                        |                                   |
'     |            executing For...Next body                       |
'     |                        |                                   |
'     |              calling Operator Step                         |
'     |                        |                                   |
'     '------------------------'                                   |
'                                                                  |
'                                                                  V
```

Example

Type for iterating through screen resolutions, with implicit step-value:

```freebasic
Type screenResolution

    ' user interface

        Declare Constructor (ByVal colorBit As Long)

        Declare Property colorDepth () As Long

        Declare Property screenWidth () As Long

        Declare Property screenHeigth () As Long

    ' overload iteration operators when Step is not defined in For...Next statement

        Declare Operator For ()

        Declare Operator Next (ByRef iterateCondition As screenResolution) As Integer

        Declare Operator Step ()

    ' internal variables

        Dim As Long colorBit, resolutionWH

End Type

Constructor screenResolution (ByVal colorBit As Long)

    This.colorBit = colorBit

End Constructor

Property screenResolution.colorDepth () As Long

    Return This.colorBit

End Property

Property screenResolution.screenWidth () As Long

    Return HiWord(This.resolutionWH)

End Property

Property screenResolution.screenHeigth () As Long

    Return LoWord(This.resolutionWH)

End Property

Operator screenResolution.For ()

    This.resolutionWH = ScreenList(This.colorBit)

End Operator

Operator screenResolution.Next (ByRef iterateCondition As screenResolution) As Integer

    While This.resolutionWH = 0

        If This.colorBit < iterateCondition.colorBit Then

            This.colorBit += 1

            This.resolutionWH = ScreenList(This.colorBit)

        Else

            Exit While

        End If

    Wend

    Return (This.resolutionWH <> iterateCondition.resolutionWH)

End Operator

Operator screenResolution.Step ()

    This.resolutionWH = ScreenList()

End Operator

Print "Screen resolutions supported within [1 bpp , 64 bpp]:"

For iterator As screenResolution = screenResolution(1) To screenResolution(64)

    Print "    " & iterator.colorDepth & " bpp ",

    Print ":" & iterator.screenWidth & "x" & iterator.screenHeigth

Next iterator

Print "End of supported screen resolutions"

Sleep
```

 Output example:

```freebasic
Screen resolutions supported within [1 bpp , 64 bpp]:
	24 bpp    :320x200
	24 bpp    :320x240
	24 bpp    :400x300
	24 bpp    :512x384
	24 bpp    :640x400
	24 bpp    :640x480
	24 bpp    :800x600
	24 bpp    :1024x768
	24 bpp    :1152x864
	24 bpp    :1280x600
	24 bpp    :1280x720
	24 bpp    :1280x768
	24 bpp    :1280x800
	24 bpp    :1280x960
	24 bpp    :1280x1024
	24 bpp    :1360x768
	24 bpp    :1366x768
	24 bpp    :1400x1050
	24 bpp    :1440x900
	24 bpp    :1600x900
	24 bpp    :1680x1050
	24 bpp    :1920x1080
	32 bpp    :320x200
	32 bpp    :320x240
	32 bpp    :400x300
	32 bpp    :512x384
	32 bpp    :640x400
	32 bpp    :640x480
	32 bpp    :800x600
	32 bpp    :1024x768
	32 bpp    :1152x864
	32 bpp    :1280x600
	32 bpp    :1280x720
	32 bpp    :1280x768
	32 bpp    :1280x800
	32 bpp    :1280x960
	32 bpp    :1280x1024
	32 bpp    :1360x768
	32 bpp    :1366x768
	32 bpp    :1400x1050
	32 bpp    :1440x900
	32 bpp    :1600x900
	32 bpp    :1680x1050
	32 bpp    :1920x1080
End of supported screen resolutions
```

Type for iterating through fractions, with explicit step-value used in the 3 operators:  
 (improved example compared to the one of [`Operator Step`](Operator-Step-Iteration) page)

```freebasic
Type fraction

    ' user interface

        Declare Constructor (ByVal n As Integer, ByVal d As Integer)

        Declare Operator Cast () As String

    ' overload iteration operators when Step is defined in For...Next statement

        Declare Operator For (ByRef iterateStep As fraction)

        Declare Operator Next (ByRef iterateCondition As fraction, ByRef iterateStep As fraction) As Integer

        Declare Operator Step (ByRef step_var As fraction)

    ' internal variables and cast operator

        As Integer num, den

        Declare Operator Cast () As Double

End Type

Constructor fraction (ByVal n As Integer, ByVal d As Integer)

    this.num = n

    this.den = d

End Constructor

Operator fraction.Cast () As String

    ' search for the highest common factor (a) between numerator and denominator

        Dim As Integer a = Abs(This.num), b = Abs(This.den)

        If a <> 0 Then

            While a <> b

                If a > b Then

                    a -= b

                Else

                    b -= a

                End If

            Wend

        Else

            a = 1

        End If

    ' reduce the fraction

        Return num \ a & "/" & den \ a

End Operator

Operator fraction.Cast () As Double

    Return This.num / This.den

End Operator

Operator fraction.For (ByRef iterateStep As fraction)

    ' search for the least common multiple (a) between the two denominators

        Dim As Integer a = Abs(This.den), b = Abs(iterateStep.den), c = a, d = b

        While a <> b

            If a > b Then

                b += d

            Else

                a += c

            End If

        Wend

    ' align at the same denominator the 2 fractions

        This.num *= a \ This.den

        This.den = a

        iterateStep.num *= a \ iterateStep.den

        iterateStep.den = a

End Operator

Operator fraction.Next (ByRef iterateCondition As fraction, ByRef iterateStep As fraction) As Integer

    If iterateStep.num < 0 Or iterateStep.den < 0 Then

        Return This >= iterateCondition

    Else

        Return This <= iterateCondition

    End If

End Operator

Operator fraction.Step (ByRef iterateStep As fraction)

    This.num += iterateStep.num

End Operator

Print "iteration from 1/8 to 1/2 by step of 1/12:"

For iterator As fraction = fraction(1, 8) To fraction(1, 2) Step fraction(1, 12)

    Print "    " & iterator;

Next

Print

Print

Print "iteration from 7/10 to -8/5 by step of -8/15:"

For iterator As fraction = fraction(7, 10) To fraction(-8, 5) Step fraction(-8, 15)

    Print "    " & iterator;

Next

Print

Sleep
```

 Output:

```freebasic
iteration from 1/8 to 1/2 by step of 1/12:
	1/8    5/24    7/24    3/8    11/24

iteration from 7/10 to -8/5 by step of -8/15:
	7/10    1/6    -11/30    -9/10    -43/30
```

See also

- [`For...Next`](For-Next)
- [`Operator`](Operator)

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
