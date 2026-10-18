# Numbers to Text

`print` shows a number without being asked, but to keep the text, join it
with other text or lay it out in columns, you need the text as a `ustring`.
There are three ways to get it, from the quickest to the most controlled.

```tiko
{{#include ../../examples/conversion/totext.tiko}}
```

**Output**

```text
{{#include ../../examples/conversion/totext.out}}
```

`str( x )` gives the text of a number or a boolean. Unlike `print`, it adds
no space in front of a positive number. The `&` operator calls the same
conversion on each side, so `"count=" & count` needs no `str` at all.

`hex`, `oct` and `bin` write an integer in base 16, 8 or 2, and an optional
second argument pads the result with zeros to that many digits.

`strings.Format` from `std/strings` does the rest: width and alignment
(`{:>6}`), zero padding (`{:06}`), a sign (`{:+}`), digits after the point
(`{:.2f}`), exponent notation (`{:.3e}`) and other bases with a prefix
(`{:#x}`). The [Formatted print](../hello/format.md) page lists the parts of a
format spec.

### Activities

1. Print `ratio` with 0, 2 and 4 digits after the point.
2. Print the numbers 1 to 12 in hexadecimal, two digits each, on one line.
