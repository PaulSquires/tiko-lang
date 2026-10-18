# Static members

Some data belongs to the type rather than to any one object: a count of how
many have been made, a shared table, a setting. A `static` member exists
once, however many objects there are, including none.

```tiko
{{#include ../../examples/objects/static.tiko}}
```

**Output**

```text
{{#include ../../examples/objects/static.out}}
```

**A static field** is declared in the type with `static` and shared by every
`Ticket`. Each constructor call increments the same `issued_`, while each
ticket keeps its own `number_`. The line outside the type,
`dim as int32 Ticket.issued_ = 100`, gives the shared field its starting
value; without it, the field starts at 0.

**A static method** has no object, so it has no `this` and cannot use
`number_` or any other per-object field; it is called on the type,
`Ticket.Issued( )`. That is why it can answer before any ticket exists.
Reaching for a per-object field from one is refused with
`TKO0937: 'number_' needs an object, and 'issued' has none: it is a static
member`.

Static members follow the same [access](access.md) rules as any other:
`issued_` is private, so only `Ticket`'s own code can change it, and the
outside world reads it through `Issued( )`.

A static field takes no room in an object: it is stored once, apart from
them all.

### Activities

1. Add a static `Peak( )` that reports the highest number ever issued, even
   after a `Reset`.
2. Try to print `Ticket.issued_` from outside the type, then move it to the
   public section and try again.
