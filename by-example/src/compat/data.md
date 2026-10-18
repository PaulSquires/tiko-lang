# data, read and restore

Older BASIC code keeps tables inside the program with `data` statements, and
tiko still accepts them:

```tiko
{{#include ../../examples/compat/quiz-data.bas}}
```

**Output**

```text
{{#include ../../examples/compat/quiz-data.out}}
```

- **`data`** holds a list of constants, numbers and strings, anywhere in the
  file.
- **`read`** takes the next values from that list, in the order the `data`
  statements appear, converting each to the type of the variable it fills.
- **`restore`** moves the reading position: to the first `data` after a label,
  or with no label to the first `data` in the file.

Nothing checks that a `read` takes values of the types the `data` holds, or
that each record has as many fields as the code expects. One missing field
shifts every later `read` by one, and reading past the last item is not an
error, even with `-exx`: the variable gets `0` or an empty string.

Modern tiko code keeps the same table in an array of records:

```tiko
{{#include ../../examples/compat/quiz.tiko}}
```

**Output**

```text
{{#include ../../examples/compat/quiz.out}}
```

Every value goes through the constructor, so the compiler checks its type and
the number of values per record. The count comes from the array, so it cannot
disagree with the table. A table too large for the source belongs in a file
the program reads.

````admonish warning title="Status in this version"
The shorter form, with no constructors and each record written as a
parenthesised list,

```tiko
dim quiz( 1 to 3 ) as Question = { ( "Capital of France?", "Paris" ), … }
```

compiles, but the program crashes when it starts, because `Question` has
`ustring` fields. Until that is fixed, give a record with string fields a
constructor, as above.
````

### Activities

1. Remove one `"Paris"` from the `data` lines and predict what the program
   prints.
2. Add a fourth question to `quiz.tiko`. What else had to change?
