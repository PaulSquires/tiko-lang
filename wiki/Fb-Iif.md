[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_IIF__**

# __FB_IIF__

Intrinsic define (macro) performed by the compiler.

## Syntax

```freebasic
__FB_IIF__( compare-expr, true-expr, false-expr )
```

## Parameters

- `compare-expr`
- `true-expr`
- `compare-expr`
- `false-expr`
- `compare-expr`

## Description

`__FB_IIF__` returns source code text depending on the result of a comparison expression evaluated at preprocessing-time.  
 Its typical use is in the middle of an expression; it avoids splitting it to put a conditional in the middle.

 This intrinsic define (macro) differs from the [`IIf`](Iif) conditional statement in that `__FB_IIF__` is evaluated at compile-time only and returns source code text. [`IIf`](Iif) is evaluated at compile-time only if the `compare-expr` is a constant. Otherwise [`IIf`](Iif) expressions are evaluated at run-time.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`#if`](If)
- [`#else`](procedures-Else)
- [`#endif`](Endif)

## Examples

```freebasic
' From the example of the '#ELSE' documentation page:

    '#DEFINE MODULE_VERSION 1

    'Dim a As String

    '#IF (MODULE_VERSION > 0)

    '    a = "Release"

    '#ELSE

    '    a = "Beta"

    '#ENDIF

    'Print "Program is "; a

' Simpler code using '__FB_IIF__':

    #define MODULE_VERSION 1

    Dim a As String

    a = __FB_IIF__( MODULE_VERSION > 0, "Release", "Beta" )

    Print "Program is "; a
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
