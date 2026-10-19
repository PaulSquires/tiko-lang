# Writing CSV

`strings.SplitCsv` reads comma-separated text (see
[Split and Join](split.md)). Writing it has the opposite problem: a field
holding a comma or a quote has to be quoted, or the reader splits it in two.

```tiko
{{#include ../../examples/strings/csv.tiko}}
```

**Output**

```text
{{#include ../../examples/strings/csv.out}}
```

`JoinCsvRow( fields [, separator] )` writes one record. A field is quoted only
when it holds the separator, a double quote or a line break, or starts or ends
with a space; a quote inside a field is doubled. With `";"` as the separator,
`a,b` no longer needs quotes.

`CsvWriter` writes records to any `fs.Stream` — a `File`, a pipe, or a
`MemoryStream` as here. Records end with CR LF, the standard CSV line ending,
unless the third argument is `false`. If a write fails, the writer stops
writing and `Finish( )` returns the failure.

Whatever `JoinCsvRow` writes, `SplitCsv` reads back as the same fields.

### Activities

1. Add a field containing a line break and check that it survives the round
   trip.
2. Write the rows to a file with `fs.File` and `Create`, then open it in a
   spreadsheet.
