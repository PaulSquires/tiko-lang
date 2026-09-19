[Home](Home) › [Miscellaneous Keywords](Category-Miscellaneous-Keywords) › **Until**

# Until

Conditional clause used in Do..Loop statements.

## Syntax

```freebasic
Do Until condition
Loop Until condition
```

## Description

`Until` is used with the [`Do...Loop`](Do-Loop) structure.

## Remarks

### Differences from QB

- None

### See also

- [`Do...Loop`](Do-Loop)

## Examples

```freebasic
Dim a As Integer

a = 1

Do

    Print "hello"

a = a + 1

Loop Until a > 10

'This will continue to print "hello" on the screen until the condition (a > 10) is met.
```

---

**Category:** [Miscellaneous Keywords](Category-Miscellaneous-Keywords)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
