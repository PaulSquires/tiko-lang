# Source information

The compiler knows the file, line and procedure of every statement, and a few
predefined names hand that knowledge to the program. They are what makes a
diagnostic message say *where*.

```tiko
{{#include ../../examples/preprocessor/sourceinfo.tiko}}
```

**Output**

```text
{{#include ../../examples/preprocessor/sourceinfo.out}}
```

| Name | Gives |
|---|---|
| `__FILE__` | the source file's name, as a string, spelled as it was given to the compiler |
| `__LINE__` | the line it is written on, as a number |
| `__FUNCTION__` | the enclosing procedure's name, as a string, in capitals |
| `__DATE_ISO__` | the build date as `"yyyy-mm-dd"` |

- **Inside a macro they expand where the macro is used.** `CHECK` is defined
  on line 12, but the message names line 17, the line inside `Average` that
  used it. That is how assertion and logging macros report the caller's
  position.
- **`#cond`** turns the macro's argument into text, so the message shows the
  condition as it was written.
- **`#line 1000 "generated.tiko"`** renumbers the source: the directive's own
  line becomes 1000, so the line after it is 1001, and `__FILE__` changes
  too. A program that writes tiko source for another uses it, so that errors
  point at the file a person edits. Compiler diagnostics follow `#line` as
  well.

`__FILE__` is the path exactly as it was passed to the compiler: built as
`tiko src/sourceinfo.tiko`, the program prints `src/sourceinfo.tiko`. Print
the date or time of a build only where a changing value is wanted; a program's
output that changes every day is hard to test.

### Activities

1. Add `CHECK( total >= 0 )` to `Average` and call it with a negative total.
2. Move the `#line` directive to the top of the file and predict every line
   number the program prints.
