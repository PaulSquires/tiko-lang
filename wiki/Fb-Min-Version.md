[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_MIN_VERSION__**

# __FB_MIN_VERSION__

Macro function to test minimum compiler version

## Syntax

```freebasic
#define __FB_MIN_VERSION__( major, minor, patch) _
((__FB_VER_MAJOR__ > major) or _
((__FB_VER_MAJOR__ = major) and ((__FB_VER_MINOR__ > minor) or _
(__FB_VER_MINOR__ = minor and __FB_VER_PATCH__ >= patch_level))))
```

## Parameters

- `major`
- `minor`
- `patch`

## Description

`__FB_MIN_VERSION__` tests for a minimum version of the compiler.

## Return Value

Returns zero (0) if the compiler version is less than the specified version, or non-zero (-1) if the compiler version is greater than or equal to specified version

## Remarks

### Usage

`__FB_MIN_VERSION__( major, minor, patch)`

### Differences from QB

- New to FreeBASIC

### See also

- [#if](If)

## Examples

```freebasic
#if Not __FB_MIN_VERSION__(0, 18, 2)

     #error fbc must be at least version 0.18.2 To compile This module

#endif
```

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
