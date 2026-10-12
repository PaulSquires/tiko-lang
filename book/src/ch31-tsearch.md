# Capstone: a CLI Search Tool

This chapter builds a complete program: **`tsearch`**, a small cousin of `grep`. It walks a
directory tree, reads every file in it, and prints the lines that contain a pattern. There is
nothing in it the earlier chapters have not shown; what is new is putting the pieces together and
making the decisions a real tool needs — what goes in a module and what stays in the program, how a
failure reaches the user, what the exit code means, and how the parts are tested.

## The specification

```text
tsearch [-i] [-n] [-l] [-g glob] pattern [path ...]
```

- Print every line, in every file under each **path**, that contains **pattern**, as
  `path:line text`. With no path, search the current directory.
- **`-i`** ignores case, for all of Unicode and not only for ASCII. **`-n`** adds the line number:
  `path:number:line text`. **`-l`** prints only the names of files that match. **`-g glob`**
  searches only files whose names match a glob pattern such as `*.txt`.
- Paths are printed with `/` between components on every platform, and files are searched in sorted
  order, so the output is the same everywhere.
- When the output goes to a terminal, the file name is coloured; when it is redirected to a file or
  a pipe, it is plain text.
- Problems — a bad option, a path that does not exist, a file that cannot be read — go to
  **stderr**, never into the results.
- The **exit code** says what happened, as `grep`'s does: **0** if anything matched, **1** if
  nothing did, **2** if something went wrong. A script can test it.

## The layout

```text
ch31/
    tiko.toml           the package
    search/search.tiko  the module: everything that can be tested on its own
    tsearch.tiko        the program: the command line, the output, the exit code
    searchtests.tiko    the module's tests
    sample/             files to search
        notes/readme.md
        notes/todo.txt
        poems/fox.txt
```

The work is split along one line: **everything that does not touch the command line or the screen
goes in the module.** Parsing the arguments takes an array and returns options; matching takes two
strings; finding files takes a root and returns paths. None of them prints anything, so the tests
can call each one directly and check what it returns. The program is what is left: reading
`command( )`, printing, and choosing the exit code.

`tiko.toml` makes the directory a **package** (Chapter 14), which lets the exercise solutions in
`solutions/` reach the module as `"../search"` — a relative import may not leave its package:

```text
{{#include ../examples/ch31/tiko.toml}}
```

## The module

```tiko
{{#include ../examples/ch31/search/search.tiko:head}}
```

The module uses `std/fs` for the file system and `std/containers` for its arrays, and declares two
**public** types:

```tiko
{{#include ../examples/ch31/search/search.tiko:types}}
```

`Options` is everything the command line said, already interpreted: the program builds one, and
every other procedure reads it. `Hit` is one result. Neither has methods: they are plain records
passed between the procedures, which keeps each procedure testable with values a test can write out.

### Parsing the arguments

```tiko
{{#include ../examples/ch31/search/search.tiko:parse}}
```

`ParseArgs` reads an array rather than calling `command( n )` itself, so a test can hand it any
argument list. It returns **an error message, or an empty string** — the one thing the caller needs
to know — and fills `opts` in place. A flag that takes a value, `-g`, moves the index past it, and
says so if the value is missing. Anything else starting with `-` is refused rather than searched
for: a misspelt option should be an error, not a silent search for `-x`. The first other argument
is the pattern and the rest are roots, with `.` as the default.

### Matching

```tiko
{{#include ../examples/ch31/search/search.tiko:match}}
```

A case-insensitive match compares both strings in lower case. For a `ustring`, **`lcase` folds the
whole of Unicode**, not only `A` to `Z`: `ÄRGER` matches `ärger`. Lower-casing a whole
line for every comparison is not the fastest possible way — the pattern could be folded once — but
it is obviously correct, which is the right first version.

### Finding the files

```tiko
{{#include ../examples/ch31/search/search.tiko:find}}
```

A root that is a file is searched as it is. A directory is walked with **`fs.WalkDir`**
(Chapter 24), which yields one `Result` per entry: a successful entry that is a file is kept when
its name matches the glob, using **`fs.MatchPattern`** — the same matcher `fs.Glob` uses, applied
to one name. A failed entry — a directory that cannot be opened, or a root that does not exist —
becomes a message in `problems`, so the program can report it and still search everything else.

The paths are **sorted** before they are returned. A file system lists a directory in whatever
order it likes, and that order differs between Windows and Linux; a tool whose output changes
between runs on the same files is a tool whose output cannot be compared.

### Searching a file

```tiko
{{#include ../examples/ch31/search/search.tiko:searchfile}}
```

`fs.ReadAllLines` returns a **`Result`** (Chapter 17): the number of lines, or an **`FsError`** that
says why the file could not be read. `SearchFile` passes that `Result` straight back, so the caller
learns about a failure in the same value that carries success, and cannot forget to look: there is
no error number to check separately and no runtime error to trap.

```tiko
{{#include ../examples/ch31/search/search.tiko:display}}
```

`DisplayPath` is the last piece of the "same output everywhere" promise: Windows writes `\` between
path components, and the tool prints `/` on both.

## The program

```tiko
{{#include ../examples/ch31/tsearch.tiko}}
```

The program reads like the specification. It collects the arguments — `command( 1 )` onward, until
`command( n )` comes back empty — and hands them to `ParseArgs`; a bad command line prints the
problem and the usage line to **stderr** through `Complain`, and ends with exit code 2.

**`IsRedirected( )`** (from `fbio.bi`, Chapter 24) is true when standard output is not a terminal.
The program colours only when it is false, so `tsearch fox > hits.txt` writes plain text and a
person at a terminal sees the file names in magenta. The colour itself is an ANSI escape sequence,
`ESC [35m` to start and `ESC [0m` to stop, which every modern terminal understands.

Every failure is counted, and reported where it happens, without stopping the search: one
unreadable file should not hide the matches in all the others. Only at the end does the program
choose the exit code: **2** if anything failed, otherwise **0** or **1** by whether anything
matched.

## Running it

Run from the chapter's directory as `tsearch -n -i fox sample`:

```text
{{#include ../examples/ch31/tsearch.out}}
```

A few more runs, on either platform, with the exit code after each:

```text
$ tsearch -l -g *.txt fox sample
sample/poems/fox.txt
exit 0
$ tsearch zebra sample
exit 1
$ tsearch fox nowhere
tsearch: nowhere: no such file or directory
exit 2
$ tsearch -x fox
tsearch: unknown option -x
tsearch: usage: tsearch [-i] [-n] [-l] [-g glob] pattern [path ...]
exit 2
```

The second run prints nothing at all and still says something, through its exit code: a script
can write `if tsearch -l secret . ; then …` and never look at the output. (In a Unix shell, quote
the glob — `-g '*.txt'` — or the shell expands it before tsearch sees it.)

## Testing

```tiko
{{#include ../examples/ch31/searchtests.tiko}}
```

On Windows:

```text
{{#include ../examples/ch31/searchtests.windows-x86_64.out}}
```

On Linux the same suites run in another order (Chapter 18):

```text
{{#include ../examples/ch31/searchtests.out}}
```

The tests are a program of their own, built with fbcunit (Chapter 18), that imports the module just
as `tsearch.tiko` does. Each test calls one procedure with values it chose and checks what came back:
the argument parser with good and bad command lines, matching with and without case, and Unicode
folding; finding files in `sample/`, with and without a glob, in sorted order; line numbers; and a
missing file, which must come back as a failed `Result` rather than a crash. Nothing here needs a
terminal or anything outside `sample/`, so it can run on every build.

The program itself is tested the way the runs above were: by running it on known files and
comparing its output and exit code with what they should be.

## What it costs

- **Every file is read whole** with `ReadAllLines`, so a search holds one file in memory at a
  time. A tool for very large files would read a line at a time with `line input #`.
- **Case-insensitive matching lower-cases every line**, one copy per line. Folding the pattern once
  and comparing without copying is the obvious optimisation, and the tests are what make it safe
  to try.
- **Sorting the file list** costs a little time for a large tree, and buys output that does not
  depend on the file system.

## Summary

- Put everything that does not touch the command line or the screen in a module, and test it
  directly; keep the program a thin layer over it.
- Parse arguments from an array into an options record, and report problems as messages; refuse
  unknown options.
- `fs.WalkDir` and `fs.MatchPattern` find the files; sort them for stable output. `fs.ReadAllLines`
  returns a `Result` whose `FsError` says why a file could not be read.
- `lcase` folds Unicode for case-insensitive matching.
- Diagnostics go to stderr; `IsRedirected( )` decides about colour; the exit code — 0, 1 or 2 —
  says what happened.
- fbcunit tests the module's procedures one by one, on both platforms.

## Exercises

1. Write a program that uses the `search` module to print how many lines match in each file, as
   `path: count`. {solution="ex31-01"}
2. Add whole-word matching, so that `dog` matches `the lazy dog.` and `hot-dog` but not `dogma` or
   `underdog`. {solution="ex31-02"}
3. Add a `-c` option that prints only the number of matching lines in each file, with tests for its
   parsing.
4. Add `-v`, which prints the lines that do *not* match. Which other options does it interact with,
   and how should `-l -v` behave?
5. Make the match cheaper: fold the pattern once, outside the loop, and check that every test still
   passes.
