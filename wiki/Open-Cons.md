[Home](Home) › [File I/O Functions](Category-File-I-O-Functions) › **Open Cons**

# Open Cons

Opens the console's standard input (stdin) or output (stdout) streams, using it as if it were file operations.

## Syntax

```freebasic
Open Cons As [#]filenumber
Open Cons For Input As [#]filenumber
Open Cons For Output As [#]filenumber
```

## Parameters

- `filenumber`

## Description

`Open Cons` opens the console's *stdin* or *stdout* streams for reading or writing. A *file number* is bound to the stream, which is used in subsequent file operations, such as [`Input #`](Input). An available *file number* can be retrieved with [`FreeFile`](Freefile).

 The [`Input`](Input-File-Mode) *file mode* opens the *stdin* stream for reading file operations, such as [`Line Input #`](Input), while the [`Output`](Output) *file mode* opens the *stdout* stream for writing file operations, such as [`Print #`](procedures-Print). The [`Output`](Output) *file mode* is the default if not specified.

 The *stdin* and *stdout* streams are the ones used when the calling process' input or output is redirected (piped) by OS commands, or when it is opened with [`Open Pipe`](Open-Pipe).

 To open both the *stdin* and *stdout* streams for file operations, a process must use multiple *file numbers*.

 The normal screen commands, such as [`Color`](Color) and [`Locate`](Locate), do not work in this mode, because they do not accept a file number.  
 The [`Tab`](Tab) keyword, regardless of the given column number, is always interpreted as a simple comma (`,`) (next output will take place at the next 14 column boundary).

 The error code returned by `Open Cons` can be checked using [`Err`](Err) in the next line. The function version of `Open Cons` returns directly the error code as a 32 bit [`Long`](Long).

 **Warning:** Presently, `Open Cons` does not work as described above. Without any *file mode* specifier, a runtime error 1 (illegal function call) occurs. With the [`Input`](Input-File-Mode) *file mode* specifier, the only input mode is well supported. But with the [`Output`](Output) *file mode* specifier, input and output modes are simultaneously supported.

 **Runtime errors:**
 `Open Cons` throws one of the following [runtime errors](Error-Handling):

 *(`1`) Illegal function call*

## Return Value

In the first usage, `Open Cons()` returns a 32 bit [`Long`](Long): a zero (0) on success and a non-zero error code otherwise.

## Remarks

### Usage

`result = Open Cons( [For {Input|Output}[,]] As filenumber )`*(or using the QB-like syntax*,)`Open Cons [For {Input|Output}] As filenumber`

### Differences from QB

- In QB the syntax was `OPEN "CON:" FOR INPUT|OUTPUT AS [#] filenumber`

### See also

- [`Open`](Open)
- [`Open Scrn`](Open-Scrn)
- [`Open Err`](Open-Err)
- [`FreeFile`](Freefile)

## Examples

```freebasic
Dim a As String

Open Cons For Input As #1

Open Cons For Output As #2

Print #2,"Please write something and press ENTER"

Line Input #1,a

Print #2, "You wrote : ";a

Close

Sleep
```

---

**Category:** [File I/O Functions](Category-File-I-O-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
