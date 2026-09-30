[Home](Home) › [All Categories](Categories) › **Iterators**

# Iterators

## Why It Exists

FreeBASIC already has an iteration protocol: OPERATOR FOR / OPERATOR NEXT / OPERATOR STEP, which serve

```freebasic
for i as T = a to b
```

That is a RANGE protocol, and it is kept exactly as it is. It does not solve the collection problem, for three reasons:

1. Seven declarations and seven definitions to iterate one type -- two

```freebasic
constructors and an OPERATOR LET on top of the three iteration operators,
because the loop variable is copy-constructed and assigned.
```

2. The loop variable IS the iterator, not the element. The body says

```freebasic
'i.cur'. Every use site has to know the iterator's representation.
```

3. FOR is 'start TO limit', and the limit is structural to the statement.

```freebasic
Iterating a linked list means inventing a sentinel object meaning
"exhausted". The collection is never named in the loop at all.
```

This protocol is the collection half. A collection hands out an iterator; the iterator hands out elements until it runs out.

## The Contract

A type is ITERABLE if it has

```freebasic
declare function GetIterator( ) as I
```

taking no parameters, where I is an ITERATOR TYPE. GetIterator may be CONST.

A type is an ITERATOR TYPE if it has all three of

```freebasic
declare function IsValid( ) as boolean      '' still on an element?
declare function Value( ) [byref] as E      '' the current element
declare sub      MoveNext( )                '' advance
```

all taking no parameters. E -- whatever Value returns -- is the ELEMENT TYPE. IsValid and Value may be CONST; MoveNext may not.

That is the whole thing:

```freebasic
type IntListIterator
    as IntNode ptr node
    declare function IsValid( ) as boolean
    declare function Value( ) byref as long
    declare sub      MoveNext( )
end type

function IntListIterator.IsValid( ) as boolean
    return this.node <> 0
end function

function IntListIterator.Value( ) byref as long
    return this.node->value
end function

sub IntListIterator.MoveNext( )
    this.node = this.node->nxt
end sub

type IntList
    as IntNode ptr head
    declare function GetIterator( ) as IntListIterator
end type

function IntList.GetIterator( ) as IntListIterator
    dim it as IntListIterator
    it.node = this.head
    return it
end function
```

## Structural, NOT Nominal

There is no Iterable interface to implement and nothing to inherit. A type is iterable because name lookup finds the members.

This is deliberate. FreeBASIC has no interface feature independent of inheritance, so a nominal protocol would consume the type's single inheritance slot, add a vtable and a virtual call per element to types that are otherwise plain data, and force every existing collection to be modified. Structural matching costs one name lookup at compile time and produces a direct, inlinable call.

The cost is that a type can conform by accident, and that a near-miss ('MoveNxt') reads as "not iterable" rather than "you misspelled it".

## What An Implementer Promises

None of this is checkable by the compiler.

- IsValid is pure and repeatable. Calling it twice without an intervening

```freebasic
MoveNext gives the same answer.
```

- Value may be called only while IsValid is true, and may be called more than

```freebasic
once for the same element.
```

- MoveNext may be called only while IsValid is true. After the last element it

```freebasic
leaves the iterator with IsValid false.
```

- A freshly returned iterator is ALREADY ON the first element, or has IsValid

```freebasic
false for an empty collection. THERE IS NO "BEFORE THE FIRST ELEMENT" STATE
-- MoveNext is not called before the first Value. This differs from C#'s
IEnumerator, and it is what lets a linked-list iterator be one pointer and
an array iterator be a pointer and an index, with the empty case falling
out for free.
```

- Mutating the collection's STRUCTURE during iteration invalidates the

```freebasic
iterator. Mutating an element's VALUE through a byref Value does not.
```

## Byref OR By Value

The element type is whatever Value returns. Declare it BYREF and elements can be modified in place:

```freebasic
function ArrayIterator( of T ).Value( ) byref as T
    return this.first[ this.idx ]
end function
```

Declare it by value and the caller gets a copy. Both are legal; the choice is the implementer's.

## Generic Collections

With generics the iterator is written once:

```freebasic
type ArrayIterator( of T )
    as T ptr first
    as long idx, count
    declare function IsValid( ) as boolean
    declare function Value( ) byref as T
    declare sub      MoveNext( )
end type

type Buf( of T )
    as T e( 0 to 7 )
    as long n
    declare function GetIterator( ) as ArrayIterator( of T )
end type
```

Note that Buf's GetIterator returns an instantiation of a DIFFERENT generic. That works, and it is the shape the standard containers use.

## Iterators Are Ordinary Values

An iterator has ordinary FreeBASIC lifetime. If it holds a resource, give it a destructor and the destructor runs when it goes out of scope -- including on EXIT FOR, on GOTO out of a loop, and while an error unwinds the scope. The protocol adds no lifetime rule of its own; it relies on the one the language already has.

This is why GetIterator returns BY VALUE rather than allocating. A typical iterator is a pointer and two integers and costs nothing.

## Coexistence

OPERATOR FOR / NEXT / STEP is untouched, undeprecated and unchanged. A type may implement both protocols and they do not interfere: they are looked up separately and neither falls back to the other.

A collection is even allowed to BE its own iterator (GetIterator returning itself by value). Convenient for one-shot generators, and an easy way to make an aliasing mistake -- two "independent" iterations would share one cursor.

## Known Limits

- CONST OVERLOADING IS NOT AVAILABLE. FreeBASIC does not distinguish

```freebasic
overloads by constness alone:

    declare function f( ) as long
    declare const function f( ) as long
    error 4: Duplicated definition

So a type cannot supply a const and a non-const GetIterator pair. Declare
the single GetIterator CONST -- it then serves const and non-const
collections alike, which is what a container wants anyway.
```

- SINGLE PASS ONLY. There is no Reset, no MovePrev, no random access and no

```freebasic
way to ask a collection for its length. That is enough to walk a
collection and not enough for a generic algorithms library.
```

- The names GetIterator, IsValid, Value and MoveNext are NOT reserved words

```freebasic
and are not in the keyword table. A type that has them today compiles and
behaves exactly as before; the only new consequence is that it may now also
be walkable.
```

## Conformance Suite

tests/generics/iterator-protocol.bas exercises every shape above: the hand-written linked-list iterator, the generic one, byref and by-value Value, a const GetIterator reached from const and non-const collections, an empty collection, two independent iterators over one collection, element types that are UDTs and generic instantiations, an iterator with a destructor (asserting constructed == destroyed), and one type carrying both protocols at once.

---

**Source:** `docs/for_each/iterator-protocol.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)
