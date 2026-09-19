[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_VER_MAJOR__**

# __FB_VER_MAJOR__

Intrinsic define (macro value) set by the compiler

## Syntax

```freebasic
__FB_VER_MAJOR__
```

## Description

`__FB_VER_MAJOR__` will return the major version of FreeBASIC currently being used. For example, the major version is 0 for FreeBASIC 0.90, and will remain 0 until FreeBASIC version 1.0 is released.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`__FB_VER_MINOR__`](Fb-Ver-Minor)
- [`__FB_VER_PATCH__`](Fb-Ver-Patch)

## Examples

```freebasic
Dim fbMajorVersion As Integer

Dim fbMinorVersion As Integer

Dim fbPatchVersion As Integer

fbMajorVersion = __FB_VER_MAJOR__

fbMinorVersion = __FB_VER_MINOR__

fbPatchVersion = __FB_VER_PATCH__

Print "Welcome to FreeBASIC " & fbMajorVersion & "." & fbMinorVersion & "." & fbPatchVersion
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
