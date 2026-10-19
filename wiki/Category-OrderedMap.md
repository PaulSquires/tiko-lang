[Home](Home) › [All Categories](Categories) › **OrderedMap**

# OrderedMap

An **OrderedMap** is a [map](Category-Map) that keeps its keys in sorted order. Like any map it stores pairs -- a **key** and the **value** that goes with it -- each key appears at most once, and you find a value by its key. The difference shows when you walk through it: an OrderedMap always hands its entries back from the smallest key to the largest, whatever order they were put in.

Think of a printed dictionary: the words are kept in alphabetical order, so you can read it from A to Z, turn to the first or the last word, or find the words just before and just after one that is not in it.

Those last questions are what an OrderedMap can answer and an ordinary Map cannot: the smallest key (`TryFirst`), the largest (`TryLast`), the largest key at or below a given one (`TryFloor`) and the smallest at or above it (`TryCeiling`). A key only has to support `<`.

**OrderedSet** is the same idea for a [set](Category-Set): values with no duplicates, kept in sorted order. Both are described on this page.

Keeping things sorted has a cost: each operation takes a little longer as the container grows, where a Map's or a Set's stays about the same. So use an ordinary Map or Set unless you need the order -- see *Which One To Use* below.

The example below stores ages by name and prints them alphabetically, then records a number in an OrderedSet:

```freebasic
#import "std/containers"
using containers

dim ages as OrderedMap( of ustring, int32 )
ages.Put( "bob", 41 )
ages.Put( "ada", 36 )

for each kv in ages
    print kv.key, kv.value           ' "ada" then "bob", always
next

dim seen as OrderedSet( of int32 )
if seen.Add( 42 ) then print "first time"
```

The always-sorted siblings of containers.Map and containers.Set. Same operations, plus the four an ordered container can answer and a hash one cannot, and FOR EACH walks them in ascending key order -- which is the entire reason to reach for them.

## Which One To Use

containers.Map and containers.Set unless you need the ORDER.

```freebasic
Map / Set                 avg O(1)     order unspecified and unstable
OrderedMap / OrderedSet   O(log n)     ascending, always
```

A hash map is faster on every single operation, allocates once instead of once per entry, and does not chase pointers on lookup. These are the right choice when you need keys in order, the smallest or largest key, or the nearest key either side of a probe -- not as a general-purpose map.

There is one case where they win outright: a key type that has '<' but no hash.

```freebasic
Map                   needs K to extend containers.Hashable (or be a
                      built-in type), and '=', and equal keys must
                      hash equal
OrderedMap            needs '<'. Nothing else.
```

A type with an ordering and no hash cannot be a Map key at all.

## Members

OrderedMap( of TK, TV ):

```freebasic
Count( ) as int32                           O(1)
IsEmpty( ) as boolean                       O(1)

Put( k, v ) as boolean                      O(log n)  TRUE if k was new
Add( k, v ) as boolean                      O(log n)  FALSE if k existed
Contains( k ) as boolean                    O(log n)
TryGet( k, byref outv ) as boolean          O(log n)
Remove( k ) as boolean                      O(log n)  TRUE if removed
m[ k ] byref as TV                          O(log n)  INSERTS on a miss
Clear( )                                    O(n)

TryFirst( byref outk, byref outv )          O(log n)  smallest key
TryLast( byref outk, byref outv )           O(log n)  largest key
TryFloor( k, byref outk ) as boolean        O(log n)  largest key <= k
TryCeiling( k, byref outk ) as boolean      O(log n)  smallest key >= k

Keys( ) as Array( of TK )                   O(n)      sorted snapshot
Values( ) as Array( of TV )                 O(n)      in key order
GetIterator( )                              O(log n)
Pairs( )                                    O(1)      the tuple view
BlackHeight( ) as int32                     O(n)      -1 if corrupt
```

OrderedSet( of T ):

```freebasic
Count( ) / IsEmpty( )                       O(1)
Add( v ) as boolean                         O(log n)  FALSE if present
Contains( v ) as boolean                    O(log n)
Remove( v ) as boolean                      O(log n)
Clear( )                                    O(n)

UnionWith( other )                          O(m log n)
IntersectWith( other )                      O(n log m)
ExceptWith( other )                         O(m log n)

TryFirst( byref outv ) / TryLast( byref outv )
TryFloor( v, byref outv ) / TryCeiling( v, byref outv )

Items( ) as Array( of T )                   O(n)      SORTED snapshot
GetIterator( )                              O(log n)
BlackHeight( ) as int32                     O(n)
```

NO Reserve AND NO Capacity on either, unlike Map and Set: a tree allocates exactly one node per entry when that entry arrives, so there is no table to size in advance and nothing to tune.

## READING vs WRITING

Exactly as Map, and for the same reasons:

```freebasic
m[ k ]        INSERTS a default-constructed TV if k is absent.
m.TryGet      does not.
m.Contains    does not.
```

'm\[ k \] += 1' just working is why the indexer inserts, and 'if m\[ k \] = 0' silently growing the map is the price.

## The Ordering Contract

'<' on the key, and nothing else. No HashOf, and no '=' either:

```freebasic
Two keys are THE SAME KEY when neither is less than the other.
```

That is what std::map means by an equivalence, and it is why Put( ) can detect an overwrite without ever comparing for equality. A '<' that is not a strict weak ordering -- one where 'a < a' is true, or where a < b and b < c does not give a < c -- produces a tree that is merely wrong, not one that crashes.

The requirement lands on the TYPE, not on a call:

```freebasic
dim m as OrderedMap( of NoLess, int32 )      ' error 20 here, at the DIM
```

That is deliberate and is the difference from Array's Sort, which is a free procedure so that an Array of an unorderable T still works. An ordered map has no meaning without an ordering, so there is nothing to defer. src/tests/generics/fail-container-noorder.bas pins the diagnostic.

## The Tree

A red-black tree: a binary search tree in which every node is red or black, the root and every null child count as black, a red node has no red child, and every path from a node down to its descendant nulls holds the same number of black nodes. Those invariants bound the longest root-to-leaf path at twice the shortest, which is what makes the height O(log n) and every operation with it.

Chosen over an AVL tree because the rebalancing is cheaper on write -- at most two rotations for an insert and three for a removal, against AVL's O(log n) -- for a tree that is at most 2x rather than 1.44x the ideal height. A workload that would prefer the AVL trade is better served by Map anyway.

NODES CARRY PARENT POINTERS. That is what makes the iterator a plain successor walk with no stack of its own, so an iterator is one pointer and FOR EACH allocates nothing. It also keeps the removal rebalance readable.

Insertion colours the new node RED, which cannot break the equal-black-count invariant, only the no-red-child one -- which is why the insert fixup has just three cases and their mirrors. Removal is the harder half: the fixup has four cases per side and runs only when the node that left was black, because that is what changes a black count.

## Ownership AND Copying

Like LinkedList and unlike the array-backed containers, these hold RAW NODE POINTERS, so the destructor, the copy constructor and 'operator let' are all written out.

Copy and assignment are DEEP and rebuild the whole tree, node for node and colour for colour -- so a copy is STRUCTURALLY IDENTICAL to its original, not merely equal to it. Rebuilding by walking in order and re-inserting would give a legal tree with different shape. Pass them BYREF where the cost matters.

## Iterator Invalidation

An iterator holds a node pointer, so:

- INSERTING does not invalidate any iterator. It may rotate nodes into new

```freebasic
positions, but every node keeps its identity and the walk still reaches all
of them. Map cannot say this: any rehash invalidates everything.
```

- REMOVING a key invalidates an iterator standing on THAT key, and nothing

```freebasic
else.
```

Do not write through OrderedSet's iterator. Value( ) returns BYREF, matching Set, so 'for each byref x in s' compiles -- and assigning to x changes the key the tree is sorted by without moving the node. Remove and re-Add instead. The same hazard exists for Set, where it breaks the hash.

## Tests

generics/container-orderedmap.bas and container-orderedset.bas, vendored in tiko-lang at `tests/vendor/fbc-tests/generics/`.

Every declared member, every state, the indexer's insert-on-miss, deep copy and assignment independence in both directions, self-assignment, destructor balance with a counting type, four key types including one with '<' and no hash, both FOR EACH binding forms and the tuple destructuring view, and -- for the set -- all three algebra operations including every self-argument case.

Two things those suites do that a hash container's cannot:

- THE INVARIANTS ARE ASSERTED, via BlackHeight( ), after every destructive

```freebasic
phase. A tree that has lost its balance still answers every lookup
correctly and still iterates in order; it has merely degraded to a linked
list, and no functional test can see that. BlackHeight( ) returns -1 on a
red-red violation, on unequal black counts, or on a red root, and all three
detections were checked against hand-corrupted trees before being relied on.
```

- THE BALANCE CLAIM IS A TESTED CLAIM. 1,000 keys inserted in ascending order

```freebasic
-- the input a naive BST turns into a list -- must report a black height of
at most 20. A degenerate tree would report about 1,000.
```

The removal rebalance's four cases and their mirrors need specific tree shapes that no hand-written case reliably produces, so both suites end in a DIFFERENTIAL STRESS: 120 rounds x 1,500 random operations mirrored into Map or Set, with every answer compared, the invariants checked each round, and Floor/Ceiling cross-checked against a linear scan.

Under tiko: both files build and run with exit 0 and print `container-orderedmap: ok` and `container-orderedset: ok` -- invariant checks and differential stress included.

See also: [Map](Category-Map) (containers.Map( of TK, TV )), [Set](Category-Set) (containers.Set( of T )), [Sorting](Category-Sorting) (sorting an Array or a LinkedList instead).

<!-- finder:start -->

## API reference

Every entry, grouped by task. [Collections](Functions-Collections) lists them beside the rest of the area.

### Choose a container

| Function | What it does | From |
|---|---|---|
| [OrderedMap](Modern-OrderedMap-OrderedMap) | Holds key and value pairs kept sorted by key. | `std/containers` |

### Map: add and change

| Function | What it does | From |
|---|---|---|
| [OrderedMap.Put](Modern-OrderedMap-Put) | Stores a value under a key, replacing any old one; returns true if the key was new. | `std/containers` |
| [OrderedMap.Add](Modern-OrderedMap-Add) | Adds a key and value if the key is new; an existing value is left alone. | `std/containers` |
| [OrderedMap.Remove](Modern-OrderedMap-Remove) | Removes a key and its value; returns true if the key was there. | `std/containers` |
| [OrderedMap.Clear](Modern-OrderedMap-Clear) | Removes every entry. | `std/containers` |

### Map: look up

| Function | What it does | From |
|---|---|---|
| [OrderedMap.TryGet](Modern-OrderedMap-TryGet) | Copies the value for a key into a variable; returns false, adding nothing, if absent. | `std/containers` |
| [OrderedMap.Contains](Modern-OrderedMap-Contains) | Returns true if the key is present, without adding it. | `std/containers` |
| [OrderedMap.Count](Modern-OrderedMap-Count) | Returns the number of entries; reading an absent key with m[ k ] adds one. | `std/containers` |
| [OrderedMap.IsEmpty](Modern-OrderedMap-IsEmpty) | Returns true if the map has no entries. | `std/containers` |

### Map: list keys and values

| Function | What it does | From |
|---|---|---|
| [OrderedMap.Keys](Modern-OrderedMap-Keys) | Returns a copy of all the keys as an Array, already sorted. | `std/containers` |
| [OrderedMap.Values](Modern-OrderedMap-Values) | Returns a copy of all the values as an Array, in the order of their keys. | `std/containers` |
| [OrderedMap.Pairs](Modern-OrderedMap-Pairs) | Returns a view that lets for each (k, v) walk keys and values in key order. | `std/containers` |

### Find the first, last or nearest key

| Function | What it does | From |
|---|---|---|
| [OrderedMap.TryFirst](Modern-OrderedMap-TryFirst) | Copies the smallest key and its value into variables; returns false if the map is empty. | `std/containers` |
| [OrderedMap.TryLast](Modern-OrderedMap-TryLast) | Copies the largest key and its value into variables; returns false if the map is empty. | `std/containers` |
| [OrderedMap.TryFloor](Modern-OrderedMap-TryFloor) | Finds the largest key at or below a given one; returns false if there is none. | `std/containers` |
| [OrderedMap.TryCeiling](Modern-OrderedMap-TryCeiling) | Finds the smallest key at or above a given one; returns false if there is none. | `std/containers` |

### Walk a container step by step

| Function | What it does | From |
|---|---|---|
| [OrderedMap.GetIterator](Modern-OrderedMap-GetIterator) | Returns an iterator over the entries in ascending key order. | `std/containers` |
| [OrderedMapIterator](Modern-OrderedMap-OrderedMapIterator) | Holds a position in an OrderedMap, stepping in ascending key order. | `std/containers` |
| [OrderedMapPairView](Modern-OrderedMap-OrderedMapPairView) | Holds the view that OrderedMap.Pairs returns, for for each (k, v) to walk. | `std/containers` |
| [OrderedMapPairIter](Modern-OrderedMap-OrderedMapPairIter) | Holds a position in OrderedMap.Pairs, giving key and value as a tuple in key order. | `std/containers` |

### Check a container's internals

| Function | What it does | From |
|---|---|---|
| [OrderedMap.BlackHeight](Modern-OrderedMap-BlackHeight) | Returns the tree's black height, or -1 if its balancing rules are broken. | `std/containers` |

<!-- finder:end -->

---



---

[Home](Home) · [Keyword Index](Keyword-Index)
