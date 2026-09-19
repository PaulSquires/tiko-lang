[Home](Home) › [Operating System Functions](Category-Operating-System-Functions) › **Operating System Functions**

# Operating System Functions

Statements and procedures for working with files, directories and the system.

Description

The statements and procedures listed here provide access to the operating system environment. They transfer execution to external programs, get information about files and directories, manipulate the file system and send commands to the command shell.

**Working with Files**

Procedures that deal with files.

**Working with Directories**

Various directory management procedures.

**File Properties**

Get information about files.

**System Procedures**

Procedures for working with the environment.

***Working with Files***

**[Exec](Exec) and [Chain](Chain)**

Temporarily transfers control to another program.

**[Run](Run)**

Transfers control to another program.

**[Kill](Kill)**

Deletes an existing file.

**[Name](Name)**

Renames an existing file.

***File Properties***

**[FileAttr](Fileattr)**

Gets information about a file bound to a file number.

**[FileCopy](Filecopy)**

Copies a file.

**[FileDateTime](Filedatetime)**

Gets the last modified date and time of a file.

**[FileExists](Fileexists)**

Tests for the existence of a file.

**[FileLen](Filelen)**

Gets the length (in bytes) of a file.

**[FileSetEof](Fileseteof)**

Sets the length of an open file bound to a file number.

**[FileFlush](Fileflush)**

Flushes application or system buffers for an open file bound to a file number.

***Working with Directories***

**[CurDir](Curdir)**

Gets the current working directory.

**[ChDir](Chdir)**

Sets the current working directory.

**[Dir](Dir)**

Gets the names of files or directories matching certain attributes.

**[ExePath](Exepath)**

Gets the directory of the current running program.

**[MkDir](Mkdir)**

Creates a new directory.

**[RmDir](Rmdir)**

Deletes an existing directory.

***System Procedures***

**[Fre](Fre)**

Gets the amount of free memory (in bytes) available.

**[Command](Command)**

Gets the command-line parameters passed to the program.

**[Environ](Environ)**

Gets the value of an environment variable.

**[IsRedirected](Isredirected)**

Checks whether stdin or stdout is redirected to a file or not.

**[SetEnviron](Setenviron)**

Sets the value of an environment variable.

**[Shell](Shell)**

Sends a command to the system command interpreter.

**[System](System)**

Closes all open files and exits the program.

---

**Category:** [Operating System Functions](Category-Operating-System-Functions)

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
