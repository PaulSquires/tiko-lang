# Building strings

Reports, generated code and log lines are built from many small pieces. How
you add the pieces decides whether the work grows with the length of the
result or with its square, so it is worth knowing which forms are cheap.

```tiko
{{#include ../../examples/strings/building.tiko}}
```

**Output**

```text
{{#include ../../examples/strings/building.out}}
```

All three produce the same 3893 characters:

1. **`&=` one piece at a time.** A `ustring` keeps spare room at its end and
   grows it in large steps, so appending a piece copies only that piece.
   For most programs this is the whole answer.
2. **Collect, then `strings.Join`.** Useful when the pieces are a list
   anyway, or when the separator should go *between* them and not after
   the last one. `Join` measures the result first and copies each piece
   once.
3. **Make room once, then overwrite.** When you know the final size,
   `space( n )` allocates it in one go and the `mid` statement writes into
   it without ever changing the length.

What is *not* cheap is anything that rebuilds the whole string each time:
`s = piece & s` puts the new text first, so every pass copies everything
built so far, and a loop of them slows down with the square of the length.

````admonish warning title="Status in this version"
`&=` takes the fast path only when its right-hand side is a single
`ustring`, such as a variable, a literal or the result of
`strings.Format`. With a concatenation on the right,

```tiko
s &= "item" & i & ";"
```

the whole of `s` is copied on every pass. Measured, 40,000 such appends
took several seconds, where the same loop appending `strings.Format(
"item{};", i )` took a few hundredths of one, and each doubling of the count
made the gap wider. The same happens for the
byte-string result of `str( i )`. Build the piece first, with
`strings.Format` or in a `ustring` variable, and append that, as the
example does.
````

There is no separate string builder type in the standard library: a
`ustring` and `&=` already do that job.

### Activities

1. Change the first loop to put a comma *between* the numbers but not after
   the last one. Which of the three ways makes that easiest?
2. Build the numbers in reverse order, 1000 down to 1, with `&=` rather than
   by putting each new piece in front.
