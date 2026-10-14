[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_QUOTE__**

# __FB_QUOTE__

Intrinsic define (macro) performed by the compiler.

## Syntax

```freebasic
__FB_QUOTE__( arg )
```

## Parameters

- `arg`

## Description

Converts the argument to a string, similar to stringize operator (#) but can be used anywhere (will expand the argument before conversion).  
 More precisely, `__FB_QUOTE__` returns an over-quoted text (prefixed with the [`Operator $ (Non-Escaped String Literal)`](Operator-Non-Escaped-String-Literal)) compared to the one passed through the argument (the argument may already be a string, and so the return will be an over-quoted string in this case).

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`__FB_UNQUOTE__`](Fb-Unquote)
- [`__FB_EVAL__`](Fb-Eval)

## Examples

```freebasic
#macro m( arg )

    Scope

        Dim s1 As String = #arg

        Print s1

        Dim s2 As String = __FB_QUOTE__( arg )

        Print s2

    End Scope

#endmacro

m(Hello)

Print

m("Hello")

Sleep

/' Output:

Hello

Hello

"Hello"

"Hello"

'/
```

```freebasic
#macro m( arg1, arg2 )

    Scope

        'Dim s0 As String = #arg1##arg2  ' does not work because arg1##arg2 is not developped before applying #

        Dim s1 As String = #arg1###arg2  ' workaround because #arg => $"arg" and not only "arg"

                                         '    (otherwise the result would be "arg1""arg2" => "arg1"arg2")

        Print s1

        Dim s2 As String = __FB_QUOTE__( arg1##arg2 )

        Print s2

    End Scope

#endmacro

m(Free, BASIC)

Sleep

/' Output:

FreeBASIC

FreeBASIC

'/
```

 See also [`__FB_UNQUOTE__`](Fb-Unquote) example.

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
