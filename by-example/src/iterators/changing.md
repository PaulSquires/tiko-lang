# Changing a collection while walking it

A loop and the collection it walks share the collection's storage. Changing
the collection's *shape*, adding or removing elements, while the loop runs
breaks that sharing in ways that differ from one collection to the next.

```tiko
{{#include ../../examples/iterators/changing.tiko}}
```

**Output**

```text
{{#include ../../examples/iterators/changing.out}}
```

Over an array, `for each` reads the bounds **once**, before the first pass,
like the counted loop it compiles to. Growing the array inside the loop does
not extend the walk: the fourth element exists afterwards and is never visited.
Shrinking it inside the loop does not shorten the walk either: the loop goes
on to the bound it read, past the end of what is left, and `-exx` does not
catch it.

A library container's iterator holds a position in the container's storage,
and adding or removing elements can move that storage. Do not change a
container's shape while `for each` walks it. Changing an element's *value*
through a `byref` loop variable is fine; that is what `byref` is for.

The second half shows the safe pattern: the loop over `stock` only *collects*
the keys to remove in `soldOut`, and a second loop removes them once the first
has finished.

```admonish danger title="Pitfall"
A `byref` loop variable bound to an array element points into the array's
storage. `redim preserve` can move that storage, and after it the variable
refers to where the element used to be.
```

### Activities

1. Use the same pattern to double the stock of every item with fewer than 5,
   adding a new `"<item> (reorder)"` entry for each.
2. Rewrite the first loop so that it does visit the fourth element: a
   `do` loop that tests `ubound( queue )` on every pass.
