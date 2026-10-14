[Home](Home) › [Using C Libraries](Using-C-Libraries-Tutorial) › **SQLite**

# SQLite Tutorial

> 📘 **Start with:** [Using C Libraries](Using-C-Libraries-Tutorial), the ideas these steps rely on.
>
> 📖 **In the book:** [Chapter 29, SQLite](https://tiko-lang.net/book/ch29-c-libraries.html#sqlite). Measured with SQLite 3.54.0 and tiko, on Windows and Linux.

[SQLite](https://sqlite.org) is a complete SQL database in a library. There is no server, and a database is one ordinary file. This tutorial uses SQLite's own C interface from tiko, linked dynamically and statically, kept inside a project or installed for the whole machine.

> ℹ️ **tiko already ships SQLite.** `#import "db/sqlite"` gives you a tiko-style wrapper over a copy linked into your program (see the book's Chapter 27). Use this tutorial when you need a different SQLite version, SQLite's own C API, or your own compile options.

---

## 1. Download

All files are on [sqlite.org/download.html](https://sqlite.org/download.html). The number in each file name is the version: 3.54.0 is `3540000`.

| File | Contains | You need it for |
|---|---|---|
| `sqlite-amalgamation-3540000.zip` | `sqlite3.c`, `sqlite3.h` (the whole library as **one C file**) | the header, on every platform; a static library on Windows |
| `sqlite-dll-win-x64-3540000.zip` | `sqlite3.dll`, `sqlite3.def` | the DLL, on Windows |
| `sqlite-autoconf-3540000.tar.gz` | `sqlite3.c`, `sqlite3.h` and a Unix build script | building on Linux |

## 2. Your project's layout

When you are done, the project looks like this. The `vendor/` folder can hold both platforms' files at once, because each library file carries its target in its name:

```
myapp/
  sqlite-quick.tiko
  sqlite3.dll                                   (Windows: the DLL, beside the program)
  libsqlite3.so.0                               (Linux: the .so, beside the program)
  vendor/sqlite/
    sqlite3.h
    sqlite3_windows_x86_64.dll                  sqlite3.dll, renamed: tiko makes its import library
    sqlite3-static_windows_x86_64.lib           static library
    sqlite3_linux_x86_64.so                     shared library
    sqlite3-static_linux_x86_64.a               static library
```

You only need the files for the platforms and the kind of link you use.

## 3. Lay it out: Windows

**The header.** Copy `sqlite3.h` from the amalgamation zip into `vendor/sqlite/`.

**For dynamic linking.** The DLL zip contains `sqlite3.dll` and `sqlite3.def`, a list of the DLL's functions, but **no import library**. You don't need to make one:

1. Copy `sqlite3.dll` to `vendor/sqlite/sqlite3_windows_x86_64.dll`.
2. Copy `sqlite3.dll` again, unrenamed, next to where your program will be.

When `#foreignlib SQLITE dynamic "vendor/sqlite/sqlite3"` finds only the `.dll`, tiko reads the DLL's exports and makes the import library while linking (run with `-v` to see the `llvm-dlltool` command). The import library names the DLL **as the DLL names itself**, `sqlite3.dll`, not by the renamed file, so the program loads the copy beside it.

**Or make the import library yourself**, to keep one in the project. `llvm-dlltool`, which comes with LLVM, makes it from the `.def`:

```bash
llvm-dlltool -m i386:x86-64 -d sqlite3.def -D sqlite3.dll -l vendor/sqlite/sqlite3_windows_x86_64.lib
```

- `-m i386:x86-64`: a 64-bit import library
- `-d sqlite3.def`: the list of functions
- `-D sqlite3.dll`: **the DLL the program will load.** Don't leave this out (see below).
- `-l ...`: the file to write

A `.lib` with one of the names `#foreignlib` tries is found before the `.dll`, so when both are there, yours is used.

> ⚠️ **Without a DLL name, the program cannot start.** `sqlite3.def` has no `LIBRARY` line, so an import library made without `-D` (for example with `llvm-lib /def:sqlite3.def`) records an **empty** DLL name. Everything links, and then the program dies on start with code `-1073741515`. Check with `llvm-readobj --coff-imports program.exe`: a `Name:` line with nothing after it is the problem.

**For static linking.** Compile the amalgamation and archive it. This needs the Visual Studio Build Tools, for the C runtime headers, and takes about 20 seconds (`sqlite3.c` is 9.6 MB of C):

```bash
clang -c -O2 -o sqlite3.obj sqlite3.c
llvm-lib /out:vendor/sqlite/sqlite3-static_windows_x86_64.lib sqlite3.obj
```

The static library is called `sqlite3-static` because on Windows a static `.lib` and an import `.lib` cannot share a name.

## 4. Lay it out: Linux

From the autoconf archive (or the amalgamation, which has the same `sqlite3.c`):

```bash
cp sqlite3.h vendor/sqlite/
gcc -O2 -fPIC -c -o sqlite3.o sqlite3.c

# static
ar rcs vendor/sqlite/sqlite3-static_linux_x86_64.a sqlite3.o

# shared, with the soname the program will ask for when it starts
gcc -shared -Wl,-soname,libsqlite3.so.0 \
    -o vendor/sqlite/sqlite3_linux_x86_64.so sqlite3.o -lm
cp vendor/sqlite/sqlite3_linux_x86_64.so libsqlite3.so.0
```

`-fPIC` is needed for code that goes into a shared library. `-Wl,-soname,...` records the name the program will look for. Without it, the program would remember the path it was linked with, and work only when started from the build directory.

## 5. The program, linked dynamically

This is SQLite's own *"SQLite In 5 Minutes Or Less"* program in tiko. It opens the database named by the first argument, runs the SQL in the second, and prints each row:

```freebasic
'' SQLite's "SQLite In 5 Minutes Or Less" program: run one SQL string
'' against a database and print each row the callback is given.
#cinclude once "vendor/sqlite/sqlite3.h"
#foreignlib SQLITE dynamic "vendor/sqlite/sqlite3"

'' Called once for each row of the result.
function Callback cdecl( byval notUsed as any ptr, _
        byval argc as int32, byval argv as zstring ptr ptr, _
        byval colName as zstring ptr ptr ) as int32
    for i as int32 = 0 to argc - 1
        dim value as ustring = "NULL"
        if argv[i] <> nullptr then value = *argv[i]
        print *colName[i]; " = "; value
    next
    print
    return 0
end function

if command( 2 ) = "" then
    print "Usage: sqlite-quick DATABASE SQL-STATEMENT"
    end 1
end if

dim db as sqlite3 ptr
if sqlite3_open( command( 1 ), @db ) <> SQLITE_OK then
    print "Can't open database: "; *sqlite3_errmsg( db )
    sqlite3_close( db )
    end 1
end if

dim errMsg as zstring ptr
if sqlite3_exec( db, command( 2 ), @Callback, nullptr, @errMsg ) _
        <> SQLITE_OK then
    print "SQL error: "; *errMsg
    sqlite3_free( errMsg )
end if
sqlite3_close( db )
```

Build and run it from the project folder. On Windows:

```bash
tiko sqlite-quick.tiko
./sqlite-quick :memory: "create table tbl1(one text, two int);
    insert into tbl1 values('hello!', 10);
    insert into tbl1 values('goodbye', 20);
    select * from tbl1"
```

On Linux, the same, but run it with the project folder on `LD_LIBRARY_PATH`:

```bash
tiko sqlite-quick.tiko
LD_LIBRARY_PATH=. ./sqlite-quick :memory: "create table tbl1(one text, two int);
    insert into tbl1 values('hello!', 10);
    insert into tbl1 values('goodbye', 20);
    select * from tbl1"
```

Output:

```
one = hello!
two = 10

one = goodbye
two = 20
```

**What each part does:**

| Line | Why |
|---|---|
| `#cinclude once "vendor/sqlite/sqlite3.h"` | tiko reads SQLite's header with clang. Every SQLite function, type and constant becomes available, and you write no `declare`s. |
| `#foreignlib SQLITE dynamic "vendor/sqlite/sqlite3"` | links `sqlite3_windows_x86_64.lib` or `sqlite3_linux_x86_64.so`, whichever matches the target, relative to **this file** |
| `function Callback cdecl( ... )` | `sqlite3_exec` calls it once per row, so it must be `cdecl` and match C's `int (*)(void*, int, char**, char**)` exactly |
| `dim db as sqlite3 ptr` / `@db` | `sqlite3` is opaque, so you only ever hold a pointer. C's `&db` is tiko's `@db`. |
| `*sqlite3_errmsg( db )` | a `const char *` from C; `*` copies the text into a tiko string |
| `sqlite3_free( errMsg )` | SQLite allocated the message, so SQLite frees it |

> 💡 **No `LD_LIBRARY_PATH` needed:** add `#cmdline "-Wl -rpath,$ORIGIN"` (inside `#ifdef __FB_LINUX__`), and the program looks for `libsqlite3.so.0` beside itself first.

> ⚠️ **On Linux, forgetting `LD_LIBRARY_PATH` may not fail.** Ubuntu has its own `libsqlite3.so.0` installed, and the program will quietly use that, an older version (3.45.1 on Ubuntu 24.04). Ask SQLite: `select sqlite_version()`.

## 6. The program, linked statically

Real programs **prepare** a statement once with `?` placeholders and **bind** values to them. That is faster, and it is safe from SQL injection. This program does that, and links SQLite statically:

```freebasic
'' Insert and query with prepared statements: the values travel as
'' parameters, never as text pasted into the SQL. Linked statically.
#cinclude once "vendor/sqlite/sqlite3.h"
#foreignlib SQLITE static "vendor/sqlite/sqlite3-static"

sub Check( byval rc as int32, byval db as sqlite3 ptr )
    if rc <> SQLITE_OK andalso rc <> SQLITE_DONE then
        print "SQLite error "; rc; ": "; *sqlite3_errmsg( db )
        end 1
    end if
end sub

print "SQLite "; *sqlite3_libversion( )

dim db as sqlite3 ptr
Check( sqlite3_open( ":memory:", @db ), db )
Check( sqlite3_exec( db, "create table city( name text, pop int )", _
    nullptr, nullptr, nullptr ), db )

dim names( 0 to 2 ) as string = _
    { "St. John's", "Gander", "Corner Brook" }
dim pops( 0 to 2 ) as int32 = { 110525, 11880, 19316 }

dim ins as sqlite3_stmt ptr
Check( sqlite3_prepare_v2( db, "insert into city values( ?, ? )", _
    -1, @ins, nullptr ), db )
for i as int32 = 0 to 2
    '' -1: the text ends at its zero byte. nullptr (SQLITE_STATIC):
    '' the string outlives the statement's use of it.
    Check( sqlite3_bind_text( ins, 1, names( i ), -1, nullptr ), db )
    Check( sqlite3_bind_int( ins, 2, pops( i ) ), db )
    Check( sqlite3_step( ins ), db )
    sqlite3_reset( ins )
next
sqlite3_finalize( ins )

dim sel as sqlite3_stmt ptr
Check( sqlite3_prepare_v2( db, _
    "select name, pop from city where pop > ? order by pop desc", _
    -1, @sel, nullptr ), db )
sqlite3_bind_int( sel, 1, 15000 )
do while sqlite3_step( sel ) = SQLITE_ROW
    print *cast( zstring ptr, sqlite3_column_text( sel, 0 ) ); ": "; _
        str( sqlite3_column_int( sel, 1 ) )
loop
sqlite3_finalize( sel )
sqlite3_close( db )
```

```bash
tiko sqlite-bind.tiko
./sqlite-bind
```

```
SQLite 3.54.0
St. John's: 110525
Corner Brook: 19316
```

Only the `#foreignlib` line differs from the dynamic program: `static`, and the static library's name. The program needs no DLL now. It is about 1.1 MB, compared with 38 KB plus a 3.5 MB DLL.

**Details worth knowing:**

- `sqlite3_bind_text`'s last argument says whether SQLite must copy the text. Pass `nullptr` (that is `SQLITE_STATIC`) when the string outlives the statement, as here. For `SQLITE_TRANSIENT` (copy it), write `cast( sqlite3_destructor_type, -1 )`. Both are C macros that cast a number to a function pointer, and `#cinclude` does not import that kind of macro.
- `sqlite3_column_text` returns `const unsigned char *`, which tiko sees as `const ubyte ptr`. Cast it to `zstring ptr` to read it as text.
- The names are `string`, tiko's byte string, because SQLite's `_text` functions take UTF-8 bytes.

## 7. Installing SQLite for every program

**Linux:** use the distribution's package. It installs `sqlite3.h` into `/usr/include` and the library into the system's library directory:

```bash
sudo apt install libsqlite3-dev
```

Then a program needs no paths at all:

```freebasic
#cinclude once "sqlite3.h"
#foreignlib SQLITE dynamic "system:sqlite3"
```

This links the distribution's SQLite, which is 3.45.1 on Ubuntu 24.04. For a newer one, build it as in step 4 and copy `sqlite3.h` to `/usr/local/include` and the `.so` to `/usr/local/lib` as `libsqlite3.so.0`, with a `libsqlite3.so` link to it. Then run `sudo ldconfig`.

**Windows:** keep the layout from step 3 in a shared folder and use a [binding header](Using-C-Libraries-Tutorial#5-a-binding-header). The [raylib tutorial](Raylib-Tutorial#7-one-copy-for-every-program) walks through one.

## 8. Troubleshooting

| Problem | Fix |
|---|---|
| `TKO0336: unable to import C header vendor/sqlite/sqlite3.h` | check the path; on Windows install the Visual Studio Build Tools |
| `TKO0329: #foreignlib found no matching library file` | the file names in the list are what tiko looked for; rename yours to match |
| `TKO0172: cannot make an import library for '...': it is not a 64-bit x86-64 DLL` | that is `sqlite-dll-win-x86`, the 32-bit download; take `win-x64` |
| the program exits at once with `-1073741515` | `sqlite3.dll` is not beside the program, or the import library was made without `-D sqlite3.dll` |
| `error while loading shared libraries: libsqlite3.so.0` | `LD_LIBRARY_PATH=.` or install SQLite |
| wrong SQLite version reported on Linux | the system's copy was loaded; use `LD_LIBRARY_PATH=.` |

---

**Next:** [raylib](Raylib-Tutorial) · [GLFW](GLFW-Tutorial) · [SDL3](SDL3-Tutorial)

[Home](Home)
