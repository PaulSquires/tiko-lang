[Home](Home) › [Miscellaneous Keywords](Category-Miscellaneous-Keywords) › **Data**

# Data

Statement to store data at compile time.

## Syntax

```freebasic
Data constant_expression1 [,constant_expression2]...
```

## Description

`Data` stores a list of constant numeric or alphabetical expressions that are evaluated at compile time (except with *[-lang qb](Compiler-Option-Lang)*) and stored as constants that can be read into variables by using [`Read`](Read).

 All the `Data` statements in the program behave as a single chained list; after the last element of one `Data` statement is read, the first element of the following `Data` statement will be read.  
 The program should not attempt to [`Read`](Read) after the last `Data` element. The results are (in all dialects) undefined, and the program may crash (Page Fault).

 `Data` statements are only visible from within the module in which they are defined; they must be only entered in module-level code.

 `Data` constants can only be of simple types (numeric or string). A numeric value can be read as a numeric literal into a string. A string read into a numeric variable will be evaluated by the [`Val`](Val) function. [`Const`](Const)s can be used as items of data except in the *[-lang qb](Compiler-Option-Lang)* dialect, where their names are considered as normal text.

 The "`Restore label`" statement makes the first `Data` item after the `label` the next item to be read, allowing the user to choose specific sections of data to read.

 `Data` is normally used to initialize variables. FreeBASIC also allows the initialization of static variables when they are [`Dim`](Dim)ensioned - see Variable Initializers for more information.

## Remarks

### Dialect Differences

- *[-lang fb](Compiler-Option-Lang)* and *[-lang fblite](Compiler-Option-Lang)* considers data items as constant expressions that are evaluated during compilation and its result stored in the program.
  *[-lang qb](Compiler-Option-Lang)* considers unquoted words, including names of variables and constants, as literal strings, and stores them without change, as in QBASIC. Unquoted strings are delimited by commas, and a colon or a line-break signifies the end of the `Data` statement. Unquoted strings are trimmed of whitespace at the beginning and end.

### Differences from QB

- Outside of the *[-lang qb](Compiler-Option-Lang)* dialect, alphabetic string literals must be enclosed within quotation marks, in QBASIC this was optional.
  In QBASIC empty items evaluated to number `0` or to empty strings, in FreeBASIC they give a compile error. In QBASIC a comma at the end of the statement made an additional, empty item, evaluated to `0` or an empty string. In FreeBASIC they give a compile error.

### See also

- [`Read`](Read)
- [`Restore`](Restore)

## Examples

```freebasic
' Create an array of 5 integers and a string to hold the data.

Dim As Integer h(4)

Dim As String hs

Dim As Integer readindex

' Set up to loop 5 times (for 5 numbers... check the data)

For readindex = 0 To 4

  ' Read in an integer.

  Read h(readindex)

  ' Display it.

  Print "Number" ; readindex ; " = " ; h(readindex)

Next readindex

' Spacer.

Print

' Read in a string.

Read hs

' Print it.

Print  "String = " + hs

' Await a keypress.

Sleep

' Exit program.

End

' Block of data.

Data 3, 234, 435/4, 23+433, 87643, "Good" + "Bye!"
```

---

**Category:** [Miscellaneous Keywords](Category-Miscellaneous-Keywords)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
