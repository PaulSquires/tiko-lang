[Home](Home) › [All Categories](Categories) › [C Header Import](Category-C-Header-Import) › **Vendor Packages**

# Vendor Packages

> **In tiko.** A C library the toolchain ships, reached with one `#import` and nothing on the command line: `#import "vendor/sqlite" link dynamic`. Its header comes across whole and unqualified, its library is linked, and a dynamic library is copied beside the program so the program starts. Measured on windows-x86_64 and linux-x86_64.

## Syntax

```
#import "vendor/<library>" [as name] [public] [link static|dynamic]
```

## Description

```freebasic
#import "vendor/sqlite" link dynamic

dim as sqlite3 ptr db
if sqlite3_open( ":memory:", @db ) <> SQLITE_OK then print "open failed"
dim as sqlite3_stmt ptr st
sqlite3_prepare_v2( db, "select ? || '!'", -1, @st, 0 )
sqlite3_bind_text( st, 1, "hi", -1, SQLITE_TRANSIENT )
if sqlite3_step( st ) = SQLITE_ROW then print *cast( zstring ptr, sqlite3_column_text( st, 0 ) )
sqlite3_finalize( st )
sqlite3_close( db )
```

```
hi!
```

Every routine, type and constant of the library's C header is callable as the library documents it: `sqlite3_open`, `SQLITE_OK`, not `sqlite.sqlite3_open`. No `#cinclude`, no `#foreignlib`, no `-i`, `-l` or `-p`, and no Clang at your end: the header was translated once, by [`tiko c2t`](C2t), and ships translated.

`vendor/` is the toolchain's, as `std/` is. It is looked for in the toolchain's `pkg/` directory alone: a project directory, an `-i` directory, a `TKO_PATH` entry or a dependency called `vendor` cannot stand in for it, and a project whose `tiko.toml` names itself `vendor` is `TKO0148`.

| Package | Library | Link modes |
| --- | --- | --- |
| `vendor/sqlite` | SQLite 3.54.0 | `static`, `dynamic` (the default) |
| `vendor/SDL3` | SDL 3.4.4 | `dynamic` (the default); windows-x86_64 only -- SDL publishes no Linux binary, so the toolchain for linux-x86_64 ships the headers with no library |

## `link static` and `link dynamic`

- **`link static`** links the library's archive into the program. Nothing else is needed at run time.
- **`link dynamic`** links the shared library (`sqlite3.dll`, `sqlite3_linux_x86_64.so`) and **copies it beside the program**, under the name the program will load it by. A copy already there with the same size and no older is left alone, and one that was deleted is put back by the next build. [`tiko build`](Category-Tiko-Build)'s `copy_to` copies the library along with the program. `-nocopylibs` turns the copy off.
- **No `link`** leaves the choice to the package: each one names its default. `vendor/sqlite`'s is dynamic.

One program links a library one way. Two imports asking for different modes are `TKO0157`, with a note at the other import; an import without `link` goes along with one that has it. A mode the package does not ship is `TKO0156`, and `link` on a package that ships no library -- any source-only package -- is `TKO0155`.

On linux-x86_64 a program that links a shared library from `#foreignlib` gets a run path of `$ORIGIN`, so the copy beside it is the one it finds. `LD_LIBRARY_PATH` still wins, and an `-rpath` the program passes with [`-Wl`](Compiler-Option-Wl) stands. `-norpath` turns it off.

## Inside a vendor package

A vendor package is an ordinary module. `vendor/sqlite` is one file:

```freebasic
#module "sqlite"

public #include once "sqlite3.ti"
public #include once "sqlite3-residue.ti"

#ifdef TIKO_LINK_STATIC
    #foreignlib SQLITE static "lib/sqlite3"
#else
    #foreignlib SQLITE dynamic "lib/sqlite3"
#endif
```

- **`public #include`** carries a header with the module's interface, whole: an importer reads it as if it had included it itself, names and macros unqualified. Outside a module file it is `TKO0369`.
- **`TIKO_LINK_STATIC`** or **`TIKO_LINK_DYNAMIC`** (each `1`) is defined in the module when an importer wrote `link`; with no `link` anywhere, neither is, and the module's `#else` decides. The mode is part of the module's cache entry, so changing it rebuilds the module.
- **`sqlite3.ti`** is the C header translated by `tiko c2t ... --shared-macro "SQLITE_API=__attribute__((dllimport))"`: a variable the library exports is written twice, `extern import` for a dynamic link on Windows and plain `extern` otherwise.
- **`sqlite3-residue.ti`** is written by hand: what the translation could not carry (`SQLITE_STATIC` and `SQLITE_TRANSIENT`, which are pointers), each with the reason.
- **`tiko.toml`** says what the package ships: `[vendor.sqlite] links = ["static", "dynamic"]`.
- **`lib/`** holds the library files. They are not part of the source: `build/vendorfetch.sh` downloads them, or builds them from the library's source where no binary is published, each archive pinned by version and SHA-256, from the module's `fetch.toml`.

### A header read in two places

A public header is read twice: once in the module, and again in every program that imports it. The program's macros can change what the header declares there. So the module records each macro the header's `#if`, `#ifdef` and `defined( )` lines looked at, as it was in the module, and the importer checks its own against them:

- the same in both, or undefined in both: nothing happens;
- defined in the module only -- its package's `[defines]`, its `TIKO_LINK_*` -- it is defined for the header and undefined again after it, so one package's link mode never reaches another's header;
- anything else is `TKO0370`, at the `#import`: `'unicode' is defined as '-1' here, but module 'vp.geo' read '.../geo.ti' with it undefined`.

## Options

| Option | Effect |
| --- | --- |
| `-nocopylibs` | do not copy a vendor package's dynamic library beside the output |
| `-norpath` | no `$ORIGIN` run path on a linux-x86_64 link that takes a shared library |

## Diagnostics

| Id | When |
| --- | --- |
| `TKO0148` | a package named `vendor` that is not the toolchain's |
| `TKO0155` | `link` on a package that ships no library |
| `TKO0156` | a link mode the package does not ship |
| `TKO0157` | two imports of one module with different link modes |
| `TKO0171` | the dynamic library could not be copied beside the output |
| `TKO0369` | `public #include` outside a module file |
| `TKO0370` | a macro a public header consulted differs between the module and the importer |

### See also

- [`tiko c2t`](C2t)
- [C Header Import](Category-C-Header-Import)
- [Foreign Library Linking](Category-Foreign-Library-Linking)
- [SQLite Tutorial](SQLite-Tutorial)
