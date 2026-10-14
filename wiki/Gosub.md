[Home](Home) › [Control Flow Statements](Category-Control-Flow-Statements) › **GoSub**

# GoSub

Control flow statement to use a section of code and return.

## Syntax

```freebasic
GoSub label
```

## Description

Execution jumps to a subroutine marked by a line label. Always use [`Return`](Return-From-Gosub) to exit a `GoSub`, execution will continue on next statement after `GoSub`.

 The line label where `GoSub` jumps must be in the same main/function/sub block as `GoSub`. All the variables in the subroutine are shared with the block, no arguments can be used. For this reason Gosub is considered bad programming practice as it can generate unreadable and untraceable code. It is better to use [`Sub`](Sub) or [`Function`](procedures-Function) instead.

## Remarks

### Dialect Differences

- Only available in the *[-lang qb](Compiler-Option-Lang)* and *[-lang fblite](Compiler-Option-Lang)* dialects.
  `GoSub` support is disabled by default in the *[-lang fblite](Compiler-Option-Lang)* unless the `Option Gosub` statement is used.

### Differences from QB

- None when using the *[-lang qb](Compiler-Option-Lang)* dialect.

### See also

- [`Goto`](Goto)
- [`Return (From Gosub)`](Return-From-Gosub)
- [`Sub`](Sub)
- [`Function`](procedures-Function)

## Examples

```freebasic
'' Compile with -lang qb

'$lang: "qb"

GoSub message

End

message:

Print "Welcome!"

Return
```

---

**Category:** [Control Flow Statements](Category-Control-Flow-Statements)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
