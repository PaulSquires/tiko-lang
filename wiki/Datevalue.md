[Home](Home) › [Date and Time Functions](Category-Date-and-Time-Functions) › **DateValue**

# DateValue

Returns the date serial for text written in the system's date format.

## Syntax

```freebasic
Declare Function DateValue ( ByRef date_string As String ) As Long
```

## Parameters

- `date_string`

## Description

The date string must be in the format set in the regional settings of the Operating System.

 `DateValue( Date() )` will work correctly only if the regional settings specify the same short date format QB used (`mm-dd-yyyy`). Consider using the [`Now`](Now) function in the expression `Fix(Now())` to obtain the current date as a date serial.

 The compiler will not recognize this function unless `vbcompat.bi` or `datetime.bi` is included.

## Return Value

Returns a Date Serial from a date string.

## Remarks

### Usage

```freebasic
#include "vbcompat.bi"

result = DateValue( date_string )
```

### Differences from QB

- Did not exist in QB. This function appeared in PDS and VBDOS

### See also

- [`DateSerial`](Dateserial)
- [`TimeValue`](Timevalue)

## Examples

```freebasic
#include "vbcompat.bi"

Dim As Long v1, v2

Dim As String  s1, s2

Print "Enter first date: ";

Line Input s1

If IsDate( s1 ) = 0 Then

  Print "not a date"

  End

End If

Print "Enter second date: ";

Line Input s2

If IsDate( s2 ) = 0 Then

  Print "not a date"

  End

End If

'' convert the strings to date serials

v1 = DateValue( s1 )

v2 = DateValue( s2 )

Print "Number of days between dates is " & Abs( v2 - v1 )
```

---

**Category:** [Date and Time Functions](Category-Date-and-Time-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
