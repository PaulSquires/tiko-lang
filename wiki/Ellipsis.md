[Home](Home) › [Procedures](Category-Procedures) › **... (Ellipsis)**

# ... (Ellipsis)

Used in place of procedure parameter to pass a variable number of arguments, or as the upper bound in an array declaration to denote that the number of elements will be determined by the initializer.

## Syntax

```freebasic
Declare { Sub | Function } proc_name cdecl ( param_list, ... ) { | [ ByRef ] As return_type }
#define identifier( [ parameters, ] variadic_parameter... ) body
Dim array_symbol ([lbound To] ...) [As datatype] => { expression_list }
```

## Description

*Variadic Procedures*

The ellipsis (three dots, `...`) is used in procedure declarations and definitions to indicate a variable argument list.

 A first argument (at least) must always be specified and the procedure must be called with the C calling convention [`cdecl`](Cdecl).

 In the procedure body, [`Cva_List`](Cva-List) data type, and [`Cva_Arg`](Cva-Arg) macro can be used to expand the ellipsis parameter (`...`) to obtain the values of the arguments passed to the variadic procedure. The argument list, once initialized with [`Cva_Start`](Cva-Start) or copied with [`Cva_Copy`](Cva-Copy), can be passed to another procedure taking a [`Cva_List`](Cva-List) parameter.

 On some targets, for backwards compatibility, [`va_first`](Va-First), [`va_arg`](Va-Arg) and [`va_next`](Va-Next) can still be used to handle the variable arguments.

 Only numeric types and pointers are supported as variable arguments (all bytes and shorts passed on variable arguments are implicitly converted to integers, all singles passed on variable arguments are implicitly converted to doubles). [`String`](String)s can be passed, in which case a `ZString Ptr` to the string data is taken.

 A variadic procedure name can never be overloaded.

*Variadic Macros*

Using an ellipsis behind the last parameter in a [`#define`](Define) or [`#macro`](Macro-Endmacro) declaration allows creation of a variadic macro. This means it is possible to pass any number of arguments to the *variadic_parameter*, which can be used in the *body* as if it was a normal macro parameter. The *variadic_parameter* will expand to the full list of arguments passed to it, including commas, and can also be completely empty.

 **Note:** To distinguish between the different arguments passed by *variadic_parameter*, you can first convert *variadic_parameter* to a string using the [`Operator # (Preprocessor Stringize)`](Operator-Preprocessor-Stringize), then differentiate in this string (*#variadic_parameter*) each passed argument by locating the separators (usually a comma).

*Array Upper Bound*

Using an ellipsis in place of the upper bound in an array declaration causes the upper bound to be set according to the data that appears in the `expression_list`. When the ellipsis is used in this manner, an initializer must appear, and cannot be [`Any`](Any).

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`cdecl`](Cdecl)
- [`Cva_List`](Cva-List)
- [`Cva_Arg`](Cva-Arg)
- [`va_arg`](Va-Arg)
- [`va_first`](Va-First)
- [`va_next`](Va-Next)
- [`Dim`](Dim)
- [`Static`](procedures-Static)
- [`#define`](Define)

## Examples

`Declare Function foo cdecl (x As Integer, ...) As Integer`

```freebasic
Dim As Integer myarray(0 To ...) = {0, 1, 2, 3}

Print LBound(myarray), UBound(myarray)   '' 0, 3
```

```freebasic
'' Using a variadic macro to wrap a variadic function

#include "crt.bi"

#define eprintf(Format, args...) fprintf(stderr, Format, args)

eprintf(!"Hello from printf: %i %s %i\n", 5, "test", 123)

'' LISP-like accessors allowing to modify comma-separated lists

#define car(a, b...) a

#define cdr(a, b...) b
```

---

**Category:** [Procedures](Category-Procedures)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
