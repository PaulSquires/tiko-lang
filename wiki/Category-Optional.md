[Home](Home) › [All Categories](Categories) › **Optional**

# Optional

[![tiko-lang](https://img.shields.io/badge/tiko--lang-extension-8A2BE2?style=flat-square)](What-Is-tiko-lang)

> ✨ **tiko-lang category.** Everything below is new in tiko-lang and is not part of stock FreeBASIC 1.20.0.

```freebasic
#include once "fb/optional.bi"
using FB

function Lookup( byref key as ustring ) as Optional( of long )
    if( key = "ada" ) then
        return Some( 1815L )
    end if
    return None( of long )( )
end function

dim r as Optional( of long ) = Lookup( "ada" )

if( r.HasValue( ) ) then
    print r.Value( )                 ' 1815
end if

dim as long unknown = -1
print Lookup( "nobody" ).ValueOr( unknown )      ' -1
```

## Why It Exists

FreeBASIC had no way to say "a value that might not be there". Absence was encoded as 0, -1, NULL, an empty string, or an out-parameter boolean -- differently in every library, and indistinguishable from a legitimate result whenever the sentinel is itself a legal value:

```freebasic
function Find( ... ) as long         ' is -1 "absent", or an index?
if( Find( ... ) = -1 ) then

dim idx as long = IndexOf( v, x )    ' 0 could mean "found at 0"
                                     ' or "not found" -- depends on the API
```

Optional puts the absence IN THE TYPE, where it has a name and cannot be confused with a value. It also removes the out-parameter form: 'TryGet( key, byref out ) as boolean' exists only because there was no way to return "a long, or nothing".

## Members

```freebasic
HasValue( ) as boolean                    O(1)
Value( ) byref as T                       O(1)   RAISES if empty
ValueOr( byref dflt as T ) byref as T     O(1)   never raises
Clear( )                                  O(1)   becomes empty
```

and two FREE PROCEDURES, not constructors:

```freebasic
Some( v ) as Optional( of T )             T inferred from v
None( of T )( ) as Optional( of T )       T must be written out
```

There is deliberately no operator '=', no comparison, no ToString and no GetIterator. See WHY THERE ARE SO FEW MEMBERS below.

## A DEFAULT-CONSTRUCTED Optional Is Empty

```freebasic
dim o as Optional( of long )         ' empty, not "uninitialised"
```

There is no third state to get wrong. Construction by free procedure rather than by constructor is what lets T be inferred:

```freebasic
dim o as Optional( of long ) = Some( 3L )        ' not Optional( of long )( 3 )
```

None( ) exists so that returning nothing reads as a decision rather than as a forgotten assignment:

```freebasic
return None( of long )( )           ' deliberate
return                              ' also empty, but says nothing
```

T cannot be inferred for None( ) -- there is no argument to infer it from -- so it has to be written out.

## Inference Never Converts

Some( ) infers T from the ARGUMENT, and an untyped integer literal is an INTEGER:

```freebasic
dim o as Optional( of long ) = Some( 3 )        ' Optional( of integer ):
                                                ' type mismatch

dim o as Optional( of long ) = Some( 3L )       ' correct
```

The same rule the containers already carry, for the same reason: inference reads parameter positions and does not coerce. Use a suffixed literal or a variable of the element type.

## Empty Access Raises

Value( ) on an empty Optional raises FB_RTERROR_ILLEGALFUNCTIONCALL through the ordinary fbc path. With no handler installed the program stops:

```freebasic
Aborting due to runtime error 1 (illegal function call)
  at line 84 of ...\inc\fb\optional.bi()
```

It is catchable by 'on error' and reports a line under -exx. This is a bug at the call site, not a recoverable condition: HasValue( ) or ValueOr( ) is available and costs nothing.

ValueOr( ) is the branch-free alternative and never raises:

```freebasic
print o.ValueOr( fallback )
```

Both return BYREF. ValueOr( ) therefore aliases either the stored value or the CALLER'S default, so passing a temporary gives a reference that dies at the end of the statement -- the same hazard as any byref return, not an Optional one.

Value( ) IS usable as an assignment target, and writes through to the stored value:

```freebasic
dim o as Optional( of long ) = Some( 1L )
o.Value( ) = 5
print o.Value( )                    ' 5
```

Note this differs from Array.At( ), where 'a.At( 0 ) = 11' does NOT assign -- measured, both under -w 3, and both silent. Do not assume one from the other. Binding byref is unambiguous and works for both:

```freebasic
dim byref as long r = o.Value( )
r = 5
```

## Zero Is A Value

This is the whole point, and it is worth stating on its own:

```freebasic
dim engaged as Optional( of long ) = Some( 0L )
dim empty_  as Optional( of long )

engaged.ValueOr( zero )             ' 0
empty_.ValueOr( zero )              ' 0        -- same answer
engaged.HasValue( )                 ' true
empty_.HasValue( )                  ' false    -- different states
```

Every sentinel encoding Optional replaces gets this case wrong.

## Why There Are So Few Members

Not minimalism. Every member of a generic is instantiated whether it is called or not, so a member needing '=' on T would make the WHOLE TYPE unusable for any T without one -- the same rule that forced Array's Sort, IndexOf and Contains to become free procedures.

So Optional's members use only default construction, copy and destruction, and Optional( of T ) instantiates for any T that has those. Including containers, which have no '=':

```freebasic
dim o as Optional( of Array( of long ) )        ' fine
```

Anything needing more than that belongs in a free procedure, where the requirement lands on the call that actually needs it.

## It Is NOT A Sum Type

Optional is a T plus a boolean, not a tagged union. The stored T is always default-constructed, whether or not the Optional is engaged, so:

```freebasic
sizeof( Optional( of T ) ) >= sizeof( T ) + sizeof( boolean )
```

and T's default constructor runs for an empty Optional. That is the price of not having sum types in the language; it also means T MUST be default-constructible:

```freebasic
type NoDefaultCtor
    as long a
    declare constructor( byval n as long )      ' suppresses the implicit one
end type

dim o as Optional( of NoDefaultCtor )           ' error 183: TYPE or CLASS
                                                ' has no default constructor
```

## Library Only

No compiler change went into this, and several things were deliberately NOT done:

```freebasic
no '?' operator                     ' propagating early-return
no must-use diagnostic              ' ignoring an Optional stays a convention
no sum type underneath              ' see above
no implicit conversion to boolean   ' 'if( o ) then' does not compile
```

What it buys is that the absence has a name and a type. Nothing more is claimed.

## NOT Iterable

There is no GetIterator( ), so 'for each' over an Optional is a compile error rather than a zero-or-one loop. A maybe-value is not a sequence, and pretending it is makes the absence easy to skip silently:

```freebasic
for each v in maybe                 ' would do nothing, and say nothing
    use( v )
next
```

Write the branch.

## Ownership AND Copying

Copy and assignment are DEEP, because the T is stored by value and FreeBASIC's value semantics do the work. 'dim b = a' copies the flag and the T; assignment overwrites both. The two are independent afterwards in BOTH directions.

Clear( ) resets the slot rather than only clearing the flag, so a T holding a resource -- a string, a container -- releases it at the Clear( ) rather than at the Optional's own destruction.

An Optional( of T ptr ) copies the POINTER. There are no smart pointers.

Optional( of Optional( of T ) ) works and has three distinguishable states, which is what makes it composable at all.

## Implementation Note

Value( ) returns a reference to the stored slot even on the raising path, because a byref return must refer to something and the slot is always a real default-constructed object.

It does NOT use the function-'static' blank that LinkedList.Front( ) uses. That pattern is correct there -- an empty list has no node to point at -- but it would be a leak here with a measured cause: a function-'static' UDT in FreeBASIC is constructed lazily on first call and is NEVER destroyed, so every instantiation of the member would retain one T, and its resources, for the lifetime of the program.

Source: src/inc/fb/optional.bi

## Tests

src/tests/generics/container-optional.bas is exhaustive: every member, both states, both free constructors, all four assignment transitions between the states, self-assignment, copy independence in both directions, byref mutation through Value( ) and ValueOr( ), element types long / double / string / a UDT with no operators / a nested Array / a nested Optional, an Optional as a return value, and destructor balance with a counting element type -- asserted for the engaged case and for the never-engaged case separately.

src/tests/generics/optional-empty-value.bas is a COMPILE_AND_RUN_FAIL test pinning that Value( ) on an empty Optional aborts. It is a separate module because the raise ends the process.

src/tests/generics/fail-optional-nodefaultctor.bas pins the diagnostic for a T with no default constructor.

## API reference

One page per entry, 6 in all:

[Clear](Modern-Optional-Clear) · [HasValue](Modern-Optional-HasValue) · [None](Modern-Optional-None) · [Some](Modern-Optional-Some) · [Value](Modern-Optional-Value) · [ValueOr](Modern-Optional-ValueOr)

---

**Source:** `docs/optional/optional.txt` in the [FBC-Modern repository](https://github.com/PaulSquires/fbc-modern).


---

[Home](Home) · [Keyword Index](Keyword-Index)
