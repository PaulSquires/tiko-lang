[Home](Home) › [User Input Functions (Graphics Library)](Category-User-Input-Functions-Graphics-Library) › **GetJoystick**

# GetJoystick

Fills in a joystick's buttons and axis positions; returns 0 on success or 1.

## Syntax

```freebasic
Declare Function GetJoystick ( ByVal id As Long, ByRef buttons As Integer = 0, ByRef a1 As Single = 0, ByRef a2 As Single = 0, ByRef a3 As Single = 0, ByRef a4 As Single = 0, ByRef a5 As Single = 0, ByRef a6 As Single = 0, ByRef a7 As Single = 0, ByRef a8 As Single = 0 ) As Long
```

## Parameters

- `id`
- `buttons`
- `a1`
- `a2`
- `a3`
- `a4`
- `a5`
- `a6`
- `a7`
- `a8`

## Description

`GetJoystick` will retrieves the button state, and the axis positions for up to 8 axes, for the joystick determined by `id`, a number between `0` and `15`. Buttons are stored in a similar manner to [`GetMouse`](Getmouse), with each bit in `buttons` representing a button.

 A single precision value between `-1.0` and `1.0` is returned for each valid axis. If the axis does not exist for the controller, a value of `-1000.00` is returned.

 `GetJoystick` will return `0` upon successful completion; It will return `1` upon failure. Failure can be caused by specifying an illegal joystick number, specifying a joystick which doesn't exist, or a failure in the joystick API.

 The error code returned by `GetJoystick` can be checked using [`Err`](Err) in the next line. The function version of `Getjoystick` returns directly the error code as a 32 bit [`Long`](Long).

## Return Value

`0` on success or `1` on failure. All of the axis positions are returned in floating point format.

## Remarks

### Usage

`result = GetJoystick( id[, buttons[, a1[, a2[, a3[, a4[, a5[, a6[, a7[, a8]]]]]]]]] )`

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Getjoystick`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Screen (Graphics)`](Screen-Graphics)
- [`SetMouse`](Setmouse)
- [`GetMouse`](Getmouse)
- [`MultiKey`](Multikey)
- [`Event`](Event-Message-Data-From-Screenevent)
- [`ScreenEvent`](Screenevent)

## Examples

```freebasic
Screen 12

Dim x As Single

Dim y As Single

Dim buttons As Integer

Dim result As Long

Dim a As Integer

Const JoystickID = 0

'This line checks to see if the joystick is ok.

If GetJoystick(JoystickID,buttons,x,y) Then

    Print "Joystick doesn't exist or joystick error."

    Print

    Print "Press any key to continue."

    Sleep

    End

End If

Do

    result = GetJoystick(JoystickID,buttons,x,y)

    Locate 1,1

    Print ;"result:";result;" x:" ;x;" y:";y;" Buttons:";buttons,"","",""

    'This tests to see which buttons from 1 to 27 are pressed.

    For a = 0 To 26

        If (buttons And (1 Shl a)) Then

            Print "Button ";a;" pressed.    "

        Else

            Print "Button ";a;" not pressed."

        End If

    Next a

Loop
```

---

**Category:** [User Input Functions (Graphics Library)](Category-User-Input-Functions-Graphics-Library)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
