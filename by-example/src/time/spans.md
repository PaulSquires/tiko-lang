# Durations

A `TimeSpan` is a length of time that does not depend on the calendar: a lap,
a timeout, the time between two moments. It has two families of readers, and
mixing them up gives plausible numbers that are wrong.

```tiko
{{#include ../../examples/time/spans.tiko}}
```

**Output**

```text
{{#include ../../examples/time/spans.out}}
```

| Reader | Gives | For `span` |
|---|---|---|
| `TotalHours`, `TotalMinutes`, ... | the whole span in one unit, with a fraction | 26.5 |
| `Hours`, `Minutes`, ... | one piece of it | 2 |

`TimeSpan.FromSeconds`, `FromMinutes`, `FromHours`, `FromDays` and
`FromMilliseconds` build a span from one unit. Spans add, subtract, multiply
and divide by a number, and compare. The pieces of a negative span are all
negative, so they still add up to the whole.

Subtracting two `Instant` values gives a `TimeSpan`. The flight in the example
leaves at 09:00 five hours behind UTC and lands at 21:40 UTC; because both are
instants, the subtraction needs no offset arithmetic.

There is no `FromMonths`: a month is not a fixed length. Use
[`AddMonths`](arithmetic.md) on a date for that.

### Activities

1. Add up three lap times and print the total in minutes.
2. Print `TotalSeconds` and `Seconds` for `TimeSpan( 0, 1, 1, 1, 0 )`.
