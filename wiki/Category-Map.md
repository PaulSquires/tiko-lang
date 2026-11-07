[Home](Home) › [All Categories](Categories) › **Map**

# Map

A **map** -- also called a dictionary -- stores pairs: a **key**, and the **value** that goes with it. You find a value by its key, not by a position number. Each key appears at most once: `Put` replaces the value already stored under a key, and `Add` leaves it alone.

Think of a phone book: you look up a name, the key, to find a number, the value. Every name is listed once, and nobody asks for "entry 37" -- you ask for "Ada".

That makes a map the right tool whenever the question is *what goes with this?* -- an age by name, a count per word, a setting by its name. A `Map` keeps its entries in a hash table, so storing, finding and removing take about the same time however many entries it holds.

Keys can be any built-in type -- numbers, strings -- or a type of your own that extends `containers.Hashable` (see [The Hash Contract](#the-hash-contract)). Values can be numbers, strings or your own types. The order a map hands its entries back in is not defined; if you need them sorted by key, use [OrderedMap](Category-OrderedMap).

The example below stores ages by name:

```freebasic
#import "std/containers"
using containers

dim ages as Map( of ustring, int32 )

ages.Put( "ada", 36 )
ages.Add( "grace", 85 )

if ages.Contains( "ada" ) then print ages[ "ada" ]

dim n as int32
if ages.TryGet( "edsger", n ) then print n

for each kv in ages
    print kv.key, kv.value
next
```

A brace list fills one at the declaration: `dim m as Map( of ustring, long ) = { {"a", 1}, {"b", 2} }` calls `Add( "a", 1 )` and `Add( "b", 2 )`. See [Collection Initializers](Category-Collection-Initializers).

## READING vs WRITING -- READ THIS FIRST

```freebasic
m[ k ]        INSERTS a default-constructed V if k is absent
m.TryGet      does not
m.Contains    does not
```

The indexer inserting on a miss is what makes the counting idiom work:

```freebasic
counts[ word ] += 1                  ' just works
```

and it is a trap when used to read:

```freebasic
if m[ "missing" ] = 0 then ...       ' silently GREW the map
```

Use TryGet or Contains to read. Every dictionary API in every language has this argument and none has won it; C# splits it the same way, and C++'s operator\[\]-inserts versus at()-throws is the same problem with a worse answer.

## Members

```freebasic
Count( ) as int32                         O(1)
IsEmpty( ) as boolean                     O(1)
Capacity( ) as int32                      O(1)

m[ k ] byref as V                         avg O(1)  lvalue, INSERTS ON MISS
Add( k, v ) as boolean                    avg O(1)  false if present;
                                                    does NOT overwrite
Put( k, v ) as boolean                    avg O(1)  insert or overwrite;
                                                    true if the key was new
TryGet( k, byref out as V ) as boolean    avg O(1)  no insertion on a miss
Contains( k ) as boolean                  avg O(1)  no insertion
Remove( k ) as boolean                    avg O(1)  true if something went

Clear( )                                  O(n)
Reserve( byval n as int32 )                O(n)
Keys( ) as Array( of K )                  O(n)      snapshot
Values( ) as Array( of V )                O(n)      snapshot
GetIterator( ) as MapIterator( of K, V )  O(1)
Pairs( ) as MapPairView( of K, V )        O(1)      tuple-yielding view,
                                                    for 'for each (k, v)'
```

Add versus Put is the other half of the distinction above:

```freebasic
m.Add( "ada", 36 )       ' true  -- inserted
m.Add( "ada", 99 )       ' false -- already there, value UNCHANGED
m.Put( "ada", 99 )       ' false -- key existed, value now 99
```

## The Hash Contract

A key type K must satisfy:

```freebasic
K extends containers.Hashable, or is a built-in type
k = k                must compare
EQUAL KEYS MUST PRODUCE EQUAL HASH CODES
```

The converse is not required -- two different keys may collide, and the map handles that. But equal keys that hash differently produce a map that LOSES DATA, which is why the invariant is stated in capitals.

Overloads are supplied for every built-in type: all integer types, both float types, pointers, string, zstring, wstring and ustring. Strings hash by CONTENT, so a string built at run time finds the literal it equals. A ustring hashes its CODE UNITS, so a USTRING \* N and a var-len ustring holding the same text agree. +0.0 and -0.0 hash the same, because they compare equal.

A user type is made usable as a key by EXTENDING containers.Hashable and overriding its abstract HashOf( ) member:

```freebasic
#import "std/containers"
using containers

type PairKey extends Hashable
    as int32 a, b
    declare function HashOf( ) as ulongint override
end type

function PairKey.HashOf( ) as ulongint
    return containers.HashInt( containers.HashOf( a ) ) xor containers.HashOf( b )
end function

operator = ( byref x as PairKey, byref y as PairKey ) as boolean
    return (x.a = y.a) andalso (x.b = y.b)
end operator
```

Derive the hash only from the fields '=' compares, or equal keys will hash differently.

Combine field hashes by passing all but one through containers.HashInt, a 64-bit mixer. The integer overloads return the value itself -- the map does its own spreading, with a multiplicative step when it picks a slot -- so a plain 'HashOf( a ) xor ( HashOf( b ) shl 1 )' gives ( 2, 0 ) and ( 0, 1 ) the same hash. That is still correct, since the map compares keys with '=', but every such pair shares a probe chain.

A key type that is neither fails when Map is instantiated, naming HashOf inside the module:

```freebasic
...\pkg\std\containers\map.tiko(144,35): error TKO0632: no overload of 'hashof' matches these arguments
```

That is what a generic can say when its requirement is an overloaded procedure: a constraint names an interface, and `HashOf` is not one.

Why an overloaded function rather than a HashCode( ) member: a member cannot be added to 'long' or 'string', and a generic body cannot branch on its type parameter -- 'typeof( T )' inside a generic sees the parameter, not what it is bound to. Ordinary overload resolution at the instantiation site is the mechanism that works. A USER type does carry a member, through Hashable, because a module's namespace cannot be re-opened and an overload declared in the importing program is invisible to Map's body, which belongs to the module.

Source: pkg/std/containers/hash.tiko

## Iteration

```freebasic
for each kv in ages
    print kv.key, kv.value
next
```

Iteration yields a KeyValuePair( of K, V ) -- a pair, read through kv.key and kv.value.

The pair is ASSEMBLED BY THE ITERATOR and does not live in the map, so writing to it changes nothing. Use m\[ k \] to write.

To DESTRUCTURE into two loop variables instead, iterate Pairs( ):

```freebasic
for each (k, v) in ages.Pairs( )
    print k, v
next
```

k and v each have their own type -- ustring and long here, not a pair and not each other.

Pairs( ) is a second view over the same slots whose iterator yields a TUPLE, (TK, TV), which is what the destructuring form requires; iterating the map directly still yields a KeyValuePair. Two spellings rather than one because tiko CANNOT OVERLOAD ON THE RETURN TYPE ALONE -- the parser picks an overload bottom-up, before any expected type is known -- so MapIterator.Value( ) has to return one thing or the other, and changing it would break every kv.key / kv.value site.

The view BORROWS the map. It does not own it, must not outlive it, and is invalidated by exactly what invalidates any map iterator (below). Writing to k or v changes nothing, for the same reason writing to kv.value does not.

Cost: the tuple copies the key and the value a second time, on top of the copy the KeyValuePair already makes. For a Map( of string, ... ) that is two string copies per iteration rather than one.

ITERATION ORDER IS UNSPECIFIED and changes across insertions. It is not randomised per process -- that is a hash-flooding defence tiko has no threat model for, and stability within one unmodified map is more useful when debugging.

If you need the keys in order, containers.OrderedMap is the same interface over a red-black tree -- O(log n) instead of O(1), always sorted, and needing only '<' rather than a hash. See [OrderedMap](Category-OrderedMap).

Keys( ) and Values( ) are SNAPSHOTS, returned as Array( of K ) and Array( of V ). Changing them does not change the map.

## Implementation

Open addressing with linear probing, power-of-two capacity, tombstones on removal, load factor 0.75, rehash doubles.

Open addressing is chosen over chaining for one allocation instead of one per entry, which matters more in a language with no garbage collector and with direct memory access. The cost is tombstones and worse behaviour at high load factors, both bounded by the load factor.

Removal leaves a TOMBSTONE rather than an empty slot. Probing stops at the first EMPTY slot, so blanking a slot would cut the probe chain and hide every key that had collided past it. Rehashing drops every tombstone, which is what stops an add/remove churn loop from filling the table with them.

Source: pkg/std/containers/map.tiko

## Ownership AND Copying

The map owns its storage. COPY AND ASSIGNMENT ARE DEEP -- 'dim b = a' copies every key and value. That is expensive and there is no move constructor in the language to avoid it; pass maps BYREF where it matters.

A Map( of K, V ptr ) frees the TABLE, not the pointees.

## Iterator Invalidation

Nothing detects a violation.

```freebasic
Add or Put causing a rehash                 all iterators invalidated
Remove                                      all iterators invalidated
```

Both the indexer and Put can rehash, so do not insert while iterating. Collect first, then mutate:

```freebasic
dim doomed as Array( of ustring )
for each kv in m
    if kv.value = 0 then doomed.Push( kv.key )
next
for i as int32 = 0 to doomed.Count( )-1
    m.Remove( doomed[ i ] )
next
```

## Tests

generics/container-map.bas is exhaustive: every member, empty / one / many states, the four readers and writers pinned against each other, the growth path, tombstones and churn, deep copy and assignment independence in both directions, destructor balance with a counting value type, key types including integers, doubles (with the +0.0 / -0.0 case), strings and a user type with its own HashOf, a value type that is itself a container, FOR EACH, and FOR EACH over Pairs( ) -- per-name types, writes not reaching the map, exit/continue, a removed entry, nesting, an empty map, a counting value type, and iteration after the rehashes 100 insertions force.

Complexity is ASSERTED, not assumed: 100k insertions must respect the 0.75 load factor, overwriting all 100k must not grow the table at all, and a 200-round add/remove churn must not let tombstones grow the capacity.

generics/fail-container-nohash.bas pins the missing-HashOf diagnostic.

<!-- finder:start -->

## API reference

Every entry, grouped by task. [Collections](Functions-Collections) lists them beside the rest of the area.

### Choose a container

| Function | What it does | From |
|---|---|---|
| [Map](Modern-Map-Map) | Holds key and value pairs in a hash table, so you find a value by its key. | `std/containers` |

### Map: add and change

| Function | What it does | From |
|---|---|---|
| [Map.Put](Modern-Map-Put) | Stores a value under a key, replacing any old one; returns true if the key was new. | `std/containers` |
| [Map.Add](Modern-Map-Add) | Adds a key and value if the key is new; an existing value is left alone. | `std/containers` |
| [Map.Remove](Modern-Map-Remove) | Removes a key and its value; returns true if the key was there. | `std/containers` |
| [Map.Clear](Modern-Map-Clear) | Removes every entry. | `std/containers` |

### Map: look up

| Function | What it does | From |
|---|---|---|
| [Map.TryGet](Modern-Map-TryGet) | Copies the value for a key into a variable; returns false, adding nothing, if absent. | `std/containers` |
| [Map.Contains](Modern-Map-Contains) | Returns true if the key is present, without adding it. | `std/containers` |
| [Map.Count](Modern-Map-Count) | Returns the number of entries; reading an absent key with m[ k ] adds one. | `std/containers` |
| [Map.IsEmpty](Modern-Map-IsEmpty) | Returns true if the map has no entries. | `std/containers` |

### Map: list keys and values

| Function | What it does | From |
|---|---|---|
| [Map.Keys](Modern-Map-Keys) | Returns a copy of all the keys as an Array, in no particular order. | `std/containers` |
| [Map.Values](Modern-Map-Values) | Returns a copy of all the values as an Array, in no particular order. | `std/containers` |
| [Map.Pairs](Modern-Map-Pairs) | Returns a view that lets for each (k, v) give each key and value as two variables. | `std/containers` |

### Walk a container step by step

| Function | What it does | From |
|---|---|---|
| [Map.GetIterator](Modern-Map-GetIterator) | Returns an iterator over the entries, each a pair read through .key and .value. | `std/containers` |
| [MapIterator](Modern-Map-MapIterator) | Holds a position in a Map; each step gives a pair read through .key and .value. | `std/containers` |
| [MapPairView](Modern-Map-MapPairView) | Holds the view that Map.Pairs returns, for for each (k, v) to walk. | `std/containers` |
| [MapPairIter](Modern-Map-MapPairIter) | Holds a position in Map.Pairs; each step gives the key and value as a tuple. | `std/containers` |

### Reserve room ahead of time

| Function | What it does | From |
|---|---|---|
| [Map.Capacity](Modern-Map-Capacity) | Returns the number of slots in the table, always a power of two. | `std/containers` |
| [Map.Reserve](Modern-Map-Reserve) | Makes room for n entries, so filling the map does not have to regrow it. | `std/containers` |

<!-- finder:end -->

---



---

[Home](Home) · [Keyword Index](Keyword-Index)
