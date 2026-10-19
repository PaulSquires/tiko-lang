[Home](Home) › [Screen Functions](Category-Screen-Functions) › **ScreenPtr**

# ScreenPtr

Returns a pointer to the work page's pixels, or 0 if no graphics mode is set.

## Syntax

```freebasic
Declare Function ScreenPtr ( ) As Any Ptr
```

## Description

`ScreenPtr` provides a way to directly read/write the working page's frame buffer. [`ScreenLock`](Screenlock) should be used before any read or writes are attempted. The pointer returned is valid up until any subsequent call to [`Screen (Graphics)`](Screen-Graphics) or [`ScreenRes`](Screenres), which invalidates it.

 `ScreenPtr` can also be used to test if a call to [`Screen (Graphics)`](Screen-Graphics) or [`ScreenRes`](Screenres) was successful, indicated by a non-NULL (`<> 0`) return value.

 In order to access a pixel in the screen buffer, you will need to know the screen's bytes per pixel and pitch (bytes per row), and also the width and height to avoid going out of bounds. This information can be found out using [`ScreenInfo`](Screeninfo).  
 Each row in the frame buffer is `pitch` bytes long. The frame buffer consists of `height` rows, stored in order of their position on the screen, running from top to bottom, left to right.

 Because of the design of FreeBASIC graphics library, `ScreenPtr` (if non-NULL) will always point to the backbuffer, and never to actual video RAM.

## Return Value

a pointer to the current work page frame buffer memory, or NULL (`0`) if no graphics mode is set.

## Remarks

### Usage

`result = ScreenPtr`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Screenptr`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Screen (Graphics)`](Screen-Graphics)
- [`ScreenRes`](Screenres)
- [`ScreenInfo`](Screeninfo)
- [`ScreenLock`](Screenlock)
- [`ScreenUnlock`](Screenunlock)

## Examples

```freebasic
Const SCREEN_WIDTH = 640, SCREEN_HEIGHT = 480

Dim As Long w, h, bypp, pitch

'' Make 8-bit screen.

ScreenRes SCREEN_WIDTH, SCREEN_HEIGHT, 8

'' Get screen info (w and h should match the constants above, bypp should be 1)

ScreenInfo w, h, , bypp, pitch

'' Get the address of the frame buffer. An Any Ptr

'' is used here to allow simple pointer arithmetic

Dim buffer As Any Ptr = ScreenPtr()

If (buffer = 0) Then

    Print "Error: graphics screen not initialized."

    Sleep

    End -1

End If

'' Lock the screen to allow direct frame buffer access

ScreenLock()

    '' Find the address of the pixel in the centre of the screen

    '' It's an 8-bit pixel, so use a UByte Ptr.

    Dim As Integer x = w \ 2, y = h \ 2

    Dim As UByte Ptr pixel = buffer + (y * pitch) + (x * bypp)

    '' Set the center pixel color to 10 (light green).

    *pixel = 10

'' Unlock the screen.

ScreenUnlock()

'' Wait for the user to press a key before closing the program

Sleep
```

```freebasic
Const SCREEN_WIDTH = 256, SCREEN_HEIGHT = 256

Dim As Long w, h, bypp, pitch

'' Make 32-bit screen.

ScreenRes SCREEN_WIDTH, SCREEN_HEIGHT, 32

'' Get screen info (w and h should match the constants above, bypp should be 4)

ScreenInfo w, h, , bypp, pitch

'' Get the address of the frame buffer. An Any Ptr

'' is used here to allow simple pointer arithmetic

Dim buffer As Any Ptr = ScreenPtr()

If (buffer = 0) Then

    Print "Error: graphics screen not initialized."

    Sleep

    End -1

End If

'' Lock the screen to allow direct frame buffer access

ScreenLock()

    '' Set row address to the start of the buffer

    Dim As Any Ptr row = buffer

    '' Iterate over all the pixels in the screen:

    For y As Integer = 0 To h - 1

        '' Set pixel address to the start of the row

        '' It's a 32-bit pixel, so use a ULong Ptr

        Dim As ULong Ptr pixel = row

        For x As Integer = 0 To w - 1

            '' Set the pixel value

            *pixel = RGB(x, x Xor y, y)

            '' Get the next pixel address

            '' (ULong Ptr will increment by 4 bytes)

            pixel += 1

        Next x

        '' Go to the next row

        row += pitch

    Next y

'' Unlock the screen.

ScreenUnlock()

'' Wait for the user to press a key before closing the program

Sleep
```

---

**Category:** [Screen Functions](Category-Screen-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
