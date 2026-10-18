# Custom formats

When ISO 8601 is not the format a person or a protocol expects,
`ToString( pattern )` builds the text from pattern letters, and
`TryParseExact` reads it back with the same pattern.

```tiko
{{#include ../../examples/time/patterns.tiko}}
```

**Output**

```text
{{#include ../../examples/time/patterns.out}}
```

| Letters | Field | For `d` |
|---|---|---|
| `yyyy`, `yy` | year | `2025`, `25` |
| `M`, `MM`, `MMM`, `MMMM` | month | `3`, `03`, `Mar`, `March` |
| `d`, `dd`, `ddd`, `dddd` | day, weekday name | `4`, `04`, `Tue`, `Tuesday` |
| `H`, `HH`, `h`, `hh` | hour, 24- and 12-hour | `14`, `14`, `2`, `02` |
| `mm`, `ss` | minute, second | `30`, `05` |
| `tt` | AM or PM | `PM` |
| `zzz`, `K` | offset; `K` writes `Z` for UTC | `+01:00` |

The names are always English, whatever the machine's language, so the text
depends only on the value and the pattern. A one-letter pattern is a named
format: `"o"` round-trip ISO, `"s"` sortable, `"R"` RFC 1123 (converted to GMT
first, as the output shows), `"d"` the date and `"T"` the time.

Text in single quotes is copied as it is, and so is any character that is not
a letter. **A letter that is not a pattern letter is an error**, not a literal:
`TryFormat` returns `false` and `ToString` an empty string, so a typo shows at
once.

`TryParseExact( text, pattern, result )` says which number is the day, and
cross-checks fields that appear twice: "Monday" does not parse beside a date
that fell on a Tuesday.

### Activities

1. Print the date as `4-Mar-2025`.
2. Parse `"12/31/2025"` as month/day/year with `TryParseExact`.
