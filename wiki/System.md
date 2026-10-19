[Home](Home) › [Operating System Functions](Category-Operating-System-Functions) › **System**

# System

Closes all open files and ends the program, with an optional exit code.

## Syntax

```freebasic
Declare Sub System ( ByVal retval As Long = 0 )
```

## Parameters

- `retval`

## Description

Closes all open files, exits the program, and returns to the operating system. An optional return value, an integer, can be specified to return an error code to the system. If no return value is given, a value of 0 is automatically returned. This is the same as [`End (Statement)`](End-Statement) and is here for compatibility between older BASIC dialects. It is recommended to use [`End (Statement)`](End-Statement) instead.

 Usage of this statement does not cleanly close scope. Local variables will not have their destructors called automatically, because FreeBASIC does not do stack unwinding. Only the destructors of global variables will be called in this case.

 For this reason, it is discouraged to use `System` simply to mark the end of a program; the program will come to an end automatically, and in a cleaner fashion, when the last line of module-level code has executed.

## Remarks

### Usage

`System( [ retval ] )`

### Differences from QB

- None

### See also

- [`End (Statement)`](End-Statement)

## Examples

```freebasic
Print "this text is shown"

System

Print "this text will never be shown"
```

---

**Category:** [Operating System Functions](Category-Operating-System-Functions)  
**Kind:** sub

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
