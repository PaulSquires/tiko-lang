[Home](Home) › [All Categories](Categories) › **File I/O Functions**

# File I/O Functions

<!-- finder:start -->

Grouped by task. [Files and folders](Functions-Files) lists them beside the rest of the area.

## File numbers: open and close files

| Function | What it does | From |
|---|---|---|
| [Open](Open) | Opens a file on a file number for reading or writing text, bytes or records. | built-in |
| [FreeFile](Freefile) | Returns an unused file number for Open, or 0 if all 255 are taken. | built-in |
| [Close](Close) | Closes one or more file numbers, or every open file when given none. | built-in |
| [Reset](Reset) | Closes every open file, or resets a redirected standard input or output stream. | built-in |
| [Input](Input-File-Mode) (file mode) | Opens a text file for reading with Open; the file must already exist. | built-in |
| [Output](Output) | Opens a text file for writing with Open, creating it or emptying it first. | built-in |
| [Append](Append) | Opens a text file with Open to add to its end, creating the file if needed. | built-in |
| [Binary](Binary) | Opens a file with Open for reading and writing bytes at any position. | built-in |
| [Random](Random) | Opens a file with Open for reading and writing fixed-size records, 128 bytes by default. | built-in |
| [Access](Access) | Limits a Binary or Random file in Open to reading, writing, or both. | built-in |
| [Read](Read-File-Access) (access) | Opens a Binary or Random file for reading only, in an Access clause. | built-in |
| [Write](Write-File-Access) (access) | Opens a Binary or Random file for writing only; an existing file is emptied first. | built-in |
| [Read Write](Read-Write-File-Access) (access) | Opens a Binary or Random file for both reading and writing, the default. | built-in |
| [Encoding](Encoding) | Sets the Unicode encoding of a text file in Open; a file read this way needs a BOM. | built-in |

## File numbers: read, write and seek

| Function | What it does | From |
|---|---|---|
| [Print #](procedures-Print) | Writes values as text to an open file; a trailing comma or semicolon skips the line break. | built-in |
| [Write #](procedures-Write) | Writes values to a file as comma-separated text, strings in quotes, for Input # to read. | built-in |
| [Input #](Input) | Reads comma- or line-separated values from a text file into variables. | built-in |
| [Line Input #](Line-Input) | Reads one line of a text file into a string, without its line ending. | built-in |
| [Get #](Get-File-I-O) | Reads a variable, string or array from a file as bytes, at a position or the current one. | built-in |
| [Put #](Put-File-I-O) | Writes a variable, string or array to a file as bytes, at a position or the current one. | built-in |
| [EOF](Eof) | Returns true when an open file has nothing left to read. | built-in |
| [LOF](Lof) | Returns the length in bytes of an open file. | built-in |
| [LOC](Loc) | Returns where the last read or write happened in an open file, counted in records. | built-in |
| [Seek](Seek-Function) (function) | Returns the 1-based position of the next read or write: bytes, or records for Random. | built-in |
| [Seek](Seek-Statement) (statement) | Sets the 1-based position of the next read or write: bytes, or records for Random. | built-in |
| [Lock](Lock) | Restricts other programs' access to a record or byte range of an open file. | built-in |
| [Unlock](Unlock) | Removes a restriction that Lock put on a record or byte range. | built-in |

## Open devices, pipes and the console

| Function | What it does | From |
|---|---|---|
| [Open Com](Open-Com) | Opens a serial port on a file number, with its speed, parity and other settings. | built-in |
| [Open Cons](Open-Cons) | Opens standard input or output on a file number, to use like a file. | built-in |
| [Open Err](Open-Err) | Opens standard input and standard error on a file number, to use like a file. | built-in |
| [Open Lpt](Open-Lpt) | Opens a printer on a file number, so Print # and Put # send data to it. | built-in |
| [Open Pipe](Open-Pipe) | Runs a shell command and opens its input or output on a file number. | built-in |
| [Open Scrn](Open-Scrn) | Opens the screen on a file number, for reading and writing like a file. | built-in |

## Also in this category

- [File I/O Functions](File-I-O-Functions)

<!-- finder:end -->

---

[Home](Home) · [Keyword Index](Keyword-Index)
