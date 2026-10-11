[Home](Home) › [All Categories](Categories) › **String Library**

# String Library

```freebasic
#import "std/containers"
#import "std/strings"
using strings, containers

print Replace( "Hello World", "World", "Earth" )   ' Hello Earth
print Tally( "a,b,c", "," )                        ' 2
print PadLeft( "42", 6, "0" )                      ' 000042
print Between( "log(42) end", "(", ")" )           ' 42

dim parts as Array( of string ) = Split( "a,b,c" )
print parts.Count( )                               ' 3
print Join( parts, " | " )                         ' a | b | c

dim rows as Array( of CsvRow ) = SplitCsv( text )  ' RFC 4180, quotes and all
print rows[ 0 ].fields[ 1 ]
```

## Why It Exists

FreeBASIC ships LEFT, RIGHT, MID, INSTR, INSTRREV, TRIM, UCASE, LCASE, SPACE and STRING, and stops. There is no Replace, no Split, no Join, no pad, and no way to work with a set of characters. Every program that needs them writes them again, usually with a 'redim preserve' loop that is quadratic.

These 39 functions are the portable half of the AfxNova string library (AfxStr.inc and DWStrProcs.inc) -- two decades of use, but Windows-only, tied to WSTRING and DWSTRING, and in places built on COM -- plus the CSV pair, which comes from elsewhere and is described in its own section below.

NOTHING HERE IS A KEYWORD. Replace, Contains, Split and the rest belong to the module: nothing is added to a program until it imports std/strings, and the bare names only after 'using strings', so they stay available as your own identifiers. The language is unchanged.

## All Four String Types

Every function is declared three times -- STRING, WSTRING, USTRING -- and ZSTRING is served by the STRING overload through fbc's own conversion, which for bytes to bytes is exact and involves no locale. You never name which family you are in; the first argument decides.

There is no dynamic ZSTRING or WSTRING, so a function cannot return the type it was handed:

```freebasic
string, zstring   ->  string        bytes, no encoding assumed
wstring, ustring  ->  ustring       UTF-16 on every target
```

A WSTRING in giving a USTRING out is the surprising one. It is also the only answer available: a fixed-length result would need a buffer the caller has not supplied. On Windows it costs nothing to use, because a ustring already is UTF-16.

EVERY PARAMETER AFTER THE FIRST IS A USTRING, in all three overloads. That is forced, not preferred. fbc ranks an overload on all of its parameters, so with per-family types on the second one,

```freebasic
Tally( someWstring, "abc" )        ' error 98: Ambiguous call
```

is an ambiguity rather than a choice. One shared type on the later parameters moves the whole decision onto the first.

The cost is that a pattern handed to the BYTE family is converted UTF-8 -> UTF-16 -> UTF-8 on the way in. For an ASCII or UTF-8 pattern that is exact, and for a literal it costs nothing at run time -- fbc converts string literals to ustring at compile time. It does not survive a pattern of arbitrary non-UTF-8 bytes; searching binary for a raw byte sequence is outside what this library does, and USTRING draws the same line. The haystack is never converted, so byte positions in a STRING stay byte positions.

## Code Units, Positions, AND Case

Positions and lengths count CODE UNITS, matching LEN, \[\] and INSTR. On the wide family an astral character is a surrogate pair and counts as 2. A search can never land mid-character -- a surrogate half cannot equal a BMP unit -- though MID can still split one, as it always could.

POSITIONS ARE 1-BASED, and 0 means "not found", matching INSTR. This is NOT the zero-based convention containers.Array uses. Strings and containers are different worlds and each keeps its own tradition.

A start below 1 is invalid and answers 0 (or "" for a function returning text) rather than clamping, so a position fed back in from a call that returned "not found" cannot silently restart the scan. AfxNova reads a negative start as counting from the right; that reading and this one claim the same range, so only one could survive, and consistency won.

'ignoreCase' folds ASCII only on the byte family, because a STRING is a byte buffer with no declared encoding and folding above 127 would be guessing at a codepage. The wide family folds through the generated simple BMP table, so it gives the same answer on every machine and in every locale.

ON THE BYTE FAMILY A CHARACTER SET IS A SET OF BYTES. InstrChars, TallyChars, VerifySet, SpanOf, RemoveChars, RetainChars, ReplaceChars and SplitChars compare one unit at a time, and on a STRING a unit is a byte. Put a multi-byte character in the set and each of its bytes joins separately:

```freebasic
dim as string s = "xx" & chr(&hC3) & chr(&hA9) & "yy"    ' UTF-8
InstrChars( 1, s, wchr(&hE8) )      ' 3 -- matched the C3 byte
```

A STRING carries no encoding, so the set cannot be decoded into characters. Use the ustring overload for character sets over non-ASCII text; there a set member is one code unit and the answer is 4. The substring functions are unaffected on both families: they match whole sequences and are exact for any UTF-8 pattern.

## The Functions

n is the input length, m the pattern length.

SEARCH AND INSPECT                                          returns

```freebasic
Tally( s, match [, ic] )                     O(n*m)   int32
    Non-overlapping occurrences. "aaaa" contains "aa" TWICE.
TallyChars( s, chars [, ic] )                O(n*k)   int32
InstrChars( start, s, chars [, ic] )         O(n*k)   int32
VerifySet( start, s, chars [, ic] )          O(n*k)   int32
    First position NOT in the set, or 0 if every one is.
SpanOf( start, s, chars [, ic] )             O(n*k)   int32
StartsWith( s, prefix [, ic] )               O(m)     boolean
EndsWith( s, suffix [, ic] )                 O(m)     boolean
Contains( s, match [, ic] )                  O(n*m)   boolean
```

EXTRACT

```freebasic
Extract( start, s, match [, ic] )            O(n*m)   text before match
ExtractChars( start, s, chars [, ic] )       O(n*k)
Remain( s, match [, start] [, ic] )          O(n*m)   text after match
RemainChars( s, chars [, start] [, ic] )     O(n*k)
Between( s, open, close [, start] [, ic] )   O(n*m)
ClipLeft( s, count )                         O(n)
ClipRight( s, count )                        O(n)
DeleteAt( s, start, count )                  O(n)
InsertAt( s, insert, position )              O(n)
```

TRANSFORM

```freebasic
Replace( s, match, with_ [, ic] )            O(n*m)
Remove( s, match [, ic] )                    O(n*m)
RemoveChars( s, chars [, ic] )               O(n*k)
RetainChars( s, chars [, ic] )               O(n*k)
ReplaceChars( s, chars, with_ [, ic] )       O(n*k)   length is invariant
RemoveBetween( s, open, close
               [, all] [, start] [, ic] )    O(n*m)
Reverse( s )                                 O(n)
Repeat( count, s )                           O(n*count)
Shrink( s [, mask] )                         O(n*k)
MCase( s )                                   O(n)     title case
```

PAD, WRAP, ESCAPE, PREDICATES

```freebasic
PadLeft( s, width [, pad] )                  O(width)
PadRight( s, width [, pad] )                 O(width)
PadCenter( s, width [, pad] )                O(width)
Wrap( s [, open] [, close] )                 O(n)
Unwrap( s [, open] [, close] [, ic] )        O(n)
Escape( s )                                  O(n)
Unescape( s )                                O(n)
IsNumeric( s )                               O(n)     boolean
IsBlank( s )                                 O(n)     boolean
```

SPLIT AND JOIN

```freebasic
Split( s [, delim] [, ic] )                  O(n*m)   Array( of T )
SplitChars( s [, chars] [, ic] )             O(n*k)   Array( of T )
Join( parts [, delim] )                      O(total) text
```

CSV

```freebasic
SplitCsv( s [, delim] )                      O(n)     Array( of CsvRow )
    A whole RFC-4180 document: records and fields in one pass.
    Zero rows means an unclosed quote.
SplitCsvRow( s [, delim] )                   O(n)     Array( of T )
    One record. The quote-aware Split. Empty means malformed.
```

## The Rules That Are Easy To Get Wrong

Each of these has a defensible opposite, so each is a decision rather than an accident, and each is asserted in the test suite.

EMPTY ARGUMENTS

```freebasic
Tally( s, "" )              0     a zero-width match advances nothing
InstrChars( n, s, "" )      0     "find one of nothing" cannot succeed
VerifySet( n, s, "" )       n     "find one NOT among nothing" cannot fail
SpanOf( n, s, "" )          0     nothing is in the set, so the run is empty
StartsWith( s, "" )         true  vacuous, including for s = ""
Contains( s, "" )           true  same
RemoveChars( s, "" )        s     an empty set removes nothing
RetainChars( s, "" )        ""    and so keeps nothing -- the complement
Shrink( s, "" )             s     there is nothing to shrink
Split( s, "" )              one field, the whole string
SplitCsv( s, "" )           one field per record, records still split
SplitCsv( "" )              one record of one empty field
```

EXTRACT AND REMAIN MISS DIFFERENTLY, on purpose:

```freebasic
Extract( 1, s, missing )    the whole remainder
Remain( s, missing )        ""
```

Extract's rule is what makes a parse loop terminate cleanly -- the final field has no trailing delimiter, and this hands it back instead of dropping it. Remain's is the only honest answer to "everything after X" when there was no X.

SPLIT NEVER DROPS A FIELD. N delimiters give N+1 fields, always:

```freebasic
Split( "a,,c" ) -> 3      Split( ",a" ) -> 2      Split( "" ) -> 1
```

That is what makes Join( Split( s, d ), d ) equal s for every s.

SPLITCSV'S TRAILING RULE IS THE OPPOSITE, and the two sit next to each other, so it is worth saying twice: Split( "a," ) is two fields, and SplitCsv( "a,b\n" ) is one record. A trailing delimiter is a field the writer meant; a trailing newline is how text files end.

INVALID ARGUMENTS ARE NO-OPS, not errors and not truncation. DeleteAt with a start past the end, or a count of zero, returns the string unchanged; InsertAt with a position below 1 does the same. A pad width of 0 or less gives "".

ONE UNIT MEANS ONE UNIT. ReplaceChars maps a single unit to a single unit, so 'with\_' must be exactly one; anything else -- empty, longer, or an astral character, which is two units -- returns the string unchanged rather than writing half a character. The pad functions take the same rule with a softer failure: a pad that is not one unit pads with a SPACE, because a pad function that pads with nothing is useless while a substitution that substitutes nothing is merely inert.

## CSV

Split is the wrong tool for a comma-separated FILE, and not by a little. There is no delimiter that survives being both a separator and content, so split-on-comma-then-repair cannot be patched into correctness; a quoted field containing a comma is not an edge case, it is the first line of most real exports.

[SplitCsv](Modern-String-SplitCsv) handles, in a single pass with a cursor:

```freebasic
"a,b"          a delimiter inside quotes, taken literally
""             two quotes inside quotes, as one literal quote
CRLF, LF, CR   mixed freely, each ending exactly one record
"l1\nl2"       a NEWLINE INSIDE A QUOTED FIELD -- content, not a record break
a,b,           a trailing empty field
a,b            a last record with no trailing newline
```

RECORDS ARE FOUND BY THE SAME PASS AS FIELDS, which is what buys the embedded newline. A row is not a line. Splitting into lines first passes every other case and fails that one, and broker and CRM exports do contain memo columns with newlines in them.

The result is a table:

```freebasic
dim rows as Array( of CsvRow ) = SplitCsv( text )
for r as integer = 0 to rows.Count( ) - 1
    for c as integer = 0 to rows[ r ].fields.Count( ) - 1
        print rows[ r ].fields[ c ]
    next
next
```

CsvRow holds STRING fields and CsvURow holds USTRING ones, following the same return rule as everything else here -- a STRING in gives CsvRow, a WSTRING or USTRING gives CsvURow. A row is a TYPE wrapping an array rather than a bare nested generic, because a generic will not instantiate directly in a TYPE field: Array( of Array( of string ) ) is not available.

NO FILE I/O. This takes text and returns rows; the reading belongs to the caller. That is what lets every awkward case be an assertion in the test suite instead of something discovered on a Tuesday with a real statement.

AN UNCLOSED QUOTE ANSWERS ZERO ROWS. A well-formed parse always yields at least one record -- an empty input is one record of one empty field, the same rule that makes Split( "" ) one field -- so a count of 0 is unambiguous and means exactly one thing:

```freebasic
dim rows as Array( of CsvRow ) = SplitCsv( text )
if rows.Count( ) = 0 then          ' malformed; do not use the rows
```

Consuming the rest of the document as one field is the alternative, and it produces a plausible-looking single row rather than a complaint. Silence is the one answer that cannot be checked. There is no Result type here and no error code: the count already carries it, and a total function needs neither.

A TRAILING NEWLINE DOES NOT MAKE AN EXTRA RECORD -- "a,b\n" is one row, not two. That is the opposite of Split's never-drop-a-field rule, and deliberately so: a file ending in a newline is the normal case, not a file with a blank record at the end. A blank line in the MIDDLE is still a real, empty record.

A DELIMITER THAT IS NOT EXACTLY ONE CODE UNIT means no delimiter at all: every record comes back as one field, with records and quoting still honoured. Same rule as Split's empty delimiter, and there is no useful reading of a two-character CSV separator.

ON THE BYTE FAMILY THIS IS EXACT FOR UTF-8, unlike the character-set functions. Quote, comma, CR and LF are all below 0x80, and no UTF-8 continuation byte is, so a multi-byte character can never be mistaken for a delimiter or a record break. The fields come back as the same bytes that went in.

[SplitCsvRow](Modern-String-SplitCsvRow) is the same parser over a single record, returning the Array( of T ) that Split returns -- a drop-in wherever the fields may be quoted. An empty result means malformed, on the same rule. Text holding more than one record answers the first; the rest is a table, and SplitCsv is what returns tables.

COMPLEXITY IS O(n). The scan appends whole runs of ordinary characters with MID rather than one unit at a time. Per-character '&=' is what the obvious version does, and it is quadratic in the field length, because FreeBASIC strings do not over-allocate.

Ported from the finara import engine (fnr\_CsvParse), itself ported from tracks. The cursor is the same; three things changed on the way in:

- the failure is a ROW COUNT rather than a Result( of Table, Error ), so the string library keeps its single dependency on std/containers' Array and stays total;
- an EMPTY INPUT is one empty record rather than none, which is what makes the zero-row signal unambiguous;
- a delimiter that is not one unit is a no-op rather than an error, matching how every other invalid argument here behaves.

The column profiles and transaction mapping that surround the parser in finara did not come with it. They are that application's schema, not a string algorithm.

## Reverse Is The One Function Whose Families Disagree

On the wide family SURROGATE PAIRS ARE KEPT INTACT. A ustring is UTF-16 by definition, so reversing its code units blindly would emit a low surrogate before its high one -- invalid UTF-16 every time an astral character is present, not occasionally.

On the byte family bytes reverse as bytes, which does mangle multi-byte UTF-8. A STRING has no declared encoding, so there is no pair to recognise and no way to know whether there would be one. Reverse UTF-8 text through the ustring overload.

## Escape

Backslash escaping -- what makes a string safe to write between quotes in a config file, a log line, or generated source, and reversible afterwards.

```freebasic
\  "             ->  \\  \"
LF CR TAB NUL    ->  \n  \r  \t  \0
other units below 32, and 127   ->  \xHH
everything else, INCLUDING ALL NON-ASCII, passes through
```

Non-ASCII is left alone deliberately: escaping it would make a ustring unreadable and reduce a UTF-8 STRING to a wall of hex, and the job is to neutralise what breaks quoting, not to force the text to ASCII.

Unescape is the exact inverse. Unescape( Escape( s ) ) is s for every input, including one that already contains backslashes -- verified over every byte value 0..255. An unrecognised escape yields the escaped character ("\\q" -> "q"); a trailing lone backslash is kept, since nothing follows it to unquote.

## WHERE THIS DIFFERS FROM AfxNova

Eleven deliberate divergences. Everything else answers what AfxNova answers.

1. Remove is a SINGLE PASS -- exactly Replace with an empty replacement.

```freebasic
AfxStrRemove restarts its search at position 1 after each deletion, so
removals cascade: deleting "ab" from "aabb" leaves "" there, because the
deletion creates a match that was not in the input. Here it leaves "ab".
Also O(n) rather than O(n^2).
```

2. Reverse keeps surrogate pairs intact on the wide family. AfxStrReverse

```freebasic
swaps code units and produces invalid UTF-16 for any astral character.
```

3. Unwrap requires BOTH ends and removes ONE of each. AfxStrUnWrap uses

```freebasic
LTRIM/RTRIM with the delimiter, so it strips repeated occurrences and does
not need a pair -- "'''x'''" loses all six quotes and "'x" loses its opener
with nothing matching it. Stripping a delimiter that was never balanced is
how a quoted field containing a quote gets silently mangled.
```

4. Shrink with an EMPTY mask returns the input unchanged. AfxStrShrink returns

```freebasic
the empty string, which reads like a guard clause that fell through to the
wrong variable.
```

5. MCase starts a word after any NON-ALPHANUMERIC character. DWStrMCase tests

```freebasic
against a fixed punctuation list, so it capitalises after "." and "-" but
not after "/", "_" or a tab -- gaps rather than decisions.
```

6. IsNumeric asks whether the string IS a number, with a real grammar.

```freebasic
AfxIsNumeric asks whether every character is drawn from "+-.0123456789",
which makes "++--.." numeric; that is a character-set test, and RetainChars
already does those. Radix literals (&H, &O, &B) are not accepted here.
```

7. Escape is BACKSLASH escaping. AfxNova's DWStrEscape escapes REGULAR

```freebasic
EXPRESSION metacharacters so a literal can be used as a pattern -- it is
built on CRegExp, a COM class, and is only meaningful beside a regex engine.
There is none here, so it would have had no consumer.
```

8. InsertAt with a position below 1 returns the string unchanged.

```freebasic
AfxStrInsert's comment says such a position appends; its code returns the
string untouched. The code is followed, because appending on a negative
index is the kind of silent success that hides a caller's off-by-one.
```

9. A negative start is NOT counted from the right. Positions below 1 are

```freebasic
invalid throughout, and the two readings claim the same range.
```

10. DeleteAt is one function. AfxStrClipMid and AfxStrDelete are the same

```freebasic
algorithm under two names.
```

11. Wrap and Unwrap take an EMPTY 'close' to mean "same as open", which

```freebasic
collapses AfxNova's three overloads into one function.
```

TWO MORE ARE AfxNova BUGS, found by the differential harness in tests/afxnova_differential.bas. Both are cases where the code contradicts its own comment, so "divergence" here means this library does what AfxNova documents and AfxNova does not.

12. TallyChars does not double-count a repeated character in the set.

```freebasic
AfxStrTallyAny's dedup loop seeds its working copy with the whole match
string and then tests INSTR( copy, <char> ) against ITSELF, so every
character is always found and nothing is ever removed -- the loop is a
no-op. Its comment promises "repeated characters in wszMatchStr will not
increase the count"; TallyChars( "abacadabra", "aa" ) is 5 here and 10
there.
```

13. ExtractChars returns the whole remainder on a miss, like Extract.

```freebasic
AfxStrExtractAny ends in an unconditional empty return, contradicting both
its own comment ("If wszMatchStr is not present ... then all of wszMainStr
is returned") and its sibling AfxStrExtract, which does return the
remainder.
```

SplitCsv and SplitCsvRow have no AfxNova counterpart at all -- there is none to diverge from. See the CSV section above for where they do come from.

Excluded entirely, as Windows-only or COM-bound: locale and country names, month and day names, LCMapStringEx casing, CryptBinaryToString, BSTR, environment access, PathName/PathScan, and the byte-size and time-interval formatters.

## Implementation

In tiko-rt the algorithms live in lib/rt/src/inc/ops-core.bi and are written ONCE, then instantiated twice -- lib/rt/src/str/ops.bas at byte width, lib/rt/src/ustr/ops.bas at 16-bit -- with ## token pasting, the technique fbc's C runtime uses with str_ops_core.h. Two hand-maintained copies of a search loop drift, and the drift shows up as one width quietly disagreeing with the other on an edge case nobody tests twice.

Reached from FreeBASIC through 'extern "C" declare ... alias' at the module's scope -- the pattern inc/string.bi already uses for FORMAT. Note that 'alias' alone is not enough inside a module: without the extern "C" the name is mangled through the module's chain, and a nested namespace does not inherit an enclosing extern either.

Split, SplitChars, Join, SplitCsv and SplitCsvRow are the only ones with FreeBASIC bodies, because their result is an Array( of T ) that the runtime cannot build. They are public members of the module, compiled once with it, so any number of files in a program can import std/strings and still link. The runtime side returns field boundaries rather than strings, so a split is two linear passes instead of the ParseCount-then-Parse-in-a-loop shape, which rescans from the start for every field and is quadratic.

## ONE FreeBASIC QUIRK WORTH KNOWING

LEN and SIZEOF do not honour a namespace qualifier on a function call that comes first in
their operand:

```freebasic
print len( strings.Replace( s, "a", "b" ) )    ' error TKO0743: 'replace' is not declared
```

This is not specific to this library or to USTRING -- stock fbc 1.10.1 fails identically on

```freebasic
namespace NS
    function Twice( byref s as const string ) as string : ... : end function
end namespace
print len( NS.Twice( t ) )
```

The operand may be a TYPE, and 'strings.' may begin one, so the compiler reads the qualifier as a type's, finds no type, and parses what follows it UNQUALIFIED. With no 'Replace' in view that is error 42 under fbc and TKO0743 under tiko. With one in view it is worse: that one is called, and measured. Given a global 'function Twice' beside NS's, 'len( NS.Twice( t ) )' calls the global one. The qualifier holds when the call is not the first thing in the operand: '( NS.Twice( t ) )', '"x" & NS.Twice( t )' and 'cast( ... )' all reach NS's. It also holds for a qualified VARIABLE, so 'len( NS.v )' is NS's.

tiko does the same (measured 2026-09-24 against fbc 1.20.0, FBC-Modern), and tests/mir/len-ns-prefix.test and tests/diagnostics/len-ns-prefix.test hold it there. The workarounds are ordinary: write 'using strings' and drop the qualifier, or assign the result first and take LEN of the variable, or put the call in parentheses. It is mentioned here only because the qualified spelling is the natural one to reach for before discovering 'using', and the error message points nowhere near the cause.

## Money Formatting

`MoneyFormat`, from `std/money`, renders an amount the way the user's locale writes money. Assign a numeric value, set the properties you care about, read back the string.

```freebasic
#import "std/money"
using money

dim as MoneyFormat m = DecimalParse( "-1234.5" ).Value( )
print m.ToString( )                  '' -$1,234.50   on en-CA

m.Negative = MONEY_NEG_PARENS
m.ThousandsSep = ""                  '' SUPPRESSED, not "use the locale"
print m.ToString( )                  '' ($1234.50)

m.UseLocale( MONEY_F_THOUSANDSSEP )  '' back to the locale's separator
```

`Currency` and `Decimal` HOLD money and the finance functions COMPUTE with it. Nothing displayed it. [MoneyFormat](Modern-String-MoneyFormat) is that half. It is documented in this library because what it does is build a string, and it ships in `std/money` beside Currency.

Everything the locale specifies -- symbol, decimal point, thousands separator, digit grouping, fraction digits, which side the symbol goes on, where the sign goes -- is used by default, and every one of them can be overridden or suppressed individually. Setting a property always marks it as yours, so `m.Symbol = ""` SUPPRESSES the symbol and only `UseLocale` gives it back; without that distinction suppression could not be expressed at all.

Windows reads `GetLocaleInfoEx( LOCALE_NAME_USER_DEFAULT, ... )` and Linux reads `localeconv( )`. Not one portable path, and both reasons are silent failures rather than errors: the Windows CRT is not the Region control panel and does not reliably see per-user overrides, and `localeconv` hands back bytes in the process code page, where the euro sign is one byte on a 1252 machine. `std/money` pulls in nothing from `inc/win` -- `GetLocaleInfoEx` sits behind `_WIN32_WINNT >= &h0600` and `inc/win/_mingw.bi` defaults that to `&h0502`, so with the shipped headers it is not visible at all.

On Linux it asks for `LC_MONETARY` alone. Widening it to `LC_ALL` would move `LC_NUMERIC` too, and `DecimalFromDouble` parses `snprintf( "%.14e" )` output -- under a German `LC_NUMERIC` every double assigned to a MoneyFormat would silently become an invalid Decimal. Formatting money must not change how the rest of the program reads numbers.

The thirty layout combinations behind [MoneyCompose](Modern-String-MoneyCompose) were generated from glibc, not transcribed: thirty synthetic locales built with `localedef` and formatted with `strfmon(3)`, asserted one cell at a time.

## Dialects

-lang fb only. The library uses namespaces, and Split returns a generic container. std/strings says so with #error rather than failing obscurely.

## API reference

One page per entry, 46 in all:

[Between](Modern-String-Between) · [ClipLeft](Modern-String-ClipLeft) · [ClipRight](Modern-String-ClipRight) · [Contains](Modern-String-Contains) · [DeleteAt](Modern-String-DeleteAt) · [EndsWith](Modern-String-EndsWith) · [Escape](Modern-String-Escape) · [Extract](Modern-String-Extract) · [ExtractChars](Modern-String-ExtractChars) · [InsertAt](Modern-String-InsertAt) · [InstrChars](Modern-String-InstrChars) · [IsBlank](Modern-String-IsBlank) · [IsNumeric](Modern-String-IsNumeric) · [Join](Modern-String-Join) · [MCase](Modern-String-MCase) · [PadCenter](Modern-String-PadCenter) · [PadLeft](Modern-String-PadLeft) · [PadRight](Modern-String-PadRight) · [Remain](Modern-String-Remain) · [RemainChars](Modern-String-RemainChars) · [Remove](Modern-String-Remove) · [RemoveBetween](Modern-String-RemoveBetween) · [RemoveChars](Modern-String-RemoveChars) · [Repeat](Modern-String-Repeat) · [Replace](Modern-String-Replace) · [ReplaceChars](Modern-String-ReplaceChars) · [RetainChars](Modern-String-RetainChars) · [Reverse](Modern-String-Reverse) · [Shrink](Modern-String-Shrink) · [SpanOf](Modern-String-SpanOf) · [Split](Modern-String-Split) · [SplitChars](Modern-String-SplitChars) · [SplitCsv](Modern-String-SplitCsv) · [SplitCsvRow](Modern-String-SplitCsvRow) · [StartsWith](Modern-String-StartsWith) · [Tally](Modern-String-Tally) · [TallyChars](Modern-String-TallyChars) · [Unescape](Modern-String-Unescape) · [Unwrap](Modern-String-Unwrap) · [VerifySet](Modern-String-VerifySet) · [Wrap](Modern-String-Wrap) · [MoneyCompose](Modern-String-MoneyCompose) · [MoneyFormat](Modern-String-MoneyFormat) · [MoneyLayoutFromICurrency](Modern-String-MoneyLayoutFromICurrency) · [MoneyLayoutFromINegCurr](Modern-String-MoneyLayoutFromINegCurr) · [MoneyLocaleIsValid](Modern-String-MoneyLocaleIsValid) · [MoneyLocaleName](Modern-String-MoneyLocaleName) · [MoneyRefreshLocale](Modern-String-MoneyRefreshLocale) · [MoneySetLocale](Modern-String-MoneySetLocale)

---

**Source:** `docs/string/string.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)
