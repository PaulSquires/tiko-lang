[Home](Home) › [Control Flow Statements](Category-Control-Flow-Statements) › **Do...Loop**

# Do...Loop

Control flow statement for looping

## Syntax

```freebasic
Do [ { Until | While } condition ]
[ statement block ]
Loop
Do
[ statement block ]
Loop [ { Until | While } condition ]
```

## Description

The `Do` statement executes the statements in the following *`statement block`* until/while the *`condition`*, if any, evaluates to true.

 If `Until` is used, the `Do` statement stops repetition of the *`statement block`* when *`condition`* evaluates to true. The `While` keyword has opposite effect, stopping the loop if *condition* evaluates to false. If both *`condition`* and either `Until` or `While` are omitted, the `Do` statement loops indefinitely.

 If an [`Exit`](Exit) `Do` statement is encountered inside the *`statement block`*, the loop is terminated, and execution resumes immediately following the enclosing `Loop` statement. If a [`Continue`](Continue) `Do` statement is encountered, the rest of the *`statement block`* is skipped and execution resumes at the `Do` statement.

 In the first syntax, the *`condition`* is checked when the `Do` statement is first encountered, and if the *`condition`* is met, the *`statement block`* will be skipped. In the second syntax, *`condition`* is initially checked *after* the *`statement block`* is executed. This means that the *`statement block`* is always guaranteed to execute *at least* once.

 *`condition`* may be any valid expression that evaluates to False (zero) or True (non-zero).

## Remarks

### Dialect Differences

- In the *[-lang qb](Compiler-Option-Lang)* and *[-lang fblite](Compiler-Option-Lang)* dialects, variables declared inside a `Do`..`Loop` block have a function-wide scope as in QB
  In the *[-lang fb](Compiler-Option-Lang)* and *[-lang deprecated](Compiler-Option-Lang)* dialects, variables declared inside a `Do`..`Loop` block are visible only inside the block, and can't be accessed outside it. To access duplicated symbols defined as global outside this block, add one or preferably two dot(s) as prefix: `.SomeSymbol` or preferably `..SomeSymbol` (or only `..SomeSymbol` if inside a [With..End With](With) block).

### Differences from QB

- None

### See also

- [`Continue`](Continue)
- [`Exit`](Exit)
- [`For...Next`](For-Next)
- [`While...Wend (Or 'While...End While')`](While-Wend-or-While-End-While)

## Examples

In this example, a `Do` loop is used to count the total number of odd numbers from 1 to 10. It will repeat `until` its `n > 10` condition is met:

```freebasic
Dim As Integer n = 1                            '' number to check

Dim As Integer total_odd = 0                    '' running total of odd numbers

Do Until( n > 10 )

  If( ( n Mod 2 ) > 0 ) Then total_odd += 1    '' add to total if n is odd (has remainder from division by 2)

  n += 1

Loop

Print "total odd numbers: " ; total_odd         '' prints '5'

End 0
```

 Here, an infinite DO loop is used to count the total number of evens. We place the conditional check inside the loop via an [`If...Then`](If-Then) statement, which exits the loop if and when *`n > 10`* becomes true:

```freebasic
Dim As Integer n = 1                            '' number to check

   Dim As Integer total_even = 0                   '' running total of even numbers

   Do

      If( n > 10 ) Then Exit Do                    '' exit if we've scanned our 10 numbers

      If( ( n Mod 2 ) = 0 ) Then total_even += 1   '' add to total if n is even (no remainder from division by 2)

      n += 1

   Loop

   Print "total even numbers: " ; total_even       '' prints '5'

   End 0
```

---

**Category:** [Control Flow Statements](Category-Control-Flow-Statements)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
