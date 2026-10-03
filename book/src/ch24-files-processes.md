# Files, Processes and the Environment

Almost every useful program reads something it did not make and leaves something behind: a
configuration file, a log, a folder of results, an exit code a build script checks. This chapter
is about that boundary — the files a program reads and writes, the directories around them, the
console it talks through, and the other programs it starts.

tiko has two layers for files. The **statements** — `open`, `print #`, `line input #`, `get`,
`put`, `kill`, `mkdir` — are built into the language and have been the way programs did file
work for a very long time. The **`std/fs` module** sits beside them: a path algebra, a single
`Stat` call for every fact about a file, directory walks with `for each`, whole-file reads and
writes, and failures reported as `Result` values (Chapter 17) rather than as runtime errors. Both
are first-class; this chapter shows when each fits.

## Stream I/O

### Text files

A file is opened on a **file number**, and `freefile( )` hands out one nobody is using:

```tiko
{{#include ../examples/ch24/textfile.tiko}}
```

```text
{{#include ../examples/ch24/textfile.out}}
```

| Mode | Opens for | An existing file is |
|---|---|---|
| `for output` | writing | **emptied** |
| `for append` | writing at the end | kept |
| `for input` | reading | read; a missing file is runtime error 2 under `-e` |
| `for binary` | reading and writing bytes, anywhere | kept |
| `for random` | fixed-size records, by number | kept |

`print #f, …` writes a line as `print` would. `line input #f, text` reads one line, without its
line ending, into a `ustring` or `string`. `eof( f )` is true once nothing is left to read, so
`do until eof( f )` reads to the end. `close #f` releases the number; a program that never closes
its files leaks them until it ends.

`open` also takes an `access` clause (`access read`, `access write`, `access read write`) to say
how much of the file the program needs, `encoding "utf8"` and its siblings for text that is not
in the system's narrow encoding, and a `lock` clause that keeps other programs out of the file
while it is open.

`print #` ends each line the way the platform does: two bytes on Windows (carriage return and line
feed), one on Linux. Reading back with `line input #` handles both, but a byte count such as
`lof( f )` — the length of the open file — differs between the two for the same text.

### Fields with write # and input #

```tiko
{{#include ../examples/ch24/writeinput.tiko}}
```

```text
{{#include ../examples/ch24/writeinput.out}}
```

`write #` writes values separated by commas, with strings in quotes, so a comma inside a string
survives the round trip. `input #` reads them back into variables of the right types. It is the
simplest way to save a few values and read them again; for anything that other programs must read,
prefer a format both sides agree on.

### Binary and random-access files

A **random-access** file is a row of fixed-size records, read and written by number:

```tiko
{{#include ../examples/ch24/records.tiko}}
```

```text
{{#include ../examples/ch24/records.out}}
```

`len = sizeof( Item )` sets the record size, and `put #f, n, it` writes record `n` wherever it
falls — record 2 can be read or rewritten without touching records 1 and 3. Every field must have
a fixed size for this to work, which is why `label` is a `string * 8` rather than a `ustring`: a
variable-length string is a pointer, and a pointer written to a file means nothing when it is read
back. `lof( f )` is the file's length in bytes, `loc( f )` the last record read or written, and
`seek` moves to a position without reading.

`open … for binary` is the same idea without records: `get #f, position, variable` reads
`sizeof( variable )` bytes at a byte position, which is how a program reads a header or a block
of a file format.

## The std/fs module

```tiko
#import "std/fs"
```

### Paths

Paths are strings, and `std/fs` has the functions to take them apart and build them without
touching the disk:

```tiko
{{#include ../examples/ch24/paths.tiko}}
```

On Windows:

```text
{{#include ../examples/ch24/paths.win64-msvc.out}}
```

On Linux:

```text
{{#include ../examples/ch24/paths.out}}
```

| Function | Gives |
|---|---|
| `PathJoin( a, b, … )` | the parts joined with the platform's separator |
| `PathParent( p )`, `PathFileName( p )` | everything before the last separator; the last part |
| `PathStem( p )`, `PathExtension( p )` | the file name without, and only, its last extension |
| `PathNormalize( p )` | `.` and `..` resolved, separators made uniform |
| `PathChangeExtension( p, ext )` | `p` with a different extension |
| `PathIsAbsolute( p )`, `PathStartsWith( p, prefix )` | tests |
| `PathRelativeTo( p, base )` | `p` written relative to `base` |

The separator is `\` on Windows and `/` on Linux, and the functions use the platform's own when
they build a path. A name that begins with a dot, `.gitignore`, has no extension: its stem is the
whole name.

````admonish danger title="Pitfall"
**`PathJoin` with an absolute second part throws the first part away.**

```tiko
{{#include ../examples/ch24/pathescape.tiko}}
```

On Windows:

```text
{{#include ../examples/ch24/pathescape.win64-msvc.out}}
```

On Linux:

```text
{{#include ../examples/ch24/pathescape.out}}
```

Joining `"uploads"` with a name a user supplied looks like it keeps the file inside `uploads`. It
does not: an absolute name replaces the folder, and the program reads or writes wherever the name
points. Which names count as absolute differs by platform — on Linux the Windows-style name is a
harmless file called `C:\Windows\win.ini` inside `uploads`; on Windows it escapes. Check
containment after joining, with `PathStartsWith` on the normalized result, before using a path
built from somebody else's input.
````

### Facts about a file: Stat

```tiko
{{#include ../examples/ch24/stat.tiko}}
```

```text
{{#include ../examples/ch24/stat.out}}
```

`fs.Stat( path )` returns a `Result` holding a `FileInfo` — size, kind, times, read-only and hidden
flags — gathered in one call. A path that is not there is a **failure** whose `FsError` says
`FS_NOT_FOUND`, which is a different answer from `FS_ACCESS_DENIED`. `Exists`, `IsFile` and
`IsDir` answer yes or no and fold every failure into `false`: convenient in an `if`, and unable to
tell "absent" from "not allowed to look". Use `Stat` when the difference matters.

Every `std/fs` operation that can fail returns a `Result` in the same way. `Value( )` on a failure
is a runtime error, so test `IsOk( )` first — the habit from Chapter 17.

### Directories: walking, globbing, copying

```tiko
{{#include ../examples/ch24/copytree.tiko}}
```

```text
{{#include ../examples/ch24/copytree.out}}
```

`CreateTempDir` creates a directory with a fresh, unpredictable name and returns its path — the
safe way to get a scratch area. `ReadDir( p )` walks one directory; `WalkDir( p )` walks a whole
tree, a directory before its contents, with `Depth( )` counting from 0 for the root's own
children. Each element is a `Result`, because a walk can fail part-way — a directory it may not
open is reported as a failed element, and the walk carries on. Directory order is whatever the
file system gives, so the listing sorts before printing.

`Glob( pattern, results )` finds the paths that match a pattern: `*` and `?` within one part of a
path, and `**` for any number of directories, including none. `CopyDir` copies a tree and
`RemoveDirAll` deletes one; each returns how many objects it handled. `RemoveDirAll` deletes a
link to a directory without following it, so it cannot reach outside the tree it was given.

### Whole files, written atomically

```tiko
{{#include ../examples/ch24/wholefile.tiko}}
```

```text
{{#include ../examples/ch24/wholefile.out}}
```

`ReadAllText` reads a file into one `ustring`; `ReadAllLines` splits it into an `Array`, removing
the line endings of either platform; `WriteAllText` writes one. Text is UTF-8 unless the file
starts with a byte-order mark that says otherwise.

`WriteAtomic` writes the new content to a temporary file **in the same directory** and then
replaces the target with it. A program reading the file at the same moment sees the old contents
or the new, never half of each, and a crash during the write leaves the old file intact. That is
the right way to save a configuration or a document. What it does not promise is survival of a
power failure at that instant, which needs the operating system's cooperation beyond any library.

### Mapped files, locks and temporary files

```tiko
{{#include ../examples/ch24/advanced.tiko}}
```

```text
{{#include ../examples/ch24/advanced.out}}
```

A `MemoryMappedFile` makes a file's bytes appear in memory: `Data( )` is a pointer to them, and a
write through it changes the file. It is the fastest way to read a large file at random, and it is
a raw pointer — invalid after `Close( )`, and a fault if another program shortens the file while it
is mapped.

A `FileLock` keeps other cooperating programs away from a file while it is held. It is **advisory**:
on Linux it binds only programs that also ask for the lock, and the library promises no more than
that on Windows either. `CreateTempFile` creates a file under a fresh name and returns the path;
nothing deletes it for you.

`std/fs` also has a `FileWatcher`, which reports files created, changed, renamed and deleted under
a directory when the program calls its `Poll` method. Its events depend on the platform and on
timing — a single save can arrive as several events — so treat each batch as a reason to look
again rather than as an exact log.

## The classic statements

```tiko
{{#include ../examples/ch24/classic.tiko}}
```

```text
{{#include ../examples/ch24/classic.out}}
```

These are the statements every BASIC-family program has used, and they still work. Most have a
`std/fs` counterpart that reports failure as a `Result` instead of a runtime error or a silent
nothing:

| Classic | Does | std/fs |
|---|---|---|
| `mkdir p`, `rmdir p` | create or remove one directory | `CreateDir`, `CreateDirAll`, `RemoveDir`, `RemoveDirAll` |
| `chdir p`, `curdir( )` | change or read the current directory | `SetCurrentDir`, `CurrentDir` |
| `kill p` | delete a file | `RemoveFile` |
| `name old as new` | rename | `MoveFile` (which also crosses drives) |
| `dir( pattern )`, `dir( )` | first match, then next match | `ReadDir`, `Glob` |
| `filelen`, `fileexists` (`file.bi`) | size, existence | `Stat`, `Exists` |
| `exepath( )` | the folder the program is in | — |

`dir( )` keeps one listing per thread, so two listings cannot be interleaved and a goroutine cannot
continue the main program's (Chapter 22). `ReadDir` has neither limit.

## The console as a device

The console is something a program can draw on — but only when there is a console. When the output
is redirected to a file or a pipe, colour and cursor movement become stray control bytes in
someone else's data:

```tiko
{{#include ../examples/ch24/console.tiko}}
```

```text
{{#include ../examples/ch24/console.out}}
```

`IsRedirected( )`, from `#include once "fbio.bi"`, is true when standard output is not a console;
`IsRedirected( true )` asks the same about standard input. The listing's output above is the
redirected branch, because that is how the book's harness runs it. At a console, `cls` clears the
screen, `color` sets the text colour, `locate row, column` moves the cursor, and `width` sets the
console's size in characters.

For keyboard input, `inkey( )` returns the key waiting to be read, or an empty string at once if
there is none — the right call inside a loop that must keep working. `getkey( )` waits for a key
and returns its code. `sleep ms` pauses for that many milliseconds. `open cons` and `open err` open
the console's output and its error stream as file numbers, for code written against `print #`
(Chapter 18 traced to `open err`).

## Processes and the environment

### Arguments and environment variables

```tiko
{{#include ../examples/ch24/envreport.tiko}}
```

Run as `envreport alpha "two words" 3`:

```text
{{#include ../examples/ch24/envreport.out}}
```

`command( n )` is the `n`-th argument, with quotes already removed, and an empty string past the
last one; `command( 0 )` is the program's own path, and `command( )` all the arguments as one
string. `environ( name )` reads an environment variable — an empty string if it is not set — and
`setenviron "NAME=value"` sets one for this process and the programs it starts.

In the main module, `__FB_ARGC__` is the number of arguments counting the program itself, and
`__FB_ARGV__` the C array of them, a `zstring ptr ptr` — the form a C library that parses its own
command line expects. They belong to the main module's top level, as in fbc: inside a procedure
they are `TKO0743: '__fb_argc__' is not declared`, and another module's top level reads 0.

### Running other programs

```tiko
{{#include ../examples/ch24/pipe.tiko}}
```

```text
{{#include ../examples/ch24/pipe.out}}
```

| Statement | Runs | Returns |
|---|---|---|
| `shell( "command" )` | a command line, through the system shell | its exit code |
| `exec( program, args )` | a program, directly | its exit code |
| `chain( program )` | a program | its exit code |
| `run program` | a program | nothing: the current program ends |
| `open pipe "command" for input as #f` | a command whose output the program reads | — |

`shell` goes through `cmd.exe` on Windows and `/bin/sh` on Linux, so the command line is in that
shell's language; `exec` starts a program with no shell in between, which is safer when an argument
came from a user. `open pipe … for input` reads what the command prints, a line at a time, as if it
were a file; `for output` sends lines to its input instead.

### Exit codes

```tiko
{{#include ../examples/ch24/exitcode.tiko}}
```

```text
{{#include ../examples/ch24/exitcode.out}}
```

`end n` ends the program with exit status `n`. Zero means success to every shell and build tool;
anything else is a failure whose number the caller can test — `$?` in a Unix shell, `%ERRORLEVEL%`
in `cmd.exe`, or the return of `shell` and `exec` in another tiko program. A program that can fail
should say so through its exit code, not only through what it prints.

## What it costs

- **A statement-level `open` keeps its file open until `close`**, and each open file holds an
  operating-system handle. Close what you open, or wrap it in a type with a destructor (Chapter 21).
- **`Stat` is one system call**; `Exists` followed by a size check is two, and the file can change
  between them.
- **`WalkDir` holds one directory open at a time** and cannot exhaust handles, however deep the
  tree. `ReadAllText` and `ReadAllLines` hold the whole file in memory.
- **`WriteAtomic` writes the file twice over** — a temporary and a rename — which is the price of
  never leaving it half-written.

## Summary

- `open … for output | append | input | binary | random as #f`, with `freefile( )`. `print #`,
  `line input #`, `write #`/`input #`, `eof`, `lof`, `loc`, `seek`, `close`.
- Random-access files read and write fixed-size records by number with `get #` and `put #`; every
  field must be fixed-size.
- `#import "std/fs"`: the `Path*` functions; `Stat` for every fact at once, failures as `FsError`;
  `ReadDir`, `WalkDir`, `Glob`; `ReadAllText`/`ReadAllLines`/`WriteAllText`; `WriteAtomic`.
- **`PathJoin` with an absolute second part discards the first** — check containment with
  `PathStartsWith` before using a path built from input.
- The classic `mkdir`, `chdir`, `kill`, `name`, `dir` still work; `std/fs` reports their failures
  as values.
- `IsRedirected( )` decides whether to draw on the console. `inkey` never waits; `getkey` does.
- `command( n )`, `environ`, `setenviron`; `shell`, `exec`, `chain`, `run`, `open pipe`; `end n`
  sets the exit code.

## Exercises

1. Walk a directory tree and count its files by extension, printing the counts in a stable order.
   {solution="ex24-01"}
2. Write `Sell( f, record, n )` for the random-access stock file: it reduces the quantity by `n`
   and refuses, returning `false`, if there are not enough. {solution="ex24-02"}
3. Make `pathescape.tiko` refuse any name that would leave `uploads`, and print which names were
   refused, on both platforms.
4. Rewrite `textfile.tiko` with `fs.WriteAllText` and `fs.ReadAllLines`. Which version would you
   want if the file might be missing?
5. Write a program that runs `exitcode.tiko`'s executable with `exec` and prints a different message
   for exit status 0 and for anything else.
