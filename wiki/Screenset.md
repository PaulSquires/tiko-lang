[Home](Home) › [Screen Functions](Category-Screen-Functions) › **ScreenSet**

# ScreenSet

Sets which page is drawn on and which page is shown.

## Syntax

```freebasic
Declare Sub ScreenSet ( ByVal work_page As Long = -1, ByVal visible_page As Long = -1 )
```

## Parameters

- `work_page`
- `visible_page`

## Description

`ScreenSet` allows to set the current working page and the current visible page. Page numbers range from `0` to `num_pages - 1`, where `num_pages` is the number of pages specified when setting the graphics mode with [`ScreenRes`](Screenres) or [`Screen (Graphics)`](Screen-Graphics). You can use this function to achieve page-flipping or double-buffering.

 If you provide `visible_page` but omit `work_page`, only the visible page is changed. If you provide `work_page` but omit `visible_page`, only the work page is changed. If you omit both arguments, both work page and visible page are reset to page 0.

 `ScreenSet` provides one method of writing to the screen without instantly displaying changes to the user. See also [`ScreenLock`](Screenlock) / [`ScreenUnlock`](Screenunlock) for an alternative method of doing this.

 Note: The current cursor position is not handled independently for each video page. Therefore, when another working page is selected, the starting cursor position corresponds to the last cursor position on the previous working page (same behavior for the text cursor and the graphics cursor).

## Remarks

### Usage

`ScreenSet [ work_page ] [, visible_page ]`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Screenset`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Screen (Graphics)`](Screen-Graphics)
- [`ScreenRes`](Screenres)
- [`ScreenCopy`](Screencopy)
- [`ScreenLock`](Screenlock)
- [`ScreenUnlock`](Screenunlock)

## Examples

```freebasic
' Open graphics screen (320*200, 8bpp) with 2 pages

ScreenRes 320, 200, 8, 2

' Work on page 1 while displaying page 0

ScreenSet 1, 0

Dim As Integer x = -40

Do

    '' Clear the screen, draw a box, update x

    Cls

    Line (x, 80)-Step(39, 39), 4, BF

    x += 1: If (x > 319) Then x = -40

    ' Wait for vertical sync: only used to control refresh rate, can be put anywhere in the Do loop

    ScreenSync

    ' Copy work page to visible page

    ScreenCopy

Loop While Inkey = ""
```

---

**Category:** [Screen Functions](Category-Screen-Functions)  
**Kind:** sub

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
