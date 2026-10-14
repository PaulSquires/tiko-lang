[Home](Home) › [Date and Time Functions](Category-Date-and-Time-Functions) › **Now**

# Now

Gets the current system time as a Date Serial

## Syntax

```freebasic
Declare Function Now ( ) As Double
```

## Description

As the time is the decimal part of a date serial, if the value of **Now** is saved to an integer, the time in it will be reset to 00:00:00

 The compiler will not recognize this function unless `vbcompat.bi` is included.

## Return Value

Returns a date serial containing the system's date and time at execution time.

## Remarks

### Usage

```freebasic
#include "vbcompat.bi"

result = Now
```

### Differences from QB

- Did not exist in QB. This function appeared in PDS and VBDOS

## Examples

```freebasic
#include "vbcompat.bi"

Dim a As Double = Now()

Print Format(a, "yyyy/mm/dd hh:mm:ss")
```

---

**Category:** [Date and Time Functions](Category-Date-and-Time-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
