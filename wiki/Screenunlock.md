[Home](Home) › [Screen Functions](Category-Screen-Functions) › **ScreenUnlock**

# ScreenUnlock

Unlocks work page's framebuffer

## Syntax

```freebasic
Declare Sub ScreenUnlock ( ByVal startline As Long = -1, ByVal endline As Long = -1 )
```

## Parameters

- `startline`
- `endline`

## Description

`ScreenUnlock` unlocks the current work page assuming it was previously locked by calling [`ScreenLock`](Screenlock) and lets the system restart updating the screen regularly. When called with `start_line` and `end_line` , only the screen area between those lines is assumed to have changed, and will be updated.

 An internal counter exists that remembers the screen lock state, thus `ScreenUnlock` has an effect only on a screen that is locked. A screen that has not been locked with `ScreenLock` cannot get unlocked, however `ScreenUnlock` still will force an update of given area or full screen.

 Calls to `ScreenUnlock` must be paired with matching calls to `ScreenLock`. Only the first call to `ScreenLock` actually performs a locking operation. Subsequent calls to `ScreenLock` only increment the lock counter. Conversely, `ScreenUnlock` only decrements the lock counter until it reaches zero at which time the actual unlock operation will be performed. Using [`Screen (Graphics)`](Screen-Graphics) or [`ScreenRes`](Screenres) will release all locks and set the lock counter back to zero before changing screen modes.

 All graphic statements automatically lock the screen before the function call, and unlock the screen afterwards, so you do not need to do this explicitly using `ScreenLock` and `ScreenUnlock`. You only need to lock the screen when you wish to access the screen (framebuffer) directly using [`ScreenPtr`](Screenptr) or when you wish to group several graphic statements together so their effects appear simultaneously on screen, thus avoiding potential screen flicker during screen updates.

 Warning (Win32, Linux) : The screen is locked by stopping the thread that processes also the OS' events. This means the screen should be locked only for the short time required to redraw it, and no user input will be received while the screen is locked. When the induced lock time becomes too long, use preferably the method of double buffering (with [`ScreenCopy`](Screencopy)).

## Remarks

### Usage

`ScreenUnlock [ start_line ] [, end_line ]`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Screenunlock`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Screen (Graphics)`](Screen-Graphics)
- [`ScreenLock`](Screenlock)
- [`ScreenPtr`](Screenptr)

## Examples

See [`ScreenPtr`](Screenptr) example.

---

**Category:** [Screen Functions](Category-Screen-Functions)  
**Kind:** sub

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
