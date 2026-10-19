[Home](Home) › [Screen Functions](Category-Screen-Functions) › **WindowTitle**

# WindowTitle

Sets the title of the graphics window.

## Syntax

```freebasic
Declare Sub WindowTitle ( ByRef title As Const String )
```

## Parameters

- `title`

## Description

This statement is useful to change the program window title. The new title set will become active immediately if the program already runs in windowed mode, otherwise will become the new title for any window produced by subsequent calls to the [`Screen (Graphics)`](Screen-Graphics) or [`ScreenRes`](Screenres) statement. If this function is not called before setting a new windowed mode via [`Screen (Graphics)`](Screen-Graphics) or [`ScreenRes`](Screenres), the program window will use the executable file name (without the extension) as title by default.  
 This command has no effect in consoles.

## Remarks

### Usage

`WindowTitle title`

### Platform Differences

- Not present in DOS version / target of FreeBASIC

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Windowtitle`.

### Differences from QB

- New to FreeBASIC

### See also

- `ScreenControl (function SET_WINDOW_TITLE or GET_WINDOW_TITLE)`
- [`Screen (Graphics)`](Screen-Graphics)
- [`ScreenRes`](Screenres)

## Examples

```freebasic
'Set screen mode

Screen 13

'Set the window title

WindowTitle "FreeBASIC example program"

Sleep
```

---

**Category:** [Screen Functions](Category-Screen-Functions)  
**Kind:** sub

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
