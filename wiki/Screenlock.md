[Home](Home) › [Screen Functions](Category-Screen-Functions) › **ScreenLock**

# ScreenLock

Stops screen updates while you draw, so the user never sees half a frame.

## Syntax

```freebasic
Declare Sub ScreenLock ( )
```

## Description

All of FreeBASIC's Graphics Library functions draw to a frame buffer and an automatic routine copies the frame buffer to the actual screen memory at each draw. If the user program does a lot of drawing, the automatic refreshes may take a significant amount of time.

 The `ScreenLock` function locks the automatic refresh, so several drawing operations may be done before the screen refresh is performed, thus increasing the speed of execution, and preventing the user from seeing partial results.

 Frame buffer memory may be freely accessed by using pointers (see [ScreenPtr](Screenptr)) ONLY while the screen is locked. Primitive graphics statements ([`Line`](Line-Graphics), [`PSet`](Pset-Statement), [`Draw String`](Draw-String), ...) may be used at any time.

 The screen refresh remains locked until the use of [`ScreenUnlock`](Screenunlock) statement, which resumes it.

 Calls to `ScreenLock` must be paired with a matching call to `ScreenUnlock`. The graphics driver keeps track of how many times `ScreenLock` has been called using a counter. Only the first call to `ScreenLock` actually performs a locking operation. Subsequent calls to `ScreenLock` only increment the counter. Conversely, `ScreenUnlock` only decrements the lock counter until it reaches zero at which time the actual unlock operation will be performed. Using [`Screen (Graphics)`](Screen-Graphics) or [`ScreenRes`](Screenres) will release all locks and set the lock counter back to zero before changing screen modes.

 It is strongly recommended that the lock on a page be held for as short a time as possible. Only screen drawing should occur while the screen is locked, input/output and waiting must be avoided. In Win32 and Linux the screen is locked by stopping the thread that processes also the OS' events. If the screen is kept locked for a long time the event queue could overflow and make the system unstable. When the induced lock time becomes too long, use preferably the method of double buffering (with [`ScreenCopy`](Screencopy)).

 The automatic refresh takes place only in the visible page of the frame buffer. `ScreenLock` has no effect when drawing to pages other than the visible one.

## Remarks

### Usage

`ScreenLock`

### Platform Differences

- In DOS, the mouse arrow does not react to mouse movements while the screen is locked

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Screenlock`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Screen (Graphics)`](Screen-Graphics) - Setting mode
- [`ScreenRes`](Screenres) - Setting mode
- [`ScreenUnlock`](Screenunlock)
- [`ScreenPtr`](Screenptr)

## Examples

```freebasic
'' Draws a circle on-screen at the mouse cursor

Dim As Long mx, my

Dim As String key

ScreenRes 640, 480, 32

Do

  'process

  GetMouse(mx, my)

  key = Inkey()

  'draw

  ScreenLock()

  Cls()

  Circle (mx, my), 8, RGB(255, 255, 255)

  ScreenUnlock()

  'free up CPU time

  Sleep(18, 1)

Loop Until key = Chr(27) Or key = Chr(255, 107)
```

---

**Category:** [Screen Functions](Category-Screen-Functions)  
**Kind:** sub

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
