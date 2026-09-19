[Home](Home) › [Miscellaneous Keywords](Category-Miscellaneous-Keywords) › **Out**

# Out

Outputs a value to a hardware port.

## Syntax

```freebasic
Declare Function Out ( ByVal port As UShort , ByVal data As UByte ) As Long
```

## Parameters

- `port`
- `data`

## Description

This function sends `value` to `port` and returns immediately.

## Remarks

### Usage

`Out port,value`

### Platform Differences

- In the Windows and Linux versions three port numbers (&H3C7, &H3C8, &H3C9) are hooked by the graphics library when a graphics mode is in use to emulate QB's VGA palette handling. This use is deprecated; use [`Palette`](Palette) to retrieve and set palette colors.

  Using true port access in the Windows version requires the program to install a device driver for the present session. For that reason, Windows executables using hardware port access should be run with administrator permits each time the computer is restarted. Further runs don't require admin rights as they just use the already installed driver. The driver is only 3K in size and is embedded in the executable.

### See also

- [`Inp`](Inp)
- [`Wait`](Wait)
- [`Palette`](Palette)

## Examples

```freebasic
'speakersound.bas

Sub Sound(ByVal freq As UInteger, dur As UInteger)

  Dim t As Double,f1 As Unsigned Short

    f1 = 1193181 \ freq

    Out &h61,Inp(&h61) Or 3

    Out &h43,&hb6

    Out &h42,LoByte(f1)

    Out &h42,HiByte(f1)

    t=Timer

    While ((Timer - t) * 1000) < dur

      Sleep 0,1

    Wend

    Out &h61,Inp(&h61) And &hfc

End Sub

Sound(523, 60)  'C5

Sound(587, 60)  'D5

Sound(659, 60)  'E5

Sound(698, 60)  'F5

Sound(784, 60)  'G5

Sound(880, 60)  'A5

Sound(988, 60)  'B5

Sound(1046, 60) 'C6
```

---

**Category:** [Miscellaneous Keywords](Category-Miscellaneous-Keywords)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
