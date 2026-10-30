# Containers and Sorting

A fixed array holds a number of elements decided when it is declared. Most real collections are
not like that: a list of orders grows as orders arrive, a word count gains a key for every new
word, a set of visited cells answers "have I been here?" a million times. Writing those from
arrays and `redim preserve` each time is how programs get slow and wrong.

The standard library's `std/containers` module has nine collections, each built for one kind of
access, plus the procedures that sort, search and rearrange them. They are ordinary generic types, written in
tiko — nothing about them is built into the compiler — and they share one shape: construct one,
fill it, walk it with `for each`.

```tiko
#import "std/containers"
```

## Arrays that grow: Array( of T )

```tiko
{{#include ../examples/ch24/arraybasics.tiko}}
```

```text
{{#include ../examples/ch24/arraybasics.out}}
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
{{#include ../examples/ch24/indexof.tiko}}
```

```text
{{#include ../examples/ch24/indexof.out}}
```

`IndexOf` returns the first index holding the value, or −1; `Contains` says whether there is one.
Both are **free procedures**, not members, and that is deliberate. They need `=` on the element
type, and every member of a generic type is compiled for every element type it is used with — so a
member `IndexOf` would make an `Array` of any type without `=` impossible to declare. As free
procedures, the requirement lands only on the calls that make it.

Their element type is inferred from the arguments, exactly, with no conversions:

```tiko
{{#include ../examples/ch24/indexofliteral.tiko}}
```

```
indexofliteral.tiko(4,25): error TKO0809: cannot infer the type arguments of 'indexof'; write them, as 'indexof( of ... )( ... )'
```

`85` is an `integer` and the array holds `int32`s, so no single `T` fits both. Pass a variable of
the element type, as `indexof.tiko` does, or write the type: `containers.IndexOf( of int32 )(
scores, 85 )`.

### Searching a sorted array

`IndexOf` looks at every element until it finds one. When the array is **sorted**, a binary search
halves the range at each step instead — about 20 looks for a million elements:

```tiko
{{#include ../examples/ch24/bsearch.tiko}}
```

```text
{{#include ../examples/ch24/bsearch.out}}
```

| Procedure | Returns |
|---|---|
| `LowerBound( xs, v )` | the first index whose element is not less than `v`: where `v` would go, before any equal elements |
| `UpperBound( xs, v )` | the first index whose element is greater than `v`: just past the last equal one |
| `BinarySearch( xs, v )` | the index of the first element equal to `v`; when there is none, `-( insertion point ) - 1` |
| `PartitionPoint( xs, pred )` | the first index where `pred` is `false`, for an array where every `true` comes first |

`UpperBound` minus `LowerBound` counts the copies of a value. A miss in `BinarySearch` is always
negative and still says where the value belongs: `-( r + 1 )` turns it back into the index at which
an `Insert` keeps the array sorted.

All four **require the array sorted by the same order they search with**; on an unsorted array
they return some index without complaint. They infer `T` from both arguments exactly, as `IndexOf`
does, which is why the listing names `v`, `hit` and `miss` as `int32` variables. Each has a
`...By` twin taking a comparer, for an array sorted with `SortBy`.

## Hashed containers

### Map( of K, V )

A `Map` stores values under keys, and finds the value for a key in constant time on average:

```tiko
{{#include ../examples/ch24/wordcount.tiko}}
```

```text
{{#include ../examples/ch24/wordcount.out}}
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
{{#include ../examples/ch24/mapgrows.tiko}}
```

```text
{{#include ../examples/ch24/mapgrows.out}}
```

Two items were stocked; the two `if`s asked about two more, and each question inserted a zero. The
program printed the right answers and quietly made the map hold four entries — so a later
`Count( )`, a `for each` over the stock, or a report of "every fruit we carry" is now wrong. Use
`[ ]` to **write**, and `TryGet` or `Contains` to **read**.
````

`Add` and `Put` differ in what happens when the key is already there:

```tiko
{{#include ../examples/ch24/addput.tiko}}
```

```text
{{#include ../examples/ch24/addput.out}}
```

`Add` refuses to replace and says so; `Put` replaces and tells you whether the key was new.

### Set( of T )

A `Set` holds each value at most once and answers "is it in?" in constant time on average:

```tiko
{{#include ../examples/ch24/setops.tiko}}
```

```text
{{#include ../examples/ch24/setops.out}}
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
{{#include ../examples/ch24/customkey.tiko}}
```

```text
{{#include ../examples/ch24/customkey.out}}
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
{{#include ../examples/ch24/leaderboard.tiko}}
```

```text
{{#include ../examples/ch24/leaderboard.out}}
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
{{#include ../examples/ch24/queue.tiko}}
```

```text
{{#include ../examples/ch24/queue.out}}
```

A `LinkedList` adds and removes at **both ends** in constant time: `PushBack`, `PushFront`,
`PopBack`, `PopFront`, with `Front( )` and `Back( )` to look without removing. That makes it a
queue, a stack, or both at once.

Popping an empty list returns the element type's default value — 0, or an empty string — rather
than an error, so test `IsEmpty( )` first when the difference matters, as the loop above does. A
`LinkedList` has no index: reaching the middle means walking to it.

## Deque( of T )

A `Deque` — say "deck", short for double-ended queue — does what a `LinkedList` does at both ends,
and adds what it cannot: `d[ i ]` reaches any element in constant time.

```tiko
{{#include ../examples/ch24/window.tiko}}
```

```text
{{#include ../examples/ch24/window.out}}
```

The listing keeps a **sliding window**: each reading goes in at the back, and once there are more
than three the oldest comes off the front. `recent[ 0 ]` is always the front, and `for each` walks
front to back.

A `Deque` keeps its elements in one block of memory used as a ring: the front can sit anywhere in
the block, and the elements wrap round its end. When the block fills, its size doubles. So
`PushBack`, `PushFront`, `PopBack` and `PopFront` each cost a constant amount on average, nothing
is allocated per element, and a walk reads one contiguous block, as it does for an `Array`. Prefer it to a
`LinkedList` for queues; keep the `LinkedList` for the one thing the ring cannot give, an iterator
that stays valid while you add elsewhere.

The `Pop` forms return a default value on an empty deque, as `LinkedList`'s do; `TryPopFront( v )`
and `TryPopBack( v )` return `false` instead. `d[ i ]`, `Front( )` and `Back( )` need an index from
0 to `Count( ) - 1`, and the deque does not grow to make a bad one valid.

## PriorityQueue( of T )

A queue serves in arrival order. A **priority queue** serves whatever matters most first, however
late it arrived:

```tiko
{{#include ../examples/ch24/jobs.tiko}}
```

```text
{{#include ../examples/ch24/jobs.out}}
```

`PriorityQueue( of T )` hands back its **smallest** element first, by `T`'s own `<`. For any other
order — largest first, or by one field of a record, as here — `PriorityQueueBy( of T, TLess )`
takes a comparer when it is constructed: `less( a, b )` is `true` when `a` must leave before `b`,
the question a `SortBy` comparer answers. The second type argument is the comparer's type. A plain
lambda or `@MyProc` has a procedure-pointer type, which the listing names `JobFirst`; a capturing
lambda's type is written `typeof( name )`.

`Push` and `Pop` cost O(log n), and `Peek` looks at the next element without removing it.
`MakeHeap( xs )` builds a queue from an `Array` in O(n), cheaper than pushing the elements one at a
time. Two elements that compare equal leave in no particular order: give records a sequence number
and compare on it second when the order among equals matters.

````admonish danger title="Pitfall"
**`for each` over a priority queue is not priority order.**

```tiko
{{#include ../examples/ch24/heaporder.tiko}}
```

```text
{{#include ../examples/ch24/heaporder.out}}
```

The queue is a **binary heap**: an array arranged so that each element is no greater than the two
below it. That arrangement is what makes `Push` and `Pop` cheap, and it is not sorted — so a loop
that prints the queue, or takes "the first three" from it, gets heap order, which looks almost
right. Take elements in priority order with `Pop`, or call `ToSortedArray( )`, which sorts a copy
and leaves the queue as it was.
````

## BitSet

A `BitSet` is a set of small whole numbers stored one bit each, so a million flags fit in 125 KB
and testing one costs a shift and a mask:

```tiko
{{#include ../examples/ch24/sieve.tiko}}
```

```text
{{#include ../examples/ch24/sieve.out}}
```

`Set( i )` grows the set when `i` is beyond its `Length( )`, and `Test` of a bit beyond the length
is `false`, so a `BitSet` can start empty; `BitSet( n )` starts with `n` clear bits instead.
`Length( )` counts addressable bits, `CountOnes( )` the ones that are set. `for each` visits the
set bits in ascending order; `FirstSet( from )` and `NextClear( from )` find the next set or clear
bit.

`UnionWith`, `IntersectWith`, `DifferenceWith` and `SymmetricDifferenceWith` work 64 bits at a time
and change the set they are called on — which is why the listing copies `primes` before taking the
odd numbers away. Compare two sets with `a.Equals( b )`: it compares the bits that are set, so sets
of different lengths can be equal.

## Filling a container from a list

Every container but `BitSet` takes a brace list when it is declared, one entry per element:

```tiko
{{#include ../examples/ch24/initializers.tiko}}
```

```text
{{#include ../examples/ch24/initializers.out}}
```

A map's entries are `{ key, value }` pairs inside the outer braces. The list is a convenience for
starting values; the container is an ordinary one afterwards.

## Sorting

```tiko
{{#include ../examples/ch24/sorting.tiko}}
```

```text
{{#include ../examples/ch24/sorting.out}}
```

| Procedure | Sorts | Stable | Order by |
|---|---|---|---|
| `Sort( xs )` | an `Array`, in place | no | `<` on the element |
| `SortBy( xs, less )` | an `Array`, in place | no | a comparer |
| `StableSort( xs )`, `StableSortBy( xs, less )` | an `Array`, in place | **yes** | `<`, or a comparer |
| `SortList( l )`, `SortListBy( l, less )` | a `LinkedList` | yes | `<`, or a comparer |
| `IsSorted( xs )`, `IsSortedBy( xs, less )` | — | — | answers whether it is |

A **comparer** answers "does `a` go before `b`?", as Chapter 21 described. A **stable** sort keeps
elements that compare equal in the order they arrived. The listing sorts by points first, then by
team stably — so within each team, the best-first order from the first sort survives. With the
unstable `SortBy` for the second step, the order within a team would be whatever the algorithm
left.

`Sort` is an introsort: O(n log n) in the worst case, in place, not stable. `StableSort` is a merge
sort: O(n log n) too, stable, and it needs a scratch buffer as large as the array. Both move
elements by swapping, so sorting an array of strings or records copies no element.

### Rearranging in place

Often a full sort answers more than the question asked. The three fastest times, or the median,
need only part of the order:

```tiko
{{#include ../examples/ch24/rearrange.tiko}}
```

```text
{{#include ../examples/ch24/rearrange.out}}
```

| Procedure | Leaves the array | Cost |
|---|---|---|
| `PartialSort( xs, k )` | the `k` smallest at the front, sorted; the rest in no order | O(n log k) |
| `NthElement( xs, k )` | at `xs[k]` what a full sort would put there; nothing greater before it, nothing less after | O(n) on average |
| `Dedup( xs )` | without **consecutive** repeats; returns how many it removed | O(n) |
| `ReverseArray( xs )`, `RotateArray( xs, k )` | reversed; rotated left by `k` | O(n) |
| `NextPermutation( xs )` | the next ordering in sorted order; `false` after the last | O(n) |
| `MinIndex( xs )`, `MaxIndex( xs )` | unchanged; the index of the smallest or largest, or -1 | O(n) |

`Dedup` removes runs, so `Sort` first when every repeat should go. Each procedure that compares has
a `...By` twin taking a comparer, and every move is a swap, as in the sorts.

`ReverseArray` and `RotateArray` carry the type in their names because `std/strings` has its own
`Reverse` and `std/numeric` its own `Rotate`: a program that brings in both modules with `using`
would find the bare names ambiguous.

## Choosing a container

| Container | Find by key or value | Add | Remove | Order | Use it for |
|---|---|---|---|---|---|
| `Array` | O(n) search, O(1) by index | O(1) at the end | O(n), or O(1) with `RemoveSwap` | insertion | most lists |
| `Map` | O(1) average | O(1) average | O(1) average | none | lookup by key |
| `Set` | O(1) average | O(1) average | O(1) average | none | membership, no duplicates |
| `OrderedMap` | O(log n) | O(log n) | O(log n) | sorted by key | sorted lookup, nearest key |
| `OrderedSet` | O(log n) | O(log n) | O(log n) | sorted | sorted unique values |
| `LinkedList` | O(n) | O(1) at either end | O(1) at either end | insertion | iterators that survive adds |
| `Deque` | O(n) search, O(1) by index | O(1) at either end | O(1) at either end | insertion | queues, sliding windows |
| `PriorityQueue` | O(1), the smallest only | O(log n) | O(log n), the smallest only | by priority, through `Pop` | scheduling, "most urgent next" |
| `BitSet` | O(1) | O(1) | O(1) | ascending | flags, sets of small numbers |

When in doubt, start with an `Array`. It is the most compact and the fastest to walk, and it is
the right answer more often than its O(n) search suggests: for a few dozen elements, a linear scan
over contiguous memory is cheap, and can cost less than hashing the key.

### What invalidates a loop

Chapter 20's rule holds here, container by container. **Changing a container's structure while a
`for each` walks it is not allowed**, and nothing detects it:

- **`Array`**: `Push`, `Insert`, `Remove`, `RemoveSwap`, `Clear`, `Reserve`, `Shrink` and a sort
  may move every element. Assigning to `xs[i]`, or through a `for each byref` variable, does not.
- **`Map`, `Set`**: adding can rehash the whole table, and removing invalidates the walk. A `Set`
  element must never be changed in place, even through `byref`: its hash changes, and it can no
  longer be found.
- **`OrderedMap`, `OrderedSet`**: adding or removing changes the tree under the loop.
- **`LinkedList`**: adding at either end leaves a walk valid; removing the node being visited does
  not.
- **`Deque`, `PriorityQueue`**: any push or pop may move every element.
- **`BitSet`**: setting a bit at or beyond `Length( )` grows the set under the loop.

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
- `Deque`: O(1) at both ends **and** by index — the queue to reach for first.
- `PriorityQueue`: smallest first, or any order with `PriorityQueueBy` and a comparer. `for each`
  is heap order, not priority order: use `Pop` or `ToSortedArray( )`.
- `BitSet`: one bit per number, grows on `Set`, set algebra a word at a time, `Equals` to compare.
- On a sorted array, `LowerBound`, `UpperBound` and `BinarySearch` find in O(log n).
  `PartialSort` and `NthElement` answer "the k smallest" and "the median" without a full sort.
- Brace lists fill any container but `BitSet` at its declaration; a map takes `{ key, value }`
  pairs.
- `Sort`/`SortBy` are fast and unstable; `StableSort`/`StableSortBy` keep equal elements in order.
- Do not change a container's structure inside a `for each` over it.

## Exercises

1. Count the words of a text in a `Map` and print the three most frequent, ties broken
   alphabetically so the output never varies. {solution="ex24-01"}
2. Keep the booked appointment times in an `OrderedSet`. For each requested time, report whether
   it is booked, and if not, how long it is free until. {solution="ex24-02"}
3. Rewrite `mapgrows.tiko` so it prints the same messages and the map still holds two entries.
4. Remove every odd number from an `Array( of int32 )` without changing the array while walking
   it. Then do it again with `RemoveSwap`, walking from the end. Which keeps the order?
5. Give `Cell` a third field, `label`, that `=` ignores. What must `HashOf` still use, and what
   goes wrong if it also hashes `label`?
6. Change `window.tiko` to keep the last five readings and also print the largest reading in the
   window each time. `MaxIndex` takes an `Array`, not a `Deque`: decide whether to copy the window
   or walk it.
7. Give `Job` a sequence number and make `JobFirst` break ties with it, so two jobs of equal
   priority leave in the order they arrived.
