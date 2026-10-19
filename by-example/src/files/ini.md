# INI files

An INI file is sections of `key = value` lines, every value text. It is the
format of many older programs' settings, and the easiest one for a person to
edit by hand.

```tiko
{{#include ../../examples/files/ini.tiko}}
```

**Output**

```text
{{#include ../../examples/files/ini.out}}
```

`ParseIni( text )` and `LoadIni( path )` return an `IniFile`. `Get( section,
key )` returns an `Optional( of ustring )`, and section and key names ignore
case, so `"paths"` finds `[Paths]`. Both `=` and `:` separate a key from its
value. A line starting with `;` or `#` is a comment; a `;` later in the line is
part of the value, as `logs` shows. Put a value in double quotes to keep spaces
at its ends.

`SetValue` replaces a value or adds the key at the end of its section,
`Remove( section, key )` deletes a key, and `Remove( section )` a whole
section. `ToText( )` gives the file back as text and `SaveIni( ini, path )`
writes it; comments are not kept.

A repeated key normally replaces the earlier one. With `IniOptions` you can
make that an error, or make names case-sensitive with `CaseSensitiveKeys`.

### Activities

1. Add a line `Data = /tmp` under `[Paths]` and check which value `Get`
   returns.
2. Set `strict.CaseSensitiveKeys = true` and look up `"paths"` with it.
