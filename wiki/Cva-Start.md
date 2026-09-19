[Home](Home) › [Procedures](Category-Procedures) › **Cva_Start**

# Cva_Start

Macro to initialize variadic argument list object variable

## Syntax

```freebasic
Cva_Start( argument_list, last_param )
```

## Parameters

- `argument_list`
- `last_param`

## Description

In a variadic procedure definition, `argument_list` is a variable having the [`Cva_List`](Cva-List) type and must be initialized with `Cva_Start` to work with the variable length argument list passed to the procedure.

 `last_param` is the last parameter before the [Ellipsis](Ellipsis) [`...`](Ellipsis) in the variadic procedure definition.

 `Cva_Start` can only be used in variadic procedures. A variadic procedure is declared or defined by specifying the [Ellipsis](Ellipsis) [`...`](Ellipsis) as the last parameter, and will accept a variable number of arguments when calling the procedure.

 `Cva_Start` is like a constructor for the variadic `argument_list` object and must eventually have a matching call to [`Cva_End`](Cva-End), which is like a destructor. After [`Cva_End`](Cva-End) for `argument_list` has been called, `argument_list` can be reused and reinitialized with another call to `Cva_Start`. The `Cva_Start` and [`Cva_End`](Cva-End) calls must both be called in pairs in the same procedure (for cross platform compatibility).

 [`Cva_Copy`](Cva-Copy) is similar to `Cva_Start` except it initializes a variadic `argument_list` object from an already initialized variadic `argument_list` object, like a copy constructor.

## Remarks

### Version

- Since fbc 1.07.0

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__cva_start`.

### Differences from QB

- New to FreeBASIC

### See also

- [... (Ellipsis)](Ellipsis)
- [`Cva_Arg`](Cva-Arg)
- [`Cva_Copy`](Cva-Copy)
- [`Cva_End`](Cva-End)
- [`Cva_List`](Cva-List)

## Examples

```freebasic
'' typical usage of iterating through all arguments

Sub proc cdecl(count As Integer, ... )

    Dim args As Cva_List

    Cva_Start( args, count )

    For i As Integer = 1 To count

        Print Cva_Arg( args, Integer )

    Next

    Cva_End( args )

End Sub

proc( 4, 4000, 300, 20, 1 )
```

```freebasic
'' example of using cva_start to get the first argument

'' then restarting to get all the arguments

Sub proc cdecl(count As Integer, ... )

    Dim args As Cva_List

    '' get the first argument only

    Cva_Start( args, count )

    Print Cva_Arg( args, Integer )

    Cva_End( args )

    '' restart and get all the arguments

    Cva_Start( args, count )

    For i As Integer = 1 To count

        Print Cva_Arg( args, Integer )

    Next

    Cva_End( args )

End Sub

proc( 4, 4000, 300, 20, 1 )
```

---

**Category:** [Procedures](Category-Procedures)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
