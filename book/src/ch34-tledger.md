# Capstone: a TUI Ledger

The last capstone is **`tledger`**, a personal ledger: the money that came in and went out, kept
in a database, loaded from a bank's CSV export, shown and edited on terminal screens, and summed
into a monthly report. It joins the parts of the book that deal with real data:

- `Decimal` for money that must be exact (Chapter 26);
- `LocalDate` for days (Chapter 25);
- SQLite through `db/sqlite`, and CSV through the same module (Chapter 27);
- an `OrderedMap` for the report (Chapter 23);
- the TUI library for the screens (Chapter 27);
- modules and a package to hold it together (Chapter 14).

## The specification

```text
tledger [--import file.csv]... [--list | --report] ledger.db
```

- **The ledger** is one SQLite file. Each transaction has a date, a payee, a category and an
  amount: positive for money in, negative for money out. `:memory:` gives a ledger that
  disappears when the program ends.
- **`--import file.csv`** loads a bank export with a `date,payee,category,amount` header, and may
  be given more than once. **All or nothing:** if any line is wrong, none of the file is kept,
  and every wrong line is reported with its line number. The file can then be fixed and loaded
  again without making duplicates.
- **`--list`** prints every transaction, oldest first. **`--report`** prints income, spending and
  net for each month, and the totals.
- With neither, **the screens** open: a table of transactions, a form for a new one, and the
  monthly report. F1, F2 and F3 switch between them, and Esc leaves.
- Amounts print as `$1,234.56`, the same on every machine, whatever its locale.
- **Exit code:** 0; 1 if an import was refused; 2 for a bad command line or a ledger that cannot
  be opened.

## The layout

```text
ch34/
    tiko.toml           the package
    ledger/ledger.tiko  the data: model, storage, import, report -- and all of the SQL
    ui/ui.tiko          the screens: a TuiApp
    tledger.tiko        the program: the command line, the text output, the exit code
    screens.tiko        the screens driven by a script, with no terminal
    schema.tiko         migrations, run twice
    bank.csv, bad.csv   a bank export, and one with mistakes in it
```

The split follows the rule from Chapter 32, with one more reason behind it. **`ledger` is the
only file that imports `db/sqlite`, and nothing from SQLite is public**: the rest of the program
sees transactions and totals, never a `Database` or a `Row`. Swapping SQLite for something else
would change one file.

## The model

```tiko
{{#include ../examples/ch34/ledger/ledger.tiko:head}}
```

```tiko
{{#include ../examples/ch34/ledger/ledger.tiko:model}}
```

A `Txn` holds its money as a **`Decimal`**, never as a `float64`. `0.1 + 0.2` is not `0.3` in
binary floating point (Chapter 26), and a ledger that is a cent out after a year of additions is
wrong. The date is a **`LocalDate`**: a calendar day, with no time and no zone, which is all a
bank statement says. `MonthTotals` is one row of the report. `MonthMap` names the generic the
report fills, so the screens and the program can write it without repeating its type arguments.

### One check for every way in

```tiko
{{#include ../examples/ch34/ledger/ledger.tiko:parse}}
```

Text becomes a transaction in **one place**. The import calls `ParseTxn` for each line of the
CSV, and the entry form calls it for what was typed. The two can never disagree about what a
valid transaction is. It refuses a date that does not exist (`LocalDate.TryParseIso` knows that
April has thirty days), an empty payee, and an amount that is not a number or has more than two
decimal places. A Decimal keeps the scale it was written with, so `Scale( )` says how many places
the text had. Categories are folded to lower case, so `Food` and `food` are one category.

## Storage

```tiko
{{#include ../examples/ch34/ledger/ledger.tiko:open}}
```

The module keeps **one database for the whole program**, in a module variable:

```tiko
private dim shared as sqlite.Database db
```

It is `private` for a reason that goes beyond tidiness. A module's interface describes its
module-level variables to the files that import it, so that a generic's body can use them. A
variable that is not `private` would put `sqlite.Database` into that description, and SQLite
would reach every importer. That is exactly what the module exists to prevent. `private` keeps the
variable, and its type, inside the module.

### The schema, and migrations

```tiko
{{#include ../examples/ch34/ledger/ledger.tiko:schema}}
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

The rule that makes this work is in the comment: **a step that has shipped is never edited.**
Version 2 here added an index. Adding a column next year is a version 3 that says
`alter table txn add column …`. Editing step 1 instead would change nothing in every database
that has already run it.

```tiko
{{#include ../examples/ch34/schema.tiko}}
```

```text
{{#include ../examples/ch34/schema.out}}
```

### Rows in and out

```tiko
{{#include ../examples/ch34/ledger/ledger.tiko:store}}
```

Two storage decisions are deliberate:

- **Dates are ISO text**, `2026-01-05`. They sort as text in date order, so `order by day` needs
  nothing else. A month is the first seven characters.
- **Amounts are the Decimal's own text**, `-1450.00`, which is exact. SQLite could store a number
  instead, but its `sum( )` would add in binary floating point, and the exactness the model
  bought would be lost at the last step. So SQL stores and sorts, and arithmetic happens in the
  program, in Decimal.

Every value travels as a `?` parameter (Chapter 27), so a payee called `O'Brien` is just text.
Nothing is pasted into SQL.

## Importing a bank's CSV

```tiko
{{#include ../examples/ch34/ledger/ledger.tiko:import}}
```

`sqlite.ImportCsv` (Chapter 27) does the reading: quoted fields such as `"Smith, Jones & Co"`,
either kind of line ending, and a table made from the header row. It loads into a **staging table**,
`import_raw`, which is not the ledger. Every staged row then goes through `ParseTxn`, and the good
ones are inserted, all inside one **transaction**. If any line was refused, the transaction rolls
back, and the ledger is exactly as it was. `rowid` numbers the staged rows from 1, and the header
was line 1 of the file, so a row's line number is its `rowid` plus 1.

```text
{{#include ../examples/ch34/bank.csv}}
```

## The report

```tiko
{{#include ../examples/ch34/ledger/ledger.tiko:report}}
```

`MonthlyReport` reads every transaction and adds it to its month, as income or as spending.
**`months[ key ]`** creates a zero `MonthTotals` the first time a month is seen, as a `Map` does.
Because the map is an **`OrderedMap`**, iterating it visits the keys in sorted order. `YYYY-MM`
sorts as the calendar does, so the months come out in order without a separate sort.

**`MoneyFormat`** turns a Decimal into money text. By default it follows the user's locale:
symbol, separators, grouping, and where the minus sign goes. That is right for a program showing a
person their own money, and wrong for a book whose output must be the same on every machine. So
`FormatMoney` sets every field itself. To follow the locale instead, leave the fields unset.

## The screens

```tiko
{{#include ../examples/ch34/ui/ui.tiko:head}}
```

```tiko
{{#include ../examples/ch34/ui/ui.tiko:app}}
```

`LedgerApp` is a `TuiApp` (Chapter 27): `Init`, `Update` and `View`. Its fields are **everything
the screens show**: which page is up, the transactions, the table's selection, the four fields of
the form, and the status line. `View` draws from them and changes nothing, and `Update` changes
them and draws nothing. That separation is what lets the screens be tested without a terminal,
below.

### Update

```tiko
{{#include ../examples/ch34/ui/ui.tiko:update}}
```

F1, F2 and F3 work everywhere. Esc goes back to the list, or quits from the list. On the list, Up
and Down move the selection, clamped to the rows that exist. On the form, Tab moves between the
fields and Enter saves. Every other key goes to the field that has the focus.

A widget is a value. `Update` makes a `TuiTextInput` over the state of the focused field, hands it
the key, and lets it go. The text, the cursor and the scroll live in the `TuiTextInputState`,
which the app owns. Two details are worth knowing:

- **`isFocused` must be set**, or the input ignores the key.
- **A box that has never been drawn does not know how wide its field is**, so it scrolls the text
  as if the field were one column wide. Setting `scrollX` back to 0 leaves the scrolling to the
  next frame's box, which is drawn into a real area and knows.

`Save` sends the four fields through `ledger.ParseTxn`. If they are refused, the message goes into
the status line and the form stays, so the mistake can be fixed. If they are accepted, the list is
reloaded and the new row is selected.

### View

```tiko
{{#include ../examples/ch34/ui/ui.tiko:view}}
```

Three bands: the page tabs, the page, and a status line. Each page is a procedure:

```tiko
{{#include ../examples/ch34/ui/ui.tiko:list}}
```

**A table leaves no gap between its columns**, so the widths leave one: the date is 10 characters
in a column of 11, and the category starts with a space. Amounts are right-aligned with
`MoneyCell`, so their decimal points line up.

```tiko
{{#include ../examples/ch34/ui/ui.tiko:entry}}
```

```tiko
{{#include ../examples/ch34/ui/ui.tiko:reportview}}
```

### Testing the screens without a terminal

`TuiRun` needs a real terminal, and a test has none. But a frame depends only on the app's state,
and the state changes only through `Update`. So a test can feed `Update` the keys a person would
press, render with `TuiRenderOnce`, and print the screen:

```tiko
{{#include ../examples/ch34/screens.tiko}}
```

```text
{{#include ../examples/ch34/screens.out}}
```

The first frame is the list, three rows down. The second is the form after a first attempt with
the 32nd of March: the status line says why, and the typed text is still there. The third is the
list after the date was corrected, with the new row at the bottom and selected (15 of 15). The last
is the report, which now includes the coffee.

## The program

```tiko
{{#include ../examples/ch34/tledger.tiko}}
```

The program reads like the specification: arguments, opening the ledger, each import in order
with its problems on stderr, then `--list`, `--report` or the screens. `ledger.OpenLedger` runs
the migrations, so a new file needs no separate set-up step.

## Running it

Run from the chapter's directory as `tledger --import bank.csv --report :memory:`:

```text
{{#include ../examples/ch34/tledger.out}}
```

A file with mistakes is refused whole, with a reason for each line, and the exit code is 1:

```text
{{#include ../examples/ch34/bad.csv}}
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
2026-01-02  Harbour Property Management rent       -$1,450.00
2026-01-05  Northwind Ltd               salary      $3,200.00
2026-01-09  Corner Grocer               food          -$86.42
…
2026-03-12  Corner Grocer               food          -$93.27
```

Given a file name instead of `:memory:`, the ledger persists, and `tledger ledger.db` opens the
screens on it.

## Shipping

`db/sqlite` links **SQLite itself** into the program. `sqlite3api.bi` says `#inclib "sqlite3"`, and
the toolchain ships `libsqlite3.a` for both windows-x86_64 and linux-x86_64. `tledger` is one
executable with no database server and no shared library to install. Copy it, and it runs. The
ledger is one ordinary file, which can be backed up by copying it while the program is not
running, or at any time with `BackupTo`.

`#foreignlib` (Chapter 28) is for the other case: a library the **project** ships, beside its
sources, one file per platform. SQLite does not need it, because the toolchain already carries it.

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

- Keep a library you may want to replace, such as `db/sqlite`, in **one module**. Make nothing
  from it public, and make module variables of its types `private`, so that it stays out of the
  interface.
- Hold money in `Decimal` and days in `LocalDate`. Store them as text that sorts and round-trips
  exactly, and do the arithmetic in the program.
- Migrate with `pragma user_version`: one step per version, one transaction per step, and never
  edit a step that has shipped.
- Import through a staging table and one transaction, validate every row with the same function
  the form uses, and roll back on any error.
- An `OrderedMap` keyed `YYYY-MM` gives a monthly report in calendar order. `MoneyFormat` with
  every field set prints money the same way everywhere.
- A `TuiApp` whose `View` only draws can be tested by feeding `Update` keys and rendering with
  `TuiRenderOnce`.

## Exercises

1. Print the spending in each category over the whole ledger, the largest first.
   {solution="ex34-01"}
2. Accept a quick-entry line, `date;payee;category;amount`, and check it with `ParseTxn`.
   {solution="ex34-02"}
3. Add a migration, version 3, that adds a `note` column, and a fifth field to the form for it.
   Open a version 2 file and check that it is upgraded and keeps its rows.
4. Refuse an import line that is already in the ledger (same date, payee and amount), so that
   loading the same statement twice adds nothing.
5. Add a fourth screen that shows the transactions of the month selected in the report.
