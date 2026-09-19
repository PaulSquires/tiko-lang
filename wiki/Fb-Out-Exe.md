[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_OUT_EXE__**

# __FB_OUT_EXE__

Intrinsic define (macro value) set by the compiler

## Syntax

```freebasic
__FB_OUT_EXE__
```

## Description

`__FB_OUT_EXE__` indicates that the specified output file type on the compiler command line at the time of compilation is an executable.

 Returns non-zero (-1) if the output is an executable. Returns zero (0) otherwise.

 Only one of [`__FB_OUT_DLL__`](Fb-Out-Dll), `__FB_OUT_EXE__`, [`__FB_OUT_LIB__`](Fb-Out-Lib), or [`__FB_OUT_OBJ__`](Fb-Out-Obj) will evaluate to non-zero (-1). All others will evaluate to zero (0).

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`__FB_OUT_DLL__`](Fb-Out-Dll)
- [`__FB_OUT_LIB__`](Fb-Out-Lib)
- [`__FB_OUT_OBJ__`](Fb-Out-Obj)

## Examples

```freebasic
#if __FB_OUT_EXE__

        '... specific instructions when making an executable

#else

        '... specific instructions when not making an executable

#endif
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
