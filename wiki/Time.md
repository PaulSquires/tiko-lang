[Home](Home) › [Date and Time Functions](Category-Date-and-Time-Functions) › **Time**

# Time

Returns the current system time as a string

## Syntax

```freebasic
Declare Function Time ( ) As String
```

## Description

Returns the current system time in the format `hh:mm:ss`.

## Return Value

Returns the current system time.

## Remarks

### Usage

`result = Time[$]`

### Differences from QB

- The QB TIME statement (to set the system time) is now called [`SetTime`](Settime).
  The string type suffix "$" is required in the *[-lang qb](Compiler-Option-Lang)* dialect.  
  The string type suffix "$" is optional in the *[-lang fblite](Compiler-Option-Lang)* dialect.  
  The string type suffix "$" is ignored in the *[-lang fb](Compiler-Option-Lang)* dialect, warn only with the *[-w suffix](Compiler-Option-W)* compile option (or *[-w pedantic](Compiler-Option-W)* compile option).

### See also

- [`Date`](Date)
- [`Timer`](Timer)

## Examples

`Print "the current time is: "; Time`

---

**Category:** [Date and Time Functions](Category-Date-and-Time-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
