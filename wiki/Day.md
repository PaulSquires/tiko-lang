[Home](Home) › [Date and Time Functions](Category-Date-and-Time-Functions) › **Day**

# Day

Gets the day of the month from a Date Serial

## Syntax

```freebasic
Declare Function Day ( ByVal date_serial As Double ) As Long
```

## Parameters

- `date_serial`

## Description

The compiler will not recognize this function unless `vbcompat.bi` is included.

## Return Value

Returns the day of the month from a variable containing a date in Date Serial format.

## Remarks

### Usage

```freebasic
#include "vbcompat.bi"

result = Day( date_serial )
```

### Differences from QB

- Did not exist in QB. This function appeared in PDS and VBDOS

## Examples

```freebasic
#include "vbcompat.bi"

Dim ds As Long = DateSerial(2005, 11, 28)

Print Format(ds, "yyyy/mm/dd "); Day(ds)
```

---

**Category:** [Date and Time Functions](Category-Date-and-Time-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
