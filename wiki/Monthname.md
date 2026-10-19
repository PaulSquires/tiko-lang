[Home](Home) › [Date and Time Functions](Category-Date-and-Time-Functions) › **MonthName**

# MonthName

Returns the name of a month number in the system's language, or its abbreviation.

## Syntax

```freebasic
Declare Function MonthName ( ByVal month As Long, ByVal abbreviate As Long = 0 ) As String
```

## Parameters

- `month`
- `abbreviate`

## Description

If `abbreviate` is true, the month name abbreviation is returned. If omitted or false, the whole name is returned.

 The compiler will not recognize this function unless `vbcompat.bi` or `datetime.bi` is included.

## Return Value

Returns the local operating system language month name from `month` value 1 to 12.

## Remarks

### Usage

```freebasic
#include "vbcompat.bi"

result = MonthName( month_number [, abreviate ] )
```

### Differences from QB

- Did not exist in QB. This function appeared in Visual Basic.

## Examples

```freebasic
#include "vbcompat.bi"

Dim ds As Double = DateSerial(2005, 11, 28) + TimeSerial(7, 30, 50)

Print Format(ds, "yyyy/mm/dd hh:mm:ss "); MonthName(Month(ds))
```

---

**Category:** [Date and Time Functions](Category-Date-and-Time-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
