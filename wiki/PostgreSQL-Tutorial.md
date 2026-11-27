[Home](Home) › [Using C Libraries](Using-C-Libraries-Tutorial) › **PostgreSQL**

# PostgreSQL Tutorial

> 📘 **Start with:** [Vendor Packages](Vendor-Packages), what a vendor package is and how `link static` and `link dynamic` work.
>
> 📖 **In the book:** [Chapter 28, Database servers](https://tiko-lang.net/book/ch28-logging-tui-sqlite.html#database-servers-postgresql-and-mysql). Measured with libpq from PostgreSQL 19.0 and tiko, against a PostgreSQL 14 server, on Windows and Linux.

[PostgreSQL](https://www.postgresql.org) is an SQL database server. A program talks to it over the network through **libpq**, PostgreSQL's own client library in C, which every other PostgreSQL driver is measured against.

tiko ships libpq as a [vendor package](Vendor-Packages), with OpenSSL inside it for encrypted connections. One line gives a program libpq's whole C API and links the library:

```freebasic
#import "vendor/libpq"
```

There is nothing to download, no header to translate, no `#foreignlib` and nothing on the command line. The names are the ones [libpq's documentation](https://www.postgresql.org/docs/current/libpq.html) uses -- `PQconnectdb`, `PQexecParams`, `PQgetvalue`, `PQclear`, `PQfinish`. More programs are in the toolchain's `examples/libpq`.

You need a PostgreSQL server to talk to, and an account on it. Every program here takes libpq's **connection string** as its first argument: keyword=value pairs such as `"host=db.example.com dbname=app user=app password=secret"`, or a URI, `"postgresql://app:secret@db.example.com/app"`.

---

## 1. A first program

The program connects, creates a table, inserts three rows and reads them back:

```freebasic
'' PostgreSQL from tiko: connect, create a table, insert with
'' parameters, read the rows back.
''     pgfirst "host=localhost dbname=app user=app password=secret"
#import "vendor/libpq"

dim as string conninfo = command( 1 )
dim as PGconn ptr c = PQconnectdb( conninfo )
if PQstatus( c ) <> CONNECTION_OK then
    print "cannot connect: "; *PQerrorMessage( c )
    PQfinish( c )        ' a failed connection is freed too
    end 1
end if

'' SQL with no parameters and no rows: PQexec.
dim as PGresult ptr r = PQexec( c, _
    "create temp table book (id serial primary key, " & _
    "title text not null, year int)" )
if PQresultStatus( r ) <> PGRES_COMMAND_OK then
    print *PQresultErrorMessage( r )
end if
PQclear( r )

'' Values travel beside the SQL as $1, $2 -- never inside it.
'' A nullptr value is SQL's NULL.
dim as string titles( 0 to 2 ) = { "Dune", "Café Society", "It's Here" }
dim as string years( 0 to 2 ) = { "1965", "2016", "" }
dim as const zstring ptr vals( 0 to 1 )
for i as int32 = 0 to 2
    vals( 0 ) = strptr( titles( i ) )
    vals( 1 ) = nullptr
    if len( years( i ) ) then vals( 1 ) = strptr( years( i ) )
    r = PQexecParams( c, _
        "insert into book (title, year) values ($1, $2)", _
        2, nullptr, @vals( 0 ), nullptr, nullptr, 0 )
    if PQresultStatus( r ) <> PGRES_COMMAND_OK then
        print *PQresultErrorMessage( r )
    end if
    PQclear( r )
next

'' A result is rows by columns of text; PQgetisnull tells NULL apart.
r = PQexec( c, "select id, title, year from book order by id" )
for row as int32 = 0 to PQntuples( r ) - 1
    dim as string year = "unknown"
    if PQgetisnull( r, row, 2 ) = 0 then year = *PQgetvalue( r, row, 2 )
    print *PQgetvalue( r, row, 0 ); ". "; *PQgetvalue( r, row, 1 ); _
          " ("; year; ")"
next
PQclear( r )
PQfinish( c )
```

```
1. Dune (1965)
2. Café Society (2016)
3. It's Here (unknown)
```

- **`PQconnectdb` always returns a connection**, also when it failed. `PQstatus` says which, `PQerrorMessage` says why, and `PQfinish` frees it either way.
- **`PQexec`** runs SQL with no values from outside the program. Every result, an error's too, is a `PGresult ptr` that `PQclear` frees; `PQresultStatus` says what it is: `PGRES_COMMAND_OK` for a statement that returns no rows, `PGRES_TUPLES_OK` for one that does, `PGRES_FATAL_ERROR` for a failure.
- **`PQexecParams`** is how values go in: `$1`, `$2` in the SQL, and an array of `const zstring ptr` beside it, one per parameter, `nullptr` for SQL's `NULL`. The values never become SQL text, so a quote in a title changes nothing.
- **A result is rows by columns**, `PQntuples` by `PQnfields`, each value text from `PQgetvalue( r, row, column )`. A `NULL` comes back as an empty string, so `PQgetisnull` is what tells it apart. A value lives as long as its `PGresult`: copy it before `PQclear`.
- **Text is UTF-8**, as long as the database's encoding is UTF8 (the usual one). Keep it in a `string`, and assign a `ustring` to a `string` before passing it.

## 2. Transactions and errors

A transaction makes several statements one: `begin`, then `commit` to keep all of them or `rollback` to keep none. This program moves money between two accounts, and a `check` constraint refuses to let a balance go below zero:

```freebasic
'' A transaction that keeps everything or nothing, and an error told
'' apart by its SQLSTATE.
''     pgtransfer "host=localhost dbname=app user=app password=secret"
#import "vendor/libpq"

dim shared as PGconn ptr c

'' Run one statement with parameters; return its SQLSTATE, "" for success.
function Run1( byval sql as string, byval a as string, _
               byval b as string = "" ) as string
    dim as const zstring ptr vals( 0 to 1 ) = { strptr( a ), strptr( b ) }
    dim as int32 n = iif( len( b ), 2, 1 )
    dim as PGresult ptr r = PQexecParams( c, sql, n, nullptr, _
                                          @vals( 0 ), nullptr, nullptr, 0 )
    dim as string state
    if PQresultStatus( r ) = PGRES_FATAL_ERROR then
        state = *PQresultErrorField( r, PG_DIAG_SQLSTATE )
    end if
    PQclear( r )
    return state
end function

'' Move an amount from one account to another: both updates or neither.
function Transfer( byval src as string, byval dst as string, _
                   byval amount as string ) as string
    PQclear( PQexec( c, "begin" ) )
    dim as string state = Run1( _
        "update account set balance = balance - $2 where name = $1", src, amount )
    if state = "" then
        state = Run1( _
            "update account set balance = balance + $2 where name = $1", dst, amount )
    end if
    PQclear( PQexec( c, iif( state = "", "commit", "rollback" ) ) )
    return state
end function

sub Show( )
    dim as PGresult ptr r = PQexec( c, _
        "select name, balance from account order by name" )
    for row as int32 = 0 to PQntuples( r ) - 1
        print "  "; *PQgetvalue( r, row, 0 ); " "; *PQgetvalue( r, row, 1 )
    next
    PQclear( r )
end sub

c = PQconnectdb( command( 1 ) )
if PQstatus( c ) <> CONNECTION_OK then
    print *PQerrorMessage( c ) : PQfinish( c ) : end 1
end if
PQclear( PQexec( c, "create temp table account (name text primary key, " & _
    "balance numeric(10,2) not null check (balance >= 0))" ) )
PQclear( PQexec( c, _
    "insert into account values ('alice', 100), ('bob', 20)" ) )

print "alice pays bob 30: "; iif( Transfer( "alice", "bob", "30" ) = "", "done", "refused" )
Show( )
'' 23514 is check_violation: alice would go below zero.
dim as string state = Transfer( "alice", "bob", "500" )
print "alice pays bob 500: SQLSTATE "; state; _
      iif( state = "23514", " (a check refused it)", "" )
Show( )
PQfinish( c )
```

```
alice pays bob 30: done
  alice 70.00
  bob 50.00
alice pays bob 500: SQLSTATE 23514 (a check refused it)
  alice 70.00
  bob 50.00
```

The second transfer's first `update` breaks the check, so nothing of it stays. **Test the SQLSTATE**, not the message: `PQresultErrorField( r, PG_DIAG_SQLSTATE )` is a five-character code that every PostgreSQL version and language gives the same (`23514` a check violation, `23505` a duplicate key, `42P01` an unknown table), while the message is translated into the server's language. `PG_DIAG_MESSAGE_PRIMARY`, `PG_DIAG_DETAIL` and `PG_DIAG_HINT` give the parts of the message.

## 3. Loading many rows: COPY

`COPY` streams rows into a table, much faster than an `insert` each:

```freebasic
'' Bulk loading with COPY: thousands of rows in one statement.
''     pgcopy "host=localhost dbname=app user=app password=secret"
#import "vendor/libpq"

dim as PGconn ptr c = PQconnectdb( command( 1 ) )
if PQstatus( c ) <> CONNECTION_OK then
    print *PQerrorMessage( c ) : PQfinish( c ) : end 1
end if
PQclear( PQexec( c, "create temp table reading (at int, celsius real)" ) )

'' The statement answers PGRES_COPY_IN; then the rows go as text, a tab
'' between columns and a newline after each, \N for NULL.
dim as PGresult ptr r = PQexec( c, "copy reading from stdin" )
if PQresultStatus( r ) <> PGRES_COPY_IN then
    print *PQresultErrorMessage( r ) : end 1
end if
PQclear( r )

dim as string chunk
for i as int32 = 1 to 50000
    chunk &= str( i ) & !"\t" & str( 15 + ( i mod 10 ) ) & !"\n"
    if len( chunk ) >= 65536 orelse i = 50000 then
        PQputCopyData( c, strptr( chunk ), len( chunk ) )
        chunk = ""
    end if
next
PQputCopyEnd( c, nullptr )

'' The COPY's own result comes after the data, then a null one.
r = PQgetResult( c )
print *PQcmdStatus( r ); " -- "; _
      iif( PQresultStatus( r ) = PGRES_COMMAND_OK, "ok", *PQresultErrorMessage( r ) )
PQclear( r )
PQclear( PQgetResult( c ) )

r = PQexec( c, "select count(*), min(celsius), max(celsius) from reading" )
print *PQgetvalue( r, 0, 0 ); " rows, "; *PQgetvalue( r, 0, 1 ); _
      " to "; *PQgetvalue( r, 0, 2 ); " degrees"
PQclear( r )
PQfinish( c )
```

```
COPY 50000 -- ok
50000 rows, 15 to 24 degrees
```

After `copy ... from stdin` answers `PGRES_COPY_IN`, `PQputCopyData` sends the data in pieces of any size, and `PQputCopyEnd` ends it. The statement's own result arrives after the data, from `PQgetResult`, which then returns `nullptr`. `copy ... to stdout` is the way out: `PQgetCopyData` returns one row at a time, in a buffer that `PQfreemem` frees.

## 4. Encrypted connections

libpq's default, `sslmode=prefer`, encrypts a connection when the server offers it **and checks nothing**: a server that pretends to be yours is accepted. For a server across a network, say what to check:

```
host=db.example.com dbname=app user=app sslmode=verify-full sslrootcert=ca.crt
```

`verify-full` checks the server's certificate chain against the roots in `sslrootcert` and its name against the host; `sslrootcert=system` uses the operating system's roots instead, for a certificate a public authority issued. `PQsslInUse( c )` says whether the connection is encrypted, and `PQsslAttribute( c, "protocol" )` and `"cipher"` how. OpenSSL is inside `vendor/libpq`: there is nothing else to install or ship.

## 5. More programs

The toolchain's `examples/libpq`, each built with `tiko <name>.tiko`, connect with the connection string in `TIKO_PG_DSN`:

| Folder | Shows |
| --- | --- |
| `01-connect` | connect and check, the server's version, the TLS protocol and cipher, the session's encodings; a connection that fails |
| `02-queries` | parameters and NULL, a result by row and column, a bytea in binary both ways, `PQprepare` / `PQexecPrepared`, a rolled-back transaction, an error's SQLSTATE |
| `03-copy` | `COPY ... FROM STDIN` and `COPY ... TO STDOUT` |
| `04-notify` | `LISTEN` / `NOTIFY` between two connections, with a payload |

## 6. In a project

A [`tiko build`](Category-Tiko-Build) project needs nothing in its `tiko.toml` for libpq: the import says it all. `tiko build`'s `copy_to` copies the shared library along with the program.

## 7. Shipping the program

- **Linked dynamically** (the default): ship the library the build put beside the program -- `libpq.dll` on Windows, `libpq_linux_x86_64.so` on Linux. It is the only file: OpenSSL is inside it.
- **Linked statically** (`#import "vendor/libpq" link static`): the program alone. It grows by about 5 MB on Windows, most of it OpenSSL.

libpq is under the PostgreSQL Licence and OpenSSL under the Apache License 2.0; both texts are in `pkg/vendor/libpq/LICENSE` in the toolchain, to go with a program you distribute.

macOS and Linux on arm64 have no `vendor/libpq` yet.

## 8. Troubleshooting

| Symptom | Cause and fix |
| --- | --- |
| `PQlibVersion( )` reports a version other than 19.0 (Windows) | `libpq.dll` is not beside the program, and Windows found another one on the `PATH` -- PHP, pgAdmin and PostgreSQL's own installers bring one (measured: PHP's, 14.24). Ship the program's own copy beside it |
| the program exits at once with `-1073741515` (Windows) | no `libpq.dll` anywhere Windows looks |
| `connection to server ... failed: Connection refused` | no server listening there: the host, the `port` (5432 by default), or a firewall |
| `password authentication failed for user` | the password, or the server's `pg_hba.conf` does not allow that user from your address |
| `SSL error: certificate verify failed` | `sslrootcert` does not hold the root that signed the server's certificate |
| `server does not support SSL, but SSL was required` | `sslmode=require` or stronger, and the server has TLS off |
| a value that should be `NULL` prints as an empty string | test `PQgetisnull` before `PQgetvalue` |
| `TKO0813: 'run' is already declared` or `'exec'` | a tiko built-in; name the function something else |

---

**Next:** [MySQL and MariaDB](MySQL-Tutorial) · [SQLite](SQLite-Tutorial) · [Vendor Packages](Vendor-Packages)

[Home](Home)
