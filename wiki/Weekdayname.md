[Home](Home) › [Date and Time Functions](Category-Date-and-Time-Functions) › **WeekdayName**

# WeekdayName

Gets the name of a week day from its integral representation

## Syntax

```freebasic
Declare Function WeekdayName ( ByVal weekday As Long, ByVal abbreviate As Long = 0, ByVal firstdayofweek As Long = fbUseSystem ) As String
```

## Parameters

- `weekday`
- `abbreviate`
- `firstdayofweek`

## Description

How `weekday` is interpreted depends on the `firstdayofweek` parameter.

 If `abbreviate` is true, a 3 letter abbreviation is returned, if false or omitted, the whole name is returned.

 `firstdayofweek` is an optional parameter specified as follows:

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

The compiler will not recognize this function unless `vbcompat.bi` or `datetime.bi` is included.

## Return Value

Returns the local operating system language day of week name from the `weekday` value 1 to 7.

## Remarks

### Usage

```freebasic
#include "vbcompat.bi"

result = WeekdayName( weekday [, abbreviate [, firstdayofweek ] ] )
```

### Differences from QB

- Did not exist in QB. This function appeared in Visual Basic.

## Examples

```freebasic
#include "vbcompat.bi"

Dim a As Double = DateSerial(2005, 11, 28) + TimeSerial(7, 30, 50)

Print Format(a, "yyyy/mm/dd hh:mm:ss "); WeekdayName(Weekday(a))
```

---

**Category:** [Date and Time Functions](Category-Date-and-Time-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
