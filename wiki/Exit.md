[Home](Home) › [Control Flow Statements](Category-Control-Flow-Statements) › **Exit**

# Exit

Control flow statement to exit a compound statement block

## Syntax

```freebasic
Exit {Do | For | While | Select }
Exit {Sub | Function | Operator | Constructor | Destructor | Property }
Exit {Do [, Do [ , ...] ] |
For [, For [ , ...] ] |
While [, While, [...] ] |
Select [, Select [ , ...] ] }
```

## Description

Leaves a code block such as a [`Sub`](Sub), [`Function`](procedures-Function), [`Operator`](Operator), [`Constructor`](Constructor), [`Destructor`](Destructor), [`Property`](Property), [`Do...Loop`](Do-Loop), [`For...Next`](For-Next), [`While...Wend`](While-Wend-or-While-End-While), or a [`Select Case`](procedures-Select-Case) block. The execution skips the rest of the block and goes to the line after its end.

 Where there are multiple [`Do`](Do-Loop) / [`For`](For-Next) / [`While`](While-Wend-or-While-End-While) / [`Select`](procedures-Select-Case) blocks nested, it will skip to the end of the innermost block of that type. You can skip to the end of multiple blocks of that type by giving the word multiple times, separated by commas.  
 For example: `Exit While, While`

## Remarks

### Differences from QB

- EXIT OPERATOR, EXIT CONSTRUCTOR, EXIT DESTRUCTOR, EXIT PROPERTY, EXIT WHILE and EXIT SELECT are new to FreeBASIC.

### See also

- [`Sub`](Sub)
- [`Function`](procedures-Function)
- [`Do...Loop`](Do-Loop)
- [`For...Next`](For-Next)
- [`While...Wend (Or 'While...End While')`](While-Wend-or-While-End-While)
- [`Continue`](Continue)

## Examples

```freebasic
'e.g. the print command will not be seen

Do

    Exit Do ' Exit the Do...Loop and continues to run the code after Loop

    Print "I will never be shown"

Loop
```

```freebasic
Dim As Integer i, j

For i = 1 To 10

    For j = 1 To 10

        Exit For, For

    Next j

    Print "I will never be shown"

Next i
```

---

**Category:** [Control Flow Statements](Category-Control-Flow-Statements)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
