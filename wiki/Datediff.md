[Home](Home) › [Date and Time Functions](Category-Date-and-Time-Functions) › **DateDiff**

# DateDiff

Gets the difference of two dates measured by a specified interval

## Syntax

```freebasic
Declare Function DateDiff ( ByRef interval As Const String, ByVal serial1 As Double, ByVal serial2 As Double, ByVal firstdayofweek As Long = fbUseSystem, ByVal firstdayofyear As Long = fbUseSystem ) As LongInt
```

## Parameters

- `interval`
- `date_serial1`
- `date_serial2`
- `firstdayofweek`
- `firstdayofyear`

## Description

`interval` is specified as follows:

| value | interval |
| --- | --- |
| yyyy | years |
| q | quarter(three months) |
| m | months |
| w | seven day periods |
| ww | calendar weeks |
| d,y | days |
| h | hours |
| n | minutes |
| s | seconds |

`first_dayofweek` Affects the counting when `'ww'` interval is used.

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

`first_weekofyear` specifies which year (previous or next) that the week which spans the end of one year and the beginning of the next should included with.

| value | first week of year | constant |
| --- | --- | --- |
| 0 | local settings | fbUseSystem |
| 1 | January 1's week | fbFirstJan1 |
| 2 | first weeks having 4 days in the year | fbFirstFourDays |
| 3 | first full week of year | fbFirstFullWeek |

Notice if you do an arithmetical subtraction of two date serials you get the difference in days.

 The compiler will not recognize this function unless `vbcompat.bi` or `datetime.bi` is included.

## Return Value

Returns a [`LongInt`](Longint) corresponding to the number of `interval`s found between two [Date Serials](Date-Serials).

 If `date_serial1` > `date_serial2`, the result is negative.

## Remarks

### Usage

```freebasic
#include "vbcompat.bi"

result = DateDiff( interval, date_serial1, date_serial2 [, firstdayofWeek [, firstweekofyear ] ] )
```

### Differences from QB

- Did not exist in QB. This function appeared in Visual Basic.

### See also

- [Date Serials](Date-Serials)

## Examples

```freebasic
#include "vbcompat.bi"

Dim s As String, d1 As Double, d2 As Double

Line Input "Enter your birthday: ", s

If IsDate( s ) Then

  d1 = DateValue( s )

  d2 = Now()

  Print "You are " & DateDiff( "yyyy", d1, d2 ) & " years old."

  Print "You are " & DateDiff( "d", d1, d2 ) & " days old."

  Print "You are " & DateDiff( "s", d1, d2 ) & " seconds old."

Else

  Print "Invalid date"

End If
```

---

**Category:** [Date and Time Functions](Category-Date-and-Time-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
