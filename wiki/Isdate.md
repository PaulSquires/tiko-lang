[Home](Home) › [Date and Time Functions](Category-Date-and-Time-Functions) › **IsDate**

# IsDate

Tests if a string can be converted to a Date Serial

## Syntax

```freebasic
Declare Function IsDate ( ByRef stringdate As Const String ) As Long
```

## Parameters

- `stringdate`

## Description

Date strings must be in the format set in the regional settings of the OS to be considered valid dates.

 `IsDate(Date)` will return non-zero (-1) only if the regional settings specify the same date format that QB used.

 The compiler will not recognize this function unless `vbcompat.bi` or `datetime.bi` is included.

## Return Value

Returns non-zero (-1) if the date string can be converted to a [Date Serial](Date-Serials), otherwise returns zero (0).

## Remarks

### Usage

```freebasic
#include "vbcompat.bi"

result = IsDate( stringdate )
```

### Differences from QB

- New to FreeBASIC

### See also

- [Date Serials](Date-Serials)
- [`DateSerial`](Dateserial)
- [`TimeValue`](Timevalue)
- [`DateValue`](Datevalue)

## Examples

```freebasic
#include "vbcompat.bi"

Dim s As String, d As Long

Do

  Print

  Print "Enter a date: "

  Line Input s

  If s = "" Then Exit Do

  If IsDate( s ) = 0 Then

    Print "'"; s; "' is not a valid date"

  Else

    d = DateValue( s )

    Print "year  = "; Year( d )

    Print "month = "; Month( d )

    Print "day   = "; Day( d )

  End If

Loop
```

---

**Category:** [Date and Time Functions](Category-Date-and-Time-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
