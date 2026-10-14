[Home](Home) › [Goroutines and Channels](Category-Goroutines-and-Channels) › [Goroutines and Channels](Category-Goroutines-and-Channels) › **Spawn**

# Spawn

Runs a procedure concurrently on the scheduler's worker pool.

## Syntax

```freebasic
spawn Procedure( [ args ] )
```

## Notes

- A **statement, not a function** -- `spawn Worker( a, b )` is compiler syntax, and its arguments are **copied at the spawn point**, so a loop variable does not race with the goroutine that captured it.
- It returns nothing and there is no handle: a goroutine is not joinable. Use a `WaitGroup` to wait for a fan-out, or a channel to collect results.
- The work runs on a pool of OS threads, so a goroutine that blocks in a syscall occupies a worker for the duration.
- Requires `-mt`.

## Examples

```freebasic
#import "std/tasks"
using tasks

'' THE SHAPE, with the Add BEFORE the spawn -- never inside the
'' goroutine, or Wait can see zero and return before the worker starts:
''
''     dim wg as WaitGroup
''     for i as long = 1 to 4
''         wg.Add( )
''         spawn Worker( i, @wg )   '' Worker does `defer wg->Done( )`
''     next
''     wg.Wait( )
''
'' Note that every Add MUST be matched by a Done, or Wait never returns.
dim wg as WaitGroup
print wg.Count( )            '' 0 -- nothing outstanding
wg.Wait( )                   '' so this returns at once
print "all done"

'' The arguments are COPIED at the spawn point, which is what makes
'' `spawn Work( i )` inside a loop safe
```

---

**Library:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Category:** [Goroutines and Channels](Category-Goroutines-and-Channels)  
**Documented under:** Members
