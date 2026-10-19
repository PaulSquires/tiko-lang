[Home](Home) › [Date and Time Functions](Category-Date-and-Time-Functions) › **Date**

# Date

Returns today's date as text in the form mm-dd-yyyy.

## Syntax

```freebasic
Declare Function Date ( ) As String
```

## Description

None

## Return Value

Returns the current system date, in the format `mm-dd-yyyy`

## Remarks

### Usage

`result = Date[$]`

### Differences from QB

- The QB DATE statement (to set the system date) is now called [`SetDate`](Setdate).
  The string type suffix "$" is required in the *[-lang qb](Compiler-Option-Lang)* dialect.  
  The string type suffix "$" is optional in the *[-lang fblite](Compiler-Option-Lang)* dialect.  
  The string type suffix "$" is ignored in the *[-lang fb](Compiler-Option-Lang)* dialect, warn only with the *[-w suffix](Compiler-Option-W)* compile option (or *[-w pedantic](Compiler-Option-W)* compile option).

### See also

- [`SetDate`](Setdate)
- [`Time`](Time)
- [`Timer`](Timer)

## Examples

`Print Date ' prints the current date`

---

**Category:** [Date and Time Functions](Category-Date-and-Time-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
