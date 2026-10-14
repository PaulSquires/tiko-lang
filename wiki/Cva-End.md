[Home](Home) › [Procedures](Category-Procedures) › **Cva_End**

# Cva_End

Macro to clean-up a variadic argument list object variable

## Syntax

```freebasic
Cva_End( argument_list )
```

## Parameters

- `argument_list`

## Description

Cleans-up a [`Cva_List`](Cva-List) type variable that was previously initialized with [`Cva_Start`](Cva-Start) or [`Cva_Copy`](Cva-Copy), like a destructor.

 `argument_list` must already have been initialized with a previous [`Cva_Start`](Cva-Start) or [`Cva_Copy`](Cva-Copy) statement in the same procedure as `Cva_End` (for cross platform compatibility).

## Remarks

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__cva_end`.

### Differences from QB

- New to FreeBASIC

### See also

- [... (Ellipsis)](Ellipsis)
- [`Cva_Arg`](Cva-Arg)
- [`Cva_Copy`](Cva-Copy)
- [`Cva_List`](Cva-List)
- [`Cva_Start`](Cva-Start)

## Examples

```freebasic
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

---

**Category:** [Procedures](Category-Procedures)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
