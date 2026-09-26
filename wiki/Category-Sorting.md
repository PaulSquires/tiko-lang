[Home](Home) › [All Categories](Categories) › **Sorting**

# Sorting

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang category.** Everything below is new in tiko-lang and is not part of stock FreeBASIC 1.20.0.

```freebasic
#include once "fb/sort.bi"           ' or "containers.bi" for everything
using FB

dim v as Array( of long )
...
Sort( v )                            ' ascending, by '<'
StableSort( v )                      ' ascending, equal elements keep order

SortBy( v, function( byref x as long, byref y as long ) as boolean
    return x > y                     ' descending
end function )

dim q as LinkedList( of ustring )
SortList( q )
```

Two sorts, and the difference is the one C++ draws between std::sort and std::stable_sort.

## Procedures

Over Array( of T ):

```freebasic
Sort( a )                             O(n log n) worst   in place, unstable
SortBy( a, less )                     O(n log n) worst   in place, unstable
StableSort( a )                       O(n log n) always  O(n) scratch, STABLE
StableSortBy( a, less )               O(n log n) always  O(n) scratch, STABLE
IsSorted( a ) as boolean              O(n)
IsSortedBy( a, less ) as boolean      O(n)
```

Over LinkedList( of T ):

```freebasic
SortList( l )                         O(n log n) worst   O(1) extra, STABLE
SortListBy( l, less )                 O(n log n) worst   O(1) extra, STABLE
```

All eight are FREE GENERIC PROCEDURES, not members, and none is included by fb/array.bi or fb/linkedlist.bi on its own.

Map and Set are not in the list and never will be. Both are open-addressed hash tables whose element order is a function of the hash; permuting their storage would destroy the lookup. Sort a snapshot instead:

```freebasic
dim ks as Array( of ustring ) = m.Keys( )
Sort( ks )
for each k in ks
    print k, m[ k ]
next
```

## Which One

Sort( ) unless you need stability. It is in place, it does not allocate, and it is faster on every input.

StableSort( ) when T carries more than the key -- sorting records by surname and expecting the previous order within a surname to survive. For scalars the two produce identical output, and the scratch buffer is wasted.

SortList( ) is the only list sort, and it is stable. Introsort is not available there and the reason is structural rather than an omission: quicksort needs random access to reach its pivot and to scan inward from both ends, and a linked list gives neither.

Sorting a LinkedList by copying it into an Array, sorting that, and copying it back is SLOWER, not faster: SortList relinks nodes and moves no element at all.

## Introsort

Sort( ) and SortBy( ) are an introsort, following Musser 1997 and what libstdc++ ships. Three algorithms, because no one of them is enough:

1. QUICKSORT is the fast average case and the reason the whole thing is fast.

```freebasic
Its worst case is O(n^2), and the input that triggers it is not exotic --
already-sorted data against a naive pivot does it.
```

2. HEAPSORT is the guarantee. The recursion depth is tracked, and at

```freebasic
2*floor(log2 n) the range in hand is finished by heapsort instead. That
turns quicksort's O(n^2) worst case into an O(n log n) one at no cost to
the average case, because the limit is essentially never reached. Heapsort
is slower than quicksort on ordinary input -- its access pattern defeats
the cache -- which is exactly why it is the fallback and not the default.
```

3. INSERTION SORT finishes the job. Below sixteen elements quicksort's

```freebasic
partitioning overhead exceeds the cost of just shifting, so ranges that
small are insertion-sorted and not recursed into. Sixteen is libstdc++'s
number.
```

The pivot is the median of the first, middle and last element. That is what stops already-sorted input, and it pays for itself twice: once the three are ordered the last element is known to be at least the pivot, which is what bounds the left-to-right scan.

Quicksort recurses on the SMALLER side and iterates on the larger, so the stack is O(log n) deep -- 64 frames at the very worst -- rather than O(n).

## Stable Sort

StableSort( ) and StableSortBy( ) are a bottom-up merge sort. The run width starts at sixteen -- the initial runs are built with the same insertion sort, which skips the first four merge passes outright -- and doubles each pass, so there is no recursion and no midpoint arithmetic to get wrong.

Only the LEFT run of each merge is moved to the scratch buffer. The right run is already sitting where the output will end, and the write cursor provably never catches up with the read cursor while any left element remains, so the merge writes straight over the right run in place. That halves the scratch traffic.

## Every Move Is A Swap

SWAP on a UDT exchanges the storage: no constructor, no copy constructor, no destructor, and it does that through a generic type parameter. Every element move in every one of these procedures is a SWAP, so sorting an Array( of string ) performs ZERO string copies, where the usual shift-with-a-temporary idiom performs one deep copy per shifted element.

This is why the insertion sort here bubbles an element down by adjacent swaps rather than holding it in a temporary. It is measured, not assumed: the test suite sorts an array of a counting element type and asserts that the copy constructor and the destructor are called exactly zero times.

## The Comparer

'less( x, y )' must be TRUE when x must come BEFORE y, and FALSE when the two are equivalent. It is a strict '<', not a '<='. Return BOOLEAN.

A comparer that returns TRUE for equal elements is the classic way to make a sort walk off the end of its array. The partition here is bounds-checked so that it cannot -- a bad comparer gives a bad ORDER, not a crash or a corruption, and the test suite pins that with an always-true and an always-false comparer. The resulting order is still garbage.

The comparer arrives through a GENERIC PARAMETER, 'of TCmp', rather than a procedure pointer, for the same reason FB.ForEach does. A CAPTURING lambda is a closure object and cannot convert to a procptr, so a procptr parameter would reject the most useful kind of comparer:

```freebasic
dim as long comparisons = 0
SortBy( v, function[ byref comparisons ]( byref x as long, byref y as long ) as boolean
    comparisons += 1
    return x < y
end function )
```

A non-capturing lambda and a plain '@myproc' still work, because calling through a generic parameter is 'less( x, y )' either way.

## Why The Names Are All Different

There is no overloading of generic procedures. A second Sort of any signature is error 4, Duplicated definition -- whether it differs in arity, in type-parameter count, or in parameter type:

```freebasic
sub Sort( of T )( byref a as Array( of T ) )
sub Sort( of T, C )( byref a as Array( of T ), byref c as C )     ' error 4
sub Sort( of T )( byref l as LinkedList( of T ) )                 ' error 4
```

So the comparer form is SortBy rather than another Sort, and the list form is SortList rather than a Sort taking a LinkedList. Measured, not assumed.

## Why These Are Free Procedures

Every member body of a generic is replayed for every instantiation, whether or not it is ever called. A member needing '<' on T would therefore make Array( of T ) fail to instantiate for every T without one -- Array( of Array( of long ) ) would not compile at all.

A generic PROCEDURE is instantiated only where it is called, so the requirement lands on the call site that actually sorts. This is the same reason IndexOf and Contains are free procedures; see docs/generics/generics.txt, KNOWN LIMITS.

src/tests/generics/fail-container-nosort.bas pins the diagnostic.

## Two Compiler Bugs This Header Found

Both were pre-existing, both were fixed rather than worked around, and both are regression-tested. They are recorded here because this header is what walked into them.

1. A GENERIC FUNCTION WHOSE BODY CONTAINED A LAMBDA did not compile. The body capture in hCaptureProcBody counted no block nesting at all, on the stated reasoning that "procedures cannot nest in FreeBASIC" -- true until this compiler added lambdas. It ended the capture at the lambda's END FUNCTION. A generic SUB was unaffected, because its terminator is END SUB.

The mirror image was also true and had nothing to do with generics: hCaptureLambdaBody counted EVERY SUB|FUNCTION, so a procedure-pointer declaration inside a lambda body raised the nesting depth and never lowered it -- error 351, Unterminated lambda body.

Both now ask lambdaOpensHere, which answers structurally rather than by counting keywords. src/tests/generics/lambda-in-generic.bas.

2. A PROCEDURE POINTER AS A TYPE ARGUMENT, spelled inside a generic body, was a use-after-free. The anonymous PROC symbol describing a procptr type is scoped to where it was spelled -- correct for a DIM, because such a type may name locals in its own signature. A type argument outlives its call site: the instantiation's body is not replayed until the next module-level statement boundary, by which time the scope has closed and the symbol node has been recycled. The parameter came out as whatever now occupied it -- 'unknown type name label$6' from the C backend, or error 17 and a segfault when the slot held a proc. Being a use-after-free it also sometimes worked.

Generic instantiation now re-interns a procptr type argument at global scope before binding it. src/tests/generics/generic-procptr-typearg.bas.

One limitation surfaced by the first fix is still open: a CAPTURING lambda cannot name the enclosing generic's T in its own parameter list. It was unreachable before, because the body never got as far as being replayed. It does not affect this header -- every lambda here is non-capturing -- and src/tests/generics/fail-lambda-capture-typaram.bas pins it.

## Tests

src/tests/generics/container-sort.bas.

Every procedure the header declares, over eight input shapes -- ascending, descending, all equal, two distinct values, organ pipe, sawtooth, random over a wide range, random with many duplicates -- at every length from 0 to 40, so the insertion-sort cutoff at 16 and the first two merge widths are crossed rather than straddled, plus 100, 511 and 1000.

Every run checks two things, not one: that the output is ORDERED, and that it is a PERMUTATION of the input. A sort that loses or duplicates an element passes the first and fails the second.

The claims that are not about ordering are checked as claims:

- STABILITY of StableSort and SortList, using a payload field that '<' cannot

```freebasic
see, so an unstable result is detectable rather than invisible.
```

- The HEAPSORT FALLBACK, driven by a median-of-3 killer input with a counting

```freebasic
comparer, bounded at 25*n*log2(n) -- far above what introsort needs and far
below what the quadratic path would cost.
```

- MOVES ARE SWAPS: zero copy constructions and zero destructions over a sort

```freebasic
of 100 counting elements, for both Sort and SortList.
```

- SortList relinks correctly in BOTH directions. The chain is walked forwards

```freebasic
from head and backwards from tail, because a merge that rewrites 'nxt' and
forgets 'prv' leaves a list that reads correctly one way only. head->prv and
tail->nxt are checked null, and the list is pushed and popped at both ends
afterwards.
```

- An always-TRUE and an always-FALSE comparer terminate and lose no elements.

Element types: long, double, string, a UDT with a global '<', a counting UDT, and a nested Array( of Array( of long ) ) to confirm the outer container still instantiates.

See also: docs/array/array.txt              FB.Array( of T ) docs/linkedlist/linkedlist.txt    FB.LinkedList( of T ) docs/lambda/lambda.txt            capturing and non-capturing lambdas docs/generics/generics.txt        RFC-0001, and the limits above

## API reference

One page per entry, 8 in all:

[IsSorted](Modern-Sorting-IsSorted) · [IsSortedBy](Modern-Sorting-IsSortedBy) · [Sort](Modern-Sorting-Sort) · [SortBy](Modern-Sorting-SortBy) · [SortList](Modern-Sorting-SortList) · [SortListBy](Modern-Sorting-SortListBy) · [StableSort](Modern-Sorting-StableSort) · [StableSortBy](Modern-Sorting-StableSortBy)

---

**Source:** `docs/sort/sort.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)
