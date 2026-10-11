[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **SplitCsvRow**

# SplitCsvRow

O(n)   Array( of T )

## Syntax

```freebasic
SplitCsvRow( s [, delim] )
```

## Notes

- O(n) — one record through the same cursor [SplitCsv](Modern-String-SplitCsv) uses. The quote-aware [Split](Modern-String-Split).
- Returns the same `Array( of T )` Split does — `Array( of string )` for a STRING, `Array( of ustring )` for a WSTRING or USTRING — so it is a drop-in wherever the fields may be quoted.
- **An empty result means malformed**, on SplitCsv's rule: a well-formed parse always yields at least one field, and an empty record is one empty field.
- Text holding more than one record answers the **first** record only. The rest is a table, and [SplitCsv](Modern-String-SplitCsv) is what returns tables.
- Where there is nothing to quote it agrees with [Split](Modern-String-Split) exactly, empty fields included.
- A delimiter that is not exactly one code unit means no delimiter: the whole record comes back as one field.

## Examples

```freebasic
#import "std/containers"
#import "std/strings"
using strings, containers

dim as Array( of string ) f = SplitCsvRow( !"a,\"b,c\",d" )

print f.Count( )        '' 3 -- the quoted comma did not split anything
print f[ 1 ]            '' b,c

'' With nothing quoted it is Split, empty fields and all
dim as Array( of string ) g = SplitCsvRow( "a,,c" )
print g.Count( )        '' 3
print "[" & g[ 1 ] & "]"    '' []

'' Empty means malformed -- never a field count of zero on good input
dim as Array( of string ) bad = SplitCsvRow( !"a,\"oops" )
if bad.Count( ) = 0 then print "malformed record"

'' Any single-character delimiter
dim as Array( of string ) tsv = SplitCsvRow( "x" & chr( 9 ) & "y", chr( 9 ) )
print tsv.Count( )      '' 2
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** The Functions  
**Source:** `docs/string/string.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
