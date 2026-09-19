[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_ARG_COUNT__**

# __FB_ARG_COUNT__

Intrinsic define (macro) performed by the compiler.

## Syntax

```freebasic
__FB_ARG_COUNT__( args... )
```

## Parameters

- `args...`

## Description

Counts the number of arguments in the argument list (`args...`) and returns the corresponding value.  
 A value is always returned, with 0 corresponding to an empty argument list.

 Because the argument separator is the comma (,), the returned value for a non-empty argument list is the number of main commas (non-nested) plus 1.

## Remarks

### Version

- Since fbc 1.08.0

### Differences from QB

- New to FreeBASIC

### See also

- [`__FB_ARG_LEFTOF__`](Fb-Arg-Leftof)
- [`__FB_ARG_RIGHTOF__`](Fb-Arg-Rightof)
- [`__FB_ARG_EXTRACT__`](Fb-Arg-Extract)
- [`__Fb_Arg_Listexpand__`](Fb-Arg-Listexpand)

## Examples

```freebasic
#macro m( args... )

    Print __FB_ARG_COUNT__( args )

#endmacro

m()

m(a)

m(b,c)

m(,d)

m(,e,)

m(,,,)

Sleep

/' Output:

 0

 1

 2

 2

 3

 4

'/
```

```freebasic
' macro with a variadic parameter which can contain several sub-parameters:

'   To distinguish between the different arguments passed by a variadic_parameter,

'   you can first convert the variadic_parameter to a string using the Operator # (Preprocessor Stringize),

'   then differentiate in this string (#variadic_parameter) each passed argument by locating the separators (usually a comma)

'   in a [For...Next] loop based on the number of arguments (__FB_ARG_COUNT__) passed to the macro.

#macro average(result, arg...)

    Scope

        Dim As String s = #arg

        If s <> "" Then

            result = 0

            For I As Integer = 1 To __FB_ARG_COUNT__( arg ) - 1

                Dim As Integer k = InStr(1, s, ",")

                result += Val(Left(s, k - 1))

                s = Mid(s, k + 1)

            Next I

            result += Val(s)

            result /= __FB_ARG_COUNT__( arg )

        End If

    End Scope

#endmacro

Dim As Double result

average(result, 1, 2, 3, 4, 5, 6)

Print result

Sleep

/' Output :

 3.5

'/
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
