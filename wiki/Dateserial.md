[Home](Home) › [Date and Time Functions](Category-Date-and-Time-Functions) › **DateSerial**

# DateSerial

Returns the date serial for a year, month and day; out-of-range values roll over.

## Syntax

```freebasic
Declare Function DateSerial ( ByVal year As Long, ByVal month As Long, ByVal day As Long ) As Long
```

## Parameters

- `year`
- `month`
- `day`

## Description

The compiler will not recognize this function unless `vbcompat.bi` or `datetime.bi` is included.

## Return Value

Returns a date serial containing the date formed by the values in the `year`, `month` and `day` parameters.The date serial returned has no decimal part.

## Remarks

### Usage

```freebasic
#include "vbcompat.bi"

result = DateSerial( year, month, day )
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

Dim a As Long = DateSerial(2005, 11, 28)

Print Format(a, "yyyy/mm/dd hh:mm:ss")
```

---

**Category:** [Date and Time Functions](Category-Date-and-Time-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
