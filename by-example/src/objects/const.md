# Const methods

A procedure that takes an object `byref as const` promises not to change it.
That promise is only useful if the compiler can tell which of the object's
methods keep it, and a `const` method is one that does.

```tiko
{{#include ../../examples/objects/const.tiko}}
```

**Output**

```text
{{#include ../../examples/objects/const.out}}
```

`declare const function Area( )` marks `Area` as a method that reads the
object but never writes it, and the definition repeats the word:
`const function Rect.Area( )`. Inside, the compiler holds the method to its
promise: assigning a field `w` is refused with `TKO0664: 'w' cannot be
written from a const method`, and calling `Scale` from it with `TKO0665: a
const method cannot call the non-const method 'scale'`.

`Report` takes its rectangle `byref as const`, so it receives the caller's
object without a copy and may not change it. It may call `Describe` and
`Area`, which are `const`. Calling `Scale` is refused:

```tiko
{{#include ../../examples/objects/constcall.tiko}}
```

```text
constcall.tiko(19,6): error TKO0935: 'scale' is not a const method, so a const object cannot call it
     |
  19 |     r.Scale( 2 )                    '' refused: Scale is not
     |      ^
```

Mark every method that only reads as `const`. A method left unmarked cannot
be called on a `const` object at all, even though it changes nothing, and
every procedure that takes the type `byref as const` loses it.

### Activities

1. Remove `const` from `Describe` and read the error. Which call does the
   compiler point at?
2. Add a `const function IsSquare( ) as boolean` and call it from `Report`.
