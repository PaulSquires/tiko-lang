# libpq examples

PostgreSQL from tiko through libpq, PostgreSQL's own C client library, from `vendor/libpq`,
which comes with the toolchain (OpenSSL inside it, for TLS). Each example is one `.tiko`
program, built on its own with `tiko <name>.tiko`.

Every example connects with the libpq connection string in **`TIKO_PG_DSN`**, and says
`skipped` and exits 0 when it is not set:

```
TIKO_PG_DSN="host=localhost dbname=app user=app password=... sslmode=verify-full sslrootcert=ca.crt"
```

Each works in TEMP tables, so it leaves nothing behind in the database.

| Folder | Shows |
| --- | --- |
| `01-connect` | connect and check, the server version, the TLS protocol and cipher, the session's encodings; a connection that fails and where its reason is |
| `02-queries` | `PQexecParams` with parameters (and NULL), a result walked by row and column, a bytea in binary both ways, `PQprepare` / `PQexecPrepared`, a rolled-back transaction, an error's SQLSTATE |
| `03-copy` | `COPY ... FROM STDIN` with `PQputCopyData`, `COPY ... TO STDOUT` with `PQgetCopyData` |
| `04-notify` | `LISTEN` / `NOTIFY` between two connections, with a payload |

## Things to know

- **`PQconnectdb` always returns a connection**, also when it failed: test `PQstatus`, read
  `PQerrorMessage`, and `PQfinish` it either way.
- **Values go in as parameters**, `$1`, `$2` ... with the values beside the SQL
  (`PQexecParams`, `PQexecPrepared`) -- never pasted into the SQL text.
- **Text crosses as UTF-8 bytes** when the session's `client_encoding` is UTF8, the default for
  a UTF8 database: keep it in a `string`, and assign a `ustring` to a `string` first.
- **Test the SQLSTATE, not the message**: `PQresultErrorField( r, PG_DIAG_SQLSTATE )` is a
  five-character code (`23505` unique violation, `42P01` undefined table); the message text is
  translated by the server.
- **What libpq allocates, libpq frees**: `PQclear` for every `PGresult` (an error's too),
  `PQfreemem` for `PQnotifies` records and `PQgetCopyData` buffers. A `PQgetvalue` pointer is
  valid until its `PGresult` is cleared.
- **TLS**: `sslmode=verify-full` checks the server's certificate and name against
  `sslrootcert` (a file, or `system` for the operating system's roots). libpq's default,
  `prefer`, encrypts if it can and checks nothing.
- **`PGnotify` and `pgNotify` are the same record**: tiko's names are case-insensitive.
