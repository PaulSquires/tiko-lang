# Capstone: a TUI Ledger

The last capstone is **`tledger`**, a personal ledger: the money that came in and went out, kept
in a database, loaded from a bank's CSV export, shown and edited on terminal screens, and summed
into a monthly report. It joins the parts of the book that deal with real data:

- `Decimal` for money that must be exact (Chapter 27);
- `LocalDate` for days (Chapter 26);
- SQLite through `vendor/sqlite3` (Chapter 28), and CSV through `strings.SplitCsv` (Chapter 9);
- an `OrderedMap` for the report (Chapter 24);
- the TUI library for the screens (Chapter 28);
- modules and a package to hold it together (Chapter 15).

## The specification

```text
tledger [--import file.csv]... [--list | --report] ledger.db
```

- **The ledger** is one SQLite file. Each transaction has a date, a payee, a category and an
  amount: positive for money in, negative for money out. `:memory:` gives a ledger that
  disappears when the program ends.
- **`--import file.csv`** loads a bank export with a `date,payee,category,amount` header, and may
  be given more than once. **All or nothing:** if any record is wrong, none of the file is kept,
  and every wrong record is reported with its number in the file. The file can then be fixed and
  loaded again without making duplicates. Blank lines are skipped, and a file with no records
  imports nothing, without complaint.
- **`--list`** prints every transaction, oldest first. **`--report`** prints income, spending and
  net for each month, and the totals. Asking for both is a mistake.
- With neither, **the screens** open: a table of transactions, a form for a new one, and the
  monthly report. F1, F2 and F3 switch between them, and Esc leaves.
- Amounts print as `$1,234.56`, the same on every machine, whatever its locale.
- **Exit code:** 0; 1 if an import was refused; 2 for a bad command line, a ledger that cannot
  be opened, or no terminal to open the screens on.

## The layout

```text
ch35/
    tiko.toml           the package
    ledger/ledger.tiko  the data: model, storage, import, report -- and all of the SQL
    ui/ui.tiko          the screens: a TuiApp
    tledger.tiko        the program: the command line, the text output, the exit code
    screens.tiko        the screens driven by a script, with no terminal
    schema.tiko         migrations, run twice
    bank.csv, bad.csv   a bank export, and one with mistakes in it
```

The split follows the rule from Chapter 33, with one more reason behind it. **`ledger` is the
only file that imports `vendor/sqlite3`, and nothing from SQLite is public**: the rest of the
program sees transactions and totals, never a `sqlite3 ptr` or a statement. Swapping SQLite for
something else would change one file.

## The model

```tiko
{{#include ../examples/ch35/ledger/ledger.tiko:head}}
```

```tiko
{{#include ../examples/ch35/ledger/ledger.tiko:model}}
```

A `Txn` holds its money as a **`Decimal`**, never as a `float64`. `0.1 + 0.2` is not `0.3` in
binary floating point (Chapter 27), and a ledger that is a cent out after a year of additions is
wrong. The date is a **`LocalDate`**: a calendar day, with no time and no zone, which is all a
bank statement says. `MonthTotals` is one row of the report. `MonthMap` names the generic the
report fills, so the screens and the program can write it without repeating its type arguments.

### One check for every way in

```tiko
{{#include ../examples/ch35/ledger/ledger.tiko:parse}}
```

Text becomes a transaction in **one place**. The import calls `ParseTxn` for each line of the
CSV, and the entry form calls it for what was typed. The two can never disagree about what a
valid transaction is. It refuses a date that does not exist (`LocalDate.TryParseIso` knows that
April has thirty days) or is not written `YYYY-MM-DD`, an empty payee, and an amount that is not a
number or has more than two decimal places. `TryParseIso` also reads the compact ISO form,
`20260105`, so the dashes are checked first: a ledger keeps one spelling of a date, and the
message promises that one. A Decimal keeps the scale it was written with, so `Scale( )` says how many places
the text had. Categories are folded to lower case, so `Food` and `food` are one category.

## Storage

```tiko
{{#include ../examples/ch35/ledger/ledger.tiko:open}}
```

The module keeps **one database for the whole program**, a connection in a module variable,
and four small procedures that every other part of the module goes through:

```tiko
{{#include ../examples/ch35/ledger/ledger.tiko:conn}}
```

The variable is `private` for a reason that goes beyond tidiness. A module's interface describes
its module-level variables to the files that import it, so that a generic's body can use them. A
variable that is not `private` would put `sqlite3 ptr` into that description, and SQLite would
reach every importer. That is exactly what the module exists to prevent. `private` keeps the
variable, and its type, inside the module.

The four procedures turn SQLite's C conventions into the module's own. SQLite reports a failure
as a result code and keeps the reason on the connection; every procedure here returns `""` or
that reason, as text, so the callers read like the rest of the program. **`RunSql`** runs SQL that
returns no rows, **`Prepare`** compiles a statement, **`LastError`** fetches the reason, and
**`ColText`** reads a column back as a `ustring`. (`Exec` and `Field` would have been shorter
names, and both are taken: tiko predeclares `field` and `exec`, and declaring either as these
procedures are is an error, `TKO0600` and `TKO0793`.)

Text crosses in UTF-8 both ways. A `ustring` passed where SQLite's C wants `const char *` is
converted to UTF-8 for the call, so `RunSql` hands its `ustring` straight to `sqlite3_exec`.
Coming back, `sqlite3_column_text` points at UTF-8 bytes SQLite owns; `ColText` copies them into a
`string`, and a `string` assigned to a `ustring` is read as UTF-8.

### The schema, and migrations

```tiko
{{#include ../examples/ch35/ledger/ledger.tiko:schema}}
```

A program that keeps data outlives the first version of its schema. **Migrations** are how it
changes without losing what is already stored. Each version is one step, applied in order, and
the database remembers how far it has got.

SQLite keeps a number for exactly that purpose: **`pragma user_version`**, an integer in the
database file's header that SQLite itself never uses. A new file has 0. `Migrate` reads it, runs
every step above it, and sets it after each one, inside the same transaction. A step that fails
rolls back with its version number, so the file is always at a version that completed. A file
whose version is above the program's is refused: it was written by a newer `tledger`, and this
one cannot know what the newer steps did.

Reading the version is also the first time SQLite looks inside the file. `sqlite3_open` succeeds
on any file, because SQLite reads nothing until it must, so a ledger path that names a text file fails
here, and `Migrate` returns SQLite's own reason: `tledger notes.txt` prints
`tledger: notes.txt: file is not a database` and exits with 2. `SchemaVersion`, the public
question, says -1 for the same file.

Every statement in a step is checked, `begin` and `commit` included: they are SQL like the step
itself, run by `RunSql`. On any failure the step runs `rollback`, which undoes whatever it had
done. `commit` can fail too — a file locked by another program refuses it — and then the
transaction is still open, which is why the `rollback` follows a failed `commit` as well.

The rule that makes this work is in the comment: **a step that has shipped is never edited.**
Version 2 here added an index. Adding a column next year is a version 3 that says
`alter table txn add column …`. Editing step 1 instead would change nothing in every database
that has already run it.

```tiko
{{#include ../examples/ch35/schema.tiko}}
```

```text
{{#include ../examples/ch35/schema.out}}
```

### Rows in and out

```tiko
{{#include ../examples/ch35/ledger/ledger.tiko:store}}
```

Two storage decisions are deliberate:

- **Dates are ISO text**, `2026-01-05`. They sort as text in date order, so `order by day` needs
  nothing else. A month is the first seven characters.
- **Amounts are the Decimal's own text**, `-1450.00`, which is exact. SQLite could store a number
  instead, but its `sum( )` would add in binary floating point, and the exactness the model
  bought would be lost at the last step. So SQL stores and sorts, and arithmetic happens in the
  program, in Decimal.

Every value travels as a `?` parameter (Chapter 28), so a payee called `O'Brien` is just text.
Nothing is pasted into SQL. Each statement is finalized by a `defer` written straight after it is
prepared (Chapter 22), so every `return` below it, the early ones included, frees it.
`ListTxns` keeps `sqlite3_step`'s last result: a loop that stops at anything but `SQLITE_ROW`
would otherwise treat a failure halfway through as the end of the rows.

## Importing a bank's CSV

```tiko
{{#include ../examples/ch35/ledger/ledger.tiko:import}}
```

`ImportCsv` reads the file's bytes whole, and **`strings.SplitCsv`** (Chapter 9) does the
parsing: quoted fields such as `"Smith, Jones & Co"`, doubled quotes, either kind of line ending.
The header row says which column is which, so a bank that puts `amount` first still loads.
`AddRecords` then sends every record through `ParseTxn` and inserts the good ones, all inside one
**transaction**. If any record was refused, it runs `rollback`, and the ledger is exactly as it
was.

Three cases are easy to miss:

- **A blank line**, most often the last one, is a record whose fields are all empty. It is not
  a mistake, so it is skipped rather than refused as `'' is not a date`.
- **A file with no records** — a header alone, or an empty file — gives `SplitCsv` fewer than two
  rows, and `ImportCsv` returns before starting a transaction, so the program reports
  `imported 0 transactions` either way.
- **The number in a message** is the record's: row 0 is the header, record 1 of the file, so row
  `r` is record `r + 1`. That is the line number for every file a bank exports. A quoted field may
  hold a line break, though, and then every record after it sits further down the file than its
  number says.

```text
{{#include ../examples/ch35/bank.csv}}
```

## The report

```tiko
{{#include ../examples/ch35/ledger/ledger.tiko:report}}
```

`MonthlyReport` reads every transaction, and `SumByMonth` adds each to its month, as income or as
spending. The two are separate so that the screens, which already hold the list, can sum it
without reading the ledger again. **`months[ key ]`** creates a zero `MonthTotals` the first time a month is seen, as a `Map` does.
Because the map is an **`OrderedMap`**, iterating it visits the keys in sorted order. `YYYY-MM`
sorts as the calendar does, so the months come out in order without a separate sort.

**`MoneyFormat`** turns a Decimal into money text. By default it follows the user's locale:
symbol, separators, grouping, and where the minus sign goes. That is right for a program showing a
person their own money, and wrong for a book whose output must be the same on every machine. So
`FormatMoney` sets every field itself. To follow the locale instead, leave the fields unset.

```admonish danger title="Pitfall"
`Grouping` is a list of group sizes, read from the right, and it does not repeat by itself.
`"3"` makes one group of three and stops, so `-1234567.89` prints as `-$1234,567.89`: every
amount under a million looks right, and the first large one does not. A trailing 0 means
"repeat the last size", so `"3;0"` gives `-$1,234,567.89`, and the Indian `"3;2;0"` gives
`-$12,34,567.89`.
```

## The screens

```tiko
{{#include ../examples/ch35/ui/ui.tiko:head}}
```

```tiko
{{#include ../examples/ch35/ui/ui.tiko:app}}
```

`LedgerApp` is a `TuiApp` (Chapter 28): `Init`, `Update` and `View`. Its fields are **everything
the screens show**: which page is up, the transactions, the report's months, the table's
selection, the four fields of the form, and the status line. `Update` changes them and draws
nothing. `View` draws from them and reads nothing else, not even the database: `Reload` reads the
ledger once, and sums the report from the list it read, so a frame costs no query. That separation
is what lets the screens be tested without a terminal, below.

`View` does write one thing back. `TuiTable.Render` keeps the selection inside the rows that
exist and moves `listState.offset`, the first row shown, so that the selected row stays in view.
That has to happen while drawing, because only then is the table's height known. It is state the
table owns, and the app only stores it.

### Update

```tiko
{{#include ../examples/ch35/ui/ui.tiko:update}}
```

F1, F2 and F3 work everywhere. Esc goes back to the list, or quits from the list. On the list, Up
and Down move the selection, clamped to the rows that exist. On the form, Tab moves between the
fields and Enter saves. Every other key goes to the field that has the focus.

So does a **paste**. `TuiTermOptionsDefault` asks the terminal for bracketed paste, and on a
terminal that has it, pasted text arrives as one `TUIEVENT_PASTE` event carrying all of it, not as
a run of keys. An `Update` that looks only at `TUIEVENT_KEY` drops every paste without a sound, so
this one sends a paste on the form to the focused field, and ignores it on the other pages.

A widget is a value. `Edit` makes a `TuiTextInput` over the state of the focused field, hands it
the event, and lets it go. The text, the cursor and the scroll live in the `TuiTextInputState`,
which the app owns. Two details are worth knowing:

- **`isFocused` must be set**, or the input ignores the event.
- **A box that has never been drawn does not know how wide its field is**, so it scrolls the text
  as if the field were one column wide. Setting `scrollX` back to 0 leaves the scrolling to the
  next frame's box, which is drawn into a real area and knows.

`Save` sends the four fields through `ledger.ParseTxn`. If they are refused, the message goes into
the status line and the form stays, so the mistake can be fixed. If they are accepted, the list is
reloaded and the new row is selected.

### View

```tiko
{{#include ../examples/ch35/ui/ui.tiko:view}}
```

Three bands: the page tabs, the page, and a status line. Each page is a procedure:

```tiko
{{#include ../examples/ch35/ui/ui.tiko:list}}
```

**A table leaves no gap between its columns**, so the widths leave one: the date is 10 characters
in a column of 11, the category starts with a space, and `RightIn` always puts at least one space
in front of what it aligns. Amounts are right-aligned with `MoneyCell`, so their decimal points
line up for any amount of up to one character less than the column: 12 characters in the list's
13, which is `-$999,999.99`. A longer one is cut off, and ends in `...`. The report has more
room, and gives its amounts 15 columns, as does the text that `--list` and `--report` print.

```tiko
{{#include ../examples/ch35/ui/ui.tiko:entry}}
```

```tiko
{{#include ../examples/ch35/ui/ui.tiko:reportview}}
```

### Testing the screens without a terminal

`TuiRun` needs a real terminal, and a test has none. But a frame depends only on the app's state,
and the state changes only through `Update`, apart from the table's scroll offset, which
rendering itself moves. So a test can feed `Update` the events a person would cause, render with
`TuiRenderOnce`, and print the screen:

```tiko
{{#include ../examples/ch35/screens.tiko}}
```

```text
{{#include ../examples/ch35/screens.out}}
```

The first frame is the list, three rows down. The second is the form after a first attempt with
the 32nd of March: the status line says why, and the text is still there, the pasted payee with
the rest. The third is the
list after the date was corrected, with the new row at the bottom and selected (15 of 15). The last
is the report, which now includes the coffee.

## The program

```tiko
{{#include ../examples/ch35/tledger.tiko}}
```

The program reads like the specification: arguments, opening the ledger, each import in order
with its problems on stderr, then `--list`, `--report` or the screens. Asking for both `--list`
and `--report` is refused rather than letting the last one win, because a person who typed both
expected both. `ledger.OpenLedger` runs the migrations, so a new file needs no separate set-up
step.

## Running it

Run from the chapter's directory as `tledger --import bank.csv --report :memory:`:

```text
{{#include ../examples/ch35/tledger.out}}
```

A file with mistakes is refused whole, with a reason for each line, and the exit code is 1:

```text
{{#include ../examples/ch35/bad.csv}}
```

```text
$ tledger --import bad.csv --list :memory:
tledger: bad.csv:3: '2026-04-31' is not a date (YYYY-MM-DD)
tledger: bad.csv:4: the payee is empty
tledger: bad.csv:5: '-12.505' has more than two decimal places
tledger: bad.csv: nothing imported
exit 1
```

Line 2 was valid, and it was not kept either: the list prints nothing. With `--list` and the good
file:

```text
$ tledger --import bank.csv --list :memory:
imported 14 transactions from bank.csv
2026-01-02  Harbour Property Management rent             -$1,450.00
2026-01-05  Northwind Ltd               salary            $3,200.00
2026-01-09  Corner Grocer               food                -$86.42
…
2026-03-12  Corner Grocer               food                -$93.27
```

Given a file name instead of `:memory:`, the ledger persists, and `tledger ledger.db` opens the
screens on it.

## Shipping

`ledger` imports SQLite with **`link static`**, so SQLite's code is linked into the program:
on Windows, `tledger.exe` imports nothing but `KERNEL32.dll` and the C runtime, `ucrtbase.dll`.
`tledger` is one executable with no database server and no shared library to install. Copy it,
and it runs. Without `link static`, `vendor/sqlite3` links SQLite's shared library and copies it
beside the program, and the two would have to travel together. The ledger is one ordinary file,
which can be backed up by copying it while the program is not running, or at any time with SQL's
`vacuum into 'copy.db'`.

`#foreignlib` (Chapter 30) is for the other case: a library the **project** ships, beside its
sources, one file per platform. SQLite does not need it, because the toolchain's vendor package
already carries it.

## What it costs

- **The report reads every transaction** and adds in the program. For a personal ledger — some
  thousands of rows a year — that is nothing. For millions, store amounts as integer cents, so that
  SQL's `sum( )` stays exact, and let the database group by month.
- **The list loads every transaction** into memory, and the screens draw only what fits. A very
  large ledger would query one screenful at a time with `limit` and `offset`.
- **One database per program**, in a private module variable. That keeps SQLite out of every
  other file, at the price of not opening two ledgers at once.
- **All-or-nothing imports** make the user fix a file before any of it counts. That is the safe
  choice for money: a half-imported statement is worse than none.

## Summary

- Keep a library you may want to replace, such as SQLite, in **one module**. Make nothing from
  it public, and make module variables of its types `private`, so that it stays out of the
  interface. A few procedures that turn its C conventions — result codes, UTF-8 text — into the
  module's own keep the rest of the module readable.
- Hold money in `Decimal` and days in `LocalDate`. Store them as text that sorts and round-trips
  exactly, and do the arithmetic in the program.
- Migrate with `pragma user_version`: one step per version, one transaction per step, and never
  edit a step that has shipped.
- Import through a staging table and one transaction, validate every row with the same function
  the form uses, and roll back on any error. Skip blank records, treat a file with none as
  empty, and check the result of `begin` and `commit` as well as of each statement.
- An `OrderedMap` keyed `YYYY-MM` gives a monthly report in calendar order. `MoneyFormat` with
  every field set prints money the same way everywhere, and its `Grouping` must end in `;0` to
  repeat.
- Give every column at least one space and enough width for the amounts it will hold, and say
  what that limit is.
- A `TuiApp` whose `View` only draws, from state that `Update` and `Reload` fill, can be tested by
  feeding `Update` events and rendering with `TuiRenderOnce`. Route `TUIEVENT_PASTE` as well as
  keys to a text input.

## Exercises

1. Print the spending in each category over the whole ledger, the largest first.
   {solution="ex35-01"}
2. Accept a quick-entry line, `date;payee;category;amount`, and check it with `ParseTxn`.
   {solution="ex35-02"}
3. Add a migration, version 3, that adds a `note` column, and a fifth field to the form for it.
   Open a version 2 file and check that it is upgraded and keeps its rows.
4. Refuse an import line that is already in the ledger (same date, payee and amount), so that
   loading the same statement twice adds nothing. Compare only with the rows that were there
   before this import began: two identical lines in one statement, such as two coffees on the
   same day, are both real.
5. Add a fourth screen that shows the transactions of the month selected in the report.
