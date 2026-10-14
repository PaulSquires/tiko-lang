[Home](Home) › [Date and Time Functions](Category-Date-and-Time-Functions) › **Weekday**

# Weekday

Gets the number of day of the week from a Date Serial

## Syntax

```freebasic
Declare Function Weekday ( ByVal serial As Double , ByVal firstdayofweek As Long = fbusesystem ) As Long
```

## Parameters

- `date_serial`
- `firstdayofweek`

## Description

The week day values must be in the range 1-7, its meaning depends on the `firstdayofweek` parameter

 `firstdayofweek` is optional.

| value | first day of week | constant |
| --- | --- | --- |
| omitted | sunday | |
| 0 | local settings | fbUseSystem |
| 1 | sunday | fbSunday |
| 2 | monday | fbMonday |
| 3 | tuesday | fbTuesday |
| 4 | wednesday | fbWednesday |
| 5 | thursday | fbThursday |
| 6 | friday | fbFriday |
| 7 | saturday | fbSaturday |

The compiler will not recognize this function unless `vbcompat.bi` is included.

## Return Value

Returns the week day number from a variable containing a date in Date Serial format.

## Remarks

### Usage

```freebasic
#include "vbcompat.bi"

result = Weekday( date_serial [, firstdayofweek ] )
```

### Differences from QB

- Did not exist in QB. This function appeared in PDS and VBDOS

## Examples

```freebasic
#include "vbcompat.bi"

Dim a As Double = DateSerial (2005, 11, 28) + TimeSerial(7, 30, 50)

Print Format(a, "yyyy/mm/dd hh:mm:ss "); Weekday(a)
```

---

**Category:** [Date and Time Functions](Category-Date-and-Time-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
