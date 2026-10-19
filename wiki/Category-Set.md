[Home](Home) › [All Categories](Categories) › **Set**

# Set

A **set** is a collection that holds each value at most once. You can add a value, take one out, and ask whether a value is in it -- that is what a set is for. Adding a value that is already there changes nothing, so a set never holds duplicates.

Think of a guest list at a door: a name is either on the list or it is not, and writing it down a second time does not let that person in twice. The list has no meaningful order either; what matters is who is on it.

That makes a set the right tool for questions like *have I seen this before?* and *which distinct values are there?* A `Set` keeps its elements in a hash table, so adding, removing and checking take about the same time however many elements it holds.

The elements can be any built-in type -- numbers, strings -- or a type of your own that extends `containers.Hashable` (see [The Hash Contract](#the-hash-contract)). The order a set hands its elements back in is not defined; if you need them sorted, use [OrderedSet](Category-OrderedSet).

The example below remembers which numbers it has already seen:

```freebasic
#import "std/containers"
using containers

dim seen as Set( of int32 )

if seen.Add( 42 ) then print "first time"

for each x in seen
    print x
next
```

Add returns FALSE when the element was already present, which is what makes

```freebasic
if seen.Add( x ) then ...
```

the natural spelling of "process each thing once".

## Members

```freebasic
Count( ) as int32                         O(1)
IsEmpty( ) as boolean                     O(1)
Capacity( ) as int32                      O(1)

Add( byref v as T ) as boolean            avg O(1)  FALSE if already present
Contains( byref v as T ) as boolean       avg O(1)
Remove( byref v as T ) as boolean         avg O(1)  TRUE if something went

Clear( )                                  O(n)
Reserve( byval n as int32 )                O(n)

UnionWith( byref other as Set( of T ) )        O(|other|)
IntersectWith( byref other as Set( of T ) )    O(n)
ExceptWith( byref other as Set( of T ) )       O(|other|)

Items( ) as Array( of T )                 O(n)      snapshot
GetIterator( ) as SetIterator( of T )     O(1)
```

The three set operations modify the receiver in place and leave the operand untouched:

```freebasic
dim a as Set( of int32 )      ' { 1, 2, 3, 4, 5 }
dim b as Set( of int32 )      ' { 4, 5, 6, 7, 8 }

dim u as Set( of int32 ) = a
u.UnionWith( b )             ' { 1..8 }, a unchanged

dim n as Set( of int32 ) = a
n.IntersectWith( b )         ' { 4, 5 }

dim e as Set( of int32 ) = a
e.ExceptWith( b )            ' { 1, 2, 3 }
```

IntersectWith collects the doomed elements first and removes them afterwards. Removing while walking the set's own slots would leave tombstones in the middle of a chain being probed.

## The Hash Contract

An element type T must satisfy:

```freebasic
T extends containers.Hashable, or is a built-in type
v = v                must compare
EQUAL ELEMENTS MUST PRODUCE EQUAL HASH CODES
```

The converse is not required. Overloads are supplied for every built-in type; strings hash by CONTENT, and +0.0 / -0.0 hash the same because they compare equal.

A user type is made usable by EXTENDING containers.Hashable and overriding its abstract HashOf( ) member:

```freebasic
#import "std/containers"
using containers

type Tag extends Hashable
    as int32 id
    declare function HashOf( ) as ulongint override
end type

function Tag.HashOf( ) as ulongint
    return containers.HashOf( id )
end function

operator = ( byref x as Tag, byref y as Tag ) as boolean
    return x.id = y.id
end operator
```

Derive the hash only from the fields '=' compares.

An element type that is neither fails when Set is instantiated, naming HashOf inside the module:

```freebasic
...\pkg\std\containers\set.tiko(89,35): error TKO0632: no overload of 'hashof' matches these arguments
```

Source: pkg/std/containers/hash.tiko

## Do NOT Modify An Element In Place

The iterator's Value( ) is byref, so 'for each byref' compiles:

```freebasic
for each byref x in seen
    x += 1                   ' DON'T
next
```

Changing an element changes its hash, and it can never be found again -- it still occupies a slot, Count( ) still counts it, and Contains( ) returns false for both the old value and the new one. Remove and re-Add instead.

The byref binding is allowed rather than blocked because the container cannot tell a harmless read-through from a mutation, and blocking it would also block passing an element byref to a function.

## Iteration

ITERATION ORDER IS UNSPECIFIED and changes across insertions. It is not randomised per process.

If you need the elements in order, containers.OrderedSet is the same interface over a red-black tree -- O(log n) instead of O(1), always sorted, and needing only '<' rather than a hash. See [OrderedSet](Category-OrderedSet).

Items( ) is a SNAPSHOT, returned as Array( of T ). Changing it does not change the set -- which is the safe way to remove while "iterating":

```freebasic
dim all as Array( of int32 ) = s.Items( )
for i as int32 = 0 to all.Count( )-1
    if unwanted( all[ i ] ) then s.Remove( all[ i ] )
next
```

## Implementation

A Map with the value machinery removed rather than a wrapper around one, so a Set costs ONE slot per element instead of two.

Open addressing with linear probing, power-of-two capacity, tombstones on removal, load factor 0.75, rehash doubles. Removal leaves a tombstone rather than an empty slot, because probing stops at the first EMPTY slot and blanking would cut the chain. Rehashing drops tombstones, which is what stops an add/remove churn loop from filling the table with them.

Source: pkg/std/containers/set.tiko

## Ownership AND Copying

The set owns its storage. COPY AND ASSIGNMENT ARE DEEP. That is expensive and there is no move constructor in the language to avoid it; pass sets BYREF where it matters. A Set( of T ptr ) frees the TABLE, not the pointees.

## Iterator Invalidation

Nothing detects a violation.

```freebasic
Add causing a rehash                        all iterators invalidated
Remove                                      all iterators invalidated
```

Use Items( ) to take a snapshot if you need to mutate while walking.

## Tests

src/tests/generics/container-set.bas is exhaustive: every member, empty / one / many states, Add's novelty return, removal and tombstones, churn, the growth path, all three set operations including every degenerate case (empty operand, empty receiver, with itself, disjoint), the Items snapshot, FOR EACH in both binding forms, element types including strings (with the empty string and a run-time-built string), doubles with +0.0 / -0.0, and a user type with its own HashOf, deep copy and assignment independence in both directions, and destructor balance with a counting element type.

Complexity is ASSERTED, not assumed: 100k insertions must respect the 0.75 load factor, re-adding all 100k must not grow the table at all, and a 200-round add/remove churn must not let tombstones grow the capacity.

src/tests/generics/fail-container-nohash-set.bas pins the missing-HashOf diagnostic.

<!-- finder:start -->

## API reference

Every entry, grouped by task. [Collections](Functions-Collections) lists them beside the rest of the area.

### Choose a container

| Function | What it does | From |
|---|---|---|
| [Set](Modern-Set-Set) | Holds each value at most once, in no particular order. | `std/containers` |

### Set: add, remove and test

| Function | What it does | From |
|---|---|---|
| [Set.Add](Modern-Set-Add) | Adds a value; returns false if it was already there. | `std/containers` |
| [Set.Remove](Modern-Set-Remove) | Removes a value; returns true if it was there. | `std/containers` |
| [Set.Contains](Modern-Set-Contains) | Returns true if the value is in the set. | `std/containers` |
| [Set.Count](Modern-Set-Count) | Returns the number of values in the set. | `std/containers` |
| [Set.IsEmpty](Modern-Set-IsEmpty) | Returns true if the set has no values. | `std/containers` |
| [Set.Clear](Modern-Set-Clear) | Removes every value. | `std/containers` |
| [Set.Items](Modern-Set-Items) | Returns a copy of all the values as an Array, in no particular order. | `std/containers` |

### Combine sets

| Function | What it does | From |
|---|---|---|
| [Set.UnionWith](Modern-Set-UnionWith) | Adds every value of another set to this one; the other set is unchanged. | `std/containers` |
| [Set.IntersectWith](Modern-Set-IntersectWith) | Keeps only the values that are also in another set. | `std/containers` |
| [Set.ExceptWith](Modern-Set-ExceptWith) | Removes every value that is also in another set. | `std/containers` |

### Walk a container step by step

| Function | What it does | From |
|---|---|---|
| [Set.GetIterator](Modern-Set-GetIterator) | Returns an iterator over the values, in no particular order. | `std/containers` |
| [SetIterator](Modern-Set-SetIterator) | Holds a position in a Set; changing a value through it loses that value. | `std/containers` |

### Reserve room ahead of time

| Function | What it does | From |
|---|---|---|
| [Set.Capacity](Modern-Set-Capacity) | Returns the number of slots in the table, always a power of two. | `std/containers` |
| [Set.Reserve](Modern-Set-Reserve) | Makes room for n values, so filling the set does not have to regrow it. | `std/containers` |

<!-- finder:end -->

---



---

[Home](Home) · [Keyword Index](Keyword-Index)
