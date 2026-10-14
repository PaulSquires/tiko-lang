[Home](Home) › [Date and Time Functions](Category-Date-and-Time-Functions) › **TimeSerial**

# TimeSerial

Gets a Date Serial for the specified hours, minutes, and seconds

## Syntax

```freebasic
Declare Function TimeSerial ( ByVal hour As Long, ByVal minute As Long, ByVal second As Long ) As Double
```

## Parameters

- `hour`
- `minute`
- `second`

## Description

`hours` must be specified in the range 0-23

 The compiler will not recognize this function unless `vbcompat.bi` or `datetime.bi` is included.

## Return Value

Returns a date serial containing the time formed by the values in the `hours`, `minutes` and `seconds` parameters.The date serial returned has no integer part.

## Remarks

### Usage

```freebasic
#include "vbcompat.bi"

result = TimeSerial( hours, minutes, seconds )
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

Dim ds As Double = DateSerial(2005, 11, 28) + TimeSerial(7, 30, 50)

Print Format(ds, "yyyy/mm/dd hh:mm:ss")
```

---

**Category:** [Date and Time Functions](Category-Date-and-Time-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
