[Home](Home) › [Date and Time Functions](Category-Date-and-Time-Functions) › **SetDate**

# SetDate

Sets the current system date

## Syntax

```freebasic
Declare Function SetDate ( ByRef newdate As Const String ) As Long
```

## Parameters

- `newdate`

## Description

To set the date you just format `newdate` and send to `SetDate` in a valid format following one of the following: `"mm-dd-yy"`, `"mm-dd-yyyy"`, `"mm/dd/yy"`, or `"mm/dd/yyyy"` (`mm` is the month, `dd` is the day, `yy` or `yyyy` is the year). Two-digit year numbers are based on the year 1900.

 The error code returned by `SetDate` can be checked using [`Err`](Err) in the next line. The function version of `SetDate` returns directly the error code as a 32 bit [`Long`](Long).

## Return Value

Returns zero on success or non-zero on failure on all ports except DOS.

## Remarks

### Usage

`result = SetDate( newdate )`

### Platform Differences

- On Windows the privilege SE_SYSTEMTIME_NAME is required, which typically means that the calling process has to be run with administrator privileges.
  On Linux the capability CAP_SYS_TIME is required, which typically means that the calling process has to run as root/superuser.

### Differences from QB

- The DATE statement was used in QB and the syntax was "*DATE = string*"

### See also

- [`Date`](Date)
- [`SetTime`](Settime)

## Examples

```freebasic
Dim m As String, d As String, y As String

m = "03" 'march

d = "13" 'the 13th

y = "1994" 'good ol' days

SetDate m + "/" + d + "/" + y
```

---

**Category:** [Date and Time Functions](Category-Date-and-Time-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
