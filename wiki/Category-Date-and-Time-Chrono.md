[Home](Home) › [All Categories](Categories) › **Date and Time (Chrono)**

# Date and Time (Chrono)

```freebasic
#import "std/chrono"
using chrono

dim as DateTime d = DateTime( 2025, 3, 4, 14, 30, 5, 0 ).WithOffset( 330 )
print d.ToIsoString( )                     ' 2025-03-04T14:30:05+05:30
print d.ToString( "dddd, dd MMMM yyyy" )   ' Tuesday, 04 March 2025

print DateTime( 2025, 2, 30 ).IsValid      ' false -- not normalized away

dim as TimeSpan age = WallClock.UtcNow( ) - d.ToInstant( )
print age.TotalDays

dim as Stopwatch sw = Stopwatch.StartNew( )
' ... work ...
print sw.ElapsedMilliseconds
```

## Why It Exists

FreeBASIC's date and time surface is the VB6 model: a date is a serial DOUBLE, resolution is one second, there is no duration type, no timezone concept, no ISO 8601, and no monotonic clock. DateSerial( 2025, 13, 40 ) does not fail -- it normalizes, so a bad date and a good one are indistinguishable afterwards. TIMER is the wall clock, which jumps backwards on an NTP correction, so every program that measures elapsed time with it is quietly wrong twice a year and occasionally in between.

This library ships ALONGSIDE all of that. Nothing in datetime.bi, vbcompat.bi, FORMAT or the runtime's existing date and time routines changed, and nothing here depends on them. The two meet at FromSerial / Serial, so a program migrates one function at a time. See migration.md for the member-by-member mapping.

NO COMPILER SUPPORT IS INVOLVED. This is a library: the runtime half is in tiko-rt (lib/rt/src/chrono/), the FreeBASIC types in the std/chrono module (pkg/std/chrono/). Nothing here is a keyword, and DateTime, Instant, WallClock and the rest stay available as your own identifiers: nothing is added to a program until it imports std/chrono, and the bare names only after 'using chrono'.

## The Tick

Everything measures in TICKS of 100 nanoseconds. A date-time is a count of ticks since 0001-01-01T00:00:00 in the proleptic Gregorian calendar.

```freebasic
range               year 1 .. year 9999
resolution          100 ns
representation      one LONGINT (DateTime adds a SHORT offset)
```

One integer, so these types pass in a register and copy trivially. There is no allocation anywhere in the value types and no destructor.

100 ns divides evenly into milliseconds and microseconds, and the epoch is far enough back that every interop epoch -- Unix, FILETIME, OLE, Julian day -- lands on a positive tick constant, so each conversion is one addition. That is the whole reason for both choices; rationale.md argues it against the alternatives.

## The Types

Five value types and four namespaces. Each type answers one question, and the split is deliberate -- a date and a time-of-day cannot be compared, subtracted, or passed to each other's functions.

```freebasic
TimeSpan      a fixed duration, signed. NOT a calendar period.
LocalDate     a date, no time, no offset
LocalTime     a time of day, no date, no offset: 0 .. a tick int16 of a day
Instant       an absolute point on the UTC timeline. No offset field,
              because an absolute point does not have one.
DateTime      a civil date-time PLUS a UTC offset

WallClock         what time is it (can jump)
Stopwatch     how int32 since (monotonic, never jumps)
CpuClock      how much CPU this process or thread burned
TimeZoneInfo  the OS zone: offset at an instant, DST, names
```

Roughly 260 members and 44 free operators.

DECLARATION ORDER IS LOAD-BEARING. FreeBASIC cannot forward-declare a UDT well enough to return one BY VALUE, so a type may only return types defined above it: TimeSpan, LocalDate, LocalTime, Instant, DateTime. That is why the Instant -> DateTime direction is spelled DateTime.FromInstant rather than Instant.ToUtc, and why DateTime.ToInstant is a member while its inverse is not.

WHICH ONE TO USE. If it is a timestamp -- when something happened, when it expires, anything compared across machines -- use Instant. If a human wrote it down or will read it, and the offset matters, use DateTime. If it is a birthday or a due date, use LocalDate. Storing a wall-clock reading and hoping the offset is obvious is the bug this type split exists to prevent.

## Immutable

Every operation returns a NEW value. Nothing modifies the receiver.

```freebasic
d = d.AddDays( 3 )              ' do
d.AddDays( 3 )                  ' does nothing -- result dropped
```

This is what java.time, NodaTime, Temporal, Rust and Go all converged on, and it is what makes it safe to pass one of these BYREF.

## Invalid Is Absorbing, AND Never Equal To Itself

There is no exception, no ERR( ), and no error code. Out-of-range construction and overflowing arithmetic both yield an Invalid value, and anything touching an Invalid value becomes Invalid. ARITHMETIC NEVER WRAPS.

```freebasic
DateTime( 2025, 2, 30 )         Invalid -- there is no such date
DateTime.MaxValue.AddTicks( 1 ) Invalid -- not MinValue
TimeSpan.Invalid + anything     Invalid
```

BEWARE: comparing an Invalid value with ANYTHING is false, INCLUDING with itself.

```freebasic
DateTime.Invalid = DateTime.Invalid       ' FALSE
DateTime.Invalid <> DateTime.Invalid      ' also FALSE
DateTime.Invalid.IsValid                  ' the only correct test
```

That is IEEE NaN's rule and it is here for IEEE NaN's reason: an equality that succeeded would let invalid values slip through a validation check that looks correct. Both <> and <= are written to return false when either side is Invalid, rather than falling out of a negated comparison.

CompareTo returns -2 for "not comparable", not 0. -2 is deliberately not an ordering, so a sort predicate written as 'CompareTo( ) < 0' does not silently treat Invalid as smallest.

The sentinel is LLONG_MIN, which lies outside every valid range, so a wrapped result can never collide with it. It costs TimeSpan exactly one value at the bottom: TimeSpan.MinValue is LLONG_MIN + 1.

DEFAULT CONSTRUCTION IS NOT UNIFORM, and this is the one asymmetry in the library:

```freebasic
dim as TimeSpan  s        ' zero
dim as LocalTime t        ' midnight
dim as LocalDate d        ' INVALID
dim as Instant   i        ' INVALID
dim as DateTime  x        ' INVALID, offset unspecified
```

Zero is a meaningful duration and a meaningful time of day, so those two default to it. There is no meaningful zeroth date or zeroth timestamp -- year 1 as a default is a value that reaches production -- so the other three default to Invalid. Do not rely on a defaulted DateTime, Instant or LocalDate being usable; test IsValid, which is what it is for.

## The Three Offset States

A DateTime carries the LOCAL wall-clock reading plus a UTC offset in minutes. It stores the wall reading, not the UTC instant, because that is what survives a round trip through ISO 8601 text without losing what the writer meant. C#'s DateTimeOffset and java.time's OffsetDateTime both do the same.

```freebasic
0                        explicitly UTC        renders as Z
-1080 .. 1080            a fixed offset        renders as +05:30
DT_OFFSET_UNSPECIFIED    naive; nobody said    renders bare
```

UNSPECIFIED IS A DISTINCT STATE FROM UTC. Conflating the two is the DateTimeKind.Unspecified mistake C# is stuck with. HasOffset says whether anyone said, IsUtc says whether the answer was zero, and ToInstant on a naive value is Invalid -- there is no defensible way to put a naive reading on the UTC timeline without guessing.

WithOffset REINTERPRETS: keeps the wall reading, changes the instant. ToOffset CONVERTS: keeps the instant, changes the wall reading.

```freebasic
DateTime( 2025, 3, 4, 12, 0, 0, 0 ).WithOffset( 60 )   ' 12:00+01:00
DateTime( 2025, 3, 4, 12, 0, 0, 0 ).WithOffset( 0 ) _
                                   .ToOffset( 60 )     ' 13:00+01:00
```

These are the pair people confuse. Neither is a safe default, which is why neither is implicit.

## The Members

Everything below is O(1) unless marked. The C kernel is branch-and-arithmetic with no loops over the range, so "convert 9999-12-31" costs what "convert 0001-01-01" costs. Text output allocates once; parsing allocates nothing.

TimeSpan -- a fixed duration

```freebasic
TimeSpan( )                                   zero
TimeSpan( ticks )
TimeSpan( h, mi, s )
TimeSpan( d, h, mi, s, ms )
.FromDays / FromHours / FromMinutes / FromSeconds /
  FromMilliseconds( float64 )                  rounds half away from zero
.FromMicroseconds( int64 )                  int64, not float64
.FromTicks( int64 )
.Zero / .MinValue / .MaxValue / .Invalid

.Ticks                                        int64
.TotalDays .TotalHours .TotalMinutes
  .TotalSeconds .TotalMilliseconds            float64, the whole span
.TotalMicroseconds                            int64
.Days .Hours .Minutes .Seconds
  .Milliseconds .Microseconds                 int32, the broken-down pieces
.IsValid .IsZero .IsNegative

.Negate .Duration                             Duration is absolute value
.Add .Subtract .Multiply( f ) .Divide( f )
.DivideBy( other )                            float64; NaN on zero or Invalid
.CompareTo( other )                           -1 0 1, or -2

.ToIsoString / .ToString                      P1DT2H3M4.5S
.TryParseIso( s, result ) / .ParseIso( s )
.ToIsoUString                                 the USTRING form

operators: + - (binary and unary) * / = <> < > <= >=
           'double * span' as well as 'span * double'

TOTALS vs COMPONENTS. Total* is the whole span in that unit, fractionally.
The components are the pieces. For 1 day 2 hours 3 minutes: TotalHours is
26.05, Hours is 2.

COMPONENTS OF A NEGATIVE SPAN ARE ALL NEGATIVE, matching C#. -1h30m has
Hours = -1 and Minutes = -30, not -1 and +30, so the pieces always
reconstruct the whole.

THERE IS NO FromMonths, on purpose. A month has no fixed length, so it is
not a duration; that is AddMonths, which takes a LONG and lives on the
date types. Keeping the two kinds of arithmetic visibly separate is the
point.
```

LocalDate -- a date

```freebasic
LocalDate( )                                  Invalid
LocalDate( y, mo, d )
.FromDayNumber( days ) / .MinValue / .MaxValue / .Invalid

.IsValid .DayNumber
.Year .Month .Day .DayOfWeek .DayOfYear
.IsoWeek .IsoWeekYear .Quarter
.IsFirstDayOfMonth .IsLastDayOfMonth

.AddDays( n ) .AddMonths( n ) .AddYears( n )
.StartOfMonth .EndOfMonth
.CompareTo

.ToIsoString / .ToString                      2025-03-04
.TryParseIso / .ParseIso  (+ USTRING overloads, .ToIsoUString)

operators: - (gives a LONG day count) = <> < > <= >=
```

LocalTime -- a time of day

```freebasic
LocalTime( )                                  midnight
LocalTime( h, mi, s, ms )
.FromTicks / .Midnight / .Noon / .MaxValue / .Invalid

.IsValid .Ticks
.Hour .Minute .Second .Millisecond .Microsecond
.CompareTo

.ToIsoString / .ToString                      14:30:05.1234567
.TryParseIso / .ParseIso  (+ USTRING overloads, .ToIsoUString)

operators: - (gives a TimeSpan) = <> < > <= >=
```

Instant -- a point on the UTC timeline

```freebasic
Instant( ) / Instant( ticks )
.FromTicks / .MinValue / .MaxValue / .Invalid
.IsValid .Ticks
.Add( span ) .Subtract( span ) .CompareTo

.FromUnixSeconds / FromUnixMilliseconds / FromUnixMicroseconds
.UnixSeconds / .UnixMilliseconds / .UnixMicroseconds

.ToIsoString / .ToString                      2025-03-04T14:30:05.1234567Z
.TryParseIso / .ParseIso  (+ USTRING overloads, .ToIsoUString)

operators: instant + span, instant - span, instant - instant -> TimeSpan,
           = <> < > <= >=

Instant.TryParseIso REQUIRES AN OFFSET IN THE INPUT. A naive reading cannot
be placed on the UTC timeline without guessing, and refusing is the type
system doing its job rather than a limitation.
```

DateTime -- a civil date-time with an offset

```freebasic
construction and identity

DateTime( )                                   Invalid, offset unspecified
DateTime( y, mo, d )
DateTime( y, mo, d, h, mi, s, ms )
.FromTicks( t, offMin ) .FromDate( date ) .FromDateTime( date, time )
.FromInstant( instant, offMin )
.MinValue .MaxValue .Invalid
.IsValid .Ticks .OffsetMinutes .HasOffset .IsUtc

components

.Year .Month .Day .Hour .Minute .Second
.Millisecond .Microsecond .TickOfDay
.DayOfWeek .DayOfYear .IsoWeek .IsoWeekYear .Quarter
.IsFirstDayOfMonth .IsLastDayOfMonth
.GetDate -> LocalDate      .GetTimeOfDay -> LocalTime

offsets and instants

.WithOffset( offMin )   reinterpret   .ToOffset( offMin )   convert
.AssumeUtc -> Instant   .ToInstant -> Instant   .ToLocal -> DateTime

exact arithmetic -- ticks, no calendar

.Add( span ) .Subtract( span ) .AddTicks( n )
.AddDays .AddHours .AddMinutes .AddSeconds .AddMilliseconds   (float64)

calendar arithmetic -- LONG, not a TimeSpan

.AddMonths( n ) .AddYears( n )
.AddCalendarDays( n ) .AddCalendarMonths( n ) .AddCalendarYears( n )

calendar utilities

.IsLeapYear( y ) .DaysInMonth( y, mo ) .DaysInYear( y ) .WeeksInYear( y )
.StartOfDay .EndOfDay .StartOfMonth .EndOfMonth .StartOfYear .EndOfYear
.StartOfWeek( firstDay = DT_MONDAY )
.NextWeekday( dow ) .PrevWeekday( dow )

interop

.FromUnixSeconds .FromUnixMilliseconds
.UnixSeconds .UnixMilliseconds .UnixMicroseconds
.FromSerial( float64 ) / .Serial            legacy datetime.bi
.FromFileTime( int64 ) / .FileTime       Win32 FILETIME
.FromOleDate( float64 ) / .OleDate          OLE automation date
.FromJulianDay( float64 ) / .JulianDay / .JulianDayNumber

text

.ToIsoString .ToString                     ToString( ) is ToIsoString( )
.TryParseIso .TryParse .ParseIso
.ToString( pattern ) .TryFormat( pattern, result )
.TryParseExact( s, pattern, result ) .ParseExact( s, pattern )
.ToLocaleDateString / ToLocaleTimeString / ToLocaleString( style )
.MonthName( mo [, abbrev] ) .WeekdayName( dow [, abbrev] )

USTRING: .ToIsoUString, .ToString( ustring ), .TryFormat, .TryParseIso,
.TryParse, .ParseIso, .TryParseExact, .ParseExact, .ToLocaleDateUString,
.ToLocaleTimeUString, .ToLocaleUString, .MonthUName, .WeekdayUName

operators: datetime + span, datetime - span, datetime - datetime ->
           TimeSpan, = <> < > <= >=
```

WallClock -- the wall clock

```freebasic
WallClock.UtcNow -> Instant
WallClock.Now -> DateTime          carries the offset in force AT THAT INSTANT
WallClock.Today -> LocalDate
WallClock.TimeOfDay -> LocalTime
WallClock.Resolution -> TimeSpan
```

Stopwatch -- the monotonic clock

```freebasic
Stopwatch( ) / Stopwatch.StartNew
.Start .Stop_ .Reset .Restart
.IsRunning .Elapsed -> TimeSpan .ElapsedMilliseconds .ElapsedTicks
Stopwatch.Frequency .GetTimestamp .IsHighResolution

'Stop_' has the trailing underscore because STOP is a FreeBASIC statement.
```

CpuClock -- consumed processor time

```freebasic
CpuClock.ProcessTime         user + kernel
CpuClock.ProcessUserTime
CpuClock.ProcessKernelTime   Invalid where the OS does not split it
CpuClock.ThreadTime          the total; no user/kernel split is exposed
CpuClock.IsSupported

Process time splits on both platforms -- GetProcessTimes on Windows,
getrusage on Unix, which is used in preference to
CLOCK_PROCESS_CPUTIME_ID precisely because it reports the two halves.
Thread time does not split on Unix (CLOCK_THREAD_CPUTIME_ID is one
number), so the C layer returns -1 for the kernel half and ThreadTime
reports the total rather than inventing a division.
```

TimeZoneInfo -- the OS zone

```freebasic
TimeZoneInfo.LocalOffsetAt( instant )      the offset AT THAT INSTANT
TimeZoneInfo.LocalOffset                   the offset right now
TimeZoneInfo.IsDaylightSavingTime( instant )
TimeZoneInfo.SupportsDaylightSavingTime
TimeZoneInfo.StandardName / .DaylightName

LocalOffsetAt EXISTS BECAUSE "the current offset" IS THE WRONG DEFAULT.
Converting a July timestamp with January's offset is the commonest timezone
bug there is, and an API offering only LocalOffset makes it the easy path.
```

## EXACT ARITHMETIC vs CALENDAR ARITHMETIC

Three families, and the names say which is which.

```freebasic
AddDays( 1 )            exactly 86400 seconds. Does NOT keep the wall-clock
                        time across a DST boundary.
AddCalendarDays( 1 )    same wall-clock time tomorrow. Re-resolves the
                        offset, so across a DST boundary it is 23 or 25
                        hours of real time.
AddMonths( 1 )          calendar months, offset untouched.
AddCalendarMonths( 1 )  calendar months, offset re-resolved.
```

"24 hours from now" is AddDays( 1 ). "Same time tomorrow" is AddCalendarDays( 1 ). They differ twice a year, and a program that means one and writes the other is correct in testing and wrong in October.

CALENDAR ARITHMETIC CLAMPS AT MONTH END, AND IS THEREFORE LOSSY:

```freebasic
2025-01-31 .AddMonths(  1 )              2025-02-28
2024-01-31 .AddMonths(  1 )              2024-02-29
2025-01-31 .AddMonths(  1 ).AddMonths( -1 )   2025-01-28   -- not 01-31
2025-01-31 .AddMonths(  2 )              2025-03-31
2025-01-31 .AddMonths(  1 ).AddMonths( 1 )    2025-03-28   -- not 03-31
```

Clamping is not associative and it is not reversible. Every library that does calendar arithmetic has this property; the alternative is rolling into the next month, which is worse. Add the larger step in one call rather than accumulating.

The time of day and the offset ride through AddMonths untouched. AddYears is AddMonths( n \* 12 ), so 2024-02-29.AddYears( 1 ) is 2025-02-28.

START/END HELPERS KEEP THE OFFSET AND SET THE TIME. EndOfDay, EndOfMonth and EndOfYear are the LAST TICK of that period -- 23:59:59.9999999 -- not the first tick of the next one. Compare with <= against them, or use the start of the next period with <.

StartOfWeek takes the first day of the week and defaults to Monday. NextWeekday and PrevWeekday are STRICTLY later and strictly earlier: asking a Tuesday for the next Tuesday gives a week forward, not a no-op. A weekday outside 1..7 is Invalid, not clamped.

DAY OF WEEK IS 1 = MONDAY, ISO 8601's numbering, which differs from datetime.bi's Weekday( ) where 1 = Sunday. The ISO week-number algorithm needs it, and two neighbouring conventions is one too many. This is the single most likely thing to trip a program moving over from the legacy surface.

ISO WEEK-YEAR IS NOT THE YEAR. 2025-12-29 is week 1 of ISO year 2026. Rendering IsoWeek beside Year instead of IsoWeekYear is the canonical bug in ISO week output, which is why both are exposed and neither is called "Week".

## ISO 8601 AND RFC 3339

EMISSION IS CANONICAL AND SINGLE-VALUED. One value produces exactly one string. All the variety ISO 8601 permits is accepted on input only.

```freebasic
Instant                 2025-03-04T14:30:05.1234567Z
DateTime, offset        2025-03-04T14:30:05.1234567+05:30
DateTime, UTC           2025-03-04T14:30:05.1234567Z
DateTime, unspecified   2025-03-04T14:30:05.1234567
LocalDate               2025-03-04
LocalTime               14:30:05.1234567
TimeSpan                P1DT2H3M4.5S
```

Extended format only, always with the separators. Uppercase T. Four-digit year, which is why the range stops at 9999. Offset is always +-HH:MM with the colon; UTC emits Z, never +00:00.

THE FRACTIONAL PART IS ALL SEVEN DIGITS OR NONE. Zero sub-second ticks emit no fraction at all; anything else emits exactly seven digits with no trailing-zero trimming. Fixed width is what makes these strings sort lexicographically, which is the property that matters once they land in a log or a database key.

An Invalid value emits the empty string. ToIsoString never fails; the maximum output is 33 bytes and the C core writes into a caller-supplied buffer.

A DURATION IS THE ONE EXCEPTION TO THE FIXED-WIDTH FRACTION -- P1DT2H3M4.5S, not 4.5000000S -- because a duration is not a sort key. Zero is PT0S, never a bare "P". A negative duration leads with the sign, outside the P: -PT2H.

The duration parser accepts weeks (P1W = 7 days) and, like the emitter, allows a fraction ON THE SECONDS FIELD ONLY. PnM and PnY ARE REJECTED: months and years are not fixed-length, which is the same reason there is no TimeSpan.FromMonths. A bare "P" is an error.

PARSING IS STRICT. No locale, no guessing, no partial acceptance, and trailing characters are an error. What is accepted beyond the canonical form:

```freebasic
basic format                20250304T143005Z    filenames, older protocols
ordinal date                2025-063
ISO week date               2025-W10-2
comma as decimal point      14:30:05,123        the ISO-preferred form
space instead of T          2025-03-04 14:30:05 RFC 3339 5.6, every SQL db
lowercase t and z           RFC 3339
hour-only offset            +05      and  +0530 without the colon
more than 7 fraction digits TRUNCATED, not rejected
```

That last one is the only lenient behaviour in the parser, and it is deliberate: rejecting a nanosecond timestamp would fail against Go and Rust output.

Rejected outright: two-digit years, ever -- there is no century-inference rule and there will not be one. 24:00 as end of day, which is legal ISO 8601 and a landmine; the next day's 00:00 says the same thing without the ambiguity. Negative and expanded years. Leap seconds (:60).

THE PARSE CONTRACT, for every type:

```freebasic
1. true and 'result' assigned on success.
2. false and 'result' = Invalid on failure. RESULT IS ALWAYS WRITTEN, so a
   caller who ignores the return value cannot read a stale value.
3. Never raises err( ), never throws, never writes to stderr.
4. Leading and trailing ASCII whitespace is trimmed first. Interior
   whitespace, other than the float32 RFC 3339 space, is an error.
5. Empty or all-whitespace input is a failure, not a zero value.
6. int8-oriented ASCII. A UTF-8 BOM is not skipped; it is an error.
```

ParseIso is TryParseIso with the boolean dropped -- it returns Invalid on failure and is for the cases where a literal is known good.

## Custom Patterns

ToString( pattern ) and TryParseExact. OUTPUT DEPENDS ONLY ON THE VALUE AND THE PATTERN -- names are invariant English, never the OS locale -- so this is the formatter to use for anything written to a file, a protocol or a log.

DATE                                        example, 2025-03-04

```freebasic
y      year, minimum digits               2025
yy     year, last two digits              25
yyyy   year, 4 digits padded              2025
yyyyy  year, 5 digits padded              02025
M MM   month, 1-2 / 2 digits              3 / 03
MMM    month abbreviation, English        Mar
MMMM   month name, English                March
d dd   day of month                       4 / 04
ddd    weekday abbreviation, English      Tue
dddd   weekday name, English              Tuesday
D DDD  day of year                        63 / 063
Q      quarter                            1      format-only
w ww   ISO week                           10     format-only
Y      ISO week-year                      2025   format-only
g      era                                A.D.   format-only
```

TIME                                        example, 14:30:05.1234567

```freebasic
H HH   hour 0-23                          14
h hh   hour 1-12                          2 / 02
m mm   minute                             30
s ss   second                             05
f..fffffff   fraction, 1-7 digits, zero-padded, ALWAYS SHOWN
F..FFFFFFF   fraction, trailing zeros and the whole field OMITTED if zero
t tt   AM/PM, invariant                   P / PM
```

OFFSET

```freebasic
z      sign + hours                       +5
zz     sign + 2-digit hours               +05
zzz    +-HH:MM                            +05:30
K      Z if UTC, +-HH:MM if offset, EMPTY if unspecified
```

K is the one for machine-readable output: it is what makes a pattern round-trip a naive DateTime correctly.

LITERALS. Single quotes delimit a literal run, '' inside is an apostrophe, and \\c escapes the next character. Any character that is not an ASCII letter is literal without quoting -- '-', '/', ':', '.', ',', space, digits.

AN UNRECOGNIZED ASCII LETTER IS A PATTERN ERROR, NOT A LITERAL. Silently passing an unknown letter through turns a typo into wrong output; failing turns it into a caught bug. An unterminated quote is an error too. On any pattern error ToString returns the empty string and TryFormat returns false -- which is why TryFormat exists, to separate "the pattern is broken" from "the value formatted to nothing".

A PATTERN OF EXACTLY ONE CHARACTER IS A NAMED FORMAT, not a field:

```freebasic
"o" "O"   round-trip ISO 8601      2025-03-04T14:30:05.1234567Z
"s"       sortable, no offset      2025-03-04T14:30:05
"u"       universal sortable       2025-03-04 14:30:05Z
"R"       RFC 1123, for HTTP       Tue, 04 Mar 2025 09:00:05 GMT
"d"       invariant short date     2025-03-04
"T"       invariant time           14:30:05
```

To format a single letter as a field, give a two-character pattern with a literal in it. This is a known wart inherited from the C# design; the shorthands earn it.

"R" emits GMT and English names regardless of locale AND regardless of the value's offset -- the value is converted to UTC first, which is what RFC 1123 requires and what the classic HTTP-header bug gets wrong.

PARSING A PATTERN is strict in the same way:

- The input must match exactly. No leading or trailing characters, and a

```freebasic
literal space matches exactly one space.
```

- Fixed-width fields (MM, dd, HH, yyyy, fff) consume exactly that many digits.

```freebasic
Variable-width fields (M, d, H) take 1-2 digits greedily.
```

- A variable-width numeric field immediately followed by another numeric field

```freebasic
is A PATTERN ERROR. "Md" cannot be parsed unambiguously, and failing at
pattern-compile time beats failing on the 3rd of December.
```

- Name fields match invariant English, case-insensitively. - Absent fields default to year 1, month 1, day 1, times 0, offset

```freebasic
unspecified.
```

- A field appearing twice with CONFLICTING values fails. Redundant but

```freebasic
consistent fields are accepted and CROSS-CHECKED: a pattern with both dddd
and yyyy-MM-dd fails if the named weekday is not that date's weekday.
```

- The assembled components go through the ordinary constructor, so 2025-02-30

```freebasic
fails there.
```

FORMAT-ONLY PATTERNS ARE A PATTERN ERROR IN A PARSE, not a silent success: Q, w, ww (a week or quarter cannot reconstruct a date), Y (derived), g (no information in a range that is entirely A.D.), and the "R" and "u" constant formats (they convert to UTC). "o", "O", "s", "d" and "T" parse.

## Clocks

THREE CLOCKS, BECAUSE THEY ANSWER THREE DIFFERENT QUESTIONS.

WallClock is the wall clock: what time is it. IT CAN JUMP BACKWARDS -- NTP corrections, DST, a user setting the clock -- so it is the wrong tool for measuring elapsed time, and so is TIMER. WallClock.Now records the offset in force at that instant, so WallClock.Now( ).ToInstant( ) round-trips even across a DST change.

Stopwatch is the monotonic clock: how long since. It never jumps. It ACCUMULATES rather than recomputing from two stored timestamps, so start/stop/start is correct with no special cases -- Elapsed is a property over an accumulator, not a subtraction of endpoints.

CpuClock is consumed processor time, which a SLEEP does not advance. That is the whole point of having it: it separates "the operation took 3 seconds" from "the operation used 3 seconds of CPU". Granularity is coarse -- about 15.6 ms on Windows -- so a short measurement reads as zero rather than as a small number.

WallClock and CpuClock are NAMESPACES, not types, because FreeBASIC will not accept a TYPE with no data members. The call syntax is identical either way.

## Locale Output, AND Why It Is Segregated

ToLocaleDateString, ToLocaleTimeString, ToLocaleString, MonthName and WeekdayName ask the OS. Their output is whatever the machine says, in the user's language, in whatever order that locale writes dates.

```freebasic
lsShort   lsLong   lsFull        the style argument, default lsShort
```

ONLY lsShort IS A DISTINCT STYLE TODAY. Both backends branch on "is it short", so lsFull renders as lsLong -- DATE_LONGDATE on Windows, "%A %d %B %Y" through strftime on Unix. The third name is in the API because the OS surfaces can support it; do not write code that depends on the two differing.

THIS IS THE ONLY PART OF THE LIBRARY WHOSE OUTPUT IS NOT REPRODUCIBLE, and it is deliberately in its own corner of the API with "Locale" in every name. Use it for text a human reads on that machine. Use the pattern formatter for anything that is written down, parsed later, compared, or sent anywhere.

Its tests assert non-emptiness, valid UTF-8, ordering and distinctness, and nothing more -- exact-string assertions there would be either locale-pinned or dishonest. RFC-0007 section 3 says so outright.

Locale output is also the only part of the library that is routinely non-ASCII, and so the only part where the USTRING overloads genuinely earn their place.

## Strings: String Core, Ustring Overloads

The core is STRING, holding UTF-8. USTRING overloads are layered on top, following the same rule std/strings uses: THE INPUT TYPE DECIDES THE OUTPUT TYPE, and a function cannot return the type it was handed.

So anything TAKING text overloads on ustring and returns ustring, and anything taking NO text cannot overload on return type alone -- which is why those carry a U in the name:

```freebasic
d.ToString( "yyyy-MM-dd" )        pattern is a string  -> string
d.ToString( uPattern )            pattern is a ustring -> ustring
d.ToIsoString( )                  -> string
d.ToIsoUString( )                 -> ustring
DateTime.MonthName( 3 )           -> string
DateTime.MonthUName( 3 )          -> ustring
```

Parsing is byte-oriented ASCII throughout; the ustring parse overloads convert to UTF-8 and run the same C parser, which is exact for every input the parser accepts.

## Interop AND The Legacy Bridge

Six external epochs, each one addition away from the tick model:

```freebasic
Unix seconds/ms/us      Instant and DateTime, both directions
Win32 FILETIME          .FileTime / .FromFileTime      1601-01-01
OLE automation date     .OleDate / .FromOleDate        1899-12-30
Julian day              .JulianDay / .JulianDayNumber / .FromJulianDay
legacy serial float64   .Serial / .FromSerial          datetime.bi

dim as float64 serial = DateSerial( 2025, 3, 4 )
dim as chrono.DateTime d = chrono.DateTime.FromSerial( serial )
dim as float64 back   = d.Serial
```

The serial bridge is LOSSY BELOW ABOUT A MILLISECOND -- a double carries ~15 significant digits and a present-day serial spends most of them on the integer part. Everything above millisecond resolution round-trips exactly, asserted over 1900-2100. Nothing else in this list is lossy.

migration.md maps every datetime.bi and AfxNova member to its equivalent, and says so plainly where there is none.

## The Rules That Are Easy To Get Wrong

Each has a defensible opposite, so each is a decision rather than an accident, and each is asserted in the suite.

```freebasic
Invalid = Invalid                false. Use IsValid.
CompareTo with an Invalid        -2, which is not an ordering
MaxValue.AddTicks( 1 )           Invalid, never a wrap
DateTime( 2025, 13, 1 )          Invalid, never normalized into 2026-01-01
dim as LocalDate d               Invalid -- but a defaulted TimeSpan and
                                 LocalTime are zero, which is a real value
naive.ToInstant( )               Invalid -- nobody said what the offset was
naive.AssumeUtc( )               the way to say it, and it names the
                                 assumption in the call
EndOfDay                         the last tick, 23:59:59.9999999
NextWeekday( sameDay )           a week forward, not a no-op
DayOfWeek                        1 = Monday, unlike Weekday( )
IsoWeekYear                      not Year, at either end of December
AddDays( 1 ) across DST          exactly 86400s; the wall time moves
AddMonths then reverse           does not return to the original day
TotalHours vs Hours              26.05 vs 2, for the same span
negative span components         all negative, so they reconstruct
TimeSpan.DivideBy( zero )        NaN, not Invalid -- it is a float64
ToString( "d" )                  the named int16-date format, not a field
ToLocaleString                   not reproducible; never write it to a file
```

TIME ZONES ARE THE OS's. There is no IANA tzdb, no named zones and no DST-ambiguity policy. Programs that care about an exact point in time should carry an Instant and never round-trip through a naive DateTime.

## WHERE THIS DIFFERS FROM datetime.bi

1. OUT-OF-RANGE INPUT IS REFUSED, NOT NORMALIZED. DateSerial( 2025, 13, 40 )

```freebasic
rolls into the next year; DateTime( 2025, 13, 40 ) is Invalid. Normalizing
means a typo and a valid date are indistinguishable one line later.
```

2. PARSING IS STRICT AND HAS NO LOCALE. DateValue guesses field order from the

```freebasic
machine's locale, so "03/04/2025" means two different days in two countries.
TryParseIso refuses it, and TryParseExact makes you say which you meant.
```

3. DAY OF WEEK IS 1 = MONDAY, not 1 = Sunday.

4. THERE IS A DURATION TYPE. The legacy answer to "how far apart" is a

```freebasic
subtraction of two doubles giving fractional days, which loses what unit it
is in as soon as it is stored.
```

5. RESOLUTION IS 100 ns, not 1 second, and it does not degrade with distance

```freebasic
from the epoch -- a serial double loses sub-second precision simply by being
a large number.
```

6. ELAPSED TIME HAS ITS OWN CLOCK. TIMER is the wall clock and jumps; Stopwatch

```freebasic
does not.
```

7. AN OFFSET IS CARRIED, AND ITS ABSENCE IS RECORDED. Now( ) returns local time

```freebasic
with no way to say so. WallClock.Now( ) records the offset it was taken under.
```

Nothing in datetime.bi changed, and both surfaces can be used in the same program. Where a legacy call has no equivalent here, migration.md says so instead of inventing one.

AGAINST AfxNova's date and time helpers, the shape of the difference is the same, plus: nothing here is Windows-only or COM-bound, and the formatter is invariant by default with locale output as the opt-in rather than the reverse. comparison-matrix.md scores this library, datetime.bi, AfxNova, C#, java.time and NodaTime feature by feature.

## What Is NOT Here

Each is argued in rationale.md rather than left as an omission.

```freebasic
LEAP SECONDS. The tick line is a count; a leap second is a discontinuity
that needs a table which must be updated by hand and which no OS exposes
reliably. UTC-SLS and the smeared clocks are what production systems
actually run.

THE IANA TZ DATABASE, NAMED ZONES, AND DST-AMBIGUITY POLICIES. The OS
already knows the user's zone and keeps its rules current; shipping and
maintaining a copy of the tzdb is a project of its own. Nothing here
forecloses a future ZonedDateTime -- DateTime already carries an offset.

NON-GREGORIAN CALENDARS. Proleptic Gregorian, year 1 to 9999, and no
calendar abstraction to make room for others.

A LENIENT PARSER. There is no equivalent of DateValue's guessing. If the
input is not ISO 8601, name the pattern.

AssumeLocal. RFC-0007 declares it; the shipped module has AssumeUtc,
ToInstant and ToLocal but not AssumeLocal. Compose it as
d.WithOffset( TimeZoneInfo.LocalOffset ).ToInstant( ) when the value is
known to be present-day, and read RFC-0007 section 1 on why a fall-back
hour makes the general case ambiguous.
```

## Implementation

```freebasic
pkg/std/chrono/                 the whole FB surface -- one #import
lib/rt/src/inc/chrono.bi        the tick representation and its constants
lib/rt/src/chrono/core.bas      civil<->tick kernel, calendar primitives
lib/rt/src/chrono/iso.bas       ISO 8601 emit and strict parse
lib/rt/src/chrono/pattern.bas   pattern formatter and parser, invariant
lib/rt/src/chrono/clock.bas     wall, monotonic and CPU clocks
lib/rt/src/chrono/zone.bas      offsets, DST, locale formatting
```

The kernel in core.bas is PURE: no OS calls, no allocation, no locale, no static state. Everything platform-specific is in clock.bas and zone.bas, which is what makes the civil<->tick conversion testable exhaustively.

The FB side is a module of value types with no compiler support of any kind. Its C entry points are reached through 'extern "C" declare ... alias' -- the pattern inc/string.bi already uses. Note that 'alias' alone is not enough inside a module: without the extern "C" the name is mangled through the module's chain.

clock.bas and zone.bas each hold BOTH platform halves, chosen by #if. fbc keeps a win32/ and a unix/ copy of each and compiles one; tiko-rt's build has no per-target source selection, so the split is made inside the file.

zone.bas resolves GetTimeZoneInformationForYear, which needs Windows 7, through GetProcAddress rather than importing it, so the binary's minimum OS is not raised for one function. When it is absent the static fallback still answers correctly for the current year.

## Tests

```freebasic
tests/vendor/fbc-tests/chrono/core.bas       ticks, components, construction, Invalid
tests/vendor/fbc-tests/chrono/spans.bas      TimeSpan, totals, components, operators
tests/vendor/fbc-tests/chrono/calendar.bas   calendar arithmetic and utilities
tests/vendor/fbc-tests/chrono/clocks.bas     WallClock, Stopwatch, CpuClock
tests/vendor/fbc-tests/chrono/iso.bas        ISO 8601 emit and parse, both directions
tests/vendor/fbc-tests/chrono/pattern.bas    every pattern letter at every run length
tests/vendor/fbc-tests/chrono/zones.bas      offsets, DST, locale invariants
tests/vendor/fbc-tests/chrono/utext.bas      the USTRING overloads
```

These are fbc's own fbcunit suites, vendored in tiko-lang. Under tiko all 8 of 8 match fbc (build/suiterun.sh, which builds each suite with both compilers and compares the results tables; measured 2026-09-24 at origin/master 50c71751), and so do all 3 suites for the older VB-style surface in tests/vendor/fbc-tests/datetime/.

ASSERT YOUR TEST GENERATOR'S RANGE. Every fixed-seed sweep here originally drew its tick as 'clngint( ( seed shr 11 ) mod culngint( DT_MAX_TICKS ) )'. The shift leaves 53 bits, 2^53 is SMALLER than DT_MAX_TICKS, so the mod was a no-op and every "random" value landed in years 1-29. Five suites were affected and their coverage claims were overstated for four phases before it was caught. The correct form is 'clngint( seed mod culngint( DT_MAX_TICKS ) )'. Re-running found no implementation bugs -- the layers were right, the sweeps were just tiny.

## Dialects

-lang fb. The library is namespaced, uses properties and operator overloading throughout, and the USTRING overloads need tiko-lang's USTRING type.

## API reference

One page per entry, 190 in all:

[AddCalendarDays](Modern-Chrono-AddCalendarDays) · [AddCalendarMonths](Modern-Chrono-AddCalendarMonths) · [AddDays](Modern-Chrono-AddDays) · [AddMonths](Modern-Chrono-AddMonths) · [Instant.Add](Modern-Chrono-Instant-Add) · [Instant.AddCalendarDays](Modern-Chrono-Instant-AddCalendarDays) · [Instant.AddCalendarMonths](Modern-Chrono-Instant-AddCalendarMonths) · [Instant.AddCalendarYears](Modern-Chrono-Instant-AddCalendarYears) · [Instant.AddDays](Modern-Chrono-Instant-AddDays) · [Instant.AddHours](Modern-Chrono-Instant-AddHours) · [Instant.AddMilliseconds](Modern-Chrono-Instant-AddMilliseconds) · [Instant.AddMinutes](Modern-Chrono-Instant-AddMinutes) · [Instant.AddMonths](Modern-Chrono-Instant-AddMonths) · [Instant.AddSeconds](Modern-Chrono-Instant-AddSeconds) · [Instant.AddTicks](Modern-Chrono-Instant-AddTicks) · [Instant.AddYears](Modern-Chrono-Instant-AddYears) · [Instant.AssumeUtc](Modern-Chrono-Instant-AssumeUtc) · [Instant.CompareTo](Modern-Chrono-Instant-CompareTo) · [Instant.DateTime](Modern-Chrono-Instant-DateTime) · [Instant.Day](Modern-Chrono-Instant-Day) · [Instant.DayOfWeek](Modern-Chrono-Instant-DayOfWeek) · [Instant.DayOfYear](Modern-Chrono-Instant-DayOfYear) · [Instant.DaysInMonth](Modern-Chrono-Instant-DaysInMonth) · [Instant.DaysInYear](Modern-Chrono-Instant-DaysInYear) · [Instant.EndOfDay](Modern-Chrono-Instant-EndOfDay) · [Instant.EndOfMonth](Modern-Chrono-Instant-EndOfMonth) · [Instant.EndOfYear](Modern-Chrono-Instant-EndOfYear) · [Instant.FileTime](Modern-Chrono-Instant-FileTime) · [Instant.FromDate](Modern-Chrono-Instant-FromDate) · [Instant.FromDateTime](Modern-Chrono-Instant-FromDateTime) · [Instant.FromFileTime](Modern-Chrono-Instant-FromFileTime) · [Instant.FromInstant](Modern-Chrono-Instant-FromInstant) · [Instant.FromJulianDay](Modern-Chrono-Instant-FromJulianDay) · [Instant.FromOleDate](Modern-Chrono-Instant-FromOleDate) · [Instant.FromSerial](Modern-Chrono-Instant-FromSerial) · [Instant.FromTicks](Modern-Chrono-Instant-FromTicks) · [Instant.FromUnixMicroseconds](Modern-Chrono-Instant-FromUnixMicroseconds) · [Instant.FromUnixMilliseconds](Modern-Chrono-Instant-FromUnixMilliseconds) · [Instant.FromUnixSeconds](Modern-Chrono-Instant-FromUnixSeconds) · [Instant.GetDate](Modern-Chrono-Instant-GetDate) · [Instant.GetTimeOfDay](Modern-Chrono-Instant-GetTimeOfDay) · [Instant.HasOffset](Modern-Chrono-Instant-HasOffset) · [Instant.Hour](Modern-Chrono-Instant-Hour) · [Instant.Instant](Modern-Chrono-Instant-Instant) · [Instant.Invalid](Modern-Chrono-Instant-Invalid) · [Instant.IsFirstDayOfMonth](Modern-Chrono-Instant-IsFirstDayOfMonth) · [Instant.IsLastDayOfMonth](Modern-Chrono-Instant-IsLastDayOfMonth) · [Instant.IsLeapYear](Modern-Chrono-Instant-IsLeapYear) · [Instant.IsoWeek](Modern-Chrono-Instant-IsoWeek) · [Instant.IsoWeekYear](Modern-Chrono-Instant-IsoWeekYear) · [Instant.IsUtc](Modern-Chrono-Instant-IsUtc) · [Instant.IsValid](Modern-Chrono-Instant-IsValid) · [Instant.JulianDay](Modern-Chrono-Instant-JulianDay) · [Instant.JulianDayNumber](Modern-Chrono-Instant-JulianDayNumber) · [Instant.MaxValue](Modern-Chrono-Instant-MaxValue) · [Instant.Microsecond](Modern-Chrono-Instant-Microsecond) · [Instant.Millisecond](Modern-Chrono-Instant-Millisecond) · [Instant.Minute](Modern-Chrono-Instant-Minute) · [Instant.MinValue](Modern-Chrono-Instant-MinValue) · [Instant.Month](Modern-Chrono-Instant-Month) · [Instant.MonthName](Modern-Chrono-Instant-MonthName) · [Instant.MonthUName](Modern-Chrono-Instant-MonthUName) · [Instant.NextWeekday](Modern-Chrono-Instant-NextWeekday) · [Instant.OffsetMinutes](Modern-Chrono-Instant-OffsetMinutes) · [Instant.OleDate](Modern-Chrono-Instant-OleDate) · [Instant.ParseExact](Modern-Chrono-Instant-ParseExact) · [Instant.ParseIso](Modern-Chrono-Instant-ParseIso) · [Instant.PrevWeekday](Modern-Chrono-Instant-PrevWeekday) · [Instant.Quarter](Modern-Chrono-Instant-Quarter) · [Instant.Second](Modern-Chrono-Instant-Second) · [Instant.Serial](Modern-Chrono-Instant-Serial) · [Instant.StartOfDay](Modern-Chrono-Instant-StartOfDay) · [Instant.StartOfMonth](Modern-Chrono-Instant-StartOfMonth) · [Instant.StartOfWeek](Modern-Chrono-Instant-StartOfWeek) · [Instant.StartOfYear](Modern-Chrono-Instant-StartOfYear) · [Instant.Subtract](Modern-Chrono-Instant-Subtract) · [Instant.TickOfDay](Modern-Chrono-Instant-TickOfDay) · [Instant.Ticks](Modern-Chrono-Instant-Ticks) · [Instant.ToInstant](Modern-Chrono-Instant-ToInstant) · [Instant.ToIsoString](Modern-Chrono-Instant-ToIsoString) · [Instant.ToLocal](Modern-Chrono-Instant-ToLocal) · [Instant.ToLocaleDateString](Modern-Chrono-Instant-ToLocaleDateString) · [Instant.ToLocaleDateUString](Modern-Chrono-Instant-ToLocaleDateUString) · [Instant.ToLocaleString](Modern-Chrono-Instant-ToLocaleString) · [Instant.ToLocaleTimeString](Modern-Chrono-Instant-ToLocaleTimeString) · [Instant.ToLocaleTimeUString](Modern-Chrono-Instant-ToLocaleTimeUString) · [Instant.ToLocaleUString](Modern-Chrono-Instant-ToLocaleUString) · [Instant.ToOffset](Modern-Chrono-Instant-ToOffset) · [Instant.ToString](Modern-Chrono-Instant-ToString) · [Instant.TryFormat](Modern-Chrono-Instant-TryFormat) · [Instant.TryParse](Modern-Chrono-Instant-TryParse) · [Instant.TryParseExact](Modern-Chrono-Instant-TryParseExact) · [Instant.TryParseIso](Modern-Chrono-Instant-TryParseIso) · [Instant.UnixMicroseconds](Modern-Chrono-Instant-UnixMicroseconds) · [Instant.UnixMilliseconds](Modern-Chrono-Instant-UnixMilliseconds) · [Instant.UnixSeconds](Modern-Chrono-Instant-UnixSeconds) · [Instant.WeekdayName](Modern-Chrono-Instant-WeekdayName) · [Instant.WeekdayUName](Modern-Chrono-Instant-WeekdayUName) · [Instant.WeeksInYear](Modern-Chrono-Instant-WeeksInYear) · [Instant.WithOffset](Modern-Chrono-Instant-WithOffset) · [Instant.Year](Modern-Chrono-Instant-Year) · [LocalDate.AddDays](Modern-Chrono-LocalDate-AddDays) · [LocalDate.AddMonths](Modern-Chrono-LocalDate-AddMonths) · [LocalDate.AddYears](Modern-Chrono-LocalDate-AddYears) · [LocalDate.CompareTo](Modern-Chrono-LocalDate-CompareTo) · [LocalDate.Day](Modern-Chrono-LocalDate-Day) · [LocalDate.DayNumber](Modern-Chrono-LocalDate-DayNumber) · [LocalDate.DayOfWeek](Modern-Chrono-LocalDate-DayOfWeek) · [LocalDate.DayOfYear](Modern-Chrono-LocalDate-DayOfYear) · [LocalDate.EndOfMonth](Modern-Chrono-LocalDate-EndOfMonth) · [LocalDate.FromDayNumber](Modern-Chrono-LocalDate-FromDayNumber) · [LocalDate.Invalid](Modern-Chrono-LocalDate-Invalid) · [LocalDate.IsFirstDayOfMonth](Modern-Chrono-LocalDate-IsFirstDayOfMonth) · [LocalDate.IsLastDayOfMonth](Modern-Chrono-LocalDate-IsLastDayOfMonth) · [LocalDate.IsoWeek](Modern-Chrono-LocalDate-IsoWeek) · [LocalDate.IsoWeekYear](Modern-Chrono-LocalDate-IsoWeekYear) · [LocalDate.IsValid](Modern-Chrono-LocalDate-IsValid) · [LocalDate.LocalDate](Modern-Chrono-LocalDate-LocalDate) · [LocalDate.MaxValue](Modern-Chrono-LocalDate-MaxValue) · [LocalDate.MinValue](Modern-Chrono-LocalDate-MinValue) · [LocalDate.Month](Modern-Chrono-LocalDate-Month) · [LocalDate.ParseIso](Modern-Chrono-LocalDate-ParseIso) · [LocalDate.Quarter](Modern-Chrono-LocalDate-Quarter) · [LocalDate.StartOfMonth](Modern-Chrono-LocalDate-StartOfMonth) · [LocalDate.ToIsoString](Modern-Chrono-LocalDate-ToIsoString) · [LocalDate.ToString](Modern-Chrono-LocalDate-ToString) · [LocalDate.TryParseIso](Modern-Chrono-LocalDate-TryParseIso) · [LocalDate.Year](Modern-Chrono-LocalDate-Year) · [LocalTime.CompareTo](Modern-Chrono-LocalTime-CompareTo) · [LocalTime.FromTicks](Modern-Chrono-LocalTime-FromTicks) · [LocalTime.Hour](Modern-Chrono-LocalTime-Hour) · [LocalTime.Invalid](Modern-Chrono-LocalTime-Invalid) · [LocalTime.IsValid](Modern-Chrono-LocalTime-IsValid) · [LocalTime.LocalTime](Modern-Chrono-LocalTime-LocalTime) · [LocalTime.MaxValue](Modern-Chrono-LocalTime-MaxValue) · [LocalTime.Microsecond](Modern-Chrono-LocalTime-Microsecond) · [LocalTime.Midnight](Modern-Chrono-LocalTime-Midnight) · [LocalTime.Millisecond](Modern-Chrono-LocalTime-Millisecond) · [LocalTime.Minute](Modern-Chrono-LocalTime-Minute) · [LocalTime.Noon](Modern-Chrono-LocalTime-Noon) · [LocalTime.ParseIso](Modern-Chrono-LocalTime-ParseIso) · [LocalTime.Second](Modern-Chrono-LocalTime-Second) · [LocalTime.Ticks](Modern-Chrono-LocalTime-Ticks) · [LocalTime.ToIsoString](Modern-Chrono-LocalTime-ToIsoString) · [LocalTime.ToString](Modern-Chrono-LocalTime-ToString) · [LocalTime.TryParseIso](Modern-Chrono-LocalTime-TryParseIso) · [Stopwatch.Elapsed](Modern-Chrono-Stopwatch-Elapsed) · [Stopwatch.ElapsedMilliseconds](Modern-Chrono-Stopwatch-ElapsedMilliseconds) · [Stopwatch.ElapsedTicks](Modern-Chrono-Stopwatch-ElapsedTicks) · [Stopwatch.Frequency](Modern-Chrono-Stopwatch-Frequency) · [Stopwatch.GetTimestamp](Modern-Chrono-Stopwatch-GetTimestamp) · [Stopwatch.IsHighResolution](Modern-Chrono-Stopwatch-IsHighResolution) · [Stopwatch.IsRunning](Modern-Chrono-Stopwatch-IsRunning) · [Stopwatch.Reset](Modern-Chrono-Stopwatch-Reset) · [Stopwatch.Restart](Modern-Chrono-Stopwatch-Restart) · [Stopwatch.Start](Modern-Chrono-Stopwatch-Start) · [Stopwatch.StartNew](Modern-Chrono-Stopwatch-StartNew) · [Stopwatch.Stop_](Modern-Chrono-Stopwatch-Stop) · [Stopwatch.Stopwatch](Modern-Chrono-Stopwatch-Stopwatch) · [TimeSpan.Add](Modern-Chrono-TimeSpan-Add) · [TimeSpan.CompareTo](Modern-Chrono-TimeSpan-CompareTo) · [TimeSpan.Days](Modern-Chrono-TimeSpan-Days) · [TimeSpan.Divide](Modern-Chrono-TimeSpan-Divide) · [TimeSpan.DivideBy](Modern-Chrono-TimeSpan-DivideBy) · [TimeSpan.Duration](Modern-Chrono-TimeSpan-Duration) · [TimeSpan.FromDays](Modern-Chrono-TimeSpan-FromDays) · [TimeSpan.FromHours](Modern-Chrono-TimeSpan-FromHours) · [TimeSpan.FromMicroseconds](Modern-Chrono-TimeSpan-FromMicroseconds) · [TimeSpan.FromMilliseconds](Modern-Chrono-TimeSpan-FromMilliseconds) · [TimeSpan.FromMinutes](Modern-Chrono-TimeSpan-FromMinutes) · [TimeSpan.FromSeconds](Modern-Chrono-TimeSpan-FromSeconds) · [TimeSpan.FromTicks](Modern-Chrono-TimeSpan-FromTicks) · [TimeSpan.Hours](Modern-Chrono-TimeSpan-Hours) · [TimeSpan.Invalid](Modern-Chrono-TimeSpan-Invalid) · [TimeSpan.IsNegative](Modern-Chrono-TimeSpan-IsNegative) · [TimeSpan.IsValid](Modern-Chrono-TimeSpan-IsValid) · [TimeSpan.IsZero](Modern-Chrono-TimeSpan-IsZero) · [TimeSpan.MaxValue](Modern-Chrono-TimeSpan-MaxValue) · [TimeSpan.Microseconds](Modern-Chrono-TimeSpan-Microseconds) · [TimeSpan.Milliseconds](Modern-Chrono-TimeSpan-Milliseconds) · [TimeSpan.Minutes](Modern-Chrono-TimeSpan-Minutes) · [TimeSpan.MinValue](Modern-Chrono-TimeSpan-MinValue) · [TimeSpan.Multiply](Modern-Chrono-TimeSpan-Multiply) · [TimeSpan.Negate](Modern-Chrono-TimeSpan-Negate) · [TimeSpan.ParseIso](Modern-Chrono-TimeSpan-ParseIso) · [TimeSpan.Seconds](Modern-Chrono-TimeSpan-Seconds) · [TimeSpan.Subtract](Modern-Chrono-TimeSpan-Subtract) · [TimeSpan.Ticks](Modern-Chrono-TimeSpan-Ticks) · [TimeSpan.TimeSpan](Modern-Chrono-TimeSpan-TimeSpan) · [TimeSpan.ToIsoString](Modern-Chrono-TimeSpan-ToIsoString) · [TimeSpan.ToIsoUString](Modern-Chrono-TimeSpan-ToIsoUString) · [TimeSpan.ToString](Modern-Chrono-TimeSpan-ToString) · [TimeSpan.TotalDays](Modern-Chrono-TimeSpan-TotalDays) · [TimeSpan.TotalHours](Modern-Chrono-TimeSpan-TotalHours) · [TimeSpan.TotalMicroseconds](Modern-Chrono-TimeSpan-TotalMicroseconds) · [TimeSpan.TotalMilliseconds](Modern-Chrono-TimeSpan-TotalMilliseconds) · [TimeSpan.TotalMinutes](Modern-Chrono-TimeSpan-TotalMinutes) · [TimeSpan.TotalSeconds](Modern-Chrono-TimeSpan-TotalSeconds) · [TimeSpan.TryParseIso](Modern-Chrono-TimeSpan-TryParseIso) · [TimeSpan.Zero](Modern-Chrono-TimeSpan-Zero)

---

**Source:** `docs/datetime/datetime.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)
