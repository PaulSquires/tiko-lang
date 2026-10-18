# defer for cleanup

A procedure with three `return`s after its `allocate` needs three
`deallocate`s, and the fourth `return` someone adds later leaks. `defer`
writes the release once, on the line after the allocation, and runs it on
every way out of the block. The statement itself is introduced in
[defer](../flow/defer.md); this page shows it paired with memory.

```tiko
{{#include ../../examples/memory/deferfree.tiko}}
```

**Output**

```text
{{#include ../../examples/memory/deferfree.out}}
```

`Release` frees the block and prints `freed`, so the output shows when the
deferred call runs.

- With `n = 0` the function returns before the `allocate`, and before the
  `defer` line is reached, so nothing is freed: a `defer` only takes effect
  once the program has passed it.
- With `n = 3` the function reaches its last `return`, and the block is freed
  on the way out.
- With `n = 2000` it leaves early through `return -2`, and the block is freed
  all the same.

Three habits make this reliable:

- **Write the `defer` on the line after the `allocate`**, before the check for
  null. `deallocate( nullptr )` does nothing, so the failure path is covered
  too, and the pair cannot drift apart.
- **The deferred statement reads its variables when it runs**, at the end of
  the block, not when the `defer` line is reached. If a `reallocate` stores a
  new address in `squares`, the right block is still freed.
- **Allocate and defer in the procedure's own body**, not inside an `if`. A
  `defer` runs at the end of the block it is written in, so inside an `if` it
  frees the memory at `end if`.

`defer` suits a resource used in one procedure. When the same kind of
resource is acquired in many places, a [type with a destructor](noncopy.md)
puts the release where it cannot be forgotten.

### Activities

1. Add a second scratch buffer to `SumOfSquares` with its own `defer`. In
   which order are the two freed?
2. Move the `allocate` and its `defer` inside an `if n > 0 then ... end if`
   block. Where does `freed` appear now?
