[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_BACKEND__**

# __FB_BACKEND__

Intrinsic define set by the compiler

## Syntax

```freebasic
__FB_BACKEND__
```

## Description

Defined to either `"gas"` or `"gcc"`, depending on which backend was specified via [-gen](Compiler-Option-Gen).

## Remarks

### Differences from QB

- Did not exist in QB

## Examples

`Print "Back end is: " & __FB_BACKEND__`

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
