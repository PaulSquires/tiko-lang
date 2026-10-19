[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **Context**

# Context

Holds the background context, which is never cancelled and is the root of all others.

## Syntax

```freebasic
Context( )
```

## Notes

- the background context; never cancelled

## Examples

```freebasic
#import "std/tasks"
using tasks

'' The background context: never cancelled, and the root every other
'' context descends from
dim ctx as Context

print ctx.IsCancelled( )     '' false
print "[" & ctx.Err( ) & "]" '' [] -- empty while it is still live

'' NOTHING IS EVER KILLED. Cancellation is a request a goroutine
'' notices, or does not. TerminateThread would skip destructors and
'' DEFER blocks and leak every mutex the thread held -- in a language
'' with DEFER, forced termination misses exactly the cleanup that was
'' written to be unmissable.
```

---

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Context
