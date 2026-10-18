# Files, Processes and the Environment

Almost every useful program reads something it did not make and leaves something behind: a
configuration file, a log, a folder of results, an exit code a build script checks. This chapter
is about that boundary — the files a program reads and writes, the directories around them, the
console it talks through, and the other programs it starts.

Files are the **`std/fs` module**: an open `File` and the streams layered on it, a path algebra, a
single `Stat` call for every fact about a file, directory walks with `for each`, whole-file reads
and writes, and the directories a program keeps its own files in. Every operation that can fail
returns a `Result` (Chapter 17) rather than raising a runtime error, so a missing file is a value
the program looks at, not a crash.

```tiko
#import "std/fs"
```

## Files and streams

### Text files

A `File` is opened in place and **closes itself** when it goes out of scope. A `TextWriter`
writes text to it, and `ReadLines` reads a file back a line at a time with `for each`:

```tiko
{{#include ../examples/ch24/textfile.tiko}}
```

```text
{{#include ../examples/ch24/textfile.out}}
```

`Create` makes the file, or empties one that is there; `OpenAppend` keeps what is there and writes
at the end; `OpenRead` opens for reading only. The `scope` blocks are where each `File` ends: its
destructor closes the handle, and the `TextWriter` declared after it is destroyed first, so nothing
is left unwritten. A `File` cannot be copied — pass it `byref`.

`WriteLine` ends each line the way the platform does: carriage return and line feed on Windows,
line feed alone on Linux. Set the writer's `NewLine` to `chr( 10 )` for files that must be the
same bytes everywhere. `ReadLines` accepts either ending, removes it, and yields one
`Result( of ustring, FsError )` per line — `ln.Value( )` is the text. It holds one line in memory at
a time, whatever the size of the file, and leaving the loop early closes the file.

Text is UTF-8. A `TextReader` and `ReadLines` also honour a byte-order mark at the start of a file,
for UTF-8 and UTF-16 text written by other programs.

### Opening a file

Every open returns a `Result( of boolean, FsError )`, and the error says why:

```tiko
{{#include ../examples/ch24/openfile.tiko}}
```

```text
{{#include ../examples/ch24/openfile.out}}
```

| Method | Opens for | An existing file is | A missing file |
|---|---|---|---|
| `OpenRead( p )` | reading | read | fails, `FS_NOT_FOUND` |
| `Create( p )` | writing | **emptied** | created |
| `CreateNew( p )` | writing | refused, `FS_ALREADY_EXISTS` | created |
| `OpenAppend( p )` | writing at the end | kept | created |
| `Open( p, options )` | what `OpenOptions` says | as the options say | as the options say |

An `OpenOptions` names what the program needs: `Read`, `Write`, `Append`, `Truncate`, `Create` and
`CreateNew`. A combination that makes no sense — `Append` with `Truncate`, `CreateNew` without
`Write` — is refused before anything is opened. An operation the `File` was not opened for fails
too: writing to a file opened for reading is a failure, not a silent nothing.

Other programs may still read, write, rename and delete a file you have open; on Windows the
`ShareRead`, `ShareWrite` and `ShareDelete` options narrow that. A handle is **not** passed to the
programs this one starts unless `Inheritable` is set.

### Fields in a line

The simplest file format a program can save and read again is one record per line with its fields
separated by commas:

```tiko
{{#include ../examples/ch24/fields.tiko}}
```

```text
{{#include ../examples/ch24/fields.out}}
```

A field that contains a comma is written inside double quotes, and `strings.SplitCsvRow` splits a
line into its fields with the quotes removed, so `hopper, grace` survives the round trip. `valint`
and `val` turn the text fields back into numbers. For anything that other programs must read,
prefer a format both sides agree on.

### Records at a position

A file of fixed-size records can be read and written **by number**, without touching the records
around the one you want:

```tiko
{{#include ../examples/ch24/records.tiko}}
```

```text
{{#include ../examples/ch24/records.out}}
```

`WriteAt( position, buffer, count )` writes `count` bytes at a byte position, and `ReadAt` reads
them; record `n` begins `( n - 1 ) * sizeof( Item )` bytes into the file. Neither moves the file's
position, and both may be called from several threads on one `File`. `Size( )` is the length of
the file in bytes. Every field must have a fixed size for this to work, which is why `label` is a
`string * 8` rather than a `ustring`: a variable-length string is a pointer, and a pointer written to
a file means nothing when it is read back.

### Streams

A `File` is a **`Stream`**: something that bytes can be read from, written to, or both. A
`MemoryStream` is another — a growable buffer in memory — and everything that works on one works on
the other:

```tiko
{{#include ../examples/ch24/streams.tiko}}
```

```text
{{#include ../examples/ch24/streams.out}}
```

`fs.Copy( source, destination )` copies from the source's current position to its end, which is why
the listing seeks the `MemoryStream` back to 0 first. A `TextReader` reads lines from any stream,
here the `File`; `ReadLine` returns `false` when there are no more.

| Type | Is |
|---|---|
| `File` | a file on disk; **unbuffered**: each `Read` and `Write` is one call to the system |
| `MemoryStream` | bytes in memory; `Length( )`, `ToUtf8Text( )` |
| `BufferedReader`, `BufferedWriter` | a buffer over another stream, so many small reads or writes become a few large ones |
| `TextReader`, `TextWriter` | text over another stream: `ReadLine`, `WriteLine` |

A wrapper keeps a pointer to the stream it was given, so that stream must outlive it — declare the
stream first. `Read` may return fewer bytes than asked, and `Ok( 0 )` means the end; `ReadExact`,
`WriteAll` and `Copy` are the loops that make short reads and writes invisible.

A stream of your own extends `fs.Stream` and overrides the operations it supports:

```tiko
{{#include ../examples/ch24/counting.tiko}}
```

```text
{{#include ../examples/ch24/counting.out}}
```

`Read`, `Write`, `Seek` and `Flush` are virtual and return a `Result`. `Counter` overrides `Write`
and says so with `CanWrite`; the operations it does not override fail with `FS_UNSUPPORTED`, and
`CanRead( )` answers `false`. Anything written for a `Stream` — `TextWriter`, `Copy`, a buffer —
now works with it.

## Paths, metadata and directories

### Paths

Paths are strings, and `std/fs` has the functions to take them apart and build them without
touching the disk:

```tiko
{{#include ../examples/ch24/paths.tiko}}
```

On Windows:

```text
{{#include ../examples/ch24/paths.windows-x86_64.out}}
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
{{#include ../examples/ch24/pathescape.windows-x86_64.out}}
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
link inside the tree as a link, without following it, and it opens each directory relative to the
one it is already in, so even another program swapping a directory for a link while the delete
runs cannot send it outside the tree. Given a path that is itself a link, it refuses with
`FS_NOT_A_DIRECTORY` and deletes nothing.

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

### Where a program keeps its files

```tiko
{{#include ../examples/ch24/userdirs.tiko}}
```

```text
{{#include ../examples/ch24/userdirs.out}}
```

| Function | Windows | Linux |
|---|---|---|
| `HomeDir( )` | the user's profile folder | `$HOME`, else the user's account entry |
| `ConfigDir( )` | `AppData\Roaming` | `$XDG_CONFIG_HOME`, else `~/.config` |
| `DataDir( )` | `AppData\Local` | `$XDG_DATA_HOME`, else `~/.local/share` |
| `CacheDir( )` | `AppData\Local` | `$XDG_CACHE_HOME`, else `~/.cache` |
| `StateDir( )` | `AppData\Local` | `$XDG_STATE_HOME`, else `~/.local/state` |
| `ExecutablePath( )` | the program's own file | the program's own file |

**Nothing is created and no program name is added.** Each call says where the directory should
be; join your own program's name, and `CreateDirAll` it before writing there. On Linux an `XDG_`
variable counts only when it holds an absolute path. `ExecutablePath( )` is the full path of the
running program however it was started, which `command( 0 )` is not — the way to find a file
installed beside the program. `ExpandHome` replaces a leading `~` with the home directory and leaves
every other path as it is.

## Coming from the file statements

tiko still compiles the file statements of the BASIC family — `open`, `print #`, `line input #`,
`get #`, `put #`, `kill`, `mkdir` and the rest — so older programs keep working. New code uses
`std/fs`, where a failure is a value rather than a runtime error or a silent nothing:

| Statement | Does | std/fs |
|---|---|---|
| `open … for output` / `append` / `input` | open a text file | `File.Create`, `OpenAppend`, `OpenRead` |
| `print #`, `line input #`, `eof` | write and read lines | `TextWriter.WriteLine`, `ReadLines`, `TextReader.ReadLine` |
| `write #`, `input #` | comma-separated fields | `WriteLine` of the fields, `strings.SplitCsvRow` |
| `open … for random`, `get #`, `put #` | fixed-size records | `File.ReadAt`, `WriteAt` |
| `lof( f )`, `seek` | length, position | `File.Size( )`, `Seek` |
| `mkdir p`, `rmdir p` | create or remove a directory | `CreateDir`, `CreateDirAll`, `RemoveDir`, `RemoveDirAll` |
| `chdir p`, `curdir( )` | change or read the current directory | `SetCurrentDir`, `CurrentDir` |
| `kill p` | delete a file | `RemoveFile` |
| `name old as new` | rename | `MoveFile` (which also crosses drives) |
| `dir( pattern )`, `dir( )` | first match, then next match | `ReadDir`, `Glob` |
| `exepath( )` | the folder the program is in | `PathParent( ExecutablePath( ).Value( ) )` |

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

- **A `File` holds an operating-system handle until it is closed or goes out of scope.** Keep it
  in the narrowest `scope` that needs it. Call `Close( )` yourself when you need to know whether
  the close itself succeeded: it returns a `Result`, and a destructor has nowhere to report one.
- **A `File` is unbuffered**: every `Read` and `Write` is a system call. Many small writes belong in
  a `BufferedWriter`, a `TextWriter` over one, or a `MemoryStream` written once.
- **`Stat` is one system call**; `Exists` followed by a size check is two, and the file can change
  between them.
- **`WalkDir` holds one directory open at a time** and cannot exhaust handles, however deep the
  tree. `ReadAllText` and `ReadAllLines` hold the whole file in memory.
- **`WriteAtomic` writes the file twice over** — a temporary and a rename — which is the price of
  never leaving it half-written.

## Summary

- `#import "std/fs"`. A `File` opens with `OpenRead`, `Create`, `CreateNew`, `OpenAppend` or
  `Open( p, OpenOptions )`, closes itself, and reports every failure as an `FsError`.
- `TextWriter.WriteLine` writes lines; `for each ln in ReadLines( p )` reads them back.
  `strings.SplitCsvRow` splits a line of comma-separated fields.
- `ReadAt` and `WriteAt` read and write fixed-size records at a position; every field must be
  fixed-size.
- A `File` is a `Stream`, like `MemoryStream`; buffers, text readers and writers, and `Copy` work on
  any stream, including one you write by extending `fs.Stream`.
- The `Path*` functions; `Stat` for every fact at once; `ReadDir`, `WalkDir`, `Glob`;
  `ReadAllText`/`ReadAllLines`/`WriteAllText`; `WriteAtomic`.
- `ConfigDir`, `DataDir`, `CacheDir`, `StateDir`, `HomeDir` and `ExecutablePath` say where a program
  keeps its files.
- **`PathJoin` with an absolute second part discards the first** — check containment with
  `PathStartsWith` before using a path built from input.
- The file statements (`open`, `print #`, `kill`, `mkdir`, `dir` …) still compile for older
  programs; each has a `std/fs` counterpart that reports failure as a value.
- `IsRedirected( )` decides whether to draw on the console. `inkey` never waits; `getkey` does.
- `command( n )`, `environ`, `setenviron`; `shell`, `exec`, `chain`, `run`, `open pipe`; `end n`
  sets the exit code.

## Exercises

1. Walk a directory tree and count its files by extension, printing the counts in a stable order.
   {solution="ex24-01"}
2. Write `Sell( f, record, n )` for the stock file of `records.tiko`: it reduces the quantity of
   record `record` by `n` and refuses, returning `false`, if there are not enough.
   {solution="ex24-02"}
3. Make `pathescape.tiko` refuse any name that would leave `uploads`, and print which names were
   refused, on both platforms.
4. Rewrite `textfile.tiko` with `fs.WriteAllText` and `fs.ReadAllLines`. Which version would you
   want for a file of a few lines, and which for a log of a few gigabytes?
5. Write a program that runs `exitcode.tiko`'s executable with `exec` and prints a different message
   for exit status 0 and for anything else.
