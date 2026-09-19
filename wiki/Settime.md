[Home](Home) › [Date and Time Functions](Category-Date-and-Time-Functions) › **SetTime**

# SetTime

Sets the current system time

## Syntax

```freebasic
Declare Function SetTime ( ByRef newtime As Const String ) As Long
```

## Parameters

- `newtime`

## Description

To set the time, format the date and send to `Settime` in one of the following formats: `"hh:mm:ss"`, `"hh:mm"`, or `"hh"` (`hh` is the hour, `mm` is the minute, and `ss` is the second).

 The error code returned by `SetTime` can be checked using [`Err`](Err) in the next line. The function version of `SetTime` returns directly the error code as a 32 bit [`Long`](Long).

## Return Value

Returns zero on success or non-zero on failure on all ports except DOS.

## Remarks

### Usage

`result = SetTime( newtime )`

### Platform Differences

- On Windows the privilege SE_SYSTEMTIME_NAME is required, which typically means that the calling process has to be run with administrator privileges.
  On Linux the capability CAP_SYS_TIME is required, which typically means that the calling process has to be run as root/superuser.

### Differences from QB

- The [`Time`](Time) statement was used QB and the syntax was `TIME = newtime`.

### See also

- [`Time`](Time)
- [`SetDate`](Setdate)

## Examples

`SetTime "1:20:30"`

---

**Category:** [Date and Time Functions](Category-Date-and-Time-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
