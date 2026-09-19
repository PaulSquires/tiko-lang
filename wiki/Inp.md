[Home](Home) › [Miscellaneous Keywords](Category-Miscellaneous-Keywords) › **Inp**

# Inp

Returns a value at a hardware port.

## Syntax

```freebasic
Declare Function Inp ( ByVal port As UShort ) As Long
```

## Parameters

- `port`

## Description

This function retrieves the value at 'port' and returns immediately.

## Return Value

The value at the specified port.

## Remarks

### Usage

`value = Inp(port)`

### Platform Differences

- In the Windows and Linux versions three port numbers (&H3C7, &H3C8, &H3C9) are hooked by the graphics library when a graphics mode is in use to emulate QB's VGA palette handling. This use is deprecated; use [`Palette`](Palette) to retrieve and set palette colors.

  Using true port access in the Windows version requires the program to install a device driver for the present session. For that reason, Windows executables using hardware port access should be run with administrator permits each time the computer is restarted. Further runs don't require admin rights as they just use the already installed driver. The driver is only 3K in size and is embedded in the executable.

### See also

- [`Out`](Out)
- [`Wait`](Wait)
- [`Palette`](Palette)

## Examples

```freebasic
'' Turn off PC speaker

Out &h61,Inp(&h61) And &hfc
```

---

**Category:** [Miscellaneous Keywords](Category-Miscellaneous-Keywords)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
