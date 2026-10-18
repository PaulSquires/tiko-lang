# Text to Numbers

Text from a user, a file or the command line has to become a number before
you can calculate with it. tiko has two kinds of function for that: the
forgiving `val` family, and strict parsers in `std/numeric` that tell you
when the text is not a number.

```tiko
{{#include ../../examples/conversion/fromtext.tiko}}
```

**Output**

```text
{{#include ../../examples/conversion/fromtext.out}}
```

`val` reads as much of a number as it can from the front of the text and
ignores the rest, so `"  12 cm"` gives 12. It understands exponents and the
`&h` prefix. When the text does not start with a number, the answer is 0.
`valint` and `vallng` work the same way but produce whole numbers, as
`int32` and `int64`; `valuint` and `valulng` are the unsigned forms.

That forgiveness is a problem when you need to know whether the input was
valid, because `val( "0" )` and `val( "none" )` give the same answer.
`numeric.TryParseLong` accepts only text that is entirely a number: it
returns an *optional* value, and `HasValue( )` says whether there is one.
`Value( )` reads it, and `ValueOr( d )` reads it or gives `d` when there is
none. `TryParseLongInt`, `TryParseDouble` and `TryParseSingle` cover the
other types.

[Error Handling](../errors/index.md) covers optional values in general.

### Activities

1. Pass `" 7"`, with a leading space, to `TryParseLong` and to `valint`.
2. Read `"9999999999"` with `TryParseLong` and then with `TryParseLongInt`.
