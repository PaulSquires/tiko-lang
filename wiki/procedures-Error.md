[Home](Home) › [Preprocessor](Category-Preprocessor) › **#error**

# #error

Preprocessor diagnostic directive

## Syntax

```freebasic
#error error_text
```

## Parameters

- `error_text`

## Description

`#error` interrupts compiling to display `error_text` when compiler finds it, and then parsing continues.

 This keyword must be surrounded by an `#if <condition>` ...[`#endif`](Endif), so the compiler can reach `#error` only if `<condition>` is met.

 In any case, the final status will be "Failed to compile".

## Remarks

### Differences from QB

- New to FreeBASIC

### See also

- [`#if`](If)
- [`#print`](freebasic-Print)
- [`#assert`](procedures-Assert)

## Examples

```freebasic
#define c 1

#if c = 1

  #error Bad value of c

#endif
```

---

**Category:** [Preprocessor](Category-Preprocessor)  
**Kind:** keyword

---

*Reproduced from the [FreeBASIC Wiki Manual](https://www.freebasic.net/wiki/) under the [GNU Free Documentation License 1.3](https://www.gnu.org/licenses/fdl-1.3.html) — with no Invariant Sections, no Front-Cover Texts and no Back-Cover Texts. Copyright © the FreeBASIC project and wiki contributors. See [License](License).*
