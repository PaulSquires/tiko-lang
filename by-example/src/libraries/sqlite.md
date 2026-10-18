# SQLite

SQLite is a database in a library: no server, one file per database, or none
at all for a database in memory. tiko ships it as the vendor package
`vendor/sqlite3`, and what you call is SQLite's own C interface, written the
way SQLite's documentation writes it.

```tiko
{{#include ../../examples/libraries/sqlite.tiko}}
```

**Output**

```text
{{#include ../../examples/libraries/sqlite.out}}
```

A connection is a **`sqlite3 ptr`**, which `sqlite3_open` fills in through its
address, `@db`. The name `:memory:` opens a private database that lasts as
long as the connection; any other name is a file, created if it does not
exist. `sqlite3_close` closes it.

Almost every function returns a **result code**: `SQLITE_OK` for success, and
anything else is a failure that `sqlite3_errmsg( db )` explains. Nothing raises
a runtime error, so an ignored code is an ignored failure.

- **`sqlite3_exec`** runs SQL that returns no rows; several statements may be
  given at once, separated by `;`.
- **`sqlite3_prepare_v2`** compiles a query into a `sqlite3_stmt ptr`.
  **`sqlite3_step`** returns `SQLITE_ROW` for each row and `SQLITE_DONE` at the
  end; `sqlite3_column_int64`, `sqlite3_column_text` and their siblings read the
  row's columns, counting from 0. **`sqlite3_finalize`** frees the statement.

`sqlite3_column_text` returns a pointer to UTF-8 bytes that SQLite owns, valid
until the next step. `ColumnText` copies them into a `ustring` straight away.

Building the program copies SQLite's shared library beside it, so the two run
wherever they travel together. `#import "vendor/sqlite3" link static` links
SQLite into the program itself instead. Other C libraries are reached the same
way; see [Calling C](../ffi/index.md).

### Activities

1. Add a fourth city and print only the cities with more than 12 million
   people.
2. Change `:memory:` to `cities.db`, run the program twice, and explain the
   second run's output.
