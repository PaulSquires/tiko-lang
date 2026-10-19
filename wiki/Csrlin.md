[Home](Home) › [Console Functions](Category-Console-Functions) › **CsrLin**

# CsrLin

Returns the row the cursor is on, counting from 1 at the top.

## Syntax

```freebasic
Declare Function CsrLin ( ) As Long
```

## Description

Returns the current row the cursor is on (i.e. the "**c**ur**s**o**r** **lin**e"). The topmost row is number `1`.

## Return Value

An [`Long`](Long) specifying the current row of the cursor.

## Remarks

### Usage

`result = CsrLin`

### Differences from QB

- None

### See also

- [`Locate`](Locate)
- [`Pos`](Pos)

## Examples

`Print "The cursor is on row:"; CsrLin`

---

**Category:** [Console Functions](Category-Console-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
