[Home](Home) › [Procedures](Category-Procedures) › **Cva_List**

# Cva_List

Variadic argument list object type

## Syntax

```freebasic
Dim variable As Cva_List
```

## Description

`Cva_List` is a built in data type for working with the variable length argument list in a variadic procedure.

 Use [`Cva_Start`](Cva-Start) to initialize the `Cva_List` variable (constructor).  
 Use [`Cva_Copy`](Cva-Copy) to copy a `Cva_List` variable (copy constructor).  
 Use [`Cva_Arg`](Cva-Arg) to obtain the value of the next argument.  
 Use [`Cva_End`](Cva-End) when finished with a `Cva_List` variable (destructor).

 The exact type and size of `Cva_List` varies depending on the target platform. This builtin type provides a layer of abstraction over the underlying mechanism for obtaining the values passed to a variadic procedure.

 fbc will select a default `Cva_List` type depending on [-target](Compiler-Option-Target), [-arch](Compiler-Option-Arch), and [-gen](Compiler-Option-Gen) command line options, as described in the following code.

```freebasic
#if (__FB_BACKEND__ = "gcc")

    #if defined( __FB_64BIT__ )

        #if defined( __FB_ARM__ )

            Type __va_list Alias "__va_list"

                As Any Ptr __stack

                As Any Ptr __gr_top

                As Any Ptr __vr_top

                As Long __gr_offs

                As Long __vr_offs

            End Type

            Type Cva_List As __va_list Alias "__builtin_va_list"

        #elseif defined( __FB_WIN32__ )

            Type Cva_List As Any Alias "__builtin_va_list" Ptr

        #else

            Type __va_list_tag Alias "__va_list_tag"

                As ULong gp_offset

                As ULong fp_offset

                As Any Ptr overflow_arg_area

                As Any Ptr reg_save_area

            End Type

            Type Cva_List As __va_list_tag Alias "__builtin_va_list[]"

        #endif

    #else

        Type Cva_List As Any Alias "__builtin_va_list" Ptr

    #endif

#else

    Type Cva_List As Any Alias "char" Ptr

#endif
```

## Remarks

### Version

- Since fbc 1.07.0

### Platform Differences

- The exact type and size of `Cva_List` depends on [-target](Compiler-Option-Target), [-arch](Compiler-Option-Arch), [-gen](Compiler-Option-Gen) command line options.
  In [`-gen gas`](Compiler-Option-Gen), `Cva_List` is a pointer  
  In [`-gen gcc`](Compiler-Option-Gen), `Cva_List` is a pointer, a struct, or a struct array. The `Cva_List` type is replaced by `"__builtin_va_list"` in gcc.  
  On 32-bit targets, gas backend: `type Cva_List as any alias "char" ptr`.  
  On 32-bit targets, gcc backend: `type Cva_List as any alias "__builtin_va_list" ptr`  
  On Windows 64-bit, gcc backend: `type Cva_List as any alias "__builtin_va_list" ptr`  
  On Linux x86_64, gcc backend: `type Cva_List as __va_list_tag alias "__builtin_va_list[]"`  
  On arm64, gcc backend: `type Cva_List as __va_list alias "__builtin_va_list"`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__cva_list`.

### Differences from QB

- New to FreeBASIC

### See also

- [... (Ellipsis)](Ellipsis)
- [`Cva_Arg`](Cva-Arg)
- [`Cva_Start`](Cva-Start)
- [`Cva_Copy`](Cva-Copy)
- [`Cva_End`](Cva-End)

## Examples

```freebasic
Function average cdecl(count As Integer, ... ) As Double

    Dim sum As Double = 0

    Dim i As Integer

    Dim args As Cva_List '' argument list object

    Cva_Start( args, count ) '' constructor

    For i = 1 To count

        sum += Cva_Arg(args, Double)

    Next

    Cva_End( args ) '' destructor

    Return sum / count

End Function

Print average(4, 3.4 ,5.0, 3.2, 4.1) '' all passed variable arguments must be of type double

Print average(2, 65.2, 454.65481)    '' all passed variable arguments must be of type double
```

 The output would look like:

```freebasic
 3.925
 259.927405
```

```freebasic
'' pass the args list to a function taking an cva_list type argument

#include "crt/stdio.bi"

Sub myprintf cdecl( fmt As ZString Ptr, ... )

    Dim args As Cva_List

    Cva_Start( args, fmt )

    vprintf( fmt, args )

    Cva_End( args )

End Sub

Dim As String s = "bar"

myprintf( !"integer=%i, longint=%lli float=%f\n", _

    1, 1ll Shl 32, 3.3 )

myprintf( !"string=%s, string=%s\n", "foo", s )
```

---

**Category:** [Procedures](Category-Procedures)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
