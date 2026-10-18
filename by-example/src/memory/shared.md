# Shared pointers

Sometimes one object has several owners, and none of them knows when the
others have finished with it. `SharedPtr( of T )`, from the `std/memory`
module, keeps a *count of owners*: each copy adds one, each copy that goes
away subtracts one, and the object is destroyed when the count reaches zero.

```tiko
{{#include ../../examples/memory/shared.tiko}}
```

**Output**

```text
{{#include ../../examples/memory/shared.out}}
```

| Procedure or member | Does |
|---|---|
| `memory.MakeShared( of T )( )` | a new `T` on the heap, owned by the returned pointer |
| `memory.SharedPtr( of T )( p )` | adopt an object made with `new`; never `delete` it yourself |
| `p->field`, `*p` | the object, as through a raw pointer, with no check for null |
| `p.Ref( )` | the object, checked: runtime error 1 on an empty pointer |
| `p.UseCount( )` | how many `SharedPtr`s own the object |
| `p.Reset( )` | stop owning; the object goes if this was the last owner |
| `p.IsNull( )` | whether this pointer owns nothing |

`var t = s` makes a second owner, and the count is 2 inside the `scope`. When
`t` goes, the count drops back to 1 and the session stays. `s.Reset( )` lets
go of the last owner, and the destructor runs at that moment.

`Show` takes its pointer `byref`, so calling it makes no new owner. Pass a
`SharedPtr` `byval` only when the procedure keeps a copy that outlives the
call.

### Cycles, and WeakPtr

Counting owners has one failure it cannot detect: two objects that own each
other. A `WeakPtr( of T )` observes an object without owning it, and is the
tool for every link that points back.

```tiko
{{#include ../../examples/memory/weak.tiko}}
```

**Output**

```text
{{#include ../../examples/memory/weak.out}}
```

In the first tree the root owns the child and the child owns the root. When
the scope ends, the two local pointers let go, but each node still has one
owner, the other node, so neither count reaches zero and neither destructor
runs. The memory is lost for the rest of the program, and nothing reports it.

In the second tree the link back is a `WeakPtr`. It does not count, so when
`root` goes the root's count reaches zero, the root is freed, its `child`
pointer goes with it, and the child follows.

A `WeakPtr` is read through `Lock( )`, which returns a real `SharedPtr`, an
owner for as long as you hold it, or an empty one if the object has gone.
That is why `root owners` is 2 while `up` exists. **Ownership flows one way**:
make every link from owner to owned a `SharedPtr`, and every link back a
`WeakPtr`.

```admonish note
`std/memory` has no single-owner smart pointer. For an object used inside one
procedure, a [destructor](raii.md) or [defer](defer.md) does that job.
```

### Activities

1. Print `root.UseCount( )` after `up.Reset( )`.
2. In `weak.tiko`, make the root's `child` the weak link and `parent` the
   owning one. What is freed, and when?
