[Home](Home) › [Miscellaneous Keywords](Category-Miscellaneous-Keywords) › **LPrint**

# LPrint

Writes text to the default printer.

## Syntax

```freebasic
LPrint [ Using formatstring,] [expressionlist] [(, | ;)] ...
```

## Parameters

- `formatstring`
- `expressionlist`

## Description

Prints `expressionlist` to the printer attached to the parallel port LPT1, or if it does not exist, to the default printer. To print to a printer different from the default one, use [`Open Lpt`](Open-Lpt).

 The [`Using`](Print-Using) clause formats `expressionlist` according to `formatstring`. Except an UDT, any data type can be passed to **`LPrint`** `expressionlist`, expressions do not need to be first converted to strings.

 Using a comma (`,`) as separator or in the end of the `expressionlist` will place the cursor in the next column (every 14 characters), using a semi-colon (`;`) won't move the cursor. If neither of them are used in the end of the `expressionlist`, then a new-line will be printed.

 Some printers will not print at all until a `Chr(12)` (End of Page) character is printed.

 Internally, FreeBASIC uses the special file number `-1` for printing using **`LPrint`**. This file number may be safely closed using `Close -1`. The next use of **`LPrint`** will automatically reopen it as needed.

## Remarks

### Differences from QB

- None

### Dialect Differences

- `LPrint` is not supported in the *[-lang fb](Compiler-Option-Lang)* dialect. In this dialect the printer must be properly opened with [`Open Lpt`](Open-Lpt) and [`Print #`](procedures-Print) must be used to print.

### See also

- [`Open Lpt`](Open-Lpt)
- [`Print`](Print)
- [`?`](Print)
- [`Print #`](procedures-Print)
- [`? #`](procedures-Print)
- [`Write`](Write)

## Examples

```freebasic
'' Compile with -lang fblite or qb

#lang "fblite"

'' new-line

LPrint "Hello World!"

'' no new-line

LPrint "Hello"; "World"; "!";

LPrint

'' column separator

LPrint "Hello!", "World!"

'' end of page

LPrint Chr$(12)
```

---

**Category:** [Miscellaneous Keywords](Category-Miscellaneous-Keywords)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
