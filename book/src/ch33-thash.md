# Capstone: a Concurrent Pipeline

The second capstone is **`thash`**, which finds duplicate files. It walks a directory tree, reads
every file, hashes the contents, and reports the files whose contents are the same. Chapter 32's
tool did one thing after another; this one does several things at once. Walking the tree, reading
files and hashing them become **stages** that run as goroutines, joined by channels (Chapter 22).
The work is what the earlier chapters showed: `fs.WalkDir` and `fs.ReadAllBytes` (Chapter 24), a
`Map` (Chapter 23), a `Stopwatch` (Chapter 25), `RunningStats` (Chapter 26) and a `Logger`
(Chapter 27). What is new is fitting them into a pipeline. That means deciding who closes which
channel, how full a channel may get, how the whole thing stops early, and how output that is
produced in no fixed order can still be the same on every run.

## The specification

```text
thash [-j workers] [-t ms] [-v] directory
```

- Hash every file under **directory** and print the groups of files with identical contents. Each
  group gives its size and hash, then its paths in sorted order. The groups come in order of their
  first path, and a total says how many bytes the extra copies take.
- Print a line of statistics first: how many files, how many bytes, and the smallest, largest and
  mean sizes.
- **`-j`** sets how many files are hashed at once (default 4). **`-t ms`** stops after that many
  milliseconds and reports what was done so far. **`-v`** logs every file as it is hashed, and the
  time the run took.
- Paths are printed with `/` between components. The output does not depend on how many workers
  there are or on the order in which they finish.
- A file that cannot be read is reported on **stderr** and does not stop the run.
- **Exit code:** 0 if every file was hashed, 1 if some could not be read or the run was stopped
  early, and 2 for a bad command line.

## The shape

```text
            paths              results
  Walk  ──────────▶  Hasher ×N ──────────▶  collect  ──▶  report
 (1 goroutine)       (N goroutines)         (main program)
```

There are three stages, and each one owns the end of a channel. **Walk** is the only sender on
`paths`, so it is the one that closes it. **N hashers** share `paths` as receivers and `results`
as senders. No single hasher can close `results`, because the others may still be sending, so a
small goroutine waits on a **`WaitGroup`** and closes it once the last hasher is done. The **main
program** receives from `results` with `for each`, which ends when the channel closes. Every
channel is closed exactly once, by whoever knows that nothing more will be sent. That one rule is
what lets each loop end by itself.

The program is one file, `thash.tiko`, shown here a section at a time. `sample/` holds nine small
files, seven of which are copies of each other:

```text
ch33/
    thash.tiko
    sample/archive/2025/IMG_0042.img     copy of photos/lighthouse.img
    sample/archive/2025/readme.txt       copy of docs/readme.txt
    sample/archive/notes-old.txt         copy of docs/notes.txt
    sample/docs/notes.txt
    sample/docs/plans.txt
    sample/docs/readme.txt
    sample/photos/harbour.img
    sample/photos/lighthouse-copy.img    copy of photos/lighthouse.img
    sample/photos/lighthouse.img
```

## The records

```tiko
{{#include ../examples/ch33/thash.tiko:head}}
```

Every concurrent listing starts like this. `#import "std/tasks"` comes first, then `#cmdline "-mt"`
so that the program links the thread-safe runtime. The import also brings `select channel`.

```tiko
{{#include ../examples/ch33/thash.tiko:types}}
```

`Options` is the command line, already interpreted. `FileHash` is the message that travels from
the hashers to the collector: a whole record, with a `ustring` in it, sent through a channel by
value. A file that could not be read still produces a record, with `problem` filled in. The
collector must hear about every file, or it could not count the failures.

## Stage 1: walking the tree

```tiko
{{#include ../examples/ch33/thash.tiko:walk}}
```

`Walk` sends each file's path into `paths`. It does not use a plain `paths.Send( p )`, because a
send can **wait**: if the channel is full, the walker sits there until a hasher takes something
out. The `select channel` waits on two things at once. Either the send goes through, or the
context's `Done( )` channel closes, which means that someone has said stop. Whichever happens
first wins. Stopping leaves the loop, and the `Close` after it still runs, so the hashers see the
end of `paths` either way.

`paths` is declared as a whole `tasks.Channel`, not a `SendChan`. **A `select` case needs the
channel itself.** The helpers behind `select channel` are written for `Channel( of T )`, so a
`SendChan` or `RecvChan` view of it does not fit, and the compiler says it cannot infer their type
arguments. fbc-modern refuses the same code in the same way. The narrower types are still the right
choice wherever a stage only calls `Send` or `Receive`, as the hashers do.

## Stage 2: hashing, N at a time

```tiko
{{#include ../examples/ch33/thash.tiko:hash}}
```

Several `Hasher` goroutines run the same loop over the same `paths` channel, and each path goes to
exactly one of them: whichever is free first. That is the whole of the **fan-out**. Each hasher
reads a file whole with `fs.ReadAllBytes` and hashes the bytes with **`containers.HashBytes`**,
a 64-bit FNV-1a hash, the one `HashOf` uses when a `Map` has string keys. The result goes into `results`, which all
of the hashers send to. That is the **fan-in**.

When `paths` is closed and empty, `Receive` returns false, the loop ends, and the hasher calls
`wg->Done( )`. The `WaitGroup` was given one `Add( )` per hasher before any of them started.
`CloseWhenDone` waits for the count to reach zero and only then closes `results`. A hasher also
checks the context before each file, so a stopped run does not read every file left in the
channel's buffer.

### Logging from goroutines

The hashers log through one `Logger`, passed to each of them as a pointer. **A logger can be shared
between threads.** Each record is built by the thread that calls `Warn( )` or `Debug( )`. A sink
takes one lock for the whole of a write, so two goroutines logging at the same moment produce two
whole lines, never one line with the other's text inside it (Chapter 27). With `-v`, the logger's
`MinLevel` is `LOG_DEBUG` and every file produces a line. Without it, the level is `LOG_WARN`:
the `Debug( )` calls are a single comparison, and only failures are written.

## Back-pressure

A channel's capacity is how far its sender may get ahead of its receiver. When the buffer is full,
`Send` waits. That is **back-pressure**: a fast stage cannot run away from a slow one and fill
memory with work that nobody has started yet.

```tiko
{{#include ../examples/ch33/backpressure.tiko}}
```

```text
{{#include ../examples/ch33/backpressure.out}}
```

The producer wants to send six values, and the channel has room for two. For the first 200
milliseconds nobody receives, so the producer stops after two sends and waits inside the third.
It finishes only as the main program drains the channel.

In `thash`, `paths` holds `workers * 2` paths, so the walker can stay a little ahead of the hashers
and never leave them idle. It cannot list a whole disk into memory while they read the first file.
`results` holds `workers` records. If the collector were slow, the hashers would wait for it rather
than pile up finished work.

## Stopping early

A **`Context`** carries the decision to stop. `tasks.WithCancel` makes one that stops when its
`Cancel( )` is called. `tasks.WithTimeout` makes one that also stops by itself after a number of
milliseconds. Every stage that might wait has a `case receive from ctx.Done( )` beside its real
work.

```tiko
{{#include ../examples/ch33/stopearly.tiko}}
```

```text
{{#include ../examples/ch33/stopearly.out}}
```

The producer would send a million values. The channel has no buffer, so each send is a handover
that completes only when the main program receives. After three, the main program cancels. The
producer is waiting in its `select` for a fourth handover that will never come, `Done( )` closes,
and it stops, having sent exactly three. `ctx.Err( )` says why a context stopped: `cancelled`
here, and `deadline exceeded` when a timeout ran out.

## Stage 3: collecting

```tiko
{{#include ../examples/ch33/thash.tiko:main}}
```

The main program is the last stage. It parses the command line and sets up the logger with
`CT_STDERR`, so diagnostics never mix with the report. It makes a context, with a deadline if `-t`
asked for one. It creates the channels and the `WaitGroup`, starts the `Stopwatch`, and spawns
everything. Then it collects:

- **`byHash`**, a `Map` from hash to the paths with that hash. `byHash[ h ]` creates an empty array
  the first time a hash is seen, so `.Push( fh.path )` works for the first path and every later one.
- **`bytesOf`**, the size that goes with each hash.
- **`sizes`**, a `numeric.RunningStats` (Chapter 26), which keeps the count, minimum, maximum and
  mean in constant space, one value at a time.

After the loop, `ctx.Err( )` says whether the deadline cut the run short. It is read **before**
`ctx.Cancel( )`, which every context gets when it is finished with, and which would otherwise
change the answer to `cancelled`.

### Turning arrival order into stable output

The records arrive in whatever order the hashers finish, and that order changes from run to run.
Nothing in the report depends on it:

```tiko
{{#include ../examples/ch33/thash.tiko:report}}
```

Each group's paths are sorted. Each group is named by its first path, and the groups are printed
in sorted order of that name. The totals are sums, which come out the same in any order. The
`Stopwatch` time differs on every run, so it is logged only with `-v`, on stderr, and never
appears in the report.

`ParseArgs` reads `command( n )` until it comes back empty, and refuses anything it does not
understand. `DisplayPath` is the same as Chapter 32's:

```tiko
{{#include ../examples/ch33/thash.tiko:parse}}
```

## Running it

Run from the chapter's directory as `thash -j 4 sample`:

```text
{{#include ../examples/ch33/thash.out}}
```

The output is the same with `-j 1` and with `-j 8`, on Windows and on Linux: the harness runs it on
both, and it was also run 30 times with 1 to 8 workers. With `-v` on Windows, the log lines go to
stderr in the order the files were hashed, which changes between runs:

```text
$ thash -v -j 2 sample
DEBUG  hashed  path=sample/archive/2025/readme.txt bytes=78
DEBUG  hashed  path=sample/archive/2025/IMG_0042.img bytes=27
…
INFO   done  ms=1
```

On Linux, with one file made unreadable (`chmod 000 sample/docs/plans.txt`), the warning goes to
stderr, the report covers the other eight files, and the exit code is 1:

```text
$ thash sample
WARN   access denied  path=sample/docs/plans.txt
8 files, 373 bytes; smallest 24, largest 78, mean 46.6
…
 3 groups; 188 bytes in extra copies
 1 files could not be read
exit 1
```

On a larger tree of seven thousand files, `-t 20` stops part of the way through:

```text
$ thash -t 20 tests
589 files, 766691 bytes; smallest 13, largest 51770, mean 1301.7
 0 groups; 0 bytes in extra copies
stopped early (deadline exceeded)
```

How far it gets depends on the machine and on how busy it is. That is the nature of a time limit,
and the reason the report says plainly that it is incomplete.

## What it costs

- **Every file is read whole**, so each hasher holds one file in memory, and N hashers hold N
  files. For large files, read and hash in fixed-size blocks instead.
- **Equal hashes are evidence, not proof.** Two different files with the same 64-bit FNV-1a hash
  are very unlikely, but possible, and FNV is not designed to resist someone making a collision on
  purpose. A tool that deletes copies must compare the bytes first (Exercise 1).
- **Every file is hashed**, even when no other file has the same size. Grouping by size first and
  hashing only the sizes that occur more than once would skip most files on a real disk.
- **More workers is not always faster.** Hashing a small file costs little; reading it is the slow
  part, and a disk serves only so many reads at once. Measure with `-v` before choosing `-j`.

## Summary

- A pipeline is stages joined by channels. Each channel is closed once, by the stage that knows
  nothing more will be sent; when several stages send, a `WaitGroup` and a closer goroutine decide
  when.
- Several goroutines receiving from one channel is a fan-out; several sending to one channel is a
  fan-in.
- A channel's capacity limits how far a sender can get ahead: back-pressure.
- A `Context` stops a pipeline. Put `case receive from ctx.Done( )` beside every wait, and read
  `ctx.Err( )` to learn why it stopped. A `select` case needs a whole `Channel`, not a
  `SendChan` or `RecvChan`.
- A `Logger` can be shared between goroutines; each record is written whole.
- Output that arrives in no fixed order becomes stable by sorting it and by keeping times and other
  run-dependent values out of it.

## Exercises

1. Write `SameBytes( a, b )`, which compares two files byte by byte, and check it on the groups
   that `thash` reports for `sample/`. {solution="ex33-01"}
2. Start two walkers, one for `sample/docs` and one for `sample/photos`, both sending to a single
   channel, and print every file name they find in sorted order. Who closes the channel?
   {solution="ex33-02"}
3. Group the files by size first, and hash only the files whose size is shared by another file.
   Print how many files that skipped.
4. Add `-min bytes`, which ignores files smaller than the given size, and decide whether the
   walker or the hashers should apply it.
5. Add a fourth stage between the hashers and the collector that confirms each group with
   `SameBytes` before it is reported.
