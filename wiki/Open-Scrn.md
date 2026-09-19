[Home](Home) › [File I/O Functions](Category-File-I-O-Functions) › **Open Scrn**

# Open Scrn

Opens the screen directly for input and output, using it as if it were file operations.

## Syntax

```freebasic
Open Scrn [for mode] As [#]filenumber As Long
```

## Parameters

- `mode`
- `filenumber`

## Description

This command opens the screen (in text or graphics screen mode) for both input and output as a file, allowing to read/write from/to it with normal file commands.

 This command may use direct access to the screen for speed in some implementations, so it should not be used when the input / output is required to be redirected or piped with OS commands.

 The normal screen commands, such as [`Color`](Color) and [`Locate`](Locate), do not work in this mode, because they do not accept a file number.

 The `[For Input|Output]` clause is allowed for compatibility, but is ignored.

 `filenumber` is an unused file number.

 An unused file number can be found using [`FreeFile`](Freefile).

 The error code returned by `Open Scrn` can be checked using [`Err`](Err) in the next line. The function version of `Open Scrn` returns directly the error code as a 32 bit [`Long`](Long).

 **Runtime errors:**
 `Open Scrn` throws one of the following [runtime errors](Error-Handling):

 *(`1`) Illegal function call*

## Return Value

A 32 bit [`Long`](Long): a zero (`0`) is returned if `Open Scrn()` completed successfully, otherwise a non-zero value is returned to indicate failure.

## Remarks

### Usage

```freebasic
Open Scrn [for mode] as [#]filenumber

or

result = Open Scrn( [for mode[,]] as [#]filenumber )
```

### Differences from QB

- QB used OPEN "SCRN:" ...

### See also

- [`Open`](Open)
- [`Open Cons`](Open-Cons)

## Examples

```freebasic
Dim a As String

Open Scrn For Input  As #1

Print #1,"Please write something and press ENTER"

Line Input #1,a

Print #1, "You wrote";a

Close

Sleep
```

---

**Category:** [File I/O Functions](Category-File-I-O-Functions)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
