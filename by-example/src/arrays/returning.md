# Returning arrays

A function can hand back a whole array: write `( )` after the result type, as
in `as int32( )`. The result is an ordinary dynamic array.

```tiko
{{#include ../../examples/arrays/returning.tiko}}
```

**Output**

```text
{{#include ../../examples/arrays/returning.out}}
```

`return` takes one of three things:

- **a brace list**, as in `Vowels`. The array is sized to the list and
  indexed from 0.
- **a local array**, as in `Squares`. It is moved to the caller rather than
  copied, and keeps its bounds, so `sq` runs from 1 to 5.
- **a call** to another function that returns an array of the same type.

The caller owns the result. `var sq = Squares( 5 )` takes it with its type and
bounds. Assigning to an existing dynamic array, `table = Squares( 2 )`, frees
what `table` held and takes the new array. A result used in place, like the
one `for each` walks, is freed when the statement ends.

Only an array that belongs to the function can be moved out. Returning a
parameter is refused with `TKO0840: 'a' is not a local array of this
procedure, so returning it would need a copy, which is not supported yet;
return a local array or a brace list`. To return a changed copy of a
parameter, build a local array from it and return that.

`dim r( ) as int32 = Squares( 3 )` is refused too
(`TKO0612: var-len array 'r' cannot be initialized`): use `var`, or declare
the array first and assign to it.

### Activities

1. Write `function Evens( byval n as int32 ) as int32( )` returning the first
   `n` even numbers, indexed from 1.
2. Write `function Doubled( values( ) as const int32 ) as int32( )` that
   returns a new array with every element doubled and the same bounds.
