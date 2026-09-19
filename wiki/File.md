[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FILE__**

# __FILE__

Intrinsic define (macro string) set by the compiler

## Syntax

```freebasic
__FILE__
```

## Description

Substituted with the quoted source file name where used.

 An example of normal use is to report wrong values in debugging.

## Remarks

### Differences from QB

- Did not exist in QB

### See also

- [`__FILE_NQ__`](File-Nq)
- [`__FUNCTION__`](Function)
- [`__LINE__`](Line)

## Examples

```freebasic
Dim a As Integer

If a<0 Then

    Print "Error: a = " & a & " in " & __FILE__ & " (" & __FUNCTION__ & ") line " & __LINE__

End If
```

```freebasic
Error: a = -32767 in test.bas (MAIN) line 47
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
