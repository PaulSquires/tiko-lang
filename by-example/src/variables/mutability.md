# Mutability

Variables in tiko can be changed unless you say otherwise. Saying otherwise
is worth doing: a value that cannot change is one less thing to keep track of
when you read the code later.

```tiko
{{#include ../../examples/variables/mutability.tiko}}
```

**Output**

```text
{{#include ../../examples/variables/mutability.out}}
```

There are two ways to fix a value:

| Declaration | Value known | Use it for |
|---|---|---|
| `const MaxScore = 100` | when compiling | fixed settings, array bounds |
| `dim as const int32 lives = StartingLives( )` | when the line runs | a result that must not change afterwards |

`snapshot` shows the second kind copying a variable at one moment: `score`
changes afterwards, and `snapshot` keeps the old value.

A parameter declared `byref value as const int32` receives the caller's own
variable, without a copy, but the procedure may only read it. Without
`const`, a `byref` parameter writes straight through to the caller, which is
how `Bump` changes `score`. Writing to a `const` parameter is refused in the
same way as writing to a `const` variable.

Any attempt to change a constant is a compile error:

```tiko
{{#include ../../examples/variables/assignconst.tiko}}
```

```text
assignconst.tiko(3,1): error TKO0617: cannot modify 'lives': it is a constant
     |
   3 | lives -= 1      '' refused: lives is const
     | ^
```

### Activities

1. Add `dim as const ustring player = "Ada"` and try to append to it.
2. Write a `sub` that takes a `byref ... as const` record and prints a field.
   Then try to change the field inside it.
