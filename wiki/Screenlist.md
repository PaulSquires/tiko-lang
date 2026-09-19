[Home](Home) › [Screen Functions](Category-Screen-Functions) › **ScreenList**

# ScreenList

Finds available fullscreen video modes

## Syntax

```freebasic
Declare Function ScreenList ( ByVal depth As Long = 0 ) As Long
```

## Parameters

- `depth`

## Description

It works like the [`Dir`](Dir) function: the first call to the function requires the `depth` parameter to be specified, it returns the lowest supported resolution for the requested depth. Further calls to `ScreenList` without arguments returns the next resolutions. When no more resolutions are available, [`ScreenList`](Screenlist) returns `0`.

 The result of [`ScreenList`](Screenlist) is encoded as a 32 bit value, with the screen width as the [High Word](Hiword) and the height as the [Low Word](Loword).

 Resolutions are returned from lowest to highest supported ones.

 It is safe to call this function before any graphics mode has been set.

## Return Value

returns `0`, when there are no more resolutions to read.

## Remarks

### Usage

`result = ScreenList( [ depth ] )`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Screenlist`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Screen (Graphics)`](Screen-Graphics)
- [`ScreenRes`](Screenres)

## Examples

```freebasic
Dim As Long mode

Dim As UInteger w, h

Print "Resolutions supported at 8 bits per pixel:"

mode = ScreenList(8)

While (mode <> 0)

    w = HiWord(mode)

    h = LoWord(mode)

    Print w & "x" & h

    mode = ScreenList()

Wend
```

---

**Category:** [Screen Functions](Category-Screen-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
