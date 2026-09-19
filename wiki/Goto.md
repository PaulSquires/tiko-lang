[Home](Home) › [Control Flow Statements](Category-Control-Flow-Statements) › **Goto**

# Goto

Control flow statement to jump to another part of the program

## Syntax

```freebasic
Goto label
```

## Description

Jumps code execution to a line label.

 When using `Goto label` to exit a scope, any local variables defined in that scope are destroyed (destructors are called).

 Usage of `Goto label` may be disallowed when it skips a variable definition but not the end of the variable's scope. If the variable requires construction, a compiler error is shown. For other variables, a compiler warning is shown. This is intended to prevent potential accesses to uninitialized variables, and ensures that automatic destruction never happens to an uninitialized variable.

 For better source code readability, overuse of `Goto` should be avoided in favor of more modern structures such as [`Do...Loop`](Do-Loop), [`For...Next`](For-Next), [`Sub`](Sub), and [`Function`](procedures-Function).

## Remarks

### Dialect Differences

- Line numbers are allowed only in the *[-lang qb](Compiler-Option-Lang)* and *[-lang deprecated](Compiler-Option-Lang)* dialects.
  In the *[-lang qb](Compiler-Option-Lang)* and *[-lang fblite](Compiler-Option-Lang)* dialects, `Goto label` is allowed to skip any variable definitions, because nested scopes are not supported and all variable definitions are moved to the top of their procedure.

### Differences from QB

- None

### See also

- [`GoSub`](Gosub)
- [`Sub`](Sub)
- [`Function`](procedures-Function)
- [`Labels`](Labels)

## Examples

```freebasic
Goto there

backagain:

    End

there:

    Print "Welcome!"

    Goto backagain
```

```freebasic
'' Compile with -lang qb or fblite

'$lang: "qb"

1 Goto 3

2 End

3 Print "Welcome!"

4 Goto 2
```

---

**Category:** [Control Flow Statements](Category-Control-Flow-Statements)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
