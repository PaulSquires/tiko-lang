# Dates

A `LocalDate` is a day on the calendar. Its parts are read with properties, and
the calendar's facts, such as leap years and month lengths, are static
functions on `DateTime`.

```tiko
{{#include ../../examples/time/dates.tiko}}
```

**Output**

```text
{{#include ../../examples/time/dates.out}}
```

`DayOfWeek` numbers the days the ISO 8601 way, **1 for Monday** through 7 for
Sunday, and `DateTime.WeekdayName( n )` turns the number into its name in the
user's language, as a `ustring` (English on the machine that made this output).
`DayOfYear`, `Quarter`, `IsoWeek` and `IsoWeekYear` complete the set.

A date with an out-of-range part is not rolled into the next month. The
constructor returns the **Invalid** value of its type, and `IsValid( )` says so:

- Invalid absorbs arithmetic: adding days to it gives Invalid again, so a chain
  of calculations can be checked once, at the end.
- It equals nothing, not even itself. Test with `IsValid( )`.
- It prints as an empty string.

A `LocalDate`, `DateTime` or `Instant` declared with no value is Invalid,
because no date is a sensible default. A `TimeSpan` starts at zero and a
`LocalTime` at midnight.

### Activities

1. Print the day of the week you were born on.
2. Find out which day of the year 31 December 2024 is, and why it is not 365.
