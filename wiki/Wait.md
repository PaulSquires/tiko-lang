[Home](Home) › [Miscellaneous Keywords](Category-Miscellaneous-Keywords) › **Wait**

# Wait

Reads from a hardware port with a mask.

## Syntax

```freebasic
Declare Function Wait ( ByVal port As UShort, ByVal and_mask As Long, ByVal xor_mask As Long = 0 ) As Long
```

## Parameters

- `port`
- `and_mask`
- `xor_mask`

## Description

`Wait` keeps reading `port` until the reading ANDed with `and_mask` and optionally XORed with `xor_mask` gives a non-zero result.

## Return Value

0 if successful, -1 on failure.

## Remarks

### Usage

`Wait port, and_value [, xor_value]`

### Platform Differences

- In the Windows and Linux versions three port numbers (&H3C7, &H3C8, &H3C9) are hooked by the graphics library when a graphics mode is in use to emulate VGA palette handling as in QB. This use is deprecated; use [`Palette`](Palette) to retrieve and set palette colors.

  Using true port access in the Windows version requires the program to install a device driver for the present session. For that reason, Windows executables using hardware port access should be run with administrator permits each time the computer is restarted. Further runs don't require admin rights as they just use the already installed driver. The driver is only 3K in size and is embedded in the executable.

### See also

- [`Inp`](Inp)
- [`Out`](Out)

## Examples

```freebasic
Wait &h3da, &h8 'Old Qbasic way of waiting for the monitor's vsync

ScreenSync 'FreeBASIC way of accomplishing the same thing
```

---

**Category:** [Miscellaneous Keywords](Category-Miscellaneous-Keywords)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
