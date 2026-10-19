[Home](Home) › [All Categories](Categories) › **Error Handling Functions**

# Error Handling Functions

<!-- finder:start -->

Grouped by task. [Errors and missing values](Functions-Errors) lists them beside the rest of the area.

## Catch runtime errors in a handler

| Function | What it does | From |
|---|---|---|
| [On Error](On-Error) | Sets a label to jump to when a runtime error happens; On Error Goto 0 turns it off. | built-in |
| [Local](Local) | Marks an On Error handler as belonging to the procedure it is set in. | built-in |

## Find out what went wrong

| Function | What it does | From |
|---|---|---|
| [Err](Err) | Returns the number of the last runtime error, or sets it without jumping. | built-in |
| [Erl](Erl) | Returns the source line of the last runtime error, or 0 if there was none. | built-in |
| [Erfn](Erfn) | Returns a pointer to the name of the failing procedure; null unless built with -exx. | built-in |
| [Ermn](Ermn) | Returns a pointer to the name of the source file where the last error happened. | built-in |

## Raise an error yourself

| Function | What it does | From |
|---|---|---|
| [Error](Error) | Raises a runtime error by number: jumps to the handler, or ends the program. | built-in |

## Also in this category

- [Error Handling Functions](Error-Handling-Functions)

<!-- finder:end -->

---

[Home](Home) · [Keyword Index](Keyword-Index)
