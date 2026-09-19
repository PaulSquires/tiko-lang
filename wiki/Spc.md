[Home](Home) › [Console Functions](Category-Console-Functions) › **Spc**

# Spc

Output function to skip spaces when writing to screen or file

## Syntax

```freebasic
Spc( columns )
```

## Parameters

- `spaces`

## Description

`Spc` skips over the given number of `spaces` when [`Print`](Print)ing to screen or to a file. The character cells skipped over are left unchanged.

## Remarks

### Usage

`Print Spc( spaces ) [(, | ;)] ...`

### Differences from QB

- In QBASIC, spaces were printed in the gap, while in FreeBASIC, the characters are just skipped over and left untouched. The [`Space`](Space) function can still be used to achieve this effect.

### See also

- [`Tab`](Tab)
- [`Space`](Space)
- [`Print`](Print)
- [`?`](Print)

## Examples

```freebasic
Print "foo"; Spc(5); "bar"

Print "hello"; Spc(4); "world"
```

```freebasic
'' Uses Spc to justify text instead of Tab

Dim As String A1, B1, A2, B2

A1 = "Jane"

B1 = "Doe"

A2 = "Bob"

B2 = "Smith"

Print "FIRST NAME"; Spc(35 - 10); "LAST NAME"

Print "----------"; Spc(35 - 10); "----------"

Print A1; Spc(35 - Len(A1)); B1

Print A2; Spc(35 - Len(A2)); B2
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
