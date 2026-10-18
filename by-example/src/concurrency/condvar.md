# Condition variables

A mutex stops two threads running the same code at once. A **condition
variable** lets a thread sleep until another thread tells it something has
changed, instead of checking over and over.

```tiko
{{#include ../../examples/concurrency/condvar.tiko}}
```

**Output**

```text
{{#include ../../examples/concurrency/condvar.out}}
```

The mailbox holds one item. The producer thread waits while it is full; the
main program waits while it is empty. Each side changes `full` with the mutex
held and then calls `condsignal`, which wakes a thread sleeping on `changed`.
The five items arrive in order because neither side can get ahead of the
other.

`condwait( cond, mutex )` does three things: it releases the mutex, sleeps
until it is signalled, and takes the mutex back before it returns. Releasing
the mutex is what lets the other thread change `full` in the meantime.

Always test the condition **in a loop**, as both `do while box->full` and
`do until box.full` do. A wake-up says only that something *may* have changed:
the thread can be woken with nothing to do, or find that another thread has
already taken what it was woken for.

| Call | Does |
|---|---|
| `condcreate( )`, `conddestroy( c )` | make and free a condition variable |
| `condwait( c, m )` | release `m`, sleep until signalled, retake `m` |
| `condsignal( c )` | wake one thread waiting on `c` |
| `condbroadcast( c )` | wake every thread waiting on `c` |

A [channel](channels.md) with a capacity of 1 does the same job as this
mailbox in a few lines. Reach for a condition variable when the condition is
more than "a value is waiting".

### Activities

1. Make the mailbox hold up to three items, with a count instead of `full`.
2. Start two consumer threads and use `condbroadcast` when the producer
   finishes.
