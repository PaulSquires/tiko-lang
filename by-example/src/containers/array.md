# Array

`containers.Array( of T )` is a list that grows. `Push` adds an element at the
end; when the storage is full it doubles, so a long run of pushes reallocates
only a few times. Use it instead of growing an ordinary array one element at a
time with `redim preserve`.

```tiko
{{#include ../../examples/containers/array.tiko}}
```

**Output**

```text
{{#include ../../examples/containers/array.out}}
```

**Indices start at 0**: `xs[ 0 ]` is the first element and
`xs[ xs.Count( ) - 1 ]` the last. `xs[ i ]` can be read and assigned.

| Member | Does |
|---|---|
| `Push( v )`, `Pop( )` | add at the end; remove and return the last |
| `Insert( i, v )`, `Remove( i )` | add or remove at `i`, keeping the order |
| `RemoveSwap( i )` | remove at `i` by moving the last element into the gap |
| `Count( )`, `IsEmpty( )` | how many elements there are |
| `Capacity( )`, `Reserve( n )`, `Shrink( )` | the storage behind them |
| `Clear( )` | remove every element, keeping the storage |

`Insert` and `Remove` move every element after `i`, so they cost more the
longer the array is. `RemoveSwap` is the fast way to remove when the order does
not matter.

`for each x in xs` gives you a copy of each element; `for each byref x in xs`
gives you the element itself, so assigning to `x` changes the array. `Pop` on
an empty array returns the element type's default value, 0 here, rather than
failing: check `IsEmpty( )` first when that matters.

````admonish warning title="Status in this version"
Under `-exx`, `xs[ i ]` is checked against the array's storage, not against
`Count( )`. An index past the last element but inside the capacity reads a
stale value instead of stopping the program:

```tiko
dim xs as containers.Array( of int32 ) = { 1, 2, 3, 4 }
xs.Pop( )
print xs[ 3 ]        '' prints 4; Count( ) is 3
```

Keep indices below `Count( )` yourself.
````

### Activities

1. Use `RemoveSwap( 0 )` instead of `Remove( 2 )` and compare the order.
2. Push the numbers 1 to 100 and print `Capacity( )` after every tenth push.
