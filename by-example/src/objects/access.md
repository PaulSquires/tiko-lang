# Access control

A type that keeps rules about its data, such as "a balance never goes
negative", can only keep them if nothing else can write that data. Access
sections let a type decide which of its members the rest of the program may
touch.

```tiko
{{#include ../../examples/objects/access.tiko}}
```

**Output**

```text
{{#include ../../examples/objects/access.out}}
```

Inside a type, a label starts a section that runs to the next label:

| Label | Members reachable from |
|---|---|
| `public:` | anywhere; this is the default before any label |
| `private:` | the type's own methods, constructors and operators only |
| `protected:` | the type's own methods and those of types derived from it |

The private section of `Account` holds the balance, an entry counter and
`Record`, a helper method. Every change to the balance goes through
`Deposit` or `Withdraw`, which refuse what the account does not allow, so the
balance cannot go wrong from outside. Reaching for the field directly is a
compile error:

```tiko
{{#include ../../examples/objects/accesserror.tiko}}
```

```text
accesserror.tiko(12,5): error TKO0625: 'balance_' is not accessible here
     |
  12 | acct.balance_ = 1000000             '' refused: balance_ is private
     |     ^
```

A global operator, such as an `operator =` written for the type, is not a
method, so it sees only the public members too; build it from the type's
public methods. `protected:` matters once types extend one another, in
[Inheritance](../inheritance/index.md).

The trailing underscore on `balance_` is a naming habit, not syntax. It marks
the data the methods look after and leaves the plain name free for a method
or [property](properties.md) that exposes it.

```admonish warning title="Status in this version"
A type with a private constructor and a public `static` function that
creates it is the usual way to insist that objects are made only through
that function. In this version `var acct = Account.Open( 100 )` is refused
with `TKO0633` as soon as the type has any private constructor, so that
pattern cannot be used yet.
```

### Activities

1. Add a public `Entries( )` function that returns how many entries
   `Record` has made.
2. Move `Deposit` into the private section and read the error for
   `acct.Deposit( 50 )`.
