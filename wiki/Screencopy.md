[Home](Home) › [Screen Functions](Category-Screen-Functions) › **ScreenCopy**

# ScreenCopy

Copies one graphics page onto another, by default the work page onto the shown one.

## Syntax

```freebasic
Declare Function ScreenCopy ( ByVal from_page As Long = -1, ByVal to_page As Long = -1 ) As Long
```

## Parameters

- `from_page`
- `to_page`

## Description

`from_page` is the page to copy from. If this argument is omitted, the current work page is assumed. `to_page` is the page to copy to. If this argument is omitted, the currently visible page is assumed. Page numbers range from `0` to `num_pages - 1`, where `num_pages` is the number of pages specified when setting the graphics mode with [`ScreenRes`](Screenres) or [`Screen (Graphics)`](Screen-Graphics).

 You can use this function to add a double buffer to your graphics. Any graphics screen mode with multiple pages supports this function.

 `ScreenCopy` is inactive if the destination page is locked.

 There are two other functions similar to this: [`Flip`](Flip) and [`PCopy`](Pcopy). [`Flip`](Flip) is designed to work in OpenGL modes, while [`PCopy`](Pcopy) supports console pages on some platforms. Both do the same thing as `ScreenCopy` in normal graphics modes.

 The error code returned by `ScreenCopy` can be checked using [`Err`](Err) in the next line. The function version of `ScreenCopy` returns directly the error code as a 32 bit [`Long`](Long).

## Return Value

Returns zero (`0`) if successful, or a non-zero error code to indicate a failure.

## Remarks

### Usage

`ScreenCopy [ from_page ] [, to_page ]`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Screencopy`.

### Differences from QB

- New to FreeBASIC. It is a graphics-only version of [`PCopy`](Pcopy) - which works in both text and graphics modes.

### See also

- [`PCopy`](Pcopy)
- [`Screen (Graphics)`](Screen-Graphics)
- [`ScreenRes`](Screenres)
- [`ScreenSet`](Screenset)

## Examples

See also [`ScreenSet`](Screenset) example.

```freebasic
'' 320x200x8, with 3 pages

Screen 13,,3

'' image for working page #1 (visible page #0)

ScreenSet 1, 0

Cls

Circle( 160, 100 ), 90, 1 ,,,, f

Circle( 160, 100 ), 90, 15

Print "Press 2 to copy page #2 to visible page"

Print "Press escape to exit"

'' image for working page #2 (visible page #0)

ScreenSet 2, 0

Cls

Line( 50, 50 )-( 270, 150 ), 2, bf

Line( 50, 50 )-( 270, 150 ), 15, b

Print "Press 1 to copy page #1 to visible page"

Print "Press escape to exit"

'' page #0 is the working page (visible page #0)

ScreenSet 0, 0

Cls

Print "Press 1 to copy page #1 to visible page"

Print "Press 2 to copy page #2 to visible page"

Print "Press escape to exit"

Dim k As String

Do

  k = Inkey

  Select Case k

  Case Chr(27)

    Exit Do

  Case "1"

    ScreenCopy 1, 0

  Case "2"

    ScreenCopy 2, 0

  End Select

  Sleep 25

Loop
```

---

**Category:** [Screen Functions](Category-Screen-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
