[Home](Home) › [All Categories](Categories) › **Block Strings**

# Block Strings

```freebasic
dim as ustring query = """
    select id, name
      from users
     where active = 1
    """
print query
```

`query` holds three lines, `select id, name`, `  from users` and ` where active = 1`, joined by line feeds. The indentation the code needs is gone; the indentation the text has is kept.

## Why It Exists

A line ends a statement in tiko, so an ordinary string literal never crosses one. Before block strings, several lines of text meant one literal per line, glued with `&`, `chr( 10 )` and a `_` continuation on every line. SQL, JSON, HTML, shader source and usage text are the cases where that hurts most. A block string is the text as it would appear in a file, indented to match the code around it.

## Rules

**It opens** with `"""` that ends its line: nothing but spaces or tabs may follow it. That condition is what keeps old code meaning what it meant (see [Compatibility](#compatibility)).

**It closes** at the first line that starts, after spaces and tabs, with `"""`. Anything after the closing `"""` is ordinary code, so the block can sit in the middle of an expression:

```freebasic
print Trim( """
    padded
    """ & " tail" )
```

**The closing line's indentation is the margin.** It is removed from the start of every line in the body, byte for byte. A line indented further keeps the extra; a blank line is always fine, whatever whitespace it holds. A non-blank line that does not start with the margin is error `TKO0208`. A tab never counts as spaces, so a tab-indented line under a space-indented closer is an error, not a guess.

```freebasic
dim as ustring a = """
    two spaces kept
      here
    """            ' margin: 4 spaces

dim as ustring b = """
    all four kept
"""                ' margin: none
```

**Line breaks.** The line break after the opening `"""` and the one before the closing line are not part of the value. Every line break inside it is a single line feed, `chr( 10 )`, whether the source file uses CRLF or LF. For a trailing line feed, leave an empty line before the closing line.

**Quotes and backslashes need no escaping.** `"` is just a character, and so is `"""` in the middle of a line; only a line that *starts* with `"""` closes the block. A backslash is an ordinary character, as it is in any plain tiko string.

**Prefixes.** `!"""` reads backslash escapes, exactly as `!"..."` does, after the margin is removed. A backslash at the very end of a line joins that line to the next with no line break. `$"""` is the same as `"""`.

```freebasic
dim as ustring row = !"""
    name\tvalue
    one long line, \
    continued
    """            ' "name<TAB>value" LF "one long line, continued"
```

A block string can go anywhere a string literal can: an initializer, a `const`, an argument, a `#define`. In a module's interface, or when a macro stringises it, it is written back as the equivalent one-line `!"..."` literal.

## Errors

| Id | When |
| --- | --- |
| `TKO0207` | No closing line before the end of the file. The rest of the file becomes the string. |
| `TKO0208` | A non-blank line does not start with the closing line's indentation. |

## Compatibility

fbc has no block strings. In fbc, `"""` followed by the end of the line is a string that is missing its closing quote. fbc warns about it (warning 12) and the value is a single `"`. tiko reads the same text as the start of a block string. No real code was found written that way: the vendored fbc test suite, tiko's packages and its tests contain no such line. Every other spelling keeps its fbc meaning. `"""abc"""` is still the five-character string `"abc"`, and `""""` is still one quote.

See [Compatibility](Compatibility).
