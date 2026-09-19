[Home](Home) › [Operators](Category-Operators) › **Operator Step (Iteration)**

# Operator Step (Iteration)

Increments the iterator of a For...Next loop

## Syntax

```freebasic
{ Type | Class | Union } typename
Declare Operator Step ()
Declare Operator Step ( [ ByRef | ByVal ] stp As typename )
...
End { Type | Class | Union }
```

## Parameters

- `typename`
- `stp`
- `step_value`
- `typename`
- `iterator`
- `typename`
- `end_value`
- `typename`
- `start_value`
- `typename`

## Description

[`Operator For`](Operator-for-Iteration), [`Operator Next`](Operator-Next-Iteration) and `Operator Step` can be overloaded in user-defined type definitions to allow objects of that type to be used as iterators and step values in [`For...Next`](For-Next) loops.  
 As all non-static member procedures, they have passed a hidden [`This`](This) parameter that allows to access by reference to the iterator object in the code body of the 3 operators.

 `Operator Step` is called to increment the iterator object immediately after all statements in the [`For...Next`](For-Next) body are executed, if any.

 The first version of `Operator Step` is used if no step value is given in the [`For...Next`](For-Next) statement. If a step value is given, the second version is used and is passed the step value to increment the iterator object.

 *Advanced usage*

The above description seems to imply that the 3 arguments `start_value`, `end_value`, and `step_value` must be of the same type as the `iterator` (this is the more obvious use), but it is not quite true:

**-** The `start_value`, `end_value`, and `step_value` arguments can be of any type (of different types among themselves and also of different types from the one of the `iterator`).
 **-** The only constraint is that the `iterator` could be constructed (in case of local `iterator`) or assigned (in case of global `iterator`) from the `start_value` argument (because the `iterator` is implicitly constructed or assigned under the hood).
 **-** Similarly the other parameters `end_value`, and `step_value` must be able to be converted into objects of the same type as the `iterator`.

## Remarks

### Usage

```freebasic
For iterator [ As typename ] = start_value To end_value [ Step step_value ]

[ ...statements... ]

Next
```

### Dialect Differences

- Only available in the *[-lang fb](Compiler-Option-Lang)* dialect.

### See also

- [`Operator For`](Operator-for-Iteration)
- [`Operator Next`](Operator-Next-Iteration)
- [`For...Next`](For-Next)

## Examples

```freebasic
'' Example Type

Type T

  '' value is set by the constructor

  value As Double

  Declare Constructor( ByVal x As Double = 0 )

  Declare Operator For( ByRef stp As T )

  Declare Operator Step( ByRef stp As T )

  Declare Operator Next( ByRef cond As T, ByRef stp As T ) As Integer

End Type

Constructor T ( ByVal x As Double )

  Print "T iterator constructed with value " & x

  value = x

End Constructor

Operator T.for( ByRef stp As T )

End Operator

Operator T.step( ByRef stp As T )

  Print " incremented by " & stp.value & " in step."

  value += stp.value

End Operator

Operator T.next( ByRef cond As T, ByRef stp As T ) As Integer

  '' iterator's moving from a high value to a low value (step >= 0)

  If( stp.value < 0 ) Then

    Return( value >= cond.value )

  Else

  '' iterator's moving from a low value to a high value (step < 0)

    Return( value <= cond.value )

  End If

End Operator

'' Example Usage. It looks like we are working with numbers, but the iterators

'' have overloaded constructors. The 10, 1, and -1 are all of type T.

For i As T = 10 To 1 Step -1

  Print i.value;

Next i
```

 A more practical example demonstrating file iteration based on [cha0s' file iteration class](http://www.freebasic.net/forum/viewtopic.php?p=83564):

```freebasic
'' a class which iterates through files

Type FileIter

    As String pathName, fileName

    Declare Constructor( ByRef pathName As String )

    Declare Operator For()

    Declare Operator Step()

    Declare Operator Next( ByRef endCond As FileIter) As Integer

End Type

Constructor FileIter( ByRef pathName As String )

    this.pathName = pathName

End Constructor

Operator FileIter.for( )

    fileName = Dir(pathName & "/*.*")

End Operator

Operator FileIter.step( )

    fileName = Dir("")

End Operator

Operator FileIter.next( ByRef endCond As FileIter ) As Integer

    Return(fileName <> endCond.pathName)

    '' the c'tor sets the path name and so we check against that

End Operator

'' example code

'' change it to any directory

For i As FileIter = "./" To ""

    Print i.fileName

Next
```

 Another example working with strings:

```freebasic
Type CharIterator

    '' used to build a step var

    Declare Constructor( ByVal r As ZString Ptr )

    '' implicit step versions

    Declare Operator For ( )

    Declare Operator Step( )

    Declare Operator Next( ByRef end_cond As CharIterator ) As Integer

    '' explicit step versions

    Declare Operator For ( ByRef step_var As CharIterator )

    Declare Operator Step( ByRef step_var As CharIterator )

    Declare Operator Next( ByRef end_cond As CharIterator, ByRef step_var As CharIterator ) As Integer

    '' give the current "value"

    Declare Operator Cast( ) As String

    Private:

        '' data

        value As String

        '' This member isn't necessary - we could use

        '' the step variable on each iteration -

        '' but we choose this method, since we have

        '' to compare strings otherwise. See below.

        is_up As Integer

End Type

Constructor CharIterator( ByVal r As ZString Ptr )

    value = *r

End Constructor

Operator CharIterator.cast( ) As String

    Operator = value

End Operator

'' implicit step versions

''

'' In this example, we interpret implicit step

'' to always mean 'up'

Operator CharIterator.for( )

    Print "implicit step"

End Operator

Operator CharIterator.step( )

    value[0] += 1

End Operator

Operator CharIterator.next( ByRef end_cond As CharIterator ) As Integer

    Return this.value <= end_cond.value

End Operator

'' explicit step versions

''

'' In this example, we calculate the direction

'' at FOR, but since the step var is passed to

'' each operator, we have the choice to also calculate

'' it "on-the-fly". For strings such as this, repeated comparison

'' may penalize, but if you're working with simpler types,

'' then you may prefer to avoid the overhead of

'' an 'is_up' variable.

Operator CharIterator.for( ByRef step_var As CharIterator )

    Print "explicit step"

    is_up = (step_var.value = "up")

End Operator

Operator CharIterator.step( ByRef step_var As CharIterator )

    If( is_up ) Then

        value[0] += 1

    Else

        value[0] -= 1

    End If

End Operator

Operator CharIterator.next( ByRef end_cond As CharIterator, ByRef step_var As CharIterator ) As Integer

    If( this.is_up ) Then

        Return this.value <= end_cond.value

    Else

        Return this.value >= end_cond.value

    End If

End Operator

For i As CharIterator = "a" To "z"

    Print i; " ";

Next

Print "done"

For i As CharIterator = "a" To "z" Step "up"

    Print i; " ";

Next

Print "done"

For i As CharIterator = "z" To "a" Step "down"

    Print i; " ";

Next

Print "done"

For i As CharIterator = "z" To "a" Step "up"

    Print i; " ";

Next

Print "done"
```

 Iterating with fractions:

```freebasic
Type fraction

    '' Used to build a step var

    Declare Constructor( ByVal n As Integer, ByVal d As Integer )

    '' Implicit step versions

    Declare Operator For ( )

    Declare Operator Step( )

    Declare Operator Next( ByRef end_cond As fraction ) As Integer

    '' Explicit step versions

    Declare Operator For ( ByRef step_var As fraction )

    Declare Operator Step( ByRef step_var As fraction )

    Declare Operator Next( ByRef end_cond As fraction, ByRef step_var As fraction ) As Integer

    '' Give the current "value"

    Declare Operator Cast( ) As Double

    Declare Operator Cast( ) As String

    Private:

        As Integer num, den

End Type

Constructor fraction( ByVal n As Integer, ByVal d As Integer )

    This.num = n : This.den = d

End Constructor

Operator fraction.Cast( ) As Double

    Operator = num / den

End Operator

Operator fraction.Cast( ) As String

    Operator = num & "/" & den

End Operator

'' Some fraction functions

Function gcd( ByVal n As Integer, ByVal m As Integer ) As Integer

    Dim As Integer t

        While m <> 0

            t = m

            m = n Mod m

            n = t

        Wend

    Return n

End Function

Function lcd( ByVal n As Integer, ByVal m As Integer ) As Integer

    Return (n * m) / gcd( n, m )

End Function

''

'' Implicit step versions

''

'' In this example, we interpret implicit step

'' to mean 1

''

Operator fraction.For( )

    Print "implicit step"

End Operator

Operator fraction.Step( )

    Dim As Integer lowest = lcd( This.den, 1 )

    Dim As Double mult_factor = This.den / lowest

    Dim As fraction step_temp = fraction( 1, 1 )

    This.num *= mult_factor

    This.den *= mult_factor

    step_temp.num *= lowest

    step_temp.den *= lowest

    This.num += step_temp.num

End Operator

Operator fraction.Next( ByRef end_cond As fraction ) As Integer

    Return This <= end_cond

End Operator

''

'' Explicit step versions

''

Operator fraction.For( ByRef step_var As fraction )

    Print "explicit step"

End Operator

Operator fraction.Step( ByRef step_var As fraction )

    Dim As Integer lowest = lcd( This.den, step_var.den )

    Dim As Double mult_factor = This.den / lowest

    Dim As fraction step_temp = step_var

    This.num *= mult_factor

    This.den *= mult_factor

    mult_factor = step_temp.den / lowest

    step_temp.num *= mult_factor

    step_temp.den *= mult_factor

    This.num += step_temp.num

End Operator

Operator fraction.Next( ByRef end_cond As fraction, ByRef step_var As fraction ) As Integer

    If(( step_var.num < 0 ) Or ( step_var.den < 0 ) ) Then

        Return This >= end_cond

    Else

        Return This <= end_cond

    End If

End Operator

For i As fraction = fraction(1,1) To fraction(4,1)

    Print i; " ";

Next

Print "done"

For i As fraction = fraction(1,4) To fraction(1,1) Step fraction(1,4)

    Print i; " ";

Next

Print "done"

For i As fraction = fraction(4,4) To fraction(1,4) Step fraction(-1,4)

    Print i; " ";

Next

Print "done"

For i As fraction = fraction(4,4) To fraction(1,4)

    Print i; " ";

Next

Print "done"
```

---

**Category:** [Operators](Category-Operators)  
**Kind:** operator

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
