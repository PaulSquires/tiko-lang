# Dynamic arrays

When the number of elements is not known until the program runs, declare the
array without bounds and give it some later with `redim`:

```tiko
{{#include ../../examples/arrays/dynamic.tiko}}
```

**Output**

```text
{{#include ../../examples/arrays/dynamic.out}}
```

`dim values( any ) as int32` and `dim as int32 values( )` both declare an
empty dynamic array. `any` stands for bounds that come later, and with
`( any, any )` it says how many dimensions they will have.

| Statement | Effect |
|---|---|
| `redim a( 1 to 3 )` | new bounds; **every element is zero again** |
| `redim preserve a( 1 to 5 )` | new bounds; elements that still fit keep their values |
| `erase a` | frees the elements; the array is empty again |

```admonish danger title="Pitfall"
`redim` without `preserve` is not a resize. It makes a fresh array under the
same name, so `redim values( 1 to 4 )` turns `10 20` into `0 0 0 0`. Use
`redim preserve` unless you mean to start over.
```

The last loop grows the array one element at a time, starting from empty:
`ubound( values ) + 1` is 0 the first time, so the first element lands at
index 0. That builds a list of any length, but each `redim preserve` may
copy every element, so for long lists the
[containers](../containers/index.md) of the standard library are the better
tool.

`erase` on a fixed array cannot free anything. It sets the elements back to
zero and the bounds stay as they were.

### Activities

1. Read numbers into a dynamic array until one is negative, with the values
   coming from a fixed array instead of the keyboard.
2. Change `redim preserve values( 1 to 2 )` to plain `redim` and predict the
   line that follows.
