[Home](Home) › [Interfaces](Category-Interfaces) › **Inherits**

# Inherits

Names a class's base class, or the interfaces an interface includes.

## Syntax

```freebasic
class name
    inherits base_class
    ...
end class

interface name
    inherits base_interface [ , base_interface ... ]
    ...
end interface
```

## Description

`inherits` is a line at the top of a [`Class`](Class) or [`Interface`](Interface) body. It comes before any member (TKO0435) and, in a class, before the `implements` lines.

**In a class** it names the one base class: a `class`, or a `type` that extends `object`. The class starts as a complete object of the base and adds to it, exactly as `type D extends B` does, and `base( … )` in a constructor chooses which base constructor runs. A class with no `inherits` line extends `object`. A second base is an error (TKO0427).

**In an interface** it names other interfaces, as many as needed, on one line or several. Their members become members of this interface, a type that implements it implements them too, and a value of it converts to any of them implicitly. An interface that reaches itself through its `inherits` lines is an error (TKO1008).

The example on the [`Class`](Class) page has a class inheriting a class; the one on the [`Interface`](Interface) page has an interface inheriting an interface.

## Remarks

- A `type` names its base with `extends` on its header; `inherits` in a `type` body is an error that says so (TKO0433). A class names its base with `inherits`; `extends` on a class's header is TKO0432.
- `inherits` is recognised only as the first word of a line in a class or interface body. Elsewhere it is an ordinary name.

### See also

- [`Class`](Class)
- [`Interface`](Interface)
- [`Implements`](Implements)
- [`Extends`](Extends)
- [`Base (Initializer)`](Base-Initializer)

---

**Category:** [Interfaces](Category-Interfaces)
**Kind:** keyword
