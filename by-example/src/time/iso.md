# ISO 8601 text

ISO 8601 is the date format that sorts as text and means the same thing
everywhere: `2025-03-04T14:30:05+01:00`. Every chrono type writes it with
`ToIsoString( )`, which returns a `ustring`, and reads it with `TryParseIso`.

```tiko
{{#include ../../examples/time/iso.tiko}}
```

**Output**

```text
{{#include ../../examples/time/iso.out}}
```

**One value has exactly one string.** `ToIsoString( )` always writes a capital
`T`, a four-digit year, `Z` for UTC, `+HH:MM` for an offset and nothing when the
offset is unspecified, and a fraction of a second gets all seven digits or none.

**Reading accepts the other ISO forms**: the basic form with no separators,
week dates (`2025-W10-2` is the Tuesday of week 10), ordinal dates (`2025-063`
is the 63rd day), and a space in place of the `T`. It refuses anything that
would need a guess, such as `03/04/2025`, and dates that do not exist.

`TryParseIso( text, result )` returns `true` and fills `result`, or returns
`false` and sets `result` to Invalid; it never raises a runtime error.
`ParseIso( text )` returns the value or Invalid, and suits text you know is
good, such as a literal in the program.

A `TimeSpan` reads and writes ISO durations: `PT1H30M` is an hour and a half.
`P1W` is accepted as seven days; `P1M` is refused, because a month is not a
fixed length.

### Activities

1. Parse `"2025-12-31T23:59:59Z"` as an `Instant`, add one second, and print
   the result.
2. Find out what `TryParseIso` makes of `"2025-03-04T24:00:00"`.
