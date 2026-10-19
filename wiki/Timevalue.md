[Home](Home) › [Date and Time Functions](Category-Date-and-Time-Functions) › **TimeValue**

# TimeValue

Returns the date serial of a time written like 23:59:59 or 11:59:59PM.

## Syntax

```freebasic
Declare Function TimeValue ( ByRef timestring As String ) As Double
```

## Parameters

- `timestring`

## Description

The time string must be in the format `"23:59:59"` or `"11:59:59PM"`

 The compiler will not recognize this function unless `vbcompat.bi` or `datetime.bi` is included.

## Return Value

Returns a Date Serial from a time string.

## Remarks

### Usage

```freebasic
#include "vbcompat.bi"

result = TimeValue( timestring )
```

### Differences from QB

- Did not exist in QB. This function appeared in PDS and VBDOS

### See also

- [`DateSerial`](Dateserial)
- [`TimeValue`](Timevalue)
- [`DateValue`](Datevalue)

## Examples

```freebasic
#include "vbcompat.bi"

Dim ds As Double = TimeValue("07:12:28AM")

Print Format(ds, "hh:mm:ss")
```

---

**Category:** [Date and Time Functions](Category-Date-and-Time-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
