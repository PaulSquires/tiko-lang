[Home](Home) › [Control Flow Statements](Category-Control-Flow-Statements) › **While...Wend (Or 'While...End While')**

# While...Wend (Or 'While...End While')

Control flow statement for looping

## Syntax

```freebasic
While [condition]
[statement block]
Wend '' or End While
```

## Description

The `While` statement will cause the following set of statements in the `statement block` to execute repeatedly if and while the expression *condition* evaluates to true.

 If `condition` evaluates to false when the `While` statement is first executed, then the `statement block` is skipped and execution resumes immediately following the enclosing `Wend` statement.

 If an `Exit While` statement is encountered inside the *statement block*, the loop is terminated, and execution resumes immediately following the enclosing `Wend` statement. If a `Continue While` statement is encountered, the rest of the `statement block` is skipped and execution resumes at the `While` statement.

 Like all control flow statements, the `While` statement can be nested, that is, it can be used in a statement block of another [`While`](While) statement.

 ***note**: the `While`*keyword*is also used in the [`Do...Loop`](Do-Loop) statement to indicate the type of comparison. Used in this way, the `Do` statement becomes functionally equivalent to the `While` statement, so do not confuse their enclosing keywords `Loop` and `Wend`, respectively.*

## Remarks

### Version

- Since fbc 1.20.0: `End While` equivalent to `Wend`

### Dialect Differences

- In the *[-lang qb](Compiler-Option-Lang)* and *[-lang fblite](Compiler-Option-Lang)* dialects, variables declared inside a `While`..`Wend` loop have a function-wide [scope](Variable-Scope) as in QB
  In the *[-lang fb](Compiler-Option-Lang)* and *[-lang deprecated](Compiler-Option-Lang)* dialects, variables declared inside a `While`..`Wend` block are visible only inside the block, and can't be accessed outside it. To access duplicated symbols defined as global outside this block, add one or preferably two dot(s) as prefix: `.SomeSymbol` or preferably `..SomeSymbol` (or only `..SomeSymbol` if inside a [With..End With](With) block).

### Differences from QB

- None, except for the `End While` syntax (equivalent to `Wend`) specific to FreeBASIC.

### See also

- [`Exit`](Exit)
- [`Continue`](Continue)
- [`Do...Loop`](Do-Loop)

## Examples

In this example, a `While` loop is used to reverse a string by iterating through it backward. The loop stops if index is less than `0` *(`0` being the first index in the string)*.

```freebasic
Dim As String sentence                          '' string to reverse

sentence = "The quick brown fox jumps over the lazy dog."

Dim As String ecnetnes

Dim As Integer index

index = Len( sentence ) - 1                     '' point to last character

While( index >= 0 )                             '' stop after first character

  ecnetnes += Chr( sentence[index] )           '' append character to new string

  index -= 1

Wend

Print "original: """ ; sentence ; """"

Print "reversed: """ ; ecnetnes ; """"

End 0
```

---

**Category:** [Control Flow Statements](Category-Control-Flow-Statements)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
