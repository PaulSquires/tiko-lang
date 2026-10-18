# Conditional compilation

`#if`, `#elseif`, `#else` and `#endif` choose which lines are compiled at all.
A line in a branch that is not taken is never compiled, so it costs nothing in
the program and may even name things that do not exist.

```tiko
{{#include ../../examples/preprocessor/conditional.tiko}}
```

**Output**

```text
{{#include ../../examples/preprocessor/conditional.out}}
```

| Directive | Keeps the lines that follow when |
|---|---|
| `#if expr` | the constant expression is not zero |
| `#elseif expr` | no earlier branch was taken and `expr` is not zero |
| `#else` | no earlier branch was taken |
| `#ifdef NAME` | `NAME` is defined |
| `#ifndef NAME` | `NAME` is not defined |
| `defined( NAME )` | inside `#if`: true when `NAME` is defined |

The expressions are worked out by the preprocessor, so they may use only
constants and defined names. `#if 0` … `#endif` is a quick way to switch off a
block of code without commenting out every line.

````admonish danger title="Pitfall"
**`#ifdef` asks whether a name is defined, not what it is.**

```tiko
{{#include ../../examples/preprocessor/ifdeftrap.tiko}}
```

```text
{{#include ../../examples/preprocessor/ifdeftrap.out}}
```

`TRACE` is defined, as `0`, so every `#ifdef TRACE` is true. Choose one
convention per switch: either it is defined or not, and you test it with
`#ifdef`, or it always has a value, and you test it with `#if`.
````

### Activities

1. Set `LOG_LEVEL` to `3`, then to `1`, and predict each output first.
2. Define `WITH_SOUND` and see which two lines change.
