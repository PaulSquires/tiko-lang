[Home](Home) › [Miscellaneous Keywords](Category-Miscellaneous-Keywords) › **Read**

# Read

Reads values stored with the Data statement.

## Syntax

```freebasic
Read variable_list
```

## Description

Reads data stored in the application with the [`Data`](Data) command.

 The elements of the `variable_list` must be of basic types, numeric, strings or elements of arrays and user defined types.

 All the [`Data`](Data) statements in the program behave as a single list, after the last element of one [`Data`](Data) statement is read, the first element of the following [`Data`](Data) statement will be read.  
 The program should not attempt to [`Read`](Read) after the last `Data` element. The results are (in all dialects) undefined, and the program may crash (Page Fault).

 Data constants can only be of simple types (numeric or string). A string read into a numeric variable will be evaluated by the [`Val`](Val) function.

 The "`Restore label`" statement makes the first [`Data`](Data) item after `label` the next item to be read, allowing the user to choose specific sections of data to be read.

## Remarks

### Dialect Differences

- None in syntax and usage of `Read`
- See the [`Data`](Data) page for more information on differences in storing the data

### Differences from QB

- None in syntax and usage of `Read`
- See the [`Data`](Data) page for more information on differences in storing the data

### See also

- [`Data`](Data)
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

Data 3, 234, 4354, 23433, 87643, "Bye!"
```

---

**Category:** [Miscellaneous Keywords](Category-Miscellaneous-Keywords)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
