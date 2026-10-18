# Recursion

A procedure may call itself. Each call gets its own parameters and locals, so
the calls in progress do not disturb one another. A recursive procedure needs
a **base case** that answers without calling itself, and every other call must
move towards it:

```tiko
{{#include ../../examples/procedures/recursion.tiko}}
```

**Output**

```text
{{#include ../../examples/procedures/recursion.out}}
```

`Factorial( 5 )` calls `Factorial( 4 )`, and so on down to `Factorial( 1 )`,
which returns 1; the multiplications then happen as the calls return.
`Countdown` prints on the way down and stops at 0.

`IsEven` and `IsOdd` call each other. The compiler reads a file from top to
bottom, so when it reaches `IsEven` it has not yet seen `IsOdd`. The `declare`
line states `IsOdd`'s signature in advance; without it the call is
`TKO0743: 'isodd' is not declared`. The body can then come later.

Every call uses some stack, and a recursion that is very deep, or that never
reaches its base case, runs out of it. For a simple count, a loop does the
same work with none of that cost.

### Activities

1. Write a recursive `Fib( n )` and print the first ten Fibonacci numbers.
2. Change `Countdown` to print `liftoff` first and the numbers after it, by
   moving one line.
