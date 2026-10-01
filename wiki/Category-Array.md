[Home](Home) › [All Categories](Categories) › **Array**

# Array

```freebasic
#import "std/containers"
using FB

dim v as Array( of ustring )

v.Push( "ada" )
v.Push( "grace" )
v.Insert( 0, "hopper" )

print v.Count( )                     ' 3
print v[ 1 ]                         ' "ada"

for each name in v
    print name
next
```

A brace list fills one at the declaration: `dim v as Array( of ustring ) = { "ada", "grace" }` calls `Push` once per element. See [Collection Initializers](Category-Collection-Initializers).

## Why It Exists

FreeBASIC had no growable array. What existed was 'redim preserve', which reallocates and copies on EVERY call, so the idiomatic append is quadratic:

```freebasic
redim preserve arr( 0 to ubound( arr ) + 1 )     ' O(n^2) over a loop
arr( ubound( arr ) ) = newItem
```

Array keeps a capacity separately from a count and only reallocates when the capacity doubles, which makes the append amortised O(1).

## Indices Are ZERO-BASED

A deliberate break with 'dim arr(1 to 10)' BASIC tradition. Count and index arithmetic are otherwise a permanent source of off-by-one, and every other language's growable array is zero-based. Stated loudly rather than hidden.

## Members

```freebasic
Count( ) as int32                         O(1)
Capacity( ) as int32                      O(1)
IsEmpty( ) as boolean                     O(1)

a[ i ]                                    O(1)   byref, and an lvalue
At( i ) byref as T                        O(1)   byref; see the note below

Push( byref v as T )                      amortised O(1)
Pop( ) as T                               O(1)   removes and returns the last
Insert( byval i as int32, byref v as T )   O(n)
Remove( byval i as int32 )                 O(n)   preserves order
RemoveSwap( byval i as int32 )             O(1)   does NOT preserve order
Clear( )                                  O(n)   drops elements, KEEPS capacity
Reserve( byval n as int32 )                O(n)   grow to at least n
Shrink( )                                 O(n)   release unused capacity
GetIterator( ) as ArrayIterator( of T )   O(1)
```

and two FREE PROCEDURES, not members:

```freebasic
IndexOf( a, v ) as int32                  needs '=' on T; -1 if absent
Contains( a, v ) as boolean               needs '=' on T
```

Sorting is in fb/sort.bi, documented in docs/sort/sort.txt.

## At( ) IS FOR READING

'a.At( 1 ) = 11' does NOT assign. It parses as an equality expression and warns:

```freebasic
warning 34(1): '=' parsed as equality operator in function argument,
               not assignment to BYREF function result
```

That is a FreeBASIC rule about byref function results, not something this container can fix. At( ) is for reading and for passing byref; use a\[ 1 \] = 11 to write.

## WHY Sort, IndexOf AND Contains ARE NOT MEMBERS

Not a style choice. Every member of a generic is instantiated whether it is called or not, so a member needing '=' on T would make the WHOLE TYPE unusable for any T without one:

```freebasic
array.bi(224) error 20: Type mismatch
  in instantiation of 'Array( of Array( of long ) )'
```

A generic procedure is instantiated only where it is called, so the requirement lands on the call that actually needs it, and an Array of anything at all can still be built. T is inferred from the nested Array( of T ) argument.

One consequence of strict type-argument inference: an untyped literal is an INTEGER, so this cannot infer T --

```freebasic
IndexOf( nums, 3 )       ' nums is an Array( of long ): long vs integer
```

-- and must be written IndexOf( nums, 3L ), or with a variable of the element type. Inference never converts; that is deliberate.

## Growth

Capacity doubles from 8 on the first push. Doubling is what makes the append amortised O(1); 1.5x would waste less and is not worth the arithmetic.

Capacity NEVER shrinks on its own, because a push/pop loop sitting on a capacity boundary would otherwise thrash. Shrink( ) is explicit.

Clear( ) drops the elements but KEEPS the capacity, so a clear-and-refill loop does not reallocate. It also resets each slot, so a T holding a resource -- a string, another container -- releases it now rather than at the array's destruction.

```freebasic
dim a as Array( of int32 )
a.Reserve( 1000 )        ' one allocation, no reallocation for 1000 pushes
```

## Sorting

```freebasic
#import "std/containers"

Sort( a )                   introsort, ascending, by '<' on T
SortBy( a, less )           introsort, ascending, by a comparer
StableSort( a )             merge sort -- equal elements keep their order
StableSortBy( a, less )
IsSorted( a )               / IsSortedBy( a, less )
```

Sort( ) is an introsort: quicksort, falling back to heapsort at a recursion depth of 2\*floor(log2 n) and to insertion sort below sixteen elements. O(n log n) worst case, in place, not stable. StableSort( ) is a bottom-up merge sort: O(n log n), stable, and needs an n-element scratch buffer.

Both move elements with SWAP, so a T holding a heap allocation is never copied.

Sorting used to be a Shell sort declared here in fb/array.bi. It moved to its own header when it grew a comparer, a stable form and a LinkedList form; see docs/sort/sort.txt. A program that includes only fb/array.bi now has to include fb/sort.bi as well -- containers.bi pulls in both.

## Ownership AND Copying

The array owns its storage and cleans it up in its destructor.

COPY AND ASSIGNMENT ARE DEEP. 'dim b = a' copies every element, invoking T's copy constructor; assignment destroys the old contents and deep-copies. That is the only rule consistent with FreeBASIC's value semantics for UDTs, and it is expensive -- there is no move constructor in the language to avoid it. Pass containers BYREF where it matters.

Containers of containers work: Array( of Array( of long ) ) copies correctly, because the inner array's copy constructor does the right thing.

An Array( of T ptr ) frees the ARRAY, not the pointees. There are no smart pointers.

## Iterator Invalidation

Nothing detects a violation.

```freebasic
Push causing reallocation                   all iterators invalidated
Insert, Remove, RemoveSwap, Clear,
Reserve, Shrink, Sort                       all iterators invalidated
assignment through [ ]                      iterators stay valid

for each byref v in a
    v *= 2                                  ' fine: element assignment
    a.Push( v )                             ' NOT fine: may reallocate
next
```

## Implementation

The elements live in an ordinary FreeBASIC dynamic array field, redim'd only when the capacity doubles. That lets the language do element construction, copying and destruction, so the deep copy, the assignment and the destructor all fall out for free and there is no manual memory to get wrong.

RFC-0004 rejects "wrap the existing redim array" because it would inherit the O(n^2) append -- but that objection is about redim'ing per append, not about the storage.

Source: src/inc/fb/array.bi

## Tests

src/tests/generics/container-array.bas is exhaustive: every member, empty / one / many states, boundary indices including one-past-the-end and negative, the growth path, every removal form followed by re-insertion, deep copy and assignment independence in both directions, destructor balance with a counting element type, element types including strings, a UDT and a nested container, and both FOR EACH binding forms.

Complexity is ASSERTED, not assumed: 100k pushes must produce at most 20 reallocations (log2(100000/8)+1 = 15) and a final capacity under 2n. That is what "amortised O(1) append" means.

src/tests/generics/fail-container-nosort.bas and fail-container-noequals.bas pin the diagnostics for an element type without '<' or '='.

## API reference

One page per entry, 21 in all:

[Array](Modern-Array-Array) · [ArrayIterator](Modern-Array-ArrayIterator) · [At](Modern-Array-At) · [Capacity](Modern-Array-Capacity) · [Clear](Modern-Array-Clear) · [Contains](Modern-Array-Contains) · [Count](Modern-Array-Count) · [ForEach](Modern-Array-ForEach) · [GetIterator](Modern-Array-GetIterator) · [IndexOf](Modern-Array-IndexOf) · [Insert](Modern-Array-Insert) · [IsEmpty](Modern-Array-IsEmpty) · [IsSorted](Modern-Array-IsSorted) · [Pop](Modern-Array-Pop) · [Push](Modern-Array-Push) · [Remove](Modern-Array-Remove) · [RemoveSwap](Modern-Array-RemoveSwap) · [Reserve](Modern-Array-Reserve) · [Shrink](Modern-Array-Shrink) · [Sort](Modern-Array-Sort) · [SortBy](Modern-Array-SortBy) · [StableSort](Modern-Array-StableSort) · [StableSortBy](Modern-Array-StableSortBy)

---

**Source:** `docs/array/array.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)
