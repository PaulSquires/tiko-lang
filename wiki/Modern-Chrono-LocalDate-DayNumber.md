[Home](Home) › [Date and Time (Chrono)](Category-Date-and-Time-Chrono) › [Chrono Date and Time](Category-Date-and-Time-Chrono) › **LocalDate.DayNumber**

# LocalDate.DayNumber

Returns the days since 0001-01-01; subtract two to count the days between dates.

## Syntax

```freebasic
LocalDate.DayNumber
```

## Examples

```freebasic
#import "std/numeric"
#import "std/chrono"
using chrono, numeric

dim as LocalDate d = LocalDate( 2026, 8, 13 )

print d.DayNumber            '' 739840

'' The whole value is this one number. Subtracting two of them is the
'' number of days between the dates, which needs no arithmetic on the
'' type itself.
dim as LocalDate e = d.AddDays( 10 )
print e.DayNumber - d.DayNumber         '' 10
```

---

**Library:** [Chrono Date and Time](Category-Date-and-Time-Chrono)  
**Category:** [Date and Time (Chrono)](Category-Date-and-Time-Chrono)  
**Documented under:** The Members
