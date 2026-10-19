[Home](Home) › [All Categories](Categories) › **Array**

# Array

An **Array** is a list of values kept in order, one after another, that you reach by position: the first element is `v[ 0 ]`, the second `v[ 1 ]`, and so on. It **grows** as you use it -- `Push` adds a value at the end and `Insert` puts one anywhere -- and it finds the room itself, so you never have to say up front how many elements there will be.

Think of a numbered list on a page: every line has a number, you can read line 3 directly, and you can keep adding lines at the bottom.

That makes Array the container to reach for first whenever you need things in order. Reading or changing an element by its position is instant, and adding at the end is quick. Inserting or removing near the front of a long Array is slower, because everything after that point moves along by one; if your program does that a lot, a [LinkedList](Category-LinkedList) may suit it better.

Every element has the same type: an `Array( of ustring )` holds strings, an `Array( of int32 )` holds numbers.

The example below builds a list of three names, reads one back by its position, and prints them all:

```freebasic
#import "std/containers"
using containers

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

'redim preserve' reallocates and copies on EVERY call, so appending with it is quadratic:

```freebasic
redim preserve arr( 0 to ubound( arr ) + 1 )     ' O(n^2) over a loop
arr( ubound( arr ) ) = newItem
```

Array keeps a capacity separately from a count and only reallocates when the capacity doubles, which makes the append amortised O(1).

## Indices Are ZERO-BASED

Array indices start at zero, deliberately. Count and index arithmetic are otherwise a permanent source of off-by-one, and every other language's growable array is zero-based. Stated loudly rather than hidden.

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

Sorting is in sort.tiko, in the same std/containers module, documented under [Sorting](Category-Sorting).

## At( ) IS FOR READING

'a.At( 1 ) = 11' does NOT assign. It parses as an equality expression and warns:

```text
warning TKO0931: '=' is read as a comparison inside the argument of 'at', not as an
assignment to its byref result; to assign, write '( at( ... ) ) = value'
```

That is a language rule about byref function results, not something this container can fix. At( ) is for reading and for passing byref; use a\[ 1 \] = 11 to write, or wrap the call in parentheses: '( a.At( 1 ) ) = 11'.

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

Sorting is in its own file, with a comparer, a stable form and a LinkedList form; see [Sorting](Category-Sorting). Both files are std/containers, so '#import "std/containers"' brings in both.

## Ownership AND Copying

The array owns its storage and cleans it up in its destructor.

COPY AND ASSIGNMENT ARE DEEP. 'dim b = a' copies every element, invoking T's copy constructor; assignment destroys the old contents and deep-copies. That is the only rule consistent with tiko's value semantics for UDTs, and it is expensive -- there is no move constructor in the language to avoid it. Pass containers BYREF where it matters.

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

The elements live in an ordinary dynamic array field, redim'd only when the capacity doubles. That lets the language do element construction, copying and destruction, so the deep copy, the assignment and the destructor all fall out for free and there is no manual memory to get wrong.

Source: pkg/std/containers/array.tiko

## Tests

src/tests/generics/container-array.bas is exhaustive: every member, empty / one / many states, boundary indices including one-past-the-end and negative, the growth path, every removal form followed by re-insertion, deep copy and assignment independence in both directions, destructor balance with a counting element type, element types including strings, a UDT and a nested container, and both FOR EACH binding forms.

Complexity is ASSERTED, not assumed: 100k pushes must produce at most 20 reallocations (log2(100000/8)+1 = 15) and a final capacity under 2n. That is what "amortised O(1) append" means.

src/tests/generics/fail-container-nosort.bas and fail-container-noequals.bas pin the diagnostics for an element type without '<' or '='.

<!-- finder:start -->

## API reference

Every entry, grouped by task. [Collections](Functions-Collections) lists them beside the rest of the area.

### Choose a container

| Function | What it does | From |
|---|---|---|
| [Array](Modern-Array-Array) | Holds a growable list of values in order, reached by position from 0. | `std/containers` |

### Array: add and remove

| Function | What it does | From |
|---|---|---|
| [Array.Push](Modern-Array-Push) | Adds a value at the end, growing the array as needed. | `std/containers` |
| [Array.Pop](Modern-Array-Pop) | Removes and returns the last element, or a default value if the array is empty. | `std/containers` |
| [Array.Insert](Modern-Array-Insert) | Inserts a value at a position, moving the later elements up one place. | `std/containers` |
| [Array.Remove](Modern-Array-Remove) | Removes the element at a position, keeping the rest in order. | `std/containers` |
| [Array.RemoveSwap](Modern-Array-RemoveSwap) | Removes the element at a position quickly by moving the last element into its place. | `std/containers` |
| [Array.Clear](Modern-Array-Clear) | Removes every element but keeps the allocated room. | `std/containers` |

### Array: read, count and visit

| Function | What it does | From |
|---|---|---|
| [Array.At](Modern-Array-At) | Returns a reference to the element at a position, like a[ i ]. | `std/containers` |
| [Array.Count](Modern-Array-Count) | Returns the number of elements; the valid indices are 0 to Count minus 1. | `std/containers` |
| [Array.IsEmpty](Modern-Array-IsEmpty) | Returns true if the array has no elements. | `std/containers` |
| [ForEach](Modern-Array-ForEach) | Calls a procedure on every element in order, passing each by reference. | `std/containers` |

### Array: find a value

| Function | What it does | From |
|---|---|---|
| [IndexOf](Modern-Array-IndexOf) | Returns the index of the first element equal to a value, or -1 if there is none. | `std/containers` |
| [Contains](Modern-Array-Contains) | Returns true if any element equals the value. | `std/containers` |

### Sort an Array or a LinkedList

| Function | What it does | From |
|---|---|---|
| [Sort](Modern-Array-Sort) (Array) | Sorts an Array in ascending order in place; equal elements may change places. | `std/containers` |
| [SortBy](Modern-Array-SortBy) (Array) | Sorts an Array in place by your comparer; equal elements may change places. | `std/containers` |
| [StableSort](Modern-Array-StableSort) (Array) | Sorts an Array in ascending order, keeping equal elements in their original order. | `std/containers` |
| [StableSortBy](Modern-Array-StableSortBy) (Array) | Sorts an Array by your comparer, keeping equal elements in their original order. | `std/containers` |
| [IsSorted](Modern-Array-IsSorted) (Array) | Returns true if the Array is already in ascending order. | `std/containers` |

### Walk a container step by step

| Function | What it does | From |
|---|---|---|
| [Array.GetIterator](Modern-Array-GetIterator) | Returns an iterator over the elements, for stepping through them by hand. | `std/containers` |
| [ArrayIterator](Modern-Array-ArrayIterator) | Holds a position in an Array; steps with IsValid, Value and MoveNext. | `std/containers` |

### Reserve room ahead of time

| Function | What it does | From |
|---|---|---|
| [Array.Capacity](Modern-Array-Capacity) | Returns how many elements fit before the array has to grow. | `std/containers` |
| [Array.Reserve](Modern-Array-Reserve) | Makes room for at least n elements without adding any; it never shrinks. | `std/containers` |
| [Array.Shrink](Modern-Array-Shrink) | Releases unused room, cutting the capacity down to the count. | `std/containers` |

<!-- finder:end -->

---



---

[Home](Home) · [Keyword Index](Keyword-Index)
