[Home](Home) › [Procedures](Category-Procedures) › **va_first**

# va_first

Returns a pointer to the first argument in a variable argument list

## Syntax

```freebasic
pointer_variable = va_first()
```

## Description

The `va_first` function provides an untyped pointer value that points to the first variable argument passed to a function.

 Not supported when using [`-gen gcc`](Compiler-Option-Gen). Use [`Cva_List`](Cva-List) variadic argument list type for cross platform compatibility.

## Remarks

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Va_first`.

### Differences from QB

- New to FreeBASIC

### See also

- [... (Ellipsis)](Ellipsis)
- [`va_arg`](Va-Arg)
- [`va_next`](Va-Next)

## Examples

```freebasic
Function average cdecl(count As Integer, ... ) As Double

    Dim arg As Any Ptr

    Dim sum As Double = 0

    Dim i As Integer

    arg = va_first()

    For i = 1 To count

        sum += va_arg(arg, Double)

        arg = va_next(arg, Double)

    Next

    Return sum / count

End Function

Print average(4, 3.4,5.0,3.2,4.1)  '' all passed variable arguments must be of type double

Print average(2, 65.2,454.65481)   '' all passed variable arguments must be of type double

Sleep
```

 The output would look like:

```freebasic
3.925
259.927405
```

```freebasic
'' Example of a simple custom printf

Sub myprintf cdecl(ByRef formatstring As String, ...)

    '' Get the pointer to the first var-arg

    Dim As Any Ptr arg = va_first()

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

                Print Str(va_arg(arg, Integer));

                '' Note, different from C: va_next() must be

                '' used as va_arg() won't update the pointer.

                arg = va_next(arg, Integer)

            '' long integer? (64-bit)

            Case Asc("l")

                Print Str(va_arg(arg, LongInt));

                arg = va_next(arg, LongInt)

            '' single or double?

            '' Note: because the C ABI, all singles passed on

            '' var-args are converted to doubles.

            Case Asc( "f" ), Asc( "d" )

                Print Str(va_arg(arg, Double));

                arg = va_next(arg, Double)

            '' string?

            Case Asc("s")

                '' Strings are passed byval, so the length is unknown

                Print *va_arg(arg, ZString Ptr);

                arg = va_next(arg, ZString Ptr)

            End Select

        '' Ordinary char, just print as-is

        Else

            Print Chr( char );

        End If

    Wend

End Sub

    Dim As String s = "bar"

    myprintf(!"integer=%i, longint=%l single=%f, double=%d, string=%s, string=%s\n", _

             1, 1ll Shl 32, 2.2, 3.3, "foo", s)

    Sleep
```

---

**Category:** [Procedures](Category-Procedures)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
