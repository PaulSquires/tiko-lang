# Adding days and months

Days have a fixed length; months do not. `std/chrono` keeps the two kinds of
arithmetic apart, and the difference shows at the end of a month.

```tiko
{{#include ../../examples/time/arithmetic.tiko}}
```

**Output**

```text
{{#include ../../examples/time/arithmetic.out}}
```

`AddDays` is exact. `AddMonths` and `AddYears` work on the calendar's fields
and then clamp the day to the end of the month, so 31 January plus one month
is 28 February. That loses information: two steps of one month end on
28 March, where one step of two months ends on 31 March.

```admonish danger title="Pitfall"
**Month arithmetic does not compose.** Adding a month at a time in a loop
drifts to the 28th and stays there. Add the whole number of months in one call,
counting from the original date.
```

Subtracting one `LocalDate` from another gives the number of days between them,
and dates compare with `<`, `=` and the other operators. `StartOfMonth` and
`EndOfMonth` give the first and last day of a date's month. A `DateTime` also
has `StartOfDay`, `StartOfWeek`, `StartOfYear`, `NextWeekday( n )` and
`PrevWeekday( n )`.

### Activities

1. Print the last day of every month of 2024 using `EndOfMonth`.
2. Count the days from 4 March 2025 to the next 1 January.
