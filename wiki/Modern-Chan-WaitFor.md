[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **WaitFor**

# WaitFor

## Syntax

```freebasic
WaitFor( ms )
```

## Examples

```freebasic
#import "std/tasks"
using tasks

dim wg as WaitGroup

'' The bounded form: TRUE if the count reached zero, FALSE on timeout
print wg.WaitFor( 100 )      '' true -- nothing outstanding

wg.Add( )
print wg.WaitFor( 50 )       '' false -- still one outstanding after 50ms

'' ms = 0 IS A POLL, not an infinite wait -- the same rule as
'' Channel.SendFor( v, 0 ). Wait( ) is how "forever" is spelled.
print wg.WaitFor( 0 )        '' false, and it returns at once

'' A FALSE does not cancel anything and does not consume the work. It
'' is the whole reason the design has no forced termination: a caller
'' that gives up still has to decide what to do about the worker.
wg.Done( )
print wg.WaitFor( 0 )        '' true
```

---

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Waitgroup
