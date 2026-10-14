[Home](Home) › [Control Flow Statements](Category-Control-Flow-Statements) › **On...Gosub**

# On...Gosub

Calls a label based on an expression

## Syntax

```freebasic
On expression GoSub label1[, ...]
```

## Description

Branches to different labels depending on the value of *expression*. An expression value of 1 will branch to the first label, a value of 2 to the second, etc. If the value of *expression* is zero (0) or greater than the number of items in the list, execution continues on the next statement following the `On...Gosub`.

 This statement behaves exactly like [`GoSub`](Gosub) and execution may return to the statement following the `On...Gosub` using [`Return`](Return-From-Gosub).

 It is recommended that the structured [`Select Case`](procedures-Select-Case) conditional statement be used instead of `On...Gosub`.

## Remarks

### Dialect Differences

- Only available in the *[-lang qb](Compiler-Option-Lang)* and *[-lang fblite](Compiler-Option-Lang)* dialects.
  `On Gosub` support is disabled by default in the *[-lang fblite](Compiler-Option-Lang)* unless the `Option Gosub` statement is used.

### Differences from QB

- FreeBASIC does not generate a run-time error if `expression` is negative or greater than 255.

### See also

- [`Select Case`](procedures-Select-Case)
- [`On...Goto`](On-Goto)
- [`GoSub`](Gosub)
- [`Return (From Gosub)`](Return-From-Gosub)

## Examples

```freebasic
'' Compile with -lang qb

'$lang: "qb"

choice = 3

On choice GoSub labela, labelb, labelc

Print "Good bye."

End

labela:

Print "choice a"

Return

labelb:

Print "choice b"

Return

labelc:

Print "choice c"

Return
```

---

**Category:** [Control Flow Statements](Category-Control-Flow-Statements)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
