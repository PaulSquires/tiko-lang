[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FUNCTION_NQ__**

# __FUNCTION_NQ__

Intrinsic define (macro string) set by the compiler

## Syntax

```freebasic
__FUNCTION_NQ__
```

## Description

Substituted with the non-quoted name of the current function block where used.

 If `__FUNCTION_NQ__` is used at the module level, the function name given will be `__FB_MAINPROC__` for the main module, or `__FB_MODLEVELPROC__` for a different module. This is not the actual function name though, so it's not as useful there.

## Remarks

### Differences from QB

- Did not exist in QB

### See also

- [`__FILE_NQ__`](File-Nq)
- [`__FUNCTION__`](Function)
- [`__LINE__`](Line)

## Examples

```freebasic
Sub MySub

  Print "Address of " + __FUNCTION__ + " is ";

  Print Hex( @__FUNCTION_NQ__ )

End Sub

MySub
```

```freebasic
Address of MYSUB is 4012D0
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
