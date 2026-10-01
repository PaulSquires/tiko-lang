[Home](Home) › [All Categories](Categories) › **Collection Initializers**

# Collection Initializers

```freebasic
#import "std/containers"

dim b as containers.Array( of integer )        = { 10, 20, 30 }
dim l as containers.LinkedList( of ustring )   = { "x", "y", "z" }
dim m as containers.Map( of ustring, integer ) = { {"a", 1}, {"b", 2} }

print b.Count( ), l.Count( ), m["b"]           ' 3  3  2
```

A container is filled the way a FreeBASIC array is initialized: with a brace list at the declaration.

## Why It Exists

A container that starts with known contents used to take one statement per element after the declaration:

```freebasic
dim b as containers.Array( of integer )
b.Push( 10 )
b.Push( 20 )
b.Push( 30 )
```

A brace list says the same in one line. Before this feature, tiko accepted `= { 10, 20, 30 }` on a container and silently threw the values away: `b.Count( )` was 0.

## Rules

**What counts as a collection.** A brace list `= { … }` on a declared variable is a collection initializer when the variable's type is a UDT that:

1. **needs construction**: it has a constructor of its own, or a field that needs one (a dynamic array, a `string` or `ustring`, an object with a constructor), and
2. **has a member procedure** named `Add`, `PushBack` or `Push`, looked for in that order. Members inherited from a base type count.

Every container in `containers` qualifies. So does a type of your own:

```freebasic
type Bag
    as string items( any )
    declare sub Add( byref s as string )
end type
sub Bag.Add( byref s as string )
    redim preserve items( ubound( items ) + 1 )
    items( ubound( items ) ) = s
end sub

dim bg as Bag = { "p", "q" }                   ' bg.Add( "p" ) : bg.Add( "q" )
```

| Type | Method called |
| --- | --- |
| `Array` | `Push` |
| `LinkedList` | `PushBack` |
| `Map`, `Set`, `OrderedMap`, `OrderedSet` | `Add` |

**Each element is one call.** An element `e` calls `x.Method( e )`. An element that is itself a brace list supplies the arguments of one call, so `{ "a", 1 }` calls `x.Add( "a", 1 )`. These are ordinary calls: overloads are resolved and arguments converted exactly as if you had written them, which is how `"a"` becomes a `ustring` key above. An element can be any expression.

**Order.** The variable is constructed first, by its default constructor, and then the calls run in element order, at the point of the declaration.

```freebasic
type Tally
    as long n
    declare constructor( )
    declare sub PushBack( byval v as long )
end type
constructor Tally( )
    n = 100
end constructor
sub Tally.PushBack( byval v as long )
    n = n * 2 + v
end sub

dim t as Tally = { 1, 2 }                      ' ((100 * 2 + 1) * 2 + 2) = 404
```

**Where it works.** A local `dim`, a module-level `dim`, and a `static` local. A `static` is filled once, the first time its declaration runs, like its construction.

```freebasic
sub Count( )
    static seen as containers.Array( of long ) = { 1, 2 }
    seen.Push( 9 )
    print seen.Count( )                        ' 3, then 4, then 5 ...
end sub
```

An empty list `= { }` constructs the variable and calls nothing. Several declarators in one `dim` each take their own list: `dim as containers.Array( of integer ) p = { 1 }, q = { 2, 3 }`.

**Not yet.** `dim shared`, a variable declared in a `namespace`, and a static member's definition are refused with `TKO0844`: their initializers run in the module initializer, not at the declaration. Field initializers inside a `type`, `var`, and assignment `x = { … }` are not collection initializers.

**Plain data is unchanged.** A type that needs no construction is not a collection, even with a `Push` method. Its initializer keeps its field-list meaning: `dim p as Pod = ( 7, 8 )`.

## Errors

| Id | When |
| --- | --- |
| `TKO0843` | The type needs construction but has no `Add`, `PushBack` or `Push`. |
| `TKO0844` | The variable is `shared` or belongs to a namespace (not supported yet). |
| `TKO0775`, `TKO0698`, … | An element's call is wrong: the ordinary diagnostic for that call, at that element. `{ {1, 2} }` into an `Array( of integer )` passes two arguments to `Push`. |

## Compatibility

fbc has no collection initializers. It refuses a brace list on any UDT with error 63, "Expected array", so no program that fbc accepts changes meaning.

See [Compatibility](Compatibility).
