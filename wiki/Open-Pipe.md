[Home](Home) › [File I/O Functions](Category-File-I-O-Functions) › **Open Pipe**

# Open Pipe

Runs a shell command and opens its input or output on a file number.

## Syntax

```freebasic
Open Pipe shell_command For Input As [#]filenumber
Open Pipe shell_command For Output As [#]filenumber
Open Pipe shell_command For Binary access_type [#]filenumber
```

## Parameters

- `shell_command`
- `access_type`
- `filenumber`

## Description

`Open Pipe` executes another process in the command shell and opens either its *stdin* or *stdout* streams for reading or writing. A *file number* is bound to the stream, which is used in subsequent file operations, such as [`Input #`](Input). An available `filenumber` can be retrieved with [`FreeFile`](Freefile). If the external process does not exist, a runtime error is thrown.

 The [`Input`](Input-File-Mode) and [`Output`](Output) *file modes* open the external process' *stdin* and *stdout* streams, respectively, for sequential text I/O, useful for reading or writing plain text. Characters, words or whole lines can then be read or written using text-mode file operations, such as [`Line Input #`](procedures-Line-Input) and [`Print #`](procedures-Print).

 The [`Binary`](Binary) *file mode* opens the external process' *stdin* or *stdout* streams - depending on the *access type* specified (see description of the `access_type` parameter above) - for random-access reading or writing of arbitrarily sized and interpreted raw data. Simple data type values, like [`Byte`](Byte) and [`LongInt`](Longint), and whole chunks of memory can be read from or written to the streams with binary-mode file operations like [`Get #`](Get-File-I-O) and [`Put #`](Put-File-I-O).  
 Bidirectional pipes are not supported by FB and must be implemented using the OS' API functions.

 The error code returned by `Open Pipe` can be checked using [`Err`](Err) in the next line. The function version of `Open Pipe` returns directly the error code as a 32 bit [`Long`](Long).

 **Runtime errors:**
 `Open Pipe` throws one of the following [runtime errors](Error-Handling):

 *(`1`) Illegal function call*

## Return Value

In the first usage, `Open Pipe()` returns a 32 bit [`Long`](Long): a zero (`0`) on success and a non-zero error code otherwise.

## Remarks

### Usage

`result = Open Pipe( command[,] For {Input|Output}[,] As filenumber )`*or,*`result = Open Pipe( command[,] For Binary[,] access_type[,] As filenumber )`*(or in the QB-like syntax,)*`Open Pipe filename For {Input|Output} As filenumber`*(or,)*`Open Pipe filename For Binary access_type As filenumber`

### Platform Differences

- The [`Binary`](Binary) *file mode* is not supported on all platforms; `Open Pipe` will throw an error if it is unable to open the external process' *stdin* or *stdout* streams in binary mode.

### Differences from QB

- New to FreeBASIC

### See also

- [`Shell`](Shell)
- [`Open`](Open)
- [`Open Cons`](Open-Cons)
- [`Open Err`](Open-Err)
- [`FreeFile`](Freefile)

## Examples

```freebasic
'' This example uses Open Pipe to run a shell command and retrieve its output.

#ifdef __FB_UNIX__

Const TEST_COMMAND = "ls *"

#else

Const TEST_COMMAND = "dir *.*"

#endif

Open Pipe TEST_COMMAND For Input As #1

Dim As String ln

Do Until EOF(1)

    Line Input #1, ln

    Print ln

Loop

Close #1
```

---

**Category:** [File I/O Functions](Category-File-I-O-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
