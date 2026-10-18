# Virtual destructors

An object created with `new` and deleted through a pointer to its base type
is destroyed by whichever destructor that pointer's type names, unless the
destructor is virtual. When the derived type is the one holding the
resource, that is the difference between closing it and leaking it.

```tiko
{{#include ../../examples/inheritance/destructors.tiko}}
```

**Output**

```text
{{#include ../../examples/inheritance/destructors.out}}
```

`delete p` ran `~Plain` and nothing else. `PlainSocket`'s destructor, the one
that closes the socket, never ran, and nothing reported it: the program
compiled and ran cleanly.

`Connection` declares `virtual destructor( )`, so `delete c` looks the
destructor up in the object's table. It finds `TlsSocket`'s, runs it, and
then runs each base's in turn, from the most derived to `Connection` itself.

```admonish danger title="Pitfall"
**`virtual` on a destructor is not inherited by a level that does not say
it.** `Socket` repeats `declare virtual destructor( )`. Declared as a plain
`destructor( )` there instead, `delete c` runs only `~Socket` and
`~Connection`, and `~TlsSocket` is skipped. Leaving `Socket` with no
destructor at all is no better: the one the compiler writes for it is not
virtual either, and only `~Connection` runs. Every level that may be deleted
through a base pointer declares `virtual destructor( )`, even an empty one.
```

Objects in a scope, or passed `byref`, are destroyed by their own type and
are not affected: the rule matters only for `delete` through a pointer to a
base. `new` and `delete` themselves are covered in
[Memory and Resources](../memory/index.md).

### Activities

1. Change `Socket`'s destructor to a plain `declare destructor( )` and
   check the output against the pitfall above.
2. Make `Plain`'s destructor virtual. What else has to change for that to
   compile?
