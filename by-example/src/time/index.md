# Dates and Times

A date looks simple and is not: months have four lengths, the same moment reads
differently on every city's clock, and `03/04/2025` means March in one country
and April in the next. The `std/chrono` module gives each idea its own type, so
a program says which one it means.

```tiko
{{#include ../../examples/time/overview.tiko}}
```

**Output**

```text
{{#include ../../examples/time/overview.out}}
```

`#import "std/chrono"` brings in five value types:

| Type | Holds |
|---|---|
| `LocalDate` | a calendar date, with no time |
| `LocalTime` | a time of day, with no date |
| `DateTime` | a date and a time, with or without an offset from UTC |
| `Instant` | one point on the UTC timeline, the same everywhere |
| `TimeSpan` | a fixed length of time |

All of them count in ticks of 100 nanoseconds and cover the years 1 to 9999.
The values are immutable: no method changes a value in place. `AddDays( 1 )`
returns a new date and leaves `day` as it was, so a date can be stored and
passed around without anything changing it underneath you.

The constructors take their fields from largest to smallest:
`LocalDate( y, mo, d )`, `LocalTime( h, mi, s, ms )`,
`DateTime( y, mo, d, h, mi, s, ms )` and `TimeSpan( d, h, mi, s, ms )`.

Every example in this section uses fixed dates, so its output is the same on
every run. A real program reads the clock with `chrono.WallClock.Today( )`,
`Now( )` or `UtcNow( )`.

### Activities

1. Print the `LocalDate` of your own birthday.
2. Make `when` one second before midnight and print `when.AddSeconds( 1 )`.
