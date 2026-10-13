# Classic BASIC and Compatibility

BASIC is older than most of the languages around it, and a great deal of code was written in its
earlier forms: QuickBASIC programs from the 1980s, FreeBASIC programs written in its `qb`
compatibility mode, and every generation of code since that kept the old habits. This chapter is
for reading and bringing over that code. It covers the classic features tiko keeps — `data` and
`read`, computed jumps, the classic date and time functions, `common` and `chain` — and, just as
important, the ones it refuses, with the diagnostic each produces and what to write instead.

The listings here end in `.bas`, as the code they stand for usually does. tiko compiles a `.bas`
file exactly as it compiles a `.tiko` one.

## One dialect

FreeBASIC has four **dialects**, chosen with `#lang` at the top of a file (fbc also has a `-lang`
option; tiko does not): `fb`, the modern
language; `fblite` and `qb`, which keep QuickBASIC's rules; and `deprecated`, an older version of
`fb`. tiko implements **`fb` only**. Asking for another is refused:

```tiko
{{#include ../examples/ch31/dialect.bas}}
```

```text
dialect.bas(2,1): error TKO0317: unsupported language mode 'qb';
tiko-lang implements "fb" only
```

(One line in the compiler's output, broken here to fit the page.)

Everything this book teaches is the `fb` dialect, and everything below that compiles is legal in
it. Code written for `qb` or `fblite` has to be brought over, and most of this chapter is how.

## Inline data: data, read and restore

```tiko
{{#include ../examples/ch31/quiz-data.bas}}
```

```text
{{#include ../examples/ch31/quiz-data.out}}
```

**`data`** statements hold a list of constant values — numbers and strings — anywhere in the
module. **`read`** takes the next values from that list, in the order the `data` statements
appear in the file, into the variables it names, converting each to the variable's type. Reading
past the last item is **not an error**, even with `-exx`: the variable gets 0 or an empty string,
as fbc's does.

**`restore`** moves the reading position back: with no argument to the first `data` in the
module, and with a **label** to the first `data` after that label. Labels in tiko are names
followed by a colon on a line of their own, as `bonus:` is; the old numbered lines are not legal in
the `fb` dialect.

`data` is a compact way to put a table in a program, and it is easy to get wrong: nothing checks
that a `read` takes values of the types the `data` holds, or that each record has the number of
fields the code expects, and one missing field shifts every later read by one. In new code an array
with an initialiser (Chapter 7) or a file (Chapter 24) holds the same table, with types the
compiler checks.

## Computed jumps

```tiko
{{#include ../examples/ch31/menu.bas}}
```

```text
{{#include ../examples/ch31/menu.out}}
```

**`goto label`** jumps to a label in the same procedure, and **`on n goto a, b, c`** jumps to the
`n`th label in its list — the first for 1, the second for 2. A value of 0, a negative value or one
past the end of the list jumps nowhere: the statement does nothing, and execution carries on with
the next line, which is how `menu.bas` catches choices 0 and 4.

`on … goto` is how menus and state machines were written before `select case`. In new code,
`select case choice` with a `case` per option says the same thing without the labels and without a
`goto` in every branch, and the compiler can see where each one ends.

## Classic dates and times

```tiko
{{#include ../examples/ch31/classic-dates.bas}}
```

```text
{{#include ../examples/ch31/classic-dates.out}}
```

The classic date functions keep a date as a **`double`**: the whole part counts days from
30 December 1899, and the fraction is the time of day — 0.5 is noon. `#include "datetime.bi"`
declares them, and `#include "vbcompat.bi"` includes that and adds `format`, `dateadd` and
`datediff`, the Visual Basic names.

| Function | Gives |
|---|---|
| `dateserial( y, m, d )`, `timeserial( h, m, s )` | a serial date, or a time to add to one |
| `year`, `month`, `day`, `hour`, `minute`, `second` | the parts of a serial |
| `weekday( d )` | the day of the week, **1 for Sunday** |
| `now` | the current date and time, as a serial |
| `dateadd( unit, n, d )`, `datediff( unit, a, b )` | arithmetic in `"d"`, `"m"`, `"yyyy"` and other units |
| `format( d, pattern )` | text; `"yyyy-mm-dd hh:nn:ss"`, with `nn` for minutes |
| `date`, `time` | the clock as text, `"mm-dd-yyyy"` and `"hh:mm:ss"` |
| `setdate`, `settime` | set the computer's clock |

`setdate` and `settime` change the clock of the whole computer, not just the program's view of
it, and need administrator rights on most systems; the listing does not call them.

```admonish danger title="Pitfall"
**The named formats follow the machine's language.** `format( d, "dddd d mmmm" )` and
`monthname( 3 )` ask the operating system for the names, so the same program prints *Tuesday* on
one computer and *mardi* on another. Use the numeric patterns for anything written to a file.
```

Chapter 25's `std/chrono` is the modern replacement, and the differences are worth knowing when
moving code across: a serial date has no time zone, `dateserial( 2025, 13, 40 )` rolls over into
the next year instead of being refused, `weekday` counts from Sunday where chrono's `DayOfWeek`
counts from Monday, and `DateTime.FromSerial` and `.Serial( )` convert between the two.

## common and chain

```tiko
{{#include ../examples/ch31/common.bas}}
```

```tiko
{{#include ../examples/ch31/common-hit.bas}}
```

```text
{{#include ../examples/ch31/common.out}}
```

**`common shared`** declares a variable that every module of a program can share, by writing the
same `common` line in each. Built together with `tiko common.bas common-hit.bas`, the two modules
use one `hits`. In new code, declare the variable once with `dim shared` in one module and
`extern` in a header the others include, so the compiler checks that every module
agrees on its type.

```tiko
{{#include ../examples/ch31/chain/parent.bas}}
```

```text
{{#include ../examples/ch31/chain/parent.out}}
```

**`chain`** runs another program, waits for it to finish and returns its exit code, or -1 when
the program cannot be started. In QuickBASIC, `chain` with `common` passed variables to the next
program. Here the two programs are separate processes that share nothing: anything one tells the
other goes through the command line, a file or the exit code. **`run`** starts a program and
does not come back. Chapter 24 covers `exec` and `shell`, which do the same with more control.

## What tiko refuses

Each of these compiles in fbc's older dialects and not in `fb`. The table gives the diagnostic tiko
reports and the replacement.

| Classic code | tiko says | Write instead |
|---|---|---|
| `gosub label` … `return` | `TKO0409: 'GOSUB' is not available in the fb dialect` | a `sub`, with what it changed passed `byref` |
| `resume`, `resume next` | `TKO0409: 'RESUME' is not available …` | handle the error where it is caught, or return a `Result` (Chapter 17) |
| `dim count%` | `TKO0320: 'count' has no type …` | `dim as int32 count` — every variable is declared with its type |
| `defint a-z` and the other `def` statements | `TKO0409: 'DEFINT' is not available …` | the same: declare each variable with its type |
| `#lang "qb"` | `TKO0317: unsupported language mode 'qb'` | port the code to `fb` |
| `asm` … `end asm` | `TKO0407: inline assembly is not supported` | a C function (Chapter 28), or compile that module with fbc |
| `10 print "x"` | `TKO0944: a line number is not available in the fb dialect` | labels: `start:` |

```tiko
{{#include ../examples/ch31/gosub.bas}}
```

```text
gosub.bas(3,7): error TKO0409: 'GOSUB' is not available in the fb dialect
```

`gosub` jumps to a label and `return` comes back to the line after the `gosub`. It is a
subroutine without parameters or local variables, so everything it touches is shared with its
caller, and it ends wherever a `return` happens to be. Exercise 1 rewrites the listing with a
`sub`: the variable the subroutine changed becomes a `byref` parameter.

```tiko
{{#include ../examples/ch31/suffix.bas}}
```

```text
suffix.bas(2,5): warning TKO0206: suffix ignored in 'count%'
suffix.bas(3,1): warning TKO0206: suffix ignored in 'count%'
suffix.bas(4,7): warning TKO0206: suffix ignored in 'count%'
suffix.bas(2,5): error TKO0320: 'count' has no type; tiko-lang implements
#lang "fb" only, where default types and suffixes are not valid
```

(Again one line.) The warnings are each `%` being thrown away; the error is what stops the build,
because without its suffix `count` has no type at all.

In the old dialects a **suffix** gave a variable its type — `%` an integer, `&` a long, `!` a
single, `#` a double, `$` a string — and `defint`, `deflng`, `defsng`, `defdbl` and `defstr` set a
type for every name starting with given letters. In `fb` every variable is declared, with its
type, before it is used; a typo then becomes an error instead of a new, empty variable.

```tiko
{{#include ../examples/ch31/asm.bas}}
```

```text
asm.bas(7,5): error TKO0407: inline assembly is not supported; compile that module with fbc
```

tiko produces LLVM's intermediate form, not assembly text, so there is nowhere for written
assembly to go. A routine that needs particular instructions can be written in C, where clang's
intrinsics reach them, and called through Chapter 28's interface — or that one module can be
compiled with fbc and linked in.

Several more classic statements are refused in the `fb` dialect — by fbc with its error 146,
"only valid in -lang deprecated or fblite or qb", and by tiko with `TKO0409` naming the keyword:
**`let`** in front of an assignment, **`call`** in front of a procedure call, **`lprint`** to the
printer, the **`option`** statements (`option explicit`, `option base`), `on n gosub`, and the
**`'$` metacommands** (`'$include`, `'$dynamic`, `'$static`). Drop `let` and
`call` — `k = 5` and `Hello( )` say the same — open the printer as a file to print to it,
`#include` a file, and give arrays explicit bounds.

```tiko
{{#include ../examples/ch31/let.bas}}
```

```text
let.bas(3,1): error TKO0409: 'LET' is not available in the fb dialect
```

`let` is still a keyword of the `fb` dialect in one place: `let ( a, b ) = t` assigns a type's
fields to several variables at once, and that form compiles.

## Bringing old code across

A QuickBASIC or `fblite` program comes across in the same few steps, most of them mechanical:

1. **Declare every variable**, with its type. The suffixes and `defint` lines tell you which type
   each one had.
2. **Replace numbered lines with labels**, and delete the numbers that nothing jumps to.
3. **Turn each `gosub` subroutine into a `sub` or `function`**, passing what it reads and changes.
4. **Drop `let` and `call`**; replace `'$include` with `#include` and `option base 1` with
   explicit bounds.
5. **Replace `on error … resume` with structured handling**, where the error is caught by the code
   that can do something about it.
6. **Compile with `-exx`** (Chapter 30) and run the program's tests, so an index out of bounds
   stops the program at the line that caused it.

Then, when the program works, the modern forms in this chapter's notes — arrays for `data`,
`select case` for `on goto`, `std/chrono` for serial dates — can come in one at a time.

## What it costs

- **Each `read` converts one item** to the variable's type.
- **Serial dates are `double`s**: cheap to store, and precise to about a millisecond for present-day
  dates.
- **`chain` starts a whole new process**, which costs milliseconds; calling a procedure costs
  nanoseconds.

## Summary

- tiko implements the `fb` dialect only: `#lang "qb"` and the rest are `TKO0317`.
- `data`, `read` and `restore [label]` keep a table in the program; nothing checks its types.
- `goto label` and `on n goto a, b, c`; an index out of range falls through.
- `datetime.bi` and `vbcompat.bi`: serial dates as `double`s, `weekday` from Sunday, `format`
  with numeric patterns for anything stored.
- `common shared` shares a variable between modules; `chain` runs a program and returns its exit
  code, sharing nothing.
- Refused: `gosub`, `resume`, `let`, `call`, `lprint`, `option`, `defint` and the `'$`
  metacommands (`TKO0409`), suffixes (`TKO0320`), `asm` (`TKO0407`), other dialects (`TKO0317`)
  and numbered lines (`TKO0944`).

## Exercises

1. Rewrite `gosub.bas` without `gosub`, so that it compiles. {solution="ex31-01"}
2. Read a price list from `data` statements until a sentinel item `"END"`, printing each line and
   the total. {solution="ex31-02"}
3. Rewrite `menu.bas` with `select case`. Which version makes it easier to see that every branch
   ends?
4. Rewrite `quiz-data.bas` so the questions live in an array of a `type` with two fields,
   initialised with `= { … }`. What can the compiler now check that it could not before?
5. Write `classic-dates.bas` again with `std/chrono` (Chapter 25), and compare the weekday each
   prints for 4 March 2025.
