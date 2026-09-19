[Home](Home) › [Miscellaneous Keywords](Category-Miscellaneous-Keywords) › **End (Block)**

# End (Block)

Indicates the end of a compound statement block.

## Syntax

```freebasic
End { Sub | Function | If | While | Select | Type | Enum | Scope | With | Namespace | Extern | Constructor | Destructor | Operator | Property }
```

## Description

Used to indicate the end of the most recent code block.

 The type of the block must be included in the command: one of [`Sub`](Sub), [`Function`](procedures-Function), [`If`](If-Then), [`While`](While-Wend-or-While-End-While), [`Select`](procedures-Select-Case), [`Type`](Type-Udt), [`Enum`](Enum), [`Scope`](Scope-End-Scope), [`With`](With), [`Namespace`](Namespace), [`Extern`](Extern-End-Extern), [`Constructor`](Constructor), [`Destructor`](Destructor), [`Operator`](Operator), or [`Property`](Property).

 Ending a [`Sub`](Sub), [`Function`](procedures-Function), [`If`](If-Then), [`While`](While-Wend-or-While-End-While), [`Select`](procedures-Select-Case), [`Scope`](Scope-End-Scope), [`Constructor`](Constructor), [`Destructor`](Destructor), [`Operator`](Operator), or [`Property`](Property) block also closes the scope for variables defined inside that block. When the scope is closed, variables defined inside the scope are destroyed, calling their destructors as needed.

 To end a program, see [`End (Statement)`](End-Statement).

## Remarks

### Version

- Since fbc 1.20.0: `End While` equivalent to `Wend`

### Differences from QB

- none, except for the `End While` syntax (equivalent to `Wend`) specific to FreeBASIC.

### See also

- [`Constructor`](Constructor)
- [`Destructor`](Destructor)
- [`End (Statement)`](End-Statement)
- [`Enum`](Enum)
- [`Extern`](Extern-End-Extern)
- [`Function`](procedures-Function)
- [`If...Then`](If-Then)
- [`While...Wend (Or 'While...End While')`](While-Wend-or-While-End-While)
- [`Namespace`](Namespace)
- [`Operator`](Operator)
- [`Property`](Property)
- [`Scope`](Scope-End-Scope)
- [`Select Case`](procedures-Select-Case)
- [`Sub`](Sub)
- [`Type`](Type-Udt)
- [`With`](With)

## Examples

```freebasic
Declare Sub checkvalue( n As Integer )

Dim variable As Integer

Input "Give me a number: ", variable

If variable = 1 Then

Print "You gave me a 1"

Else

Print "You gave me a big number!"

End If

checkvalue(variable)

Sub checkvalue( n As Integer )

Print "Value is: " & n

End Sub
```

---

**Category:** [Miscellaneous Keywords](Category-Miscellaneous-Keywords)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
