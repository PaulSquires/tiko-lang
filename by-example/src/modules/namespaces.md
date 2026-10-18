# Namespaces

A module keeps names apart between directories. Inside one file, a
**namespace** does the same job: it gives a group of names a family name, so
two parts of a program can each have an `Area`.

```tiko
{{#include ../../examples/modules/namespaces.tiko}}
```

**Output**

```text
{{#include ../../examples/modules/namespaces.out}}
```

- **Outside the namespace, a member is written qualified**: `Metric.Area`,
  `Imperial.Area`. Inside it, the bare name is enough.
- **Namespaces nest**, and the full path is written out:
  `Metric.Convert.ToInches`.
- **A namespace can be reopened.** The second `namespace Metric` block adds
  `Perimeter` to the same namespace.
- **`using Metric`** inside `Report` makes the members usable bare until the
  end of `Report`. Written at the top level, it lasts to the end of the file.

A name declared closer to where it is used always beats one that `using`
brings in, so adding a `using` never changes the meaning of a name you already
had.

Use a module for code that other files or programs share; a module is already
a namespace, with visibility rules on top. Use `namespace` to group names
within a file, or in a header that must stay a header.

### Activities

1. Add `Imperial.Perimeter` and call both `Perimeter`s.
2. Put `using Metric` and `using Imperial` in one `sub` and call `Area`
   bare. What does the compiler say?
