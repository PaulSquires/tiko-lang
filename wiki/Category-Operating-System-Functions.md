[Home](Home) › [All Categories](Categories) › **Operating System Functions**

# Operating System Functions

The built-in statements and functions below work in every program. The [`std/os`](Category-OS) module adds `Args( )` that keeps empty arguments, `GetEnv` that tells an unset variable from an empty one, host facts such as `CpuCount( )`, and Ctrl-C handling; [`std/process`](Category-Process) runs other programs with their arguments passed exactly, no shell in between, and pipes to their input and output.

<!-- finder:start -->

Grouped by task. [Operating system](Functions-System) lists them beside the rest of the area.

## Read the command line

| Function | What it does | From |
|---|---|---|
| [Command](Command) | Returns command-line argument n, the program's name for 0, or all of them if omitted. | built-in |

## Run another program

| Function | What it does | From |
|---|---|---|
| [Shell](Shell) | Runs a command through the system shell, waits, and returns its exit code or -1. | built-in |
| [Exec](Exec) | Runs a program by its path with arguments, waits, and returns its exit code or -1. | built-in |
| [Chain](Chain) | Runs a program without arguments, waits, and returns its exit code or -1. | built-in |
| [Run](Run) | Hands control to another program and ends this one; returns -1 if it cannot start. | built-in |

## Read and set environment variables

| Function | What it does | From |
|---|---|---|
| [Environ](Environ) | Returns the value of an environment variable, or an empty string if it is not set. | built-in |
| [SetEnviron](Setenviron) | Sets an environment variable from "NAME=value" text; returns 0 on success. | built-in |

## Find the program's folder and the current folder

| Function | What it does | From |
|---|---|---|
| [ExePath](Exepath) | Returns the folder that holds the running program. | built-in |
| [CurDir](Curdir) | Returns the current folder. | built-in |
| [ChDir](Chdir) | Changes the current folder; returns 0 on success or -1 on failure. | built-in |

## Make, remove and list folders

| Function | What it does | From |
|---|---|---|
| [MkDir](Mkdir) | Creates one folder, whose parent must already exist; returns 0 on success. | built-in |
| [RmDir](Rmdir) | Removes an empty folder; returns 0 on success or -1 on failure. | built-in |
| [Dir](Dir) | Returns the first name matching a pattern, then the next one on each later call. | built-in |

## Copy, rename and delete files

| Function | What it does | From |
|---|---|---|
| [FileCopy](Filecopy) | Copies a file, overwriting the destination; returns 0 on success. | `file.bi` |
| [Name](Name) | Renames or moves a file or folder; returns 0 on success. | built-in |
| [Kill](Kill) | Deletes a file; returns 0 on success or an error code. | built-in |

## Check whether a file exists, its size and date

| Function | What it does | From |
|---|---|---|
| [FileExists](Fileexists) | Returns non-zero if the file exists, or 0 if it does not. | `file.bi` |
| [FileLen](Filelen) | Returns the size of a named file in bytes. | `file.bi` |
| [FileDateTime](Filedatetime) | Returns when a file was last modified, as a date serial. | `file.bi` |

## Work with an open file number

| Function | What it does | From |
|---|---|---|
| [FileAttr](Fileattr) | Returns an open file number's mode, system handle or encoding. | `file.bi` |
| [FileFlush](Fileflush) | Writes buffered output for one or all open files to the system, or on to disk. | `file.bi` |
| [FileSetEof](Fileseteof) | Cuts or extends an open file so that it ends at the current position. | `file.bi` |

## End the program

| Function | What it does | From |
|---|---|---|
| [System](System) | Closes all open files and ends the program, with an optional exit code. | built-in |

## Check free memory and redirection

| Function | What it does | From |
|---|---|---|
| [Fre](Fre) | Returns the amount of free physical memory, in bytes. | built-in |
| [IsRedirected](Isredirected) | Returns non-zero if standard output, or input if asked, is redirected to a file. | `fbio.bi` |

## Also in this category

- [Operating System Functions](Operating-System-Functions)

<!-- finder:end -->

---

[Home](Home) · [Keyword Index](Keyword-Index)
