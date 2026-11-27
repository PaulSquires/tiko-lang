[Home](Home) › [Using C Libraries](Using-C-Libraries-Tutorial) › **MySQL and MariaDB**

# MySQL and MariaDB Tutorial

> 📘 **Start with:** [Vendor Packages](Vendor-Packages), what a vendor package is and how `link dynamic` works.
>
> 📖 **In the book:** [Chapter 28, Database servers](https://tiko-lang.net/book/ch28-logging-tui-sqlite.html#database-servers-postgresql-and-mysql). Measured with MariaDB Connector/C 3.4.11 and tiko, against a MySQL 8.0 server, on Windows, Linux (x86-64 and arm64) and macOS.

[MySQL](https://www.mysql.com) and [MariaDB](https://mariadb.org) are SQL database servers that speak the same protocol. A program talks to either through the **`mysql.h` client API**: `mysql_init`, `mysql_real_connect`, `mysql_query`, the `mysql_stmt_*` prepared statements.

tiko ships that API as **`vendor/mariadb`**, MariaDB's Connector/C, a [vendor package](Vendor-Packages). It connects to MariaDB and to MySQL 5.7, 8 and later, with every login method built in: `caching_sha2_password` (MySQL 8's default), `mysql_native_password` and `sha256_password`, and MariaDB's `client_ed25519` and `parsec`. One line gives a program the whole API and links the library:

```freebasic
#import "vendor/mariadb"
```

There is nothing to download, no header to translate, no `#foreignlib` and nothing on the command line. The names are the ones [MariaDB's Connector/C documentation](https://mariadb.com/docs/connectors/mariadb-connector-c) and MySQL's C API reference use. More programs are in the toolchain's `examples/mariadb`.

You need a server to talk to, and an account on it. Every program here takes the host, the user and the database on its command line, and the password from the environment variable `MYSQL_PWD`, which it reads itself: a password on a command line can be read by other users of the machine.

---

## 1. A first program

The program connects, creates a table, inserts three rows and reads them back:

```freebasic
'' MySQL or MariaDB from tiko: connect, create a table, read rows back.
''     myfirst HOST USER DATABASE        (the password in MYSQL_PWD)
#import "vendor/mariadb"

dim as MYSQL ptr m = mysql_init( nullptr )
'' utf8mb4 before connecting, so the handshake already uses it.
mysql_optionsv( m, MYSQL_SET_CHARSET_NAME, strptr( "utf8mb4" ) )
if mysql_real_connect( m, command( 1 ), command( 2 ), environ( "MYSQL_PWD" ), _
                       command( 3 ), 0, nullptr, 0 ) = nullptr then
    print "cannot connect: "; *mysql_error( m )
    mysql_close( m )        ' the handle mysql_init made
    end 1
end if
print "server "; *mysql_get_server_info( m )
dim as const zstring ptr cipher = mysql_get_ssl_cipher( m )
print "tls    "; iif( cipher, *cipher, "none" )

'' SQL with no values from outside: mysql_query. 0 is success.
mysql_query( m, "create temporary table book (id int auto_increment " & _
                "primary key, title varchar(80) not null, year int)" )
if mysql_query( m, "insert into book (title, year) values " & _
                   "('Dune', 1965), ('Café Society', 2016), ('Untitled', null)" ) then
    print *mysql_error( m )
end if
print mysql_affected_rows( m ); " rows inserted"

'' A result is an array of zstring ptr per row; nullptr is NULL.
mysql_query( m, "select id, title, year from book order by id" )
dim as MYSQL_RES ptr res = mysql_store_result( m )
dim as MYSQL_ROW row = mysql_fetch_row( res )
while row
    print *row[0]; ". "; *row[1]; " ("; iif( row[2], *row[2], "unknown" ); ")"
    row = mysql_fetch_row( res )
wend
mysql_free_result( res )
mysql_close( m )
```

```
server 8.0.46-0ubuntu0.22.04.5
tls    TLS_AES_256_GCM_SHA384
3 rows inserted
1. Dune (1965)
2. Café Society (2016)
3. Untitled (unknown)
```

- **`mysql_init`** makes the connection handle, a **`MYSQL ptr`**, and **`mysql_close`** frees it -- also after `mysql_real_connect` failed. `MYSQL` is opaque: hold the pointer, pass it on, and ask the API what it knows (`mysql_get_server_info`, `mysql_get_host_info`, `mysql_error`).
- **Ask for `utf8mb4`**, with `MYSQL_SET_CHARSET_NAME` before connecting. Text then crosses as UTF-8 bytes: keep it in a `string`. MySQL's `utf8` is a three-byte subset that cannot hold every character.
- **`mysql_query`** and `mysql_real_query` (which takes a length) return 0 for success; `mysql_errno` and `mysql_error` explain a failure. **`mysql_store_result`** reads a result into memory, `mysql_fetch_row` gives each row as an array of `zstring ptr`, `nullptr` for `NULL`, and `mysql_free_result` frees it. A row lives as long as its result.
- A binary column can hold zero bytes, so its length is **`mysql_fetch_lengths( res )[column]`**, not the zstring's.

## 2. Prepared statements

A value from outside the program goes in as a parameter, never as SQL text. `?` marks each one, and a **`MYSQL_BIND`** record describes the program's variable that holds it:

```freebasic
'' Prepared statements: '?' in the SQL, the values in MYSQL_BIND records.
''     myprepared HOST USER DATABASE        (the password in MYSQL_PWD)
#import "vendor/mariadb"

dim as MYSQL ptr m = mysql_init( nullptr )
mysql_optionsv( m, MYSQL_SET_CHARSET_NAME, strptr( "utf8mb4" ) )
if mysql_real_connect( m, command( 1 ), command( 2 ), environ( "MYSQL_PWD" ), _
                       command( 3 ), 0, nullptr, 0 ) = nullptr then
    print *mysql_error( m ) : mysql_close( m ) : end 1
end if
mysql_query( m, "create temporary table book (title varchar(80), year int)" )

'' INSERT: one MYSQL_BIND per '?', saying the type of the program's
'' variable, where it is and -- for text -- how long it is.
dim as MYSQL_STMT ptr st = mysql_stmt_init( m )
dim as string sql = "insert into book values (?, ?)"
if mysql_stmt_prepare( st, strptr( sql ), len( sql ) ) then
    print *mysql_stmt_error( st ) : end 1
end if
dim as string title
dim as culong titlelen
dim as int32 year
dim as MYSQL_BIND p( 0 to 1 )
p( 0 ).buffer_type = MYSQL_TYPE_STRING : p( 0 ).length = @titlelen
p( 1 ).buffer_type = MYSQL_TYPE_LONG   : p( 1 ).buffer = @year

dim as string titles( 0 to 2 ) = { "Dune", "It's Here", "Café Society" }
dim as int32 years( 0 to 2 ) = { 1965, 2001, 2016 }
for i as int32 = 0 to 2
    '' A string's buffer can move when it is assigned: point at it again.
    title = titles( i ) : titlelen = len( title ) : p( 0 ).buffer = strptr( title )
    year = years( i )
    mysql_stmt_bind_param( st, @p( 0 ) )
    if mysql_stmt_execute( st ) then print *mysql_stmt_error( st )
next
mysql_stmt_close( st )

'' SELECT with a parameter, its columns fetched into bound variables.
st = mysql_stmt_init( m )
sql = "select title, year from book where year >= ? order by year"
mysql_stmt_prepare( st, strptr( sql ), len( sql ) )
dim as int32 since = 2000
dim as MYSQL_BIND q( 0 to 0 )
q( 0 ).buffer_type = MYSQL_TYPE_LONG : q( 0 ).buffer = @since
mysql_stmt_bind_param( st, @q( 0 ) )
mysql_stmt_execute( st )

dim as zstring * 81 buf
dim as MYSQL_BIND res( 0 to 1 )
res( 0 ).buffer_type = MYSQL_TYPE_STRING : res( 0 ).buffer = @buf
res( 0 ).buffer_length = sizeof( buf )   : res( 0 ).length = @titlelen
res( 1 ).buffer_type = MYSQL_TYPE_LONG   : res( 1 ).buffer = @year
mysql_stmt_bind_result( st, @res( 0 ) )
while mysql_stmt_fetch( st ) = 0
    print year; "  "; left( buf, titlelen )
wend
mysql_stmt_close( st )
mysql_close( m )
```

```
 2001  It's Here
 2016  Café Society
```

- **`buffer_type`** says what the variable is (`MYSQL_TYPE_LONG` an `int32`, `MYSQL_TYPE_LONGLONG` an `int64`, `MYSQL_TYPE_DOUBLE` a `float64`, `MYSQL_TYPE_STRING` text, `MYSQL_TYPE_BLOB` bytes, `MYSQL_TYPE_DATETIME` a `MYSQL_TIME`), **`buffer`** where it is, and for text and bytes **`length`** points at its length. **`is_null`** points at a flag that makes the value `NULL`.
- The binds are read when the statement **executes**, so changing the variables and calling `mysql_stmt_execute` again runs it with the new values. A `string` moves when it is assigned: point `buffer` at it again, and call `mysql_stmt_bind_param` again.
- For a result, `mysql_stmt_bind_result` names a variable per column -- text needs a buffer and its size, and gets its length back -- and each **`mysql_stmt_fetch`** fills them, until it returns `MYSQL_NO_DATA`.
- A statement has its own errors: **`mysql_stmt_errno`**, `mysql_stmt_error`, `mysql_stmt_sqlstate`.

If SQL text must be built from a value, **`mysql_real_escape_string`** is the only safe way: `examples/mariadb/02-queries` shows it.

## 3. Transactions and errors

```freebasic
'' A transaction that keeps everything or nothing, and errors told apart
'' by their number and SQLSTATE.
''     mytransfer HOST USER DATABASE        (the password in MYSQL_PWD)
#import "vendor/mariadb"

dim shared as MYSQL ptr m
dim shared as string lasterror        ' the failing statement's own words

'' Run "... ? ... ?" with an amount, then a name; return the error number,
'' 0 for success. The message is copied before mysql_stmt_close, which
'' discards it with the statement.
function Run2( byval sql as string, byval amount as int32, _
               byval name_ as string ) as uint32
    dim as MYSQL_STMT ptr st = mysql_stmt_init( m )
    dim as culong namelen = len( name_ )
    dim as MYSQL_BIND p( 0 to 1 )
    p( 0 ).buffer_type = MYSQL_TYPE_LONG : p( 0 ).buffer = @amount
    p( 1 ).buffer_type = MYSQL_TYPE_STRING
    p( 1 ).buffer = strptr( name_ ) : p( 1 ).length = @namelen
    dim as uint32 e
    if mysql_stmt_prepare( st, strptr( sql ), len( sql ) ) = 0 andalso _
       mysql_stmt_bind_param( st, @p( 0 ) ) = 0 then
        mysql_stmt_execute( st )
    end if
    e = mysql_stmt_errno( st )
    if e then lasterror = *mysql_stmt_sqlstate( st ) & " " & *mysql_stmt_error( st )
    mysql_stmt_close( st )
    return e
end function

'' Both updates or neither. A CHECK that fails is error 3819 on MySQL 8
'' (4025 on MariaDB), SQLSTATE HY000: test the number, not the state.
function Transfer( byval src as string, byval dst as string, _
                   byval amount as int32 ) as uint32
    mysql_autocommit( m, 0 )
    dim as uint32 e = Run2( _
        "update account set balance = balance - ? where name = ?", amount, src )
    if e = 0 then e = Run2( _
        "update account set balance = balance + ? where name = ?", amount, dst )
    if e = 0 then mysql_commit( m ) else mysql_rollback( m )
    mysql_autocommit( m, 1 )
    return e
end function

sub Show( )
    mysql_query( m, "select name, balance from account order by name" )
    dim as MYSQL_RES ptr res = mysql_store_result( m )
    dim as MYSQL_ROW row = mysql_fetch_row( res )
    while row
        print "  "; *row[0]; " "; *row[1]
        row = mysql_fetch_row( res )
    wend
    mysql_free_result( res )
end sub

m = mysql_init( nullptr )
if mysql_real_connect( m, command( 1 ), command( 2 ), environ( "MYSQL_PWD" ), _
                       command( 3 ), 0, nullptr, 0 ) = nullptr then
    print *mysql_error( m ) : mysql_close( m ) : end 1
end if
'' InnoDB, the default engine, keeps transactions.
mysql_query( m, "create temporary table account (name varchar(20) primary key, " & _
                "balance decimal(10,2) not null, check (balance >= 0))" )
mysql_query( m, "insert into account values ('alice', 100), ('bob', 20)" )

print "alice pays bob 30: error "; str( Transfer( "alice", "bob", 30 ) )
Show( )
print "alice pays bob 500: error "; str( Transfer( "alice", "bob", 500 ) ); _
      " -- "; lasterror
Show( )
print "a second bob: error "; _
      str( Run2( "insert into account (balance, name) values (?, ?)", 0, "bob" ) ); " -- "; lasterror
mysql_close( m )
```

```
alice pays bob 30: error 0
  alice 70.00
  bob 50.00
alice pays bob 500: error 3819 -- HY000 Check constraint 'account_chk_1' is violated.
  alice 70.00
  bob 50.00
a second bob: error 1062 -- 23000 Duplicate entry 'bob' for key 'account.PRIMARY'
```

**`mysql_autocommit( m, 0 )`** starts grouping statements, and **`mysql_commit`** or **`mysql_rollback`** ends the group, keeping all of it or none. The table must use a transactional engine; InnoDB, the default, is one.

**Test the error number.** MySQL's numbers are stable and documented (1062 a duplicate key, 1146 an unknown table, 1045 access denied, 3819 a check constraint), and MariaDB's are the same for most (its check constraint is 4025). The SQLSTATE is often only the generic `HY000`, as it is for the check here, and the message is in the server's language.

## 4. Encrypted connections

Connector/C uses TLS whenever the server offers it -- every connection above was encrypted. **To be sure the server's certificate is checked**, give the CA that signed it and ask for the check, before connecting:

```freebasic
dim as my_bool yes = 1
mysql_optionsv( m, MYSQL_OPT_SSL_CA, strptr( "ca.pem" ) )
mysql_optionsv( m, MYSQL_OPT_SSL_VERIFY_SERVER_CERT, @yes )
```

Measured with a CA that did not sign the server's certificate, the connection is refused: error 2026, `TLS/SSL error: Server certificate validation failed ... CERT_E_UNTRUSTEDROOT` on Windows, `self-signed certificate in certificate chain` on Linux. **`mysql_get_ssl_cipher( m )`** gives the connection's cipher, or `nullptr` when it is not encrypted. Windows' TLS is the system's own (Schannel); on Linux and macOS OpenSSL is inside `vendor/mariadb`, so there is nothing else to install either way.

## 5. More programs

The toolchain's `examples/mariadb`, each built with `tiko <name>.tiko`, connect with `TIKO_MYSQL_HOST`, `_USER`, `_PASSWORD`, `_DB`, `_PORT` and `_CA`:

| Folder | Shows |
| --- | --- |
| `01-connect` | connect and check, the server's version, the TLS cipher, the character set; a connection that fails |
| `02-queries` | text queries, field names and types, NULL, a binary column by its length, `mysql_insert_id`, `mysql_real_escape_string`, a rolled-back transaction, an error's number and SQLSTATE |
| `03-prepared` | `MYSQL_BIND` for an integer, text, a NULL-able double, a DATETIME and a BLOB; a statement run three times; a result into bound variables |

## 6. In a project

A [`tiko build`](Category-Tiko-Build) project needs nothing in its `tiko.toml` for Connector/C: the import says it all. `tiko build`'s `copy_to` copies the shared library along with the program.

## 7. Shipping the program

`vendor/mariadb` is **a shared library only**: `#import "vendor/mariadb" link static` is refused (`TKO0156: 'link static': package 'vendor' ships no static link of module 'vendor.mariadb'`). Ship the library the build put beside the program: `libmariadb.dll` on Windows, `libmariadb_linux_x86_64.so` or `libmariadb_linux_arm64.so` on Linux, `libmariadb_macos_arm64.dylib` on macOS. It is the only file.

That is the licence's doing. Connector/C is under the **GNU LGPL 2.1**, which lets a program under any licence use it, as long as the library stays a separate file its user could replace, the licence goes with it, and the library's source is available -- Connector/C 3.4.11's, from [MariaDB's repository](https://github.com/mariadb-corporation/mariadb-connector-c/tree/v3.4.11). The texts, and OpenSSL's (Apache 2.0, inside the Linux library), are in `pkg/vendor/mariadb/LICENSE` in the toolchain.

## 8. Troubleshooting

| Symptom | Cause and fix |
| --- | --- |
| `2002 Can't connect to server on '...'` | no server listening there: the host, the port (3306 by default), or a firewall. MySQL often listens on 127.0.0.1 only (`bind-address`) |
| `1045 Access denied for user 'app'@'localhost' (using password: YES)` | the user or password, or the account is not allowed from your address (`'user'@'host'` in MySQL) |
| `2026 TLS/SSL error: ...` | the CA in `MYSQL_OPT_SSL_CA` did not sign the server's certificate, or the certificate's name does not match the host |
| `3819 Check constraint ... is violated` (MySQL), `4025` (MariaDB) | a `check` refused the row; the transaction should roll back |
| `lld-link: error: undefined symbol: mysql_port` | the program wrote `MYSQL_PORT`. tiko's names are case-insensitive, so that is `mysql.h`'s variable `mysql_port`, which the library does not export. Write `MARIADB_PORT` (3306); the constant itself is `MYSQL_PORT_2` |
| the members of `MYSQL` are not declared | `MYSQL` is opaque in `vendor/mariadb`: use the API (`mysql_get_server_info`, `mysql_errno`, `mariadb_get_infov`) |
| the program exits at once with `-1073741515` (Windows) | `libmariadb.dll` is not beside the program; another copy on the `PATH`, from some other program, may be loaded in its place |

---

**Next:** [PostgreSQL](PostgreSQL-Tutorial) · [SQLite](SQLite-Tutorial) · [Vendor Packages](Vendor-Packages)

[Home](Home)
