[Home](Home) › [Console Functions](Category-Console-Functions) › **Tab**

# Tab

Sets the column when writing to screen or file

## Syntax

```freebasic
Tab( col_num )
```

## Parameters

- `column`

## Description

`Tab` will move the cursor to given `column` number when [`Print`](Print)ing to screen or to a file. Character cells skipped over between the old and new cursor positions are left unchanged.  
 If the current column is greater than `column`, then `Tab` will move the cursor to the requested column number on the next line. If the current column is equal to `column`, then the cursor will not move anywhere.

## Remarks

### Usage

`Print Tab( column ) [(, | ;)] ...`

### Differences from QB

- In QBASIC, spaces were printed in the gap, while in FreeBASIC, the characters are just skipped over and left untouched.

### See also

- [`Spc`](Spc)
- [`Locate`](Locate)
- [`Pos`](Pos)
- [`Print`](Print)
- [`?`](Print)

## Examples

```freebasic
'' Using Print with Tab to justify text in a table

Dim As String A1, B1, A2, B2

A1 = "Jane"

B1 = "Doe"

A2 = "Bob"

B2 = "Smith"

Print "FIRST NAME"; Tab(35); "LAST NAME"

Print "----------"; Tab(35); "----------"

Print A1; Tab(35); B1

Print A2; Tab(35); B2
```

 The output would look like:

```freebasic
FIRST NAME                         LAST NAME
----------                         ----------
Jane                               Doe
Bob                                Smith
```

---

**Category:** [Console Functions](Category-Console-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
