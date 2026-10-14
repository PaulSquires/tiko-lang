[Home](Home) › [Procedures](Category-Procedures) › **Cva_Copy**

# Cva_Copy

Macro to initialize variadic argument list object variable from an already initialized variadic argument list object variable

## Syntax

```freebasic
Cva_Copy( dst_list, src_list )
```

## Parameters

- `dst_list`
- `src_list`

## Description

Copies one [`Cva_List`](Cva-List) type variable to another [`Cva_List`](Cva-List) type variable. `dst_list` is initialized using current state of `src_list`

 `src_list` must already have been initialized with a previous [`Cva_Start`](Cva-Start) or `Cva_Copy` statement.

 `Cva_Copy` is like a copy constructor for the a variadic argument list object and must eventually have a matching call to [`Cva_End`](Cva-End), which is like the destructor. After [`Cva_End`](Cva-End) for `dst_list` has been called, `dst_list` can be reused and reinitialized with another call to [`Cva_Start`](Cva-Start) or `Cva_Copy`. The `Cva_Copy` and [`Cva_End`](Cva-End) calls must both be called in the same procedure (for cross platform compatibility).

## Remarks

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__cva_copy`.

### Differences from QB

- New to FreeBASIC

### See also

- [... (Ellipsis)](Ellipsis)
- [`Cva_Arg`](Cva-Arg)
- [`Cva_End`](Cva-End)
- [`Cva_List`](Cva-List)
- [`Cva_Start`](Cva-Start)

## Examples

```freebasic
'' example of using cva_copy to create

'' a copy of the variable argument list

Sub proc cdecl(count As Integer, ... )

    Dim args1 As Cva_List

    Dim args2 As Cva_List

    '' first list

    Cva_Start( args1, count )

    '' create a copy

    Cva_Copy( args2, args1 )

    For i As Integer = 1 To count

        Print Cva_Arg( args1, Integer ), Cva_Arg( args2, Integer )

    Next

    '' clean-up

    Cva_End( args2 )

    Cva_End( args1 )

End Sub

proc( 4, 4000, 300, 20, 1 )
```

```freebasic
'' example of using cva_copy to create

'' a copy of the variable argument list

'' and pass it to another procedure

Sub vproc cdecl(count As Integer, ByRef args As Cva_List )

    '' if we don't know that caller made a copy

    '' of args, it is safe to make our own copy

    '' and leave the passed in args untouched

    Dim a As Cva_List

    Cva_Copy( a, args )

    Print "vproc"

    For i As Integer = 1 To count

        Print Cva_Arg( a, Integer )

    Next

    '' clean-up

    Cva_End( a )

End Sub

Sub proc cdecl(count As Integer, ... )

    Dim args As Cva_List

    Cva_Start( args, count )

    '' if don't know that the called procedure

    '' will make it's own copy, it is safe to

    '' make a copy here and pass that instead

    Dim tmp As Cva_List

    Cva_Copy( tmp, args )

    vproc( count, tmp )

    Cva_End( tmp )

    '' args is still valid, we can use it

    Print "proc"

    For i As Integer = 1 To count

        Print Cva_Arg( args, Integer )

    Next

    '' clean-up

    Cva_End( args )

End Sub

proc( 4, 4000, 300, 20, 1 )
```

---

**Category:** [Procedures](Category-Procedures)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
