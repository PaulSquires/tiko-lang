[Home](Home) › [File I/O Functions](Category-File-I-O-Functions) › **File I/O Functions**

# File I/O Functions

Statements and procedures for working with files and devices.

Description

These statements and procedures provide file and device i/o capabilities. So called *file numbers* can be bound to files or devices, which can be read or written to using formatted (text mode) or unformatted (binary mode) data. In binary mode, files and devices can be read from or written to in arbitrary locations. For multithreaded applications, files and devices can also be locked.

**Opening Files or Devices**

Procedures and other keywords that provide read or write access to a file or device.

**Reading from and Writing to Files or Devices**

Procedures that read and write data to an opened file or device.

**File Position and other Info**

Procedures that determine where reading and writing will take place within an opened file.

***Opening Files or Devices***

**[FreeFile](Freefile)**

Gets an available file number that can be used to read or write from files or devices.

**[Open](Open)**

Binds a file number to a physical file to provide reading and writing capabilities.

**[Open Com](Open-Com)**

Binds a file number to a communications port.

**[Open Cons](Open-Cons)**

Binds a file number to the standard input and output streams.

**[Open Err](Open-Err)**

Binds a file number to the standard input and error streams.

**[Open Lpt](Open-Lpt)**

Binds a file number to a printer device.

**[Open Pipe](Open-Pipe)**

Binds a file number to the input and output streams of a process.

**[Open Scrn](Open-Scrn)**

Binds a file number directly to the console.

**[Close](Close)**

Unbinds a file number from a file or device.

**[Reset](Reset)**

Unbinds all active file numbers.

**File I/O modes**

**[Input (File Mode)](Input-File-Mode)**

Text data can be read from the file.

**[Output](Output)**

Text data can be written to the file.

**[Append](Append)**

Text data is added to the end of a file when output.

**[Binary](Binary)**

Arbitrary data can be read from or written to the file.

**[Random](Random)**

Blocks of data of certain size can be read from and written to the file.

**File access privileges**

**[Access](Access)**

An overview of file access privileges.

**[Read (File Access)](Read-File-Access)**

Binary data can only be read from the file.

**[Write (File Access)](Write-File-Access)**

Binary data can only be written to the file.

**[Read Write(File Access)](Read-Write-File-Access)**

Binary data can be read from and written to the file.

**Character encoding**

**[Encoding](Encoding)**

Specifies the character encoding of a file.

***Reading from and Writing to Files or Devices***

**[Input #](Input)**

Reads a list of values from a file or device.

**[Write #](procedures-Write)**

Writes a list of values to a file or device.

**[Input()](Input-2)**

Reads a number of characters from a file or device.

**[Winput()](Winput)**

Reads a number of wide characters from a file or device.

**[Line Input #](Line-Input)**

Reads a line of text from a file or device.

**[Print #](procedures-Print)**
**[? # (Shortcut For 'Print #')](procedures-Print)**

Writes text data to a file or device.

**[Put #](Put-File-I-O)**

Writes arbitrary data to a file or device.

**[Get #](Get-File-I-O)**

Reads arbitrary data from a file or device.

***File Position and other Info***

**[LOF](Lof)**

Gets the length (in bytes) of a file.

**[LOC](Loc)**

Gets the file position of the last read or write operation.

**[EOF](Eof)**

Returns true if all of the data has been read from a file.

**[Seek (Statement)](Seek-Statement)**

Sets the file position of the next read or write operation.

**[Seek (Function)](Seek-Function)**

Gets the file position of the next read or write operation.

**[Lock](Lock)**

Restricts read or write access to a file or portion of a file.

**[Unlock](Unlock)**

Remove read or write restrictions from a previous [Lock](Lock) command.

---

**Category:** [File I/O Functions](Category-File-I-O-Functions)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
