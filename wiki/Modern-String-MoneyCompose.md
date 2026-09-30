[Home](Home) › [String Library](Category-String-Library) › [String Library](Category-String-Library) › **MoneyCompose**

# MoneyCompose

The layout primitive [MoneyFormat](Modern-String-MoneyFormat) composes with: given the number, the symbol and the sign as text, it assembles them per the POSIX `(precedes, sepBySpace, signPosn)` model. Matches `strfmon(3)` cell for cell.

## Syntax

```freebasic
MoneyCompose( num, sym, signStr, precedes, sepBySpace, signPosn ) as ustring
```

## Notes

- `signPosn`: 0 parentheses, 1 sign before all, 2 sign after all, 3 sign immediately before the symbol, 4 sign immediately after it. Anything out of range is treated as 1.
- `sepBySpace` is **0/1/2 and not a boolean**. 1 puts a space beside the number on the symbol's side; 2 puts one between the sign and the symbol. Two of the sixteen Windows negative layouts need the 2, and flattened to true/false they render `$- 1.1` and `1.1 -$`, both wrong.
- The thirty combinations were GENERATED from glibc -- thirty synthetic locales built with `localedef` and formatted with `strfmon(3)` -- not transcribed from a description of POSIX, whose paraphrases disagree about `sepBySpace = 2`.
- It reproduces one glibc wart: with `sepBySpace = 2` the space is emitted even when the sign string is empty, leaving a stray leading or trailing space. MoneyFormat itself does not, because it emits no separator with nothing on one side of it.

## Examples

```freebasic
print MoneyCompose( "1,234.50", "$", "-", true,  0, 1 )   '' -$1,234.50
print MoneyCompose( "1,234.50", "$", "-", true,  0, 4 )   '' $-1,234.50
print MoneyCompose( "1,234.50", "$", "-", true,  1, 4 )   '' $- 1,234.50
print MoneyCompose( "1,234.50", "$", "-", true,  2, 4 )   '' $ -1,234.50
print MoneyCompose( "1,234.50", "$", "",  true,  0, 0 )   '' ($1,234.50)
print MoneyCompose( "1,234.50", "$", "-", false, 1, 3 )   '' 1,234.50 -$
```

---

**Library:** [String Library](Category-String-Library)  
**Category:** [String Library](Category-String-Library)  
**Documented under:** Money Formatting  
**Source:** `docs/string/string.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).
