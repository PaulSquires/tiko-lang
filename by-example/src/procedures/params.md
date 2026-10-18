# Parameters

Each parameter is passed one of two ways. `byval` gives the procedure its own
copy, so changes stay inside. `byref` gives it the caller's variable, so
changes are seen by the caller. That is also how a procedure reports more than
one result.

```tiko
{{#include ../../examples/procedures/params.tiko}}
```

**Output**

```text
{{#include ../../examples/procedures/params.out}}
```

`AddTax` scales its copy of `price`, so the caller's `price` is still 8, and
adds into the caller's `total` twice, which ends at 20.

A parameter written with neither keyword gets a default, and the default
depends on the type:

| Parameter type | Passed, when no keyword is written |
|---|---|
| numbers, `boolean`, enums, pointers | `byval`: a copy |
| `ustring` | `byref`: the caller's variable |
| your own types and tuples | `byref`: the caller's variable |
| arrays | always by reference (see [Passing arrays](../arrays/passing.md)) |

```admonish danger title="Pitfall"
The three `NoKeyword` subs are written the same way and behave differently:
the `int32` is copied, but the `ustring` and the `Point` are the caller's
own, so the caller sees `changed` and 99. A procedure that uses a `ustring`
parameter as scratch space quietly changes its caller's text. Write `byval`
or `byref` on every parameter, as the other examples in this section do.
```

A `byref` parameter still accepts a literal or an expression in place of a
variable. tiko passes a temporary that holds the value, and the procedure's
writes go to the temporary.

`byref ... as const` passes the caller's variable without copying it, and
refuses any write to it. It suits a large value or a `ustring` that the
procedure only reads, like `Initials`. A write is a compile error:

```tiko
{{#include ../../examples/procedures/constparam.tiko}}
```

```text
constparam.tiko(3,5): error TKO0617: cannot modify 'text': it is a constant
```

### Activities

1. Write `sub Swap2( byref a as int32, byref b as int32 )` that exchanges two
   values, then change one parameter to `byval` and watch it stop working.
2. Change `NoKeywordText` to take `byval s as ustring` and check the output.
