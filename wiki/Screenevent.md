[Home](Home) › [Screen Functions](Category-Screen-Functions) › **ScreenEvent**

# ScreenEvent

Queries for and retrieves system events.

## Syntax

```freebasic
Declare Function ScreenEvent ( ByVal event As Any Ptr = 0 ) As Long
```

## Parameters

- `event`

## Description

This function returns the latest available system event from the internal GfxLib events queue. By "event" we mean any mouse or keyboard activity, for example.

 The event data (if available) will be copied into the buffer pointed that should be declared as an [`Event`](Event-Message-Data-From-Screenevent).  
 On the [`Event`](Event-Message-Data-From-Screenevent) page, see the list of event types and how to use their associated fields (see also the example below).

 *Querying for events*

The function returns `-1` if there are pending events to be retrieved, `0` otherwise. If the `event` parameter is set to `0` (the default if omitted) [`ScreenEvent`](Screenevent) will not be able to copy the event data and it will not dequeue it from the internal events queue. Calling the function this way can be useful to check if there are pending events without actually fetching them.

*Note*

If you receive a KEY_PRESS, KEY_RELEASE or KEY_REPEAT event, it does not clear the keyboard buffer. If you need the buffer to be clear after you receive the event, you will need to clear it manually. See [`Inkey`](Inkey).

## Return Value

Returns `-1` if there are pending events to be retrieved, `0` otherwise.

## Remarks

### Usage

`result = ScreenEvent( [ event ] )`

### Platform Differences

- `ScreenEvent` does not return window related events in the DOS version, but does return input events.

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect.

### Differences from QB

- New to FreeBASIC

### See also

- [`Event`](Event-Message-Data-From-Screenevent)
- [`Screen (Graphics)`](Screen-Graphics)
- [`Inkey`](Inkey)
- [`MultiKey`](Multikey)
- [`GetMouse`](Getmouse)
- [Event Handling](Event-Handling)
- [Keyboard scancodes](Dos-Keyboard-Scancodes)
- [Keyboard Input](Keyboard-Input)

## Examples

```freebasic
'' include fbgfx.bi for some useful definitions

#include "fbgfx.bi"

#if __FB_LANG__ = "fb"

Using fb '' constants and structures are stored in the FB namespace in lang fb

#endif

Dim e As Event

ScreenRes 640, 480

Do

    If (ScreenEvent(@e)) Then

        Select Case e.type

        Case EVENT_KEY_PRESS

            If (e.scancode = SC_ESCAPE) Then

                End

            End If

            If (e.ascii > 0) Then

                Print "'" & e.ascii & "'";

            Else

                Print "unknown key";

            End If

            Print " was pressed (scancode " & e.scancode & ")"

        Case EVENT_KEY_RELEASE

            If (e.ascii > 0) Then

                Print "'" & e.ascii & "'";

            Else

                Print "unknown key";

            End If

            Print " was released (scancode " & e.scancode & ")"

        Case EVENT_KEY_REPEAT

            If (e.ascii > 0) Then

                Print "'" & e.ascii & "'";

            Else

                Print "unknown key";

            End If

            Print " is being repeated (scancode " & e.scancode & ")"

        Case EVENT_MOUSE_MOVE

            Print "mouse moved to " & e.x & "," & e.y & " (delta " & e.dx & "," & e.dy & ")"

        Case EVENT_MOUSE_BUTTON_PRESS

            If (e.button = BUTTON_LEFT) Then

                Print "left";

            ElseIf (e.button = BUTTON_RIGHT) Then

                Print "right";

            Else

                Print "middle";

            End If

            Print " button pressed"

        Case EVENT_MOUSE_BUTTON_RELEASE

            If (e.button = BUTTON_LEFT) Then

                Print "left";

            ElseIf (e.button = BUTTON_RIGHT) Then

                Print "right";

            Else

                Print "middle";

            End If

            Print " button released"

        Case EVENT_MOUSE_DOUBLE_CLICK

            If (e.button = BUTTON_LEFT) Then

                Print "left";

            ElseIf (e.button = BUTTON_RIGHT) Then

                Print "right";

            Else

                Print "middle";

            End If

            Print " button double clicked"

        Case EVENT_MOUSE_WHEEL

            Print "mouse wheel moved to position " & e.z

        Case EVENT_MOUSE_ENTER

            Print "mouse moved into program window"

        Case EVENT_MOUSE_EXIT

            Print "mouse moved out of program window"

        Case EVENT_WINDOW_GOT_FOCUS

            Print "program window got focus"

        Case EVENT_WINDOW_LOST_FOCUS

            Print "program window lost focus"

        Case EVENT_WINDOW_CLOSE

            End

        Case EVENT_MOUSE_HWHEEL

            Print "horizontal mouse wheel moved to position " & e.w

        End Select

    End If

    Sleep 1

Loop
```

---

**Category:** [Screen Functions](Category-Screen-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
