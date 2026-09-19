[Home](Home) › [Control Flow Statements](Category-Control-Flow-Statements) › **Continue**

# Continue

Control flow statement to continue next iteration of a loop

## Syntax

```freebasic
Continue {Do | For | While}
```

## Description

Skips all code until the end clause of a loop structure, i.e. [`Do...Loop`](Do-Loop), [`For...Next`](For-Next), or a [`While...Wend`](While-Wend-or-While-End-While) block, then executes the limit condition check. In the case of a [`For...Next`](For-Next), the variable is incremented according to the [`Step`](Step) specified.

 Where there are multiple [`Do`](Do-Loop) / [`For`](For-Next) / [`While`](While-Wend-or-While-End-While) blocks nested, it will continue on the innermost block of that type, i.e. the last one entered. You can continue an earlier block of that type by giving the word multiple times, separated by commas. e.g. `continue while, while`

## Remarks

### Dialect Differences

- Not available in the *[-lang qb](Compiler-Option-Lang)* dialect unless referenced with the alias `__Continue`.

### Differences from QB

- New to FreeBASIC

### See also

- [`Exit`](Exit)

## Examples

```freebasic
Dim As Integer n

Print "Here are odd numbers between 0 and 10!"

Print

For n = 0 To 10

  If ( n Mod 2 ) = 0 Then

    Continue For

  End If

  Print n

Next n
```

```freebasic
'' simple prime number finder

Print "Here are the prime numbers between 1 and 20!"

Print

Dim n As Integer, d As Integer

For n = 2 To 20

    For d = 2 To Int(Sqr(n))

        If ( n Mod d ) = 0 Then ' d divides n

            Continue For, For ' n is not prime, so try next n

        End If

    Next d

    Print n

Next n
```

---

**Category:** [Control Flow Statements](Category-Control-Flow-Statements)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
