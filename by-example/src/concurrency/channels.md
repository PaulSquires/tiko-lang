# Channels

A `tasks.Channel( of T )` is a typed queue that goroutines use to hand values
to one another. It is created with a **capacity**, the number of values it can
hold before a sender has to wait.

```tiko
{{#include ../../examples/concurrency/channels.tiko}}
```

**Output**

```text
{{#include ../../examples/concurrency/channels.out}}
```

| Operation | Does |
|---|---|
| `Send( v )` | waits until there is room, then queues `v` |
| `Receive( v )` | waits for a value; `false` once the channel is closed **and** empty |
| `TrySend( v )`, `TryReceive( v )` | never wait; `false` if they would have to |
| `SendFor( v, ms )`, `ReceiveFor( v, ms )` | wait at most `ms` milliseconds |
| `Close( )` | no more sends; values already queued can still be received |
| `for each v in ch` | receives until the channel is closed and drained |
| `Count( )`, `Capacity( )`, `IsClosed( )` | how things stand at this moment |

`Receive` returning `false` is not an error: it is how a receiver learns that
the sender has finished, and `for each` over a channel is built on it. The
variable keeps its old value when that happens. Sending on a closed channel
stops the program with runtime error 1: it means two parts of the program
disagree about who sends.

A channel is a **handle**. Copying one, or passing it to a procedure, gives
another handle to the same queue, which is how one channel is shared between
goroutines.

## Pipelines and channel directions

Channels join goroutines into a **pipeline**, each stage reading from one
channel and writing to the next:

```tiko
{{#include ../../examples/concurrency/pipeline.tiko}}
```

**Output**

```text
{{#include ../../examples/concurrency/pipeline.out}}
```

A capacity of **0** makes every send wait until a receiver takes the value: a
handover, with no buffer between the stages. `Generate` closes `numbers` when
it has sent everything; `KeepOdd` sees `Receive` return `false` and closes
`odds` in turn; and the main program's `for each` ends. The close travels down
the pipeline, and no stage needs to know how many values there are.

The parameter types say which end each stage holds. A `tasks.SendChan( of T )`
can send and close; a `tasks.RecvChan( of T )` can only receive. A `Channel`
converts to either when it is passed. Closing is the sender's decision, so a
receiving end that tries is refused:

```tiko
{{#include ../../examples/concurrency/recvclose.tiko}}
```

```text
recvclose.tiko(5,11): error TKO0739: 'recvchan' has no member named 'close'
```

### Activities

1. Add a third stage between `KeepOdd` and the main program that squares each
   value.
2. Give `numbers` a capacity of 4 instead of 0. The output does not change;
   what does?
