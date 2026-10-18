# Slicing

A derived object can be passed wherever its base type is wanted. *How* it is
passed decides whether the procedure gets the object or only part of it.

```tiko
{{#include ../../examples/inheritance/slicing.tiko}}
```

**Output**

```text
{{#include ../../examples/inheritance/slicing.out}}
```

`ByReference` receives `rex` itself, so the virtual call reaches `Dog.Sound`
and `is Dog` is true.

`ByValue` receives a *new* `Animal`, built by copying the `Animal` part of
`rex`. That copy is an `Animal` through and through: it says `...`, it is not
a `Dog`, and `tricks` is not part of it at all. The derived part has been
sliced off. Assigning a `Dog` to an `Animal` variable does the same. A
pointer, like a `byref` parameter, refers to the whole object.

The last line shows the hidden field behind all of this. `Object` is 8
bytes: the pointer to the type's table of virtual methods, and nothing else.
`Animal` adds `legs` and rounds up to 16, and `Dog` adds `tricks` and rounds
up to 24.

```admonish danger title="Pitfall"
Nothing warns about slicing, because from the compiler's side nothing is
wrong: an `Animal` was asked for and an `Animal` was made. Pass objects of a
type with virtual methods `byref` or by pointer, never `byval`, and keep
them in `Animal ptr` variables rather than `Animal` ones.
```

### Activities

1. Change `ByValue` to take its parameter `byref` and compare the output.
2. Put `rex` in a `dim as Animal pets( 0 to 0 )` array and call `Sound` on
   the element. Then try an array of `Animal ptr`.
