[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_VER_PATCH__**

# __FB_VER_PATCH__

Intrinsic define (macro value) set by the compiler

## Syntax

```freebasic
__FB_VER_PATCH__
```

## Description

`__FB_VER_PATCH__` will return the patch/subversion/revision number the version of FreeBASIC currently being used. For FreeBASIC 0.18, for example, there were subversions 1, 2, 3, 4, 5 and 6, resulting in versions 0.18.1 through 0.18.6.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`__FB_VER_MAJOR__`](Fb-Ver-Major)
- [`__FB_VER_MINOR__`](Fb-Ver-Minor)

## Examples

```freebasic
Dim fbMajorVersion As Integer

Dim fbMinorVersion As Integer

Dim fbPatchVersion As Integer

fbMajorVersion = __FB_VER_MAJOR__

fbMinorVersion = __FB_VER_MINOR__

fbPatchVersion = __FB_VER_PATCH__

Print "Welcome to FreeBASIC " & fbMajorVersion & "." & fbMinorVersion & ", revision " & fbPatchVersion
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
