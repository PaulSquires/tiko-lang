# Containers

A fixed array holds as many elements as its declaration says. Most collections
are not like that: a list grows as items arrive, a word count gains a key for
every new word, a set of visited cells answers "have I been here?" again and
again. The `std/containers` module has a collection for each of those jobs.

```tiko
{{#include ../../examples/containers/overview.tiko}}
```

**Output**

```text
{{#include ../../examples/containers/overview.out}}
```

`#import "std/containers"` brings in the module, and its types are named
through it: `containers.Array( of ustring )`. Each container is a generic type,
so you choose the element type when you declare one, and each works with
`for each`.

| Container | Holds | Good at |
|---|---|---|
| [`Array( of T )`](array.md) | elements in order, by index from 0 | appending, walking, indexing |
| [`Map( of K, V )`](map.md) | a value for each key | finding a value by its key |
| [`Set( of T )`](set.md) | each value at most once | "is it in?", set operations |
| [`OrderedMap`, `OrderedSet`](ordered.md) | keys kept sorted | order, nearest key |
| [`LinkedList( of T )`](linkedlist.md) | elements in a chain | adding and removing at both ends |

The rest of the section covers [sorting](sorting.md),
[searching](searching.md), [keys of your own](custom-keys.md) and
[brace-list initialisers](initialisers.md).

Copying a container copies every element in it, so pass containers to
procedures `byref`, as the examples in this section do.

### Activities

1. Print the words in the order they first appeared, using `seen.Add` to skip
   repeats.
2. Print the most frequent word and its count.
