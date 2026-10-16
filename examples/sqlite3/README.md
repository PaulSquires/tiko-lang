# SQLite examples

SQLite's C interface from tiko, through `vendor/sqlite`, which comes with the toolchain. Each
example is one `.tiko` program, built on its own with `tiko <name>.tiko`.

| Folder | Shows |
| --- | --- |
| `01-quickstart` | SQLite's own first program ([quickstart.html](https://sqlite.org/quickstart.html)): run one statement, print every row through a callback |
| `02-prepared-statements` | prepare, bind, step, read columns and their types, finalize |
| `03-transactions` | a bulk insert with and without a transaction, timed; a rollback |
| `04-functions` | SQL functions written in tiko: a scalar, an aggregate ([appfunc.html](https://sqlite.org/appfunc.html)) |
| `05-blobs` | binary data, bound whole and through incremental BLOB I/O |
| `06-backup` | the online backup API's two examples ([backup.html](https://sqlite.org/backup.html)): save and load an in-memory database, and back up a live one with progress |
| `07-errors` | result codes, extended codes and messages for constraint, SQL and open failures |

`01-quickstart` takes a database and a statement:

```
quickstart :memory: "select 1 as one, 'two' as two, null as three"
```

## Dynamic or static

Every example imports SQLite with

```
#import "vendor/sqlite" link dynamic
```

which links the shared library and copies it beside the program -- `sqlite3.dll` on Windows,
`sqlite3_linux_x86_64.so` on Linux, where the program finds it beside itself. Change `dynamic` to
`static` and SQLite is built into the program instead, with nothing to copy. The mode is part of
the source, not a command-line switch: what a program imports is fixed by its text and its target.

Each example prints the same either way, on Windows and on Linux.

These examples are public domain, as SQLite is.
