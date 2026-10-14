[Home](Home) › [All Categories](Categories) › **Nullptr**

# Nullptr

## The name

`nullptr` is the null pointer. tiko predeclares it as

```freebasic
const nullptr as any ptr = 0
```

so it is an `any ptr` whose value is 0. It assigns to, and compares with, every pointer type — typed, `zstring ptr`, procedure pointers, UDT pointers — with no warning, and `if p then` treats it as false.

```freebasic
type Node
    nxt as Node ptr
end type

dim as Node ptr head = nullptr
dim as zstring ptr name_ = nullptr
dim as sub( ) callback = nullptr
if head = nullptr then print "empty list"
```

## Why it exists

`0` is an integer. Where the target is already a pointer that makes no difference, but where the compiler has to *choose* a type it chooses `integer`:

| Code | With `0` | With `nullptr` |
|---|---|---|
| `F( x )`, overloads `F( integer )` and `F( any ptr )` | calls `F( integer )` | calls `F( any ptr )` |
| `var p = x` | `p` is an `integer` | `p` is an `any ptr` |
| `Echo( x )`, `function Echo( of T )( byval v as T ) as T` | `T` is `integer` | `T` is `any ptr` |

C++11 and C23 added `nullptr` for the same reason.

## Two pointer overloads

`nullptr` converts to every pointer type equally, so a call that could take it as either of two pointer types is ambiguous, as it is in C++:

```freebasic
sub G overload ( byval a as long ptr )
end sub
sub G overload ( byval a as zstring ptr )
end sub

G( nullptr )                        '' TKO0660, with a note naming the fix
G( cptr( zstring ptr, nullptr ) )   '' the fix
```

## Not a keyword

`nullptr` is a constant, not a reserved word, for the same reason the [fixed-width type names](Category-Fixed-Width-Types) are typedefs: programs may use the name for their own declarations. Whatever a program declares called `nullptr` — a field, a namespace member, a local, a parameter, a `for` counter, a module-level variable — replaces tiko's there, with no diagnostic.

`0` keeps its meanings alongside it: `p = 0` and `if p = 0` are legal and silent.

## Into an integer

Storing `nullptr` — or any pointer — into a pointer-sized integer is warning `TKO0968`:

```freebasic
dim as integer n = nullptr          '' TKO0968: implicit conversion
dim as integer m = cast( integer, nullptr )   '' silent
```
