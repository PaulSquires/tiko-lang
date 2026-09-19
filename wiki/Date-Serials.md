[Home](Home) › [Tutorials](Category-Tutorials) › **Date Serials**

# Date Serials

A floating point number representing a date and time

Description

A date serial is a number that holds a date and time value in the same format used by PDS or VBDOS. The value is a count of the days from 0:00 AM of December 30,1899; it's mainly used for easy counting of the time between two dates.

 The date serial unit is one day and the fractional part represents the time of the day. If a date serial is written into an integer, the time is lost. FreeBASIC date serials are not limited to dates between 1753 and 2078 as in VBDOS. FreeBASIC date serial handling functions use [`Double`](Double) arguments.

 FreeBASIC date serial handling functions require the inclusion of `vbcompat.bi` or `datetime.bi` in the source.

 A date serial can be created by the functions [`Now`](Now), [`TimeSerial`](Timeserial)+[`DateSerial`](Dateserial), or [`DateValue`](Datevalue)+[`TimeValue`](Timevalue).

 The functions [`Year`](Year), [`Month`](Month), [`Weekday`](Weekday), [`Day`](Day), [`Hour`](Hour), [`Minute`](Minute), [`Second`](Second) allow to recover the different components of a date serial.

 The [`Format`](Format) function has formatting expressions to print date serials in a human readable way.

Example

```freebasic
#include "vbcompat.bi"

Dim a As Double, b As Double

a = 0

Print "The origin of the date serials is:"

Print Format(a, "yyyy/mm/dd hh:mm:ss")

Print

a = Now

Print "The time now is: "

Print Format(a, "yyyy/mm/dd hh:mm:ss")

Print

b = DateSerial(2000,1,1)

Print Int(a-b) & " days have passed since 2000/01/01"
```

---

**Category:** [Tutorials](Category-Tutorials)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
