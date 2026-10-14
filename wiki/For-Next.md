[Home](Home) › [Operators](Category-Operators) › **For...Next**

# For...Next

Control flow statement for looping

## Syntax

```freebasic
For iterator [ As datatype ] = startvalue To endvalue [ Step stepvalue ]
[ statement block ]
Next [ iterator ]
```

## Parameters

- `iterator`
- `datatype`
- `iterator`
- `datatype`
- `startvalue`
- `endvalue`
- `stepvalue`

## Description

A `For...Next` loop initializes `iterator` to `startvalue`, then executes the `statement block`, incrementing `iterator` by `stepvalue` until it exceeds `endvalue`. If `stepvalue` is not explicitly given it will set to `1`.

 The values of `stepvalue` and `endvalue` are stored internally immediately following execution of the `For` statement and thus neither can be changed inside the `For` loop. Comparison operators such as < and > will not be effective as `stepvalue` or `endvalue` because the expressions will not be re-evaluated while the loop is running. (The results of the expressions used to define them may be changed, but these changes will not affect the execution of the `For` loop.) See examples.

 Note: In some dialects, the temporary variables holding `stepvalue` and `endvalue` go out of scope at the end of the loop, and their values are not guaranteed to remain unchanged once any code following the loop has been executed. For this reason, it is recommended never to branch out of a `For...Next` loop (using [`Goto`](Goto) or similar), and then jump back into the middle of it later when in the *[-lang fb](Compiler-Option-Lang)* or *[-lang deprecated](Compiler-Option-Lang)* dialect.

 The iterator must be an intrinsic scalar: only [`Static`](procedures-Static)/[`Shared`](Shared) variables and local variables can be used; no other kind can be used, including array elements, UDT members, [`ByRef`](Byref-Parameters) parameters or any kind of dereferenced address.

 The `iterator` may be defined having the same scope as the `For` statement by using the `As datatype` syntax. With this syntax, `iterator` is created and destroyed within the `For...Next` scope. See dialect differences below.

 If `endvalue` is less than `startvalue` then a negative `stepvalue` must be specified or the `statement block` will not execute at all, since `startvalue` compares greater than `endvalue`.

 The `For` statement causes the execution of the statements in the `statement block` until `iterator` compares **greater than** `endvalue` (or **less than** `endvalue` if `stepvalue < 0`). `iterator` will be incremented the amount of `stepvalue` following each execution of the `statement block`. If an increment is not given, `iterator` will be implicitly incremented by `1`.

 If an [`Exit`](Exit) `For` statement is encountered inside the `statement block`, the loop is terminated, and execution resumes immediately following the enclosing `Next` statement. If a [`Continue`](Continue) `For` statement is encountered, the rest of the `statement block` is skipped until the block's corresponding `Next` statement. The counter's value is incremented and the loop restarted if it is still within the bounds given by `endvalue`.

 **Note**: for integer data types, it is not possible to loop up to the highest possible value (or down to the lowest possible value) that can be stored in the variable type, because the loop only breaks when the incremented variable exceeds `endvalue`, which can never happen. For example, if you try to iterate an variable from `0` to `255`, the loop will only break once the variable reaches `256` or more. Using a [`UByte`](Ubyte) variable for the counter wouldn't work, because although it can hold the numbers `0` to `255`, it cannot hold `256`. See [`Standard Data Type Limits`](Standard-Data-Type-Limits) to find the upper and lower limits for the standard data types.

 Like all control flow statements, the `For` statement can be nested, that is, it can be used in a statement block of another `For` statement.

 `For`, `Next`, and `Step` are operators that can be overloaded inside user defined types. See [`Operator For`](Operator-for-Iteration), [`Operator Next`](Operator-Next-Iteration), [`Operator Step`](Operator-Step-Iteration)

## Remarks

### Dialect Differences

- In the *[-lang fb](Compiler-Option-Lang)* and *[-lang deprecated](Compiler-Option-Lang)* dialects, variables declared inside a `For`..`Next` block are visible only inside the block, and cannot be accessed outside it. To access duplicated symbols defined as global outside this block, add one or preferably two dot(s) as prefix: `.SomeSymbol` or preferably `..SomeSymbol` (or only `..SomeSymbol` if inside a [With..End With](With) block).
  In the *[-lang qb](Compiler-Option-Lang)* and *[-lang fblite](Compiler-Option-Lang)* dialects, variables declared inside a `For`..`Next` block (including the counter if declared, and any temporary variables used to hold `endvalue` or *`stepvalue`*), have a procedure-wide scope as in QB

### Differences from QB

- [`ByRef`](Byref-Parameters) arguments cannot be used as counters.

### See also

- [`Continue`](Continue)
- [`Do...Loop`](Do-Loop)
- [`Exit`](Exit)

## Examples

```freebasic
Print "counting from 3 to 0, with a step of -0.5"

For i As Single = 3 To 0 Step -0.5

    Print "i is " & i

Next i
```

```freebasic
Dim As Integer i, j, k, toTemp, stepTemp

j = 9: k = 1

For i = 0 To j Step k

    j = 0: k = 0 '' Changing j and k has no effect on the current loop.

    Print i;

Next i

Print

' Internally, this is what the above example does:

j = 9: k = 1

i = 0: toTemp = j: stepTemp = k

Do While IIf(stepTemp >= 0, i <= toTemp, i >= toTemp)

    j = 0: k = 0 '' Changing j and k has no effect on the current loop.

    Print i;

    i += stepTemp

Loop

Print
```

 Example of infinite For...Next loop in case of loop up to the highest value of an Ubyte iterator (255):

```freebasic
For ub As UByte = 240 To 255 '' Infinite loop because the end criterion value (255+1=256) can never be reached by the UByte iterator

    Print ub

    If Inkey <> "" Then Exit For

    Sleep 10

Next ub
```

 The same applies to lowest value of an UByte iterator (0) in case of loop down (negative `stepvalue`).

---

**Category:** [Operators](Category-Operators)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
