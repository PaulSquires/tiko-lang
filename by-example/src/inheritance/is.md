# Runtime type checks

Code holding a base type sometimes needs something only one derived type
has. `is` asks, while the program runs, what an object really is.

```tiko
{{#include ../../examples/inheritance/is.tiko}}
```

**Output**

```text
{{#include ../../examples/inheritance/is.out}}
```

`m is TextMessage` is true when the object is a `TextMessage` **or anything
derived from one**, which is why the reply passes both the `TextMessage` and
the `Reply` tests. Once it is true, `cast( TextMessage ptr, @m )` views the
same object as a `TextMessage`, and its `text` field can be read.

The cast itself checks nothing. Cast to the wrong type and the program reads
whatever memory follows the base part, so always guard a cast like this with
`is`.

`is` reads the answer from the hidden table pointer, so the type must extend
`Object`, and it asks only about types derived from the variable's own type.
Both are checked when the program compiles:

| Asking | Refused with |
|---|---|
| `p is More`, where `p`'s type does not extend `Object` | `TKO0799: 'is' needs run-time type information, and 'plain' has none: it does not extend 'object'` |
| `t is TextMessage`, where `t` is already a `TextMessage` | `TKO0798: 'is textmessage' needs a type derived from 'textmessage', and 'textmessage' is not one` |

```admonish danger title="Pitfall"
A chain of `if m is TextMessage ... elseif m is Picture ...` is a `select
case` on the type, and it has to be edited every time a new kind of message
appears. When the question is "what should this object do", the answer is a
[virtual method](virtual.md), which each new type supplies for itself. Keep
`is` for the few places that truly need a derived type's own data.
```

### Activities

1. Add a `Voice` message with a `seconds` field and make `Show` print its
   length.
2. Replace the `is` tests with a virtual `Detail( )` method that each message
   type overrides. Which version is easier to extend?
