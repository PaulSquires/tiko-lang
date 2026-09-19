[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_OUT_OBJ__**

# __FB_OUT_OBJ__

Intrinsic define (macro value) set by the compiler

## Syntax

```freebasic
__FB_OUT_OBJ__
```

## Description

`__FB_OUT_OBJ__` indicates that the specified output file type on the compiler command line at the time of compilation is an object module.

 Returns non-zero (-1) if the output is an object module. Returns zero (0) otherwise.

 Only one of [`__FB_OUT_DLL__`](Fb-Out-Dll), [`__FB_OUT_EXE__`](Fb-Out-Exe), [`__FB_OUT_LIB__`](Fb-Out-Lib), or `__FB_OUT_OBJ__`, will evaluate to non-zero (-1). All others will evaluate to zero (0).

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`__FB_OUT_EXE__`](Fb-Out-Exe)
- [`__FB_OUT_DLL__`](Fb-Out-Dll)
- [`__FB_OUT_LIB__`](Fb-Out-Lib)

## Examples

```freebasic
#if __FB_OUT_OBJ__

        '... specific instructions when compiling to an object file only

#else

        '... specific instructions when not compiling to an object file only

#endif
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
