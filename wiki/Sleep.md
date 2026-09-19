[Home](Home) › [Miscellaneous Keywords](Category-Miscellaneous-Keywords) › **Sleep**

# Sleep

Waits until a specified time has elapsed, or a key is pressed.

## Syntax

```freebasic
Declare Sub Sleep ( ByVal amount As Long = -1 )
Declare Function Sleep ( ByVal amount As Long , ByVal keyflag As Long ) As Long
```

## Parameters

- `amount`
- `keyflag`

## Description

`Sleep` will wait until `amount` milliseconds (can be seconds in *[-lang qb](Compiler-Option-Lang)*, see below) given elapsed (if any value was passed) or until the user presses a key. If `amount` is below 100 ms then `Sleep` will always wait the full requested amount (key presses are ignored).

 Include the second parameter, `1`, for a "deep" sleep, which cannot be interrupted by pressing a key.

 The accuracy of `Sleep` is variable depending on the OS cycle time:

Windows NT/2K/XP: 15 ms, 9x/Me: 50 ms, Linux: 10ms, DOS: 55 ms.

And using for the `amount` parameter values lower than these accuracy values does not allow `Sleep` to produce the corresponding wait values (always higher wait, and of the order of these values) except for the `amount` value '0'.

 Call `Sleep` with 25ms or less to release time-slice when waiting for user input or looping inside a thread. This will prevent the program from unnecessarily hogging the CPU.

 `Sleep` does not clear the keyboard input buffer and any keys pressed during a call to `Sleep` are retained and can be later read by [`Inkey`](Inkey) or [`GetKey`](Getkey) or [`Input`](procedures-Input).  
 When `Sleep` has no parameters (waiting for a key pressed only), [`GetKey`](Getkey) keyword can be used instead of Sleep.  
 For the general form of `Sleep` (with parameters), if the user want to clear the keyboard input buffer from any eventual keys pressed during the `Sleep` execution, he can use after the `Sleep` instruction line something like the following method:

`While Inkey <> "": Wend '' loop until the keyboard input buffer is empty`

## Return Value

Returns `1` if `keyflag` was not a valid value (i.e. something other than `0` or `1`) to indicate failure, or `0` otherwise.

## Remarks

### Usage

```freebasic
Sleep [ amount [, keyflag ]]

result = Sleep ( amount, keyflag )
```

### Dialect Differences

- In the *[-lang fb](Compiler-Option-Lang)* and *[-lang fblite](Compiler-Option-Lang)* dialects, the `amount` value is in **milliseconds**.
  In the *[-lang qb](Compiler-Option-Lang)* dialect, the `amount` value is in **seconds** as in QB. If the second parameter `keyflag` is given, or the keyword is written as `__Sleep` the value is expected to be in **milliseconds**.

### Differences from QB

- None in the *[-lang qb](Compiler-Option-Lang)* dialect.
- In QB, the delay was given in whole seconds only and did not support the `keyflag` parameter.

### See also

- [`Timer`](Timer)
- [`Inkey`](Inkey)

## Examples

```freebasic
Print "press a key"

Sleep

GetKey  '' clear the keyboard input buffer, and even in that code case, the 'Sleep' keyword can be outright omitted

Print "waiting half second"

Sleep 500
```

```freebasic
Dim As String s

Print "wait 3 seconds or press a key"

Sleep 3000

Print "outputed by timeout or key pressed"

While Inkey <> ""  '' loop until the keyboard input buffer is empty

Wend

Input "enter a string"; s

Print "string entered: " & "'" & s & "'"

Sleep
```

---

**Category:** [Miscellaneous Keywords](Category-Miscellaneous-Keywords)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
