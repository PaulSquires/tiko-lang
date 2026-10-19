[Home](Home) › [All Categories](Categories) › **Screen Functions**

# Screen Functions

<!-- finder:start -->

Grouped by task. [Graphics and windows](Functions-Graphics) lists them beside the rest of the area.

## Open a graphics window

| Function | What it does | From |
|---|---|---|
| [ScreenRes](Screenres) | Opens a graphics window of a given width, height and colour depth. | built-in |
| [Screen](Screen-Graphics) | Opens a graphics mode by mode number, or picks the work and visible pages. | built-in |
| [WindowTitle](Windowtitle) | Sets the title of the graphics window. | built-in |
| [ScreenList](Screenlist) | Returns the fullscreen resolutions for a colour depth, one per call, then 0. | built-in |
| [ScreenInfo](Screeninfo) | Fills in the screen's width, height, depth and driver, or the desktop's if none is open. | built-in |
| [ScreenControl](Screencontrol) | Sets or reads graphics library settings, such as the driver or the window position. | built-in |
| [ScreenGLProc](Screenglproc) | Returns the address of an OpenGL procedure by name, or 0 if it is not found. | built-in |

## Draw lines, shapes and pixels

| Function | What it does | From |
|---|---|---|
| [Draw](Draw) | Draws a figure from a string of pen commands such as "U10 R10". | built-in |
| [PointCoord](Pointcoord) | Returns the x or y position of the Draw pen. | built-in |

## Draw without flicker

| Function | What it does | From |
|---|---|---|
| [ScreenLock](Screenlock) | Stops screen updates while you draw, so the user never sees half a frame. | built-in |
| [ScreenUnlock](Screenunlock) | Resumes screen updates after ScreenLock and shows what was drawn. | built-in |
| [ScreenSet](Screenset) | Sets which page is drawn on and which page is shown. | built-in |
| [ScreenCopy](Screencopy) | Copies one graphics page onto another, by default the work page onto the shown one. | built-in |
| [PCopy](Pcopy) | Copies one graphics or text page onto another. | built-in |
| [Flip](Flip) | Shows the OpenGL back buffer, or copies a page as ScreenCopy does in other modes. | built-in |
| [ScreenSync](Screensync) | Waits for the display to finish drawing a frame, to reduce flicker. | built-in |
| [ScreenPtr](Screenptr) | Returns a pointer to the work page's pixels, or 0 if no graphics mode is set. | built-in |

## Set the drawing area and coordinates

| Function | What it does | From |
|---|---|---|
| [View](View-Graphics) | Sets the rectangle that drawing is clipped to, or resets it to the whole screen. | built-in |
| [Window](Window) | Sets the coordinate system mapped onto the current view. | built-in |
| [PMap](Pmap) | Converts a coordinate between the Window system and physical pixels. | built-in |

## Read the mouse, keyboard and joystick

| Function | What it does | From |
|---|---|---|
| [ScreenEvent](Screenevent) | Returns -1 if a mouse, keyboard or window event is waiting, and fetches it. | built-in |
| [Event](Event-Message-Data-From-Screenevent) | Holds one event fetched by ScreenEvent: its type and its key or mouse data. | `fbgfx.bi` |

## Also in this category

- [Screen Functions](Screen-Functions)

<!-- finder:end -->

---

[Home](Home) · [Keyword Index](Keyword-Index)
