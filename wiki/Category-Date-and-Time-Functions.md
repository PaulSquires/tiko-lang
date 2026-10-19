[Home](Home) › [All Categories](Categories) › **Date and Time Functions**

# Date and Time Functions

<!-- finder:start -->

Grouped by task. [Dates and times](Functions-Dates) lists them beside the rest of the area.

## Get the current date and time

| Function | What it does | From |
|---|---|---|
| [Date](Date) | Returns today's date as text in the form mm-dd-yyyy. | built-in |
| [Time](Time) | Returns the current time as text in the form hh:mm:ss. | built-in |
| [Now](Now) | Returns the current local date and time as a date serial. | `datetime.bi` |

## Time how long something takes

| Function | What it does | From |
|---|---|---|
| [Timer](Timer) | Returns the seconds since a fixed starting point, for measuring elapsed time. | built-in |

## Make a date, a time or a date-time

| Function | What it does | From |
|---|---|---|
| [DateSerial](Dateserial) | Returns the date serial for a year, month and day; out-of-range values roll over. | `datetime.bi` |
| [TimeSerial](Timeserial) | Returns the fraction of a day for an hour, minute and second, to add to a date serial. | `datetime.bi` |

## Read the year, month, day and time

| Function | What it does | From |
|---|---|---|
| [Year](Year) | Returns the year of a date serial. | `datetime.bi` |
| [Month](Month) | Returns the month of a date serial, 1 to 12. | `datetime.bi` |
| [Day](Day) | Returns the day of the month of a date serial. | `datetime.bi` |
| [Hour](Hour) | Returns the hour of a date serial, 0 to 23. | `datetime.bi` |
| [Minute](Minute) | Returns the minute of a date serial. | `datetime.bi` |
| [Second](Second) | Returns the second of a date serial. | `datetime.bi` |
| [DatePart](Datepart) | Returns one part of a date serial, such as its year, quarter, week or hour. | `datetime.bi` |

## Add days, months and years

| Function | What it does | From |
|---|---|---|
| [DateAdd](Dateadd) | Returns a date serial moved by a number of years, months, days, hours or other units. | `datetime.bi` |

## Compare dates and count the days between

| Function | What it does | From |
|---|---|---|
| [DateDiff](Datediff) | Counts the years, months, days or other units between two date serials. | `datetime.bi` |

## Read dates and durations from text

| Function | What it does | From |
|---|---|---|
| [DateValue](Datevalue) | Returns the date serial for text written in the system's date format. | `datetime.bi` |
| [TimeValue](Timevalue) | Returns the date serial of a time written like 23:59:59 or 11:59:59PM. | `datetime.bi` |
| [IsDate](Isdate) | Returns true if the text can be read as a date in the system's date format. | `datetime.bi` |

## Weekdays, weeks and quarters

| Function | What it does | From |
|---|---|---|
| [Weekday](Weekday) | Returns the day of the week, 1 to 7, counting from Sunday unless told otherwise. | `datetime.bi` |

## Month and weekday names

| Function | What it does | From |
|---|---|---|
| [MonthName](Monthname) | Returns the name of a month number in the system's language, or its abbreviation. | `datetime.bi` |
| [WeekdayName](Weekdayname) | Returns the name of a weekday number in the system's language, or its abbreviation. | `datetime.bi` |

## Set the system clock

| Function | What it does | From |
|---|---|---|
| [SetDate](Setdate) | Sets the system date from text like mm-dd-yyyy; needs admin rights, 0 means success. | built-in |
| [SetTime](Settime) | Sets the system time from text like hh:mm:ss; needs admin rights, 0 means success. | built-in |

## Also in this category

- [Date and Time Functions](Date-and-Time-Functions)

<!-- finder:end -->

---

[Home](Home) · [Keyword Index](Keyword-Index)
