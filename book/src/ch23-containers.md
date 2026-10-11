# Containers and Sorting

A fixed array holds a number of elements decided when it is declared. Most real collections are
not like that: a list of orders grows as orders arrive, a word count gains a key for every new
word, a set of visited cells answers "have I been here?" a million times. Writing those from
arrays and `redim preserve` each time is how programs get slow and wrong.

The standard library's `std/containers` module has six collections, each built for one kind of
access, plus the sorting procedures that go with them. They are ordinary generic types, written in
tiko — nothing about them is built into the compiler — and they share one shape: construct one,
fill it, walk it with `for each`.

```tiko
#import "std/containers"
```

## Arrays that grow: Array( of T )

```tiko
{{#include ../examples/ch23/arraybasics.tiko}}
```

```text
{{#include ../examples/ch23/arraybasics.out}}
```

An `Array( of T )` keeps a **count** — how many elements there are — and a **capacity** — how many
fit before it must grow. `Push` appends; when the capacity runs out it doubles, so a long run of
pushes reallocates only a handful of times and each push costs, on average, a constant amount.
That is the difference from `redim preserve`, which reallocates on every call and makes a loop of
appends quadratic.

| Member | Does | Cost |
|---|---|---|
| `xs[i]` | the element at `i`, which can be assigned | O(1) |
| `Push( v )`, `Pop( )` | add at the end; remove and return the last | O(1) on average |
| `Insert( i, v )`, `Remove( i )` | add or remove at `i`, keeping the order | O(n) |
| `RemoveSwap( i )` | remove at `i` by moving the last element into the gap | O(1) |
| `Count( )`, `Capacity( )`, `IsEmpty( )` | sizes | O(1) |
| `Reserve( n )`, `Shrink( )` | grow capacity ahead of time; release the spare | O(n) |
| `Clear( )` | remove every element, **keeping** the capacity | O(n) |

**Indices start at 0**, whatever an ordinary array's `dim a( 1 to 10 )` habit says: `xs[0]` is the
first element and `xs[xs.Count( ) - 1]` the last. `RemoveSwap` is the fast way to remove when the
order does not matter. `Reserve` is worth calling when you know how many elements are coming: one
allocation instead of several.

Copying an `Array` copies every element — `dim b as … = a`, assignment, and a `byval` parameter
all make an independent array. Pass containers `byref` unless a copy is what you want.

### Searching

```tiko
{{#include ../examples/ch23/indexof.tiko}}
```

```text
{{#include ../examples/ch23/indexof.out}}
```

`IndexOf` returns the first index holding the value, or −1; `Contains` says whether there is one.
Both are **free procedures**, not members, and that is deliberate. They need `=` on the element
type, and every member of a generic type is compiled for every element type it is used with — so a
member `IndexOf` would make an `Array` of any type without `=` impossible to declare. As free
procedures, the requirement lands only on the calls that make it.

Their element type is inferred from the arguments, exactly, with no conversions:

```tiko
{{#include ../examples/ch23/indexofliteral.tiko}}
```

```
indexofliteral.tiko(4,25): error TKO0809: cannot infer the type arguments of 'indexof'; write them, as 'indexof( of ... )( ... )'
```

`85` is an `integer` and the array holds `int32`s, so no single `T` fits both. Pass a variable of
the element type, as `indexof.tiko` does, or write the type: `containers.IndexOf( of int32 )(
scores, 85 )`.

## Hashed containers

### Map( of K, V )

A `Map` stores values under keys, and finds the value for a key in constant time on average:

```tiko
{{#include ../examples/ch23/wordcount.tiko}}
```

```text
{{#include ../examples/ch23/wordcount.out}}
```

| Member | Does |
|---|---|
| `m[k]` | the value for `k`, which can be assigned — **inserting a default value if `k` is absent** |
| `TryGet( k, v )` | `true` and the value in `v` if `k` is present; inserts nothing |
| `Contains( k )` | whether `k` is present; inserts nothing |
| `Add( k, v )` | inserts only if `k` is absent |
| `Put( k, v )` | inserts, or replaces the value of an existing key |
| `Remove( k )` | `true` if something was removed |
| `Keys( )`, `Values( )` | the keys or values, copied into an `Array` |
| `Pairs( )` | `(key, value)` tuples for `for each` |

`counts[ word ] += 1` works on the first sighting of a word because a missing key is inserted with
the value type's default, 0, before the `+= 1`. That is the reason the indexer inserts. The cost of
that convenience is the next listing.

A `Map` keeps **no order**: `for each` visits its entries in whatever order the table holds them,
and that order changes as the map grows. To print in a stable order, take `Keys( )` and sort it,
as `wordcount.tiko` does — or use an `OrderedMap`, below.

````admonish danger title="Pitfall"
**Reading a `Map` with `[ ]` inserts every key it does not find.**

```tiko
{{#include ../examples/ch23/mapgrows.tiko}}
```

```text
{{#include ../examples/ch23/mapgrows.out}}
```

Two items were stocked; the two `if`s asked about two more, and each question inserted a zero. The
program printed the right answers and quietly made the map hold four entries — so a later
`Count( )`, a `for each` over the stock, or a report of "every fruit we carry" is now wrong. Use
`[ ]` to **write**, and `TryGet` or `Contains` to **read**.
````

`Add` and `Put` differ in what happens when the key is already there:

```tiko
{{#include ../examples/ch23/addput.tiko}}
```

```text
{{#include ../examples/ch23/addput.out}}
```

`Add` refuses to replace and says so; `Put` replaces and tells you whether the key was new.

### Set( of T )

A `Set` holds each value at most once and answers "is it in?" in constant time on average:

```tiko
{{#include ../examples/ch23/setops.tiko}}
```

```text
{{#include ../examples/ch23/setops.out}}
```

`Add` returns `false` for a value already present. `IntersectWith`, `UnionWith` and `ExceptWith`
change the set they are called on, so the listing copies `evens` first — copying a `Set`, like
every container here, copies its contents. Like a `Map`, a `Set` has no order; `Items( )` gives an
`Array` to sort.

### Keys of your own

Every built-in type can be a key. A record type needs two things: `=`, to say when two keys are
the same, and a **hash** — a number computed from the key, which decides where in the table it is
stored:

```tiko
{{#include ../examples/ch23/customkey.tiko}}
```

```text
{{#include ../examples/ch23/customkey.out}}
```

`probe` is a different variable from `spot`, with the same contents, and the map finds it: the two
are equal, so they hash equally and land in the same place. The hash is the key's own `HashOf( )`,
an override of the abstract one in `containers.Hashable`, which every key type extends; the module's
`containers.HashOf` already has an overload for every built-in type, which is what
`containers.HashOf( row )` calls.

One rule makes it work: **equal keys must produce equal hashes.** Compute the hash from exactly the
fields that `=` compares. A hash that included a field `=` ignores would put two equal keys in
different places, and the map would lose track of entries without any error.

## Ordered containers

`OrderedMap` and `OrderedSet` keep their contents **sorted**. They are trees rather than tables, so
each operation costs O(log n) rather than O(1) — and in exchange they can answer questions about
order that a hashed container cannot:

```tiko
{{#include ../examples/ch23/leaderboard.tiko}}
```

```text
{{#include ../examples/ch23/leaderboard.out}}
```

`for each` visits the keys from smallest to largest, every time. `TryFirst` and `TryLast` give the
smallest and largest entries. `TryFloor( k, … )` finds the largest key **at or below** `k`, and
`TryCeiling` the smallest **at or above** — the nearest neighbours of a value that need not be a
key at all, which is what a schedule, a price ladder or a leaderboard asks. Each returns `false`
when there is no such key.

An ordered container needs only `<` on its key type, not a hash. Two keys are treated as the same
when neither is less than the other. `OrderedSet( of T )` is the same tree with no values:
`Add`, `Contains`, `Remove`, the set operations, and the four `Try` neighbours.

Reach for an ordered container when you need the order, not by default: the hashed ones are faster
for everything else.

## LinkedList( of T )

```tiko
{{#include ../examples/ch23/queue.tiko}}
```

```text
{{#include ../examples/ch23/queue.out}}
```

A `LinkedList` adds and removes at **both ends** in constant time: `PushBack`, `PushFront`,
`PopBack`, `PopFront`, with `Front( )` and `Back( )` to look without removing. That makes it a
queue, a stack, or both at once.

Popping an empty list returns the element type's default value — 0, or an empty string — rather
than an error, so test `IsEmpty( )` first when the difference matters, as the loop above does. A
`LinkedList` has no index: reaching the middle means walking to it.

## Filling a container from a list

Every container takes a brace list when it is declared, one entry per element:

```tiko
{{#include ../examples/ch23/initializers.tiko}}
```

```text
{{#include ../examples/ch23/initializers.out}}
```

A map's entries are `{ key, value }` pairs inside the outer braces. The list is a convenience for
starting values; the container is an ordinary one afterwards.

## Sorting

```tiko
{{#include ../examples/ch23/sorting.tiko}}
```

```text
{{#include ../examples/ch23/sorting.out}}
```

| Procedure | Sorts | Stable | Order by |
|---|---|---|---|
| `Sort( xs )` | an `Array`, in place | no | `<` on the element |
| `SortBy( xs, less )` | an `Array`, in place | no | a comparer |
| `StableSort( xs )`, `StableSortBy( xs, less )` | an `Array`, in place | **yes** | `<`, or a comparer |
| `SortList( l )`, `SortListBy( l, less )` | a `LinkedList` | yes | `<`, or a comparer |
| `IsSorted( xs )`, `IsSortedBy( xs, less )` | — | — | answers whether it is |

A **comparer** answers "does `a` go before `b`?", as Chapter 20 described. A **stable** sort keeps
elements that compare equal in the order they arrived. The listing sorts by points first, then by
team stably — so within each team, the best-first order from the first sort survives. With the
unstable `SortBy` for the second step, the order within a team would be whatever the algorithm
left.

`Sort` is an introsort: O(n log n) in the worst case, in place, not stable. `StableSort` is a merge
sort: O(n log n) too, stable, and it needs a scratch buffer as large as the array. Both move
elements by swapping, so sorting an array of strings or records copies no element.

## Choosing a container

| Container | Find by key or value | Add | Remove | Order | Use it for |
|---|---|---|---|---|---|
| `Array` | O(n) search, O(1) by index | O(1) at the end | O(n), or O(1) with `RemoveSwap` | insertion | most lists |
| `Map` | O(1) average | O(1) average | O(1) average | none | lookup by key |
| `Set` | O(1) average | O(1) average | O(1) average | none | membership, no duplicates |
| `OrderedMap` | O(log n) | O(log n) | O(log n) | sorted by key | sorted lookup, nearest key |
| `OrderedSet` | O(log n) | O(log n) | O(log n) | sorted | sorted unique values |
| `LinkedList` | O(n) | O(1) at either end | O(1) at either end | insertion | queues, deques |

When in doubt, start with an `Array`. It is the most compact and the fastest to walk, and it is
the right answer more often than its O(n) search suggests: for a few dozen elements, a linear scan
over contiguous memory is cheap, and can cost less than hashing the key.

### What invalidates a loop

Chapter 19's rule holds here, container by container. **Changing a container's structure while a
`for each` walks it is not allowed**, and nothing detects it:

- **`Array`**: `Push`, `Insert`, `Remove`, `RemoveSwap`, `Clear`, `Reserve`, `Shrink` and a sort
  may move every element. Assigning to `xs[i]`, or through a `for each byref` variable, does not.
- **`Map`, `Set`**: adding can rehash the whole table, and removing invalidates the walk. A `Set`
  element must never be changed in place, even through `byref`: its hash changes, and it can no
  longer be found.
- **`OrderedMap`, `OrderedSet`**: adding or removing changes the tree under the loop.
- **`LinkedList`**: adding at either end leaves a walk valid; removing the node being visited does
  not.

Collect the changes in a second container during the loop, and apply them after it.

## What it costs

- **Every container copies its contents when it is copied.** A `byval` parameter or an assignment
  of a large container is a large copy; pass `byref`.
- **A hashed container trades memory for speed**: its table has spare room so that lookups stay
  constant-time.
- **An ordered container allocates per element**, a node at a time, and pays O(log n) for order.
- **`Keys( )`, `Values( )` and `Items( )` build a new `Array`** every time they are called.

## Summary

- `#import "std/containers"`. `Array`, `Map`, `Set`, `OrderedMap`, `OrderedSet`, `LinkedList`.
- `Array`: zero-based, `Push`/`Pop` amortised O(1), `Insert`/`Remove` O(n), `RemoveSwap` O(1),
  `Reserve` to pre-size. `IndexOf` and `Contains` are free procedures, and infer `T` exactly — a
  bare literal does not match an `int32` array (`TKO0809`).
- `Map`: **`m[k]` inserts on a miss** — read with `TryGet`/`Contains`. `Add` will not replace;
  `Put` will. No order: sort `Keys( )` to print.
- `Set`: unique values, with `IntersectWith`, `UnionWith`, `ExceptWith`.
- A custom key needs `=`, and extends `containers.Hashable` with a `HashOf( )` override; equal
  keys must hash equally.
- `OrderedMap`/`OrderedSet`: sorted, O(log n), `TryFirst`/`TryLast`/`TryFloor`/`TryCeiling`; need
  only `<`.
- `LinkedList`: O(1) at both ends; popping an empty list returns a default value.
- Brace lists fill any container at its declaration; a map takes `{ key, value }` pairs.
- `Sort`/`SortBy` are fast and unstable; `StableSort`/`StableSortBy` keep equal elements in order.
- Do not change a container's structure inside a `for each` over it.

## Exercises

1. Count the words of a text in a `Map` and print the three most frequent, ties broken
   alphabetically so the output never varies. {solution="ex23-01"}
2. Keep the booked appointment times in an `OrderedSet`. For each requested time, report whether
   it is booked, and if not, how long it is free until. {solution="ex23-02"}
3. Rewrite `mapgrows.tiko` so it prints the same messages and the map still holds two entries.
4. Remove every odd number from an `Array( of int32 )` without changing the array while walking
   it. Then do it again with `RemoveSwap`, walking from the end. Which keeps the order?
5. Give `Cell` a third field, `label`, that `=` ignores. What must `HashOf` still use, and what
   goes wrong if it also hashes `label`?
