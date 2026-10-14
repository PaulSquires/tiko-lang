[Home](Home) › [Intrinsic Defines](Category-Intrinsic-Defines) › **__FB_OPTIMIZE__**

# __FB_OPTIMIZE__

Intrinsic define set by the compiler

## Syntax

```freebasic
__FB_OPTIMIZE__
```

## Description

Always defined and will have a value from 0 to 3 (0 by default) to indicate the optimization level passed to the backend compiler via [-O](Compiler-Option-O-2).

## Remarks

### Differences from QB

- Did not exist in QB

### See also

- [Compiler Option: -O](Compiler-Option-O-2)

## Examples

`Print "Optimization level is: " & __FB_OPTIMIZE__`

---

**Category:** [Intrinsic Defines](Category-Intrinsic-Defines)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
