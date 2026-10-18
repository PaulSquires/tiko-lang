# Mutexes

When two threads change the same variable, updates get lost.
`acct->balance += 1` is three steps (read, add, write back), and two threads
can both read the same value, both add one, and both write it: two deposits,
one recorded. A **mutex** makes a section of code run in one thread at a time.

```tiko
{{#include ../../examples/concurrency/mutex.tiko}}
```

**Output**

```text
{{#include ../../examples/concurrency/mutex.out}}
```

Four tellers each deposit 1 a hundred thousand times, and the balance is
exactly 400000. Between `mutexlock` and `mutexunlock` only one thread runs, so
each `+= 1` happens whole. Without those two lines the balance comes out short,
by a different amount on each run, and nothing reports an error.

| Call | Does |
|---|---|
| `mutexcreate( )` | makes a mutex and returns its handle, an `any ptr` |
| `mutexlock( m )` | waits until no other thread holds `m`, then holds it |
| `mutexunlock( m )` | lets the next waiting thread in |
| `mutexdestroy( m )` | frees it, once no thread can use it any more |

Keep the lock and the data it protects together, as `Account` does, so every
procedure that can reach the data can reach its lock. Hold a mutex for as
little code as you can: while one thread holds it, the others wait, and four
threads taking turns on one lock run no faster than one.

Every `mutexlock` needs its `mutexunlock` on every path out, including an
early `exit` or `return`. A thread that leaves while holding the lock makes
every other thread wait for ever.

### Activities

1. Remove the `mutexlock` and `mutexunlock` lines and run the program a few
   times.
2. Move the lock outside the loop, so each teller holds it for all its
   deposits. Is the result still right? What did the threads gain?
