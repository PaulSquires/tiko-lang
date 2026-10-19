# TOML settings

TOML is a settings format with types: strings, integers, floats, booleans,
dates, arrays and nested tables. `std/config` reads it into a tree of
`TomlValue`s, and every question you ask the tree answers a value or nothing,
so a missing setting falls back to a default instead of stopping the program.

```tiko
{{#include ../../examples/files/toml.tiko}}
```

**Output**

```text
{{#include ../../examples/files/toml.out}}
```

`LoadToml( path )` reads a file and `ParseToml( text )` reads text; both return
a `Result` whose value is the root table. `Path( "window.size.0" )` follows keys
separated by dots, a number indexing an array, and returns an `Optional`.
`AsInt( )`, `AsString( )`, `AsBool( )`, `AsFloat( )` and `AsDateTime( )` each
return an `Optional` too, empty when the value is another kind — so `Setting`
plus `ValueOr` turns "absent" and "wrong type" into the default.

Tables keep their keys in the order the file wrote them: `KeyAt( i )` and
`Keys( )` walk them that way. A file that breaks the rules — the same key
twice, a table defined twice, a number too big for 64 bits — fails with a
`ConfigError` naming the line and column.

To change a document, `SetKey`, `Push` and `RemoveKey` edit the tree and
`config.ToTomlText( root )` writes it back. Comments are not part of the tree,
so they do not survive the round trip.

### Activities

1. Change `retries = 3` to `retries = "3"` and see which default is printed.
2. Add `cfg.SetKey( "retries", config.TomlValue.FromInt( 5 ) )` and print
   `config.ToTomlText( cfg ).Value( )`.
