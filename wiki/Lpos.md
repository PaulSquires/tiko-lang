[Home](Home) › [Miscellaneous Keywords](Category-Miscellaneous-Keywords) › **LPos**

# LPos

Returns the number of characters sent to the printer port in the last LPrint statement.

## Syntax

```freebasic
Declare Function LPos ( ByVal printer As Long ) As Long
```

## Parameters

- `printer`

## Description

Used to determine, from the last [`LPrint`](Lprint), how many characters were sent to the printer port.

## Return Value

Returns the number of characters sent.

## Remarks

### Usage

`result = LPOS(printer)`

### Differences from QB

- None

### See also

- [`LPrint`](Lprint)

## Examples

```freebasic
' compile with -lang fblite or qb

#lang "fblite"

Dim test As String = "LPrint Example test"

Print "Sending '" + test + "' to LPT1 (default)"

LPrint test

Print "LPT1 last recieved " + Str(LPos(1)) + " characters"

Print "String sent was " + Str(Len(test)) + " characters long"

Sleep
```

---

**Category:** [Miscellaneous Keywords](Category-Miscellaneous-Keywords)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
