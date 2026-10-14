[Home](Home) › [All Categories](Categories) › **For Each**

# For Each

```freebasic
dim names(0 to 2) as ustring = { "ada", "grace", "edsger" }

for each n as ustring in names
    print n
next
```

The loop variable is declared by the statement, is scoped to the loop body, and holds a COPY of each element.

## Why It Exists

An ordinary FOR counts. A traversal written with it is an index loop:

```freebasic
for i as int32 = lbound(arr) to ubound(arr)
    process( arr(i) )
next
```

which is where 'lbound vs 0', 'ubound vs count-1' and the wrong index in a nested loop come from. FOR EACH removes the index.

The OPERATOR FOR / NEXT / STEP protocol is separate. It serves 'for i as T = a to b', which is a different statement. See doc/iterator-protocol.txt for why it does not cover collections.

## The Forms

```freebasic
for each x in c                 element type inferred
for each x as E in c            element type given; ordinary conversion
                                rules apply, as for 'dim x as E = ...'
for each byref x as E in c      x is a reference to the element
for each byref x in c
```

Close with NEXT. NEXT may NOT name the variable -- in a FOR EACH the variable is the element, not a counter, and it does not survive the loop.

EXIT FOR and CONTINUE FOR work exactly as in an ordinary FOR, including the multi-level forms: a FOR EACH counts as a FOR. CONTINUE FOR still advances the iterator.

## What Can Be Walked

Fixed array        any lbound; the element type is the array's Dynamic array      lbound/ubound read once at loop entry; an unallocated

```freebasic
array iterates zero times
```

var-len STRING     one BYTE per iteration, not one character Any type satisfying the iterator protocol -- it has

```freebasic
GetIterator( ) returning a type with IsValid( ),
Value( ) and MoveNext( ).  See doc/iterator-protocol.txt.
```

BYREF binding is permitted for arrays always, and for a user collection when its iterator's Value( ) is declared 'byref as E'. It is not permitted for strings.

```freebasic
for each byref v as int32 in values
    v *= 2                  '' modifies the array
next
```

## How It Lowers

A user collection becomes

```freebasic
dim __it = c.GetIterator( )
goto test
```

ini:

```freebasic
scope
    dim x = __it.Value( )        '' or a byref binding
    BODY
end scope
```

cmp:                               '' CONTINUE FOR lands here

```freebasic
__it.MoveNext( )
```

test:

```freebasic
if __it.IsValid( ) then goto ini
```

The collection expression is evaluated EXACTLY ONCE, before the first iteration; 'for each x in f( )' calls f once. \_\_it is an ordinary scoped value, so an iterator with a destructor is destroyed on normal exit, on EXIT FOR, and on anything else that leaves the scope. x is declared inside the body's scope, so it is constructed and destructed per iteration for types that need it.

An array or a string becomes an ordinary FOR over a hidden counter with the element bound at the top of the body. No iterator object is materialised, and the emitted code is what the hand-written index loop emits -- FOR EACH over an array is exactly as fast as 'for i = lbound to ubound'.

lbound and ubound are read ONCE, at loop entry. Resizing the array inside the loop neither extends nor shortens it, and resizing a dynamic array during iteration may invalidate BYREF bindings. This is stated, not prevented -- it is the same as for the hand-written loop.

## 'each' AND 'in' As Names

'each' and 'in' are NOT reserved words. Neither is in the keyword table, and both remain usable as variable, procedure, field and type names. These compile, with their ordinary meaning:

```freebasic
for each as int32 = 1 to 3       '' 'each' is the counter
    print each
next

dim each as int32
for each = 1 to 3
next

dim in as int32 = 7
```

One token of look-ahead separates the two forms with nothing left over. An ordinary FOR requires a simple scalar counter --

```freebasic
for each(0) = 1 to 3    error 52: Expected scalar counter
for each.v  = 1 to 3    error 52: Expected scalar counter
```

-- so after 'for \<identifier>' the only tokens an ordinary FOR accepts are AS and '=', and a FOR EACH's next token is always BYREF or an identifier.

## Diagnostics

The failure mode of a structural protocol is a near-miss, so the message says which member is missing rather than just "not iterable":

```freebasic
error 342: Type is not iterable, it needs:
           declare function GetIterator( ) as <iterator>, MYLIST

error 343: Not an iterator type, an iterator needs IsValid( ) as boolean,
           Value( ) [byref] as E and MoveNext( ), missing, MoveNext( )

error 344: Cannot FOR EACH over a multi-dimensional array,
           iterate one dimension explicitly

error 345: Cannot bind BYREF in FOR EACH,
           the iterator's Value( ) returns by value

error 346: NEXT cannot name the FOR EACH variable,
           it is scoped to the loop body
```

## Known Limits

- ZSTRING and WSTRING are refused. A var-len STRING carries its own length; a

```freebasic
fixed-length buffer does not, and a ZSTRING should be walked to its
terminating NUL rather than to its declared size -- a different loop, not a
different bound. Assign to a STRING first.
```

- A STRING expression with side effects is refused, because the pointer and

```freebasic
the length are read separately and the collection must be evaluated exactly
once. Assign it to a variable first.
```

- String iteration yields BYTES. For non-ASCII text that is not character

```freebasic
iteration, and the compiler does not warn -- a warning would fire on every
correct ASCII use. A character-correct answer belongs with a real Unicode
string type.
```

- Multi-dimensional arrays are a compile-time error. There is no defensible

```freebasic
default traversal order, and picking one silently would be worse.
```

- No index is available. FOR EACH gives the element, not its position.

## Tests

tests/generics/for-each.bas exercises all of the above, plus the cases that use 'each' and 'in' as names, nesting with itself and with FOR and WHILE, the iterator destructor running on EXIT FOR, and the collection being evaluated once. Five fail-tests and five golden diagnostic files cover the errors.

## API reference

One page per entry, 4 in all:

[GetIterator](Modern-ForEach-GetIterator) · [IsValid](Modern-ForEach-IsValid) · [MoveNext](Modern-ForEach-MoveNext) · [Value](Modern-ForEach-Value)

---



---

[Home](Home) · [Keyword Index](Keyword-Index)
