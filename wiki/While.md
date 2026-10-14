[Home](Home) › [Miscellaneous Keywords](Category-Miscellaneous-Keywords) › **While**

# While

Control flow statement.

## Syntax

```freebasic
Do While condition
[statement block]
Loop
Do
[statement block]
Loop While condition
While [condition]
[statement block]
```

## Description

`While` specifies that a loop block will continue if the `condition` following it evaluates as true. This `condition` is checked during each loop iteration.

## Remarks

### Differences from QB

- None, except for the `End While` syntax (equivalent to `Wend`) specific to FreeBASIC.

### See also

- [`Do...Loop`](Do-Loop)
- [`While...Wend (Or 'While...End While')`](While-Wend-or-While-End-While)

## Examples

```freebasic
Dim a As Integer

a = 0

Do While a < 10

    Print "hello"

a = a + 1

Loop

'This will continue to print "hello" on the screen while the condition (a < 10) is met.
```

---

**Category:** [Miscellaneous Keywords](Category-Miscellaneous-Keywords)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
