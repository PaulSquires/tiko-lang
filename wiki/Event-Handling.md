[Home](Home) › [Tutorials](Category-Tutorials) › **Event Handling**

# Event Handling

**Handling** (querying and processing) keyboard, mouse, and window **Events**.

 **Preamble:**

 Events are basically user actions like key press, clicks, mouse movements, etc., or some occurrence like system generated notifications.

 The [`Event`](Event-Message-Data-From-Screenevent) type plus the [`ScreenEvent`](Screenevent) function constitute a built-in interface provided by FreeBASIC for accessing events (keyboard, mouse, and window events).  
 [`ScreenEvent`](Screenevent) signals the events so the user can write his own event handlers (which require that he keeps track of the data himself).

 By using [`ScreenEvent`](Screenevent), the user can check the events as they are returned by the function.  
 It is assumed that this function is regularly called to fetch events as they are queued internally by the system.

Event type

The [`Event`](Event-Message-Data-From-Screenevent) type is a pre-defined structure in "fbgfx.bi" (in the `FB` [`Namespace`](Namespace) for the *[lang fb](Freebasic-Dialects)* dialect only).  
 When the user calls [`ScreenEvent`](Screenevent) passing an instance of [`Event`](Event-Message-Data-From-Screenevent) type, [`ScreenEvent`](Screenevent) fills in it with the event data (if an event flag is returned).

 *Syntax*

```freebasic
#include once "fbgfx.bi"

Using FB

Dim variable As Event
```

*"Event" structure*

This structure is extracted from "fbgfx.bi".

```freebasic
Type Event Field = 1

    Type As Long

    Union

        Type

            scancode As Long

            ascii As Long

        End Type

        Type

            x As Long

            y As Long

            dx As Long

            dy As Long

        End Type

        button As Long

        z As Long

        w As Long

    End Union

End Type
```

- For key events, one among:

```freebasic
EVENT_KEY_PRESS

EVENT_KEY_RELEASE

EVENT_KEY_REPEAT
```

- For mouse event, one among:

```freebasic
EVENT_MOUSE_MOVE

EVENT_MOUSE_BUTTON_PRESS

EVENT_MOUSE_BUTTON_RELEASE

EVENT_MOUSE_DOUBLE_CLICK

EVENT_MOUSE_WHEEL

EVENT_MOUSE_HWHEEL

EVENT_MOUSE_ENTER

EVENT_MOUSE_EXIT
```

- For window event, one among:

```freebasic
EVENT_WINDOW_GOT_FOCUS

EVENT_WINDOW_LOST_FOCUS

EVENT_WINDOW_CLOSE
```

EVENT_KEY_PRESS  
 EVENT_KEY_RELEASE  
 EVENT_KEY_REPEAT

EVENT_MOUSE_MOVE

EVENT_MOUSE_BUTTON_PRESS  
 EVENT_MOUSE_BUTTON_RELEASE  
 EVENT_MOUSE_DOUBLE_CLICK

EVENT_MOUSE_WHEEL

EVENT_MOUSE_HWHEEL

**Note:**

**-** The last five field blocks \[`.scancode` and `.ascii`\], \[`.x`, `.y` and `.dx`, `.dy`\], \[`.button`\], \[`.z`\] and \[`.w`\] are aligned on the same memory location (because declared inside a Union type), so that filling in one field block overwrites the other field blocks previously filled in.
 **-** Therefore for example if the mouse position (mx, my) must be available when the `MOUSE_BUTTON_PRESS` event is detected, this position must have been previously stored in (mx, my) at each `MOUSE_MOVE` event from its own event data (`.x`, `.y`), because (`.x`, `.y`) is overwritten by any other event returned by [`ScreenEvent`](Screenevent).

ScreenEvent function

The [`ScreenEvent`](Screenevent) function allows querying and retrieving system events.

 *Syntax*`Declare Function ScreenEvent ( ByVal event_instance_ptr As Any Ptr = 0 ) As Long`

*Usage*`result = ScreenEvent( [ event_instance_ptr ] )`

with:

`event_instance_ptr`: the buffer address where the function should fill in the event data with a structure as the [`Event`](Event-Message-Data-From-Screenevent) type defined above.  
 `result`: -1 if there are pending events to be retrieved, 0 otherwise.

Description

The [`ScreenEvent`](Screenevent) function checks if there are any pending system events:

**-** If there are no events, the function simply returns 0 (false).
 **-** If there is any, it returns -1 (true), and if the `event_instance_ptr` pointer is not NULL, it copies the event data into the user passed structure and removes the event (the latest available) from the internal GfxLib events queue.
 **-** So to simply check if there are any pending events without retrieving them (if there are any), nor even dequeue it from the internal events queue, it is enough to call the function without parameters (or with a NULL parameter).

The user must first call [`ScreenEvent`](Screenevent) once to get one event, and then check that one event against each event type he is interested in.  
 Once the user has handled that event, he must quickly call [`ScreenEvent`](Screenevent) again to handle the next event. Otherwise he will almost certainly miss events (like for example `EVENT_MOUSE_MOVE` at least).  
 This is why the program loop which tests the successive events must have a period compatible with the rate of the events that the user wants to intercept (for example, difference between keyboard input and mouse move).  
 Conversely, having an event test loop with a period significantly less than 10 ms unnecessarily hogs the CPU.

 *Event querying program skeleton*

As only one event is served by the [`ScreenEvent`](Screenevent) function at a given time, the event querying program skeleton can be properly structured around a `[Select Case As Const...End Select]` block.  
 The different cases correspond to the different events that the user wishes to handle.

```freebasic
#include Once "fbgfx.bi"

Using FB

' .....

Dim e As Event

' .....

Do

    If (ScreenEvent(@e)) Then

        Select Case As Const e.type

        Case EVENT_xxx

            ' handle the event xxx

        Case EVENT_yyy

            ' handle the event yyy

        ' .....

        ' .....

        Case EVENT_zzz

            ' handle the event zzz

        Case Else

            ' event not handled

        End Select

    End If

    Sleep 10, 1

Loop

' .....
```

If for example a key is held down for some seconds, this will induce:

**-** a first `EVENT_KEY_PRESS`,
 **-** followed by several `EVENT_KEY_REPEAT` (for as long as the key is held down),
 **-** and `EVENT_KEY_RELEASE` when the key is released.

Two successive simple-click actions on a mouse obviously induce four successive mouse events:

```freebasic
EVENT_MOUSE_BUTTON_PRESS

EVENT_MOUSE_BUTTON_RELEASE

EVENT_MOUSE_BUTTON_PRESS

EVENT_MOUSE_BUTTON_RELEASE
```

An only double-click action on a mouse also induces four successive mouse events, but:

```freebasic
EVENT_MOUSE_BUTTON_PRESS

EVENT_MOUSE_BUTTON_RELEASE

EVENT_MOUSE_DOUBLE_CLICK

EVENT_MOUSE_BUTTON_RELEASE
```

 **Note:**

**-** If the user program retrieves a `KEY_...` event, this does not clear the keyboard buffer. If the keyboard buffer needs to be cleared after user retrieves the event, he will need to clear it manually (see [`Inkey`](Inkey)).
 **-** Event queuing and InKey buffering are two completely independent ways to test the keyboard state. They can coexist, even in two competing threads without any conflict.
 **-** There are currently three ways to test input from the keyboard using gfxlib:

using [`Inkey`](Inkey) (user can test only keys that have an ascii representation),  
 using [`MultiKey`](Multikey) (user can query the state pressed/released of any key on keyboard),  
 using [`ScreenEvent`](Screenevent) (user can check the `KEY_PRESS`, `KEY_RELEASE` and `KEY_REPEAT` events).

Examples

Example of simple [`ScreenEvent`](Screenevent) mechanism to implement a key-pressed events handling:  
 (click on the window-close button \[X\] to exit)

```freebasic
'   The main code tests events in a loop:

'       - calls a user Sub each time a key-pressed event is retrieved

'       - exits the loop if a window-close event is retrieved (by click on window-close button)

'   The user Sub prints the character of the key pressed, the ascci code and the scancode.

#include Once "fbgfx.bi"

Using FB

'' user callback Sub definition

Sub printInkeyData (ByVal ascii As Long, ByVal scancode As Long)

    Print "'" & Chr(ascii) & "' (" & ascii & ")", scancode

End Sub

'' user main code

Screen 12

Dim e As Event

Do

    If (ScreenEvent(@e)) Then

        Select Case As Const e.type

        Case EVENT_KEY_PRESS                     '' test key-pressed event

            printInkeyData(e.ascii, e.scancode)

        Case EVENT_WINDOW_CLOSE                  '' test window-close event

            Exit Do

        End Select

    End If

    Sleep 10, 1

Loop
```

Simple example highlighting that Event queuing and InKey buffering can coexist, even in two competing threads without any conflict:  
 (ESC to quit)

```freebasic
'   The main code (main thread) tests Inkey in a loop.

'   The other thread tests ScreenEvent in a loop.

'   The ESC character allows to exit the two loops.

#include "fbgfx.bi"

Using FB

Function getAscii (ByVal ascii As Long) As String

    If ((ascii>0) And (ascii<255)) Then

        Return "'" & Chr(ascii) & "'"

    Else

        Return "???"

    End If

End Function

Sub Thread (ByVal p As Any Ptr)

    Dim e As Event

    Do

        If (ScreenEvent(@e)) Then

            Select Case As Const e.Type

            Case EVENT_KEY_PRESS                                      '' test key-pressed event

                Print getAscii(e.ascii) &_

                " is pressed    (from ScreenEvent)   (other thread)"

                If (e.scancode=SC_ESCAPE) Then                        '' test ESC

                    Exit Sub

                End If

            Case EVENT_KEY_RELEASE                                    '' test key-released event

                Print getAscii(e.ascii) &_

                " is released   (from ScreenEvent)   (other thread)"

            Case EVENT_KEY_REPEAT                                     '' test key-repeated event

                Print getAscii(e.ascii) &_

                " is repeated   (from ScreenEvent)   (other thread)"

            End Select

        End If

        Sleep 10, 1

    Loop

End Sub

Screen 12

Dim As String s

Dim As Any Ptr pt

pt = ThreadCreate(@Thread)

Do

    s = Inkey

    If s <> "" Then                                                   '' test inkey return

        Print getAscii(s[0]) &_

        " is viewed     (from Inkey)         (main thread)"

    End If

    Sleep 10, 1

Loop Until s = Chr(27)                                                '' test ESC

ThreadWait(pt)

Print "main and other thread completed"

Sleep
```

Example of mouse event handling where cursor position and buttons state are stored in a Type derived of EVENT to be available at the time of events other than those that normally provide them:  
 (click on the window-close button \[X\] to exit)

```freebasic
' Memorization in (.mx, .my) of the cursor position of the mouse:

'     - at MOUSE_MOVE event : e.mx = e.x, e.my = e.y

' Memorization in .mbutton of the buttons state of the mouse:

'     - at MOUSE_BUTTON_PRESS event and MOUSE_DOUBLE_CLICK event : e.mbutton = e.mbutton Or e.button

'     - at MOUSE_BUTTON_RELEASE event : e.mbutton = e.mbutton Xor e.button

#include Once "fbgfx.bi"

Using FB

Type EVENTstore Extends Event

    mx As Long

    my As Long

    mbutton As Long

End Type

Screen 19

Dim e As EVENTstore

Do

    If ScreenEvent(@e) Then

        Select Case As Const e.Type

        Case EVENT_MOUSE_MOVE

            e.mx = e.x

            e.my = e.y

            Print Using "Mouse move:                  x=####   /   y=####      dx=####  /  dy=####      button=##";_

            e.x; e.y; e.dx; e.dy; e.mbutton

        Case EVENT_MOUSE_BUTTON_PRESS

            e.mbutton = e.mbutton Or e.button

            Print Using "Mouse button press:          button =##               x=####   /   y=####";_

            e.button; e.mx; e.my

        Case EVENT_MOUSE_BUTTON_RELEASE

            e.mbutton = e.mbutton Xor e.button

            Print Using "Mouse button release:        button =##               x=####   /   y=####";_

            e.button; e.mx; e.my

        Case EVENT_MOUSE_DOUBLE_CLICK

            e.mbutton = e.mbutton Or e.button

            Print Using "Mouse button double click:   button =##               x=####   /   y=####";_

            e.button; e.mx; e.my

        Case EVENT_MOUSE_WHEEL

            Print Using "Mouse wheel:                 wheel=  ###########      x=####   /   y=####";_

            e.z; e.mx; e.my

        Case EVENT_MOUSE_HWHEEL

            Print Using "Mouse hwheel:                hwheel= ###########      x=####   /   y=####";_

            e.z; e.mx; e.my

        Case EVENT_WINDOW_CLOSE

            Exit Do

        End Select

    End If

    Sleep 10, 1

Loop
```

See also

- [`Event`](Event-Message-Data-From-Screenevent)
- [`ScreenEvent`](Screenevent)
- [`Inkey`](Inkey)
- [`MultiKey`](Multikey)
- [`GetMouse`](Getmouse)
- [Keyboard scancodes](Dos-Keyboard-Scancodes)

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
