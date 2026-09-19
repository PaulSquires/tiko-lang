[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_ARG_RIGHTOF__**

# __FB_ARG_RIGHTOF__

Intrinsic define (macro) performed by the compiler.

## Syntax

```freebasic
__FB_ARG_RIGHTOF__( arg, sep [, ret] )
```

## Parameters

- `arg`
- `sep`
- `ret`

## Description

Returns the right token of the argument (`arg`), based on the separator (`sep`).  
 (in the expression of the argument, the tokens and the separator must be spaced)

 By default, if the default return (`ret`) is not given, the macro returns nothing (empty token) if the separator (`sep`) is not found.  
 Otherwise, if the default return (`ret`) is given, the macro returns the default return (`ret`) if the separator (`sep`) is not found.

## Remarks

### Version

- Since fbc 1.08.0

### Differences from QB

- New to FreeBASIC

### See also

- [`__FB_ARG_LEFTOF__`](Fb-Arg-Leftof)
- [`__FB_ARG_COUNT__`](Fb-Arg-Count)
- [`__FB_ARG_EXTRACT__`](Fb-Arg-Extract)
- [`__Fb_Arg_Listexpand__`](Fb-Arg-Listexpand)

## Examples

```freebasic
#macro m( arg )

    Scope

        Var v = __FB_ARG_RIGHTOF__( arg, versus, "Not found 'versus'" )

        Print v

    End Scope

#endmacro

m(1 versus 2)

m("left-side" versus "right-side")

m(pi verso 3.14)

Sleep

/' Output:

 2

right-side

Not found 'versus'

'/
```

```freebasic
#macro count( range )

    Scope

        Dim x As Integer = __FB_ARG_LEFTOF__( range, To )

        Dim y As Integer = __FB_ARG_RIGHTOF__( range, To )

        Dim s As Integer = Sgn(y - x)

        Print "Counting " & #range

        For i As Integer = x To y Step s

            Print i

        Next i

    End Scope

#endmacro

count( 4 To 10 )

count( 7 To 2 )

Sleep

/' Output:

Counting 4 to 10

 4

 5

 6

 7

 8

 9

 10

Counting 7 to 2

 7

 6

 5

 4

 3

 2

'/
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
