[Home](Home) › [Miscellaneous Keywords](Category-Miscellaneous-Keywords) › **Rem**

# Rem

Indicates comments in the source code.

## Syntax

```freebasic
Rem comment
' Comment
/' Multi-line
comment '/
```

## Description

A source code line beginning with `Rem` indicates that the line is a comment and will not be compiled.

 The single quote character (') may also be used to indicate a comment and may appear after other keywords on a source line.

 Multi-line comments are marked with the tokens `/'` and `'/`. All text between the two markers is considered comment text and is not compiled.

## Remarks

### Differences from QB

- `Rem` may also appear after other keywords on a source line in FreeBASIC
- Multiline comments are new to FreeBASIC

### See also

- [`#if`](If)

## Examples

```freebasic
/' this is a multi line

comment as a header of

this example '/

Rem This Is a Single Line comment

' this is a single line comment

? "Hello" : Rem comment following a statement

Dim a As Integer ' comment following a statement

? "FreeBASIC" : ' also acceptable

Dim b As /' can comment in here also '/    Integer

#if 0

    This way of commenting Out code was

    required before version 0.16

#endif
```

---

**Category:** [Miscellaneous Keywords](Category-Miscellaneous-Keywords)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
