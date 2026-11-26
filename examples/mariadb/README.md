# MariaDB / MySQL examples

MySQL and MariaDB servers from tiko through MariaDB Connector/C -- the `mysql.h` client API --
from `vendor/mariadb`, which comes with the toolchain. Each example is one `.tiko` program,
built on its own with `tiko <name>.tiko`.

Every example connects with these environment variables, and says `skipped` and exits 0 when
`TIKO_MYSQL_HOST` is not set:

| Variable | |
| --- | --- |
| `TIKO_MYSQL_HOST` | the server (required) |
| `TIKO_MYSQL_USER`, `TIKO_MYSQL_PASSWORD`, `TIKO_MYSQL_DB` | the account and the database |
| `TIKO_MYSQL_PORT` | optional, 3306 |
| `TIKO_MYSQL_CA` | optional: a CA certificate file; when set the server's certificate is verified against it |

Each works in TEMPORARY tables, so it leaves nothing behind in the database.

| Folder | Shows |
| --- | --- |
| `01-connect` | connect and check, the server's version, the TLS cipher, the character set; a connection that fails and where its reason is |
| `02-queries` | `mysql_real_query`, a result with its field names and types, NULL, a binary column by `mysql_fetch_lengths`, `mysql_insert_id`, escaping with `mysql_real_escape_string`, a rolled-back transaction, an error's number and SQLSTATE |
| `03-prepared` | `mysql_stmt_*`: `MYSQL_BIND` for an integer, a string, a NULL-able double, a DATETIME and a BLOB; one statement run three times; a result fetched into bound variables |

## Things to know

- **`MYSQL` is opaque**: hold the `MYSQL ptr` from `mysql_init`, pass it to every call, and ask
  the API for what it knows (`mysql_get_server_info`, `mysql_error`, `mysql_get_host_info`).
- **`mysql_close` after a failed connect too** -- `mysql_init` allocated the handle.
- **Values go in as prepared-statement parameters** (`03-prepared`). If SQL text must be built,
  `mysql_real_escape_string` is the only safe way to put a string in it.
- **Ask for utf8mb4**: `mysql_optionsv( m, MYSQL_SET_CHARSET_NAME, strptr( "utf8mb4" ) )`
  before connecting. Text then crosses as UTF-8 bytes: keep it in a `string`. (MySQL's `utf8` is
  a three-byte subset.)
- **A binary column's length is `mysql_fetch_lengths`**, not the zstring's: it may hold zero bytes.
- **Test the error number or SQLSTATE**, not the message: `mysql_errno` (1062 duplicate key,
  1146 no such table), `mysql_sqlstate`; a statement's own are `mysql_stmt_errno` /
  `mysql_stmt_error`.
- **TLS**: Connector/C uses it whenever the server offers it, but verifies the certificate only
  when told to: `MYSQL_OPT_SSL_CA` plus `MYSQL_OPT_SSL_VERIFY_SERVER_CERT`.
- **`MYSQL_PORT` is `MYSQL_PORT_2`**: tiko's names are case-insensitive, and mysql.h also has a
  variable `mysql_port`. `MARIADB_PORT` is the same 3306.
