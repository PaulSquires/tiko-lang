[Home](Home) › [Miscellaneous Keywords](Category-Miscellaneous-Keywords) › **Restore**

# Restore

Changes the next read location for values stored with the Data statement.

## Syntax

```freebasic
Restore [label]
```

## Description

Sets the next-data-to-read pointer to the first element of the first [`Data`](Data) statement after the label. The label must be contained in the same module as the currently-executing code. `Restore` alters the normal top to bottom order in which `Data` are [`Read`](Read). It allows re-reading some `Data` or using multiple sets of `Data` in a single module.  
 If label is omitted, the next-data-to-read pointer is set to the first `Data` statement found in the module.

## Remarks

### Differences from QB

- None

### See also

- [`Data`](Data)
- [`Read`](Read)

## Examples

```freebasic
' Create an 2 arrays of integers and a 2 strings to hold the data.

Dim h(4) As Integer

Dim h2(4) As Integer

Dim hs As String

Dim hs2 As String

Dim read_data1 As Integer

Dim read_data2 As Integer

' Set the data read to the label 'dat2:'

Restore dat2

' Set up to loop 5 times (for 5 numbers... check the data)

For read_data1 = 0 To 4

  ' Read in an integer.

  Read h(read_data1)

  ' Display it.

  Print "Bloc 1, number"; read_data1;" = "; h(read_data1)

Next

' Spacer.

Print

' Read in a string.

Read hs

' Print it.

Print  "Bloc 1 string = " + hs

' Spacers.

Print

Print

' Set the data read to the label 'dat1:'

Restore dat1

' Set up to loop 5 times (for 5 numbers... check the data)

For read_data2 = 0 To 4

  ' Read in an integer.

  Read h2(read_data2)

  ' Display it.

  Print "Bloc 2, number"; read_data2;" = "; h2(read_data2)

Next

' Spacer.

Print

' Read in a string.

Read hs2

' Print it.

Print  "Bloc 2 string = " + hs2

' Await a keypress.

Sleep

' Exit program.

End

' First block of data.

dat1:

Data 3, 234, 4354, 23433, 87643, "Bye!"

' Second block of data.

dat2:

Data 546, 7894, 4589, 64657, 34554, "Hi!"
```

---

**Category:** [Miscellaneous Keywords](Category-Miscellaneous-Keywords)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
