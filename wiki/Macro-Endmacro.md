[Home](Home) › [Preprocessor](Category-Preprocessor) › **#Macro...#Endmacro**

# #Macro...#Endmacro

Preprocessor directive to define a multiline macro

## Syntax

```freebasic
#macro identifier [?] ( [ parameters ] )
body
#endmacro
#macro identifier [?] ( [ parameters, ] Variadic_Parameter... )
body
#endmacro
```

## Description

`#macro` is the multi-line version of [`#define`](Define).

 If using the optional question mark (?) after the `identifier` in the definition syntax, macros with parameters can be invoked without using parentheses around the arguments.
 **Note:** Beware of the possibility of triggering so a conflict with expressions containing the name of the macro as one of their terms.

 Note: Unlike the function-like [`#define`](Define) declaration, spaces can be put between the macro name and the opening parenthesis for any declaration syntax of macro.

 WARNING: In the macro body, it may be mandatory to have to surround by parentheses any used parameter if it is inside an expression with one operator at least, in order to not undergo an unwanted precedence change of operators (if passing as argument an expression with also operators).

## Remarks

### Version

- Before fbc 1.08.0, the optional question mark (?) was not available.

### Differences from QB

- New to FreeBASIC

### See also

- [`#define`](Define)
- [`#ifdef`](Ifdef)
- [`#undef`](Undef)

## Examples

```freebasic
' macro as an expression value

#macro Print1( a, b )

    a + b

#endmacro

Print Print1( "Hello ", "World!" )

/' Output :

Hello World!

'/
```

```freebasic
' macro as multiple statements

#macro Print2( a, b )

    Print a;

    Print " ";

    Print b;

    Print "!"

#endmacro

Print2( "Hello", "World" )

/' Output :

Hello World!

'/
```

```freebasic
' macro with a variadic parameter

#macro test1( arg1, arg2... )

    Print arg1

    #if #arg2 = ""

        Print "2nd argument not passed"

    #else

        Print arg2

    #endif

#endmacro

test1( "1", "2" )

Print "-----------------------"

test1( "3" )

Print "-----------------------"

test1( 5, 6 )

Print "-----------------------"

test1( 7 )

/' Output :

1

2

-----------------------

3

2nd argument not passed

-----------------------

 5

 6

-----------------------

 7

2nd argument not passed

'/
```

```freebasic
' macro with a variadic parameter which can contain several sub-parameters:

'   To distinguish between the different arguments passed by variadic_parameter,

'   you can first convert variadic_parameter to a string using the Operator # (Preprocessor Stringize),

'   then differentiate in this string (#variadic_parameter) each passed argument by locating the separators (usually a comma).

#macro test2( arg1, arg2... )

    Print "'" & Trim(#arg1) & "'"

    Scope

        Dim As String s = Trim(#arg2)

        If s <> "" Then

            Do

                Dim As Integer k = InStr(1, s, ",")

                If k = 0 Then

                    Print "'" & s & "'"

                    Exit Do

                End If

                Print "'" & Left(s, k - 1) & "'"

                s = Trim(Mid(s, k+1))

            Loop

        End If

    End Scope

#endmacro

test2( 5 )

Print "----"

test2( 5,6, 7, , 9, 10, ,,13, 14 )

/' Output :

'5'

----

'5'

'6'

'7'

''

'9'

'10'

''

''

'13'

'14'

'/
```

---

**Category:** [Preprocessor](Category-Preprocessor)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
