# Split and Join

A line of comma-separated values, a path, a list of words: text that is
really a list of fields. `strings.Split` turns it into a list you can walk,
and `strings.Join` turns a list back into text.

```tiko
{{#include ../../examples/strings/split.tiko}}
```

**Output**

```text
{{#include ../../examples/strings/split.out}}
```

`Split` returns an `Array( of ustring )`, the standard library's growable
array from [Containers](../containers/index.md). Here it is asked only for
`.Count( )`, for an element with `[ i ]`, and to be walked with `for each`.
Its indexes count from 0, unlike positions inside a string, which count
from 1.

`Split` never drops a field. Two delimiters in a row make an empty field
between them, and a delimiter at either end makes an empty field there, so
`",a,,b,"` is five fields and *n* delimiters always give *n* + 1 fields. That
rule is what makes the round trip work: `Join( Split( s, d ), d )` is `s`
again, for every `s`.

When the delimiter is a choice of characters rather than one string,
`SplitChars` takes them all at once: `" ;,"` splits at a space, a semicolon
or a comma.

```admonish note
A comma-separated *file* is not a `Split` problem: a quoted field such as
`"London, UK"` contains the delimiter. `strings.SplitCsvRow` and
`strings.SplitCsv` read quoting correctly.
```

### Activities

1. Split `"1969-07-20"` on `"-"` and print the three parts as numbers with
   `val`.
2. Split a sentence into words with `SplitChars`, then `Join` them back in
   reverse order.
