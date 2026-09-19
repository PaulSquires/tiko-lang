[Home](Home) › [Console Functions](Category-Console-Functions) › **Pos**

# Pos

Returns the horizontal (left to right) position of the text cursor

## Syntax

```freebasic
Declare Function Pos ( ) As Long
Declare Function Pos ( ByVal dummy As Long ) As Long
```

## Parameters

- `dummy`

## Description

Returns the horizontal (left to right) position of the text cursor. The leftmost column is number `1`.

## Return Value

Returns the horizontal position of the text cursor.

## Remarks

### Usage

`result = Pos[ ( dummy ) ]`

### Differences from QB

- The `dummy` parameter was not optional in QBASIC.

### See also

- [`CsrLin`](Csrlin)
- [`Tab`](Tab)
- [`Locate`](Locate)

## Examples

```freebasic
Dim As Long p

'' print starting column position

p = Pos()

Print "position: "; p

'' print a string, without a new-line

Print "ABCDEF";

'' print new column position:

p = Pos()

Print: Print "position: "; p

Print

''position changes after each Print:

Print "Column numbers: "

Print Pos(), Pos(), Pos(), Pos(), Pos()
```

---

**Category:** [Console Functions](Category-Console-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
