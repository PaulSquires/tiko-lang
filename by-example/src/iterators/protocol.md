# Making a type iterable

`for each` walks your own types too, and there is nothing to inherit. A type
is *iterable* when it has a `GetIterator( )` method, and what that returns is
an *iterator* when it has three methods: `IsValid( )`, `Value( )` and
`MoveNext( )`. The compiler looks for those names.

```tiko
{{#include ../../examples/iterators/range.tiko}}
```

**Output**

```text
{{#include ../../examples/iterators/range.out}}
```

| Member | On | Job |
|---|---|---|
| `GetIterator( ) as I` | the collection | hand out a new iterator; called once per loop |
| `IsValid( ) as boolean` | the iterator | is there a current element? |
| `Value( ) as E` | the iterator | the current element; `E` is the loop variable's type |
| `MoveNext( )` | the iterator | advance to the next element |

The loop calls `GetIterator( )` once, as the `(GetIterator)` lines show. Then,
for as long as `IsValid( )` is true, it binds `Value( )` to `n`, runs the body
and calls `MoveNext( )`.

Three rules make an iterator behave:

- **A new iterator is already on the first element.** There is no initial
  `MoveNext( )`. For an empty collection `IsValid( )` is false at once, as it
  is for `backwards`, and the body never runs.
- **`IsValid( )` is a question.** Asking twice without a `MoveNext( )` in
  between gives the same answer.
- **`Value( )` decides what `byref` can do.** Declared `byref as E`, it hands
  out the element itself, and `for each byref` can write to it; the
  [next page](ring.md) does that. Declared by value, as here, it hands out a
  copy.

The calls are direct: no interface and no virtual dispatch.

A misspelt member does not match, and the error names the one that is
missing:

```tiko
{{#include ../../examples/iterators/misspelt.tiko}}
```

```text
misspelt.tiko(31,1): error TKO0607: 'tickiterator' is not an iterator: it has no 'MoveNext( )'
     |
  31 | for each t in three
     | ^
```

A type with no `GetIterator( )` at all gets `TKO0606: ... cannot be walked by
'for each': it has no GetIterator( )`.

### Activities

1. Give `Range` a `Count( )` function and use it to print how many elements
   a range has before walking it.
2. Make `Value( )` return the square of `at`. What changes in the loops?
