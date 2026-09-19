[Home](Home) › [Date and Time Functions](Category-Date-and-Time-Functions) › **DateAdd**

# DateAdd

Offset a date with a specified interval

## Syntax

```freebasic
Declare Function DateAdd ( ByRef interval As Const String, ByVal number As Double, ByVal date_serial As Double ) As Double
```

## Parameters

- `interval`
- `number`
- `number`
- `date_serial`

## Description

Interval is specified as follows:

| value | interval |
| --- | --- |
| yyyy | years |
| q | quarter(three months) |
| m | months |
| ww | weeks |
| d,w,y | days |
| h | hours |
| n | minutes |
| s | seconds |

 The compiler will not recognize this function unless `vbcompat.bi` or `datetime.bi` is included.

## Return Value

Returns a [Date Serial](Date-Serials) corresponding to the received `date_serial` plus the `number` of `intervals`.

## Remarks

### Usage

```freebasic
#include "vbcompat.bi"

result = DateAdd( interval, number, date_serial )
```

### Differences from QB

- Did not exist in QB. This function appeared in Visual Basic.

### See also

- [Date Serials](Date-Serials)

## Examples

```freebasic
#include "vbcompat.bi"

Const fmt = "ddddd ttttt"

Dim d As Double

d = Now()

Print "1 hour from now is ";

Print Format( DateAdd( "h", 1, d ), fmt )

Print "1 day from now is ";

Print Format( DateAdd( "d", 1, d ), fmt )

Print "1 week from now is ";

Print Format( DateAdd( "ww", 1, d ), fmt )

Print "1 month from now is ";

Print Format( DateAdd( "m", 1, d ), fmt )
```

---

**Category:** [Date and Time Functions](Category-Date-and-Time-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
