[Home](Home) › [Screen Functions](Category-Screen-Functions) › **Screen Functions**

# Screen Functions

Statements and procedures that work with the graphics display.

Description

These statements and procedures control the graphics capabilities of the FreeBASIC graphics library. Screen modes can be set with varying resolutions and color depths, window events can be handled, and specific OpenGL procedures can be retrieved.

**Working with screen modes**

Procedures for setting and retrieving information about screen modes.

**Working with pages**

Procedures that manipulate screen pages.

**Working video memory**

Procedures that provide direct access to framebuffer memory.

**Screen Metrics**

Procedures that control the way coordinates are interpreted.

**Screen Data Types**

Data types and data definitions for screen functions.

***Working with screen modes***

**[ScreenList](Screenlist)**

Gets the available fullscreen resolutions.

**[Screen (Graphics)](Screen-Graphics) and [ScreenRes](Screenres)**

Sets a new graphics display mode.

**[ScreenInfo](Screeninfo)**

Gets information about the system desktop or current display mode.

**[ScreenControl](Screencontrol)**

Gets or sets internal graphics library settings.

**[ScreenEvent](Screenevent)**

Gets system events.

**[ScreenGLProc](Screenglproc)**

Returns the address of an OpenGL procedure.

**[WindowTitle](Windowtitle)**

Sets the running program's window caption.

***Working with pages***

**[Cls](Cls)**

Clears the entire screen or viewport.

**[ScreenSet](Screenset)**

Sets the current work and visible pages.

**[ScreenCopy](Screencopy) and [PCopy](Pcopy) and [Flip](Flip)**

Copies pixel data from one page to another.

**[ScreenSync](Screensync)**

Waits for the vertical refresh of the monitor.

***Working video memory***

**[ScreenPtr](Screenptr)**

Gets the address of the working page's framebuffer.

**[ScreenLock](Screenlock)**

Locks the current working page's framebuffer for direct access.

**[ScreenUnlock](Screenunlock)**

Reverts a previous [ScreenLock](Screenlock) command.

***Screen Metrics***

**[View (Graphics)](View-Graphics)**

Sets a clipping region for all drawing and blitting procedures.

**[Window](Window)**

Sets a new coordinate mapping for the current viewport.

**[PMap](Pmap)**

Converts coordinates between physical and view mappings.

**[PointCoord](Pointcoord)**

Queries [`Draw`](Draw)'s pen position.

***Screen Data Types***

**[Event](Event-Message-Data-From-Screenevent)**

Data type for [ScreenEvent](Screenevent) function.

---

**Category:** [Screen Functions](Category-Screen-Functions)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
