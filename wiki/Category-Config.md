[Home](Home) › [All Categories](Categories) › **Config**

# Config: INI And TOML Files

The `std/config` module reads and writes the two configuration formats programs meet most: INI files and TOML. A TOML document becomes a tree of `TomlValue`s you can query, change and write back; an INI file becomes an `IniFile` of sections and keys. Writing CSV is in [String Library](Category-String-Library), next to `SplitCsv`.

```freebasic
#import "std/config"

dim r as config.ConfigResultToml = config.LoadToml( "app.toml" )
if r.IsOk( ) = false then
    print r.Failure( ).Message( )        ' line 4, column 9: duplicate key: 'port'
    end 1
end if
dim as config.TomlValue doc = r.Value( )
print doc.Path( "server.port" ).ValueOr( config.TomlValue( ) ).AsInt( ).ValueOr( 8080 )
print doc.Path( "servers.0.host" ).ValueOr( config.TomlValue( ) ).AsString( ).ValueOr( "localhost" )
```

## TOML

`ParseToml( text )` and `LoadToml( path )` return the document's root table, or a `ConfigError`. TOML 1.1 is read, so every TOML 1.0 document is too: inline tables may span lines and end with a comma, strings may use `\e` and `\xHH`, and a time may leave out its seconds (`07:32`).

A `TomlValue` is one of:

| `Kind( )` | Read with | Holds |
|---|---|---|
| `TOML_STRING` | `AsString( )` | `ustring` |
| `TOML_INT` | `AsInt( )` | `longint`; a number outside 64 bits is an error, never a float |
| `TOML_FLOAT` | `AsFloat( )` | `double`, including `inf` and `nan`; `AsFloat` also reads an integer |
| `TOML_BOOL` | `AsBool( )` | `boolean` |
| `TOML_OFFSET_DATETIME` | `AsDateTime( )` | a `chrono.DateTime` with its offset |
| `TOML_LOCAL_DATETIME` | `AsDateTime( )` | a `chrono.DateTime` with no offset |
| `TOML_LOCAL_DATE` | `AsLocalDate( )` | a `chrono.LocalDate` |
| `TOML_LOCAL_TIME` | `AsLocalTime( )` | a `chrono.LocalTime` |
| `TOML_ARRAY` | `Count( )`, `[ i ]` | values, any mix of kinds |
| `TOML_TABLE` | `Get`, `Find`, `Path`, `KeyAt` | keys and values, **in the order they were written** |
| `TOML_NONE` | | a default-constructed `TomlValue`; not a TOML type |

Every `As…` returns an `Optional`, empty when the value is another kind. Fractional seconds are kept to 100 nanoseconds; a date outside years 1 to 9999 parses, but its `AsDateTime` is empty because `chrono` cannot hold it.

### Looking Things Up

| Call | Does |
|---|---|
| `Get( key )` | `Optional( of TomlValue )`, a copy of the entry |
| `Find( key )` | a `TomlValue ptr` into the tree, or `0`; no copy |
| `Has( key )` | whether the table has the key |
| `Path( "a.b.0.c" )` | keys separated by dots, a number indexing an array; empty when any step is missing |
| `Count( )`, `[ i ]`, `Item( i )`, `KeyAt( i )` | walk an array or a table by position (0-based) |
| `Keys( )` | a table's keys, in order |

`Path` cannot name a key that itself contains a dot; use `Get` for that.

### Building And Writing

```freebasic
#import "std/config"

dim as config.TomlValue root = config.TomlValue.NewTable( )
dim as config.TomlValue server = config.TomlValue.NewTable( )
server.SetKey( "host", config.TomlValue.FromString( "example.org" ) )
server.SetKey( "port", config.TomlValue.FromInt( 8080 ) )
root.SetKey( "name", config.TomlValue.FromString( "demo" ) )
root.SetKey( "server", server )
print config.ToTomlText( root ).Value( )
```

```toml
name = "demo"

[server]
host = "example.org"
port = 8080
```

`FromString`, `FromInt`, `FromFloat`, `FromBool`, `FromDateTime`, `FromLocalDate`, `FromLocalTime`, `NewTable` and `NewArray` make values; `SetKey` adds or replaces a table entry, `Push` appends to an array and `RemoveKey` deletes an entry. A `TomlValue` is a plain value: copying a table copies the whole tree. `Equals` compares two trees, table entries in any order.

`ToTomlText( root )` writes valid TOML 1.0. A table's plain entries come first, then its sub-tables as `[a.b]` sections and its arrays of tables as `[[a.b]]` sections, in the order they were added. Inline tables appear only where they must: an empty table (`{}`) and a table inside an array that is not all tables. Floats are written as the shortest text that reads back as the same number. Writing fails with `CFG_NOT_REPRESENTABLE` when the root is not a table or the tree holds a `TOML_NONE`.

**Comments are not kept.** A document read and written back loses its comments and may have its sections in a different order.

### The Table Rules

The reader enforces TOML's rules on where tables come from:

- a key, or a table, may be defined only once;
- `apple.color = "red"` under `[fruit]` defines the table `fruit.apple`, so a later `[fruit.apple]` is a duplicate, though `[fruit.apple.texture]` is fine;
- an inline table (`{ … }`) and an array written as a value are complete: nothing may be added to them later;
- `[[name]]` adds a table to an array of tables, and only to one made by `[[name]]`.

## INI

```freebasic
#import "std/config"

dim r as config.ConfigResultIni = config.LoadIni( "settings.ini" )
if r.IsOk( ) then
    dim as config.IniFile ini = r.Value( )
    print ini.Get( "database", "host" ).ValueOr( "localhost" )
    ini.SetValue( "database", "port", "5433" )
    config.SaveIni( ini, "settings.ini" )
end if
```

The dialect:

- `[section]` starts a section; keys before the first one are in section `""`;
- `key = value` or `key: value`, split at the first `=` or `:`;
- a line starting with `;` or `#` is a comment, but a `;` later in a line is part of the value;
- whitespace around names and values is dropped; a value in double quotes keeps the spaces inside them (the quotes are removed and nothing inside is unescaped);
- no line continuations, no `${…}` substitution.

| `IniFile` call | Does |
|---|---|
| `Get( section, key )` | `Optional( of ustring )` |
| `SetValue( section, key, value )` | replaces the value, or adds the key (and the section) at the end |
| `Sections( )`, `Keys( section )` | names, in file order |
| `Remove( section, key )` | removes a key; with no key, the whole section |
| `ToText( )` | the file as text; `SaveIni( ini, path )` writes it |

`IniOptions` changes two things: `CaseSensitiveKeys` (`false` by default, so `Host` and `host` are the same name, for sections as well as keys) and `Duplicates` — `INI_LAST_WINS` (the default: a repeated key replaces the first, a repeated section continues it) or `INI_DUP_ERROR`.

```freebasic
dim as config.IniOptions strict
strict.Duplicates = config.INI_DUP_ERROR
dim r as config.ConfigResultIni = config.ParseIni( text, strict )
```

Comments are not kept by `ToText`.

## Errors

Every failure is a `ConfigError`: `Code( )`, `Line( )` and `Column( )` (1-based; 0 when there is no position), `Detail( )` and `Message( )`, for example `line 2, column 1: duplicate key: 'x'`. For `CFG_IO`, `OsCode( )` is the [Filesystem](Category-Filesystem) error code.

| Code | Means |
|---|---|
| `CFG_SYNTAX` | the text is not TOML or INI |
| `CFG_DUPLICATE_KEY` | a key or table defined twice |
| `CFG_TYPE_REDEFINED` | a value used as a table, or an inline table or array extended |
| `CFG_INVALID_ESCAPE` | a bad backslash escape in a TOML string |
| `CFG_NUMBER_RANGE` | an integer outside 64 bits |
| `CFG_INVALID_DATETIME` | a date or time that is malformed or does not exist |
| `CFG_NOT_REPRESENTABLE` | a value `ToTomlText` cannot write |
| `CFG_IO` | the file could not be read |

Files are read as UTF-8, a byte order mark skipped.

## See Also

- [String Library](Category-String-Library) — `SplitCsv`, and `JoinCsvRow` / `CsvWriter` for writing CSV
- [Date and Time](Category-Date-and-Time-Chrono) — the `chrono` values TOML dates become
- [Optional](Category-Optional), [Result](Category-Result)
