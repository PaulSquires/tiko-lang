[Home](Home) › [Operating System Functions](Category-Operating-System-Functions) › **Environ**

# Environ

Returns the value of a system environment variable

## Syntax

```freebasic
Declare Function Environ ( ByRef varname As Const String ) As String
```

## Parameters

- `varname`

## Description

`Environ` returns the text value of a system environment variable.

## Return Value

Returns the text value of the environmental variable, or the empty string (`"``"`) if the variable does not exist.

## Remarks

### Usage

`result = Environ[$]( varname )`

### Differences from QB

- The `QB ENVIRON` statement is now called [`SetEnviron`](Setenviron).
  The string type suffix "$" is required in the *[-lang qb](Compiler-Option-Lang)* dialect.  
  The string type suffix "$" is optional in the *[-lang fblite](Compiler-Option-Lang)* dialect.  
  The string type suffix "$" is ignored in the *[-lang fb](Compiler-Option-Lang)* dialect, warn only with the *[-w suffix](Compiler-Option-W)* compile option (or *[-w pedantic](Compiler-Option-W)* compile option).

### See also

- [`SetEnviron`](Setenviron)
- [`Shell`](Shell)

## Examples

```freebasic
'e.g. to show the system variable "path":

Print Environ("path")
```

---

**Category:** [Operating System Functions](Category-Operating-System-Functions)  
**Kind:** function

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
