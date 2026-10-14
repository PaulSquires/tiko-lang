[Home](Home) › [Screen Functions](Category-Screen-Functions) › **Screen (Graphics)**

# Screen (Graphics)

Initializes a graphics mode using QB-like mode numbers

## Syntax

```freebasic
-lang fb|fblite dialects:
Screen mode [, [ depth ] [, [ num_pages ] [, [ flags ] [, [ refresh_rate ]]]]]
Screen , [ active_page ] [, [ visible_page ]]
-lang qb dialect:
Screen [ mode ] [, [ colormode ] [, [ active_page ] [, [ visible_page ]]]]
```

## Parameters

- `mode`
- `mode`
- `depth`
- `num_pages`
- `flags`
- `refresh_rate`
- `active_page`
- `visible_page`
- `colormode`

## Description

`Screen` tells the compiler to link the GfxLib and initializes a QB-only, QB-on-GUI or OpenGL graphics mode, depending on the `flags` setting.

 In QB-only modes a dumb window or fullscreen resolution is set, one or more buffers in standard memory are created, console commands are redirected to their graphic versions, a [default palette](Default-Palettes) is set and an automatic screen refresh thread is started. QB-like graphics and console statements can be used.

 In QB-on-GUI modes one or more buffers in standard memory are created, console commands are redirected to their graphic versions and a [default palette](Default-Palettes) is set. QB-like graphics and console statements can be used. It is up to the user to create a window and to refresh it with the contents of the graphics buffers.

 In OpenGL modes a dumb window or fullscreen resolution is set, one or more buffers in standard memory are created, and the OS's OpenGL library is initialized. From here only OpenGL commands can be used; QB-like and console commands are forbidden. This allows to initialize OpenGL in a portable way; you can then also use [`ScreenControl`](Screencontrol) to properly customize the GL pixel format to be used before `Screen` is called or to retrieve the list of supported OpenGL extensions after a mode has been set, and [`ScreenGLProc`](Screenglproc) to obtain extension function pointers.

 Any buffer that is created in standard memory uses one of three supported internal pixel formats, depending on the desired color depth; see Internal pixel formats for details.

 If `Screen` fails to set the required mode, an "Illegal function call" error is issued and the screen pointer is set to `0`. Thus `Screen` failures can be detected using standard [`On Error`](On-Error) processing or retrieving the screen pointer with [`ScreenPtr`](Screenptr).

 Before setting a fullscreen mode the program should check if that mode is available in the graphics card using [`ScreenList`](Screenlist).

 *mode details*

Available modes list:

QB compatibility modes:

| Mode nr | Resolution | Emulation | Text | char size | colors on screen |
| --- | --- | --- | --- | --- | --- |
| 1 | 320x200 | CGA | 40X25 | 8x8 | 16 background, 1 of four sets foreground |
| 2 | 640x200 | CGA | 80x25 | 8x8 | 16 colors to 2 attributes |
| 7 | 320x200 | EGA | 40x25 | 8x8 | 16 colors to 16 attributes |
| 8 | 640x200 | EGA | 80x25 | 8x8 | 16 colors to 16 attributes |
| 9 | 640x350 | EGA | 80x25 0r 80x43 | 8x14 or 8x8 | 16 colors to 16 attributes |
| 11 | 640x480 | VGA | 80x30 or 80x60 | 8x16 or 8x8 | 256K colors to 2 attributes |
| 12 | 640x480 | VGA | 80x30 or 80x60 | 8x16 or 8x8 | 256K colors to 16 attributes |
| 13 | 320x200 | MCGA | 40X25 | 8X8 | 256K colors to 256 attributes |

(the mode number '0' is dedicated to text mode)

New FreeBASIC modes:

| Mode nr | Resolution | Emulation | Text | char size | colors on screen |
| --- | --- | --- | --- | --- | --- |
| 14 | 320x240 | | 40x30 | 8x8 | 256K colors to 256 attributes or direct color |
| 15 | 400x300 | | 50x37 | 8x8 | 256K colors to 256 attributes or direct color |
| 16 | 512x384 | | 64x24 or 64x48 | 8x16 or 8x8 | 256K colors to 256 attributes or direct color |
| 17 | 640x400 | | 80x25 or 80x50 | 8x16 or 8x8 | 256K colors to 256 attributes or direct color |
| 18 | 640x480 | | 80x30 or 80x60 | 8x16 or 8x8 | 256K colors to 256 attributes or direct color |
| 19 | 800x600 | | 100x37 or 100x75 | 8x16 or 8x8 | 256K colors to 256 attributes or direct color |
| 20 | 1024x768 | | 128x48 or 128x96 | 8x16 or 8x8 | 256K colors to 256 attributes or direct color |
| 21 | 1280x1024 | | 160x64 or 160x128 | 8x16 or 8x8 | 256K colors to 256 attributes or direct color |

*`depth` details*

For modes `14` and up, the depth parameter changes the color depth to the specified new one; if depth is not specified, these modes run in 8bpp. For modes `13` and below, `depth` has no effect.

*`num_pages` details*

You can request any number of pages for any video mode; if you omit the parameter, only the visible page (number `0`) will be available. A page is either the visible screen or an offscreen buffer, you can show a page while working on another one; see the [`ScreenSet`](Screenset) statement for details. All pages are created in standard memory, the video card memory is never used for video buffering.

*`flags` details:*

(documented at the page [ScreenRes](Screenres))

*Other details*

While in windowed mode, clicking on the window close button will add a keypress of `(Chr(255) & "k")` to the [`Inkey`](Inkey) buffer. Clicking on the Maximize window button will switch to fullscreen mode if possible. A successful `Screen` call sets currently visible and working pages both to page number `0`, resets the palette to the specified mode one (see [Default palettes](Default-Palettes)), resets the clipping region to the size of the screen, disables custom coordinates mappings, moves the graphics cursor to the center of the screen, moves the text cursor to the top-left corner of the screen (but never visible on any graphics screen), and sets foreground and background colors to bright white and black respectively.

*Note on using `Screen 0` (text mode only)*

The default BASIC screen mode (`Screen 0`) is text based.  
 `Screen 0` closes any graphics window, but also clears the console window if it exists.  
 `Screen 0, , , GFX_SCREEN_EXIT` (with `GFX_SCREEN_EXIT=&h80000000`) also closes any graphics window, but does not clear the console window if it exists (previous text is preserved).

## Remarks

### Platform Differences

- In DOS, Windowing and OpenGL related switches are not available, and other issues, see [GfxLib overview](Gfxlib-Freebasic-Graphics-Library-Overview)

### Dialect Differences

- In the *[-lang fb](Compiler-Option-Lang)* and *[-lang fblite](Compiler-Option-Lang)* dialects, the usage is:

`Screen mode [, [depth] [, [num_pages] [, [flags] [, [refresh_rate]]]]]`  
 or:  
 `Screen , [active_page] [, [visible_page]]]`

- In the *[-lang qb](Compiler-Option-Lang)* dialect, the usage is:

`Screen [mode] [, [colormode] [, [active_page] [, [visible_page]]]]`

### Differences from QB

- None in the *[-lang qb](Compiler-Option-Lang)* dialect.
  In QB the syntax was `Screen mode,colormode,active_page,visible_page`. Of those parameters FreeBASIC supports only *mode* and redefines the rest. The use of `Screen , , apage,vpage` to swap screen pages is only available in the *[-lang qb](Compiler-Option-Lang)* dialect.  
  [`ScreenSet`](Screenset) should be used in the *[-lang fb](Compiler-Option-Lang)* and *[-lang fblite](Compiler-Option-Lang)* dialects.

### See also

- [`Screen (Console)`](Screen-Console)
- [`ScreenRes`](Screenres) More flexible alternative to `Screen`
- [`ScreenList`](Screenlist) Check display modes available for FB GfxLib to use
- [`ScreenControl`](Screencontrol) Select driver and more
- [`ScreenLock`](Screenlock)
- [`ScreenUnlock`](Screenunlock)
- [`ScreenPtr`](Screenptr) Semi-low level access
- [`ScreenSet`](Screenset)
- [`ScreenCopy`](Screencopy)
- [`ScreenInfo`](Screeninfo)
- [`ScreenGLProc`](Screenglproc)

## Examples

```freebasic
' Sets screen mode 13 (320*200, 8bpp)

Screen 13

Print "Screen mode 13 set"

Sleep
```

```freebasic
#include "fbgfx.bi"

#if __FB_LANG__ = "fb"

Using FB '' Screen mode flags are in the FB namespace in lang FB

#endif

' Sets screen mode 18 (640*480) with 32bpp color depth and 4 pages, in windowed mode; switching disabled

Screen 18, 32, 4, (GFX_WINDOWED Or GFX_NO_SWITCH)

' Check to make sure Screen was opened successfully

If ScreenPtr = 0 Then

    Print "Error setting video mode!"

    End

End If

Print "Successfully set video mode"

Sleep
```

---

**Category:** [Screen Functions](Category-Screen-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
