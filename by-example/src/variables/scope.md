# Scope and Shadowing

Every variable belongs to the block it is declared in, and lives until that
block ends. A block inside another may declare a name that already exists
outside; the inner one then hides, or *shadows*, the outer one until the
block ends.

```tiko
{{#include ../../examples/variables/scope.tiko}}
```

**Output**

```text
{{#include ../../examples/variables/scope.out}}
```

`scope ... end scope` opens a block whose only job is to limit names. Inside
it, `message` is a new `ustring` holding `"inner"`, and the innermost block
declares a third `message`, this time a `float64`. Each one disappears at its
`end scope`, and the outer `message` is untouched throughout: line 5 still
prints `outer`.

The body of every `if`, `for`, `do` and `select case` is a block in the same
way, so `doubled` exists only inside the loop. An *assignment* inside a
block, as in the `if`, has no `dim` and so declares nothing: it changes the
variable already in scope.

A name used after its block has ended is no longer declared:

```tiko
{{#include ../../examples/variables/outofscope.tiko}}
```

```text
outofscope.tiko(5,7): error TKO0743: 'temporary' is not declared
     |
   5 | print temporary     '' refused: temporary ended with its scope
     |       ^
```

Shadowing needs a new block. Declaring the same name twice in one block is
an error, and the note points at the first declaration:

```tiko
{{#include ../../examples/variables/redeclare.tiko}}
```

```text
redeclare.tiko(3,14): error TKO0600: 'total' is already declared in this scope
     |
   3 | dim as int32 total = 2      '' refused: same name, same scope
     |              ^
redeclare.tiko(1,14): note: declared here
     |
   1 | dim as int32 total = 1
     |              ^
```

### Activities

1. Inside the first `scope`, assign to `message` without `dim` before the
   inner declaration, and see which variable changes.
2. Move `dim as int32 doubled` above the `for` loop. What does the loop
   print, and what is `doubled` after it?
