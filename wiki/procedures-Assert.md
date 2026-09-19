[Home](Home) › [Preprocessor](Category-Preprocessor) › **#assert**

# #assert

Preprocessor conditional directive

## Syntax

```freebasic
#assert condition
```

## Parameters

- `condition`

## Description

Asserts the truth of a conditional expression at compile time. If `condition` is false, compilation will stop with an error.

 This statement differs from the [`Assert`](Assert) macro in that `#assert` is evaluated at compile-time and [`Assert`](Assert) is evaluated at run-time.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`Assert`](Assert)
- [`#if`](If)
- [`#error`](procedures-Error)

## Examples

```freebasic
Const MIN = 5, MAX = 10

#assert MAX > MIN '' cause a compile-time error if MAX <= MIN
```

---

**Category:** [Preprocessor](Category-Preprocessor)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
