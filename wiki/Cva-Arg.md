[Home](Home) › [Procedures](Category-Procedures) › **Cva_Arg**

# Cva_Arg

Macro to obtain the next argument from a variadic argument list object.

## Syntax

```freebasic
variable = Cva_Arg ( argument_list, datatype )
```

## Parameters

- `argument_list`
- `datatype`
- `argument_list`

## Description

The `Cva_Arg` macro allows the use of a variable number of arguments within a function:

## Remarks

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__cva_arg`.

### Differences from QB

- New to FreeBASIC

### See also

- [`... (Ellipsis)`](Ellipsis)
- [`Cva_Copy`](Cva-Copy)
- [`Cva_End`](Cva-End)
- [`Cva_List`](Cva-List)
- [`Cva_Start`](Cva-Start)

## Examples

```freebasic
'' Example of a simple custom printf

Sub myprintf cdecl(ByRef formatstring As String, ...)

    Dim As Cva_List args

    '' Initialize the cva_list object to first var-arg

    Cva_Start( args, formatstring )

    '' For each char in format string...

    Dim As UByte Ptr p = StrPtr(formatstring)

    Dim As Integer todo = Len(formatstring)

    While (todo > 0)

        Dim As Integer char = *p

        p += 1

        todo -= 1

        '' Is it a format char?

        If (char = Asc("%")) Then

            If (todo = 0) Then

                '' % at the end

                Print "%";

                Exit While

            End If

            '' The next char should tell the type

            char = *p

            p += 1

            todo -= 1

            '' Print var-arg, depending on the type

            Select Case char

            '' integer?

            Case Asc("i")

                Print Str(Cva_Arg(args, Integer));

            '' long integer? (64-bit)

            Case Asc("l")

                Print Str(Cva_Arg(args, LongInt));

            '' single or double?

            '' Note: because the C ABI, all singles passed on

            '' var-args are converted to doubles.

            Case Asc( "f" ), Asc( "d" )

                Print Str(Cva_Arg(args, Double));

            '' string?

            Case Asc("s")

                '' Strings are passed byval, so the length is unknown

                Print *Cva_Arg(args, ZString Ptr);

            End Select

        '' Ordinary char, just print as-is

        Else

            Print Chr( char );

        End If

    Wend

    Cva_End( args )

End Sub

Dim As String s = "bar"

myprintf(!"integer=%i, longint=%l single=%f, double=%d, string=%s, string=%s\n", _

         1, 1ll Shl 32, 2.2, 3.3, "foo", s)
```

---

**Category:** [Procedures](Category-Procedures)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
