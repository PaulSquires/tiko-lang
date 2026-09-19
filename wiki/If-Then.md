[Home](Home) › [Control Flow Statements](Category-Control-Flow-Statements) › **If...Then**

# If...Then

Control flow statement for conditional branching

## Syntax

```freebasic
If expression Then [statement(s)] [Else [statement(s)]] [End If]
If expression Then : [statement(s)] [Else [statement(s)]] : End If
If expression Then
[statement(s)]
[ ElseIf expression Then ]
[statement(s)]
[ Else ]
[statement(s)]
```

## Description

`If...Then` is a way to make decisions.  
 It is a mechanism to execute code only if a condition is true, and can provide alternative code to execute based on more conditions:

`expression` can be one of several forms:

`x = 5`

`x >= 5 And x <= 10`

`y <> 0 AndAlso x \ y = 1`  
 (in this case, "`x \ y = 1`" will only be evaluated if "`y <> 0`" is True)

Both multi-line and single-line `If`s can be nested. In the latter case, the optional `End If`s can be useful to control where nested `If`s begin and end.

 The multi-line syntax allows several `Elseifs` (but none after a `Else`) and tests can be nested (there must be in this case as many `End Ifs` as `Ifs`).  
 If the condition of the `If` is not true, those of `Elseifs` blocks are tested in succession:

In the *[-lang fb](Compiler-Option-Lang)* and *[-lang fblite](Compiler-Option-Lang)* dialects, colons (`:`) can be used instead of newlines to construct multi-line `If` blocks on a single line.

 **Note:** The single-line syntax `If...Goto`, as shortcut for `If...Then Goto`, is deprecated and it only exists for compatibility with QB.

## Remarks

### Dialect Differences

- In the *[-lang qb](Compiler-Option-Lang)* and *[-lang fblite](Compiler-Option-Lang)* dialects, variables declared inside an `If`..`Then` block have a procedure-wide [scope](Variable-Scope) as in QB
  In the *[-lang fb](Compiler-Option-Lang)* and *[-lang deprecated](Compiler-Option-Lang)* dialects, variables declared inside an `If`..`Then` block are visible only inside the block, and cannot be accessed outside it. To access duplicated symbols defined as global outside this block, add one or preferably two dot(s) as prefix: `.SomeSymbol` or preferably `..SomeSymbol` (or only `..SomeSymbol` if inside a [With..End With](With) block).  
  In the *[-lang qb](Compiler-Option-Lang)* dialect, if there is a new line or a single-line comment (`'`) directly after THEN, then the IF will be multi-line. A colon, a [`Rem`](Rem) or any other statement will result in a single-line IF.  
  In the *[-lang fb](Compiler-Option-Lang)* and *[-lang fblite](Compiler-Option-Lang)* dialects, if there is a new line, a single-line comment (`'`), a colon (`:`), or a [`Rem`](Rem) statement directly after THEN, then the IF will be multi-line. Any other statement will result in a single-line IF.

### Differences from QB

- END IF was not supported in single-line IFs in QBASIC.

### See also

- [`ElseIf`](Elseif)
- [`Do...Loop`](Do-Loop)
- [`#if`](If)
- [`Select Case`](procedures-Select-Case)

## Examples

```freebasic
'' Here is a simple "compute the square root" code using a single-line if...then for the decision,

'' but with multiple statements extended with colons (:)

Dim As Double d , r

r = -1

d = 2

'd = -3

If d > 0 Then r = Sqr(d) : Print "square root computed:" Else r = 0 : Print "square root not computed:"

Print r

Sleep
```

```freebasic
'' Here is a simple "guess the number" game using a multi-line if...then for a decision.

Dim As Integer num, guess

Randomize

num = Int(Rnd * 10) + 1 'Create a random number between 1 and 10...

Print "guess the number between 1 and 10 (or CTRL-C to abort)"

Do 'Start a loop

    Input "Guess"; guess 'Input a number from the user

    If guess > 10 OrElse guess < 1 Then  'The user's guess is out of range

        Print "The number can't be greater then 10 or less than 1!"

    ElseIf guess > num Then  'The user's guess is too high

        Print "Too high"

    ElseIf guess < num Then  'The user's guess is too low

        Print "Too low"

    Else                     'The user guessed the right number!

        Print "Correct!"

        Exit Do   'Exit the loop

    End If

Loop 'Go back to the start of the loop

Sleep
```

---

**Category:** [Control Flow Statements](Category-Control-Flow-Statements)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
