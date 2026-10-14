[Home](Home) › [Control Flow Statements](Category-Control-Flow-Statements) › **On...Goto**

# On...Goto

Jumps to a label based on an expression.

## Syntax

```freebasic
On expression Goto label1[, ...]
```

## Description

Branches to different labels depending on the value of *expression*. An expression value of 1 will branch to the first label, a value of 2 to the second, etc. If the value of *expression* is zero (0) or greater than the number of items in the list, execution continues on the next statement following the `On...Goto`.

 It is recommended that the structured [`Select Case`](procedures-Select-Case) conditional statement be used instead of `On...Goto`.

## Remarks

### Differences from QB

- FreeBASIC does not generate a run-time error if `expression` is negative or greater than 255.

### See also

- [`Select Case`](procedures-Select-Case)
- [`On...Gosub`](On-Gosub)
- [`Goto`](Goto)

## Examples

```freebasic
Dim choice As Integer

Input "Enter a number: ", choice

On choice Goto labela, labelb, labelc

labela:

Print "choice a"

End

labelb:

Print "choice b"

End

labelc:

Print "choice c"

End
```

---

**Category:** [Control Flow Statements](Category-Control-Flow-Statements)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
