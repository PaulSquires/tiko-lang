[Home](Home) › [Console Functions](Category-Console-Functions) › **Width**

# Width

Sets or returns the number of columns and rows of the console.

## Syntax

```freebasic
Width [columns] [, rows]
Width LPrint columns
Width { #filenum | devicename }, columns
result = Width( )
```

## Parameters

- `columns`
- `rows`
- `filenum`
- `devicename`

## Description

Sets the maximum number of columns of characters of an output device (console, printer or text file). If text sent to the device reaches the width an automatic carriage return is generated.

 Using `Width` as a function returns the current console width in the low word and the current height in the high word.

 If a device is not given then `Width` takes effect on the active console/graphics screen, and a second argument specifying maximum number of rows is allowed.

 In graphics modes `Width` is used to indirectly select the font size by setting one of the character height \* width pairs allowed (See [`Screen (Graphics)`](Screen-Graphics)). If `rows` / `cols` is an invalid combination, no changes are made to the screen display.  
 Valid font heights are 8 pixels, 14 pixels and 16 pixels. The fonts all have a fixed width of 8 pixels.  
 (see second example)

 Using the `Width` command in graphic mode also forces a screen clear ([`Cls`](Cls)).

## Return Value

Returns a 32 bit [`Long`](Long) where the [High Word](Hiword) is the number of rows and the [Low Word](Loword) is the number of columns currently set.

## Remarks

### Platform Differences

- In a Windows console any values > `0` can be used in windowed mode.
- On a DOS or Windows full-screen console, the valid dimensions depend on the capabilities of the hardware.
- Linux doesn't allow applications to change the console size.

### Differences from QB

- `columns` was limited to `40` or `80`, while `rows` could be `25`, `30`, `43`, `50` or `60`, depending on the graphics hardware and screen mode being used.

### See also

- [`LoWord`](Loword)
- [`HiWord`](Hiword)
- [`CsrLin`](Csrlin)
- [`Pos`](Pos)

## Examples

```freebasic
Dim As Long w

w = Width

Print "rows: " & HiWord(w)

Print "cols: " & LoWord(w)
```

```freebasic
''Set up a graphics screen

Const W = 320, H = 200

ScreenRes W, H

Dim As Long twid

Dim As UInteger tw, th

'' Fetch and print current text width/height:

twid = Width()

tw = LoWord(twid): th = HiWord(twid)

Print "Default for current screen (8*8)"

Print "Width:  " & tw

Print "Height: " & th

Sleep

Width W\8, H\16 '' Use 8*16 font

twid = Width()

tw = LoWord(twid): th = HiWord(twid)

Print "Set to 8*16 font"

Print "Width:  " & tw

Print "Height: " & th

Sleep

Width W\8, H\14 '' Use 8*14 font

twid = Width()

tw = LoWord(twid): th = HiWord(twid)

Print "Set to 8*14 font"

Print "Width:  " & tw

Print "Height: " & th

Sleep

Width W\8, H\8 '' Use 8*8 font

twid = Width()

tw = LoWord(twid): th = HiWord(twid)

Print "Set to 8*8 font"

Print "Width:  " & tw

Print "Height: " & th

Sleep
```

---

**Category:** [Console Functions](Category-Console-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
