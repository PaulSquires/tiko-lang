[Home](Home) › [Screen Functions](Category-Screen-Functions) › **ScreenGLProc**

# ScreenGLProc

Gets the address of an OpenGL procedure

## Syntax

```freebasic
Declare Function ScreenGLProc ( ByRef procname As Const String ) As Any Ptr
```

## Parameters

- `procname`

## Description

This function can be used to get the address of any OpenGL procedure, to be used to retrieve the pointers to new functions associated with OpenGL extensions. If given procedure named `procname` cannot be found, `ScreenGLProc` will return NULL (`0`).

## Remarks

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Screenglproc`.

### Platform Differences

- Not available for DOS target.

### Differences from QB

- New to FreeBASIC

### See also

- [`Screen (Graphics)`](Screen-Graphics)
- [`ScreenControl`](Screencontrol)

## Examples

```freebasic
'' include fbgfx.bi for some useful definitions

#include "fbgfx.bi"

Dim SwapInterval As Function(ByVal interval As Integer) As Integer

Dim extensions As String

'' Setup OpenGL and retrieve supported extensions

ScreenRes 640, 480, 32,, FB.GFX_OPENGL

ScreenControl FB.GET_GL_EXTENSIONS, extensions

If (InStr(extensions, "WGL_EXT_swap_control") <> 0) Then

    '' extension supported, retrieve proc address

    SwapInterval = ScreenGLProc("wglSwapIntervalEXT")

    If (SwapInterval <> 0) Then

        '' Ok, we got it. Set OpenGL to wait for vertical sync on buffer swaps

        SwapInterval(1)

    End If

End If
```

---

**Category:** [Screen Functions](Category-Screen-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
