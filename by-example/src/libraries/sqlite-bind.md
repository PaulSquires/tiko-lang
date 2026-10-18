# Prepared statements

A value that comes from outside the program, such as a name typed by a user,
must never be pasted into the text of an SQL statement. It goes in as a
*parameter*: a `?` in the SQL, and a value bound to it separately.

```tiko
{{#include ../../examples/libraries/sqlite-bind.tiko}}
```

**Output**

```text
{{#include ../../examples/libraries/sqlite-bind.out}}
```

A statement is used in four steps:

1. **`sqlite3_prepare_v2`** compiles the SQL once.
2. **`sqlite3_bind_text`**, `sqlite3_bind_int64` and their siblings give a
   value to each `?`, counting from 1.
3. **`sqlite3_step`** runs it. **`sqlite3_reset`** makes it ready to run again
   with new values.
4. **`sqlite3_finalize`** frees it.

```admonish danger title="Pitfall"
**Never build SQL by pasting values into it.** `"... values( '" & name & "' )"`
breaks on `O'Brien's jam`, and lets whoever controls the value rewrite the
query. A bound value travels apart from the SQL and cannot change what it
means.
```

The `-1` in `sqlite3_bind_text` means "the text ends at its zero byte", and
`SQLITE_TRANSIENT` asks SQLite to keep its own copy, which is always safe. A
`ustring` passed where SQLite wants text is converted to UTF-8 for the call.

**A transaction** groups statements: `begin`, then `commit` to keep everything
or `rollback` to undo it. They are SQL like any other, run with
`sqlite3_exec`.

When `sqlite3_exec` is given the address of a `zstring ptr` as its last
argument, SQLite stores its error message there, and the program frees it with
`sqlite3_free`. `Execute` is named so because `run` is already a statement:
a `sub Run` is `TKO0813: 'run' is already declared by the runtime library`.

### Activities

1. Add an `update item set price = ? where name = ?` statement and bind both
   values.
2. Replace the `rollback` with `commit` and check the count again.
