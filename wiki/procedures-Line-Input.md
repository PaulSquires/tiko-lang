[Home](Home) › [User Input (Runtime Library)](Category-User-Input-Runtime-Library) › **Line Input**

# Line Input

Reads a whole typed line into a string, commas included, after an optional prompt.

## Syntax

```freebasic
Line Input [;] [promptstring {;|,} ] stringvariable1
Line Input [;] promptstring {;|,} stringvariable2 , maxlength
```

## Parameters

- `promptstring`
- `stringvariable1`
- `stringvariable2`
- `maxlength`

## Description

Reads a line of text from the keyboard and stores it in a string variable.

 The `promptstring` - if any - is written to the screen at the current cursor location, and characters read are echoed to the screen immediately following the prompt. If no prompt is specified, characters are echoed at the current cursor location.

 The optional leading semicolon (`;`) after `Line Input` is similar to the optional trailing semicolon in a [`Print`](Print) statement: the cursor will remain on the same line after all of the characters have been echoed, otherwise, the cursor will move to the beginning of the next line.

 `Line Input` has a limited edit capacity: it allows to use the left and right cursor keys to navigate the text, and to erase or insert characters. If a better user interface is needed, a custom input routine should be used.

 Two syntaxes are available:

## Remarks

### Differences from QB

- QBASIC only allowed literal strings for the prompt text. FreeBASIC allows any variable or constant string expression.

### See also

- [`Line Input #`](Line-Input)
- [`Input`](procedures-Input)

## Examples

```freebasic
Dim s As String

Line Input "Enter a line"; s

Print "Full line that you entered:"

Print "'"; s; "'"

Print

Const maxlength = 11  '' max 10 characters plus 1 null terminal character

Dim pz As ZString Ptr = CAllocate(maxlength, SizeOf(ZString))

Line Input "Enter a line"; *pz, maxlength

Print "First " & maxlength - 1 & " characters that you entered:"

Print "'"; *pz; "'"

Deallocate(pz)
```

---

**Category:** [User Input (Runtime Library)](Category-User-Input-Runtime-Library)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
