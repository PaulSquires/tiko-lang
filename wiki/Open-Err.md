[Home](Home) › [File I/O Functions](Category-File-I-O-Functions) › **Open Err**

# Open Err

Opens both the standard input (stdin) and standard error (stderr) streams, using it as if it were file operations.

## Syntax

```freebasic
Open Err [for mode] As [#]filenumber As Long
```

## Parameters

- `mode`
- `filenumber`

## Description

This command opens `stdin` to read from and `stderr` to write to the console allowing read and write operations with normal file commands.

 `stderr` is an output stream different from `stdout` allowing error messages to be redirected separately from the main console output.

 The normal console commands, such as [`Color`](Color) and [`Locate`](Locate), do not work in this mode, because they do not accept a file number.  
 The [`Tab`](Tab) keyword, regardless of the given column number, is always interpreted as a simple comma (`,`) (next output will take place at the next 14 column boundary).

 The `[For Input|Output]` `mode` is allowed for compatibility, but is ignored.

 The error code returned by `Open Err` can be checked using [`Err`](Err) in the next line. The function version of `Open Err` returns directly the error code as a 32 bit [`Long`](Long).

 **Runtime errors:**
 `Open Err` throws one of the following [runtime errors](Error-Handling):

 *(`1`) Illegal function call*

## Return Value

A 32 bit [`Long`](Long): a zero is returned if `Open Err()` completed successfully, otherwise a non-zero value is returned to indicate failure.

## Remarks

### Usage

```freebasic
Open Err [for mode] as [#]filenumber

or

result = Open Err( [for mode[,]] as [#]filenumber )
```

### Differences from QB

- New to FreeBASIC

### See also

- [`Open`](Open)

## Examples

```freebasic
Dim a As String

Open Err For Input  As #1

Print #1,"Please write something and press ENTER"

Line Input #1, a

Print #1, "You wrote"; a

Close

Sleep
```

---

**Category:** [File I/O Functions](Category-File-I-O-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
