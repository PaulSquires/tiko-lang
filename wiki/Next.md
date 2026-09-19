[Home](Home) › [Miscellaneous Keywords](Category-Miscellaneous-Keywords) › **Next**

# Next

Control flow statement to mark the end of a For...Next loop.

## Syntax

```freebasic
Next [ identifier_list ]
```

## Description

Indicates the end of a statement block associated with a matching [`For`](For-Next) statement.

 When `Next` is used on its own without an *identifier_list*, it closes the most recent [`For`](For-Next) statement block.

 `identifier_list` is optional and may be one or more variable names separated by commas. This form of the `Next` statement is retained for compatibility with QB. `identifier_list`, if given, must match the identifiers used in the associated [`For`](For-Next) statements in reverse order, from inner to outer.

## Remarks

### Differences from QB

- [`ByRef`](Byref-Parameters) arguments cannot be used as counters.

### See also

- [`For...Next`](For-Next)

## Examples

```freebasic
For i As Integer = 1 To 10

    For j As Integer = 1 To 2

        ' ...

    Next

Next
```

```freebasic
For i As Integer = 1 To 10

    For j As Integer = 1 To 2

        ' ...

    Next j

Next i
```

```freebasic
For i As Integer = 1 To 10

For j As Integer = 1 To 2

    ' ...

Next j,i
```

---

**Category:** [Miscellaneous Keywords](Category-Miscellaneous-Keywords)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
