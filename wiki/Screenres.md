[Home](Home) › [Screen Functions](Category-Screen-Functions) › **ScreenRes**

# ScreenRes

Initializes a graphics mode by specifying horizontal and vertical resolution

## Syntax

```freebasic
Declare Function ScreenRes ( ByVal width As Long, ByVal height As Long, ByVal depth As Long = 8, ByVal num_pages As Long = 1, ByVal flags As Long = 0, ByVal refresh_rate As Long = 0 ) As Long
```

## Parameters

- `width`
- `height`
- `depth`
- `num_pages`
- `flags`
- `refresh_rate`

## Description

`ScreenRes` tells the compiler to link the GfxLib and initializes a QB-only, QB-on-GUI or OpenGL graphics mode, depending on the `flags` setting.

 `ScreenRes` clears the created window or the full screen. In non-fullscreen modes, the resolution does not have to match any resolution of the graphics card. Resolutions like `555x111` are possible, GfxLib will create a window of such size. See the page [GfxLib overview](Gfxlib-Freebasic-Graphics-Library-Overview) for DOS issues.

 The font size in `ScreenRes` modes is set to 8x8 by default. This can be changed by setting the number of text rows/columns, using the [`Width`](Width) function.

 In QB-only modes a dumb window or fullscreen resolution is set, one or more buffers in standard memory are created, console commands are redirected to their graphic versions, a [default palette](Default-Palettes) is set and an automatic screen refresh thread is started. QB-like graphics and console statements can be used.

 In QB-on-GUI modes one or more buffers in standard memory are created, console commands are redirected to their graphic versions and a [default palette](Default-Palettes) is set. QB-like graphics and console statements can be used. It is up to the user to create a window and to refresh it with the contents of the graphics buffers.

 In OpenGL modes a dumb window or fullscreen resolution is set, one or more buffers in standard memory are created, and the system's OpenGL library is initialized. From here only OpenGL commands can be used to write to the graphics buffer. QB-like and console commands are forbidden. This mode allows to initialize OpenGL in a portable way.

 The error code returned by `ScreenRes` can be checked using [`Err`](Err) in the next line. The function version of `ScreenRes` returns directly the error code as a 32 bit [`Long`](Long).

 *`flags` details:*

 If flags are omitted, FreeBASIC uses QB-compatible graphics in windowed (except in DOS) mode. These constants are defined in `fbgfx.bi`. In the *[-lang fb](Compiler-Option-Lang)* dialect, these constants are part of the `FB` [`Namespace`](Namespace). Their values can be combined to form a mask using [`Operator Or`](Operator-or-Inclusive-Disjunction). Note that most of the flags are not supported in DOS.

 Available flags:

 *graphic mode flags*

`GFX_NULL`: Starts a QB-on-GUI graphics mode. It creates a graphics buffer but not a window. User must implement the window, the events manager and refresh the screen as needed. This mode allows to mix FreeBASIC drawing functions with API-driven windows. Alternatively, it allows to process graphics (for example files) without making it visible on the screen, even in a purely console application. This flag overrides all other mode flags. See an Example of GFX_NULL in Windows.  
 `GFX_OPENGL`: Initializes OpenGL to draw in a dumb window. FreeBASIC graphic functions can't be used. The screen is not automatically updated, [`Flip`](Flip) must be used. This option provides a portable way to initialize the OpenGL Library.  
 If none of the above options is specified, FreeBASIC enters the QB-only graphics mode: it creates a buffer and a dumb window and sets a thread that automatically updates the screen and manages keyboard and mouse. The FreeBASIC drawing functions can be used.

*window mode flags*

Window mode flags are meaningless if `GFX_NULL` mode is used  
 `GFX_WINDOWED`: If windowed mode is supported, FreeBASIC opens a window of the requested size in the present desktop  
 `GFX_FULLSCREEN`: The graphics card switch mode is switched to the requested mode and color depth and OS fullscreen mode is used. If the mode is not available in the present card FreeBASIC switches to windowed mode.  
 If `GFX_FULLSCREEN` is not specified, the behavior for `GFX_WINDOWED` is assumed.  
 `GFX_NO_SWITCH`: Prevents the user from changing to fullscreen or to windowed mode by pressing Alt-Enter.  
 `GFX_NO_FRAME`: Creates a window without a border.  
 `GFX_SHAPED_WINDOW`: Creates transparent regions wherever RGBA(255, 0, 255, 0) is drawn on the screen.  
 `GFX_ALWAYS_ON_TOP`: Creates a window that stays always on top.

*option flags*

Flags working in any mode, they activate special behaviors  
 `GFX_ALPHA_PRIMITIVES`: Tells the graphics library to enable alpha channel support for all drawing primitives. This means the alpha specified in a color value (via either the [`RGBA`](Rgba) macro or direct color in the form `&hAARRGGBB`) will always be used by all primitives.  
 `GFX_HIGH_PRIORITY`: Tells the graphics library to enable a higher priority for graphics processing. Only has an effect on `gdi` and `DirectX` drivers on Win32 platform and `Direct2D` added on new platforms.  
 `GFX_NO_X86_MMX`: Tells the graphics library not to use MMX blitters on X86 even if MMX cpu instructions are available.

*OpenGL Buffer flags*

These flags work only in OpenGL graphics mode, must be combined with GFX_OPENGL  
 `GFX_STENCIL_BUFFER`: Forces OpenGL to use Stencil buffer  
 `GFX_ACCUMULATION_BUFFER`: Forces OpenGL to use Accumulation buffer  
 `GFX_MULTISAMPLE`: Requests fullscreen anti-aliasing through the ARB_multisample extension

Depending on whether the `GFX_FULLSCREEN` parameter is present or not, `Screen` will try to set the specified video mode in fullscreen or windowed mode, respectively. If fullscreen mode is set and the system cannot set specified mode in fullscreen, it will try in windowed mode. If windowed mode is set and the system fails to open a window for specified mode, it will try fullscreen. If everything fails, `Screen` will have no effect and execution will resume from the statement following the `Screen` call. You should take care of checking if a graphics mode has been set or not, and behave accordingly; a way to check if `Screen` is successful is to test the return value of the [`ScreenPtr`](Screenptr) function; see its page for details.

 Note:

`Screen 0` closes any graphics window, but also clears the console window if it exists.  
 `Screen 0, , , GFX_SCREEN_EXIT` (with `GFX_SCREEN_EXIT=&h80000000`) also closes any graphics window, but does not clear the console window if it exists (previous text is preserved).

*Graphics mode console*
 Console commands ([`Locate`](Locate), [`Print`](Print)), input can be used both with standard QB `Screen` modes and with the extended ones too, provided the standard color depth is not modified by using the second argument of `Screen`. Where the table says more than one text resolution is available for the text mode, the required text resolution can be requested by using [`Width`](Width). Any characters [`Print`](Print)ed will erase the background around them; it does not use a transparent background.

## Return Value

Returns zero (`0`) if successful, or a non-zero error code to indicate a failure. *[(throws a runtime error)](Error-Handling)* (???)

## Remarks

### Usage

```freebasic
ScreenRes width, height [, [depth] [, [num_pages] [, [flags] [, refresh_rate ]]]]

result = ScreenRes( width, height [, [depth] [, [num_pages] [, [flags] [, refresh_rate ]]]] )
```

### Platform Differences

- In DOS, Windowing and OpenGL related switches are not available, and other issues, see [GfxLib overview](Gfxlib-Freebasic-Graphics-Library-Overview)

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Screenres`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Screen (Graphics)`](Screen-Graphics) The QB-like way to set graphics mode
- [`ScreenList`](Screenlist) Check display modes available for FB GfxLib to use
- [`ScreenControl`](Screencontrol) Select driver and more
- [`ScreenLock`](Screenlock)
- [`ScreenUnlock`](Screenunlock)
- [`ScreenPtr`](Screenptr) Semi-low level access
- [`ScreenSet`](Screenset)
- [`ScreenCopy`](Screencopy)
- [`ScreenInfo`](Screeninfo)
- [`ScreenGLProc`](Screenglproc)
- `FaqPggfxlib2`

## Examples

```freebasic
' Set the screen mode to 320*200, with 8 bits per pixel

ScreenRes 320, 200, 8

' Draw color bands in a diagonal pattern over the whole screen

For y As Long = 0 To 200-1

    For x As Long = 0 To 320-1

        PSet (x,y),(x + y) And 255

    Next x

Next y

' Display the text "Hello World!!" over the lines we've drawn, in the top-left hand corner

Print "Hello world!!"

' Keep the window open until the user presses a key

Sleep
```

---

**Category:** [Screen Functions](Category-Screen-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
