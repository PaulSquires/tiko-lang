[Home](Home) › [All Categories](Categories) › **Map**

# Map

```freebasic
#import "std/containers"
using FB

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

## Why It Exists

FreeBASIC had no hash map. The available answer was a COM Scripting.Dictionary from the Windows Script Runtime:

```freebasic
Portability   Windows-only.  No dictionary on Linux or macOS builds.
Startup       CoInitialize / CoCreateInstance per instance.
Types         Every key and value becomes a VARIANT.
Errors        HRESULT, checked by hand.
Speed         Late-bound IDispatch dispatch per lookup.
```

Nobody reaches for OLE automation to get a hash table by preference.

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
FB.HashOf( k )       must resolve
k = k                must compare
EQUAL KEYS MUST PRODUCE EQUAL HASH CODES
```

The converse is not required -- two different keys may collide, and the map handles that. But equal keys that hash differently produce a map that LOSES DATA, which is why the invariant is stated in capitals.

Overloads are supplied for every built-in type: all integer types, both float types, pointers, string, zstring, wstring and ustring. Strings hash by CONTENT, so a string built at run time finds the literal it equals. A ustring hashes its CODE UNITS, so a USTRING \* N and a var-len ustring holding the same text agree. +0.0 and -0.0 hash the same, because they compare equal.

A user type is made usable as a key by RE-OPENING the namespace:

```freebasic
type PairKey
    as int32 a, b
end type

operator = ( byref x as PairKey, byref y as PairKey ) as boolean
    return (x.a = y.a) andalso (x.b = y.b)
end operator

namespace FB
    function HashOf overload ( byref k as PairKey ) as uint64
        return HashOf( k.a ) xor (HashOf( k.b ) shl 1)
    end function
end namespace
```

Derive the hash only from the fields '=' compares, or equal keys will hash differently.

A key type with no overload fails at the INSTANTIATION site:

```freebasic
error 99: No matching overloaded function, HASHOF()
  in instantiation of 'Map( of NOHASH, long )'
```

That is what unconstrained generics can offer today, and it is the strongest single argument for adding constraints later.

Why an overloaded function rather than a HashCode( ) member: a member cannot be added to 'long' or 'string', and a generic body cannot branch on its type parameter -- 'typeof( T )' inside a generic sees the parameter, not what it is bound to. Ordinary overload resolution at the instantiation site is the mechanism that works.

Source: src/inc/fb/hash.bi

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

Pairs( ) is a second view over the same slots whose iterator yields a TUPLE, (TK, TV), which is what the destructuring form requires; iterating the map directly still yields a KeyValuePair. Two spellings rather than one because FreeBASIC CANNOT OVERLOAD ON THE RETURN TYPE ALONE -- the parser picks an overload bottom-up, before any expected type is known -- so MapIterator.Value( ) has to return one thing or the other, and changing it would break every kv.key / kv.value site.

The view BORROWS the map. It does not own it, must not outlive it, and is invalidated by exactly what invalidates any map iterator (below). Writing to k or v changes nothing, for the same reason writing to kv.value does not.

Cost: the tuple copies the key and the value a second time, on top of the copy the KeyValuePair already makes. For a Map( of string, ... ) that is two string copies per iteration rather than one.

See docs/tuples/RFC-0003-destructuring.md.

ITERATION ORDER IS UNSPECIFIED and changes across insertions. It is not randomised per process -- that is a hash-flooding defence FreeBASIC has no threat model for, and stability within one unmodified map is more useful when debugging.

If you need the keys in order, FB.OrderedMap is the same interface over a red-black tree -- O(log n) instead of O(1), always sorted, and needing only '<' rather than a hash. See docs/ordered/ordered.txt.

Keys( ) and Values( ) are SNAPSHOTS, returned as Array( of K ) and Array( of V ). Changing them does not change the map.

## Implementation

Open addressing with linear probing, power-of-two capacity, tombstones on removal, load factor 0.75, rehash doubles.

Open addressing is chosen over chaining for one allocation instead of one per entry, which matters more in a language with no garbage collector and with direct memory access. The cost is tombstones and worse behaviour at high load factors, both bounded by the load factor.

Removal leaves a TOMBSTONE rather than an empty slot. Probing stops at the first EMPTY slot, so blanking a slot would cut the probe chain and hide every key that had collided past it. Rehashing drops every tombstone, which is what stops an add/remove churn loop from filling the table with them.

Source: src/inc/fb/map.bi

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

src/tests/generics/container-map.bas is exhaustive: every member, empty / one / many states, the four readers and writers pinned against each other, the growth path, tombstones and churn, deep copy and assignment independence in both directions, destructor balance with a counting value type, key types including integers, doubles (with the +0.0 / -0.0 case), strings and a user type with its own HashOf, a value type that is itself a container, FOR EACH, and FOR EACH over Pairs( ) -- per-name types, writes not reaching the map, exit/continue, a removed entry, nesting, an empty map, a counting value type, and iteration after the rehashes 100 insertions force.

Complexity is ASSERTED, not assumed: 100k insertions must respect the 0.75 load factor, overwriting all 100k must not grow the table at all, and a 200-round add/remove churn must not let tombstones grow the capacity.

src/tests/generics/fail-container-nohash.bas pins the missing-HashOf diagnostic.

## API reference

One page per entry, 14 in all:

[Add](Modern-Map-Add) · [Capacity](Modern-Map-Capacity) · [Clear](Modern-Map-Clear) · [Contains](Modern-Map-Contains) · [Count](Modern-Map-Count) · [GetIterator](Modern-Map-GetIterator) · [IsEmpty](Modern-Map-IsEmpty) · [Keys](Modern-Map-Keys) · [Map](Modern-Map-Map) · [MapIterator](Modern-Map-MapIterator) · [MapPairIter](Modern-Map-MapPairIter) · [MapPairView](Modern-Map-MapPairView) · [Pairs](Modern-Map-Pairs) · [Put](Modern-Map-Put) · [Remove](Modern-Map-Remove) · [Reserve](Modern-Map-Reserve) · [TryGet](Modern-Map-TryGet) · [Values](Modern-Map-Values)

---

**Source:** `docs/map/map.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)
