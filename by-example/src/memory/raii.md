# Destructors and scope

A type with a destructor cleans up after itself: the destructor runs when the
object's block ends, however the block is left. Tie a resource to an object,
acquiring it in the constructor and releasing it in the destructor, and the
release happens without any code at the places the block ends.

```tiko
{{#include ../../examples/memory/raii.tiko}}
```

**Output**

```text
{{#include ../../examples/memory/raii.out}}
```

Three rules are visible in that output:

- **Objects are destroyed in reverse order of construction.** `c` was made
  last and closes first, then `b`, then `a`. Something made later may depend
  on something made earlier, never the other way round, so this order is
  always safe.
- **Every block counts.** `inner` lives in a `scope ... end scope` block and
  closes at `end scope`, while `Work` is still running.
- **Every way out counts.** `exit sub` in the second call leaves before `c`
  exists, and `b` and `a` still close, in the same reverse order. The same
  holds for `return` and `exit for`.

The order is the order you wrote things in, reversed. Nothing depends on a
collector, a timer or where objects happen to be in memory.

The one exception is a runtime error that jumps out of a procedure to a
handler further out, which skips that procedure's destructors; see
[Error numbers and handlers](../errors/handlers.md). Destructors themselves
are introduced in [Objects](../objects/destructors.md).

### Activities

1. Add `dim d as Resource = Resource( "d" )` inside the `if` block, before
   `exit sub`. When does `d` close?
2. Put the three `dim` lines inside a `for` loop that runs twice. What is
   opened and closed on each pass?
