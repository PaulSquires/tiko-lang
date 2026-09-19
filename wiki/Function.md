[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FUNCTION__**

# __FUNCTION__

Intrinsic define (macro string) set by the compiler

## Syntax

```freebasic
__FUNCTION__
```

## Description

Substituted with the quoted name of the current function block where used.

 Its normal use is to report wrong values in debugging.

 If `__FUNCTION__` is used at the module level, the function name given will be `"__FB_MAINPROC__"` for the main module, or `"__FB_MODLEVELPROC__"` for a different module.

## Remarks

### Differences from QB

- Did not exist in QB

### See also

- [`__FILE__`](File)
- [`__FUNCTION_NQ__`](Function-Nq)
- [`__LINE__`](Line)

## Examples

```freebasic
Dim a As Integer

'...

If a < 0 Then '' this shouldn't happen

    Print "Error: a = " & a & " in " & __FILE__ & " (" & __FUNCTION__ & ") line " & __LINE__

End If
```

```freebasic
Error: a = -32767 in test.bas (__FB_MAINPROC__) line 47
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
