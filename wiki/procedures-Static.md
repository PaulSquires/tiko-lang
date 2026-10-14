[Home](Home) › [Variable Declarations](Category-Variable-Declarations) › **Static**

# Static

Defines variables, objects and arrays having static storage

## Syntax

```freebasic
Static symbol1 [ (array-dimensions) ] As DataType [ = expression] [, symbol2 [ (array-dimensions) ] As DataType [ = expression], ...]
Static As DataType symbol1 [ (array-dimensions) ] [ = expression] [, symbol2 [ (array-dimensions) ] [ = expression], ...]
Static Var symbol1 = expression [, symbol2 = expression, ...]
Sub|Function procedurename ( parameters ) [[ ByRef ] As DataType] Static
...
End Sub|Function
```

## Parameters

- `symbol`
- `array-dimensions`
- `lower-bound To upper-bound [, ...] or Any [, Any...] or empty. expression`

## Description

Specifies static storage for variables, objects and arrays; they are allocated at program startup and deallocated upon exit. Objects are constructed once when they are defined, and destructed upon program exit.

 When declaring static arrays, only [numeric literals](Literals), [Constants](Const) or [Enumerations](Enum) may be used as subscript range values. Static variable-length arrays must be declared empty (no subscript range list) and resized using [`ReDim`](Redim) before used.

 In both iterative and recursive blocks, like looping [control flow statements](Control-Flow-Statements) or procedures, static variables, objects and arrays local to the block are guaranteed to occupy the same storage across all instantiations of the block. For example, procedures that call themselves - either directly or indirectly - share the same instances of their local static variables.

 A static variable may only be initialised with a constant value: its starting value is set at the start of the program before any code is run, and so it cannot depend on any variables or functions in it.

 When used at procedure definition level (forbidden at declaration line level), `Static` specifies static storage for all local variables, objects and arrays, except temporary types and internal variables (objects not explicitly declared).

 At module-level variable declaration only, the modifier [`Shared`](Shared) may be used with the keyword `Static` to make module-level static variables visible inside procedures.

 When used with in a user-defined type, `Static` creates [Static Member Procedures Or Variables](Static-Member).

## Remarks

### Dialect Differences

- Variables cannot be initialised in the *[-lang qb](Compiler-Option-Lang)* dialect.

### Differences from QB

- QuickBASIC allows variables and arrays to be declared using the `Static` keyword within procedures and `DEF FN` routines only.
  `Static` forces local visibility of variables and arrays in QuickBASIC `DEF FN` routines. FreeBASIC supports neither `DEF FN` routines nor this usage of `Static`.

### See also

- [`Static (Member)`](Static-Member)
- [`Dim`](Dim), [`ReDim`](Redim)
- [`Shared`](Shared)
- [`Byref (Variables)`](Byref-Variables)
- [`Sub (Module)`](Sub), [`Function (Module)`](procedures-Function)
- [`Sub (Member)`](Sub-Member), [`Function (Member)`](Function-Member)
- [`Option Static`](Option-Static)

## Examples

```freebasic
Sub f

    '' times called is initially 0

    Static timesCalled As Integer = 0

    timesCalled += 1

    Print "Number of times called: " & timesCalled

End Sub

'' the static variable in f() retains its value between

'' multiple procedure calls.

f()

f()
```

 Will output:

```freebasic
Number of times called: 1
Number of times called: 2
```

---

**Category:** [Variable Declarations](Category-Variable-Declarations)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
