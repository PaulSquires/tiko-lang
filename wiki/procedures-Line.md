[Home](Home) › [Preprocessor](Category-Preprocessor) › **#line**

# #line

Preprocessor directive to set the current line number and file name

## Syntax

```freebasic
#line number [ "name" ]
```

## Parameters

- `number`

## Description

Informs the compiler of a change in line number and file name and updates the [`__FILE__`](File) and [`__LINE__`](Line) macro values accordingly.

 Both compile time messages and run-time messages are affected by this directive.

 This directive allows other programs to generate source code for the FreeBASIC compiler and have it return warning and/or error messages that refer to the original source used by the other program.

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`__FILE__`](File)
- [`__LINE__`](Line)

## Examples

```freebasic
#line 155 "outside.src"

Error 1000

'' Output is:

'' Aborting due to runtime error 1000 at line 157 of outside.src()
```

---

**Category:** [Preprocessor](Category-Preprocessor)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
