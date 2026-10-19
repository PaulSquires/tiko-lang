[Home](Home) › [Screen Functions](Category-Screen-Functions) › **Flip**

# Flip

Shows the OpenGL back buffer, or copies a page as ScreenCopy does in other modes.

## Syntax

```freebasic
Declare Function Flip ( ByVal frompage As Long = -1, ByVal topage As Long = -1 ) As Long
```

## Parameters

- `frompage`
- `topage`

## Description

In normal graphics mode, `Flip` is an alias for [`PCopy`](Pcopy) and [`ScreenCopy`](Screencopy). See [`ScreenCopy`](Screencopy) for details.

 In OpenGL mode, `Flip` does a hardware page flip and displays the contents of the backbuffer. It is recommended that you call `Flip` regularly while in OpenGL mode, otherwise your app may also become unresponsive.

 The error code returned by `Flip` can be checked using [`Err`](Err) in the next line. The function version of `Flip` returns directly the error code as a 32 bit [`Long`](Long).

## Return Value

Returns zero (`0`) if successful, or a non-zero error code to indicate a failure.

## Remarks

### Usage

`Flip [ frompage ] [, topage ]`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Flip`.

### Differences from QB

- New to FreeBASIC

## Examples

```freebasic
ScreenRes 320, 240, 32, 2    'Sets up the screen to be 320x240 in 32-bit color with 2 video pages.

ScreenSet 1,0                'Sets the working page to 1 and the displayed page to 0

For n As Integer = 50 To 270

    Cls

    Circle (n, 50),50 ,RGB(255,255,0) 'Draws a circle with a 50 pixel radius in yellow on page 1

    Flip 1,0    'Copies our circle from page 1 to page 0

    Sleep 25

Next

Print "Now wasn't that neat!"

Print "Push any key."

Flip 1,0    'Copies our text from page 1 to page 0

Sleep
```

---

**Category:** [Screen Functions](Category-Screen-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
