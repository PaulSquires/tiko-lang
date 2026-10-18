# for each

Most loops over an array do not need the index; they need each element.
`for each` hands you the elements in order and keeps the bounds out of sight:

```tiko
{{#include ../../examples/flow/foreach.tiko}}
```

**Output**

```text
{{#include ../../examples/flow/foreach.out}}
```

`for each p as ustring in planets` declares `p`, which exists only inside the
loop. With the type left out, as in `for each n in primes`, `n` takes the
element type of the array. The loop works the same whatever the array's
bounds, and an empty dynamic array runs the body zero times.

`exit for` and `continue for` behave as they do in a counting `for`.

The loop variable is a **copy** of the element. Writing to it does not change
the array; [for each over arrays](../arrays/foreach.md) shows `for each byref`,
which does. `for each` also walks the containers of the standard library,
which the [Containers](../containers/index.md) section covers.

A `ustring` cannot be walked this way:

```tiko
{{#include ../../examples/flow/foreachtext.tiko}}
```

```text
foreachtext.tiko(3,1): error TKO0688: 'for each' cannot walk a ustring; index it with 'for' and 'mid' instead
```

The last loop in the first example does what the message suggests: it counts
from 1 to `len( word )` and takes one character at a time with `mid`. The
[Strings](../strings/index.md) section has more on working with text.

### Activities

1. Print the planets in a single line, separated by commas.
2. Find the largest prime in `primes` with `for each`, without using an index.
