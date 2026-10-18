# Overriding

`override` marks a method that replaces a virtual one from the base, and asks
the compiler to check that there *is* one to replace. Whether types further
down can replace it again is decided by `virtual`.

```tiko
{{#include ../../examples/inheritance/override.tiko}}
```

**Output**

```text
{{#include ../../examples/inheritance/override.out}}
```

**An override is not virtual unless it says so.** `Cat.Sound` is declared
with `override` alone. It replaces `Animal.Sound`, and that is the end of the
line: `Kitten.Sound` can only *hide* it. Called on a `Kitten` directly it
answers `mew`, but through an `Animal` the call reaches `Cat.Sound`.

`Dog.Sound` is declared `virtual ... override`. It replaces `Animal.Sound` and
keeps the method open, so `Puppy.Sound` overrides it in turn and is reached
through an `Animal` as well.

| Declared as | Replaces an open virtual method of the base | Open to the next level down |
|---|---|---|
| `virtual` | yes, if there is one | yes |
| `override` | yes, and it is an error if there is none | no |
| `virtual ... override` | yes, and it is an error if there is none | yes |
| neither | yes, if there is one | no |

A method with the same name and parameters as an open virtual method
replaces it whether or not it says `override`. What the keyword adds is the
check: writing `override` where nothing virtual is left to replace is an
error, so a misspelt name, or a base method that is not virtual, is caught
when the program compiles instead of quietly hiding.

```tiko
{{#include ../../examples/inheritance/overrideerror.tiko}}
```

```text
overrideerror.tiko(19,13): error TKO0621: 'sound' is marked 'override' but overrides no virtual method
     |
  19 |     declare function Sound( ) as ustring override
     |             ^
```

The fix is one word in `Cat`: `declare virtual function Sound( ) as ustring
override`. When you write a type that others will extend, write `virtual`
with every `override` that they may need to replace.

### Activities

1. Change `Cat.Sound` to `virtual ... override` and check what `Speak( kit )`
   prints now.
2. Misspell `Sound` as `Sund` in `Puppy`, keeping `override`, and read the
   error.
