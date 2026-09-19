[Home](Home) › [Control Flow Statements](Category-Control-Flow-Statements) › **Select Case**

# Select Case

Conditional statement block

## Syntax

```freebasic
Select Case expression
[ Case expressionlist]
[statements]
[ Case Else ]
[statements]
End Select
Select Case As Const integer_expression
[ Case constant | enumeration ]
```

## Description

`Select Case` executes specific code depending on the value of an expression. The expression is evaluated once, and compared against each `Case`, in order, until a matching expression is found. The code inside the matching Case branch is executed, and the program skips down to the end of the `Select Case` block. `Case Else` matches any case not already matched, so if there is a `Case Else`, at least one `Case` is guaranteed to be executed. If no `Case`s match, the whole `Select Case` block will be skipped.  
 `End Select` is used to close the `Select Case...End Select` block.

 `Exit Select` can be used to escape the `Select Case` block, preventing further code in the `Case` block from being executed.

 Note for C users: In FreeBASIC, `Select Case` works like a `switch` block where all cases have a `break` at the end. As there is no fall-through, multiple options must be put in an expression list in a single `Case`.

 Besides integer types, floating point and string expressions are also supported with the first syntax.

 Syntax of an expression list:  
 `{ expression | expression To expression | Is relational operator expression }[, ...]`

- `expr`: evaluates `expr`, and compares for equality with the original expression. If they are equal, then a match has been found. This could be considered as a shorthand for "`Is = expr`" (see below).
  `expr1 To expr2`: evaluates `expr1` and checks to see if it is less than or equal to the original expression. If so, it evaluates `expr2`, and checks to see if it is greater than or equal to the original expression. If so, then a match has been found.  
  `Is relational_operator expr`: evaluates `expr`, and compares the original operation against it, using the supplied `relational_operator` (`=`, `>`, `<`, `<>`, `<=`, `>=`). If the comparison is true, then a match has been found.

Multiple checks can be made in each `Case`, by separating them by a comma (`,`). Once a match is found, the program finishes its checks, and goes on to execute the code statements for that `Case` block. No further expressions are evaluated or checked.

 example of expression lists:

| Case 1 | constant |
| --- | --- |
| Case 5.4 To 10.1 | range |
| Case Is > 3 | bigger than-smaller than |
| Case 1, 3, 5, 7 to 9 | match against a set of values |
| Case x | value of a variable |

 If `As Const` is used, only integer constants (all numeric constants excluding the two floating-point constants: single and double) can be evaluated and the expression list supports simple constants and enumerations only. "`To`" ranges are supported, but "`Is`" relational operators are not.

 With `As Const`, a jump table is created to contain the full range of integer `Case`s handled. This allows `Select Case As Const` to be faster than `Select Case`.  
 However, the size of the range of values is limited, and after converting the values to the uinteger type, the largest value in the range may be no higher than the smallest value + 8191 (current implementation).

 **Note:** No statement can be placed between the `Select Case` statement and the first `Case` statement.

## Remarks

### Differences from QB

- `Select Case As Const` did not exist in QB.
  in an "`expr1 TO expr2`" case, QB would always evaluate both expressions, even if `expr1` was higher than the original expression.  
  In the *[-lang qb](Compiler-Option-Lang)* and *[-lang fblite](Compiler-Option-Lang)* dialects, variables declared inside a `Select`..`End Select` block have a function-wide [scope](Variable-Scope) as in QB.  
  In the *[-lang fb](Compiler-Option-Lang)* and *[-lang deprecated](Compiler-Option-Lang)* dialects, variables declared inside a `Select`..`End Select` block are visible only inside the block, and can't be accessed outside it. To access duplicated symbols defined as global outside this block, add one or preferably two dot(s) as prefix: `.SomeSymbol` or preferably `..SomeSymbol` (or only `..SomeSymbol` if inside a [With..End With](With) block).

### See also

- [`If...Then`](If-Then)

## Examples

```freebasic
Dim choice As Integer

Input "Choose a number between 1 and 10: "; choice

Select Case As Const choice

Case 1

    Print "number is 1"

Case 2

    Print "number is 2"

Case 3, 4

    Print "number is 3 or 4"

Case 5 To 10

    Print "number is in the range of 5 to 10"

Case Else

    Print "number is outside the 1-10 range"

End Select
```

```freebasic
'' SELECT CASE vs. SELECT CASE AS CONST speed test

Const N = 50000000

Dim As Integer dummy = 0

Dim As Double t = Timer()

For i As Integer = 1 To N

    Select Case i

    Case 1, 3, 5, 7, 9

        dummy += 1

    Case 2, 4, 6, 8, 10

        dummy += 1

    Case 11 To 20

        dummy += 1

    Case 21 To 30

        dummy += 1

    Case 31

        dummy += 1

    Case 32

        dummy += 1

    Case 33

        dummy += 1

    Case Is >= 34

        dummy += 1

    Case Else

        Print "can't happen"

    End Select

Next

Print Using "SELECT CASE: ##.### seconds"; Timer() - t

t = Timer()

For i As Integer = 1 To N

    Select Case As Const i

    Case 1, 3, 5, 7, 9

        dummy += 1

    Case 2, 4, 6, 8, 10

        dummy += 1

    Case 11 To 20

        dummy += 1

    Case 21 To 30

        dummy += 1

    Case 31

        dummy += 1

    Case 32

        dummy += 1

    Case 33

        dummy += 1

    Case Else

        If( i >= 34 ) Then

            dummy += 1

        Else

            Print "can't happen"

        End If

    End Select

Next

Print Using "SELECT CASE AS CONST: ##.### seconds"; Timer() - t

Sleep
```

---

**Category:** [Control Flow Statements](Category-Control-Flow-Statements)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
