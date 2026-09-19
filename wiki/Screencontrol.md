[Home](Home) › [Screen Functions](Category-Screen-Functions) › **ScreenControl**

# ScreenControl

Sets or gets internal graphics library settings

## Syntax

```freebasic
Declare Sub ScreenControl ( ByVal what As Const Long, ByRef param1 As Long = &h80000000, ByRef param2 As Long = &h80000000, ByRef param3 As Long = &h80000000, ByRef param4 As Long = &h80000000 )
Declare Sub ScreenControl ( ByVal what As Const Long, ByRef param1 As LongInt, ByRef param2 As LongInt = &h80000000, ByRef param3 As LongInt = &h80000000, ByRef param4 As LongInt = &h80000000 )
Declare Sub ScreenControl ( ByVal what As Const Long, ByRef param As String)
```

## Parameters

- `what`
- `param1`
- `param2`
- `param3`
- `param4`
- `param`

## Description

This function can be used to set or get internal GfxLib states. The `what` parameter specifies which operation to perform. On operations that set states, the `param*` parameters must contain the values to be set. On operations that get states, `param*` will hold the values returned by GfxLib when the function returns.  
 The meaning of the `param*` parameters depend on the `what` parameter, whose possible values are defined as constants in `fbgfx.bi`. In *[lang fb](Freebasic-Dialects)*, they are set to be stored in the `FB` [`Namespace`](Namespace).  
 Below is a list of the supported `what` constants - and their values as defined at time of writing - along with the parameters associated with them.

 *Supported operations*

Note:

(\*) denotes operations that are allowed while a graphics mode has not yet been set via [Screen (Graphics)](Screen-Graphics) or [ScreenRes](Screenres),  
 (\*\*) denotes the operations that must be performed before the graphics mode is set via [Screen (Graphics)](Screen-Graphics) or [ScreenRes](Screenres),  
 for all other operations, return values are zero (`0`) or the empty string (`"``"`) and the operation has no effect if a graphics mode is not available at call time.

**Get operations**

- `GET_WINDOW_POS` Returns the current window position, in desktop coordinates.

\[OUT\] `param1` x  
 \[OUT\] `param2` y

- (\*) `GET_WINDOW_TITLE` Returns the title of the program window.

\[OUT\] `param` title

- `GET_WINDOW_HANDLE` Returns a handle to the program window.

\[OUT\] `param1` handle; this is a `HWND` in Windows, a "Window" XID in X11  
 \[OUT\] `param2` display ptr in X11

- (\*) `GET_DESKTOP_SIZE` Returns the desktop size, in pixels.

\[OUT\] `param1` width  
 \[OUT\] `param2` height

- `GET_SCREEN_SIZE` Returns the current screen size in pixels.

\[OUT\] `param1` width  
 \[OUT\] `param2` height

- `GET_SCREEN_DEPTH` Returns current graphics mode screen depth.

\[OUT\] `param1` bits per pixel

- `GET_SCREEN_BPP` Returns current graphics mode BPP.

\[OUT\] `param1` bytes per pixel

- `GET_SCREEN_PITCH` Returns the current graphics mode framebuffer pitch, in bytes.

\[OUT\] `param1` pitch

- `GET_SCREEN_REFRESH` Returns the current graphics mode refresh rate, in hertz.

\[OUT\] `param1` rate

- `GET_DRIVER_NAME` Returns the current graphics mode driver name.

\[OUT\] `param` name

- `GET_TRANSPARENT_COLOR` Returns the transparent color value for the current graphics mode depth.

\[OUT\] `param1` value

- `GET_VIEWPORT` Returns the current viewport as set by the [View (Graphics)](View-Graphics) statement, in screen coordinates.

\[OUT\] `param1` x1  
 \[OUT\] `param2` y1  
 \[OUT\] `param3` x2  
 \[OUT\] `param4` y2

- `GET_PEN_POS` Returns the last graphical pen position, in screen coordinates. This position is used in graphics functions supporting relative coordinates using the [`Step`](Step) keyword.

\[OUT\] `param1` x  
 \[OUT\] `param2` y

- `GET_COLOR` Returns the current graphics mode color.

\[OUT\] `param1` foreground  
 \[OUT\] `param2` background

- `GET_ALPHA_PRIMITIVES` Returns if primitives drawing support for alpha channel is enabled.

\[OUT\] `param1` `TRUE` (`-1`) if alpha primitives is enabled, `FALSE` (`0`) otherwise

- `GET_GL_EXTENSIONS` Returns a string holding all supported GL extensions, or the empty string if not in OpenGL mode.

\[OUT\] `param` supported GL extensions

- `GET_HIGH_PRIORITY` Returns if `GFX_HIGH_PRIORITY` was specified in the flags passed to [`Screen (Graphics)`](Screen-Graphics) or [`ScreenRes`](Screenres).

\[OUT\] `param1` higher priority graphics processing enabled

- `GET_SCANLINE_SIZE` Returns how currently many scan lines each row of fbgfx video memory should occupy on the screen

\[OUT\] `param1` scan line size multiplier

- (\*) `GET_X86_MMX_ENABLED` Returns if MMX specific blitters are enabled on X86. fbgfx will select MMX blitters if MMX is enabled and available.

\[OUT\] `param1` `TRUE` (`-1`) if MMX is enabled, `FALSE` (`0`) otherwise

- `GET_GL_COLOR_BITS` Returns the current number of bits dedicated to the OpenGL color buffer

\[OUT\] `param1` bits

- `GET_GL_COLOR_RED_BITS` Returns the current number of bits dedicated to the red component of the OpenGL color buffer

\[OUT\] `param1` bits

- `GET_GL_COLOR_GREEN_BITS` Returns the current number of bits dedicated to the green component of the OpenGL color buffer

\[OUT\] `param1` bits

- `GET_GL_COLOR_BLUE_BITS` Returns the current number of bits dedicated to the blue component of the OpenGL color buffer

\[OUT\] `param1` bits

- `GET_GL_COLOR_ALPHA_BITS` Returns the current number of bits dedicated to the alpha component of the OpenGL color buffer

\[OUT\] `param1` bits

- `GET_GL_DEPTH_BITS` Returns the current number of bits dedicated to the OpenGL depth buffer

\[OUT\] `param1` bits

- `GET_GL_STENCIL_BITS` Returns the current number of bits dedicated to the OpenGL stencil buffer

\[OUT\] `param1` bits

- `GET_GL_ACCUM_BITS` Returns the current number of bits dedicated to the OpenGL accumulation buffer

\[OUT\] `param1` bits

- `GET_GL_ACCUM_RED_BITS` Returns the current number of bits dedicated to the red component of the OpenGL accumulation buffer

\[OUT\] `param1` bits

- `GET_GL_ACCUM_GREEN_BITS` Returns the current number of bits dedicated to the green component of the OpenGL accumulation buffer

\[OUT\] `param1` bits

- `GET_GL_ACCUM_BLUE_BITS` Returns the current number of bits dedicated to the blue component of the OpenGL accumulation buffer

\[OUT\] `param1` bits

- `GET_GL_ACCUM_ALPHA_BITS` Returns the current number of bits dedicated to the alpha component of the OpenGL accumulation buffer

\[OUT\] `param1` bits

- `GET_GL_NUM_SAMPLES` Returns the current number of samples to be used for OpenGL multisampling

\[OUT\] `param1` samples

- `GET_GL_2D_MODE` Returns the current OpenGL 2D render

\[OUT\] `param1`:

`OGL_2D_NONE` No rendering  
 `OGL_2D_MANUAL_SYNC` Manual rendering (when [`Flip`](Flip) is called)  
 `OGL_2D_AUTO_SYNC` Automatic rendering

- `GET_GL_SCALE` Returns the current zoom factor on OpenGL 2D render (only allowed if OpenGL 2D render mode has yet been activated via `SET_GL_2D_MODE`)

\[OUT\] `param1` zoom factor (0: no rendering)

 **Set operations**

- `SET_WINDOW_POS` Sets the current program window position, in desktop coordinates.

\[IN\] `param1` x  
 \[IN\] `param2` y

- (\*) `SET_WINDOW_TITLE` Sets the current program window title. This is equivalent to calling `WindowTitle( param )`.

\[IN\] `param` title

- `SET_PEN_POS` Sets the current graphical pen position, in screen coordinates. This position is used in graphics functions supporting relative coordinates using the [`Step`](Step) keyword.

\[IN\] `param1` x  
 \[IN\] `param2` y

- (\*) `SET_DRIVER_NAME` Sets the name of the internal graphics driver to be used in subsequent calls to [`Screen (Graphics)`](Screen-Graphics) or [`ScreenRes`](Screenres).

\[IN\] `param` driver name

- `SET_ALPHA_PRIMITIVES` Sets if primitives drawing should honor alpha channel.

\[IN\] `param1` enabled

- (\*) `SET_GL_COLOR_BITS` Sets the number of bits dedicated to the OpenGL color buffer

\[IN\] `param1` bits

- (\*) `SET_GL_COLOR_RED_BITS` Sets the number of bits dedicated to the red component of the OpenGL color buffer

\[IN\] `param1` bits

- (\*) `SET_GL_COLOR_GREEN_BITS` Sets the number of bits dedicated to the green component of the OpenGL color buffer

\[IN\] `param1` bits

- (\*) `SET_GL_COLOR_BLUE_BITS` Sets the number of bits dedicated to the blue component of the OpenGL color buffer

\[IN\] `param1` bits

- (\*) `SET_GL_COLOR_ALPHA_BITS` Sets the number of bits dedicated to the alpha component of the OpenGL color buffer

\[IN\] `param1` bits

- (\*) `SET_GL_DEPTH_BITS` Sets the number of bits dedicated to the OpenGL depth buffer

\[IN\] `param1` bits

- (\*) `SET_GL_STENCIL_BITS` Sets the number of bits dedicated to the OpenGL stencil buffer

\[IN\] `param1` bits

- (\*) `SET_GL_ACCUM_BITS` Sets the number of bits dedicated to the OpenGL accumulation buffer

\[IN\] `param1` bits

- (\*) `SET_GL_ACCUM_RED_BITS` Sets the number of bits dedicated to the red component of the OpenGL accumulation buffer

\[IN\] `param1` bits

- (\*) `SET_GL_ACCUM_GREEN_BITS` Sets the number of bits dedicated to the green component of the OpenGL accumulation buffer

\[IN\] `param1` bits

- (\*) `SET_GL_ACCUM_BLUE_BITS` Sets the number of bits dedicated to the blue component of the OpenGL accumulation buffer

\[IN\] `param1` bits

- (\*) `SET_GL_ACCUM_ALPHA_BITS` Sets the number of bits dedicated to the alpha component of the OpenGL accumulation buffer

\[IN\] `param1` bits

- (\*) `SET_GL_NUM_SAMPLES` Sets the number of samples to be used for OpenGL multisampling

\[IN\] `param1` samples

- (\*) `SET_X86_MMX_ENABLED` Sets if MMX blitters should be used on X86

\[IN\] `param1` enabled

- (\*\*) `SET_GL_2D_MODE` Sets OpenGL 2D render

\[IN\] `param1`:

`OGL_2D_NONE` No rendering  
 `OGL_2D_MANUAL_SYNC` Manual rendering (when [`Flip`](Flip) is called)  
 `OGL_2D_AUTO_SYNC` Automatic rendering

- (\*\*) `SET_GL_SCALE` Apply a zoom factor on OpenGL 2D render (only allowed if OpenGL 2D render mode has yet been activated via `SET_GL_2D_MODE`)

\[IN\] `param1` zoom factor (0: no rendering)

 **Other operations**

- `POLL_EVENTS` Cause the library to poll all events, ie to check the system event queue, specifically used for retrieving keyboard and mouse events. This is most useful for OpenGL code where [`Flip`](Flip) is not used, as normally [`Flip`](Flip) will cause these events to be polled.

## Remarks

### Usage

```freebasic
in the LONG (or INTEGER<32>) version of the sub:

ScreenControl( what [, [ param1 ] [, [ param2 ] [, [ param3 ] [, param4 ]]]] )

or,

ScreenControl( what , param )

in the LONGINT (or INTEGER<64>) version of the sub:

ScreenControl( what , param1 [, [ param2 ] [, [ param3 ] [, param4 ]]] )

or,

ScreenControl( what , param )
```

### Version

- Since fbc 1.20.0: `GET_X86_MMX_ENABLED`, `SET_X86_MMX_ENABLED`
- Since fbc 1.10.0: 16 getters from `GET_SCANLINE_SIZE` to `GET_GL_SCALE` added.
- Before fbc 1.08.0:

Syntax:

```freebasic
Declare Sub ScreenControl ( ByVal what As Long, ByRef param1 As Integer = 0, ByRef param2 As Integer = 0, ByRef param3 As Integer = 0, ByRef param4 As Integer = 0 )

Declare Sub ScreenControl ( ByVal what As Long, ByRef param As String =
```

""`)`

Usage:

```freebasic
ScreenControl( what [, [ param1 ] [, [ param2 ] [, [ param3 ] [, [ param4 ]]]]] )

or,

ScreenControl( what [, param ] )
```

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Screencontrol`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Screen (Graphics)`](Screen-Graphics)
- [`ScreenEvent`](Screenevent)
- [`ScreenInfo`](Screeninfo)
- [`WindowTitle`](Windowtitle)
- [`View (Graphics)`](View-Graphics)

## Examples

```freebasic
'' include fbgfx.bi for some useful definitions

#include "fbgfx.bi"

'' use FB namespace for easy access to types/constants

Using FB

Dim e As Event

Dim As Long x0, y0, x, y

Dim As Integer shakes = 0

Dim As Any Ptr img

ScreenRes 320, 200, 32

Print "Click to shake window"

'' find window coordinates

ScreenControl GET_WINDOW_POS, x0, y0

Do

    If (shakes > 0) Then

        '' do a shake of the window

        If (shakes > 1) Then

            '' move window to a random position near its original coordinates

            x = x0 + Int(32 * (Rnd() - 0.5))

            y = y0 + Int(32 * (Rnd() - 0.5))

            ScreenControl SET_WINDOW_POS, x, y

        Else

            '' move window back to its original coordinates

            ScreenControl SET_WINDOW_POS, x0, y0

        End If

        shakes -= 1

    End If

    If (ScreenEvent(@e)) Then

        Select Case e.type

        '' user pressed the mouse button

        Case EVENT_MOUSE_BUTTON_PRESS

            If (shakes = 0) Then

                '' set to do 20 shakes

                shakes = 20

                '' find current window coordinates to shake around

                ScreenControl GET_WINDOW_POS, x0, y0

            End If

        '' user closed the window or pressed a key

        Case EVENT_WINDOW_CLOSE, EVENT_KEY_PRESS

            '' exit to end of program

            Exit Do

        End Select

    End If

    '' free up CPU for other programs

    Sleep 5

Loop
```

```freebasic
'' include fbgfx.bi for some useful definitions

#include "fbgfx.bi"

Dim As String driver

#ifdef __FB_WIN32__

'' set graphics driver to GDI (Windows only), before calling ScreenRes

ScreenControl FB.SET_DRIVER_NAME, "GDI"

#endif

ScreenRes 640, 480

'' fetch graphics driver name and display it to user

ScreenControl FB.GET_DRIVER_NAME, driver

Print "Graphics driver name: " & driver

'' wait for a keypress before closing the window

Sleep
```

---

**Category:** [Screen Functions](Category-Screen-Functions)  
**Kind:** sub

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
