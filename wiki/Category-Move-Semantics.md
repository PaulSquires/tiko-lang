[Home](Home) › [All Categories](Categories) › **Move Semantics**

# Move Semantics

```freebasic
#import "std/containers"
using containers

function LoadNames( byref path as string ) as Array( of string )
    dim as Array( of string ) names
    ' ... fill it ...
    return names                        ' MOVED: the caller gets these buffers
end function

dim as Array( of string ) a = LoadNames( "names.txt" )   ' no copy
dim as Array( of string ) b = move( a )                  ' no copy; a is now empty
b.Push( "one more" )
```

A **move** hands an object's contents to another object without copying them. The heap
data a string or an array owns stays where it is; only the object's own header (a
string's 24 bytes, an `Array`'s 80) goes to its new place, and the source is left empty.
tiko moves automatically wherever the source cannot be used again, and `move( x )` asks
for it explicitly.

## What Moves By Itself

| Code | What happens |
| --- | --- |
| `return r` where `r` is a local variable | `r` is moved into the caller's result; its destructor does not run |
| `return f( )`, `return a + b` | the temporary result is moved into the caller's result |
| `Take( f( ) )` with a `byval` parameter | the temporary **is** the argument: no copy |
| `b = f( )` | `b`'s old value is destroyed and the temporary moved in, when the type has no `operator let` of its own anywhere in it |

Everything else copies, as it always did: returning a `shared` variable, a `byref`
parameter, a field or an array element, and assigning from a variable. An assignment
over a type with a hand-written `operator let` still runs that `let`.

## move( x )

`move( x )` moves out of a variable, a field, an array element or `*p` that you are done
with. `x` is reset to its **default state** -- for a string or an array, empty; for a type
with a constructor, freshly default-constructed -- and is fully usable again:

```freebasic
dim as Array( of long ) work = Build( )
results.Push( move( work ) )   ' no copy
work.Push( 1 )                 ' fine: work is an empty array again
```

An explicit move skips the copy constructor **and** `operator let`: you asked for it.
`move( x )` is not a reserved word. A procedure, method or field of your own called `move`
keeps its meaning, and then `move( x )` is your procedure.

| Diagnostic | When |
| --- | --- |
| TKO1258 | `x` is not an object of a type: a `long`, a `string` |
| TKO1259 | `x` is const -- a move writes to its source |
| TKO1260 (warning) | `x` is a temporary, which is moved already |
| TKO1261 | `x`'s type is `nomove` |

## Move-Only Types

A type whose copy constructor and `operator let` are `private` cannot be copied -- and
**can** be moved, because a move calls neither. So it can be returned, kept in a container
and handed on:

```freebasic
#import "std/memory"

function OpenLog( ) as memory.UniquePtr( of LogFile )
    dim as memory.UniquePtr( of LogFile ) f = memory.MakeUnique( of LogFile )( )
    return f                                  ' moved
end function

dim as memory.UniquePtr( of LogFile ) lg = OpenLog( )
dim as memory.UniquePtr( of LogFile ) other = lg            ' error: a copy
dim as memory.UniquePtr( of LogFile ) mine = move( lg )     ' fine: lg is null now
```

See [Smart Pointers](Category-Smart-Pointers) for `UniquePtr`.

## nomove

Some objects must stay where they are, because something else holds their address: a
`WaitGroup` that workers were given `@wg` of, a node that registered `@this` in a list.
Mark such a type `nomove`:

```freebasic
type Pinned nomove
    as int32 v
end type
```

Then `move( x )` (TKO1261), `swap` (TKO1262) and `redim preserve` (TKO1263) are refused,
and the automatic moves above copy instead. A type with a `nomove` field is `nomove` too,
and a container that grows by reallocating -- `containers.Array` -- cannot hold one.
`tasks.WaitGroup` is `nomove`.

## The Containers Move Too

`Array.Push` / `Insert`, `Deque.PushBack` / `PushFront`, `LinkedList.PushBack` /
`PushFront`, `Map.Put` / `Add` and `Channel.Send` take their value **by value** and move it
into place. Passing a temporary or `move( x )` copies nothing; passing a variable copies it
exactly once, as before. `Channel.Receive` moves the value out of the buffer.

## Next To fbc

FreeBASIC has no moves: a `return r` copies `r`, and an assignment from a function result
runs `operator let`. tiko's moves change how many times a copy constructor, `let` and
destructor run -- which is the point -- so a program that counts those calls sees fewer
of them than under fbc. Everything else a program can observe is unchanged.
